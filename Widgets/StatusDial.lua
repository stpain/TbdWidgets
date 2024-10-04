

local name, addon = ...;

local SWIPE = {
	lowTexCoords = {
		x = 1 / 256, -- left 0.00390625
		y = 1 / 128, -- top 0.0078125
	},
	highTexCoords =
	{
		x = 97 / 256, -- right 0.37890625
		y = 97 / 128, -- bottom 0.7578125
	}
}

TbdWidgetsStatusMixin = {}
function TbdWidgetsStatusMixin:OnLoad()
    self.cooldown:SetRotation(math.rad(180))
    self.cooldown:SetTexCoordRange(SWIPE.lowTexCoords, SWIPE.highTexCoords)
end
function TbdWidgetsStatusMixin:SetValue(cur, max, animate)
    if not cur or not max or max == 0 then 
        return 
    end
    local i = 0
    local percent = (cur/max)

    if animate then

        local step = percent / 25
        local ticker = C_Timer.NewTicker(0.01, function()
            CooldownFrame_SetDisplayAsPercentage(self.cooldown, i)
            i = i + (step)
        end, 25)

    else
        CooldownFrame_SetDisplayAsPercentage(self.cooldown, percent)
    end
end

function TbdWidgetsStatusMixin:SetIcon(icon)
    if type(icon) == "string" then
        self.icon:SetAtlas(icon)
    elseif type(icon) == "number" then
        self.icon:SetTexture(icon)
    else
        self.icon:SetTexture(nil)
    end
end

function TbdWidgetsStatusMixin:SetColour(r, g, b)
    self.cooldown:SetSwipeColor(r, g, b, 1)
end