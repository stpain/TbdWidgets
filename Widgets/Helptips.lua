local name, addon = ...;

TBDHelpTipMixin = {};
function TBDHelpTipMixin:SetText(text)
    self.text:SetText(text)
end
function TBDHelpTipMixin:OnLoad()
    self.next:SetText(NEXT)


    if self.arrowAnchor then

        self.background:Show()

        if self.arrowAnchor == "right" then
            self.BG:Hide()
            self.Arrow:ClearAllPoints()
            self.Arrow:SetPoint("RIGHT", 36, 0)
            self.Arrow.Arrow:ClearAllPoints()
            self.Arrow.Arrow:SetPoint("RIGHT", 0, -1)
            self.Arrow.Arrow:SetRotation(1.57)
            self.Arrow.Glow:ClearAllPoints()
            self.Arrow.Glow:SetPoint("RIGHT", 10, 0)
            self.Arrow.Glow:SetRotation(1.57)
        end

        if self.arrowAnchor == "left" then
            self.BG:Hide()
            self.Arrow:ClearAllPoints()
            self.Arrow:SetPoint("LEFT", -36, 0)
            self.Arrow.Arrow:ClearAllPoints()
            self.Arrow.Arrow:SetPoint("LEFT", 0, -1)
            self.Arrow.Arrow:SetRotation(-1.57)
            self.Arrow.Glow:ClearAllPoints()
            self.Arrow.Glow:SetPoint("LEFT", -10, 0)
            self.Arrow.Glow:SetRotation(-1.57)
        end

        if self.arrowAnchor == "top" then
            self.BG:Hide()
            self.Arrow:ClearAllPoints()
            self.Arrow:SetPoint("TOP", 0, 20)
            self.Arrow.Arrow:ClearAllPoints()
            self.Arrow.Arrow:SetPoint("TOP", 0, 0)
            self.Arrow.Arrow:SetRotation(3.14)
            self.Arrow.Glow:ClearAllPoints()
            self.Arrow.Glow:SetPoint("TOP", 0, 8)
            self.Arrow.Glow:SetRotation(3.14)
        end
    end
end
function TBDHelpTipMixin:OnShow()

end