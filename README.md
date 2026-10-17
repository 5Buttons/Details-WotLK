# Details! Damage Meter – WotLK 3.3.5a

A port of the **current retail Details!** damage meter (build `#Details.20261006.15326.172`) for the World of Warcraft **3.3.5a** client.

Started as an update for Bunny67 backport but it ended more in a complete rebase of retail Details!. 


## Installation

1. Download the repository (Code → Download ZIP).
2. Copy the folders into `World of Warcraft\Interface\AddOns\`:
   - `Details` (required)
   - `Details_EncounterDetails`, `Details_TinyThreat`, `Details_DataStorage`, `Details_SunderCount` (optional plugins)
3. Coming from an older Details backport? Delete or rename `WTF\Account\<ACCOUNT>\SavedVariables\Details.lua`, because the old data format is not compatible.
4. Restart the client completely; a `/reload` is not enough for new texture files.

## Plugins

| Plugin | Status |
| --- | --- |
| Encounter Details | ported from retail |
| Tiny Threat | ported from retail |
| Data Storage | ported from retail |
| Sunder Count | kept for 3.3.5 (counts Sunder Armor + Devastate) |

## Bug reports

Please open an [issue](https://github.com/5Buttons/Details-WotLK/issues) and include the full Lua error (for example from BugSack) and steps to reproduce it.

## Credits

- [Details!](https://github.com/Tercioo/Details-Damage-Meter) by Terciob and contributors
- Original WotLK backport by [Bunny67](https://github.com/Bunny67/Details-WotLK)
