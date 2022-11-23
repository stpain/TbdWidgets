
TbdWidgetsDropDownTemplateMixin = {}

function TbdWidgetsDropDownTemplateMixin:OnLoad()
    self.isOpen = false;
    self:SetScript("OnClick", function()
        self.isOpen = not self.isOpen
        if self.isOpen then
            self.flyout:Show()
        else
            self.flyout:Hide()
        end
    end)
end

function TbdWidgetsDropDownTemplateMixin:SetWidth(width)
    --self.flyout:SetWidth(width)
end

function TbdWidgetsDropDownTemplateMixin:SetText(text)
    self.label.text:SetText(text)
end

function TbdWidgetsDropDownTemplateMixin:ClearMenu()
    self.flyout.listview.DataProvider:Flush()
end

function TbdWidgetsDropDownTemplateMixin:SetMenu(t)

    if type(t) ~= "table" then
        return;
    end

    --self.flyout.listview.menu = t

    local menulength = #t;
    if menulength > 8 then
        self.flyout:SetHeight(230)
    else
        self.flyout:SetHeight((menulength * 24) + 36)
    end

    self.maxWidth = 0.0;

    self.flyout.listview.DataProvider:Flush()
    self.flyout.listview.DataProvider:InsertTable(t)
end


TbdWidgetsDropDownListviewItemTemplateMixin = {}

function TbdWidgetsDropDownListviewItemTemplateMixin:OnLoad()
    self.dropdown = self:GetParent():GetParent():GetParent():GetParent():GetParent()
end

function TbdWidgetsDropDownListviewItemTemplateMixin:SetDataBinding(binding, height)
    self:SetHeight(height)
    self.text:SetText(binding.text)

    self.icon:SetSize(height-2, height-2)

    if type(binding.icon) == "string" then
        self.icon:SetAtlas(binding.icon)
    elseif type(binding.icon) == "number" then
        self.icon:SetTexture(binding.icon)
    else
        self.icon:SetSize(1,1)
    end

    local w = self.text:GetUnboundedStringWidth() + 44
    if w > self.dropdown.maxWidth then
        self.dropdown.maxWidth = w;
        self.dropdown.flyout:SetWidth(self.dropdown.maxWidth + 44)
        self.dropdown.flyout.listview:ClearAllPoints()
        self.dropdown.flyout.listview:SetPoint("TOP", 0, -14)
        self.dropdown.flyout.listview:SetPoint("BOTTOM", 0, 14)
        self.dropdown.flyout.listview:SetWidth(self.dropdown.maxWidth)
    end

    self:SetScript("OnMouseDown", function()
        self.dropdown.label.text:SetText(binding.text)
        self.dropdown.isOpen = false;
        self.dropdown.flyout:Hide()

        if binding.func then
            binding.func()
        end
    end)

end

function TbdWidgetsDropDownListviewItemTemplateMixin:ResetDataBinding()
    self.text:SetText(nil)
    self.icon:SetTexture(nil)
    self.menuTable = nil;
    self:SetScript("OnMouseDown", nil)
end
