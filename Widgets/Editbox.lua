

local name, addon = ...;

TBDInputBoxMixin = {}
function TBDInputBoxMixin:OnLoad()
    if self.labelText then
        self.label:SetText(self.labelText)
    end
    if self.clearTextOnHide then
        self:SetText("")
    end
end
function TBDInputBoxMixin:Init(scripts)
    if scripts.onAccept then
        self.ok:SetScript("OnClick", function()
            scripts.onAccept(self)
        end)
    end
    if scripts.onCancel then
        self.cancel:SetScript("OnClick", function()
            scripts.onCancel(self)
        end)
    end
end
function TBDInputBoxMixin:OnTextChanged()
    if #self:GetText() > 0 then
        if not self.disableButtons then
            self.ok:Show()
            self.cancel:Show()
        end
        self.label:Hide()
    else
        self.ok:Hide()
        self.cancel:Hide()
        self.label:Show()
    end
end