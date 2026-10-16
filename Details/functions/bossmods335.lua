--[3.3.5]

local Details = _G.Details
local addonName, Details222 = ...
local Compat = DetailsCompat335

local data = Details222.Encounters335
if (not data or not Compat) then
	return
end

local GetTime = GetTime
local tostring = tostring

local bossmods335 = {
	source = nil,
	encounterId = nil,
	deadBosses = {},
}
Details222.BossMods335 = bossmods335

local function getEncounterInfo(encounterId)
	local encounter = data.encounters[encounterId]
	if (encounter) then
		return encounter[1], encounter[4]
	end
end

local function getDifficultyAndSize()
	local _, instanceType, difficultyId, _, maxPlayers, _, _, _, groupSize = Compat.GetInstanceInfo()
	local size = (maxPlayers and maxPlayers > 0) and maxPlayers or groupSize
	return difficultyId, size, instanceType
end

local function startEncounter(source, encounterId, encounterName)
	if (bossmods335.encounterId) then
		return
	end
	local difficultyId, size = getDifficultyAndSize()
	bossmods335.source = source
	bossmods335.encounterId = encounterId
	Details:Destroy(bossmods335.deadBosses)
	if (Details.debug) then
		Details:Msg("(debug) [3.3.5] encounter start by", source, encounterId, encounterName)
	end
	Details.parser_functions:ENCOUNTER_START(encounterId, encounterName, difficultyId, size)
end

local function endEncounter(source, bIsKill)
	local encounterId = bossmods335.encounterId
	if (not encounterId or (source and bossmods335.source ~= source)) then
		return
	end
	local encounterName = getEncounterInfo(encounterId) or Details.encounter_table.name
	local difficultyId, size = getDifficultyAndSize()
	bossmods335.source = nil
	bossmods335.encounterId = nil
	if (Details.debug) then
		Details:Msg("(debug) [3.3.5] encounter end by", source, encounterId, bIsKill and "kill" or "wipe")
	end
	Details.parser_functions:ENCOUNTER_END(encounterId, encounterName, difficultyId, size, bIsKill and 1 or 0)
end
bossmods335.EndEncounter = endEncounter

--DBM

local function encounterFromDBMMod(mod)
	if (type(mod) ~= "table") then
		return
	end
	local modName = mod.localization and mod.localization.general and mod.localization.general.name
	local encounterId = data.dbmMods[tostring(mod.id)]

	if (not encounterId and mod.combatInfo) then
		local mob = mod.combatInfo.mob or mod.creatureId
		if (type(mob) == "number") then
			encounterId = data.creatures[mob]
		end
	end

	if (not encounterId) then
		encounterId = tonumber(mod.encounterId) or tonumber(mod.id) or mod.id
	end

	local encounterName = getEncounterInfo(encounterId) or modName or tostring(mod.id)
	return encounterId, encounterName
end

local dbmHooked = false
local function hookDBM()
	if (dbmHooked or not _G.DBM or type(_G.DBM.RegisterCallback) ~= "function") then
		return
	end
	dbmHooked = true

	DBM:RegisterCallback("DBM_Pull", function(event, mod)
		local encounterId, encounterName = encounterFromDBMMod(mod)
		if (encounterId) then
			if (bossmods335.source == "CLEU") then
				bossmods335.source, bossmods335.encounterId = nil, nil
			end
			startEncounter("DBM", encounterId, encounterName)
		end
	end)

	DBM:RegisterCallback("DBM_Kill", function(event, mod)
		endEncounter("DBM", true)
	end)

	DBM:RegisterCallback("DBM_Wipe", function(event, mod)
		endEncounter("DBM", false)
	end)

	DBM:RegisterCallback("DBM_SetStage", function(event, mod, modId, phase)
		local encounterTable = Details.encounter_table
		phase = tonumber(phase)
		if (not phase or not bossmods335.encounterId or not Details.in_combat or encounterTable.phase == phase) then
			return
		end
		Details:OnCombatPhaseChanged()
		encounterTable.phase = phase
		local currentCombat = Details:GetCurrentCombat()
		local combatTime = currentCombat:GetCombatTime()
		if (combatTime > 5) then
			table.insert(currentCombat.PhaseData, {phase, combatTime})
		end
		Details:SendEvent("COMBAT_ENCOUNTER_PHASE_CHANGED", nil, phase)
	end)

	if (Details.debug) then
		Details:Msg("(debug) [3.3.5] DBM boss mod callbacks registered.")
	end
end

local function isBossModActive()
	return dbmHooked
end

--[3.3.5]
function bossmods335.OnCreatureNpcId(npcId)
	if (bossmods335.encounterId or isBossModActive()) then
		return
	end
	local encounterId = data.creatures[npcId]
	if (encounterId) then
		local encounterName = getEncounterInfo(encounterId) or tostring(encounterId)
		startEncounter("CLEU", encounterId, encounterName)
	end
end

function bossmods335.OnUnitDied(guid)
	if (bossmods335.source ~= "CLEU") then
		return
	end
	local npcId = Compat.GetNpcIdFromGuid(guid)
	if (npcId == 0) then
		return
	end
	local _, bossCreatures = getEncounterInfo(bossmods335.encounterId)
	if (not bossCreatures) then
		return
	end
	local isBoss = false
	for _, creatureId in ipairs(bossCreatures) do
		if (creatureId == npcId) then
			isBoss = true
			break
		end
	end
	if (not isBoss) then
		return
	end
	bossmods335.deadBosses[npcId] = true
	for _, creatureId in ipairs(bossCreatures) do
		if (not bossmods335.deadBosses[creatureId]) then
			return
		end
	end
	endEncounter("CLEU", true)
end

local function isGroupInCombat()
	if (UnitAffectingCombat("player")) then
		return true
	end
	local raidMembers = GetNumRaidMembers()
	if (raidMembers > 0) then
		for i = 1, raidMembers do
			if (UnitAffectingCombat("raid" .. i) and not UnitIsDeadOrGhost("raid" .. i)) then
				return true
			end
		end
		return false
	end
	for i = 1, GetNumPartyMembers() do
		if (UnitAffectingCombat("party" .. i) and not UnitIsDeadOrGhost("party" .. i)) then
			return true
		end
	end
	return false
end

--events

local eventFrame = CreateFrame("frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
	if (event == "ADDON_LOADED") then
		if (arg1 == "DBM-Core") then
			hookDBM()
		end

	elseif (event == "PLAYER_LOGIN") then
		hookDBM()

	elseif (event == "PLAYER_REGEN_ENABLED") then
		if (bossmods335.source == "CLEU") then
			C_Timer.After(1.5, function()
				if (bossmods335.source == "CLEU" and not isGroupInCombat()) then
					endEncounter("CLEU", false)
				end
			end)
		end

	elseif (event == "ZONE_CHANGED_NEW_AREA") then
		if (bossmods335.encounterId) then
			endEncounter(nil, false)
		end
	end
end)

hookDBM()
