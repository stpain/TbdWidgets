

TBDListviewMixin = {}

function TBDListviewMixin:OnLoad()

    self.DataProvider = CreateDataProvider();
    self.scrollView = CreateScrollBoxListLinearView();

    ---height is defined in the xml keyValues
    local height = self.elementHeight;
    self.scrollView:SetElementExtent(height);

    self.scrollView:SetElementInitializer(self.itemTemplate, GenerateClosure(self.OnElementInitialize, self));
    self.scrollView:SetElementResetter(GenerateClosure(self.OnElementReset, self));

    self.scrollView:SetDataProvider(self.DataProvider);

    self.selectionBehavior = ScrollUtil.AddSelectionBehavior(self.scrollView);

    self.scrollView:SetPadding(1, 1, 1, 1, 1);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.scrollBox, self.scrollBar, self.scrollView);
    --ScrollUtil.InitScrollBoxWithScrollBar(scrollBox, scrollBar, scrollBoxView)

    local anchorsWithBar = {
        CreateAnchor("TOPLEFT", self, "TOPLEFT", 1, -1),
        CreateAnchor("BOTTOMRIGHT", self.scrollBar, "BOTTOMLEFT", -3, 1),
    };
    local anchorsWithoutBar = {
        CreateAnchor("TOPLEFT", self, "TOPLEFT", 1, -1),
        CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1),
    };
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.scrollBox, self.scrollBar, anchorsWithBar, anchorsWithoutBar);

end

function TBDListviewMixin:OnElementInitialize(element, elementData, isNew)
    if isNew then
        element:OnLoad();
    end
    local height = self.elementHeight;
    element:SetDataBinding(elementData, height);
    element:Show()

    if self.enableSelection then
        if element.selected then
            element:HookScript("OnMouseDown", function()
                self.scrollView:ForEachFrame(function(f, d)
                    f.selected:Hide()
                end)
                element.selected:Show()
            end)
        end
    end
end

function TBDListviewMixin:OnElementReset(element)
    if element.ResetDataBinding then
        element:ResetDataBinding()
    end
end







TBDNoTemplateListviewMixin = {}


function TBDNoTemplateListviewMixin:OnLoad()

    self.DataProvider = CreateDataProvider();
    self.scrollView = CreateScrollBoxListLinearView();

    self.scrollView:SetElementFactory(function(factory, elementData)
		factory(elementData.template, elementData.initializer);
	end);
    self.scrollView:SetElementExtentCalculator(function(_, elementData)
        return elementData.height or 20
    end)

    self.scrollView:SetElementResetter(GenerateClosure(self.OnElementReset, self));

    self.scrollView:SetDataProvider(self.DataProvider);

    self.selectionBehavior = ScrollUtil.AddSelectionBehavior(self.scrollView);

    self.scrollView:SetPadding(1, 1, 1, 1, 1);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.scrollBox, self.scrollBar, self.scrollView);
    --ScrollUtil.InitScrollBoxWithScrollBar(scrollBox, scrollBar, scrollBoxView)

    local anchorsWithBar = {
        CreateAnchor("TOPLEFT", self, "TOPLEFT", 1, -1),
        CreateAnchor("BOTTOMRIGHT", self.scrollBar, "BOTTOMLEFT", -5, 1),
    };
    local anchorsWithoutBar = {
        CreateAnchor("TOPLEFT", self, "TOPLEFT", 1, -1),
        CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1),
    };
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.scrollBox, self.scrollBar, anchorsWithBar, anchorsWithoutBar);

end

function TBDNoTemplateListviewMixin:OnElementReset(element)
    if element.ResetDataBinding then
        element:ResetDataBinding()
    end
end










TBDTreeviewMixin = {}
function TBDTreeviewMixin:OnLoad()

    self.DataProvider = CreateTreeDataProvider();
    local indent = 10;
	local padLeft = 0;
	local pad = 5;
	local spacing = 1;
    self.scrollView = CreateScrollBoxListTreeListView(indent, pad, pad, padLeft, pad, spacing)

    ---height is defined in the xml keyValues
    local height = self.elementHeight;
    self.scrollView:SetElementExtent(height);

    self.scrollView:SetElementInitializer(self.itemTemplate, GenerateClosure(self.OnElementInitialize, self));
    self.scrollView:SetElementResetter(GenerateClosure(self.OnElementReset, self));

    self.scrollView:SetDataProvider(self.DataProvider);

    self.scrollView:SetPadding(1, 1, 1, 1, 1);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.scrollBox, self.scrollBar, self.scrollView);

    local anchorsWithBar = {
        CreateAnchor("TOPLEFT", self, "TOPLEFT", 1, -1),
        CreateAnchor("BOTTOMRIGHT", self.scrollBar, "BOTTOMLEFT", -5, 1),
    };
    local anchorsWithoutBar = {
        CreateAnchor("TOPLEFT", self, "TOPLEFT", 1, -1),
        CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1),
    };
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.scrollBox, self.scrollBar, anchorsWithBar, anchorsWithoutBar);
end

function TBDTreeviewMixin:OnElementInitialize(button, node)

    -- local data = node:GetData()
    -- local text = data.ButtonText
    -- button:SetText(text)
    button:SetScript("OnMouseDown", function()
        node:ToggleCollapsed()

        -- if node:GetData().isParent then
        --     if node:IsCollapsed() then
        --         button.icon:SetTexCoord(0,1,0,1)
        --     else
        --         --button.icon:SetTexCoord(1,0, 0,0, 1,1, 0,1)
        --         button.icon:SetTexCoord(0,1, 1,1, 0,0, 1,0)
        --     end
        -- end
    end)


    --[[
        changed to pass the node instead, any SetDataBinding functions will need to use
        local binding = node:GetData()
        to access the binding table data

        update, moving node to end and keeping the original args
    ]]
    local height = self.elementHeight;
    if button.SetDataBinding then
        button:SetDataBinding(node:GetData(), height, node);
        button:Show()
    end
end

function TBDTreeviewMixin:OnElementReset(button)
    if button.ResetDataBinding then
        button:ResetDataBinding()
    end
end














TBDNoTemplateTreeviewMixin = {}


function TBDNoTemplateTreeviewMixin:OnLoad()

    self.DataProvider = CreateTreeDataProvider();
    local indent = 10;
	local padLeft = 0;
	local pad = 5;
	local spacing = 1;
    self.scrollView = CreateScrollBoxListTreeListView(indent, pad, pad, padLeft, pad, spacing)

    self.scrollView:SetElementFactory(function(factory, elementData)
        local data = elementData:GetData()
		factory(data.template, data.initializer);
	end);

    self.scrollView:SetElementExtentCalculator(function(_, elementData)
        return elementData:GetData().height or 20
    end)

    self.scrollView:SetElementResetter(GenerateClosure(self.OnElementReset, self));

    self.scrollView:SetDataProvider(self.DataProvider);

    self.selectionBehavior = ScrollUtil.AddSelectionBehavior(self.scrollView);

    self.scrollView:SetPadding(1, 1, 1, 1, 1);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.scrollBox, self.scrollBar, self.scrollView);
    --ScrollUtil.InitScrollBoxWithScrollBar(scrollBox, scrollBar, scrollBoxView)

    local anchorsWithBar = {
        CreateAnchor("TOPLEFT", self, "TOPLEFT", 1, -1),
        CreateAnchor("BOTTOMRIGHT", self.scrollBar, "BOTTOMLEFT", -5, 1),
    };
    local anchorsWithoutBar = {
        CreateAnchor("TOPLEFT", self, "TOPLEFT", 1, -1),
        CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1),
    };
    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.scrollBox, self.scrollBar, anchorsWithBar, anchorsWithoutBar);

end

function TBDNoTemplateTreeviewMixin:OnElementReset(element)
    if element.ResetDataBinding then
        element:ResetDataBinding()
    end
end