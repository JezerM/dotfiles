local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local naughty = require("naughty")
local gears = require("gears")

local helpers = require("lain.helpers")

-- Meta class

Brightness = {
    brightness_value = 0,
    layout = 0,
    text_value = "",
    widget = wibox.widget,
}

local get_brightness_cmd = "xbacklight -get"
local inc_brightness_cmd = "xbacklight -inc "
local dec_brightness_cmd = "xbacklight -dec "
local set_brightness_cmd = "xbacklight -set "

function Brightness:new(object)
    self.widget = object.widget
    self.settings = object.settings
    local timer = gears.timer {
        timeout = 5,
        call_now = true,
        callback = function()
            self:update()
        end
    }
    timer:start()
    return self
end

function Brightness:update()
    awful.spawn.easy_async(get_brightness_cmd, function(out)
        local brightness_level = tonumber(string.format("%.0f", out))
        self.brightness_value = brightness_level
        self:set_text()
    end)
end

function Brightness:settings()
end

function Brightness:set_text()
    self:settings()
    self.widget:get_children_by_id("text")[1]:set_markup(self.text_value)
end

function Brightness:inc(step)
    step = step or 10
    awful.spawn.easy_async(inc_brightness_cmd .. step, function()
        self:update()
    end)
end

function Brightness:dec(step)
    step = step or 10
    awful.spawn.easy_async(dec_brightness_cmd .. step, function()
        self:update()
    end)
end

function Brightness:set(value, step)
    step = step or 10
    awful.spawn.easy_async(set_brightness_cmd .. step, function()
        self:update()
    end)
end


--local bri = Brightness({
    --settings = function(self)
        --self.text_value = " Bright " .. self.brightness_value .. "% "
    --end
--})

return Brightness