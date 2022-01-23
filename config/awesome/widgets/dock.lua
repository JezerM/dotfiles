-- Dock inspired/copied from JavaJanuary (Blyaticon) on AwesomeWM's discord

local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local rubato = require("lib.rubato")
local naughty = require("naughty")

local Dock = {
    mt = {}
}

function Dock:new(o)
    o.screen = o.screen or screen.primary

    local fly_in = rubato.timed {
        duration = 0.25,
        intro = 0.125,
        rate = 60,
        pos = o.screen.geometry.height,
        easing = rubato.linear,
    }

    local tasklist = awful.widget.tasklist {
        screen = o.screen,
        filter = awful.widget.tasklist.filter.allscreen,
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
            },
            create_callback = function(self, task, index, object)
                self:connect_signal("mouse::enter", function()
                    self.bg = beautiful.colors.bg0_h
                end)
                self:connect_signal("mouse::leave", function()
                    self.bg = beautiful.colors.bg
                end)
            end
        }
    }

    local dock = awful.popup {
        widget = wibox.container.margin(wibox.container.background(tasklist, beautiful.colors.bg)),
        bg = "#00000000",
        screen = o.screen,
        ontop = true,
        type = "dock",
    }
    awful.placement.bottom(dock, {
            attach = true,
            update_workarea = false,
            margins = dpi(5),
            honor_workarea = false,
        }
    )
    local function adjust()
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

    dock:connect_signal("mouse::enter", function()
        fly_in.target = o.screen.geometry.height - (dock.height + beautiful.useless_gap)
    end)
    dock:connect_signal("mouse::leave", function()
        fly_in.target = o.screen.geometry.height - beautiful.useless_gap
    end)

    fly_in.target = o.screen.geometry.height - beautiful.useless_gap

    return dock
end

function Dock.mt:__call(...)
    return Dock:new(...)
end

return setmetatable(Dock, Dock.mt)

-- vim: shiftwidth=4: tabstop=4
