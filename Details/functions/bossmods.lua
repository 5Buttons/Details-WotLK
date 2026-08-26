--> boss mods (DBM / BigWigs) integration for 3.3.5a
--> on wrath there is no ENCOUNTER_START/END event, details emulates them from the combat log.
--> the boss mod is used as an extra, authoritative data source:
--> - pull detection even when details has no npc data for the boss
--> - kill detection for encounters that end without a boss death (gunship, valithria, thorim, faction champions...)
--> - retroactive kill flag when the segment already closed before the kill was credited (e.g. lich king roleplay)

local _detalhes = _G._detalhes
local _

local _GetInstanceInfo = GetInstanceInfo
local _GetInstanceDifficulty = GetInstanceDifficulty
local _pcall = pcall

local hookedDBM = false
local hookedBigWigs = false

------------------------------------------------------------------------------------------------
--> shared handlers

--> resolve which of our encounters a boss mod is talking about
--> returns encounterID, encounterName (falls back to the raw creature id / name from the mod)
local function resolve_encounter(creatureId, name)
	if creatureId then
		local _, _, encounterID, bossName = _detalhes:GetEncounterInfoFromNpcId(creatureId)
		if encounterID then
			return encounterID, bossName or name
		end
		return creatureId, name
	end
	return nil, name
end

--> does the boss mod info match the encounter details is currently tracking?
local function matches_current_encounter(creatureId, name)
	local encounterTable = _detalhes.encounter_table
	if not encounterTable.id then
		return false
	end

	if creatureId then
		local encounterID = resolve_encounter(creatureId, name)
		if encounterID == encounterTable.id then
			return true
		end
	end

	if name and encounterTable.name and name:lower():find(encounterTable.name:lower(), 1, true) then
		return true
	end
	if name and encounterTable.name and encounterTable.name:lower():find(name:lower(), 1, true) then
		return true
	end

	--> no usable info from the boss mod, trust it (it only fires for the mod that was in combat)
	return not creatureId and not name
end

local function on_bossmod_pull(creatureId, name)
	if _detalhes.encounter_table.id or _detalhes.encounter_table.name then
		return --already tracking an encounter
	end

	local _, instanceType = _GetInstanceInfo()
	if instanceType ~= "party" and instanceType ~= "raid" then
		return
	end

	local encounterID, encounterName = resolve_encounter(creatureId, name)
	if not encounterID and not encounterName then
		return
	end

	if _detalhes.debug then
		_detalhes:Msg("(debug) boss mod pull:", encounterName or encounterID)
	end

	local _, _, _, _, maxPlayers = _GetInstanceInfo()
	_detalhes.parser_functions:ENCOUNTER_START(encounterID, encounterName, _GetInstanceDifficulty(), maxPlayers)
end

local function on_bossmod_kill(creatureId, name)
	if _detalhes.in_combat and _detalhes.encounter_table.start and not _detalhes.encounter_table["end"] then
		if matches_current_encounter(creatureId, name) then
			if _detalhes.debug then
				_detalhes:Msg("(debug) boss mod kill:", name or creatureId)
			end

			local encounterTable = _detalhes.encounter_table
			local _, _, _, _, maxPlayers = _GetInstanceInfo()
			_detalhes.parser_functions:ENCOUNTER_END(encounterTable.id, encounterTable.name, encounterTable.diff or _GetInstanceDifficulty(), encounterTable.size or maxPlayers)
		end
		return
	end

	if _detalhes.in_combat and not _detalhes.encounter_table.id then
		--> details never detected this encounter, build a minimal encounter table and end it as a kill
		local encounterID, encounterName = resolve_encounter(creatureId, name)
		if not encounterID and not encounterName then
			return
		end

		if _detalhes.debug then
			_detalhes:Msg("(debug) boss mod kill on undetected encounter:", encounterName or encounterID)
		end

		local zoneName, _, _, _, maxPlayers = _GetInstanceInfo()
		local encounterTable = _detalhes.encounter_table
		encounterTable.id = encounterID
		encounterTable.name = encounterName
		encounterTable.diff = _GetInstanceDifficulty()
		encounterTable.size = maxPlayers
		encounterTable.zone = zoneName
		encounterTable.mapid = _detalhes.zone_id
		encounterTable["start"] = _detalhes.tabela_vigente:GetStartTime() or GetTime()
		encounterTable["end"] = nil

		_detalhes.parser_functions:ENCOUNTER_END(encounterID, encounterName, encounterTable.diff, maxPlayers)
		return
	end

	--> segment already closed (e.g. lich king: the raid leaves combat during the roleplay, the kill is credited later)
	local combat = _detalhes.tabela_vigente
	if combat and combat.is_boss and not combat.is_boss.killed then
		local bossName = combat.is_boss.name
		local nameMatch = name and bossName and (name:lower():find(bossName:lower(), 1, true) or bossName:lower():find(name:lower(), 1, true))
		local idMatch = creatureId and combat.is_boss.id and resolve_encounter(creatureId, name) == combat.is_boss.id

		if nameMatch or idMatch then
			if _detalhes.debug then
				_detalhes:Msg("(debug) boss mod kill, flagging the closed segment as killed:", bossName)
			end

			combat.is_boss.killed = true
			combat.enemy = combat.is_boss.encounter or combat.enemy

			_detalhes:SendEvent("COMBAT_BOSS_DEFEATED", nil, combat)
			_detalhes:AtualizaGumpPrincipal(-1, true)
		end
	end
end

local function on_bossmod_wipe(creatureId, name)
	if _detalhes.in_combat and _detalhes.encounter_table.start and not _detalhes.encounter_table["end"] then
		if matches_current_encounter(creatureId, name) then
			if _detalhes.debug then
				_detalhes:Msg("(debug) boss mod wipe:", name or creatureId)
			end

			local encounterTable = _detalhes.encounter_table
			local _, _, _, _, maxPlayers = _GetInstanceInfo()
			_detalhes.parser_functions:ENCOUNTER_END(encounterTable.id, encounterTable.name, encounterTable.diff or _GetInstanceDifficulty(), encounterTable.size or maxPlayers, 1)
		end
	end
end

------------------------------------------------------------------------------------------------
--> DBM

local function get_dbm_mod_info(mod)
	local combatInfo = mod and mod.combatInfo
	if not combatInfo then
		return
	end

	local creatureId = combatInfo.creatureId or combatInfo.mob
	local name = combatInfo.name
	if not name and mod.localization and mod.localization.general then
		name = mod.localization.general.name
	end

	return creatureId, name
end

local function hook_dbm()
	local DBM = _G.DBM
	if hookedDBM or not DBM then
		return
	end

	if type(DBM.StartCombat) == "function" then
		hooksecurefunc(DBM, "StartCombat", function(self, mod, delay, event, ...)
			local ok, errortext = _pcall(function()
				local creatureId, name = get_dbm_mod_info(mod)
				on_bossmod_pull(creatureId, name)
			end)
			if not ok and _detalhes.debug then
				_detalhes:Msg("(debug) error on DBM StartCombat hook:", errortext)
			end
		end)
	end

	if type(DBM.EndCombat) == "function" then
		hooksecurefunc(DBM, "EndCombat", function(self, mod, wipe, ...)
			local ok, errortext = _pcall(function()
				local creatureId, name = get_dbm_mod_info(mod)
				if wipe then
					on_bossmod_wipe(creatureId, name)
				else
					on_bossmod_kill(creatureId, name)
				end
			end)
			if not ok and _detalhes.debug then
				_detalhes:Msg("(debug) error on DBM EndCombat hook:", errortext)
			end
		end)
	end

	hookedDBM = true
	_detalhes.bossmod_name = "DBM"

	if _detalhes.debug then
		_detalhes:Msg("(debug) DBM found, boss mod integration enabled.")
	end
end

------------------------------------------------------------------------------------------------
--> BigWigs (only versions sending AceEvent-3.0 messages, mirrors the Skada integration)

local bigwigs_listener = {}

local function hook_bigwigs()
	if hookedBigWigs or hookedDBM or not _G.BigWigs then
		return
	end

	local AceEvent = LibStub and LibStub:GetLibrary("AceEvent-3.0", true)
	if not AceEvent then
		return
	end

	AceEvent:Embed(bigwigs_listener)
	bigwigs_listener:RegisterMessage("BigWigs_Message", function(_, module, event, message)
		local ok, errortext = _pcall(function()
			if event == "bosskill" and message then
				on_bossmod_kill(nil, message)
			end
		end)
		if not ok and _detalhes.debug then
			_detalhes:Msg("(debug) error on BigWigs message handler:", errortext)
		end
	end)

	hookedBigWigs = true
	_detalhes.bossmod_name = "BigWigs"

	if _detalhes.debug then
		_detalhes:Msg("(debug) BigWigs found, boss mod integration enabled.")
	end
end

------------------------------------------------------------------------------------------------
--> initialization

local function try_hook()
	hook_dbm()
	hook_bigwigs()
	return hookedDBM or hookedBigWigs
end

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function(self, event, addonName)
	if event == "ADDON_LOADED" then
		if addonName == "DBM-Core" or addonName == "BigWigs" then
			try_hook()
		end
	else --PLAYER_LOGIN
		try_hook()
		self:UnregisterEvent("PLAYER_LOGIN")
		if hookedDBM then
			self:UnregisterEvent("ADDON_LOADED")
		end
	end
end)

try_hook()
