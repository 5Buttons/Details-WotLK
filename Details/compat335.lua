--[3.3.5]

local _G = _G
local type, select, pairs, ipairs, next, pcall, rawget, tonumber, tostring = type, select, pairs, ipairs, next, pcall, rawget, tonumber, tostring
local floor, ceil, max = math.floor, math.ceil, math.max
local unpack = unpack

local Compat = {}
_G.DetailsCompat335 = Compat

Compat.IsClient335 = select(4, GetBuildInfo()) < 30400
Compat.HasMaskTextures = false
Compat.HasClassicAPI = (_G.IsAddOnLoaded and _G.IsAddOnLoaded("!!!ClassicAPI")) and true or false

local noop = function() end
local returnFalse = function() return false end

local function define(name, value)
	if (_G[name] == nil) then
		_G[name] = value
	end
	return _G[name]
end

local function namespace(name)
	local t = _G[name]
	if (type(t) ~= "table") then
		t = {}
		_G[name] = t
	end
	return t
end

local function fill(t, fields)
	for key, value in pairs(fields) do
		if (t[key] == nil) then
			t[key] = value
		end
	end
	return t
end

local function callErrorHandler(err)
	local handler = _G.geterrorhandler and _G.geterrorhandler()
	if (handler) then
		handler(err)
	end
end

local function addMethods(methods, list)
	for name, func in pairs(list) do
		if (rawget(methods, name) == nil) then
			methods[name] = func
		end
	end
end

local function getMethods(object)
	local mt = object and getmetatable(object)
	local methods = mt and mt.__index
	return type(methods) == "table" and methods or nil
end

local frameTypes = {"Frame", "Button", "CheckButton", "StatusBar", "Slider", "EditBox", "ScrollFrame", "GameTooltip",
	"Model", "PlayerModel", "Cooldown", "SimpleHTML", "ScrollingMessageFrame", "MessageFrame", "ColorSelect"}

local samples = {}
for _, frameType in ipairs(frameTypes) do
	local ok, sample = pcall(CreateFrame, frameType)
	if (ok and sample) then
		sample:Hide()
		samples[frameType] = sample
	end
end
local hostFrame = samples.Frame
local sampleTexture = hostFrame:CreateTexture()
local sampleFontString = hostFrame:CreateFontString()
local sampleAnimGroup = hostFrame:CreateAnimationGroup()

--------------------------------------------------------------------------------
-- xpcall
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- Constants & enums
--------------------------------------------------------------------------------

define("WOW_PROJECT_MAINLINE", 1)
define("WOW_PROJECT_CLASSIC", 2)
define("WOW_PROJECT_BURNING_CRUSADE_CLASSIC", 5)
define("WOW_PROJECT_WRATH_CLASSIC", 11)
define("WOW_PROJECT_ID", _G.WOW_PROJECT_WRATH_CLASSIC)

define("LE_EXPANSION_CLASSIC", 0)
define("LE_EXPANSION_BURNING_CRUSADE", 1)
define("LE_EXPANSION_WRATH_OF_THE_LICH_KING", 2)
define("LE_EXPANSION_CATACLYSM", 3)
define("LE_EXPANSION_MISTS_OF_PANDARIA", 4)
define("LE_EXPANSION_WARLORDS_OF_DRAENOR", 5)
define("LE_EXPANSION_LEGION", 6)
define("LE_EXPANSION_BATTLE_FOR_AZEROTH", 7)
define("LE_EXPANSION_SHADOWLANDS", 8)
define("LE_EXPANSION_DRAGONFLIGHT", 9)
define("LE_EXPANSION_WAR_WITHIN", 10)
define("LE_EXPANSION_LEVEL_CURRENT", _G.GetAccountExpansionLevel and _G.GetAccountExpansionLevel() or 2)

define("INLINE_TANK_ICON", "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:0:64:64:0:19:22:41|t")
define("INLINE_HEALER_ICON", "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:0:64:64:20:39:1:20|t")
define("INLINE_DAMAGER_ICON", "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:0:64:64:20:39:22:41|t")

define("LE_PARTY_CATEGORY_HOME", 1)
define("LE_PARTY_CATEGORY_INSTANCE", 2)

fill(namespace("SOUNDKIT"), {
	IG_MAINMENU_OPTION = "igMainMenuOption",
	IG_MAINMENU_OPTION_CHECKBOX_ON = "igMainMenuOptionCheckBoxOn",
	IG_MAINMENU_OPTION_CHECKBOX_OFF = "igMainMenuOptionCheckBoxOff",
	IG_MAINMENU_OPEN = "igMainMenuOpen",
	IG_MAINMENU_CLOSE = "igMainMenuClose",
	IG_CHARACTER_INFO_TAB = "igCharacterInfoTab",
	U_CHAT_SCROLL_BUTTON = "uChatScrollButton",
})

STAT_AVERAGE_ITEM_LEVEL = STAT_AVERAGE_ITEM_LEVEL or "Item Level"

_G.Enum = _G.Enum or {}
if (not Enum.PowerType) then
	Enum.PowerType = {
		HealthCost = -2, None = -1, Mana = 0, Rage = 1, Focus = 2, Energy = 3, Happiness = 4, Runes = 5, RunicPower = 6,
	}
end
if (not Enum.CompressionMethod) then
	Enum.CompressionMethod = {Deflate = 0, Zlib = 1, Gzip = 2}
end

do
	local Enum = namespace("Enum")
	fill(Enum, {
		SpellBookSpellBank = {Player = 0, Pet = 1},
		SpellBookItemType = {None = 0, Spell = 1, FutureSpell = 2, PetAction = 3, Flyout = 4},
		SpellBookSkillLineIndex = {General = 1, Class = 2, MainSpec = 3, OffSpecStart = 4},
		StatusBarInterpolation = {Immediate = 0, ExponentialEaseOut = 1},
		StatusBarTimerDirection = {ElapsedTime = 0, RemainingTime = 1},
		CompressionLevel = {Default = 0, OptimizeForSpeed = 1, OptimizeForSize = 2},
		ItemQuality = {Poor = 0, Common = 1, Standard = 1, Uncommon = 2, Good = 2, Rare = 3, Superior = 3, Epic = 4, Legendary = 5, Artifact = 6, Heirloom = 7},
	})
	fill(namespace("Enum").PowerType or {}, {
		ComboPoints = 14, Runes = 5, RunicPower = 6, SoulShards = 7, LunarPower = 8, HolyPower = 9,
		Alternate = 10, Maelstrom = 11, Chi = 12, Insanity = 13, ArcaneCharges = 16, Fury = 17, Pain = 18, Essence = 19,
	})
end

--------------------------------------------------------------------------------
-- Retail-only systems
--------------------------------------------------------------------------------

do
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
end

if (not _G.C_ChallengeMode) then
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

--------------------------------------------------------------------------------
-- C_Timer
--------------------------------------------------------------------------------

do
	local TIMER_FRAME = CreateFrame("Frame")
	local heap = {}
	local heapSize = 0
	local GetTime = GetTime

	local function swap(i, j)
		heap[i], heap[j] = heap[j], heap[i]
		heap[i].heapIndex = i
		heap[j].heapIndex = j
	end

	local function siftUp(i)
		while (i > 1) do
			local parent = floor(i / 2)
			if (heap[parent].nextTime <= heap[i].nextTime) then
				break
			end
			swap(i, parent)
			i = parent
		end
	end

	local function siftDown(i)
		while (true) do
			local left = i * 2
			local right = left + 1
			local smallest = i
			if (left <= heapSize and heap[left].nextTime < heap[smallest].nextTime) then
				smallest = left
			end
			if (right <= heapSize and heap[right].nextTime < heap[smallest].nextTime) then
				smallest = right
			end
			if (smallest == i) then
				break
			end
			swap(i, smallest)
			i = smallest
		end
	end

	local function push(timer)
		heapSize = heapSize + 1
		heap[heapSize] = timer
		timer.heapIndex = heapSize
		siftUp(heapSize)
		TIMER_FRAME:Show()
	end

	local function remove(timer)
		local i = timer.heapIndex
		if (not i or heap[i] ~= timer) then
			return
		end
		timer.heapIndex = nil
		if (i == heapSize) then
			heap[heapSize] = nil
			heapSize = heapSize - 1
			return
		end
		heap[i] = heap[heapSize]
		heap[i].heapIndex = i
		heap[heapSize] = nil
		heapSize = heapSize - 1
		siftDown(i)
		siftUp(i)
	end

	local TimerMethods = {}
	TimerMethods.__index = TimerMethods

	function TimerMethods:Cancel()
		self._cancelled = true
		remove(self)
	end

	function TimerMethods:IsCancelled()
		return self._cancelled == true
	end

	TIMER_FRAME:SetScript("OnUpdate", function(self)
		local now = GetTime()
		while (heapSize > 0 and heap[1].nextTime <= now) do
			local timer = heap[1]
			remove(timer)
			if (timer._remainingIterations) then
				timer._remainingIterations = timer._remainingIterations - 1
			end
			local repeating = timer._isTicker and not timer._cancelled and (not timer._remainingIterations or timer._remainingIterations > 0)
			if (repeating) then
				timer.nextTime = now + timer._duration
				push(timer)
			else
				timer._cancelled = timer._handle and true or nil
			end
			local ok, err = pcall(timer._callback, timer._handle and timer or nil)
			if (not ok) then
				callErrorHandler(err)
			end
		end
		if (heapSize == 0) then
			self:Hide()
		end
	end)

	local function newTimer(duration, callback, iterations, isTicker, handle)
		if (type(duration) ~= "number") then
			duration = 0
		end
		local timer = handle and setmetatable({}, TimerMethods) or {}
		timer._duration = max(duration, 0)
		timer._callback = callback
		timer._isTicker = isTicker
		timer._handle = handle
		timer._remainingIterations = iterations
		timer.nextTime = GetTime() + timer._duration
		push(timer)
		return timer
	end

	local C_Timer = namespace("C_Timer")
	fill(C_Timer, {
		After = function(duration, callback)
			newTimer(duration, callback, 1, false, false)
		end,
		NewTimer = function(duration, callback)
			return newTimer(duration, callback, 1, false, true)
		end,
		NewTicker = function(duration, callback, iterations)
			return newTimer(duration, callback, iterations, true, true)
		end,
	})
	if (C_Timer.CancelTimer == nil) then
		C_Timer.CancelTimer = function(timer)
			if (type(timer) == "table" and timer.Cancel) then
				timer:Cancel()
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Mixins, math & misc globals
--------------------------------------------------------------------------------

define("Mixin", function(object, ...)
	for i = 1, select("#", ...) do
		local mixin = select(i, ...)
		if (mixin) then
			for k, v in pairs(mixin) do
				object[k] = v
			end
		end
	end
	return object
end)

define("CreateFromMixins", function(...)
	return _G.Mixin({}, ...)
end)

define("CreateAndInitFromMixin", function(mixin, ...)
	local object = _G.CreateFromMixins(mixin)
	object:Init(...)
	return object
end)

do
	local ColorMixin = define("ColorMixin", {})
	fill(ColorMixin, {
		OnLoad = function(self, r, g, b, a)
			self:SetRGBA(r, g, b, a)
		end,
		IsRGBEqualTo = function(self, other)
			return self.r == other.r and self.g == other.g and self.b == other.b
		end,
		IsEqualTo = function(self, other)
			return self:IsRGBEqualTo(other) and self.a == other.a
		end,
		GetRGB = function(self)
			return self.r, self.g, self.b
		end,
		GetRGBAsBytes = function(self)
			return floor(self.r * 255 + 0.5), floor(self.g * 255 + 0.5), floor(self.b * 255 + 0.5)
		end,
		GetRGBA = function(self)
			return self.r, self.g, self.b, self.a
		end,
		GetRGBAAsBytes = function(self)
			return floor(self.r * 255 + 0.5), floor(self.g * 255 + 0.5), floor(self.b * 255 + 0.5), floor((self.a or 1) * 255 + 0.5)
		end,
		SetRGBA = function(self, r, g, b, a)
			self.r, self.g, self.b, self.a = r, g, b, a
		end,
		SetRGB = function(self, r, g, b)
			self:SetRGBA(r, g, b, nil)
		end,
		GenerateHexColor = function(self)
			return ("ff%.2x%.2x%.2x"):format(self:GetRGBAsBytes())
		end,
		GenerateHexColorNoAlpha = function(self)
			return ("%.2x%.2x%.2x"):format(self:GetRGBAsBytes())
		end,
		GenerateHexColorMarkup = function(self)
			return "|c" .. self:GenerateHexColor()
		end,
		WrapTextInColorCode = function(self, text)
			return "|c" .. self:GenerateHexColor() .. tostring(text) .. "|r"
		end,
	})
	define("CreateColor", function(r, g, b, a)
		local color = _G.CreateFromMixins(ColorMixin)
		color:OnLoad(r, g, b, a)
		return color
	end)
end

define("Clamp", function(value, minValue, maxValue)
	if (value > maxValue) then
		return maxValue
	elseif (value < minValue) then
		return minValue
	end
	return value
end)
define("Saturate", function(value)
	return _G.Clamp(value, 0, 1)
end)
define("Lerp", function(startValue, endValue, amount)
	return (1 - amount) * startValue + amount * endValue
end)
define("Round", function(value)
	if (value < 0) then
		return ceil(value - 0.5)
	end
	return floor(value + 0.5)
end)
define("Square", function(value)
	return value * value
end)
define("Wrap", function(value, maxValue)
	return (value - 1) % maxValue + 1
end)
define("PercentageBetween", function(value, startValue, endValue)
	if (startValue == endValue) then
		return 0
	end
	return (value - startValue) / (endValue - startValue)
end)
define("ClampedPercentageBetween", function(value, startValue, endValue)
	return _G.Saturate(_G.PercentageBetween(value, startValue, endValue))
end)
define("RandomFloatInRange", function(minValue, maxValue)
	return _G.Lerp(minValue, maxValue, math.random())
end)
define("DeltaLerp", function(startValue, endValue, amount, timeSec)
	return _G.Lerp(startValue, endValue, _G.Saturate(amount * timeSec * 60))
end)
define("FrameDeltaLerp", function(startValue, endValue, amount)
	return _G.DeltaLerp(startValue, endValue, amount, 1 / 60)
end)
define("CalculateDistanceSq", function(x1, y1, x2, y2)
	local dx, dy = x2 - x1, y2 - y1
	return dx * dx + dy * dy
end)
define("CalculateDistance", function(x1, y1, x2, y2)
	return math.sqrt(_G.CalculateDistanceSq(x1, y1, x2, y2))
end)

define("GetServerTime", function()
	return time()
end)
define("GetTimePreciseSec", function()
	return GetTime()
end)
define("GetPhysicalScreenSize", function()
	local resolution = GetCVar("gxResolution") or ""
	local width, height = resolution:match("(%d+)x(%d+)")
	return tonumber(width) or 1920, tonumber(height) or 1080
end)

define("Ambiguate", function(name)
	return name
end)

define("CreateTextureMarkup", function(file, fileWidth, fileHeight, width, height, left, right, top, bottom, xOffset, yOffset)
	return ("|T%s:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d|t"):format(
		file, height, width, xOffset or 0, yOffset or 0, fileWidth, fileHeight,
		(left or 0) * fileWidth, (right or 1) * fileWidth, (top or 0) * fileHeight, (bottom or 1) * fileHeight)
end)

--------------------------------------------------------------------------------
-- Group & unit
--------------------------------------------------------------------------------

define("IsInGroup", function(category)
	if (category == _G.LE_PARTY_CATEGORY_INSTANCE) then
		return false
	end
	return GetNumRaidMembers() > 0 or GetNumPartyMembers() > 0
end)

define("IsInRaid", function(category)
	if (category == _G.LE_PARTY_CATEGORY_INSTANCE) then
		return false
	end
	return GetNumRaidMembers() > 0
end)

define("GetNumGroupMembers", function()
	local numRaid = GetNumRaidMembers()
	if (numRaid > 0) then
		return numRaid
	end
	local numParty = GetNumPartyMembers()
	return numParty > 0 and (numParty + 1) or 0
end)

define("GetNumSubgroupMembers", function()
	return GetNumPartyMembers()
end)

define("UnitIsGroupLeader", function(unit)
	if (GetNumRaidMembers() > 0) then
		if (UnitIsUnit(unit, "player")) then
			return IsRaidLeader() and true or false
		end
		for i = 1, GetNumRaidMembers() do
			local _, rank = GetRaidRosterInfo(i)
			if (rank == 2 and UnitIsUnit(unit, "raid" .. i)) then
				return true
			end
		end
		return false
	elseif (GetNumPartyMembers() > 0) then
		if (UnitIsUnit(unit, "player")) then
			return IsPartyLeader() and true or false
		end
		return UnitIsPartyLeader(unit) and true or false
	end
	return false
end)

define("UnitIsGroupAssistant", function(unit)
	for i = 1, GetNumRaidMembers() do
		local _, rank = GetRaidRosterInfo(i)
		if (rank == 1 and UnitIsUnit(unit, "raid" .. i)) then
			return true
		end
	end
	return false
end)

define("UnitFullName", function(unit)
	local name, realm = UnitName(unit)
	if (name and (not realm or realm == "") and UnitIsUnit(unit, "player")) then
		realm = GetRealmName()
	end
	return name, realm
end)

define("UnitIsTapDenied", function(unit)
	return UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)
end)

define("UnitGetIncomingHeals", function() return 0 end)
define("UnitGetTotalAbsorbs", function() return 0 end)
define("UnitGetTotalHealAbsorbs", function() return 0 end)

--------------------------------------------------------------------------------
-- Classes
--------------------------------------------------------------------------------

do
	local classFileById = {"WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "DEATHKNIGHT", "SHAMAN", "MAGE", "WARLOCK", nil, "DRUID"}
	local classIdByFile = {}
	for id, classFile in pairs(classFileById) do
		classIdByFile[classFile] = id
	end
	Compat.ClassFileById = classFileById
	Compat.ClassIdByFile = classIdByFile

	local function localizedClassName(classFile)
		return (_G.LOCALIZED_CLASS_NAMES_MALE and _G.LOCALIZED_CLASS_NAMES_MALE[classFile]) or classFile
	end

	define("GetClassInfo", function(classId)
		local classFile = classFileById[classId]
		if (not classFile) then
			return nil
		end
		return localizedClassName(classFile), classFile, classId
	end)

	define("GetNumClasses", function()
		return 11
	end)

	define("GetClassColor", function(classFile)
		local color = (_G.CUSTOM_CLASS_COLORS and _G.CUSTOM_CLASS_COLORS[classFile]) or _G.RAID_CLASS_COLORS[classFile]
		if (color) then
			return color.r, color.g, color.b, ("ff%.2x%.2x%.2x"):format(color.r * 255, color.g * 255, color.b * 255)
		end
		return 1, 1, 1, "ffffffff"
	end)

	fill(namespace("C_CreatureInfo"), {
		GetClassInfo = function(classId)
			local className, classFile = _G.GetClassInfo(classId)
			if (className) then
				return {className = className, classFile = classFile, classID = classId}
			end
		end,
		GetRaceInfo = function()
			return nil
		end,
	})
end

--------------------------------------------------------------------------------
-- C_AddOns, C_CVar, C_ChatInfo, C_Container, C_Item, C_Map, C_PvP
--------------------------------------------------------------------------------

fill(namespace("C_AddOns"), {
	GetAddOnInfo = GetAddOnInfo,
	GetAddOnMetadata = GetAddOnMetadata,
	IsAddOnLoaded = IsAddOnLoaded,
	LoadAddOn = LoadAddOn,
	EnableAddOn = EnableAddOn,
	DisableAddOn = DisableAddOn,
	GetNumAddOns = GetNumAddOns,
	IsAddOnLoadOnDemand = IsAddOnLoadOnDemand,
	GetAddOnDependencies = GetAddOnDependencies,
	GetAddOnEnableState = function(addon, character)
		local enabled = select(4, GetAddOnInfo(addon))
		return enabled and 2 or 0
	end,
})

fill(namespace("C_CVar"), {
	GetCVar = GetCVar,
	SetCVar = SetCVar,
	GetCVarBool = GetCVarBool,
	GetCVarDefault = GetCVarDefault,
	RegisterCVar = function(name, value)
		if (GetCVar(name) == nil and _G.RegisterCVar) then
			_G.RegisterCVar(name, value)
		end
	end,
})

fill(namespace("C_ChatInfo"), {
	RegisterAddonMessagePrefix = function() return true end,
	IsAddonMessagePrefixRegistered = function() return true end,
	SendAddonMessage = function(prefix, message, chatType, target)
		return SendAddonMessage(prefix, message, chatType, target)
	end,
	SendChatMessage = function(...)
		return SendChatMessage(...)
	end,
})

do
	local function itemIdFromLink(link)
		return link and tonumber(link:match("item:(%d+)"))
	end
	fill(namespace("C_Container"), {
		GetContainerNumSlots = GetContainerNumSlots,
		GetContainerItemLink = GetContainerItemLink,
		GetContainerItemID = function(bag, slot)
			if (_G.GetContainerItemID) then
				return _G.GetContainerItemID(bag, slot)
			end
			return itemIdFromLink(GetContainerItemLink(bag, slot))
		end,
		GetContainerItemInfo = function(bag, slot)
			local icon, count, locked, quality, readable, lootable, link = GetContainerItemInfo(bag, slot)
			if (not icon) then
				return nil
			end
			return {
				iconFileID = icon, stackCount = count, isLocked = locked, quality = quality,
				isReadable = readable, hasLoot = lootable, hyperlink = link, itemID = itemIdFromLink(link),
				isFiltered = false, hasNoValue = false, isBound = false,
			}
		end,
		PickupContainerItem = PickupContainerItem,
		UseContainerItem = UseContainerItem,
	})
end

do
	local C_Item = namespace("C_Item")
	local function itemInfo(item)
		if (type(item) == "table") then
			return nil
		end
		return GetItemInfo(item)
	end
	fill(C_Item, {
		GetItemInfo = itemInfo,
		GetItemInfoInstant = function(item)
			local name, link, quality, itemLevel, minLevel, itemType, itemSubType, stackCount, equipLoc, icon = itemInfo(item)
			if (not name) then
				return nil
			end
			return tonumber(link:match("item:(%d+)")), itemType, itemSubType, equipLoc, icon
		end,
		GetItemNameByID = function(item)
			return (itemInfo(item))
		end,
		GetItemIconByID = function(item)
			return GetItemIcon(item)
		end,
		GetItemIcon = function(item)
			return GetItemIcon(item)
		end,
		GetItemQualityByID = function(item)
			return (select(3, itemInfo(item)))
		end,
		GetItemQualityColor = GetItemQualityColor,
		GetDetailedItemLevelInfo = function(item)
			local itemLevel = select(4, itemInfo(item))
			return itemLevel, false, itemLevel
		end,
		GetCurrentItemLevel = function()
			return nil
		end,
		GetItemStats = function(link, statTable)
			return GetItemStats(link, statTable)
		end,
		GetItemCount = GetItemCount,
		GetItemSpell = GetItemSpell,
		GetItemCooldown = GetItemCooldown,
		GetItemFamily = GetItemFamily,
		IsEquippableItem = IsEquippableItem,
		IsEquippedItem = IsEquippedItem,
		IsUsableItem = IsUsableItem,
		IsHelpfulItem = IsHelpfulItem,
		IsHarmfulItem = IsHarmfulItem,
		IsConsumableItem = IsConsumableItem,
		IsCurrentItem = IsCurrentItem,
		IsItemInRange = IsItemInRange,
		ItemHasRange = ItemHasRange,
		EquipItemByName = EquipItemByName,
		UseItemByName = UseItemByName,
		PickupItem = PickupItem,
		DoesItemExistByID = function(item)
			return itemInfo(item) ~= nil
		end,
		IsItemDataCachedByID = function(item)
			return itemInfo(item) ~= nil
		end,
		RequestLoadItemDataByID = noop,
		IsItemKeystoneByID = returnFalse,
	})
end

do
	local function currentMapId()
		if (SetMapToCurrentZone and not (WorldMapFrame and WorldMapFrame:IsShown())) then
			SetMapToCurrentZone()
		end
		return GetCurrentMapAreaID and GetCurrentMapAreaID() or nil
	end
	fill(namespace("C_Map"), {
		GetBestMapForUnit = function(unit)
			if (unit == "player" or UnitIsUnit(unit, "player")) then
				return currentMapId()
			end
			return nil
		end,
		GetMapInfo = function(mapId)
			if (not mapId) then
				return nil
			end
			local name = (mapId == (GetCurrentMapAreaID and GetCurrentMapAreaID())) and GetRealZoneText() or ""
			return {mapID = mapId, name = name, mapType = 3, parentMapID = 0}
		end,
	})
end

fill(namespace("C_PvP"), {
	IsPvPMap = function()
		local inInstance, instanceType = IsInInstance()
		return inInstance and (instanceType == "pvp" or instanceType == "arena") or false
	end,
	IsRatedBattleground = returnFalse,
	IsWarModeDesired = returnFalse,
})

fill(namespace("C_FriendList"), {
	GetFriendInfo = function(name)
		for i = 1, GetNumFriends() do
			local friendName, level, class, area, connected, status, notes = GetFriendInfo(i)
			if (friendName == name) then
				return {name = friendName, level = level, className = class, area = area, connected = connected, notes = notes}
			end
		end
	end,
	SetFriendNotes = SetFriendNotes,
	GetNumFriends = GetNumFriends,
})

fill(namespace("C_AuctionHouse"), {})

--------------------------------------------------------------------------------
-- Spells & spellbook
--------------------------------------------------------------------------------

do
	local scanTooltip
	local function getScanTooltip()
		if (not scanTooltip) then
			scanTooltip = CreateFrame("GameTooltip", "DetailsCompat335ScanTooltip", nil, "GameTooltipTemplate")
			scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
		end
		return scanTooltip
	end
	Compat.GetScanTooltip = getScanTooltip

	local function getSpellDescription(spellId)
		if (not spellId or not GetSpellInfo(spellId)) then
			return ""
		end
		local tooltip = getScanTooltip()
		tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
		tooltip:ClearLines()
		tooltip:SetHyperlink("spell:" .. spellId)
		local numLines = tooltip:NumLines()
		if (numLines > 0) then
			local line = _G["DetailsCompat335ScanTooltipTextLeft" .. numLines]
			return line and line:GetText() or ""
		end
		return ""
	end

	local C_Spell = namespace("C_Spell")
	fill(C_Spell, {
		GetSpellInfo = function(spellId)
			if (not spellId) then
				return nil
			end
			local name, rank, icon, powerCost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(spellId)
			if (not name) then
				return nil
			end
			return {
				name = name, rank = rank, iconID = icon, originalIconID = icon,
				castTime = castTime, minRange = minRange, maxRange = maxRange,
				spellID = type(spellId) == "number" and spellId or nil,
			}
		end,
		GetSpellName = function(spellId)
			return spellId and (GetSpellInfo(spellId)) or nil
		end,
		GetSpellTexture = function(spellId)
			if (not spellId) then
				return nil
			end
			local icon = select(3, GetSpellInfo(spellId))
			return icon, icon
		end,
		GetSpellLink = function(spellId)
			return spellId and GetSpellLink(spellId) or nil
		end,
		GetSpellDescription = getSpellDescription,
		GetSpellCooldown = function(spellId)
			local start, duration, enabled = GetSpellCooldown(spellId)
			if (not start) then
				return nil
			end
			return {startTime = start, duration = duration, isEnabled = enabled == 1 or enabled == true, modRate = 1}
		end,
		GetSpellCharges = function()
			return nil
		end,
		GetOverrideSpell = function(spellId)
			return spellId
		end,
		GetSpellPowerCost = function()
			return nil
		end,
		GetSpellSubtext = function(spellId)
			return spellId and select(2, GetSpellInfo(spellId)) or nil
		end,
		IsSpellPassive = function(spellId)
			return IsPassiveSpell(spellId) and true or false
		end,
		IsSpellImportant = returnFalse,
		DoesSpellExist = function(spellId)
			return spellId and GetSpellInfo(spellId) ~= nil or false
		end,
		IsSpellDataCached = function(spellId)
			return spellId and GetSpellInfo(spellId) ~= nil or false
		end,
		RequestLoadSpellData = noop,
	})
	define("GetSpellDescription", getSpellDescription)

	local function bankToken(bank)
		if (bank == 1 or bank == "pet" or bank == _G.BOOKTYPE_PET) then
			return _G.BOOKTYPE_PET or "pet"
		end
		return _G.BOOKTYPE_SPELL or "spell"
	end

	local function spellIdAtIndex(index, bank)
		local link = GetSpellLink(index, bankToken(bank))
		return link and tonumber(link:match("spell:(%d+)"))
	end
	Compat.GetSpellBookSpellId = spellIdAtIndex

	local function getSpellBookItemName(index, bank)
		local name, subName = GetSpellName(index, bankToken(bank))
		if (not name) then
			return nil
		end
		return name, subName, spellIdAtIndex(index, bank)
	end
	define("GetSpellBookItemName", getSpellBookItemName)

	local SpellBookItemType = _G.Enum.SpellBookItemType

	local C_SpellBook = namespace("C_SpellBook")
	fill(C_SpellBook, {
		GetNumSpellBookSkillLines = function()
			return GetNumSpellTabs()
		end,
		GetSpellBookSkillLineInfo = function(index)
			local name, icon, offset, numSpells = GetSpellTabInfo(index)
			if (not name) then
				return nil
			end
			return {
				name = name, iconID = icon, itemIndexOffset = offset or 0, numSpellBookItems = numSpells or 0,
				isGuild = false, shouldHide = false, offSpecID = nil, specID = nil,
			}
		end,
		GetSpellBookItemName = getSpellBookItemName,
		GetSpellBookItemType = function(index, bank)
			local name = GetSpellName(index, bankToken(bank))
			if (not name) then
				return SpellBookItemType.None, nil, nil
			end
			local spellId = spellIdAtIndex(index, bank)
			local itemType = (bankToken(bank) == "pet") and SpellBookItemType.PetAction or SpellBookItemType.Spell
			return itemType, spellId, spellId
		end,
		GetSpellBookItemInfo = function(index, bank)
			local name, subName = GetSpellName(index, bankToken(bank))
			if (not name) then
				return nil
			end
			local spellId = spellIdAtIndex(index, bank)
			return {
				actionID = spellId, spellID = spellId, name = name, subName = subName,
				iconID = GetSpellTexture(index, bankToken(bank)),
				isPassive = IsPassiveSpell(index, bankToken(bank)) and true or false,
				isOffSpec = false, skillLineIndex = nil,
				itemType = (bankToken(bank) == "pet") and SpellBookItemType.PetAction or SpellBookItemType.Spell,
			}
		end,
		GetSpellBookItemTexture = function(index, bank)
			return GetSpellTexture(index, bankToken(bank))
		end,
		IsSpellBookItemPassive = function(index, bank)
			return IsPassiveSpell(index, bankToken(bank)) and true or false
		end,
		HasPetSpells = function()
			return HasPetSpells()
		end,
		IsSpellInSpellBook = function(spellId)
			return IsSpellKnown(spellId) and true or false
		end,
		IsSpellKnownOrInSpellBook = function(spellId, isPet)
			return IsSpellKnown(spellId, isPet) and true or false
		end,
		GetOverrideSpell = function(spellId)
			return spellId
		end,
		GetSpellLinkFromSpellID = GetSpellLink,
	})

	local SpellMixin = {}
	SpellMixin.__index = SpellMixin
	function SpellMixin:GetSpellID() return self.spellID end
	function SpellMixin:IsSpellEmpty() return not self.spellID or GetSpellInfo(self.spellID) == nil end
	function SpellMixin:IsSpellDataCached() return not self:IsSpellEmpty() end
	function SpellMixin:GetSpellName() return (GetSpellInfo(self.spellID)) end
	function SpellMixin:GetSpellSubtext() return select(2, GetSpellInfo(self.spellID)) end
	function SpellMixin:GetSpellTexture() return select(3, GetSpellInfo(self.spellID)) end
	function SpellMixin:GetSpellDescription() return getSpellDescription(self.spellID) end
	function SpellMixin:ContinueOnSpellLoad(callback) callback() end
	function SpellMixin:ContinueWithCancelOnSpellLoad(callback) callback(); return noop end

	local Spell = define("Spell", {})
	fill(Spell, {
		CreateFromSpellID = function(_, spellId)
			return setmetatable({spellID = spellId}, SpellMixin)
		end,
	})
end

--------------------------------------------------------------------------------
-- Auras
--------------------------------------------------------------------------------

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

do
	local function unpackAuraData(aura)
		if (not aura) then
			return nil
		end
		return aura.name, aura.icon, aura.applications, aura.dispelName, aura.duration, aura.expirationTime,
			aura.sourceUnit, aura.isStealable, aura.nameplateShowPersonal, aura.spellId, aura.canApplyAura,
			aura.isBossAura, aura.isFromPlayerOrPlayerPet, aura.nameplateShowAll, aura.timeMod
	end

	local AuraUtil = namespace("AuraUtil")
	fill(AuraUtil, {
		UnpackAuraData = unpackAuraData,
		ForEachAura = function(unit, filter, maxCount, func, usePackedAura)
			if (maxCount and maxCount <= 0) then
				return
			end
			local count = 0
			for i = 1, 40 do
				local aura = _G.C_UnitAuras.GetAuraDataByIndex(unit, i, filter)
				if (not aura) then
					return
				end
				local done
				if (usePackedAura) then
					done = func(aura)
				else
					done = func(unpackAuraData(aura))
				end
				count = count + 1
				if (done or (maxCount and count >= maxCount)) then
					return
				end
			end
		end,
		FindAura = function(predicate, unit, filter, predicateArg1, predicateArg2, predicateArg3)
			for i = 1, 40 do
				local aura = _G.C_UnitAuras.GetAuraDataByIndex(unit, i, filter)
				if (not aura) then
					return nil
				end
				if (predicate(predicateArg1, predicateArg2, predicateArg3, unpackAuraData(aura))) then
					return unpackAuraData(aura)
				end
			end
		end,
		FindAuraByName = function(auraName, unit, filter)
			for i = 1, 40 do
				local aura = _G.C_UnitAuras.GetAuraDataByIndex(unit, i, filter)
				if (not aura) then
					return nil
				end
				if (aura.name == auraName) then
					return unpackAuraData(aura)
				end
			end
		end,
		AuraUpdateChangedType = {None = 1, Debuff = 2, Buff = 3, Dispel = 4},
		DispellableDebuffTypes = {Magic = true, Curse = true, Disease = true, Poison = true},
	})
end

--------------------------------------------------------------------------------
-- C_EncodingUtil
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- Textures, atlases & pixel util
--------------------------------------------------------------------------------

do
	local atlasInfo = Compat.AtlasInfo or {}
	Compat.AtlasInfo = atlasInfo
	fill(namespace("C_Texture"), {
		GetAtlasInfo = function(atlasName)
			local info = atlasName and atlasInfo[atlasName]
			if (not info) then
				return nil
			end
			return {
				width = info[1], height = info[2],
				leftTexCoord = info[3], rightTexCoord = info[4], topTexCoord = info[5], bottomTexCoord = info[6],
				tilesHorizontally = info[7] or false, tilesVertically = info[8] or false, file = info[9], filename = info[9],
			}
		end,
		GetFilenameFromFileDataID = function() return nil end,
	})
end

define("CooldownFrame_Set", function(cooldown, start, duration, enable, forceShowDrawEdge, modRate)
	if (enable and enable ~= 0 and start and start > 0 and duration and duration > 0) then
		cooldown:SetCooldown(start, duration)
		cooldown:Show()
	else
		cooldown:Hide()
	end
end)

do
	local rotations = {
		[0] = {0, 0, 0, 1, 1, 0, 1, 1},
		[90] = {1, 0, 0, 0, 1, 1, 0, 1},
		[180] = {1, 1, 1, 0, 0, 1, 0, 0},
		[270] = {0, 1, 1, 1, 0, 0, 1, 0},
	}
	define("SetClampedTextureRotation", function(texture, rotationDegrees)
		local coords = rotations[rotationDegrees or 0]
		if (coords) then
			texture.rotationDegrees = rotationDegrees ~= 0 and rotationDegrees or nil
			texture:SetTexCoord(unpack(coords))
		end
	end)
end

do
	local PixelUtil = namespace("PixelUtil")
	fill(PixelUtil, {
		GetPixelToUIUnitFactor = function()
			local _, physicalHeight = _G.GetPhysicalScreenSize()
			return 768.0 / physicalHeight
		end,
		GetNearestPixelSize = function(uiUnitSize, layoutScale, minPixels)
			if (uiUnitSize == 0 and (not minPixels or minPixels == 0)) then
				return 0
			end
			local uiUnitFactor = PixelUtil.GetPixelToUIUnitFactor()
			local numPixels = _G.Round((uiUnitSize * layoutScale) / uiUnitFactor)
			if (minPixels) then
				if (uiUnitSize < 0.0) then
					if (numPixels > -minPixels) then
						numPixels = -minPixels
					end
				elseif (numPixels < minPixels) then
					numPixels = minPixels
				end
			end
			return numPixels * uiUnitFactor / layoutScale
		end,
		ConvertPixelsToUI = function(pixels, frameScale)
			return pixels * PixelUtil.GetPixelToUIUnitFactor() / frameScale
		end,
		ConvertPixelsToUIForRegion = function(pixels, region)
			return PixelUtil.ConvertPixelsToUI(pixels, region:GetEffectiveScale())
		end,
		SetWidth = function(region, width)
			region:SetWidth(width)
		end,
		SetHeight = function(region, height)
			region:SetHeight(height)
		end,
		SetSize = function(region, width, height)
			region:SetSize(width, height)
		end,
		SetPoint = function(region, point, relativeTo, relativePoint, offsetX, offsetY)
			region:SetPoint(point, relativeTo, relativePoint, offsetX or 0, offsetY or 0)
		end,
		SetStatusBarValue = function(statusBar, value)
			statusBar:SetValue(value)
		end,
	})
end

--------------------------------------------------------------------------------
-- Combat log
--------------------------------------------------------------------------------

function Compat.CombatLogEventInfo(timestamp, token, ...)
	if (not timestamp) then
		if (_G.CombatLogGetCurrentEventInfo) then
			return _G.CombatLogGetCurrentEventInfo()
		end
		return nil
	end
	if (type(select(1, ...)) == "boolean") then
		return timestamp, token, ...
	end
	local srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags = ...
	return timestamp, token, false, srcGUID, srcName, srcFlags, 0, dstGUID, dstName, dstFlags, 0, select(7, ...)
end

--------------------------------------------------------------------------------
-- Talents, templates & scroll frames
--------------------------------------------------------------------------------

do
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
end

do
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
end

--------------------------------------------------------------------------------
-- Instances & encounters
--------------------------------------------------------------------------------

do
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
end

--------------------------------------------------------------------------------
-- GUIDs
--------------------------------------------------------------------------------

do
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
end

--------------------------------------------------------------------------------
-- Misc helpers
--------------------------------------------------------------------------------

do
	local uniqueNameCounter = 0
	function Compat.UniqueName(prefix)
		uniqueNameCounter = uniqueNameCounter + 1
		return (prefix or "DetailsCompat335Frame") .. uniqueNameCounter
	end
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

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

do
	if (not Compat.HasClassicAPI) then
		local virtualEvents = {
			GROUP_ROSTER_UPDATE = {"PARTY_MEMBERS_CHANGED", "RAID_ROSTER_UPDATE"},
			INSPECT_READY = {"INSPECT_TALENT_READY"},
		}
		local nativeToVirtual = {}
		for virtualEvent, natives in pairs(virtualEvents) do
			for _, nativeEvent in ipairs(natives) do
				nativeToVirtual[nativeEvent] = virtualEvent
			end
		end

		local subscribers = {}
		local unitFilters = {}
		local dispatcher = CreateFrame("Frame")
		local inspectQueuedGuid

		local function nativeEventsOf(event)
			return virtualEvents[event] or {event}
		end

		local function subscribe(frame, event, units)
			local list = subscribers[event]
			if (not list) then
				list = {}
				subscribers[event] = list
				for _, nativeEvent in ipairs(nativeEventsOf(event)) do
					dispatcher:RegisterEvent(nativeEvent)
				end
			end
			list[frame] = true
			if (units) then
				unitFilters[frame] = unitFilters[frame] or {}
				unitFilters[frame][event] = units
			elseif (unitFilters[frame]) then
				unitFilters[frame][event] = nil
			end
		end

		local function unsubscribe(frame, event)
			local list = subscribers[event]
			if (not list or not list[frame]) then
				return
			end
			list[frame] = nil
			if (unitFilters[frame]) then
				unitFilters[frame][event] = nil
			end
			if (not next(list)) then
				subscribers[event] = nil
				for _, nativeEvent in ipairs(nativeEventsOf(event)) do
					local virtualEvent = nativeToVirtual[nativeEvent]
					if (not subscribers[nativeEvent] and not (virtualEvent and subscribers[virtualEvent])) then
						dispatcher:UnregisterEvent(nativeEvent)
					end
				end
			end
		end

		local function deliver(event, ...)
			local list = subscribers[event]
			if (not list) then
				return
			end
			local unit = ...
			local targets = {}
			for frame in pairs(list) do
				targets[#targets + 1] = frame
			end
			for i = 1, #targets do
				local frame = targets[i]
				if (list[frame]) then
					local filter = unitFilters[frame] and unitFilters[frame][event]
					if (not filter or filter[1] == unit or filter[2] == unit or filter[3] == unit or filter[4] == unit) then
						local onEvent = frame:GetScript("OnEvent")
						if (onEvent) then
							local ok, err = pcall(onEvent, frame, event, ...)
							if (not ok) then
								callErrorHandler(err)
							end
						end
					end
				end
			end
		end

		dispatcher:SetScript("OnEvent", function(self, nativeEvent, ...)
			local virtualEvent = nativeToVirtual[nativeEvent]
			if (virtualEvent == "GROUP_ROSTER_UPDATE") then
				if (nativeEvent == "PARTY_MEMBERS_CHANGED" and GetNumRaidMembers() > 0) then
					return
				end
				deliver(virtualEvent)
			elseif (virtualEvent == "INSPECT_READY") then
				if (inspectQueuedGuid) then
					local guid = inspectQueuedGuid
					inspectQueuedGuid = nil
					deliver(virtualEvent, guid)
				end
			end
			if (subscribers[nativeEvent]) then
				deliver(nativeEvent, ...)
			end
		end)

		hooksecurefunc("NotifyInspect", function(unit)
			inspectQueuedGuid = UnitGUID(unit)
		end)

		local function registerUnitEvent(frame, event, ...)
			if (virtualEvents[event]) then
				subscribe(frame, event, nil)
				return true
			end
			if (select("#", ...) > 0) then
				subscribe(frame, event, {...})
			else
				frame:RegisterEvent(event)
			end
			return true
		end

		Compat.EventSubscribers = subscribers

		for _, sample in pairs(samples) do
			local methods = getMethods(sample)
			if (methods and not rawget(methods, "__detailsCompatEvents")) then
				methods.__detailsCompatEvents = true
				hooksecurefunc(methods, "RegisterEvent", function(frame, event)
					if (virtualEvents[event]) then
						subscribe(frame, event, nil)
					end
				end)
				hooksecurefunc(methods, "UnregisterEvent", function(frame, event)
					unsubscribe(frame, event)
				end)
				hooksecurefunc(methods, "UnregisterAllEvents", function(frame)
					for event in pairs(subscribers) do
						unsubscribe(frame, event)
					end
				end)
				if (rawget(methods, "RegisterUnitEvent") == nil) then
					methods.RegisterUnitEvent = registerUnitEvent
				end
				if (rawget(methods, "RegisterEventCallback") == nil) then
					methods.RegisterEventCallback = noop
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Widget methods
--------------------------------------------------------------------------------

do
	local sin, cos, sqrt = math.sin, math.cos, math.sqrt

	local regionMethods = {
		SetShown = function(self, shown)
			if (shown) then
				self:Show()
			else
				self:Hide()
			end
		end,
		AdjustPointsOffset = function(self, x, y)
			for i = 1, self:GetNumPoints() do
				local point, relativeTo, relativePoint, offsetX, offsetY = self:GetPoint(i)
				self:SetPoint(point, relativeTo, relativePoint, (offsetX or 0) + (x or 0), (offsetY or 0) + (y or 0))
			end
		end,
		ClearPointsOffset = function(self)
			for i = 1, self:GetNumPoints() do
				local point, relativeTo, relativePoint = self:GetPoint(i)
				self:SetPoint(point, relativeTo, relativePoint, 0, 0)
			end
		end,
		GetPointByName = function(self, pointName)
			for i = 1, self:GetNumPoints() do
				local point, relativeTo, relativePoint, offsetX, offsetY = self:GetPoint(i)
				if (point == pointName) then
					return point, relativeTo, relativePoint, offsetX, offsetY
				end
			end
		end,
		GetScaledRect = function(self)
			local left, bottom, width, height = self:GetRect()
			if (left) then
				local scale = self:GetEffectiveScale()
				return left * scale, bottom * scale, width * scale, height * scale
			end
		end,
		IsRectValid = function(self)
			local left, bottom, width, height = self:GetRect()
			return left ~= nil and width > 0 and height > 0
		end,
		SetIgnoreParentAlpha = function(self, ignore)
			self.__ignoreParentAlpha = ignore
		end,
		IsIgnoringParentAlpha = function(self)
			return self.__ignoreParentAlpha or false
		end,
		SetIgnoreParentScale = function(self, ignore)
			self.__ignoreParentScale = ignore
		end,
		IsIgnoringParentScale = function(self)
			return self.__ignoreParentScale or false
		end,
		GetParentKey = function(self)
			local parent = self:GetParent()
			if (parent) then
				for key, value in pairs(parent) do
					if (value == self) then
						return key
					end
				end
			end
		end,
		IsForbidden = returnFalse,
	}

	local layeredRegionMethods = {
		GetEffectiveScale = function(self)
			local parent = self:GetParent()
			return parent and parent:GetEffectiveScale() or 1
		end,
	}

	local function applyRotation(texture, radians, cx, cy)
		cx, cy = cx or 0.5, cy or 0.5
		local c, s = cos(radians), sin(radians)
		local function corner(x, y)
			x, y = x - cx, y - cy
			return cx + x * c + y * s, cy - x * s + y * c
		end
		local ulx, uly = corner(0, 0)
		local llx, lly = corner(0, 1)
		local urx, ury = corner(1, 0)
		local lrx, lry = corner(1, 1)
		texture:SetTexCoord(ulx, uly, llx, lly, urx, ury, lrx, lry)
	end

	local textureMethods = {
		SetColorTexture = function(self, r, g, b, a)
			self:SetTexture(r or 1, g or 1, b or 1, a or 1)
		end,
		SetAtlas = function(self, atlasName, useAtlasSize)
			local info = atlasName and Compat.AtlasInfo and Compat.AtlasInfo[atlasName]
			if (not info) then
				return false
			end
			self:SetTexture(info[9])
			self:SetTexCoord(info[3], info[4], info[5], info[6])
			if (useAtlasSize) then
				self:SetSize(info[1], info[2])
			end
			self.__atlas = atlasName
			return true
		end,
		GetAtlas = function(self)
			return self.__atlas
		end,
		SetDesaturation = function(self, amount)
			self:SetDesaturated(amount and amount > 0)
			self.__desaturation = amount
		end,
		GetDesaturation = function(self)
			return self.__desaturation or (self:IsDesaturated() and 1 or 0)
		end,
		SetRotation = function(self, radians, cx, cy)
			self.__rotation = radians or 0
			applyRotation(self, radians or 0, cx, cy)
		end,
		GetRotation = function(self)
			return self.__rotation or 0, 0.5, 0.5
		end,
		SetMask = noop,
		SetSnapToPixelGrid = noop,
		IsSnappingToPixelGrid = returnFalse,
		SetTexelSnappingBias = noop,
		GetTexelSnappingBias = function() return 0 end,
		GetTextureFilePath = function(self)
			return self:GetTexture()
		end,
		GetTextureFileID = function(self)
			return self:GetTexture()
		end,
		AddMaskTexture = noop,
		RemoveMaskTexture = noop,
		GetNumMaskTextures = function() return 0 end,
	}

	local fontStringMethods = {
		GetNumLines = function(self)
			local _, fontHeight = self:GetFont()
			if (not fontHeight or fontHeight <= 0) then
				return 1
			end
			local lines = math.floor((self:GetStringHeight() or fontHeight) / fontHeight + 0.5)
			return lines > 0 and lines or 1
		end,
		GetLineHeight = function(self)
			local _, fontHeight = self:GetFont()
			return fontHeight or 0
		end,
		GetFontHeight = function(self)
			local _, fontHeight = self:GetFont()
			return fontHeight or 0
		end,
		SetFontHeight = function(self, height)
			local file, _, flags = self:GetFont()
			if (file) then
				self:SetFont(file, height, flags)
			end
		end,
		SetTextToFit = function(self, text)
			self:SetWidth(0)
			if (text) then
				self:SetText(text)
			end
		end,
		ClearText = function(self)
			self:SetText("")
		end,
		SetTextScale = noop,
		GetTextScale = function() return 1 end,
		SetMaxLines = noop,
	}

	local LINE_TEXTURE = [[Interface\AddOns\Details\Libs\LibGraph-2.0\line]]
	local LINE_FACTOR_2 = 128 / 126 / 2
	local LINE_THICKNESS_FACTOR = 16

	local H_RANK = {LEFT = 0, [""] = 1, RIGHT = 2}
	local V_RANK = {TOP = 0, [""] = 1, BOTTOM = 2}

	local function splitPoint(point)
		local v = point:match("^TOP") or point:match("^BOTTOM") or ""
		local h = point:match("LEFT$") or point:match("RIGHT$") or ""
		return v, h
	end

	local function joinPoint(v, h)
		local point = v .. h
		if (point == "") then
			return "CENTER"
		end
		return point
	end

	local function clampCoord(value)
		if (value > 10000) then
			return 10000
		elseif (value < -10000) then
			return -10000
		end
		return value
	end

	local lineMethods = {
		SetThickness = function(self, thickness)
			self.__thickness = thickness
			self:UpdateLine()
		end,
		GetThickness = function(self)
			return self.__thickness or 1
		end,
		SetStartPoint = function(self, point, relativeTo, x, y)
			if (type(relativeTo) == "number") then
				relativeTo, x, y = nil, relativeTo, x
			end
			self.__start = {point or "CENTER", relativeTo, x or 0, y or 0}
			self:UpdateLine()
		end,
		SetEndPoint = function(self, point, relativeTo, x, y)
			if (type(relativeTo) == "number") then
				relativeTo, x, y = nil, relativeTo, x
			end
			self.__end = {point or "CENTER", relativeTo, x or 0, y or 0}
			self:UpdateLine()
		end,
		GetStartPoint = function(self)
			local p = self.__start
			if (p) then
				return p[1], p[2], p[3], p[4]
			end
		end,
		GetEndPoint = function(self)
			local p = self.__end
			if (p) then
				return p[1], p[2], p[3], p[4]
			end
		end,
		SetColorTexture = function(self, r, g, b, a)
			self:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
		end,
		UpdateLine = function(self)
			local s, e = self.__start, self.__end
			if (not s or not e) then
				return
			end
			local parent = self:GetParent()
			if (not parent.__lines335) then
				parent.__lines335 = {}
				parent:HookScript("OnSizeChanged", function(frame)
					for line in pairs(frame.__lines335) do
						line:UpdateLine()
					end
				end)
			end
			parent.__lines335[self] = true
			local thickness = self.__thickness or 1
			local startTarget, endTarget = s[2] or parent, e[2] or parent
			local startPoint, endPoint = s[1]:upper(), e[1]:upper()
			self:ClearAllPoints()
			if (startTarget == endTarget) then
				local sv, sh = splitPoint(startPoint)
				local ev, eh = splitPoint(endPoint)
				if (sv == ev and s[4] == e[4]) then
					self:SetSolid335()
					local l, r = s, e
					local lh, rh = sh, eh
					if (H_RANK[sh] > H_RANK[eh] or (sh == eh and s[3] > e[3])) then
						l, r, lh, rh = e, s, eh, sh
					end
					self:SetPoint("TOPLEFT", startTarget, joinPoint(sv, lh), l[3], s[4] + thickness / 2)
					self:SetPoint("BOTTOMRIGHT", startTarget, joinPoint(sv, rh), r[3], s[4] - thickness / 2)
					return
				elseif (sh == eh and s[3] == e[3]) then
					self:SetSolid335()
					local t, b = s, e
					local tv, bv = sv, ev
					if (V_RANK[sv] > V_RANK[ev] or (sv == ev and s[4] < e[4])) then
						t, b, tv, bv = e, s, ev, sv
					end
					self:SetPoint("TOPLEFT", startTarget, joinPoint(tv, sh), s[3] - thickness / 2, t[4])
					self:SetPoint("BOTTOMRIGHT", startTarget, joinPoint(bv, sh), s[3] + thickness / 2, b[4])
					return
				elseif (startPoint == endPoint) then
					self:DrawDiagonal335(startTarget, startPoint, s[3], s[4], e[3], e[4], thickness)
					return
				end
			end
			local function anchorOffset(anchor, target)
				local px, py = 0, 0
				local point = anchor[1]:upper()
				local w, h = target:GetWidth() or 0, target:GetHeight() or 0
				if (point:find("LEFT")) then px = -w / 2 elseif (point:find("RIGHT")) then px = w / 2 end
				if (point:find("TOP")) then py = h / 2 elseif (point:find("BOTTOM")) then py = -h / 2 end
				return px + anchor[3], py + anchor[4]
			end
			local sx, sy = anchorOffset(s, startTarget)
			local ex, ey = anchorOffset(e, endTarget)
			if (startTarget ~= endTarget) then
				local scx, scy = startTarget:GetCenter()
				local ecx, ecy = endTarget:GetCenter()
				if (scx and ecx) then
					local scale = endTarget:GetEffectiveScale() / startTarget:GetEffectiveScale()
					ex = ex + (ecx * scale - scx)
					ey = ey + (ecy * scale - scy)
				end
			end
			if (sy == ey) then
				self:SetSolid335()
				self:SetPoint("LEFT", startTarget, "CENTER", math.min(sx, ex), sy)
				self:SetWidth(math.max(math.abs(ex - sx), 1))
				self:SetHeight(thickness)
				return
			elseif (sx == ex) then
				self:SetSolid335()
				self:SetPoint("BOTTOM", startTarget, "CENTER", sx, math.min(sy, ey))
				self:SetHeight(math.max(math.abs(ey - sy), 1))
				self:SetWidth(thickness)
				return
			end
			self:DrawDiagonal335(startTarget, "CENTER", sx, sy, ex, ey, thickness)
		end,
		SetSolid335 = function(self)
			if (self.__diagonal) then
				self.__diagonal = nil
				self:SetTexture(1, 1, 1, 1)
				self:SetTexCoord(0, 1, 0, 1)
			end
		end,
		DrawDiagonal335 = function(self, target, refPoint, sx, sy, ex, ey, thickness)
			if (not self.__diagonal) then
				self.__diagonal = true
				self:SetTexture(LINE_TEXTURE)
			end
			local dx, dy = ex - sx, ey - sy
			local cx, cy = (sx + ex) / 2, (sy + ey) / 2
			if (dx < 0) then
				dx, dy = -dx, -dy
			end
			local l = sqrt(dx * dx + dy * dy)
			if (not (l > 0.01)) then
				self:SetPoint("CENTER", target, refPoint, sx, sy)
				self:SetSize(0.01, 0.01)
				return
			end
			local w = thickness * LINE_THICKNESS_FACTOR
			local sn, cs = -dy / l, dx / l
			local sc = sn * cs
			local bwid, bhgt, blx, bly, tlx, tly, trx, try, brx, bry
			if (dy >= 0) then
				bwid = ((l * cs) - (w * sn)) * LINE_FACTOR_2
				bhgt = ((w * cs) - (l * sn)) * LINE_FACTOR_2
				blx, bly, bry = (w / l) * sc, sn * sn, (l / w) * sc
				brx, tlx, tly, trx = 1 - bly, bly, 1 - bry, 1 - blx
				try = brx
			else
				bwid = ((l * cs) + (w * sn)) * LINE_FACTOR_2
				bhgt = ((w * cs) + (l * sn)) * LINE_FACTOR_2
				blx, bly, brx = sn * sn, -(l / w) * sc, 1 + (w / l) * sc
				bry, tlx, tly, try = blx, 1 - brx, 1 - blx, 1 - bly
				trx = tly
			end
			self:SetTexCoord(clampCoord(tlx), clampCoord(tly), clampCoord(blx), clampCoord(bly), clampCoord(trx), clampCoord(try), clampCoord(brx), clampCoord(bry))
			self:SetPoint("BOTTOMLEFT", target, refPoint, cx - bwid, cy - bhgt)
			self:SetPoint("TOPRIGHT", target, refPoint, cx + bwid, cy + bhgt)
		end,
	}

	local frameMethods = {
		SetResizeBounds = function(self, minWidth, minHeight, maxWidth, maxHeight)
			if (minWidth and minHeight) then
				self:SetMinResize(minWidth, minHeight)
			end
			if (maxWidth and maxHeight) then
				self:SetMaxResize(maxWidth, maxHeight)
			end
		end,
		GetResizeBounds = function(self)
			local minWidth, minHeight = self:GetMinResize()
			local maxWidth, maxHeight = self:GetMaxResize()
			return minWidth or 0, minHeight or 0, maxWidth or 0, maxHeight or 0
		end,
		SetClipsChildren = function(self, clips)
			self.__clipsChildren = clips
		end,
		DoesClipChildren = function(self)
			return self.__clipsChildren or false
		end,
		SetUsingParentLevel = function(self, using)
			local parent = self:GetParent()
			if (using and parent) then
				self:SetFrameLevel(parent:GetFrameLevel())
			end
		end,
		CreateLine = function(self, name, layer, template, subLevel)
			local line = self:CreateTexture(name, layer or "ARTWORK", template)
			for methodName, func in pairs(lineMethods) do
				line[methodName] = func
			end
			line.__isLine = true
			line:SetTexture(1, 1, 1, 1)
			return line
		end,
		SetFixedFrameStrata = noop,
		SetFixedFrameLevel = noop,
		SetFlattensRenderLayers = noop,
		SetIsFrameBuffer = noop,
		SetPropagateKeyboardInput = noop,
		GetPropagateKeyboardInput = returnFalse,
		SetPropagateMouseClicks = noop,
		SetPropagateMouseMotion = noop,
		RegisterForMouse = noop,
		SetPassThroughButtons = noop,
		SetMouseClickEnabled = function(self, enabled) if (enabled) then self:EnableMouse(true) end end,
		SetMouseMotionEnabled = function(self, enabled) if (enabled) then self:EnableMouse(true) end end,
	}

	local buttonMethods = {
		SetEnabled = function(self, enabled)
			if (enabled) then
				self:Enable()
			else
				self:Disable()
			end
		end,
		ClearNormalTexture = function(self)
			self:SetNormalTexture("")
		end,
		ClearPushedTexture = function(self)
			self:SetPushedTexture("")
		end,
		ClearHighlightTexture = function(self)
			self:SetHighlightTexture("")
		end,
		ClearDisabledTexture = function(self)
			self:SetDisabledTexture("")
		end,
		SetNormalAtlas = function(self, atlasName)
			self:SetNormalTexture("")
			local texture = self:GetNormalTexture()
			if (texture) then
				texture:SetAtlas(atlasName)
			end
		end,
		SetPushedAtlas = function(self, atlasName)
			self:SetPushedTexture("")
			local texture = self:GetPushedTexture()
			if (texture) then
				texture:SetAtlas(atlasName)
			end
		end,
		SetHighlightAtlas = function(self, atlasName)
			self:SetHighlightTexture("")
			local texture = self:GetHighlightTexture()
			if (texture) then
				texture:SetAtlas(atlasName)
			end
		end,
		SetDisabledAtlas = function(self, atlasName)
			self:SetDisabledTexture("")
			local texture = self:GetDisabledTexture()
			if (texture) then
				texture:SetAtlas(atlasName)
			end
		end,
	}

	local editBoxMethods = {
		SetEnabled = function(self, enabled)
			if (enabled) then
				self:EnableMouse(true)
				self:EnableKeyboard(true)
				self.__disabled = nil
			else
				self:ClearFocus()
				self:EnableMouse(false)
				self:EnableKeyboard(false)
				self.__disabled = true
			end
		end,
		Enable = function(self)
			self:SetEnabled(true)
		end,
		Disable = function(self)
			self:SetEnabled(false)
		end,
		IsEnabled = function(self)
			return not self.__disabled
		end,
	}

	local sliderMethods = {
		SetEnabled = function(self, enabled)
			if (enabled) then
				self:Enable()
			else
				self:Disable()
			end
		end,
		SetObeyStepOnDrag = function(self, obey)
			self.__obeyStepOnDrag = obey
		end,
		GetObeyStepOnDrag = function(self)
			return self.__obeyStepOnDrag or false
		end,
		SetStepsPerPage = function(self, steps)
			self.__stepsPerPage = steps
		end,
		GetStepsPerPage = function(self)
			return self.__stepsPerPage or 1
		end,
	}

	local statusBarMethods = {
		SetStatusBarAtlas = function(self, atlasName)
			local texture = self:GetStatusBarTexture()
			if (not texture) then
				self:SetStatusBarTexture([[Interface\Buttons\WHITE8X8]])
				texture = self:GetStatusBarTexture()
			end
			if (texture) then
				texture:SetAtlas(atlasName)
			end
		end,
		GetStatusBarAtlas = function(self)
			local texture = self:GetStatusBarTexture()
			return texture and texture.__atlas
		end,
		SetFillStyle = noop,
		SetReverseFill = noop,
		GetReverseFill = returnFalse,
		SetRotatesTexture = noop,
		SetStatusBarDesaturated = noop,
		SetMinMaxSmoothedValue = function(self, minValue, maxValue)
			self:SetMinMaxValues(minValue, maxValue)
		end,
		SetSmoothedValue = function(self, value)
			self:SetValue(value)
		end,
	}

	local cooldownMethods = {
		SetDrawBling = noop,
		GetDrawBling = returnFalse,
		SetDrawSwipe = function(self, draw)
			self.__drawSwipe = draw
		end,
		GetDrawSwipe = function(self)
			return self.__drawSwipe ~= false
		end,
		SetDrawEdge = noop,
		SetEdgeScale = noop,
		SetEdgeTexture = noop,
		SetEdgeColor = noop,
		SetBlingTexture = noop,
		SetSwipeTexture = noop,
		SetSwipeColor = noop,
		SetUseCircularEdge = noop,
		SetHideCountdownNumbers = function(self, hide)
			self.noCooldownCount = hide or nil
		end,
		SetCountdownFont = noop,
		SetCooldownDuration = function(self, duration)
			self:SetCooldown(GetTime(), duration)
		end,
		SetCooldownFromDurationObject = noop,
		Pause = noop,
		Resume = noop,
		IsPaused = returnFalse,
		SetPaused = noop,
		Clear = function(self)
			self:Hide()
		end,
		GetCooldownTimes = function(self)
			return (self.__start or 0) * 1000, (self.__duration or 0) * 1000
		end,
		GetCooldownDuration = function(self)
			return (self.__duration or 0) * 1000
		end,
	}

	local modelMethods = {
		SetDisplayInfo = noop,
		SetPortraitZoom = noop,
		SetTransform = noop,
		ClearTransform = noop,
		SetCamDistanceScale = noop,
		SetViewTranslation = noop,
	}

	local animationGroupMethods = {
		Restart = function(self)
			self:Stop()
			self:Play()
		end,
		SetPlaying = function(self, play)
			if (play) then
				self:Play()
			else
				self:Stop()
			end
		end,
		SetToFinalAlpha = noop,
	}

	local animationMethods = {
		Restart = animationGroupMethods.Restart,
		SetPlaying = animationGroupMethods.SetPlaying,
		SetTarget = noop,
		SetChildKey = noop,
		SetTargetKey = noop,
		SetTargetName = noop,
		SetTargetParent = noop,
	}

	local alphaMethods = {
		SetFromAlpha = function(self, fromAlpha)
			self.__fromAlpha = fromAlpha
			self:SetChange((self.__toAlpha or fromAlpha) - fromAlpha)
		end,
		SetToAlpha = function(self, toAlpha)
			self.__toAlpha = toAlpha
			self:SetChange(toAlpha - (self.__fromAlpha or 0))
		end,
		GetFromAlpha = function(self)
			return self.__fromAlpha or 0
		end,
		GetToAlpha = function(self)
			return self.__toAlpha or 0
		end,
	}

	local scaleMethods = {
		SetScaleFrom = function(self, x, y)
			self.__scaleFromX, self.__scaleFromY = x, y
			local toX, toY = self.__scaleToX or 1, self.__scaleToY or 1
			self:SetScale((x ~= 0) and (toX / x) or toX, (y ~= 0) and (toY / y) or toY)
		end,
		SetScaleTo = function(self, x, y)
			self.__scaleToX, self.__scaleToY = x, y
			local fromX, fromY = self.__scaleFromX or 1, self.__scaleFromY or 1
			self:SetScale((fromX ~= 0) and (x / fromX) or x, (fromY ~= 0) and (y / fromY) or y)
		end,
		GetScaleFrom = function(self)
			return self.__scaleFromX or 1, self.__scaleFromY or 1
		end,
		GetScaleTo = function(self)
			return self.__scaleToX or 1, self.__scaleToY or 1
		end,
	}

	local translationMethods = {}

	for frameType, sample in pairs(samples) do
		local methods = getMethods(sample)
		if (methods) then
			addMethods(methods, regionMethods)
			addMethods(methods, frameMethods)
			if (frameType == "Button" or frameType == "CheckButton") then
				addMethods(methods, buttonMethods)
			elseif (frameType == "EditBox") then
				addMethods(methods, editBoxMethods)
			elseif (frameType == "Slider") then
				addMethods(methods, sliderMethods)
			elseif (frameType == "StatusBar") then
				addMethods(methods, statusBarMethods)
			elseif (frameType == "Cooldown") then
				addMethods(methods, cooldownMethods)
				if (not rawget(methods, "__detailsCompatCooldown")) then
					methods.__detailsCompatCooldown = true
					hooksecurefunc(methods, "SetCooldown", function(self, start, duration)
						self.__start, self.__duration = start, duration
					end)
				end
			elseif (frameType == "Model" or frameType == "PlayerModel") then
				addMethods(methods, modelMethods)
			end
		end
	end

	do
		local mouseScripts = {OnEnter = true, OnLeave = true, OnMouseDown = true, OnMouseUp = true, OnDragStart = true, OnReceiveDrag = true}
		local strfind, debugstack = string.find, debugstack

		local isDetailsCaller = function()
			local stack = debugstack(1, 8, 0) or ""
			for line in stack:gmatch("[^\n]+") do
				if ((strfind(line, "%.lua:%d") or strfind(line, "%[string")) and not strfind(line, "compat335.lua", 1, true)) then
					if (strfind(line, "AddOns\\Details", 1, true)) then
						return true
					end
					if (strfind(line, "^%s*%.%.%.")) then
						return (strfind(line, "Details", 1, true) or strfind(line, "window_breakdown", 1, true)) ~= nil
					end
					return false
				end
			end
			return false
		end

		local onSetScript = function(self, scriptName, func)
			if (not func) then
				return
			end
			if (mouseScripts[scriptName]) then
				if (not self:IsMouseEnabled() and isDetailsCaller()) then
					self:EnableMouse(true)
				end
			elseif (scriptName == "OnMouseWheel") then
				if (isDetailsCaller()) then
					self:EnableMouseWheel(true)
				end
			end
		end

		for frameType, sample in pairs(samples) do
			local methods = getMethods(sample)
			if (methods and not rawget(methods, "__detailsCompatMouse") and frameType ~= "Button" and frameType ~= "CheckButton") then
				methods.__detailsCompatMouse = true
				hooksecurefunc(methods, "SetScript", onSetScript)
			end
		end

		local detailsCreateLine = frameMethods.CreateLine
		local lineWrappers = {[detailsCreateLine] = true}

		local installLineWrappers = function()
			for _, sample in pairs(samples) do
				local methods = getMethods(sample)
				local otherCreateLine = methods and rawget(methods, "CreateLine")
				if (otherCreateLine and not lineWrappers[otherCreateLine]) then
					local wrapper = function(self, ...)
						if (isDetailsCaller()) then
							return detailsCreateLine(self, ...)
						end
						return otherCreateLine(self, ...)
					end
					lineWrappers[wrapper] = true
					methods.CreateLine = wrapper
				end
			end
		end
		installLineWrappers()

		local lineEventFrame = CreateFrame("frame")
		lineEventFrame:RegisterEvent("ADDON_LOADED")
		lineEventFrame:RegisterEvent("PLAYER_LOGIN")
		lineEventFrame:SetScript("OnEvent", installLineWrappers)
	end

	do
		local methods = getMethods(sampleTexture)
		if (methods) then
			addMethods(methods, regionMethods)
			addMethods(methods, layeredRegionMethods)
			addMethods(methods, textureMethods)
		end
		methods = getMethods(sampleFontString)
		if (methods) then
			addMethods(methods, regionMethods)
			addMethods(methods, layeredRegionMethods)
			addMethods(methods, fontStringMethods)
		end
		methods = getMethods(sampleAnimGroup)
		if (methods) then
			addMethods(methods, animationGroupMethods)
		end
		for _, animType in ipairs({"Animation", "Alpha", "Scale", "Translation", "Rotation"}) do
			local ok, anim = pcall(sampleAnimGroup.CreateAnimation, sampleAnimGroup, animType)
			methods = ok and getMethods(anim)
			if (methods) then
				addMethods(methods, animationMethods)
				if (animType == "Alpha") then
					addMethods(methods, alphaMethods)
				elseif (animType == "Scale") then
					addMethods(methods, scaleMethods)
				elseif (animType == "Translation") then
					addMethods(methods, translationMethods)
				end
			end
		end
		local font = CreateFont("DetailsCompat335SampleFont")
		methods = getMethods(font)
		if (methods) then
			addMethods(methods, {
				GetFontObjectForAlphabet = function(self) return self end,
			})
		end
	end

	Compat.ApplyTextureRotation = applyRotation
end

--------------------------------------------------------------------------------
-- Mask textures
--------------------------------------------------------------------------------

do
	local function createMaskTexture(self, name, layer)
		local mask = self:CreateTexture(name, layer or "ARTWORK")
		mask:Hide()
		mask.Show = noop
		mask.SetShown = noop
		mask.__isDummyMask = true
		return mask
	end
	for _, frameType in ipairs({"Frame", "Button", "CheckButton", "StatusBar", "Slider", "EditBox", "ScrollFrame", "GameTooltip", "Cooldown"}) do
		local sample = samples[frameType]
		local methods = getMethods(sample)
		if (methods) then
			local current = rawget(methods, "CreateMaskTexture")
			if (not current or current(sample) == nil) then
				methods.CreateMaskTexture = createMaskTexture
			end
		end
	end
end

--------------------------------------------------------------------------------
-- FontString width
--------------------------------------------------------------------------------

do
	local methods = getMethods(sampleFontString)

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

--------------------------------------------------------------------------------
-- Fonts
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- XML template support
--------------------------------------------------------------------------------

function DetailsCompat335_OverlayGlowOnUpdate(self, elapsed)
	if (AnimateTexCoords and self.ants) then
		AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01)
	end
end

function DetailsCompat335_OverlayGlowAnimInFinished(animGroup)
	local frame = animGroup:GetParent()
	local frameWidth, frameHeight = frame:GetSize()
	frame.spark:SetAlpha(0)
	frame.innerGlow:SetAlpha(0)
	frame.innerGlow:SetSize(frameWidth, frameHeight)
	frame.innerGlowOver:SetAlpha(0)
	frame.outerGlow:SetSize(frameWidth, frameHeight)
	frame.outerGlowOver:SetAlpha(0)
	frame.outerGlowOver:SetSize(frameWidth, frameHeight)
	frame.ants:SetAlpha(1)
end

function DetailsCompat335_OverlayGlowAnimOutFinished(animGroup)
	local overlay = animGroup:GetParent()
	overlay:Hide()
end

Compat.BackdropTemplateMixin = Compat.BackdropTemplateMixin or {
	OnBackdropLoaded = function(self)
		if (self.backdropInfo) then
			self:SetBackdrop(self.backdropInfo)
		end
	end,
	OnBackdropSizeChanged = function() end,
	ApplyBackdrop = function(self)
		if (self.backdropInfo) then
			self:SetBackdrop(self.backdropInfo)
		end
	end,
	ClearBackdrop = function(self)
		self:SetBackdrop(nil)
		self.backdropInfo = nil
	end,
	HasBackdropInfo = function(self, backdropInfo)
		return self.backdropInfo == backdropInfo
	end,
	SetBorderBlendMode = function() end,
	GetEdgeSize = function(self)
		return self.backdropInfo and self.backdropInfo.edgeSize or 0
	end,
}
