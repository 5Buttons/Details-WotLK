--[3.3.5]

local _G = _G
local type, pairs, ipairs, pcall = type, pairs, ipairs, pcall
local sin, cos, sqrt, atan2 = math.sin, math.cos, math.sqrt, math.atan2
local Compat = _G.DetailsCompat335

local noop = function() end
local returnFalse = function() return false end

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
		self:SetTexture(r or 1, g or 1, b or 1, a or 1)
	end,
	UpdateLine = function(self)
		local s, e = self.__start, self.__end
		if (not s or not e) then
			return
		end
		local parent = self:GetParent()
		local function anchorOffset(anchor)
			local target = anchor[2] or parent
			local px, py = 0, 0
			local point = anchor[1]:upper()
			local w, h = target:GetWidth() or 0, target:GetHeight() or 0
			if (point:find("LEFT")) then px = -w / 2 elseif (point:find("RIGHT")) then px = w / 2 end
			if (point:find("TOP")) then py = h / 2 elseif (point:find("BOTTOM")) then py = -h / 2 end
			return target, px + anchor[3], py + anchor[4]
		end
		local startTarget, sx, sy = anchorOffset(s)
		local endTarget, ex, ey = anchorOffset(e)
		local thickness = self.__thickness or 1
		self:ClearAllPoints()
		if (startTarget == endTarget and (sy == ey or sx == ex)) then
			if (sy == ey) then
				self:SetPoint("LEFT", startTarget, "CENTER", math.min(sx, ex), sy)
				self:SetWidth(math.max(math.abs(ex - sx), 1))
				self:SetHeight(thickness)
			else
				self:SetPoint("BOTTOM", startTarget, "CENTER", sx, math.min(sy, ey))
				self:SetHeight(math.max(math.abs(ey - sy), 1))
				self:SetWidth(thickness)
			end
			return
		end
		local dx, dy = ex - sx, ey - sy
		local length = sqrt(dx * dx + dy * dy)
		self:SetPoint("CENTER", startTarget, "CENTER", (sx + ex) / 2, (sy + ey) / 2)
		self:SetSize(math.max(length, 1), thickness)
		applyRotation(self, atan2(dy, dx))
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
