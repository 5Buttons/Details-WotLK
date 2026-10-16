--[3.3.5]

local Details = _G.Details
local addonName, Details222 = ...

local DeathRecap335 = {}
Details222.DeathRecap335 = DeathRecap335

local RECAP_TITLE = "Death Recap"
local RECAP_UNAVAILABLE = "Death Recap unavailable."
local HOST_MIN_WIDTH = 380

local externalHosts = {
	"StandaloneDeathRecapFrame",
	"ElvUI_DeathRecapFrame",
}

local host
local hostEntries
local watcher

local function GetExternalHost()
	for _, frameName in ipairs(externalHosts) do
		local frame = _G[frameName]
		if (frame and frame.DeathRecapEntry) then
			return frame
		end
	end
end

local function CreateOwnHost()
	local frame = CreateFrame("frame", "DetailsDeathRecapHostFrame", UIParent)
	frame:SetBackdrop({
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
		edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
		edgeSize = 8,
		insets = {left = 1, right = 1, top = 1, bottom = 1},
	})
	frame:SetBackdropColor(0, 0, 0, 0.85)
	frame:SetFrameStrata("HIGH")
	frame:SetSize(HOST_MIN_WIDTH, 326)
	frame:SetPoint("center")
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:Hide()
	tinsert(UISpecialFrames, frame:GetName())

	frame.Title = frame:CreateFontString(nil, "artwork", "GameFontNormalLarge")
	frame.Title:SetPoint("top", 0, -9)
	frame.Title:SetText(RECAP_TITLE)

	frame.Unavailable = frame:CreateFontString(nil, "artwork", "GameFontNormal")
	frame.Unavailable:SetPoint("center")
	frame.Unavailable:SetText(RECAP_UNAVAILABLE)
	frame.Unavailable:Hide()

	local closeX = CreateFrame("button", "$parentCloseXButton", frame, "UIPanelCloseButton")
	closeX:SetPoint("topright", 4, 4)

	local closeButton = CreateFrame("button", "$parentCloseButton", frame, "UIPanelButtonTemplate")
	closeButton:SetSize(144, 21)
	closeButton:SetPoint("bottom", 0, 15)
	closeButton:SetText(CLOSE)
	closeButton:SetScript("OnClick", function() frame:Hide() end)

	frame.DeathRecapEntry = {}
	return frame
end

local function SetHostEntriesShown(bShown)
	for i, entry in ipairs(hostEntries) do
		if (bShown and entry.wasShown) then
			entry.frame:Show()
		elseif (not bShown) then
			entry.frame:Hide()
		end
	end
end

local function SaveHostEntries()
	for i, entry in ipairs(hostEntries) do
		entry.wasShown = entry.frame:IsShown()
	end
	host.unavailableWasShown = host.Unavailable:IsShown()
end

local function HasDetailsLines()
	if (Details.DeathRecap and Details.DeathRecap.Lines) then
		for i = 1, #Details.DeathRecap.Lines do
			if (Details.DeathRecap.Lines[i]:IsShown()) then
				return true
			end
		end
	end
	return false
end

function DeathRecap335.Refresh(segment)
	if (not host) then
		return
	end

	Details.OpenDetailsDeathRecap(segment)

	if (HasDetailsLines()) then
		SetHostEntriesShown(false)
		host.Unavailable:Hide()
	else
		SetHostEntriesShown(true)
		if (not host.isExternal or host.unavailableWasShown) then
			host.Unavailable:Show()
		end
	end
end

local function AttachToHost(frame, bIsExternal)
	host = frame
	host.isExternal = bIsExternal
	hostEntries = {}

	for i = 1, 5 do
		local entry = host.DeathRecapEntry[i]
		if (entry) then
			hostEntries[#hostEntries + 1] = {frame = entry}
		end
		host["Recap" .. i] = entry or {Hide = function() end}
	end

	if (host:GetWidth() < HOST_MIN_WIDTH) then
		host:SetWidth(HOST_MIN_WIDTH)
	end

	watcher = CreateFrame("frame", nil, host)
	watcher:SetScript("OnUpdate", function(self)
		if (self.pending or self.recapID ~= host.recapID) then
			self.pending = nil
			self.recapID = host.recapID
			SaveHostEntries()
			DeathRecap335.Refresh()
		end
	end)
	host:HookScript("OnShow", function()
		watcher.pending = true
	end)
	host:HookScript("OnHide", function()
		watcher.recapID = nil
	end)
end

local function AttachToExternalHost()
	if (not host) then
		local externalHost = GetExternalHost()
		if (externalHost) then
			AttachToHost(externalHost, true)
		end
	end
end

function DeathRecap335.GetHost()
	AttachToExternalHost()
	if (not host) then
		AttachToHost(CreateOwnHost(), false)
	end
	return host
end

function DeathRecap335.HasPlayerDeath()
	local combat = Details.tabela_vigente
	local playerName = Details.playername
	local segmentsTable = Details:GetCombatSegments()

	for _, segment in ipairs({combat, segmentsTable and segmentsTable[1]}) do
		local deaths = segment and segment.last_events_tables
		if (deaths) then
			for index = #deaths, 1, -1 do
				if (deaths[index][3] == playerName) then
					return true
				end
			end
		end
	end
	return false
end

function DeathRecap335.Open()
	local frame = DeathRecap335.GetHost()
	if (frame.isExternal) then
		return
	end
	if (frame:IsShown()) then
		frame:Hide()
	else
		frame:Show()
	end
end

local function ShouldShowDeathButton()
	if (not Details.death_recap or not Details.death_recap.enabled) then
		return false
	end
	if (GetExternalHost()) then
		return false
	end
	return DeathRecap335.HasPlayerDeath()
end

local function ReshowDeathPopup()
	if (UnitIsDead("player") and not StaticPopup_FindVisible("DEATH")) then
		StaticPopup_Show("DEATH", GetReleaseTimeRemaining(), SECONDS)
	end
end

local function HookDeathPopup()
	local dialog = StaticPopupDialogs and StaticPopupDialogs["DEATH"]
	if (not dialog or dialog.button3) then
		return
	end

	local originalOnShow = dialog.OnShow
	local originalOnHide = dialog.OnHide

	dialog.button3 = RECAP_TITLE
	dialog.DisplayButton3 = ShouldShowDeathButton

	dialog.OnShow = function(self, ...)
		if (originalOnShow) then
			originalOnShow(self, ...)
		end
		if (self.button3:IsShown() and not HasSoulstone()) then
			self.button2:Hide()
			self.button1:ClearAllPoints()
			self.button1:SetPoint("bottomright", self, "bottom", -6, 16)
			self.button3:ClearAllPoints()
			self.button3:SetPoint("left", self.button1, "right", 13, 0)
		end
	end

	dialog.OnHide = function(self, ...)
		if (originalOnHide) then
			originalOnHide(self, ...)
		end
		if (host and not host.isExternal and not UnitIsDead("player")) then
			host:Hide()
		end
	end

	dialog.OnAlt = function()
		DeathRecap335.Open()
		Details.Schedules.After(0.01, ReshowDeathPopup)
	end
end

HookDeathPopup()

local eventFrame = CreateFrame("frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_DEAD")
eventFrame:SetScript("OnEvent", AttachToExternalHost)
