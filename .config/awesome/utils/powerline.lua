local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")

local flipped_arrow = function(cr, width, height)
    cr:translate(width,height)
    cr:rotate(math.pi)
    gears.shape.rectangular_tag(cr, width, height)
end

local flipped_powerline = function(cr, width, height)
    cr:translate(width,height)
    cr:rotate(math.pi)
    gears.shape.powerline(cr, width, height)
end

Powerline = {
    markup = "",
    normal_bg = "",
    active_bg = "",
    font = "",
    shape = gears.shape.powerline,
    widget = wibox.widget,
    inner_widget = wibox.widget.textbox,
    margin = {
        left = 6,
        right = 6,
    }
}

function Powerline:new(o)
    o = o or {}

    if o.margin == nil then
        o.margin = {left = 6, right = 6}
    end

    o.widget = wibox.widget {
        {
            {
                --{
                    --markup = o.markup or "",
                    --id = "text",
                    --font = o.font,
                    --widget = wibox.widget.textbox,
                --},
                o.inner_widget or {
                    id = "text",
                    markup = o.markup,
                    widget = wibox.widget.textbox
                },
                left = o.margin.left or 6,
                right = o.margin.right or 6,
                widget = wibox.container.margin,
            },
            spacing_widget = {
                shape = gears.shape.powerline,
                widget = wibox.widget.separator,
            },
            spacing = -8,
            layout  = wibox.layout.fixed.horizontal,
        },
        shape = o.shape or gears.shape.powerline,
        id = "background_role",
        bg = o.normal_bg,
        normal_bg = o.normal_bg,
        active_bg = o.active_bg,
        widget = wibox.container.background,
        buttons = o.buttons,
    }
    o.widget:connect_signal("mouse::enter", function(c)
        c.bg = c.active_bg
    end)
    o.widget:connect_signal("mouse::leave", function(c)
        c.bg = c.normal_bg
    end)

    self.__index = self
    setmetatable(o, self)
    return o
end

Powerline.flipped_powerline = flipped_powerline
Powerline.flipped_arrow = flipped_arrow

return Powerline
