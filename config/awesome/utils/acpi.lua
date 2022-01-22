local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local files = require("utils.file")
local inspect = require("inspect")

local ACPI_controller = {
    tries = 0,
    mt = {}
}

function ACPI_controller:listen()
    local comm = [[acpi_listen]]
    local pid = awful.spawn.with_line_callback(comm, {
            stdout = function(line)
                self:emit_signal("update", line)
            end,
            stderr = function()
                naughty.notify { text = "An error with acpi_listen ocurred", preset = naughty.config.presets.critical }
            end
        })
    if type(pid) == "number" then
        awesome.connect_signal("exit", function()
            awesome.kill(pid, awesome.unix_signal.SIGKILL)
        end)
    end
end

function ACPI_controller:new()
    if ACPI_controller._instance then
        return ACPI_controller._instance
    end

    local gobj = gears.object {}
    gears.table.crush(gobj, ACPI_controller, true)

    self.__index = self
    setmetatable(gobj, self)

    gobj:listen()
    ACPI_controller._instance = gobj
    return gobj
end

function ACPI_controller.mt:__call()
    return ACPI_controller:new()
end

return setmetatable(ACPI_controller, ACPI_controller.mt)

-- vim: shiftwidth=4: tabstop=4
