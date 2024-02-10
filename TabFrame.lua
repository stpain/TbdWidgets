local name, addon = ...;

TBDTabFrameMixin = {}

function TBDTabFrameMixin:OnLoad()

end

function TBDTabFrameMixin:OnTabSelected(tab, index)

    for k, button in ipairs(self.tabsGroup.buttons) do
        if button.panel then
            button.panel:Hide()
        end
    end

    if tab.panel then
        tab.panel:Show()
    end
end

function TBDTabFrameMixin:CreateTabButtons(tabs)

    if type(tabs) == "table" then

        local t = {}

        for k, v in ipairs(tabs) do
            
            local button = CreateFrame("BUTTON", nil, self, "MinimalTabTemplate")
            button:SetWidth(v.width)

            if k == 1 then
                button:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 14, 0) 
            else
                button:SetPoint("LEFT", t[k-1], "RIGHT", 1, 0)
            end

            if v.label then
                button.Text:SetText(v.label)
            end
            if v.panel then
                button.panel = v.panel;
            end

            t[k] = button
        end
        
        self.tabsGroup = CreateRadioButtonGroup();

        self.tabsGroup:AddButtons(t);
        self.tabsGroup:SelectAtIndex(1);
        self.tabsGroup:RegisterCallback(ButtonGroupBaseMixin.Event.Selected, self.OnTabSelected, self);

    end
end