local awful = require("awful")
local naughty = require("naughty")

local function poweroff()
    naughty.notify { title = "Power off", text = "Your system will be shut down" }
    awful.spawn.easy_async("loginctl poweroff", function(_, stderr)
        if stderr ~= "" then
            naughty.notify { title = "Power off error", text = stderr }
        end
    end)
end

local function restart()
    naughty.notify { title = "Restart", text = "Your system will be restarted" }
    awful.spawn.easy_async("loginctl reboot", function(_, stderr)
        if stderr ~= "" then
            naughty.notify { title = "Restart error", text = stderr }
        end
    end)
end

local function suspend()
    naughty.notify { title = "Suspend", text = "Your system will be suspended" }
    awful.spawn.easy_async("loginctl suspend", function(_, stderr)
        if stderr ~= "" then
            naughty.notify { title = "Suspend error", text = stderr }
        end
    end)
end

local function hibernate()
    naughty.notify { title = "Hibernate", text = "Your system will be hibernated" }
    awful.spawn.easy_async("loginctl hibernate", function(_, stderr)
        if stderr ~= "" then
            naughty.notify { title = "Hibernate error", text = stderr }
        end
    end)
end

local function logout()
    naughty.notify { title = "Log out", text = "Logging out" }
    awesome.quit()
end

return {
    poweroff = poweroff,
    restart = restart,
    suspend = suspend,
    hibernate = hibernate,
    logout = logout,
}

-- vim: shiftwidth=4: tabstop=4
