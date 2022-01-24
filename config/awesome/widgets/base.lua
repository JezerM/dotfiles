local wibox = require("wibox")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

local Base = {}

--- Create a new Extended Widget
--- @param o table The parameters
function Base:new(o)
    o = o or {}

    if o.margins == nil then
        o.margins = { left = dpi(6), right = dpi(6) }
    end
    if o.outer_margins == nil then
        o.outer_margins = {}
    end
    if o.icon == nil then
        o.icon = {
            markup = "",
            bg = nil,
            shape = gears.shape.rectangle,
            margins = {},
        }
    end

    local widget = wibox.widget {
        {
            {
                {
                    id = "icon_background_role",
                    widget = wibox.container.background,
                    shape = o.icon.shape,
                    bg = o.icon.bg or o.active_bg,
                    {
                        widget = wibox.container.margin,
                        margins = o.icon.margins,
                        {
                            id = "icon",
                            markup = o.icon.markup,
                            widget = wibox.widget.textbox,
                        }
                    },
                },
                {
                    widget = wibox.container.margin,
                    margins = o.margins,
                    {
                        o.inner_widget or {
                            id = "text",
                            markup = o.markup,
                            widget = wibox.widget.textbox,
                        },
                        layout = wibox.layout.fixed.horizontal,
                    }
                },
                layout = wibox.layout.fixed.horizontal,
            },
            shape = o.shape or gears.shape.rectangle,
            id = "background_role",
            bg = o.bg_normal,
            bg_normal = o.bg_normal,
            bg_active = o.bg_active or o.bg_normal,

            widget = wibox.container.background,
            buttons = o.buttons,
        },
        margins = o.outer_margins,
        widget = wibox.container.margin,
    }
    widget:connect_signal("mouse::enter", function()
        local background = widget:get_children_by_id("background_role")[1]
        background.bg = background.bg_active
    end)
    widget:connect_signal("mouse::leave", function()
        local background = widget:get_children_by_id("background_role")[1]
        background.bg = background.bg_normal
    end)

    return widget
end

return Base

-- vim: shiftwidth=4: tabstop=4
