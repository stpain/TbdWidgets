

local name, addon = ...;

local nineSlice = 
{
    ["TopRightCorner"] = { atlas = "Tooltip-NineSlice-CornerTopRight", x = 4, y = 4 },
    ["TopLeftCorner"] = { atlas = "Tooltip-NineSlice-CornerTopLeft", x = -4, y = 4 },
    ["BottomLeftCorner"] = { atlas = "Tooltip-NineSlice-CornerBottomLeft", x = -4, y = -4 },
    ["BottomRightCorner"] = { atlas = "Tooltip-NineSlice-CornerBottomRight", x = 4, y = -4 },
    ["TopEdge"] = { atlas = "_Tooltip-NineSlice-EdgeTop" },
    ["BottomEdge"] = { atlas = "_Tooltip-NineSlice-EdgeBottom" },
    ["LeftEdge"] = { atlas = "!Tooltip-NineSlice-EdgeLeft" },
    ["RightEdge"] = { atlas = "!Tooltip-NineSlice-EdgeRight" },
    ["Center"] = { layer = "BACKGROUND", atlas = "Tooltip-Glues-NineSlice-Center", x = -4, y = 4, x1 = 4, y1 = -4 },
}


TBDDatePickerGridviewItemMixin = {}
function TBDDatePickerGridviewItemMixin:OnLoad()
    
end
function TBDDatePickerGridviewItemMixin:SetDataBinding(binding)
    self.text:SetText(binding.text)
    self:SetScript("OnMouseDown", binding.onMouseDown)
end
function TBDDatePickerGridviewItemMixin:ResetDataBinding()
    self:SetScript("OnMouseDown", nil)
end




TBDDatePickerMixin = {}
function TBDDatePickerMixin:OnLoad()

    NineSliceUtil.ApplyLayout(self, nineSlice)
    
    local now = date("*t")
    self.year = now.year;
    self.month = now.month;
    self.day = now.day;
    self.hour = now.day;
    self.min = now.min;

    self.gridview:InitFramePool("FRAME", "TBDDatePickerGridviewItemTemplate")
    self.gridview:SetFixedColumnCount(4)
    self.gridview.ScrollBar:Hide()

    self.hourInput:SetText(self.hour)
    self.minuteInput:SetText(self.min)

    self.hourInput:SetFrameLevel(self:GetFrameLevel() + 10)
    self.minuteInput:SetFrameLevel(self:GetFrameLevel() + 10)

    self.hourInput:SetScript("OnMouseWheel", function(_, delta)
        local currentHour = tonumber(self.hourInput:GetText())
        if currentHour then
            currentHour = currentHour + delta
            if currentHour < 0 then
                currentHour = 0
            end
            if currentHour > 23 then
                currentHour = 23
            end
            self.hourInput:SetText(currentHour)
        end
    end)

    self.minuteInput:SetScript("OnMouseWheel", function(_, delta)
        local currentMinute = tonumber(self.minuteInput:GetText())
        if currentMinute then
            currentMinute = currentMinute + delta
            if currentMinute < 0 then
                currentMinute = 0
            end
            if currentMinute > 59 then
                currentMinute = 59
            end
            self.minuteInput:SetText(currentMinute)
        end
    end)

    self.hourInput:SetScript("OnTextChanged", function()
        if tonumber(self.hourInput:GetText()) then
            self.hour = tonumber(self.hourInput:GetText())
            self:OnDateChange()
        end
    end)

    self.minuteInput:SetScript("OnTextChanged", function()
        if tonumber(self.minuteInput:GetText()) then
            self.min = tonumber(self.minuteInput:GetText())
            self:OnDateChange()
        end
    end)

    self:LoadGridview("day")
    self:OnDateChange()
end

function TBDDatePickerMixin:GetDaysInMonth(month, year)
    local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
    local d = days_in_month[month]
    -- check for leap year
    if (month == 2) then
        if year % 4 == 0 then
            if year % 100 == 0 then
                if year % 400 == 0 then
                    d = 29
                end
            else
                d = 29
            end
        end
    end
    return d
end

function TBDDatePickerMixin:GetMonthStart(month, year)
    local today = date('*t')
    today.day = 0
    today.month = month
    today.year = year
    local monthStart = date('*t', time(today))
    return monthStart.wday
end

function TBDDatePickerMixin:SetDate(year, month, day)
    
end

function TBDDatePickerMixin:OnHide()
    self.callback = nil;
end

function TBDDatePickerMixin:GetDate()
    return self.datetime;
end

function TBDDatePickerMixin:SetCallback(callback)
    self.callback = callback;
end

function TBDDatePickerMixin:OnDateChange(fireCallback)
    local today = date('*t')
    today.day = self.day
    today.month = self.month
    today.year = self.year
    today.hour = self.hour
    today.min = self.min
    self.datetime = time(today)

    if fireCallback and self.callback then
        self.callback(self.datetime)
    end

    self.text:SetText(date("%Y-%m-%d   %H:%M", self.datetime))
end

function TBDDatePickerMixin:LoadGridview(tier)

    self.gridview:Flush()
    
    if tier == "day" then

        self.selector:SetText(self.month)
        self.selector:SetScript("OnClick", function()
            self:LoadGridview("month")
        end)

        self.gridview:SetFixedColumnCount(7)
        
        for i = 1, self:GetDaysInMonth(self.month, self.year) do
            self.gridview:Insert({
                text = i,
                onMouseDown = function(f)
                    self.day = i
                    self:OnDateChange(true)
                    self:Hide()
                end,
            })
        end

        return;
    end

    if tier == "month" then
        
        self.selector:SetText(self.year)
        self.selector:SetScript("OnClick", function()
            self:LoadGridview("year")
        end)

        self.gridview:SetFixedColumnCount(4)
        
        for i = 1, 12 do
            self.gridview:Insert({
                text = i,
                onMouseDown = function(f)
                    self.month = i
                    self:OnDateChange()
                    self:LoadGridview("day")
                end,
            })
        end

        return;
    end

    if tier == "year" then
        
        self.selector:SetText(self.year)
        self.selector:SetScript("OnClick", function()
            self:LoadGridview("year")
        end)

        self.gridview:SetFixedColumnCount(4)
        
        for i = self.year - 10, self.year + 10 do
            self.gridview:Insert({
                text = i,
                onMouseDown = function(f)
                    self.year = i
                    self:OnDateChange()
                    self:LoadGridview("month")
                end,
            })
        end

        return;
    end
end