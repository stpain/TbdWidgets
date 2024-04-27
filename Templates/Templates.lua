

local addonName, addon = ...;



TBDSimpleIconLabelFrameMixin = {}
function TBDSimpleIconLabelFrameMixin:OnLoad()

end
function TBDSimpleIconLabelFrameMixin:SetDataBinding(binding, height)

    --self.anim:Play()
    local x, y = self:GetSize()

    if binding.rightButton then
        if binding.rightButton.size then
            self.rightButton:SetSize(binding.rightButton.size[1], binding.rightButton.size[2])
        else
            self.rightButton:SetSize(height - 4, height - 4)
        end

        if binding.rightButton.offsetY then
            self.rightButton:ClearAllPoints()
            self.rightButton:SetPoint("RIGHT", binding.rightButton.offsetY, 0)
        end

        if binding.rightButton.atlas then
            self.rightButton.icon:SetAtlas(binding.rightButton.atlas)
        end

        if binding.rightButton.onClick then
            self.rightButton:SetScript("OnClick", binding.rightButton.onClick)
        end

        self.rightButton:Show()
    else
        self.rightButton:Hide()
        self.rightButton:SetSize(1, height - 4)
    end

    if binding.backgroundAlpha then
        self.background:SetAlpha(binding.backgroundAlpha)
    else
        self.background:SetAlpha(0)
    end
    if binding.highlightAtlas then
        self.highlight:SetAtlas(binding.highlightAtlas)
    end
    if binding.backgroundAtlas then
        self.background:SetAtlas(binding.backgroundAtlas)
        if binding.backgroundAlpha then
            self.background:SetAlpha(binding.backgroundAlpha)
        else
            self.background:SetAlpha(1)
        end
    else
        if binding.backgroundRGB then
            self.background:SetColorTexture(binding.backgroundRGB.r, binding.backgroundRGB.g, binding.backgroundRGB.b)
         else
             self.background:SetColorTexture(0,0,0)
         end
    end

    if binding.label then
        self.label:SetText(binding.label)
    end
    if binding.labelRight then
        self.labelRight:SetText(binding.labelRight)
        self.label:SetPoint("RIGHT", -height, 0)
    end

    if binding.fontObject then
        self.label:SetFontObject(binding.fontObject)
        self.labelRight:SetFontObject(binding.fontObject)
    else
        self.label:SetFontObject(GameFontWhite)
        self.labelRight:SetFontObject(GameFontWhite)
    end

    if binding.atlas then
        self.icon:SetAtlas(binding.atlas)
    elseif binding.icon then
        self.icon:SetTexture(binding.icon)
    end

    if binding.atlasRight then
        self.iconRight:SetAtlas(binding.atlasRight)
    elseif binding.iconRight then
        self.iconRight:SetTexture(binding.iconRight)
    end

    if binding.iconCoordsRight then
        self.icon:SetTexCoord(binding.iconCoordsRight[1], binding.iconCoordsRight[2], binding.iconCoordsRight[3], binding.iconCoordsRight[4])
    else
        self.icon:SetTexCoord(0,1,0,1)
    end

    if not binding.icon and not binding.atlas then
        self.icon:SetSize(1, height-4)
    else
        self.icon:SetSize(height-4, height-4)
    end

    if binding.iconSize then
        self.icon:SetSize(binding.iconSize[1], binding.iconSize[2])
    end
    if binding.iconSizeRight then
        self.iconRight:SetSize(binding.iconSizeRight[1], binding.iconSizeRight[2])
    end

    if binding.showMask then
        local x, y = self.icon:GetSize()

        if binding.showMask == "circle" then
            self.circleMask:Show()
            self.circleMask:SetSize(x, y)
            self.ring:SetSize(x*1.8, y*1.8)
            self.ring:Show()

        elseif binding.showMask == "square" then

            if WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
                
            elseif WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
                self.squareMask:SetAtlas("UI-HUD-ActionBar-IconFrame-Mask")
            end

            self.squareMask:Show()
            self.squareMask:SetSize(x, y)
            self.ring:Hide()
        else

            --keeping this for compatability with older version passsing a bool value
            self.circleMask:Show()
            self.circleMask:SetSize(x, y)
            self.ring:SetSize(x*1.8, y*1.8)
            self.ring:Show()
        end

    else
        self.circleMask:Hide()
        self.squareMask:Hide()
        self.ring:Hide()
    end

    if binding.showMaskRight then
        self.maskRight:Show()
        local x, y = self.iconRight:GetSize()
        self.iconRight:SetSize(x + 6, y + 6)
        self.iconRight:ClearAllPoints()
        self.iconRight:SetPoint("RIGHT", -3, 0)
    else
        self.maskRight:Hide()
    end

    if binding.onUpdate then
        self:SetScript("OnUpdate", binding.onUpdate)
    end

    if binding.onMouseDown then
        self:SetScript("OnMouseDown", binding.onMouseDown)
        self:EnableMouse(true)
    end
    if binding.onMouseUp then
        self:SetScript("OnMouseUp", binding.onMouseUp)
        self:EnableMouse(true)
    end

    if binding.onMouseEnter then
        self:SetScript("OnEnter", binding.onMouseEnter)
        self:EnableMouse(true)
    else
        if binding.link then
            self:SetScript("OnEnter", function()
                GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                GameTooltip:SetHyperlink(binding.link)
                GameTooltip:Show()
            end)
        end
    end

    if binding.onMouseLeave then
        self:SetScript("OnLeave", binding.onMouseLeave)
    else
        self:SetScript("OnLeave", function()
            GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
        end)
    end

    if binding.init then
        binding.init(self)
    end

    if binding.resetFunc then
        self.resetFunc = binding.resetFunc;
    end

    --self.anim:Play()
end
function TBDSimpleIconLabelFrameMixin:ResetDataBinding()
    self:SetScript("OnMouseDown", nil)
    self:SetScript("OnEnter", nil)
    self:SetScript("OnLeave", nil)
    self:EnableMouse(false)
    self.icon:SetTexture(nil)
    self.iconRight:SetTexture(nil)
    self.label:SetText("")
    self.labelRight:SetText("")
    self.rightButton:SetScript("OnClick", nil)
    self.rightButton:Hide()

    if self.resetFunc then
        self.resetFunc(self)
        self.resetFunc = nil
    end
end



TBDSquareSlotButtonMixin = {}
function TBDSquareSlotButtonMixin:OnLoad()
    -- if self.tooltipTitle and self.tooltipText then
    --     self:SetScript("OnEnter", function()
    --         GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    --         GameTooltip:AddLine(self.tooltipTitle)
    --         GameTooltip:AddLine(self.tooltipText, 1, 1, 1, true)
    --         GameTooltip:Show()
    --     end)
    -- elseif self.tooltipText then
    --     self:SetScript("OnEnter", function()
    --         GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    --         GameTooltip:SetText(self.tooltipText, 1, 1, 1, 1, true)
    --         GameTooltip:Show()
    --     end)
    -- end
end



TBDBaseTooltipMixin = {}
function TBDBaseTooltipMixin:OnEnter()
    if self.tooltipTitle and self.tooltipText then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(self.tooltipTitle)
        GameTooltip:AddLine(self.tooltipText, 1, 1, 1, true)
        GameTooltip:Show()
    elseif self.tooltipText then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(self.tooltipText, 1, 1, 1, 1, true)
        GameTooltip:Show()
    end
end




TBDCircleButtonMixin = {}
function TBDCircleButtonMixin:OnLoad()
    self.isSelected = false;
end
function TBDCircleButtonMixin:Init(config)
    if config.icon then
        self.icon:SetTexture(config.icon)
    end
    if config.atlas then
        self.icon:SetAtlas(config.atlas)
    end
    if config.label then
        self.label:SetText(config.label)
    end
    if config.onClick then
        self:SetScript("OnClick", function()
            config.onClick(self)
        end)
    end
end