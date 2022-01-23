local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local files = require("utils.file")
local inspect = require("inspect")

local home = os.getenv("HOME")

local Brightness_controller = {
    mt = {}
}

function Brightness_controller:watch()
    local script = string.format("%s/.config/awesome/scripts/watchfile", home)
    local comm = string.format("%s \"%s\"", script, self.brightness_path)
    local pid = awful.spawn.with_line_callback(comm, {
            stdout = function()
                self:update()
            end,
            stderr = function(line)
                naughty.notify { title = "Brightness", text = line }
            end,
        })
    if type(pid) == "number" then
        awesome.connect_signal("exit", function()
            awesome.kill(pid, awesome.unix_signal.SIGKILL)
        end)
    end
end

function Brightness_controller:update()
    local brightness = self:get()
    if brightness ~= nil then
        self:emit_signal("update")
    end
end

--- Get brightness
--- @return number|nil
function Brightness_controller:get()
    local brightness = files.read_first_line(self.brightness_path)
    local brightness_level = nil
    if brightness ~= nil then
        brightness_level = math.floor(tonumber(brightness) * 100 / self.max_brightness
                                        + 0.5)
        self.brightness = brightness_level
    end
    return brightness_level
end

--- Set brightness
--- @param value number
--- @param step number
function Brightness_controller:set(value, step)
    if value > 100 then value = 100
    elseif value < 0 then value = 0
    end
    step = step or 10
    local sleep = self.delay / step
    local current = self:get()
    if step <= 1 then
        local brightness = string.format("%d",
            math.floor(value * self.max_brightness / 100 + 0.5))
        files.write(self.brightness_path, brightness)
        return
    end

    local i = 0
    local timer = gears.timer {
        timeout = sleep,
        autostart = true,
    }
    timer:connect_signal("timeout", function()
        if i > step then
            timer:stop()
            return
        end
        local brigh = current + ((value - current) * i) / step
        local brightness = string.format("%d",
            math.floor(brigh * self.max_brightness / 100 + 0.5))
        files.write(self.brightness_path, brightness)
        i = i + 1
    end)
end

function Brightness_controller:inc(value, step)
    step = step or 10
    self:set(self.brightness + value, step)
end
function Brightness_controller:dec(value, step)
    step = step or 10
    self:set(self.brightness - value, step)
end

function Brightness_controller:new()
    if Brightness_controller._instance then
        return Brightness_controller._instance
    end

    local gobj = gears.object {}
    gears.table.crush(gobj, Brightness_controller, true)
    gobj.brightness_path = "/sys/class/backlight/intel_backlight/brightness"
    gobj.max_brightness_path = "/sys/class/backlight/intel_backlight/max_brightness"
    gobj.delay = 0.2

    gobj.brightness = nil
    gobj.max_brightness = tonumber(files.read_first_line("/sys/class/backlight/intel_backlight/max_brightness"))

    self.__index = self
    setmetatable(gobj, self)

    gears.timer {
        timeout = 1,
        autostart = true,
        sigle_shot = true,
        callback = function()
            gobj:update()
        end
    }

    gobj:watch()
    Brightness_controller._instance = gobj
    return gobj
end

function Brightness_controller.mt:__call()
    return Brightness_controller:new()
end

return setmetatable(Brightness_controller, Brightness_controller.mt)
