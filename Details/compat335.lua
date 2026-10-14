--[3.3.5]

local _G = _G
local type, select, ipairs, pairs, rawget = type, select, ipairs, pairs, rawget

local Compat = {}
_G.DetailsCompat335 = Compat

Compat.IsClient335 = select(4, GetBuildInfo()) < 30400
Compat.HasMaskTextures = false

do
	local nativeXpcall = _G.xpcall
	local ok, forwarded = nativeXpcall(function(value) return value end, function() end, true)
	if (not (ok and forwarded)) then
		local unpack = unpack
		_G.xpcall = function(func, errorHandler, ...)
			local argCount = select("#", ...)
			if (argCount == 0) then
				return nativeXpcall(func, errorHandler)
			end
			local args = {...}
			return nativeXpcall(function() return func(unpack(args, 1, argCount)) end, errorHandler)
		end
		Compat.xpcallPolyfilled = true
	end
end

local retailOnlyEvents = {
	SPELL_TEXT_UPDATE = true,
	ENCOUNTER_LOOT_RECEIVED = true,
	SCENARIO_COMPLETED = true,
	ENCOUNTER_START = true,
	ENCOUNTER_END = true,
	CHALLENGE_MODE_START = true,
	CHALLENGE_MODE_COMPLETED = true,
	CHALLENGE_MODE_RESET = true,
	PLAYER_SPECIALIZATION_CHANGED = true,
	UNIT_ABSORB_AMOUNT_CHANGED = true,
	PLAYER_SOFT_ENEMY_CHANGED = true,
	COMBAT_LOG_EVENT = false,
}
Compat.retailOnlyEvents = retailOnlyEvents

if (not _G.C_EventUtils) then
	_G.C_EventUtils = {
		IsEventValid = function(eventName)
			return not retailOnlyEvents[eventName]
		end,
	}
end

if (not _G.C_ChallengeMode) then
	local noop = function() end
	_G.C_ChallengeMode = {
		GetActiveKeystoneInfo = function() return 0, {}, false end,
		GetActiveChallengeMapID = noop,
		IsChallengeModeActive = function() return false end,
		GetChallengeCompletionInfo = noop,
		GetCompletionInfo = noop,
		GetDeathCount = function() return 0, 0 end,
		GetMapUIInfo = noop,
		GetMapTable = function() return {} end,
		GetAffixInfo = noop,
		GetDungeonScoreRarityColor = noop,
		GetKeystoneLevelRarityColor = noop,
		GetOverallDungeonScore = function() return 0 end,
		GetOverallDungeonScoreRarityColor = noop,
		GetSpecificDungeonOverallScoreRarityColor = noop,
		GetSpecificDungeonScoreRarityColor = noop,
		GetMapScoreInfo = function() return {} end,
		GetGuildLeaders = function() return {} end,
		GetPowerLevelDamageHealthMod = function() return 0, 0 end,
		GetSlottedKeystoneInfo = noop,
		HasSlottedKeystone = function() return false end,
		CanUseKeystoneInCurrentMap = function() return false end,
		RequestLeaders = noop,
	}
end

if (not _G.C_SpecializationInfo) then
	_G.C_SpecializationInfo = {
		GetActiveSpecGroup = function() return GetActiveTalentGroup and GetActiveTalentGroup() or 1 end,
		GetAllSelectedPvpTalentIDs = function() return {} end,
		GetPvpTalentSlotInfo = function() return nil end,
		GetNumSpecializationsForClassID = function() return 3 end,
		GetTalentInfo = function(query)
			if (type(query) ~= "table") then
				return nil
			end
			local tabIndex, talentIndex = query.specializationIndex, query.talentIndex
			local name, icon, tier, column, rank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(tabIndex, talentIndex, query.isInspect, query.isPet, query.groupIndex)
			if (not name) then
				return nil
			end
			return {
				talentID = tabIndex * 100 + talentIndex,
				name = name, icon = icon, tier = tier, column = column,
				rank = rank or 0, maxRank = maxRank or 0,
				isExceptional = isExceptional, meetsPrereq = meetsPrereq,
			}
		end,
	}
end

_G.Enum = _G.Enum or {}
if (not Enum.PowerType) then
	Enum.PowerType = {
		HealthCost = -2, None = -1, Mana = 0, Rage = 1, Focus = 2, Energy = 3, Happiness = 4, Runes = 5, RunicPower = 6,
	}
end
if (not Enum.CompressionMethod) then
	Enum.CompressionMethod = {Deflate = 0, Zlib = 1, Gzip = 2}
end

if (not _G.C_UnitAuras) then
	local UnitAura = UnitAura
	local UnitIsUnit = UnitIsUnit
	local HARMFUL_ID_OFFSET = 1000

	local isHarmfulFilter = function(filter)
		return type(filter) == "string" and filter:upper():find("HARMFUL") ~= nil
	end

	local buildAuraData = function(unit, index, filter)
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(unit, index, filter)
		if (not name) then
			return nil
		end
		local harmful = isHarmfulFilter(filter)
		local fromPlayer = unitCaster and (UnitIsUnit(unitCaster, "player") or UnitIsUnit(unitCaster, "pet")) or false
		return {
			name = name,
			icon = icon,
			applications = count or 0,
			dispelName = debuffType,
			duration = duration or 0,
			expirationTime = expirationTime or 0,
			sourceUnit = unitCaster,
			isStealable = isStealable and true or false,
			spellId = spellId,
			canApplyAura = fromPlayer,
			isBossAura = false,
			isFromPlayerOrPlayerPet = fromPlayer,
			nameplateShowAll = false,
			nameplateShowPersonal = false,
			timeMod = 1,
			points = {},
			auraInstanceID = index + (harmful and HARMFUL_ID_OFFSET or 0),
			isHelpful = not harmful,
			isHarmful = harmful,
			isRaid = false,
			isNameplateOnly = false,
			charges = 0,
			maxCharges = 0,
		}
	end

	local findByName = function(unit, spellName, filter)
		for i = 1, 40 do
			local name = UnitAura(unit, i, filter)
			if (not name) then
				return nil
			end
			if (name == spellName) then
				return buildAuraData(unit, i, filter)
			end
		end
	end

	local findBySpellId = function(unit, spellId, filter)
		for i = 1, 40 do
			local name, _, _, _, _, _, _, _, _, _, thisSpellId = UnitAura(unit, i, filter)
			if (not name) then
				return nil
			end
			if (thisSpellId == spellId) then
				return buildAuraData(unit, i, filter)
			end
		end
	end

	local lastSlotFilter = {}
	local noop = function() end

	_G.C_UnitAuras = {
		GetAuraDataByIndex = function(unit, index, filter)
			return buildAuraData(unit, index, filter or "HELPFUL")
		end,
		GetBuffDataByIndex = function(unit, index, filter)
			return buildAuraData(unit, index, filter and ("HELPFUL|" .. filter) or "HELPFUL")
		end,
		GetDebuffDataByIndex = function(unit, index, filter)
			return buildAuraData(unit, index, filter and ("HARMFUL|" .. filter) or "HARMFUL")
		end,
		GetAuraDataBySpellName = function(unit, spellName, filter)
			if (filter) then
				return findByName(unit, spellName, filter)
			end
			return findByName(unit, spellName, "HELPFUL") or findByName(unit, spellName, "HARMFUL")
		end,
		GetPlayerAuraBySpellID = function(spellId)
			return findBySpellId("player", spellId, "HELPFUL") or findBySpellId("player", spellId, "HARMFUL")
		end,
		GetAuraDataByAuraInstanceID = function(unit, auraInstanceID)
			if (type(auraInstanceID) ~= "number") then
				return nil
			end
			if (auraInstanceID > HARMFUL_ID_OFFSET) then
				return buildAuraData(unit, auraInstanceID - HARMFUL_ID_OFFSET, "HARMFUL")
			end
			return buildAuraData(unit, auraInstanceID, "HELPFUL")
		end,
		GetAuraSlots = function(unit, filter)
			filter = filter or "HELPFUL"
			lastSlotFilter[unit] = filter
			local slots = {}
			for i = 1, 40 do
				if (not UnitAura(unit, i, filter)) then
					break
				end
				slots[#slots + 1] = i
			end
			return nil, unpack(slots)
		end,
		GetAuraDataBySlot = function(unit, slot)
			return buildAuraData(unit, slot, lastSlotFilter[unit] or "HELPFUL")
		end,
		GetUnitAuras = function(unit, filter)
			filter = filter or "HELPFUL"
			local result = {}
			for i = 1, 40 do
				local aura = buildAuraData(unit, i, filter)
				if (not aura) then
					break
				end
				result[#result + 1] = aura
			end
			return result
		end,
		GetCooldownAuraBySpellID = noop,
		DoesAuraHaveExpirationTime = function() return true end,
		IsAuraFilteredOutByInstanceID = function() return false end,
		WantsAlteredForm = function() return false end,
		AuraIsPrivate = function() return false end,
		AddPrivateAuraAnchor = noop,
		RemovePrivateAuraAnchor = noop,
		AddPrivateAuraAppliedSound = noop,
		RemovePrivateAuraAppliedSound = noop,
		SetPrivateWarningTextAnchor = noop,
	}
end

if (not _G.C_EncodingUtil) then
	local function getDeflate()
		return _G.LibStub and _G.LibStub:GetLibrary("LibDeflate", true)
	end
	local function getSerializer()
		return _G.LibStub and _G.LibStub:GetLibrary("AceSerializer-3.0", true)
	end

	local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	local b64decode = {}
	for i = 1, 64 do
		b64decode[b64chars:byte(i)] = i - 1
	end

	local function encodeBase64(data)
		local out = {}
		local len = #data
		for i = 1, len, 3 do
			local a, b, c = data:byte(i, i + 2)
			local n = a * 65536 + (b or 0) * 256 + (c or 0)
			local c1 = math.floor(n / 262144) % 64
			local c2 = math.floor(n / 4096) % 64
			local c3 = math.floor(n / 64) % 64
			local c4 = n % 64
			out[#out + 1] = b64chars:sub(c1 + 1, c1 + 1) .. b64chars:sub(c2 + 1, c2 + 1)
				.. (b and b64chars:sub(c3 + 1, c3 + 1) or "=") .. (c and b64chars:sub(c4 + 1, c4 + 1) or "=")
		end
		return table.concat(out)
	end

	local function decodeBase64(data)
		data = data:gsub("[^%w%+/=]", "")
		local out = {}
		for i = 1, #data, 4 do
			local s1, s2, s3, s4 = data:byte(i, i + 3)
			local v1, v2 = b64decode[s1], b64decode[s2 or 0]
			if (not v1 or not v2) then
				break
			end
			local v3, v4 = b64decode[s3 or 0], b64decode[s4 or 0]
			local n = v1 * 262144 + v2 * 4096 + (v3 or 0) * 64 + (v4 or 0)
			out[#out + 1] = string.char(math.floor(n / 65536) % 256)
			if (v3) then out[#out + 1] = string.char(math.floor(n / 256) % 256) end
			if (v4) then out[#out + 1] = string.char(n % 256) end
		end
		return table.concat(out)
	end

	_G.C_EncodingUtil = {
		CompressString = function(data, method)
			local deflate = getDeflate()
			if (not deflate or type(data) ~= "string") then return nil end
			if (method == Enum.CompressionMethod.Zlib) then
				return deflate:CompressZlib(data)
			end
			return deflate:CompressDeflate(data)
		end,
		DecompressString = function(data, method)
			local deflate = getDeflate()
			if (not deflate or type(data) ~= "string") then return nil end
			if (method == Enum.CompressionMethod.Zlib) then
				return deflate:DecompressZlib(data)
			end
			return deflate:DecompressDeflate(data)
		end,
		EncodeBase64 = function(data)
			return type(data) == "string" and encodeBase64(data) or nil
		end,
		DecodeBase64 = function(data)
			return type(data) == "string" and decodeBase64(data) or nil
		end,
		EncodeHex = function(data)
			return (data:gsub(".", function(c) return string.format("%02x", c:byte()) end))
		end,
		DecodeHex = function(data)
			return (data:gsub("%x%x", function(h) return string.char(tonumber(h, 16)) end))
		end,
		SerializeCBOR = function(value)
			local serializer = getSerializer()
			return serializer and serializer:Serialize(value) or nil
		end,
		DeserializeCBOR = function(data)
			local serializer = getSerializer()
			if (not serializer or type(data) ~= "string") then return nil end
			local ok, value = serializer:Deserialize(data)
			if (ok) then
				return value
			end
			return nil
		end,
		SerializeJSON = function() return nil end,
		DeserializeJSON = function() return nil end,
	}
end

local knownTemplates = {
	DetailsSpellActivationAlert = true,
	DetailsBackdropTemplate = true,
	DetailsButtonFrameTemplate = true,
}
function Compat.DoesTemplateExist(templateName)
	if (_G.DoesTemplateExist) then
		return _G.DoesTemplateExist(templateName)
	end
	return knownTemplates[templateName] or false
end

function Compat.GetTalentTabInfo(tabIndex, isInspect, isPet, talentGroup)
	local name, iconTexture, pointsSpent, background = GetTalentTabInfo(tabIndex, isInspect, isPet, talentGroup)
	if (not name) then
		return nil
	end
	return tabIndex, name, "", iconTexture, pointsSpent or 0, background
end

Compat.GetTalentInfo = GetTalentInfo

local scrollFrameChildKeys = {
	{"ScrollBar", "ScrollBar"},
	{"ScrollChildFrame", "ScrollChild"},
}
local scrollBarChildKeys = {
	{"ScrollUpButton", "ScrollUpButton"},
	{"ScrollDownButton", "ScrollDownButton"},
	{"ThumbTexture", "ThumbTexture"},
}
function Compat.FixScrollFrameKeys(scrollFrame)
	if (type(scrollFrame) ~= "table" or not scrollFrame.GetName) then
		return scrollFrame
	end
	local name = scrollFrame:GetName()
	if (name) then
		for _, keys in ipairs(scrollFrameChildKeys) do
			local child = _G[name .. keys[1]]
			if (child and rawget(scrollFrame, keys[2]) == nil) then
				scrollFrame[keys[2]] = child
			end
		end
	end
	if (rawget(scrollFrame, "ScrollBar") == nil and scrollFrame.GetChildren) then
		for _, child in ipairs({scrollFrame:GetChildren()}) do
			if (child.GetObjectType and child:GetObjectType() == "Slider") then
				scrollFrame.ScrollBar = child
				break
			end
		end
	end
	local scrollBar = rawget(scrollFrame, "ScrollBar")
	if (scrollBar) then
		local scrollBarName = scrollBar.GetName and scrollBar:GetName()
		if (scrollBarName) then
			for _, keys in ipairs(scrollBarChildKeys) do
				local child = _G[scrollBarName .. keys[1]]
				if (child and rawget(scrollBar, keys[2]) == nil) then
					scrollBar[keys[2]] = child
				end
			end
		end
		if (rawget(scrollBar, "ScrollUpButton") == nil and scrollBar.GetChildren) then
			local buttons = {}
			for _, child in ipairs({scrollBar:GetChildren()}) do
				if (child.GetObjectType and child:GetObjectType() == "Button") then
					buttons[#buttons + 1] = child
				end
			end
			scrollBar.ScrollUpButton = buttons[1]
			scrollBar.ScrollDownButton = buttons[2]
		end
		if (rawget(scrollBar, "ThumbTexture") == nil and scrollBar.GetThumbTexture) then
			scrollBar.ThumbTexture = scrollBar:GetThumbTexture()
		end
		for _, button in ipairs({rawget(scrollBar, "ScrollUpButton"), rawget(scrollBar, "ScrollDownButton")}) do
			if (button and button.GetNormalTexture) then
				button.Normal = button.Normal or button:GetNormalTexture()
				button.Pushed = button.Pushed or button:GetPushedTexture()
				button.Disabled = button.Disabled or button:GetDisabledTexture()
				button.Highlight = button.Highlight or button:GetHighlightTexture()
			end
		end
	end
	return scrollFrame
end

do
	local frameTypes = {"Frame", "Button", "CheckButton", "StatusBar", "Slider", "EditBox", "ScrollFrame", "GameTooltip",
		"Model", "PlayerModel", "Cooldown", "SimpleHTML", "ScrollingMessageFrame", "MessageFrame", "ColorSelect"}
	local noop = function() end

	local frameMethods = {
		SetPropagateKeyboardInput = noop,
		GetPropagateKeyboardInput = function() return false end,
		SetPropagateMouseClicks = noop,
		SetPropagateMouseMotion = noop,
		RegisterForMouse = noop,
		SetPassThroughButtons = noop,
		SetMouseClickEnabled = function(self, enabled) if (enabled) then self:EnableMouse(true) end end,
		SetMouseMotionEnabled = function(self, enabled) if (enabled) then self:EnableMouse(true) end end,
	}
	local typeMethods = {
		StatusBar = {
			SetReverseFill = noop,
			GetReverseFill = function() return false end,
		},
		Model = {SetDisplayInfo = noop},
		PlayerModel = {SetDisplayInfo = noop},
	}

	for _, frameType in ipairs(frameTypes) do
		local ok, sample = pcall(CreateFrame, frameType)
		if (ok and sample) then
			sample:Hide()
			local methods = getmetatable(sample).__index
			if (type(methods) == "table") then
				for name, func in pairs(frameMethods) do
					if (not methods[name]) then
						methods[name] = func
					end
				end
				for name, func in pairs(typeMethods[frameType] or {}) do
					if (not methods[name]) then
						methods[name] = func
					end
				end
			end
		end
	end
end

do
	local fonts = {
		{"GameFontHighlightHuge",     "GameFontHighlight",       20,    ""},
		{"OptionsFontHighlightSmall", "GameFontHighlightSmall",  nil,   nil},
		{"GameFontNormalWTF2Outline", "GameFontNormal",          32,    "OUTLINE"},
	}
	for _, info in ipairs(fonts) do
		local name, baseName, size, flags = info[1], info[2], info[3], info[4]
		local base = _G[baseName]
		if (not _G[name] and base) then
			local font = CreateFont(name)
			font:CopyFontObject(base)
			local path, baseSize, baseFlags = base:GetFont()
			font:SetFont(path or [[Fonts\FRIZQT__.TTF]], size or baseSize or 12, flags or baseFlags or "")
			font:SetTextColor(base:GetTextColor())
		end
	end
end

do
	local noop = function() end
	local function createMaskTexture(self, name, layer)
		local mask = self:CreateTexture(name, layer or "ARTWORK")
		mask:Hide()
		mask.Show = noop
		mask.SetShown = noop
		mask.__isDummyMask = true
		return mask
	end
	local frameTypes = {"Frame", "Button", "CheckButton", "StatusBar", "Slider", "EditBox", "ScrollFrame", "GameTooltip", "Cooldown"}
	for _, frameType in ipairs(frameTypes) do
		local ok, sample = pcall(CreateFrame, frameType)
		if (ok and sample) then
			sample:Hide()
			local methods = getmetatable(sample).__index
			if (type(methods) == "table") then
				local current = rawget(methods, "CreateMaskTexture")
				if (not current or current(sample) == nil) then
					methods.CreateMaskTexture = createMaskTexture
				end
			end
		end
	end
	local texture = UIParent:CreateTexture()
	local textureMethods = getmetatable(texture).__index
	for _, methodName in ipairs({"AddMaskTexture", "RemoveMaskTexture"}) do
		if (not rawget(textureMethods, methodName)) then
			textureMethods[methodName] = noop
		end
	end
end

STAT_AVERAGE_ITEM_LEVEL = STAT_AVERAGE_ITEM_LEVEL or "Item Level"

local raidDifficultyId = {[1] = 3, [2] = 4, [3] = 5, [4] = 6}
local partyDifficultyId = {[1] = 1, [2] = 2}

function Compat.GetRetailDifficultyId(instanceType, difficultyIndex, maxPlayers)
	if (instanceType == "raid") then
		difficultyIndex = difficultyIndex or 1
		if (maxPlayers == 25 and (difficultyIndex == 1 or difficultyIndex == 3)) then
			difficultyIndex = difficultyIndex + 1
		elseif (maxPlayers == 10 and (difficultyIndex == 2 or difficultyIndex == 4)) then
			difficultyIndex = difficultyIndex - 1
		end
		return raidDifficultyId[difficultyIndex] or 3
	elseif (instanceType == "party") then
		return partyDifficultyId[difficultyIndex] or 1
	end
	return 0
end

function Compat.GetInstanceId(zoneName)
	if (Compat.InstanceIdByMapArea and GetCurrentMapAreaID) then
		if (SetMapToCurrentZone and not (WorldMapFrame and WorldMapFrame:IsShown())) then
			SetMapToCurrentZone()
		end
		local instanceId = Compat.InstanceIdByMapArea[GetCurrentMapAreaID()]
		if (instanceId) then
			return instanceId
		end
	end
	return zoneName and Compat.InstanceIdByName and Compat.InstanceIdByName[zoneName] or 0
end

function Compat.GetInstanceInfo()
	local name, instanceType, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
	local instanceId = Compat.GetInstanceId(name)
	local difficultyId = Compat.GetRetailDifficultyId(instanceType, difficultyIndex, maxPlayers)
	local groupSize = GetNumRaidMembers() > 0 and GetNumRaidMembers() or (GetNumPartyMembers() + 1)
	return name, instanceType, difficultyId, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceId, groupSize, nil
end

function Compat.FindEncounterByName(instanceId, bossName)
	local list = Compat.Encounters and Compat.Encounters[instanceId]
	if (not list or not bossName) then
		return nil
	end
	local wanted = bossName:lower()
	for _, encounter in ipairs(list) do
		local name = encounter[2]:lower()
		if (name == wanted) then
			return encounter[1], encounter[2]
		end
	end
	for _, encounter in ipairs(list) do
		local name = encounter[2]:lower()
		if (name:find(wanted, 1, true) or wanted:find(name, 1, true)) then
			return encounter[1], encounter[2]
		end
	end
end

function Compat.GetEncounterInfo(encounterId)
	for instanceId, list in pairs(Compat.Encounters or {}) do
		for _, encounter in ipairs(list) do
			if (encounter[1] == encounterId) then
				return instanceId, encounter[2], encounter[4]
			end
		end
	end
end

local hexGuidTypes = {
	["F11"] = "GameObject", ["F13"] = "Creature", ["F14"] = "Pet", ["F15"] = "Vehicle", ["F12"] = "Transport",
}

function Compat.GetGuidType(guid)
	if (type(guid) ~= "string" or guid == "") then
		return nil
	end
	if (guid:sub(1, 2) == "0x") then
		local high = guid:sub(3, 5):upper()
		if (high == "000") then
			return "Player"
		end
		return hexGuidTypes[high] or "Creature"
	end
	return (guid:match("^(%a+)%-"))
end

function Compat.IsPlayerGuid(guid)
	return Compat.GetGuidType(guid) == "Player"
end

function Compat.IsCreatureGuid(guid)
	local guidType = Compat.GetGuidType(guid)
	return guidType == "Creature" or guidType == "Vehicle"
end

function Compat.GetNpcIdFromGuid(guid)
	if (type(guid) ~= "string" or guid == "") then
		return 0
	end
	if (guid:sub(1, 2) == "0x") then
		local guidType = Compat.GetGuidType(guid)
		if (guidType == "Creature" or guidType == "Vehicle" or guidType == "Pet" or guidType == "GameObject") then
			return tonumber(guid:sub(7, 12), 16) or 0
		end
		return 0
	end
	return tonumber(guid:match("^[^%-]*%-[^%-]*%-[^%-]*%-[^%-]*%-[^%-]*%-([^%-]*)")) or 0
end

function Compat.GetSpawnIdFromGuid(guid)
	if (type(guid) ~= "string" or guid == "") then
		return nil
	end
	if (guid:sub(1, 2) == "0x") then
		return guid:sub(13, 18)
	end
	return (select(7, strsplit("-", guid)))
end

local uniqueNameCounter = 0
function Compat.UniqueName(prefix)
	uniqueNameCounter = uniqueNameCounter + 1
	return (prefix or "DetailsCompat335Frame") .. uniqueNameCounter
end

function Compat.IsSecretValue(value)
	if (_G.issecretvalue) then
		return _G.issecretvalue(value)
	end
	return false
end
function Compat.IsSecretTable(value)
	if (_G.issecrettable) then
		return _G.issecrettable(value)
	end
	return false
end

do
	local sample = UIParent:CreateFontString(nil, "background", "GameFontNormal")
	local methods = getmetatable(sample).__index

	local function measureNatural(fontString)
		local oldWidth = fontString:GetWidth() or 0
		fontString:SetWidth(0)
		local naturalWidth = fontString:GetStringWidth() or 0
		if (oldWidth > 0 and math.abs(oldWidth - naturalWidth) > 0.5) then
			fontString:SetWidth(oldWidth)
		end
		return naturalWidth, oldWidth
	end

	methods.GetUnboundedStringWidth = function(self)
		return (measureNatural(self))
	end

	methods.IsTruncated = function(self)
		local naturalWidth, oldWidth = measureNatural(self)
		if (not oldWidth or oldWidth == 0) then
			return false
		end
		return naturalWidth > (oldWidth + 0.1)
	end
end
