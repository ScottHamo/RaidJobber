# RaidJobber

RaidJobber is a small World of Warcraft Burning Crusade Classic Anniversary addon scaffold for scanning your current raid and assigning boss-specific jobs in the current instance.

## Install

Copy the `RaidJobber` folder into:

```text
World of Warcraft/_anniversary_/Interface/AddOns/
```

Then restart the game or run:

```text
/reload
```

## Commands

```text
/rj help
/rj scan
/rj raid
/rj ui
/rj minimap
/rj minimap reset
/rj profiles
/rj bosses bt
/rj load bt
/rj role Scott = Holy Paladin
/rj suggest hydross
/rj assign hydross = Scott: Frost resistance tank
/rj show hydross
/rj rw hydross
/rj test raid
/rj test off
/rj clear hydross
```

Jobs are stored by instance name, then boss name, in the `RaidJobberDB` saved variable.

## Interface

Open the in-game interface with:

```text
/rj ui
```

The window lets you choose a raid profile, choose a boss from that raid, scan the raid, load the selected raid profile, generate suggested assignments, edit each job row directly, announce assignments to raid warning, and clear the selected boss.

When you use `Raid Warn` or `/rj rw boss`, the addon sends compact grouped raid warnings first, then whispers each real player their assignment afterward. If you are not raid leader or assistant, it falls back to raid chat instead.

Bosses can define phase tabs. Lady Vashj is organized into `All`, `P1/P3`, `Phase 2`, and `Phase 3`, so the assignment table can focus on the jobs for one phase at a time.

The addon also creates a minimap button. Left-click it to open the interface, drag it to reposition it, or right-click it to hide it. Use `/rj minimap` to show it again, or `/rj minimap reset` to force it back to the default position.

## Raid Profiles

The addon includes profiles for:

- `kara` - Karazhan
- `gruul` - Gruul's Lair
- `magtheridon` - Magtheridon's Lair
- `ssc` - Serpentshrine Cavern
- `tk` - Tempest Keep
- `bt` - Black Temple
- `hyjal` - Mount Hyjal
- `za` - Zul'Aman
- `sunwell` - Sunwell Plateau

Use the raid dropdown in `/rj ui` to switch profiles without typing commands. The `Load Raid` button loads the currently selected raid profile. Slash commands such as `/rj load bt` still work if you prefer them.

Run `/rj scan`, optionally add role/spec hints like `/rj role Playername = Holy Paladin`, then run `/rj suggest hydross` to auto-fill that boss from the scanned raid.

The suggestion engine prefers sensible candidates for common raid jobs. For example, Holy Paladins are weighted heavily for tank-healing jobs, Hunters for Misdirection jobs, Warlocks for ranged tanking jobs, melee with interrupts for interrupt jobs, and ranged control classes for kiting/slow jobs. It also gives a small preference to raiders from your own guild; same-guild raiders are marked with `*` in the UI raid list.

Lady Vashj has a custom assignment profile with four numbered area rows. Each area row groups one melee, one healer, and one hunter-preferred ranged DPS together, for example `Melee: Player1, Healer: Player2, Ranged: Player3`. It also assigns a Holy Paladin to the middle with Righteous Fury, hunters to Phase 3 spore bats, and a strider kiter with preference Mage, then Shaman, then Hunter.

## Test Mode

Use `/rj test raid` to load a sample raid and enable test mode. In test mode, `/rj rw boss` prints `[TEST RW]` lines to your local chat frame instead of sending real raid warnings. Outside test mode, `/rj rw boss` and the `Raid Warn` button send one raid warning for the header and one raid warning for each assignment.

Example:

```text
/rj test raid
/rj suggest vashj
/rj show vashj
/rj rw vashj
/rj test off
```

## Notes

TBC role detection is limited. The addon checks `UnitGroupRolesAssigned` if the client exposes it, then falls back to a class-based estimate. For serious raid leading, the next useful step is to add a small UI where you can manually override each raider's role.
