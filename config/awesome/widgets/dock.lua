-- Dock inspired/copied from JavaJanuary (Blyaticon) on AwesomeWM's discord

local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local rubato = require("lib.rubato")
local naughty = require("naughty")

local fly_in = rubato.timed {
    duration = 0.25,
    intro = 0.125,
    rate = 60,
    pos = screen.primary.geometry.height,
    easing = rubato.linear,
}

local tasklist = awful.widget.tasklist {
    screen = screen.primary,
    filter = awful.widget.tasklist.filter.alltags,
    buttons = awful.util.tasklist_buttons,
    layout = {
        layout = wibox.layout.fixed.horizontal,
    },
    widget_template = {
        widget = wibox.container.background,
        shape = gears.shape.rectangle,
        bg = beautiful.colors.bg,
        {
            widget = wibox.container.margin,
            margins = dpi(5),
            {
                widget = wibox.container.background,
                id = "background_role",
                {
                    widget = wibox.container.place,
                    valign = "center",
                    halign = "center",
                    forced_width = beautiful.dock_size,
                    forced_height = beautiful.dock_size,
                    {
                        widget = wibox.container.margin,
                        margins = dpi(5),
                        {
                            widget = wibox.widget.imagebox,
                            resize = true,
                            id = "icon_role",
                        },
                    }
                }
            }
        }
    }
}

local dock = awful.popup {
    widget = wibox.container.margin(wibox.container.background(tasklist, beautiful.colors.bg)),
    bg = "#00000000",
    screen = screen.primary,
    ontop = true,
    type = "dock",
}

awful.placement.bottom(dock, {
        attach = true,
        update_workarea = false,
        margins = dpi(5),
        honor_workarea = true,
    }
)

local function adjust()
    pos_x = (screen.primary.geometry.width - dock.width - dock.border_width) / 2
    gears.timer {
        timeout = 3,
        autostart = true,
        single_shot = true,
        callback = function()
            dock:geometry({ y = fly_in.target })
        end
    }
end

tasklist:connect_signal("widget::layout_changed", function() adjust() end)
client.connect_signal("focus", function() adjust() end)

fly_in:subscribe(function(pos)
    dock:geometry({ y = pos })
    dock:draw()
end)

fly_in.target = screen.primary.geometry.height - beautiful.useless_gap

dock:connect_signal("mouse::enter", function()
    fly_in.target = screen.primary.geometry.height - (dock.height + beautiful.useless_gap)
end)
dock:connect_signal("mouse::leave", function()
    fly_in.target = screen.primary.geometry.height - beautiful.useless_gap
end)

-- vim: shiftwidth=4: tabstop=4
