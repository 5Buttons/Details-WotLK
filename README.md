# Details! Damage Meter – WotLK 3.3.5a

A port of the **current retail Details!** damage meter (build `#Details.20261006.15326.172`) for the World of Warcraft **3.3.5a** client.

Started as an update for Bunny's backport but it ended more in a complete rebase of retail Details!. 


## Installation

1. Download the repository (Code → Download ZIP).
2. Copy the folders into `World of Warcraft\Interface\AddOns\`:
   - `Details` (required)
   - `Details_EncounterDetails`, `Details_TinyThreat`, `Details_DataStorage`, `Details_SunderCount` (optional plugins)
3. Coming from an older Details backport? Delete or rename `WTF\Account\<ACCOUNT>\SavedVariables\Details.lua`, because the old data format is not compatible.
4. Restart the client completely; a `/reload` is not enough for new texture files.

## Optional: Encounter Journal

If the [EncounterJournal](https://github.com/5Buttons/EncounterJournal) addon is installed, Details! also reads boss and instance data from it. EncounterJournal is an optional dependency only, so Details! loads normally without it.

What you get with it:
- **Boss portraits** next to boss segments in the segment menu
- **Instance artwork** as the tooltip background for raid and dungeon segments
- **Encounter information** for boss fights: Details! links each fight to the right boss and instance (proper names and icons instead of a plain "boss fight" entry)
- **Statistics window**: records can be filtered to current content (WotLK raids and dungeons)

## Bug reports

Please open an [issue](https://github.com/5Buttons/Details-WotLK/issues) and include the full Lua error (for example from BugSack) and steps to reproduce it.

## Credits

- [Details!](https://github.com/Tercioo/Details-Damage-Meter) by Terciob and contributors
- Original WotLK backport by [Bunny67](https://github.com/Bunny67/Details-WotLK)
