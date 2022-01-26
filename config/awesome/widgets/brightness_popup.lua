local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = require("beautiful.xresources").apply_dpi

local brightness_controller = require("utils.brightness"):new {}

local Brightness_popup = {
    mt = {}
}

function Brightness_popup:show()
    if not self.can_show then
        return
    end
    self.popup.visible = true

    self.timer:again()
end

function Brightness_popup:new()
    if Brightness_popup._instance then
        return Brightness_popup._instance
    end

    local progress_bar = wibox.widget {
        widget = wibox.widget.progressbar,
        max_value = 100,
        min_value = 0,
        value = brightness_controller:get() or 0,
        forced_width = dpi(100),
        forced_height = dpi(10),
        shape = gears.shape.rounded_rect,

        color = beautiful.colors.light_purple,
        background_color = beautiful.colors.bg2,
    }

    local brightness_text = wibox.widget {
        widget = wibox.widget.textbox,
        font = "MesloLGS NF Bold 12",
        align = "center",
    }

    local popup = awful.popup {
        widget = {
            widget = wibox.container.background,
            bg = beautiful.colors.bg1 .. "aa",
            forced_width = dpi(220),
            {
                widget = wibox.container.margin,
                margins = dpi(20),
                {
                    layout = wibox.layout.fixed.vertical,
                    spacing = dpi(10),
                    {
                        widget = wibox.widget.textbox,
                        align = "center",
                        font = "MesloLGS NF Bold 64",
                        markup = " 盛 ",
                    },
                    brightness_text,
                    progress_bar,
                }
            }
        },
        screen = screen.primary,
        bg = "#00000000",
        type = "notification",
        ontop = true,
        visible = false,
        shape = gears.shape.rounded_rect,
        placement = awful.placement.centered,
        input_passthrough = true,
    }

    local gobj = gears.object {}
    gears.table.crush(gobj, Brightness_popup, true)

    gobj.popup = popup
    gobj.can_show = false
    gobj.timer = gears.timer {
        timeout = 2,
        call_now = false,
        autostart = false,
        single_shot = true,
        callback = function()
            gobj.popup.visible = false
        end
    }

    self.__index = self
    setmetatable(gobj, self)

    brightness_controller:connect_signal("update", function()
        brightness_text.markup = " Brightness: " .. brightness_controller.brightness .. " "
        progress_bar.value = brightness_controller.brightness
        gobj:show()
    end)

    gears.timer {
        timeout = 5,
        call_now = false,
        autostart = true,
        single_shot = true,
        callback = function()
            gobj.can_show = true
        end
    }

    Brightness_popup._instance = gobj

    return gobj
end


function Brightness_popup.mt:__call()
    return Brightness_popup:new()
end

return setmetatable(Brightness_popup, Brightness_popup.mt)

-- vim: shiftwidth=4: tabstop=4
