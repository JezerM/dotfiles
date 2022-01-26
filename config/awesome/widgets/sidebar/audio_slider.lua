local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = require("beautiful.xresources").apply_dpi
local utils = require("utils")

local audio_controller = utils.audio {}

local Audio_slider = {
    mt = {}
}

function Audio_slider:new()
    local slider = wibox.widget {
        bar_shape = gears.shape.rounded_rect,
        bar_height = dpi(5),
        bar_color = beautiful.colors.bg2,
        bar_active_color = beautiful.colors.light_purple,
        handle_shape = gears.shape.circle,
        handle_width = dpi(12),
        handle_color = beautiful.colors.light_purple,
        value = audio_controller.volume.left or 0,
        forced_width = dpi(100),
        forced_height = dpi(10),
        minimum = 0,
        maximum = 100,
        widget = wibox.widget.slider,
    }
    slider:connect_signal("property::value", function(_, value)
        audio_controller:set(value)
    end)
    audio_controller:connect_signal("update", function()
        slider.value = audio_controller.volume.left
    end)

    return slider
end

return Audio_slider

-- vim: shiftwidth=4: tabstop=4
