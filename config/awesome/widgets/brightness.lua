local wibox = require("wibox")
local naughty = require("naughty")
local brightness_controller = require("utils.brightness")

local Brightness = {}

function Brightness:update()
    self.brightness = self.controller:get()
    --naughty.notify { title = "Brightness", text = "Update: " .. self.brightness }
    self:settings()
end

function Brightness:settings()
end

function Brightness:new(o)
    local b = {}

    b.settings = o.settings
    b.widget = o.widget or wibox.widget {
        widget = wibox.container.background,
        {
            widget = wibox.widget.textbox,
            id = "text"
        }
    }

    b.brightness = nil
    b.controller = brightness_controller()

    self.__index = self
    setmetatable(b, self)

    b.controller:connect_signal("update", function()
        b:update()
    end)

    return b
end

return Brightness
