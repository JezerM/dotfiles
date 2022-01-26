local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local Notification_controller = {
    mt = {}
}

function Notification_controller:add(n)
    local i = #self.notification_list

    self.notification_list[i + 1] = n

    local popup = naughty.layout.box {
        notification = n,
        ontop = true,
        position = "top_right",
        widget_template = {
            {
                {
                    {
                        {
                            naughty.widget.icon,
                            {
                                naughty.widget.title,
                                naughty.widget.message,
                                spacing = dpi(4),
                                layout = wibox.layout.fixed.vertical,
                            },
                            fill_space = true,
                            spacing = dpi(4),
                            layout = wibox.layout.fixed.horizontal,
                        },
                        naughty.list.actions,
                        spacing = dpi(4),
                        layout = wibox.layout.fixed.vertical,
                    },
                    margins = beautiful.notification_margin or dpi(5),
                    widget = wibox.container.margin,
                },
                id = "background_role",
                widget = naughty.container.background,
            },
            strategy = "max",
            width = beautiful.notification_max_width or dpi(500),
            widget = wibox.container.constraint,
        }
    }

    self:emit_signal("update")
end

function Notification_controller:clear()
    self.notification_list = {}
    self:emit_signal("update")
end

function Notification_controller:new()
    if Notification_controller._instance then
        return Notification_controller._instance
    end

    local gobj = gears.object {}
    gears.table.crush(gobj, Notification_controller, true)

    gobj.notification_list = {}

    self.__index = self
    setmetatable(gobj, self)

    naughty.connect_signal("request::display", function(n)
        gobj:add(n)
    end)

    Notification_controller._instance = gobj
    return gobj
end

function Notification_controller.mt:__call()
    return Notification_controller:new()
end

return setmetatable(Notification_controller, Notification_controller.mt)
