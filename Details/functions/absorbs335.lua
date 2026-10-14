--[3.3.5]

local Details = _G.Details
local addonName, Details222 = ...
local C_Timer = C_Timer
local bit_band = bit.band
local ipairs, table_insert, table_remove, table_sort = ipairs, table.insert, table.remove, table.sort

local Absorbs = {}
Details222.Absorbs335 = Absorbs

	Absorbs.MageFireWardSpells = {
		[543] = 30 , -- Fire Ward (Mage) Rank 1
		[8457] = 30,
		[8458] = 30,
		[10223] = 30,
		[10225] = 30,
		[27128] = 30,
		[43010] = 30, -- Rank 7
	}

	Absorbs.MageFrostWardSpells = {
		[6143] = 30, -- Frost Ward (Mage) Rank 1
		[8461] = 30,
		[8462] = 30,
		[10177] = 30,
		[28609] = 30,
		[32796] = 30,
		[43012] = 30, -- Rank 7
	}

	Absorbs.WarlockShadowWardSpells = {
		[6229] = 30, -- Shadow Ward (warlock) Rank 1
		[11739] = 30,
		[11740] = 30,
		[28610] = 30,
		[47890] = 30,
		[47891] = 30, -- Rank 6
	}

	Absorbs.MageIceBarrierSpells = {
		[11426] = 60, -- Ice Barrier (Mage) Rank 1
		[13031] = 60,
		[13032] = 60,
		[13033] = 60,
		[27134] = 60,
		[33405] = 60,
		[43038] = 60,
		[43039] = 60, -- Rank 8
	}

	Absorbs.WarlockSacrificeSpells = {
		[7812] = 30, -- Sacrifice (warlock) Rank 1
		[19438] = 30,
		[19440] = 30,
		[19441] = 30,
		[19442] = 30,
		[19443] = 30,
		[27273] = 30,
		[47985] = 30,
		[47986] = 30, -- rank 9
	}

	Absorbs.AbsorbSpells = {
		[48707] = 5, -- Anti-Magic Shell (DK) Rank 1 -- Does not currently seem to show tracable combat log events. It shows energizes which do not reveal the amount of damage absorbed
		[51052] = 10, -- Anti-Magic Zone (DK)( Rank 1 (Correct spellID?)
		[51271] = 20, -- Unbreakable Armor (DK)
		-- Druid
		[62606] = 10, -- Savage Defense proc. (Druid) Tooltip of the original spell doesn't clearly state that this is an absorb, but the buff does.
		-- Mage
		[11426] = 60, -- Ice Barrier (Mage) Rank 1
		[13031] = 60,
		[13032] = 60,
		[13033] = 60,
		[27134] = 60,
		[33405] = 60,
		[43038] = 60,
		[43039] = 60, -- Rank 8
		[6143] = 30, -- Frost Ward (Mage) Rank 1
		[8461] = 30,
		[8462] = 30,
		[10177] = 30,
		[28609] = 30,
		[32796] = 30,
		[43012] = 30, -- Rank 7
		[1463] = 60, --  Mana shield (Mage) Rank 1
		[8494] = 60,
		[8495] = 60,
		[10191] = 60,
		[10192] = 60,
		[10193] = 60,
		[27131] = 60,
		[43019] = 60,
		[43020] = 60, -- Rank 9
		[543] = 30 , -- Fire Ward (Mage) Rank 1
		[8457] = 30,
		[8458] = 30,
		[10223] = 30,
		[10225] = 30,
		[27128] = 30,
		[43010] = 30, -- Rank 7
		-- Paladin
		[58597] = 6, -- Sacred Shield (Paladin) proc (Fixed, thanks to Julith)
		-- Priest
		[17] = 30, -- Power Word: Shield (Priest) Rank 1
		[592] = 30,
		[600] = 30,
		[3747] = 30,
		[6065] = 30,
		[6066] = 30,
		[10898] = 30,
		[10899] = 30,
		[10900] = 30,
		[10901] = 30,
		[25217] = 30,
		[25218] = 30,
		[48065] = 30,
		[48066] = 30, -- Rank 14
		[47509] = 12, -- Divine Aegis (Priest) Rank 1
		[47511] = 12,
		[47515] = 12, -- Divine Aegis (Priest) Rank 3 (Some of these are not actual buff spellIDs)
		[47753] = 12, -- Divine Aegis (Priest) Rank 1
		[54704] = 12, -- Divine Aegis (Priest) Rank 1
		[47788] = 10, -- Guardian Spirit  (Priest) (50 nominal absorb, this may not show in the CL)
		-- Warlock
		[7812] = 30, -- Sacrifice (warlock) Rank 1
		[19438] = 30,
		[19440] = 30,
		[19441] = 30,
		[19442] = 30,
		[19443] = 30,
		[27273] = 30,
		[47985] = 30,
		[47986] = 30, -- rank 9
		[6229] = 30, -- Shadow Ward (warlock) Rank 1
		[11739] = 30,
		[11740] = 30,
		[28610] = 30,
		[47890] = 30,
		[47891] = 30, -- Rank 6
		-- Consumables
		[29674] = 86400, -- Lesser Ward of Shielding
		[29719] = 86400, -- Greater Ward of Shielding (these have infinite duration, set for a day here :P)
		[29701] = 86400,
		[28538] = 120, -- Major Holy Protection Potion
		[28537] = 120, -- Major Shadow
		[28536] = 120, --  Major Arcane
		[28513] = 120, -- Major Nature
		[28512] = 120, -- Major Frost
		[28511] = 120, -- Major Fire
		[7233] = 120, -- Fire
		[7239] = 120, -- Frost
		[7242] = 120, -- Shadow Protection Potion
		[7245] = 120, -- Holy
		[7254] = 120, -- Nature Protection Potion
		[53915] = 120, -- Mighty Shadow Protection Potion
		[53914] = 120, -- Mighty Nature Protection Potion
		[53913] = 120, -- Mighty Frost Protection Potion
		[53911] = 120, -- Mighty Fire
		[53910] = 120, -- Mighty Arcane
		[17548] = 120, --  Greater Shadow
		[17546] = 120, -- Greater Nature
		[17545] = 120, -- Greater Holy
		[17544] = 120, -- Greater Frost
		[17543] = 120, -- Greater Fire
		[17549] = 120, -- Greater Arcane
		[28527] = 15, -- Fel Blossom
		[29432] = 3600, -- Frozen Rune usage (Naxx classic)
		[36481] = 4, -- Arcane Barrier (TK Kael'Thas) Shield
		[57350] = 6, -- Darkmoon Card: Illusion
		[17252] = 30, -- Mark of the Dragon Lord (LBRS epic ring) usage
		[25750] = 15, -- Defiler's Talisman/Talisman of Arathor Rank 1
		[25747] = 15,
		[25746] = 15,
		[23991] = 15,
		[31000] = 300, -- Pendant of Shadow's End Usage
		[30997] = 300, -- Pendant of Frozen Flame Usage
		[31002] = 300, -- Pendant of the Null Rune
		[30999] = 300, -- Pendant of Withering
		[30994] = 300, -- Pendant of Thawing
		[31000] = 300, --
		[23506]= 20, -- Arena Grand Master Usage (Aura of Protection)
		[12561] = 60, -- Goblin Construction Helmet usage
		[31771] = 20, -- Runed Fungalcap usage
		[21956] = 10, -- Mark of Resolution usage
		[29506] = 20, -- The Burrower's Shell
		[4057] = 60, -- Flame Deflector
		[4077] = 60, -- Ice Deflector
		[39228] = 20, -- Argussian Compass (may not be an actual absorb)
		[27779] = 30, -- Divine Protection - Priest dungeon set 1/2  Proc
		[11657] = 20, -- Jang'thraze (Zul Farrak) proc
		[10368] = 15, -- Uther's Strength proc
		[37515] = 15, -- Warbringer Armor Proc
		[42137] = 86400, -- Greater Rune of Warding Proc
		[26467] = 30, -- Scarab Brooch proc
		[26470] = 8, -- Scarab Brooch proc (actual)
		[27539] = 6, -- Thick Obsidian Breatplate proc
		[28810] = 30, -- Faith Set Proc Armor of Faith
		[54808] = 12, -- Noise Machine proc Sonic Shield
		[55019] = 12, -- Sonic Shield (one of these too ought to be wrong)
		[64413] = 8, -- Val'anyr, Hammer of Ancient Kings proc Protection of Ancient Kings
		-- Misc
		[40322] = 30, -- Teron's Vengeful Spirit Ghost - Spirit Shield
		[65874] = 15, -- Twin Val'kyr's Shield of Darkness 175000
		[67257] = 15, -- 300000
		[67256] = 15, -- 700000
		[67258] = 15, -- 1200000
		[65858] = 15, -- Twin Val'kyr's Shield of Lights 175000
		[67260] = 15, -- 300000
		[67259] = 15, -- 700000
		[67261] = 15, -- 1200000
		[65686] = 86400, -- Twin Val'kyr Light Essence
		[65684] = 86400, -- Twin Val'kyr Dark Essence
	}

local fireWard = Absorbs.MageFireWardSpells
local frostWard = Absorbs.MageFrostWardSpells
local shadowWard = Absorbs.WarlockShadowWardSpells
local iceBarrier = Absorbs.MageIceBarrierSpells
local sacrifice = Absorbs.WarlockSacrificeSpells
local absorbSpells = Absorbs.AbsorbSpells

local SCHOOL_FIRE, SCHOOL_FROST, SCHOOL_SHADOW = 0x4, 0x10, 0x20
local VALKYR_LIGHT, VALKYR_DARK = 65686, 65684
local SACRED_SHIELD, FEL_BLOSSOM, DIVINE_AEGIS = 58597, 28527, 47753

local shields = {}
Absorbs.shields = shields

local function priority(shield)
	local spellId = shield.spellId
	if (spellId == VALKYR_LIGHT or spellId == VALKYR_DARK) then return 0 end
	if (frostWard[spellId] or fireWard[spellId] or shadowWard[spellId]) then return 1 end
	if (spellId == SACRED_SHIELD) then return 2 end
	if (spellId == FEL_BLOSSOM) then return 3 end
	if (spellId == DIVINE_AEGIS) then return 4 end
	if (iceBarrier[spellId]) then return 5 end
	if (sacrifice[spellId]) then return 6 end
	return 7
end

local function sortShields(a, b)
	local pa, pb = priority(a), priority(b)
	if (pa ~= pb) then
		return pa < pb
	end
	return a.timestamp < b.timestamp
end

function Absorbs.IsAbsorbSpell(spellId)
	return absorbSpells[spellId] or spellId == VALKYR_LIGHT or spellId == VALKYR_DARK
end

function Absorbs.OnAuraApplied(timestamp, sourceSerial, sourceName, sourceFlags, targetName, spellId, spellName, school)
	if (not targetName or not Absorbs.IsAbsorbSpell(spellId)) then
		return
	end
	local list = shields[targetName]
	if (not list) then
		list = {}
		shields[targetName] = list
	end
	for i = #list, 1, -1 do
		if (list[i].spellId == spellId and list[i].serial == sourceSerial) then
			table_remove(list, i)
		end
	end
	table_insert(list, {
		serial = sourceSerial or "",
		name = sourceName or ("[*] " .. (spellName or "?")),
		flags = sourceFlags or 0,
		spellId = spellId,
		spellName = spellName,
		school = school,
		timestamp = timestamp or 0,
	})
	table_sort(list, sortShields)
end

local function removeShield(targetName, sourceSerial, spellId)
	local list = shields[targetName]
	if (not list) then
		return
	end
	for i = #list, 1, -1 do
		if (list[i].spellId == spellId and list[i].serial == sourceSerial) then
			table_remove(list, i)
			break
		end
	end
	if (#list == 0) then
		shields[targetName] = nil
	end
end

function Absorbs.OnAuraRemoved(sourceSerial, targetName, spellId)
	if (not targetName or not Absorbs.IsAbsorbSpell(spellId) or not shields[targetName]) then
		return
	end
	C_Timer.After(0.1, function() removeShield(targetName, sourceSerial, spellId) end)
end

function Absorbs.FindShield(targetName, school)
	local list = shields[targetName]
	if (not list) then
		return nil
	end
	school = school or 1
	for _, shield in ipairs(list) do
		local spellId = shield.spellId
		if (spellId == VALKYR_LIGHT) then
			if (bit_band(school, SCHOOL_FIRE) ~= 0) then return nil end
		elseif (spellId == VALKYR_DARK) then
			if (bit_band(school, SCHOOL_SHADOW) ~= 0) then return nil end
		elseif (frostWard[spellId]) then
			if (bit_band(school, SCHOOL_FROST) ~= 0) then return shield end
		elseif (fireWard[spellId]) then
			if (bit_band(school, SCHOOL_FIRE) ~= 0) then return shield end
		elseif (shadowWard[spellId]) then
			if (bit_band(school, SCHOOL_SHADOW) ~= 0) then return shield end
		else
			return shield
		end
	end
	return nil
end

function Absorbs.OnAbsorbed(timestamp, targetSerial, targetName, targetFlags, amount, school)
	if (not amount or amount <= 0 or not targetName) then
		return
	end
	local shield = Absorbs.FindShield(targetName, school)
	if (shield and Details222.Parser.CreditShield) then
		Details222.Parser.CreditShield(timestamp, shield, targetSerial, targetName, targetFlags, amount)
	end
end

function Absorbs.Reset()
	Details:Destroy(shields)
end

local zoneFrame = CreateFrame("frame")
zoneFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
zoneFrame:SetScript("OnEvent", function()
	if (not Details.in_combat) then
		Absorbs.Reset()
	end
end)
