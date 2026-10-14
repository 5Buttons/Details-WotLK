--[3.3.5]

local _G = _G
local type, select, pairs, ipairs, next, pcall, tonumber, tostring = type, select, pairs, ipairs, next, pcall, tonumber, tostring
local floor, ceil, max = math.floor, math.ceil, math.max
local unpack = unpack
local Compat = _G.DetailsCompat335

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

Compat.HasClassicAPI = (_G.IsAddOnLoaded and _G.IsAddOnLoaded("!!!ClassicAPI")) and true or false

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

do
	if (not Compat.HasClassicAPI) then
		local frameTypes = {"Frame", "Button", "CheckButton", "StatusBar", "Slider", "EditBox", "ScrollFrame", "GameTooltip",
			"Model", "PlayerModel", "Cooldown", "SimpleHTML", "ScrollingMessageFrame", "MessageFrame", "ColorSelect"}

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

		for _, frameType in ipairs(frameTypes) do
			local ok, sample = pcall(CreateFrame, frameType)
			if (ok and sample) then
				sample:Hide()
				local methods = getmetatable(sample).__index
				if (type(methods) == "table" and not rawget(methods, "__detailsCompatEvents")) then
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
end
