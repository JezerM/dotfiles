local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local rubato = require("lib.rubato")
local naughty = require("naughty")
local inspect = require("inspect")

local brightness_slider = require("widgets.sidebar.brightness_slider")
local audio_slider = require("widgets.sidebar.audio_slider")
local notification_controller = require("widgets.sidebar.notifications"):new { }
local utils = require("utils")

local Sidebar = {
    mt = {}
}

local function create_power_button(o)
    o = o or {}

    local widget = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.colors.bg2,
        shape = gears.shape.rounded_rect,
        {
            widget = wibox.container.margin,
            margins = dpi(10),
            {
                widget = wibox.widget.textbox,
                markup = o.markup,
                font = o.font or "MesloLGS NF Bold 12",
                buttons = gears.table.join(
                    awful.button({ }, 1, o.command)
                    ),
            }
        }
    }
    local tooltip = awful.tooltip {
        objects = { widget },
        mode = "mouse",
        align = "top_left",
        delay_show = 0.5,
        input_passthrough = true,
    }
    widget:connect_signal("mouse::enter", function(self)
        self.bg = beautiful.colors.bg3
        tooltip.text = o.tooltip or o.command
    end)
    widget:connect_signal("mouse::leave", function(self)
        self.bg = beautiful.colors.bg2
    end)

    return widget
end

local function create_sidebar_notification(notification_list, i)
    local notifications = notification_controller.notification_list
    local n = notifications[i]

    local w = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.colors.bg2,
        shape = gears.shape.rounded_rect,
        forced_width = dpi(200),
        {
            widget = wibox.container.margin,
            margins = dpi(10),
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(5),
                fill_space = true,
                naughty.widget.icon { notification = n },
                {
                    layout = wibox.layout.fixed.vertical,
                    spacing = dpi(5),
                    naughty.widget.title { notification = n },
                    naughty.widget.message { notification = n },
                    {
                        widget = naughty.list.actions,
                        notification = n,
                    }
                }
            }
        }
    }
    w:buttons(gears.table.join(
            awful.button({ }, 3, function()
                n:destroy(naughty.notification_closed_reason.dismissed_by_user)
                table.remove(notifications, i)
                notification_controller:emit_signal("update")
            end)
        ))
    notification_list:add(w)
end

function Sidebar:show(value)
    if value == nil then
        value = not self.visible
    end

    if value == true then
        self.fly_in.target = self.screen.geometry.width - self.popup.width - dpi(20)
    else
        self.fly_in.target = self.screen.geometry.width
    end

    self.visible = value
end

function Sidebar:new(o)
    o = o or {}
    o.screen = o.screen or screen.primary

    local grid = wibox.widget {
        layout = wibox.layout.grid,
        spacing = dpi(10),
        orientation = "vertical",
    }

    -- Text clock
    grid:add_widget_at(
        wibox.widget {
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(5),
            {
                widget = wibox.widget.textclock,
                font = "MesloLGS NF Bold 36",
                format = "%H:%M",
                align = "center",
            },
            {
                widget = wibox.widget.textclock,
                font = "MesloLGS NF Bold 12",
                format = "%d-%m-%Y",
                align = "center",
            },
        },
        1, 1, 2, 2
        )
    -- Brightness
    grid:add_widget_at(
        wibox.widget {
            widget = wibox.container.background,
            bg = beautiful.colors.bg0_s,
            shape = gears.shape.rounded_rect,
            {
                widget = wibox.container.margin,
                margins = dpi(10),
                {
                    layout = wibox.layout.fixed.horizontal,
                    {
                        widget = wibox.widget.textbox,
                        markup = " 盛 ",
                        font = "MesloLGS NF bold 14"
                    },
                    brightness_slider:new {},
                }
            }
        },
        3, 1, 1, 1
        )
    -- Audio
    grid:add_widget_at(
        wibox.widget {
            widget = wibox.container.background,
            bg = beautiful.colors.bg0_s,
            shape = gears.shape.rounded_rect,
            {
                widget = wibox.container.margin,
                margins = dpi(10),
                {
                    layout = wibox.layout.fixed.horizontal,
                    {
                        widget = wibox.widget.textbox,
                        markup = " 墳 ",
                        font = "MesloLGS NF bold 14"
                    },
                    audio_slider:new {},
                }
            }
        },
        3, 2, 1, 1
        )
    -- Power options
    grid:add_widget_at(
        wibox.widget {
            widget = wibox.container.background,
            bg = beautiful.colors.bg0_s,
            shape = gears.shape.rounded_rect,
            {
                widget = wibox.container.margin,
                margins = dpi(10),
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = dpi(10),
                    create_power_button({
                            command = function()
                                utils.power.poweroff()
                            end,
                            markup = "  ",
                            tooltip = "Power-off",
                        }),
                    create_power_button({
                            command = function()
                                utils.power.restart()
                            end,
                            markup = " ﰇ ",
                            tooltip = "Restart",
                        }),
                    create_power_button({
                            command = function()
                                utils.power.suspend()
                            end,
                            markup = "  ",
                            tooltip = "Suspend",
                        }),
                    create_power_button({
                            command = function()
                                utils.power.hibernate()
                            end,
                            markup = " ⏼ ",
                            tooltip = "Hibernate",
                        }),
                    create_power_button({
                            command = function()
                                utils.power.logout()
                            end,
                            markup = "  ",
                            tooltip = "Logout",
                        }),
                }
            }
        },
        4, 1, 1, 2
        )

    local notification_list = wibox.widget {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(10),
    }
    notification_controller:connect_signal("update", function()
        local notifications = notification_controller.notification_list
        notification_list:reset()

        local range_min = 1
        local range_max = 4

        local q = 1
        for i = #notifications, 1, -1 do
            if q <= 4 then
                create_sidebar_notification(notification_list, i)
                q = q + 1
            end
        end
    end)

    -- Notifications
    grid:add_widget_at(
        wibox.widget {
            widget = wibox.container.background,
            bg = beautiful.colors.bg0_s,
            shape = gears.shape.rounded_rect,
            {
                widget = wibox.container.margin,
                margins = dpi(15),
                notification_list,
            }
        },
        5, 1, 8, 2
        )

    local popup = awful.popup {
        widget = wibox.widget {
            widget = wibox.container.background,
            {
                widget = wibox.container.margin,
                left = dpi(20), right = dpi(20),
                top = dpi(30), bottom = dpi(30),
                grid
            }
        },
        screen = o.screen,
        ontop = true,
        type = "dock",
        minimum_width = o.screen.geometry.width * 0.1,
        maximum_width = o.screen.geometry.width * 0.5,
    }

    local placement = awful.placement.maximize_vertically
    placement(popup, {
            attach = true,
            update_workarea = false,
            margins = dpi(20),
            honor_workarea = true,
        })

    local fly_in = rubato.timed {
        duration = 0.25,
        intro = 0.125,
        rate = 60,
        pos = o.screen.geometry.width,
        easing = rubato.linear,
    }

    fly_in:subscribe(function(pos)
        popup:geometry({ x = pos })
        popup:draw()
    end)

    local gobj = gears.object {}
    gears.table.crush(gobj, Sidebar, true)
    gobj.popup = popup
    gobj.fly_in = fly_in
    gobj.visible = false
    gobj.screen = o.screen

    self.__index = self
    setmetatable(gobj, self)

    return gobj
end

function Sidebar.mt:__call(...)
    return Sidebar:new(...)
end

return setmetatable(Sidebar, Sidebar.mt)

-- vim: shiftwidth=4: tabstop=4
