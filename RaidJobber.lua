local ADDON_NAME = ...

local RJ = CreateFrame("Frame")
RaidJobber = RJ

local DEFAULT_DB = {
    raids = {},
    jobs = {},
    overrides = {},
    testMode = false,
    minimap = {
        angle = 225,
        hide = false,
    },
}

local ROLE_BY_CLASS = {
    DRUID = "Hybrid",
    HUNTER = "Ranged",
    MAGE = "Ranged",
    PALADIN = "Hybrid",
    PRIEST = "Healer",
    ROGUE = "Melee",
    SHAMAN = "Hybrid",
    WARLOCK = "Ranged",
    WARRIOR = "Melee",
}

local TANK_LIKE_CLASSES = {
    DRUID = true,
    PALADIN = true,
    WARRIOR = true,
}

local CLASS_DISPLAY = {
    DRUID = "Druid",
    HUNTER = "Hunter",
    MAGE = "Mage",
    PALADIN = "Paladin",
    PRIEST = "Priest",
    ROGUE = "Rogue",
    SHAMAN = "Shaman",
    WARLOCK = "Warlock",
    WARRIOR = "Warrior",
}

local RAID_MARKERS = {
    star = 1,
    circle = 2,
    diamond = 3,
    triangle = 4,
    moon = 5,
    square = 6,
    cross = 7,
    x = 7,
    skull = 8,
}

local GetRaidSize
local RefreshUI

local function Print(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff66ccffRaidJobber|r: " .. tostring(message))
end

local function EnsureDB()
    if type(RaidJobberDB) ~= "table" then
        RaidJobberDB = {}
    end

    for key, value in pairs(DEFAULT_DB) do
        if type(value) == "table" then
            if type(RaidJobberDB[key]) ~= "table" then
                RaidJobberDB[key] = {}
            end
        elseif RaidJobberDB[key] == nil then
            RaidJobberDB[key] = value
        end
    end

    RaidJobberDB.minimap.angle = RaidJobberDB.minimap.angle or DEFAULT_DB.minimap.angle
    RaidJobberDB.minimap.hide = RaidJobberDB.minimap.hide or false
end

local function Trim(value)
    if not value then
        return ""
    end

    return string.gsub(value, "^%s*(.-)%s*$", "%1")
end

local function GetInstanceKey()
    if RaidJobberDB and RaidJobberDB.testMode then
        return "Serpentshrine Cavern"
    end

    local name = GetInstanceInfo()
    if not name or name == "" then
        return "Unknown Instance"
    end

    return name
end

local function GetProfileBossKey(bossName)
    local normalized = string.lower(Trim(bossName))
    if normalized == "" then
        return nil
    end

    for _, profile in pairs(RaidJobberProfiles or {}) do
        for _, boss in ipairs(profile.bosses or {}) do
            if string.lower(boss.name or "") == normalized then
                return boss.name
            end

            for _, alias in ipairs(boss.aliases or {}) do
                if string.lower(alias) == normalized then
                    return boss.name
                end
            end
        end
    end
end

local function GetBossKey(bossName)
    bossName = Trim(bossName)
    if bossName == "" then
        bossName = "General"
    end

    return GetProfileBossKey(bossName) or bossName
end

local function GetProfile(profileName)
    profileName = string.lower(Trim(profileName))

    if profileName == "" then
        return nil
    end

    for key, profile in pairs(RaidJobberProfiles or {}) do
        if key == profileName or string.lower(profile.name or "") == profileName then
            return profile, key
        end

        if profile.aliases and profile.aliases[profileName] then
            return profile, key
        end
    end
end

local function GetProfileForBoss(bossName)
    local bossKey = GetBossKey(bossName)

    for key, profile in pairs(RaidJobberProfiles or {}) do
        for _, boss in ipairs(profile.bosses or {}) do
            if boss.name == bossKey then
                return profile, key
            end
        end
    end
end

local function StoreProfileJob(instanceKey, bossName, job)
    RaidJobberDB.jobs[instanceKey] = RaidJobberDB.jobs[instanceKey] or {}
    RaidJobberDB.jobs[instanceKey][bossName] = RaidJobberDB.jobs[instanceKey][bossName] or {}
    RaidJobberDB.jobs[instanceKey][bossName]["[" .. job.slot .. "]"] = job.role .. ": " .. job.text
end

local function GetCurrentRaid()
    local instanceKey = GetInstanceKey()
    return RaidJobberDB.raids[instanceKey]
end

local function GetMemberOverride(playerName)
    playerName = string.lower(playerName or "")

    return RaidJobberDB.overrides[playerName] or RaidJobberDB.overrides[string.gsub(playerName, "%-.*$", "")]
end

local function GetMemberLabel(playerName, member)
    local override = GetMemberOverride(playerName)
    if override and override ~= "" then
        return override
    end

    return (member.role or "Unknown") .. " " .. (CLASS_DISPLAY[member.class] or member.class or "")
end

local function GetPlayerGuildName()
    local guildName = GetGuildInfo and GetGuildInfo("player")
    return guildName
end

local function IsSameGuildMember(member)
    local playerGuild = GetPlayerGuildName()
    return playerGuild and playerGuild ~= "" and member and member.guild == playerGuild
end

local function TextHasAny(text, values)
    text = string.lower(text or "")

    for _, value in ipairs(values or {}) do
        value = string.lower(value or "")
        if value ~= "" and string.find(text, value, 1, true) then
            return true
        end
    end

    return false
end

local function ScoreCandidate(job, playerName, member, usedPlayers)
    if usedPlayers[playerName] then
        return -1000
    end

    local class = member.class or ""
    local role = string.lower(member.role or "")
    local label = string.lower(GetMemberLabel(playerName, member))
    local jobRole = string.lower(job.role or "")
    local jobText = string.lower((job.slot or "") .. " " .. (job.text or ""))
    local score = 0

    if IsSameGuildMember(member) then
        score = score + 12
    end

    if TextHasAny(label, { jobRole }) then
        score = score + 20
    end

    if jobRole == "tank" then
        if TANK_LIKE_CLASSES[class] then
            score = score + 35
        end
        if TextHasAny(label, { "tank", "protection", "feral" }) then
            score = score + 30
        end
    elseif jobRole == "healer" then
        if TextHasAny(label, { "healer", "holy", "resto", "restoration", "discipline" }) then
            score = score + 35
        end
        if class == "PRIEST" or class == "PALADIN" or class == "SHAMAN" or class == "DRUID" then
            score = score + 15
        end
    elseif jobRole == "ranged" then
        if class == "HUNTER" or class == "MAGE" or class == "WARLOCK" then
            score = score + 25
        end
    elseif jobRole == "melee" then
        if class == "ROGUE" or class == "WARRIOR" then
            score = score + 25
        end
    elseif jobRole == "dps" then
        if role ~= "healer" and not TextHasAny(label, { "healer", "holy", "resto", "restoration" }) then
            score = score + 15
        end
    else
        score = score + 5
    end

    if TextHasAny(jobText, { "tank healer", "main tank healer", "boss tank healer" }) then
        if class == "PALADIN" and TextHasAny(label, { "holy", "healer" }) then
            score = score + 60
        elseif class == "PRIEST" and TextHasAny(label, { "holy", "discipline", "healer" }) then
            score = score + 35
        elseif TextHasAny(label, { "healer", "resto", "restoration" }) then
            score = score + 20
        end
    end

    if TextHasAny(jobText, { "warlock tank" }) and class == "WARLOCK" then
        score = score + 80
    end

    if TextHasAny(jobText, { "misdirect", "hunter" }) and class == "HUNTER" then
        score = score + 80
    end

    if TextHasAny(jobText, { "interrupt" }) and (class == "ROGUE" or class == "WARRIOR" or class == "SHAMAN") then
        score = score + 45
    end

    if TextHasAny(jobText, { "kite", "slow", "strider" }) and (class == "HUNTER" or class == "MAGE" or class == "WARLOCK") then
        score = score + 40
    end

    if TextHasAny(jobText, { "core", "generator" }) then
        score = score + 10
    end

    return score
end

local function FindBestCandidate(job, raid, usedPlayers)
    local bestName, bestScore

    for playerName, member in pairs(raid.members or {}) do
        local score = ScoreCandidate(job, playerName, member, usedPlayers)
        if not bestScore or score > bestScore or (score == bestScore and playerName < bestName) then
            bestName = playerName
            bestScore = score
        end
    end

    if bestScore and bestScore > 0 then
        return bestName, bestScore
    end
end

local function SendRaidWarning(message)
    if RaidJobberDB and RaidJobberDB.testMode then
        Print("[TEST RW] " .. message)
        return true
    end

    local inRaid = IsInRaid and IsInRaid()
    if not inRaid and GetRaidSize and GetRaidSize() > 0 then
        inRaid = true
    end

    if not inRaid then
        Print("You need to be in a raid to use raid warning.")
        return false
    end

    if IsRaidLeader or IsRaidOfficer or UnitIsGroupLeader or UnitIsGroupAssistant then
        local canWarn = (IsRaidLeader and IsRaidLeader())
            or (IsRaidOfficer and IsRaidOfficer())
            or (UnitIsGroupLeader and UnitIsGroupLeader("player"))
            or (UnitIsGroupAssistant and UnitIsGroupAssistant("player"))

        if not canWarn then
            Print("You need raid leader or assistant to send raid warnings.")
            return false
        end
    end

    SendChatMessage(message, "RAID_WARNING")
    return true
end

local function SendRaidWarningLines(lines)
    if not lines or not lines[1] then
        return false
    end

    if not SendRaidWarning(lines[1]) then
        return false
    end

    for index = 2, table.getn(lines) do
        local message = lines[index]
        local function sendLine()
            SendRaidWarning(message)
        end

        if C_Timer and C_Timer.After then
            C_Timer.After((index - 1) * 0.45, sendLine)
        else
            SendRaidWarning(message)
        end
    end

    return true
end

local function GetMarkerIndex(markerName)
    markerName = string.lower(Trim(markerName))
    if markerName == "clear" or markerName == "none" then
        return 0
    end

    return RAID_MARKERS[markerName]
end

local TEST_RAID_MEMBERS = {
    { name = "Aurelion", class = "PALADIN", role = "Healer", override = "Holy Paladin", guild = "RaidJobber Guild", subgroup = 1 },
    { name = "Brightward", class = "PALADIN", role = "Healer", override = "Holy Paladin", guild = "RaidJobber Guild", subgroup = 1 },
    { name = "Stoneguard", class = "WARRIOR", role = "Tank", override = "Protection Warrior", guild = "RaidJobber Guild", subgroup = 1 },
    { name = "Ironbark", class = "DRUID", role = "Tank", override = "Feral Druid Tank", guild = "RaidJobber Guild", subgroup = 1 },
    { name = "Lightshield", class = "PALADIN", role = "Tank", override = "Protection Paladin", guild = "Friends Of RaidJobber", subgroup = 1 },
    { name = "Willowmend", class = "DRUID", role = "Healer", override = "Restoration Druid", guild = "RaidJobber Guild", subgroup = 2 },
    { name = "Tidecaller", class = "SHAMAN", role = "Healer", override = "Restoration Shaman", guild = "Friends Of RaidJobber", subgroup = 2 },
    { name = "Mindlace", class = "PRIEST", role = "Healer", override = "Holy Priest", guild = "RaidJobber Guild", subgroup = 2 },
    { name = "Shadowcoil", class = "WARLOCK", role = "Ranged", override = "Fire Resistance Warlock", guild = "RaidJobber Guild", subgroup = 3 },
    { name = "Felbrand", class = "WARLOCK", role = "Ranged", override = "Destruction Warlock", guild = "Friends Of RaidJobber", subgroup = 3 },
    { name = "Arrowfall", class = "HUNTER", role = "Ranged", override = "Hunter", guild = "RaidJobber Guild", subgroup = 3 },
    { name = "Frostwake", class = "MAGE", role = "Ranged", override = "Frost Mage", guild = "Friends Of RaidJobber", subgroup = 3 },
    { name = "Kickshift", class = "ROGUE", role = "Melee", override = "Rogue", guild = "RaidJobber Guild", subgroup = 4 },
    { name = "Stormkick", class = "SHAMAN", role = "Melee", override = "Enhancement Shaman", guild = "Friends Of RaidJobber", subgroup = 4 },
    { name = "Bladecall", class = "WARRIOR", role = "Melee", override = "DPS Warrior", guild = "RaidJobber Guild", subgroup = 4 },
}

local function GetSortedJobNames(bossJobs)
    local names = {}

    for playerName in pairs(bossJobs or {}) do
        table.insert(names, playerName)
    end

    table.sort(names)
    return names
end

local function GuessRole(unit, classFileName)
    local assignedRole = UnitGroupRolesAssigned and UnitGroupRolesAssigned(unit)
    if assignedRole == "TANK" then
        return "Tank"
    elseif assignedRole == "HEALER" then
        return "Healer"
    elseif assignedRole == "DAMAGER" then
        return ROLE_BY_CLASS[classFileName] or "DPS"
    end

    if TANK_LIKE_CLASSES[classFileName] then
        return ROLE_BY_CLASS[classFileName] or "Hybrid"
    end

    return ROLE_BY_CLASS[classFileName] or "Unknown"
end

GetRaidSize = function()
    if GetNumGroupMembers then
        return GetNumGroupMembers()
    end

    return GetNumRaidMembers()
end

function RJ:ScanRaid()
    EnsureDB()

    local instanceKey = GetInstanceKey()
    RaidJobberDB.raids[instanceKey] = {
        scannedAt = date("%Y-%m-%d %H:%M:%S"),
        members = {},
    }

    local count = GetRaidSize()
    if count == 0 then
        Print("You are not in a raid.")
        return
    end

    for index = 1, count do
        local unit = "raid" .. index
        local name, realm = UnitName(unit)
        local _, classFileName = UnitClass(unit)

        if name and classFileName then
            local fullName = realm and realm ~= "" and (name .. "-" .. realm) or name
            local guildName = GetGuildInfo and GetGuildInfo(unit)
            RaidJobberDB.raids[instanceKey].members[fullName] = {
                class = classFileName,
                role = GuessRole(unit, classFileName),
                guild = guildName,
                subgroup = select(3, GetRaidRosterInfo(index)),
            }
        end
    end

    Print("Scanned " .. count .. " raid members for " .. instanceKey .. ".")
    if RefreshUI then
        RefreshUI()
    end
end

function RJ:LoadTestRaid()
    EnsureDB()

    RaidJobberDB.testMode = true

    local instanceKey = GetInstanceKey()
    RaidJobberDB.raids[instanceKey] = {
        scannedAt = date("%Y-%m-%d %H:%M:%S") .. " test",
        members = {},
    }

    local playerGuild = GetPlayerGuildName() or "RaidJobber Guild"
    for _, member in ipairs(TEST_RAID_MEMBERS) do
        RaidJobberDB.raids[instanceKey].members[member.name] = {
            class = member.class,
            role = member.role,
            guild = member.guild == "RaidJobber Guild" and playerGuild or member.guild,
            subgroup = member.subgroup,
        }
        RaidJobberDB.overrides[string.lower(member.name)] = member.override
    end

    Print("Test mode enabled with " .. table.getn(TEST_RAID_MEMBERS) .. " sample raid members.")
    if RefreshUI then
        RefreshUI()
    end
end

function RJ:SetTestMode(enabled)
    EnsureDB()

    RaidJobberDB.testMode = enabled and true or false
    if RaidJobberDB.testMode then
        Print("Test mode enabled. Raid warnings will print locally.")
    else
        Print("Test mode disabled.")
    end
    if RefreshUI then
        RefreshUI()
    end
end

function RJ:SetRaidMarker(markerName, unit)
    EnsureDB()

    unit = Trim(unit)
    if unit == "" then
        unit = "target"
    end

    local markerIndex = GetMarkerIndex(markerName)
    if not markerIndex then
        Print("Unknown marker. Use skull, cross, square, moon, triangle, diamond, circle, star, or clear.")
        return
    end

    if not UnitExists or not UnitExists(unit) then
        Print("No unit found for " .. unit .. ". Target something first or use target/focus/mouseover.")
        return
    end

    if not SetRaidTarget then
        Print("Raid markers are not available in this client.")
        return
    end

    SetRaidTarget(unit, markerIndex)

    if markerIndex == 0 then
        Print("Cleared raid marker from " .. unit .. ".")
    else
        Print("Set " .. markerName .. " on " .. unit .. ".")
    end
end

function RJ:MarkTarget(markerName)
    RJ:SetRaidMarker(markerName, "target")
end

function RJ:AssignJob(bossName, playerName, jobText)
    EnsureDB()

    local instanceKey = GetInstanceKey()
    local bossKey = GetBossKey(bossName)
    playerName = Trim(playerName)
    jobText = Trim(jobText)

    if playerName == "" or jobText == "" then
        Print("Usage: /rj assign boss name = player: job")
        return
    end

    RaidJobberDB.jobs[instanceKey] = RaidJobberDB.jobs[instanceKey] or {}
    RaidJobberDB.jobs[instanceKey][bossKey] = RaidJobberDB.jobs[instanceKey][bossKey] or {}
    RaidJobberDB.jobs[instanceKey][bossKey][playerName] = jobText

    Print(playerName .. " assigned to " .. jobText .. " for " .. bossKey .. ".")
    if RefreshUI then
        RefreshUI()
    end
end

function RJ:SetMemberOverride(playerName, label)
    EnsureDB()

    playerName = Trim(playerName)
    label = Trim(label)

    if playerName == "" or label == "" then
        Print("Usage: /rj role player = Holy Paladin")
        return
    end

    RaidJobberDB.overrides[string.lower(playerName)] = label
    Print(playerName .. " marked as " .. label .. ".")
    if RefreshUI then
        RefreshUI()
    end
end

function RJ:ShowJobs(bossName)
    EnsureDB()

    local instanceKey = GetInstanceKey()
    local bossKey = GetBossKey(bossName)
    local bossJobs = RaidJobberDB.jobs[instanceKey] and RaidJobberDB.jobs[instanceKey][bossKey]

    Print(instanceKey .. " - " .. bossKey)

    if not bossJobs or not next(bossJobs) then
        Print("No jobs assigned yet.")
        return
    end

    for playerName, jobText in pairs(bossJobs) do
        Print(playerName .. ": " .. jobText)
    end
end

function RJ:AnnounceJobs(bossName)
    EnsureDB()

    local instanceKey = GetInstanceKey()
    local bossKey = GetBossKey(bossName)
    local bossJobs = RaidJobberDB.jobs[instanceKey] and RaidJobberDB.jobs[instanceKey][bossKey]

    if not bossJobs or not next(bossJobs) then
        Print("No jobs assigned for " .. bossKey .. ".")
        return
    end

    local lines = {
        "RaidJobber assignments: " .. bossKey,
    }

    for _, playerName in ipairs(GetSortedJobNames(bossJobs)) do
        local entry = playerName .. ": " .. bossJobs[playerName]
        if string.len(entry) > 240 then
            entry = string.sub(entry, 1, 237) .. "..."
        end
        table.insert(lines, entry)
    end

    SendRaidWarningLines(lines)
end

function RJ:LoadProfile(profileName)
    EnsureDB()

    local profile = GetProfile(profileName)
    if not profile then
        Print("Unknown profile. Try /rj profiles.")
        return
    end

    local instanceKey = GetInstanceKey()
    for _, boss in ipairs(profile.bosses or {}) do
        for _, job in ipairs(boss.jobs or {}) do
            StoreProfileJob(instanceKey, boss.name, job)
        end
    end

    Print("Loaded " .. profile.name .. " jobs into " .. instanceKey .. ".")
    if RefreshUI then
        RefreshUI()
    end
end

function RJ:SuggestJobs(bossName)
    EnsureDB()

    local bossKey = GetBossKey(bossName)
    local raid = GetCurrentRaid()
    if not raid or not raid.members or not next(raid.members) then
        Print("No raid scan found. Run /rj scan first.")
        return
    end

    local profile = GetProfileForBoss(bossKey)
    local profileBoss

    for _, boss in ipairs((profile and profile.bosses) or {}) do
        if boss.name == bossKey then
            profileBoss = boss
            break
        end
    end

    if not profileBoss then
        Print("No profile jobs found for " .. bossKey .. ".")
        return
    end

    local instanceKey = GetInstanceKey()
    local usedPlayers = {}
    RaidJobberDB.jobs[instanceKey] = RaidJobberDB.jobs[instanceKey] or {}
    RaidJobberDB.jobs[instanceKey][bossKey] = {}

    for _, job in ipairs(profileBoss.jobs or {}) do
        local playerName
        if string.lower(job.role or "") ~= "all" then
            playerName = FindBestCandidate(job, raid, usedPlayers)
        end
        local key = playerName or ("[" .. job.slot .. "]")

        if playerName then
            usedPlayers[playerName] = true
            RaidJobberDB.jobs[instanceKey][bossKey][key] = "[" .. job.slot .. "] " .. job.text
            Print(job.slot .. " -> " .. playerName .. " (" .. GetMemberLabel(playerName, raid.members[playerName]) .. ")")
        else
            RaidJobberDB.jobs[instanceKey][bossKey][key] = job.role .. ": " .. job.text
            Print(job.slot .. " -> no candidate found")
        end
    end

    Print("Suggested assignments saved for " .. bossKey .. ". Use /rj show " .. bossName .. " or /rj rw " .. bossName .. ".")
    if RefreshUI then
        RefreshUI()
    end
end

function RJ:LoadSelectedBossProfile(bossName)
    local _, profileKey = GetProfileForBoss(bossName)
    if not profileKey then
        Print("No raid profile found for " .. tostring(bossName) .. ".")
        return
    end

    RJ:LoadProfile(profileKey)
end

function RJ:ShowProfiles()
    if not RaidJobberProfiles or not next(RaidJobberProfiles) then
        Print("No profiles are installed.")
        return
    end

    Print("Installed profiles:")
    for key, profile in pairs(RaidJobberProfiles) do
        Print(key .. " - " .. profile.name)
    end
end

function RJ:ShowProfileBosses(profileName)
    local profile = GetProfile(profileName)
    if not profile then
        Print("Unknown profile. Try /rj profiles.")
        return
    end

    Print(profile.name .. " bosses:")
    for _, boss in ipairs(profile.bosses or {}) do
        Print("- " .. boss.name)
    end
end

function RJ:ShowRaid()
    EnsureDB()

    local instanceKey = GetInstanceKey()
    local raid = RaidJobberDB.raids[instanceKey]

    if not raid or not raid.members or not next(raid.members) then
        Print("No scan found for " .. instanceKey .. ". Run /rj scan first.")
        return
    end

    Print("Raid scan for " .. instanceKey .. " at " .. raid.scannedAt)
    for playerName, data in pairs(raid.members) do
        Print(playerName .. " - " .. data.class .. " - " .. data.role .. " - Group " .. tostring(data.subgroup or "?"))
    end
end

function RJ:ClearBoss(bossName)
    EnsureDB()

    local instanceKey = GetInstanceKey()
    local bossKey = GetBossKey(bossName)

    if RaidJobberDB.jobs[instanceKey] then
        RaidJobberDB.jobs[instanceKey][bossKey] = nil
    end

    Print("Cleared jobs for " .. bossKey .. ".")
    if RefreshUI then
        RefreshUI()
    end
end

local UI = {
    selectedProfile = "ssc",
    selectedBoss = "Hydross the Unstable",
    jobLines = {},
    jobRows = {},
    raidLines = {},
}

local function PositionMinimapButton()
    if not UI.minimapButton then
        return
    end

    EnsureDB()

    local angle = RaidJobberDB.minimap.angle or 225
    local radians = math.rad(angle)
    local radius = 80
    UI.minimapButton:SetPoint("CENTER", Minimap, "CENTER", math.cos(radians) * radius, math.sin(radians) * radius)
end

local function CalculateMinimapAngle(y, x)
    if math.atan2 then
        return math.deg(math.atan2(y, x))
    end

    if x == 0 then
        return y >= 0 and 90 or 270
    end

    local angle = math.deg(math.atan(y / x))
    if x < 0 then
        angle = angle + 180
    elseif y < 0 then
        angle = angle + 360
    end

    return angle
end

local function GetProfileBossNames()
    local names = {}
    local profile = RaidJobberProfiles and RaidJobberProfiles[UI.selectedProfile]

    for _, boss in ipairs((profile and profile.bosses) or {}) do
        table.insert(names, boss.name)
    end

    return names
end

local function GetSortedProfileKeys()
    local keys = {}

    for key in pairs(RaidJobberProfiles or {}) do
        table.insert(keys, key)
    end

    table.sort(keys)
    return keys
end

local function GetProfileKeyForCurrentInstance()
    local instanceName = string.lower(GetInstanceInfo() or "")

    for key, profile in pairs(RaidJobberProfiles or {}) do
        if string.lower(profile.name or "") == instanceName then
            return key
        end

        if profile.aliases and profile.aliases[instanceName] then
            return key
        end
    end
end

local function SelectProfile(profileKey)
    if not RaidJobberProfiles or not RaidJobberProfiles[profileKey] then
        return
    end

    UI.selectedProfile = profileKey

    local firstBoss = RaidJobberProfiles[profileKey].bosses and RaidJobberProfiles[profileKey].bosses[1]
    if firstBoss then
        UI.selectedBoss = firstBoss.name
    end

    if UI.profileDropDown then
        UIDropDownMenu_SetText(UI.profileDropDown, RaidJobberProfiles[profileKey].name)
    end

    if UI.bossDropDown then
        UIDropDownMenu_SetText(UI.bossDropDown, UI.selectedBoss)
    end

    RefreshUI()
end

local function EnsureSelectedProfile()
    if not RaidJobberProfiles or not RaidJobberProfiles[UI.selectedProfile] then
        UI.selectedProfile = GetSortedProfileKeys()[1] or "ssc"
    end

    local profile = RaidJobberProfiles and RaidJobberProfiles[UI.selectedProfile]
    if profile and profile.bosses and profile.bosses[1] and not UI.selectedBoss then
        UI.selectedBoss = profile.bosses[1].name
    end
end

local function GetBossJobsForUI()
    local instanceKey = GetInstanceKey()
    local bossKey = GetBossKey(UI.selectedBoss)

    if RaidJobberDB.jobs[instanceKey] then
        return RaidJobberDB.jobs[instanceKey][bossKey]
    end
end

local function GetProfileBossForUI()
    local profile = RaidJobberProfiles and RaidJobberProfiles[UI.selectedProfile]
    local bossKey = GetBossKey(UI.selectedBoss)

    for _, boss in ipairs((profile and profile.bosses) or {}) do
        if boss.name == bossKey then
            return boss
        end
    end
end

local function GetSuggestedPlayerForJob(job)
    local bossJobs = GetBossJobsForUI()
    if not bossJobs then
        return ""
    end

    if bossJobs["[" .. job.slot .. "]"] then
        return ""
    end

    local prefix = "[" .. job.slot .. "] "
    for playerName, jobText in pairs(bossJobs) do
        if string.sub(jobText, 1, string.len(prefix)) == prefix then
            return string.sub(playerName, 1, 1) == "[" and "" or playerName
        end
    end

    return ""
end

local function StripSlotPrefix(jobText)
    return string.gsub(jobText or "", "^%[[^%]]+%]%s*", "")
end

local function RemoveSlotAssignment(bossName, slot)
    local instanceKey = GetInstanceKey()
    local bossKey = GetBossKey(bossName)
    local bossJobs = RaidJobberDB.jobs[instanceKey] and RaidJobberDB.jobs[instanceKey][bossKey]
    if not bossJobs then
        return
    end

    local placeholderKey = "[" .. slot .. "]"
    local prefix = "[" .. slot .. "] "

    for playerName, jobText in pairs(bossJobs) do
        if playerName == placeholderKey or string.sub(jobText or "", 1, string.len(prefix)) == prefix then
            bossJobs[playerName] = nil
        end
    end
end

local function RemoveAssignmentPlayer(bossName, playerName)
    playerName = Trim(playerName)
    if playerName == "" then
        return
    end

    local instanceKey = GetInstanceKey()
    local bossKey = GetBossKey(bossName)
    local bossJobs = RaidJobberDB.jobs[instanceKey] and RaidJobberDB.jobs[instanceKey][bossKey]
    if bossJobs then
        bossJobs[playerName] = nil
    end
end

local function SaveJobRow(row)
    local playerName = Trim(row.player:GetText())
    local jobText = Trim(row.job:GetText())

    if row.isCustom then
        RemoveAssignmentPlayer(UI.selectedBoss, row.originalPlayer)
        RJ:AssignJob(UI.selectedBoss, playerName, jobText)
        return
    end

    RemoveSlotAssignment(UI.selectedBoss, row.slot)

    if playerName == "" then
        playerName = "[" .. row.slot .. "]"
    end

    RJ:AssignJob(UI.selectedBoss, playerName, "[" .. row.slot .. "] " .. jobText)
end

local function IsProfileSlotAssignment(playerName, jobText, profileJobs)
    for _, job in ipairs(profileJobs or {}) do
        local placeholderKey = "[" .. job.slot .. "]"
        local prefix = "[" .. job.slot .. "] "
        if playerName == placeholderKey or string.sub(jobText or "", 1, string.len(prefix)) == prefix then
            return true
        end
    end

    return false
end

local function CountRaidMembers(raid)
    local count = 0

    for _ in pairs((raid and raid.members) or {}) do
        count = count + 1
    end

    return count
end

local function CreateLabel(parent, text, size)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetText(text)
    if size == "small" then
        label:SetFontObject(GameFontHighlightSmall)
    end
    return label
end

local function CreateButton(parent, text, width, height, onClick)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetWidth(width)
    button:SetHeight(height)
    button:SetText(text)
    button:SetScript("OnClick", onClick)
    return button
end

local function CreateEditBox(parent, width)
    local editBox = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    editBox:SetWidth(width)
    editBox:SetHeight(24)
    editBox:SetAutoFocus(false)
    editBox:SetFontObject(ChatFontNormal)
    return editBox
end

RefreshUI = function()
    if not UI.frame or not UI.frame:IsShown() then
        return
    end

    EnsureDB()
    EnsureSelectedProfile()

    local instanceKey = GetInstanceKey()
    local raid = GetCurrentRaid()
    local raidCount = CountRaidMembers(raid)
    local bossKey = GetBossKey(UI.selectedBoss)
    local bossJobs = GetBossJobsForUI()
    local testText = RaidJobberDB.testMode and "on" or "off"

    UI.instanceText:SetText("Instance: " .. instanceKey .. "   Raid: " .. raidCount .. "   Test: " .. testText)
    UI.bossText:SetText("Boss: " .. bossKey)

    local profileBoss = GetProfileBossForUI()
    local jobs = (profileBoss and profileBoss.jobs) or {}
    local rowIndex = 1
    for index, rowFrame in ipairs(UI.jobRows) do
        local job = jobs[index]
        if job then
            rowIndex = index + 1
            rowFrame.isCustom = false
            rowFrame.originalPlayer = nil
            rowFrame.slot = job.slot
            rowFrame.slotText:SetText(job.slot)
            rowFrame.player:SetText(GetSuggestedPlayerForJob(job))
            rowFrame.job:SetText(job.text)
            rowFrame:Show()
        else
            rowFrame:Hide()
        end
    end

    if bossJobs and next(bossJobs) then
        for _, playerName in ipairs(GetSortedJobNames(bossJobs)) do
            local jobText = bossJobs[playerName]
            if rowIndex <= table.getn(UI.jobRows) and not IsProfileSlotAssignment(playerName, jobText, jobs) then
                local rowFrame = UI.jobRows[rowIndex]
                rowFrame.isCustom = true
                rowFrame.originalPlayer = playerName
                rowFrame.slot = "Custom"
                rowFrame.slotText:SetText("Custom")
                rowFrame.player:SetText(playerName)
                rowFrame.job:SetText(StripSlotPrefix(jobText))
                rowFrame:Show()
                rowIndex = rowIndex + 1
            end
        end
    end

    for _, line in ipairs(UI.raidLines) do
        line:SetText("")
    end

    local row = 1
    if raid and raid.members and next(raid.members) then
        local names = GetSortedJobNames(raid.members)
        for _, playerName in ipairs(names) do
            if UI.raidLines[row] then
                local member = raid.members[playerName]
                local guildTag = IsSameGuildMember(member) and " *" or ""
                UI.raidLines[row]:SetText(playerName .. guildTag .. "  -  " .. GetMemberLabel(playerName, member))
            end
            row = row + 1
        end
    else
        UI.raidLines[1]:SetText("No raid scan yet.")
    end
end

local function CreateRaidJobberUI()
    if UI.frame then
        return UI.frame
    end

    local backdropTemplate = BackdropTemplateMixin and "BackdropTemplate" or nil
    local frame = CreateFrame("Frame", "RaidJobberFrame", UIParent, backdropTemplate)
    UI.frame = frame
    frame:SetWidth(720)
    frame:SetHeight(700)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    if frame.SetBackdrop then
        frame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true,
            tileSize = 32,
            edgeSize = 32,
            insets = { left = 11, right = 12, top = 12, bottom = 11 },
        })
    end
    frame:Hide()

    local title = CreateLabel(frame, "RaidJobber", nil)
    title:SetPoint("TOPLEFT", 22, -18)

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -6, -6)

    UI.instanceText = CreateLabel(frame, "", "small")
    UI.instanceText:SetPoint("TOPLEFT", 24, -44)

    UI.bossText = CreateLabel(frame, "", nil)
    UI.bossText:SetPoint("TOPLEFT", 24, -78)

    local raidDropLabel = CreateLabel(frame, "Raid", "small")
    raidDropLabel:SetPoint("TOPLEFT", 112, -63)

    local bossDropLabel = CreateLabel(frame, "Boss", "small")
    bossDropLabel:SetPoint("TOPLEFT", 312, -63)

    local profileDropDown = CreateFrame("Frame", "RaidJobberProfileDropDown", frame, "UIDropDownMenuTemplate")
    UI.profileDropDown = profileDropDown
    profileDropDown:SetPoint("TOPLEFT", 104, -76)
    UIDropDownMenu_SetWidth(profileDropDown, 150)
    EnsureSelectedProfile()
    UIDropDownMenu_SetText(profileDropDown, RaidJobberProfiles[UI.selectedProfile].name)
    UIDropDownMenu_Initialize(profileDropDown, function()
        for _, profileKey in ipairs(GetSortedProfileKeys()) do
            local selectedKey = profileKey
            local profile = RaidJobberProfiles[selectedKey]
            local info = UIDropDownMenu_CreateInfo()
            info.text = profile.name
            info.func = function()
                SelectProfile(selectedKey)
            end
            UIDropDownMenu_AddButton(info)
        end
    end)

    local bossDropDown = CreateFrame("Frame", "RaidJobberBossDropDown", frame, "UIDropDownMenuTemplate")
    UI.bossDropDown = bossDropDown
    bossDropDown:SetPoint("TOPLEFT", 304, -76)
    UIDropDownMenu_SetWidth(bossDropDown, 210)
    UIDropDownMenu_SetText(bossDropDown, UI.selectedBoss)
    UIDropDownMenu_Initialize(bossDropDown, function()
        for _, bossName in ipairs(GetProfileBossNames()) do
            local selectedName = bossName
            local info = UIDropDownMenu_CreateInfo()
            info.text = selectedName
            info.func = function()
                UI.selectedBoss = selectedName
                UIDropDownMenu_SetText(bossDropDown, selectedName)
                RefreshUI()
            end
            UIDropDownMenu_AddButton(info)
        end
    end)

    local scan = CreateButton(frame, "Scan", 78, 24, function()
        RJ:ScanRaid()
    end)
    scan:SetPoint("TOPLEFT", 24, -112)

    local load = CreateButton(frame, "Load Raid", 86, 24, function()
        RJ:LoadProfile(UI.selectedProfile)
    end)
    load:SetPoint("LEFT", scan, "RIGHT", 6, 0)

    local suggest = CreateButton(frame, "Suggest", 86, 24, function()
        RJ:SuggestJobs(UI.selectedBoss)
    end)
    suggest:SetPoint("LEFT", load, "RIGHT", 6, 0)

    local announce = CreateButton(frame, "Raid Warn", 92, 24, function()
        RJ:AnnounceJobs(UI.selectedBoss)
    end)
    announce:SetPoint("LEFT", suggest, "RIGHT", 6, 0)

    local clear = CreateButton(frame, "Clear", 72, 24, function()
        RJ:ClearBoss(UI.selectedBoss)
    end)
    clear:SetPoint("LEFT", announce, "RIGHT", 6, 0)

    local testRaid = CreateButton(frame, "Test Raid", 86, 24, function()
        RJ:LoadTestRaid()
    end)
    testRaid:SetPoint("LEFT", clear, "RIGHT", 6, 0)

    local testOff = CreateButton(frame, "Test Off", 78, 24, function()
        RJ:SetTestMode(false)
    end)
    testOff:SetPoint("LEFT", testRaid, "RIGHT", 6, 0)

    local roleLabel = CreateLabel(frame, "Role hint", "small")
    roleLabel:SetPoint("TOPLEFT", 24, -148)

    UI.rolePlayer = CreateEditBox(frame, 110)
    UI.rolePlayer:SetPoint("TOPLEFT", 82, -142)
    UI.rolePlayer:SetText("Player")

    UI.roleText = CreateEditBox(frame, 150)
    UI.roleText:SetPoint("LEFT", UI.rolePlayer, "RIGHT", 14, 0)
    UI.roleText:SetText("Holy Paladin")

    local saveRole = CreateButton(frame, "Save Role", 84, 24, function()
        RJ:SetMemberOverride(UI.rolePlayer:GetText(), UI.roleText:GetText())
    end)
    saveRole:SetPoint("LEFT", UI.roleText, "RIGHT", 8, 0)

    local assignLabel = CreateLabel(frame, "Quick add", "small")
    assignLabel:SetPoint("TOPLEFT", 24, -176)

    UI.assignPlayer = CreateEditBox(frame, 110)
    UI.assignPlayer:SetPoint("TOPLEFT", 82, -170)
    UI.assignPlayer:SetText("Player")

    UI.assignText = CreateEditBox(frame, 220)
    UI.assignText:SetPoint("LEFT", UI.assignPlayer, "RIGHT", 14, 0)
    UI.assignText:SetText("Tank healer")

    local assign = CreateButton(frame, "Add", 52, 24, function()
        RJ:AssignJob(UI.selectedBoss, UI.assignPlayer:GetText(), UI.assignText:GetText())
    end)
    assign:SetPoint("LEFT", UI.assignText, "RIGHT", 8, 0)

    local markerLabel = CreateLabel(frame, "Mark target", "small")
    markerLabel:SetPoint("TOPLEFT", 500, -148)

    local skull = CreateButton(frame, "Skull", 48, 22, function()
        RJ:MarkTarget("skull")
    end)
    skull:SetPoint("TOPLEFT", 560, -142)

    local cross = CreateButton(frame, "Cross", 48, 22, function()
        RJ:MarkTarget("cross")
    end)
    cross:SetPoint("LEFT", skull, "RIGHT", 6, 0)

    local clearMarker = CreateButton(frame, "Clear", 48, 22, function()
        RJ:MarkTarget("clear")
    end)
    clearMarker:SetPoint("LEFT", cross, "RIGHT", 6, 0)

    local square = CreateButton(frame, "Square", 54, 22, function()
        RJ:MarkTarget("square")
    end)
    square:SetPoint("TOPLEFT", 560, -170)

    local moon = CreateButton(frame, "Moon", 48, 22, function()
        RJ:MarkTarget("moon")
    end)
    moon:SetPoint("LEFT", square, "RIGHT", 6, 0)

    local jobsTitle = CreateLabel(frame, "Assignments", nil)
    jobsTitle:SetPoint("TOPLEFT", 24, -214)

    local playerHeader = CreateLabel(frame, "Player", "small")
    playerHeader:SetPoint("TOPLEFT", 130, -216)

    local jobHeader = CreateLabel(frame, "Job", "small")
    jobHeader:SetPoint("TOPLEFT", 242, -216)

    for index = 1, 18 do
        local row = CreateFrame("Frame", nil, frame)
        row:SetWidth(430)
        row:SetHeight(24)
        row:SetPoint("TOPLEFT", 28, -234 - ((index - 1) * 24))

        row.slotText = CreateLabel(row, "", "small")
        row.slotText:SetWidth(92)
        row.slotText:SetJustifyH("LEFT")
        row.slotText:SetPoint("LEFT", 0, 0)

        row.player = CreateEditBox(row, 96)
        row.player:SetPoint("LEFT", 100, 0)

        row.job = CreateEditBox(row, 178)
        row.job:SetPoint("LEFT", row.player, "RIGHT", 12, 0)

        row.save = CreateButton(row, "Save", 48, 22, function()
            SaveJobRow(row)
        end)
        row.save:SetPoint("LEFT", row.job, "RIGHT", 6, 0)

        UI.jobRows[index] = row
    end

    local raidTitle = CreateLabel(frame, "Raid", nil)
    raidTitle:SetPoint("TOPLEFT", 470, -214)

    for index = 1, 24 do
        local line = CreateLabel(frame, "", "small")
        line:SetWidth(210)
        line:SetJustifyH("LEFT")
        line:SetPoint("TOPLEFT", 474, -236 - ((index - 1) * 15))
        UI.raidLines[index] = line
    end

    return frame
end

function RJ:ToggleUI()
    local frame = CreateRaidJobberUI()
    if frame:IsShown() then
        frame:Hide()
    else
        SelectProfile(GetProfileKeyForCurrentInstance() or UI.selectedProfile)
        frame:Show()
        RefreshUI()
    end
end

local function CreateMinimapButton()
    if UI.minimapButton then
        return UI.minimapButton
    end

    EnsureDB()

    local button = CreateFrame("Button", "RaidJobberMinimapButton", Minimap)
    UI.minimapButton = button
    button:SetWidth(32)
    button:SetHeight(32)
    button:SetFrameStrata("MEDIUM")
    button:SetMovable(true)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:RegisterForDrag("LeftButton")

    local icon = button:CreateTexture(nil, "BACKGROUND")
    button.icon = icon
    icon:SetWidth(20)
    icon:SetHeight(20)
    icon:SetPoint("CENTER")
    icon:SetTexture("Interface\\Icons\\INV_Misc_Note_01")

    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetWidth(54)
    border:SetHeight(54)
    border:SetPoint("CENTER", 0, 0)
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    button:SetScript("OnClick", function(_, mouseButton)
        if mouseButton == "RightButton" then
            RaidJobberDB.minimap.hide = true
            button:Hide()
            Print("Minimap button hidden. Type /rj minimap to show it again.")
        else
            RJ:ToggleUI()
        end
    end)

    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("RaidJobber")
        GameTooltip:AddLine("Left-click: open assignments", 1, 1, 1)
        GameTooltip:AddLine("Drag: move button", 1, 1, 1)
        GameTooltip:AddLine("Right-click: hide button", 1, 1, 1)
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    button:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            px = px / scale
            py = py / scale
            RaidJobberDB.minimap.angle = CalculateMinimapAngle(py - my, px - mx)
            PositionMinimapButton()
        end)
    end)

    button:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
        PositionMinimapButton()
    end)

    PositionMinimapButton()

    if RaidJobberDB.minimap.hide then
        button:Hide()
    else
        button:Show()
    end

    return button
end

function RJ:ShowMinimapButton()
    EnsureDB()
    RaidJobberDB.minimap.hide = false
    CreateMinimapButton()
    UI.minimapButton:Show()
    PositionMinimapButton()
    Print("Minimap button shown.")
end

local function ShowHelp()
    Print("/rj scan - scan raid members and estimated roles")
    Print("/rj raid - show the last scan for this instance")
    Print("/rj profiles - list installed boss profiles")
    Print("/rj bosses kara|gruul|magtheridon|ssc|tk|bt|hyjal|za|sunwell - list bosses")
    Print("/rj load kara|gruul|magtheridon|ssc|tk|bt|hyjal|za|sunwell - load raid jobs")
    Print("/rj ui - open the in-game interface")
    Print("/rj minimap - show the minimap button")
    Print("/rj suggest [boss] - auto-fill boss jobs from scanned raid")
    Print("/rj role player = Holy Paladin - add a manual role/spec hint")
    Print("/rj mark skull target - set a raid marker on target/focus/mouseover")
    Print("/rj test on|off|raid - test mode and sample raid")
    Print("/rj show [boss] - show jobs for a boss, or General")
    Print("/rj rw [boss] - announce jobs in raid warning")
    Print("/rj assign boss = player: job - assign a player job")
    Print("/rj clear [boss] - clear jobs for a boss, or General")
end

local function HandleAssign(input)
    local bossName, rest = string.match(input, "^assign%s+(.+)%s+=%s+(.+)$")
    if not bossName or not rest then
        Print("Usage: /rj assign boss name = player: job")
        return
    end

    local playerName, jobText = string.match(rest, "^([^:]+)%s*:%s*(.+)$")
    RJ:AssignJob(bossName, playerName, jobText)
end

local function HandleRole(input)
    local playerName, label = string.match(input, "^role%s+(.+)%s+=%s+(.+)$")
    RJ:SetMemberOverride(playerName, label)
end

local function HandleTest(input)
    local command = string.lower(Trim(string.gsub(input, "^test", "")))

    if command == "on" then
        RJ:SetTestMode(true)
    elseif command == "off" then
        RJ:SetTestMode(false)
    elseif command == "raid" then
        RJ:LoadTestRaid()
    else
        Print("Usage: /rj test on, /rj test off, or /rj test raid")
    end
end

local function HandleMark(input)
    local markerName, unit = string.match(input, "^mark%s+([^%s]+)%s*(.*)$")
    RJ:SetRaidMarker(markerName, unit)
end

SLASH_RAIDJOBBER1 = "/raidjobber"
SLASH_RAIDJOBBER2 = "/rj"
SlashCmdList.RAIDJOBBER = function(input)
    input = Trim(input)

    if input == "" or input == "help" then
        ShowHelp()
    elseif input == "scan" then
        RJ:ScanRaid()
    elseif input == "raid" then
        RJ:ShowRaid()
    elseif input == "ui" or input == "window" then
        RJ:ToggleUI()
    elseif input == "minimap" then
        RJ:ShowMinimapButton()
    elseif input == "profiles" then
        RJ:ShowProfiles()
    elseif string.find(input, "^bosses%s+") then
        RJ:ShowProfileBosses(Trim(string.gsub(input, "^bosses", "")))
    elseif string.find(input, "^load%s+") then
        RJ:LoadProfile(Trim(string.gsub(input, "^load", "")))
    elseif string.find(input, "^suggest%s+") then
        RJ:SuggestJobs(Trim(string.gsub(input, "^suggest", "")))
    elseif string.find(input, "^role%s+") then
        HandleRole(input)
    elseif string.find(input, "^mark%s+") then
        HandleMark(input)
    elseif string.find(input, "^test") then
        HandleTest(input)
    elseif string.find(input, "^assign%s+") then
        HandleAssign(input)
    elseif string.find(input, "^show") then
        RJ:ShowJobs(Trim(string.gsub(input, "^show", "")))
    elseif string.find(input, "^rw") or string.find(input, "^announce") then
        input = string.gsub(input, "^rw", "")
        input = string.gsub(input, "^announce", "")
        RJ:AnnounceJobs(Trim(input))
    elseif string.find(input, "^clear") then
        RJ:ClearBoss(Trim(string.gsub(input, "^clear", "")))
    else
        ShowHelp()
    end
end

RJ:RegisterEvent("ADDON_LOADED")
RJ:RegisterEvent("GROUP_ROSTER_UPDATE")
RJ:RegisterEvent("RAID_ROSTER_UPDATE")
RJ:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        EnsureDB()
        CreateMinimapButton()
        Print("Loaded. Type /rj help.")
    elseif event == "GROUP_ROSTER_UPDATE" or event == "RAID_ROSTER_UPDATE" then
        EnsureDB()
    end
end)
