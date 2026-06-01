RaidJobberProfiles = RaidJobberProfiles or {}

RaidJobberProfiles.ssc = {
    name = "Serpentshrine Cavern",
    aliases = {
        ["serpentshrine cavern"] = true,
        ["serpentshrine"] = true,
        ["ssc"] = true,
    },
    bosses = {
        {
            name = "Hydross the Unstable",
            aliases = { "hydross" },
            jobs = {
                { slot = "Tank 1", role = "Tank", text = "Nature phase boss tank" },
                { slot = "Tank 2", role = "Tank", text = "Frost phase boss tank" },
                { slot = "Add Tank 1", role = "Tank", text = "Pick up left-side adds" },
                { slot = "Add Tank 2", role = "Tank", text = "Pick up right-side adds" },
                { slot = "Healer 1", role = "Healer", text = "Nature tank healer" },
                { slot = "Healer 2", role = "Healer", text = "Frost tank healer" },
                { slot = "Hunter", role = "Ranged", text = "Misdirect pull and threat support" },
                { slot = "Raid", role = "All", text = "Stop DPS before transitions and reset threat after movement" },
            },
        },
        {
            name = "The Lurker Below",
            aliases = { "lurker" },
            jobs = {
                { slot = "Tank 1", role = "Tank", text = "Boss tank on platform edge" },
                { slot = "Island Tank 1", role = "Tank", text = "Handle adds on island group 1" },
                { slot = "Island Tank 2", role = "Tank", text = "Handle adds on island group 2" },
                { slot = "Island Tank 3", role = "Tank", text = "Handle adds on island group 3" },
                { slot = "Healer 1", role = "Healer", text = "Main tank healer" },
                { slot = "Healer 2", role = "Healer", text = "Island group 1 healer" },
                { slot = "Healer 3", role = "Healer", text = "Island group 2 healer" },
                { slot = "Healer 4", role = "Healer", text = "Island group 3 healer" },
                { slot = "Raid", role = "All", text = "Jump into water for Spout and return fast" },
            },
        },
        {
            name = "Leotheras the Blind",
            aliases = { "leo", "leotheras" },
            jobs = {
                { slot = "Tank 1", role = "Tank", text = "Human-form boss tank" },
                { slot = "Warlock Tank", role = "Ranged", text = "Demon-form tank with fire resistance set" },
                { slot = "Healer 1", role = "Healer", text = "Human tank healer" },
                { slot = "Healer 2", role = "Healer", text = "Warlock tank healer" },
                { slot = "DPS Lead", role = "DPS", text = "Call inner demon swaps and stop DPS during Whirlwind" },
                { slot = "Raid", role = "All", text = "Spread for Whirlwind and kill your Inner Demon immediately" },
            },
        },
        {
            name = "Fathom-Lord Karathress",
            aliases = { "karathress", "fathom-lord" },
            jobs = {
                { slot = "Karathress Tank", role = "Tank", text = "Tank Fathom-Lord Karathress" },
                { slot = "Sharkkis Tank", role = "Tank", text = "Tank Sharkkis and pet" },
                { slot = "Tidalvess Tank", role = "Tank", text = "Tank Tidalvess and handle totems nearby" },
                { slot = "Caribdis Tank", role = "Tank", text = "Tank Caribdis and position for interrupts" },
                { slot = "Interrupt 1", role = "Melee", text = "Primary Caribdis heal interrupt" },
                { slot = "Interrupt 2", role = "Melee", text = "Backup Caribdis heal interrupt" },
                { slot = "Totem DPS", role = "DPS", text = "Kill Spitfire Totem immediately" },
                { slot = "Healer 1", role = "Healer", text = "Karathress tank healer" },
                { slot = "Healer 2", role = "Healer", text = "Sharkkis tank healer" },
                { slot = "Healer 3", role = "Healer", text = "Tidalvess tank healer" },
                { slot = "Healer 4", role = "Healer", text = "Caribdis tank healer" },
            },
        },
        {
            name = "Morogrim Tidewalker",
            aliases = { "morogrim" },
            jobs = {
                { slot = "Tank 1", role = "Tank", text = "Boss tank" },
                { slot = "Murloc Tank 1", role = "Tank", text = "Gather murlocs from left side" },
                { slot = "Murloc Tank 2", role = "Tank", text = "Gather murlocs from right side" },
                { slot = "Grave Healer 1", role = "Healer", text = "Heal Watery Grave targets" },
                { slot = "Grave Healer 2", role = "Healer", text = "Backup Watery Grave healing" },
                { slot = "Murloc Control 1", role = "DPS", text = "Slow, root, or stun murlocs for pickup" },
                { slot = "Murloc Control 2", role = "DPS", text = "Backup murloc control" },
                { slot = "Raid", role = "All", text = "Stack for murloc AoE and move after Earthquake" },
            },
        },
        {
            name = "Lady Vashj",
            aliases = { "vashj", "lady vashj" },
            jobs = {
                { slot = "Tank 1", role = "Tank", text = "Phase 1 and Phase 3 boss tank" },
                { slot = "Middle Paladin", role = "Healer", text = "Holy Paladin stands middle with Righteous Fury" },
                { slot = "Strider Kiter", role = "Ranged", text = "Kite Coilfang Strider; prefer Mage, then Shaman, then Hunter" },
                { slot = "Strider Slow", role = "Ranged", text = "Backup slow and control for Coilfang Strider" },
                { slot = "Naga Tank 1", role = "Tank", text = "Pick up Coilfang Elite" },
                { slot = "Naga Tank 2", role = "Tank", text = "Backup Elite pickup" },
                { slot = "Area 1", role = "Any", text = "Area 1 core team", members = {
                    { label = "Melee", role = "Melee", text = "Area 1 melee DPS" },
                    { label = "Healer", role = "Healer", text = "Area 1 healer" },
                    { label = "Ranged", role = "Ranged", text = "Area 1 ranged DPS; hunter preferred" },
                } },
                { slot = "Area 2", role = "Any", text = "Area 2 core team", members = {
                    { label = "Melee", role = "Melee", text = "Area 2 melee DPS" },
                    { label = "Healer", role = "Healer", text = "Area 2 healer" },
                    { label = "Ranged", role = "Ranged", text = "Area 2 ranged DPS; hunter preferred" },
                } },
                { slot = "Area 3", role = "Any", text = "Area 3 core team", members = {
                    { label = "Melee", role = "Melee", text = "Area 3 melee DPS" },
                    { label = "Healer", role = "Healer", text = "Area 3 healer" },
                    { label = "Ranged", role = "Ranged", text = "Area 3 ranged DPS; hunter preferred" },
                } },
                { slot = "Area 4", role = "Any", text = "Area 4 core team", members = {
                    { label = "Melee", role = "Melee", text = "Area 4 melee DPS" },
                    { label = "Healer", role = "Healer", text = "Area 4 healer" },
                    { label = "Ranged", role = "Ranged", text = "Area 4 ranged DPS; hunter preferred" },
                } },
                { slot = "Spore Bats 1", role = "Ranged", text = "Hunter assigned to Spore Bats in Phase 3" },
                { slot = "Spore Bats 2", role = "Ranged", text = "Backup Hunter assigned to Spore Bats in Phase 3" },
                { slot = "Healer 1", role = "Healer", text = "Main tank healer" },
                { slot = "Raid", role = "All", text = "Spread for Static Charge and keep moving out of poison" },
            },
        },
    },
}

RaidJobberProfiles.kara = {
    name = "Karazhan",
    aliases = {
        ["karazhan"] = true,
        ["kara"] = true,
    },
    bosses = {
        { name = "Attumen the Huntsman", aliases = { "attumen" }, jobs = {
            { slot = "Attumen Tank", role = "Tank", text = "Tank Attumen after mount split" },
            { slot = "Midnight Tank", role = "Tank", text = "Tank Midnight before merge" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
            { slot = "Raid", role = "All", text = "Dispel Intangible Presence and avoid cleave" },
        } },
        { name = "Moroes", aliases = { "moroes" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Moroes main tank" },
            { slot = "Tank 2", role = "Tank", text = "Off-tank Moroes and loose adds" },
            { slot = "Crowd Control 1", role = "Any", text = "Control dangerous dinner guest" },
            { slot = "Crowd Control 2", role = "Any", text = "Control second dinner guest" },
            { slot = "Healer 1", role = "Healer", text = "Garrote and tank healing" },
            { slot = "Raid", role = "All", text = "Kill or control guests before focusing Moroes" },
        } },
        { name = "Maiden of Virtue", aliases = { "maiden" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Dispel 1", role = "Healer", text = "Primary Holy Fire dispel" },
            { slot = "Dispel 2", role = "Healer", text = "Backup Holy Fire dispel" },
            { slot = "Raid", role = "All", text = "Spread and use Repentance break plan" },
        } },
        { name = "Opera Event", aliases = { "opera" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Primary active target tank" },
            { slot = "Tank 2", role = "Tank", text = "Backup or add tank" },
            { slot = "Interrupt 1", role = "Melee", text = "Primary interrupt if needed" },
            { slot = "Healer 1", role = "Healer", text = "Tank and raid healer" },
            { slot = "Raid", role = "All", text = "Adjust to the selected Opera encounter" },
        } },
        { name = "The Curator", aliases = { "curator" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Spark DPS", role = "DPS", text = "Kill Astral Flares immediately" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
            { slot = "Raid", role = "All", text = "Save cooldowns for Evocation" },
        } },
        { name = "Terestian Illhoof", aliases = { "illhoof" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss and Kil'rek tank" },
            { slot = "Chains DPS", role = "DPS", text = "Kill Demon Chains immediately" },
            { slot = "Seed Control", role = "Ranged", text = "AoE imps" },
            { slot = "Healer 1", role = "Healer", text = "Tank and sacrifice target healer" },
        } },
        { name = "Shade of Aran", aliases = { "aran", "shade" }, jobs = {
            { slot = "Interrupt 1", role = "Melee", text = "Interrupt Frostbolt/Fireball" },
            { slot = "Interrupt 2", role = "Melee", text = "Backup interrupt" },
            { slot = "Elemental Control", role = "DPS", text = "Control or kill water elementals" },
            { slot = "Raid", role = "All", text = "Do not move during Flame Wreath" },
        } },
        { name = "Netherspite", aliases = { "netherspite" }, jobs = {
            { slot = "Red Beam 1", role = "Tank", text = "First red beam soak" },
            { slot = "Red Beam 2", role = "Tank", text = "Second red beam soak" },
            { slot = "Green Beam", role = "Healer", text = "Manage green beam rotation" },
            { slot = "Blue Beam", role = "DPS", text = "Manage blue beam rotation" },
            { slot = "Raid", role = "All", text = "Move out during banish phase" },
        } },
        { name = "Chess Event", aliases = { "chess" }, jobs = {
            { slot = "King", role = "Any", text = "Control king" },
            { slot = "Healer Pieces", role = "Any", text = "Control healer pieces" },
            { slot = "DPS Pieces", role = "Any", text = "Control damage pieces" },
        } },
        { name = "Prince Malchezaar", aliases = { "prince", "malchezaar" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank positioned away from infernals" },
            { slot = "Healer 1", role = "Healer", text = "Main tank healer" },
            { slot = "Healer 2", role = "Healer", text = "Raid and enfeeble recovery healer" },
            { slot = "Raid", role = "All", text = "Avoid infernals and recover after Enfeeble" },
        } },
        { name = "Nightbane", aliases = { "nightbane" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Ground phase boss tank" },
            { slot = "Skeleton Tank", role = "Tank", text = "Gather skeletons during air phase" },
            { slot = "Fear Break", role = "Any", text = "Help cover fear breaks or tremor" },
            { slot = "Healer 1", role = "Healer", text = "Main tank healer" },
            { slot = "Raid", role = "All", text = "Stack for skeletons and avoid Charred Earth" },
        } },
    },
}

RaidJobberProfiles.gruul = {
    name = "Gruul's Lair",
    aliases = {
        ["gruul's lair"] = true,
        ["gruuls lair"] = true,
        ["gruul"] = true,
        ["gl"] = true,
    },
    bosses = {
        {
            name = "High King Maulgar",
            aliases = { "maulgar", "high king maulgar" },
            jobs = {
                { slot = "Maulgar Tank", role = "Tank", text = "Tank High King Maulgar" },
                { slot = "Krosh Tank", role = "Ranged", text = "Mage tank Krosh Firehand with Spellsteal shield" },
                { slot = "Olm Tank", role = "Tank", text = "Tank Olm the Summoner and control felhounds" },
                { slot = "Kiggler Tank", role = "Ranged", text = "Ranged tank or kite Kiggler the Crazed" },
                { slot = "Blindeye Tank", role = "Tank", text = "Tank Blindeye the Seer" },
                { slot = "Blindeye Interrupt 1", role = "Melee", text = "Interrupt Blindeye heals" },
                { slot = "Blindeye Interrupt 2", role = "Melee", text = "Backup Blindeye heal interrupt" },
                { slot = "Krosh Healer", role = "Healer", text = "Heal Krosh ranged tank" },
                { slot = "Maulgar Healer", role = "Healer", text = "Heal Maulgar tank" },
                { slot = "Raid", role = "All", text = "Kill order: Blindeye, Olm, Kiggler, Krosh, Maulgar" },
            },
        },
        {
            name = "Gruul the Dragonkiller",
            aliases = { "gruul" },
            jobs = {
                { slot = "Tank 1", role = "Tank", text = "Main boss tank" },
                { slot = "Tank 2", role = "Tank", text = "Hurtful Strike soak off-tank" },
                { slot = "Healer 1", role = "Healer", text = "Main tank healer" },
                { slot = "Healer 2", role = "Healer", text = "Off-tank healer" },
                { slot = "Shatter Caller", role = "Any", text = "Call spread before Shatter" },
                { slot = "Raid", role = "All", text = "Spread after Ground Slam and watch Cave In" },
            },
        },
    },
}

RaidJobberProfiles.magtheridon = {
    name = "Magtheridon's Lair",
    aliases = {
        ["magtheridon's lair"] = true,
        ["magtheridons lair"] = true,
        ["magtheridon"] = true,
        ["mag"] = true,
    },
    bosses = {
        {
            name = "Magtheridon",
            aliases = { "magtheridon", "mag" },
            jobs = {
                { slot = "Channeler Tank 1", role = "Tank", text = "Tank Hellfire Channeler 1" },
                { slot = "Channeler Tank 2", role = "Tank", text = "Tank Hellfire Channeler 2" },
                { slot = "Channeler Tank 3", role = "Tank", text = "Tank Hellfire Channeler 3" },
                { slot = "Channeler Tank 4", role = "Tank", text = "Tank Hellfire Channeler 4" },
                { slot = "Channeler Tank 5", role = "Tank", text = "Tank Hellfire Channeler 5" },
                { slot = "Interrupt 1", role = "Melee", text = "Interrupt Shadow Bolt Volley on assigned channeler" },
                { slot = "Interrupt 2", role = "Melee", text = "Backup Shadow Bolt Volley interrupt" },
                { slot = "Cube Clicker 1", role = "Any", text = "Click Manticron Cube position 1" },
                { slot = "Cube Clicker 2", role = "Any", text = "Click Manticron Cube position 2" },
                { slot = "Cube Clicker 3", role = "Any", text = "Click Manticron Cube position 3" },
                { slot = "Cube Clicker 4", role = "Any", text = "Click Manticron Cube position 4" },
                { slot = "Cube Clicker 5", role = "Any", text = "Click Manticron Cube position 5" },
                { slot = "Cube Backup 1", role = "Any", text = "Backup cube clicker" },
                { slot = "Cube Backup 2", role = "Any", text = "Backup cube clicker" },
                { slot = "Healer 1", role = "Healer", text = "Main tank healer" },
                { slot = "Healer 2", role = "Healer", text = "Channeler tank healer" },
                { slot = "Raid", role = "All", text = "Click cubes during Blast Nova and avoid cave-in" },
            },
        },
    },
}

RaidJobberProfiles.tk = {
    name = "Tempest Keep",
    aliases = {
        ["tempest keep"] = true,
        ["the eye"] = true,
        ["tk"] = true,
    },
    bosses = {
        { name = "Al'ar", aliases = { "alar", "al'ar" }, jobs = {
            { slot = "Platform Tank 1", role = "Tank", text = "Tank Al'ar on assigned platform" },
            { slot = "Platform Tank 2", role = "Tank", text = "Rotate platforms and pick up boss" },
            { slot = "Ember Tank", role = "Tank", text = "Pick up Embers of Al'ar" },
            { slot = "Healer 1", role = "Healer", text = "Platform tank healer" },
            { slot = "Raid", role = "All", text = "Move from Flame Quills and kill Embers" },
        } },
        { name = "Void Reaver", aliases = { "void reaver", "vr" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Highest-threat boss tank" },
            { slot = "Tank 2", role = "Tank", text = "Threat backup tank" },
            { slot = "Tank 3", role = "Tank", text = "Threat backup tank" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
            { slot = "Raid", role = "All", text = "Avoid Arcane Orb and watch threat" },
        } },
        { name = "High Astromancer Solarian", aliases = { "solarian" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Tank Solarian after split phase" },
            { slot = "Add Tank", role = "Tank", text = "Pick up priests and agents" },
            { slot = "Interrupt 1", role = "Melee", text = "Interrupt Solarian priests" },
            { slot = "Healer 1", role = "Healer", text = "Raid healing and Wrath target support" },
            { slot = "Raid", role = "All", text = "Wrath target runs out immediately" },
        } },
        { name = "Kael'thas Sunstrider", aliases = { "kael", "kael'thas", "kt" }, jobs = {
            { slot = "Thaladred Tank", role = "Tank", text = "Control Thaladred positioning" },
            { slot = "Sanguinar Tank", role = "Tank", text = "Tank Lord Sanguinar" },
            { slot = "Capernian Tank", role = "Ranged", text = "Ranged tank Capernian" },
            { slot = "Telonicus Tank", role = "Tank", text = "Tank Master Engineer Telonicus" },
            { slot = "Weapon Tank", role = "Tank", text = "Gather legendary weapons" },
            { slot = "Interrupt 1", role = "Melee", text = "Interrupt advisors or Phoenix casts" },
            { slot = "Phoenix Tank", role = "Tank", text = "Pick up Phoenix adds" },
            { slot = "Healer 1", role = "Healer", text = "Main tank healer" },
            { slot = "Raid", role = "All", text = "Loot weapons, handle MC, avoid Flamestrike" },
        } },
    },
}

RaidJobberProfiles.bt = {
    name = "Black Temple",
    aliases = {
        ["black temple"] = true,
        ["bt"] = true,
    },
    bosses = {
        { name = "High Warlord Naj'entus", aliases = { "najentus", "naj'entus" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Spine Caller", role = "Any", text = "Call Impaling Spine removal and shield break" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
            { slot = "Raid", role = "All", text = "Top raid before shield break" },
        } },
        { name = "Supremus", aliases = { "supremus" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank during tank phase" },
            { slot = "Tank 2", role = "Tank", text = "Hateful strike soak backup" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
            { slot = "Raid", role = "All", text = "Kite during chase and avoid volcanoes" },
        } },
        { name = "Shade of Akama", aliases = { "akama", "shade of akama" }, jobs = {
            { slot = "Door Tank 1", role = "Tank", text = "Tank adds from left door" },
            { slot = "Door Tank 2", role = "Tank", text = "Tank adds from right door" },
            { slot = "Channeler DPS", role = "DPS", text = "Kill channelers and sorcerers" },
            { slot = "Healer 1", role = "Healer", text = "Door tank healer" },
        } },
        { name = "Teron Gorefiend", aliases = { "teron", "gorefiend" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Construct Coach", role = "Any", text = "Call Shadow of Death construct control" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
            { slot = "Raid", role = "All", text = "Shadow of Death players kill constructs" },
        } },
        { name = "Gurtogg Bloodboil", aliases = { "gurtogg", "bloodboil" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Main boss tank" },
            { slot = "Tank 2", role = "Tank", text = "Tank rotation backup" },
            { slot = "Tank 3", role = "Tank", text = "Tank rotation backup" },
            { slot = "Bloodboil Group 1", role = "Any", text = "Rotate in for Bloodboil stacks" },
            { slot = "Healer 1", role = "Healer", text = "Fel Rage target healer" },
            { slot = "Raid", role = "All", text = "Maintain Bloodboil group rotation" },
        } },
        { name = "Reliquary of Souls", aliases = { "reliquary", "ros" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Phase 1 boss tank" },
            { slot = "Interrupt 1", role = "Melee", text = "Primary Deaden interrupt" },
            { slot = "Interrupt 2", role = "Melee", text = "Backup Deaden interrupt" },
            { slot = "Dispel 1", role = "Healer", text = "Soul Drain dispel" },
            { slot = "Raid", role = "All", text = "Stop healing in Phase 1 and manage threat in Phase 2" },
        } },
        { name = "Mother Shahraz", aliases = { "mother", "shahraz" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank with shadow resistance" },
            { slot = "Tank 2", role = "Tank", text = "Saber Lash soak" },
            { slot = "Tank 3", role = "Tank", text = "Saber Lash soak" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
            { slot = "Raid", role = "All", text = "Spread for Fatal Attraction and wear resistance plan" },
        } },
        { name = "The Illidari Council", aliases = { "council", "illidari council" }, jobs = {
            { slot = "Gathios Tank", role = "Tank", text = "Tank Gathios the Shatterer" },
            { slot = "Malande Tank", role = "Tank", text = "Tank Lady Malande and interrupt heals" },
            { slot = "Zerevor Tank", role = "Ranged", text = "Ranged tank High Nethermancer Zerevor" },
            { slot = "Veras Tank", role = "Tank", text = "Handle Veras when visible" },
            { slot = "Interrupt 1", role = "Melee", text = "Interrupt Lady Malande heals" },
            { slot = "Mage Tank Healer", role = "Healer", text = "Heal Zerevor tank" },
        } },
        { name = "Illidan Stormrage", aliases = { "illidan" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Flame Tank 1", role = "Tank", text = "Tank Flame of Azzinoth left" },
            { slot = "Flame Tank 2", role = "Tank", text = "Tank Flame of Azzinoth right" },
            { slot = "Demon Tank", role = "Ranged", text = "Tank demon phase if using warlock strategy" },
            { slot = "Trap Soaker", role = "Any", text = "Handle Shadow Prison or trap calls" },
            { slot = "Healer 1", role = "Healer", text = "Main tank healer" },
            { slot = "Raid", role = "All", text = "Avoid eye beams, parasites, and flame patches" },
        } },
    },
}

RaidJobberProfiles.hyjal = {
    name = "Mount Hyjal",
    aliases = {
        ["mount hyjal"] = true,
        ["hyjal summit"] = true,
        ["hyjal"] = true,
        ["mh"] = true,
    },
    bosses = {
        { name = "Rage Winterchill", aliases = { "rage", "winterchill" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Decurse 1", role = "Healer", text = "Remove Death and Decay related pressure and cover dispels" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
            { slot = "Raid", role = "All", text = "Move from Death and Decay and avoid Icebolt deaths" },
        } },
        { name = "Anetheron", aliases = { "anetheron" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Infernal Tank", role = "Tank", text = "Pick up Infernals away from raid" },
            { slot = "Infernal Healer", role = "Healer", text = "Heal Infernal tank" },
            { slot = "Raid", role = "All", text = "Sleep target calls and Infernal movement" },
        } },
        { name = "Kaz'rogal", aliases = { "kazrogal", "kaz'rogal" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
            { slot = "Mana Watch", role = "Healer", text = "Call low mana before Mark explosions" },
            { slot = "Raid", role = "All", text = "Manage mana and move out if about to explode" },
        } },
        { name = "Azgalor", aliases = { "azgalor" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Doom Guard Tank", role = "Tank", text = "Pick up Doomguard adds" },
            { slot = "Silence Healer", role = "Healer", text = "Cover healing during silence windows" },
            { slot = "Raid", role = "All", text = "Doom target moves to add tank area" },
        } },
        { name = "Archimonde", aliases = { "archimonde" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Decurse 1", role = "Healer", text = "Primary Grip of the Legion decurse" },
            { slot = "Decurse 2", role = "Healer", text = "Backup decurse" },
            { slot = "Fear Break", role = "Any", text = "Cover fear break or Tremor Totem" },
            { slot = "Raid", role = "All", text = "Use Tears on air burst and avoid fire" },
        } },
    },
}

RaidJobberProfiles.za = {
    name = "Zul'Aman",
    aliases = {
        ["zul'aman"] = true,
        ["zulaman"] = true,
        ["za"] = true,
    },
    bosses = {
        { name = "Nalorakk", aliases = { "nalorakk", "bear" }, jobs = {
            { slot = "Human Tank", role = "Tank", text = "Tank human form" },
            { slot = "Bear Tank", role = "Tank", text = "Tank bear form" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
            { slot = "Raid", role = "All", text = "Tank swap between forms" },
        } },
        { name = "Akil'zon", aliases = { "akilzon", "akil'zon", "eagle" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Storm Caller", role = "Any", text = "Call Electrical Storm stack target" },
            { slot = "Healer 1", role = "Healer", text = "Raid healer" },
            { slot = "Raid", role = "All", text = "Stack under storm target and spread after" },
        } },
        { name = "Jan'alai", aliases = { "janalai", "jan'alai", "dragonhawk" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Hatcher Control", role = "DPS", text = "Control hatchers and eggs" },
            { slot = "Bomb Caller", role = "Any", text = "Call safe movement during Fire Bombs" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
        } },
        { name = "Halazzi", aliases = { "halazzi", "lynx" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Spirit Tank", role = "Tank", text = "Tank Spirit of the Lynx" },
            { slot = "Totem DPS", role = "DPS", text = "Kill Corrupted Lightning Totem" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
        } },
        { name = "Hex Lord Malacrass", aliases = { "malacrass", "hex lord" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Crowd Control 1", role = "Any", text = "Control dangerous add" },
            { slot = "Crowd Control 2", role = "Any", text = "Control second dangerous add" },
            { slot = "Interrupt 1", role = "Melee", text = "Interrupt Spirit Bolts or stolen casts" },
            { slot = "Healer 1", role = "Healer", text = "Raid healer" },
        } },
        { name = "Zul'jin", aliases = { "zuljin", "zul'jin" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Boss tank" },
            { slot = "Claw Rage Healer", role = "Healer", text = "Heal Claw Rage target" },
            { slot = "Dispel 1", role = "Healer", text = "Cover phase dispels where needed" },
            { slot = "Raid", role = "All", text = "Adjust positioning and stops per animal phase" },
        } },
    },
}

RaidJobberProfiles.sunwell = {
    name = "Sunwell Plateau",
    aliases = {
        ["sunwell plateau"] = true,
        ["sunwell"] = true,
        ["swp"] = true,
    },
    bosses = {
        { name = "Kalecgos", aliases = { "kalecgos", "kalec" }, jobs = {
            { slot = "Dragon Tank", role = "Tank", text = "Tank Kalecgos in dragon realm" },
            { slot = "Demon Tank", role = "Tank", text = "Tank Sathrovarr in demon realm" },
            { slot = "Portal Group 1", role = "Any", text = "First portal rotation" },
            { slot = "Portal Group 2", role = "Any", text = "Second portal rotation" },
            { slot = "Decurse 1", role = "Healer", text = "Primary Curse of Boundless Agony decurse" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
        } },
        { name = "Brutallus", aliases = { "brutallus", "brut" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "First Burn/Swing tank" },
            { slot = "Tank 2", role = "Tank", text = "Second Burn/Swing tank" },
            { slot = "Burn Group 1", role = "Any", text = "Burn soak or movement group 1" },
            { slot = "Burn Group 2", role = "Any", text = "Burn soak or movement group 2" },
            { slot = "Healer 1", role = "Healer", text = "Tank healer" },
            { slot = "Healer 2", role = "Healer", text = "Burn target healer" },
        } },
        { name = "Felmyst", aliases = { "felmyst" }, jobs = {
            { slot = "Tank 1", role = "Tank", text = "Ground phase boss tank" },
            { slot = "Dispel 1", role = "Healer", text = "Primary Encapsulate or gas nova dispel support" },
            { slot = "Mass Dispel", role = "Healer", text = "Cover gas nova mass dispel if available" },
            { slot = "Air Phase Caller", role = "Any", text = "Call fog beam movement" },
            { slot = "Raid", role = "All", text = "Avoid fog beam and stack after air phase" },
        } },
        { name = "Eredar Twins", aliases = { "twins", "eredar twins", "sacrolash", "alythess" }, jobs = {
            { slot = "Sacrolash Tank", role = "Tank", text = "Tank Lady Sacrolash" },
            { slot = "Alythess Tank", role = "Ranged", text = "Tank Grand Warlock Alythess" },
            { slot = "Conflagration Healer", role = "Healer", text = "Heal Conflagration targets" },
            { slot = "Shadow Nova Healer", role = "Healer", text = "Raid healing during Shadow Nova" },
            { slot = "Raid", role = "All", text = "Handle Shadow/Fire debuffs and Conflagration movement" },
        } },
        { name = "M'uru", aliases = { "muru", "m'uru" }, jobs = {
            { slot = "Humanoid Tank 1", role = "Tank", text = "Tank humanoid adds left" },
            { slot = "Humanoid Tank 2", role = "Tank", text = "Tank humanoid adds right" },
            { slot = "Void Sentinel Tank", role = "Tank", text = "Tank Void Sentinels" },
            { slot = "Add Control 1", role = "DPS", text = "Control or kill spawned adds" },
            { slot = "Interrupt 1", role = "Melee", text = "Interrupt dark fiend or caster priorities" },
            { slot = "Healer 1", role = "Healer", text = "Add tank healer" },
            { slot = "Raid", role = "All", text = "Swap cleanly into Entropius phase" },
        } },
        { name = "Kil'jaeden", aliases = { "kiljaeden", "kil'jaeden", "kj" }, jobs = {
            { slot = "Orb DPS", role = "Ranged", text = "Kill Shield Orbs immediately" },
            { slot = "Dragon Controller 1", role = "Any", text = "Use blue dragon shield and breath" },
            { slot = "Dragon Controller 2", role = "Any", text = "Backup dragon controller" },
            { slot = "Darkness Caller", role = "Any", text = "Call Darkness of a Thousand Souls shield" },
            { slot = "Healer 1", role = "Healer", text = "Raid healer" },
            { slot = "Raid", role = "All", text = "Stack for shields and avoid fire blooms" },
        } },
    },
}
