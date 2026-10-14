--[3.3.5]

local Compat = DetailsCompat335

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
