local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local files = require("utils.file")
local inspect = require("inspect")

local Battery = {}

function Battery:get_batteries()
    files.scandir_line("/sys/class/power_supply/", function(line)
        local bstr = string.match(line, "BAT%w+")
        if bstr then
            self.batteries[#self.batteries + 1] = {
            name = bstr,
            status = "N/A",
            perc = 0,
            capacity = 0,
        }
        else
            self.ac = string.match(line, "A%w+") or self.ac
        end
    end)
end

local last_time = os.time()
local running = false

-- Taken from "lain" battery widget
function Battery:full_update()
    local now_time = os.time()
    if ((now_time - last_time) < 2) or running then
        return
    end
    last_time = now_time
    running = true

    local sum_rate_current  = 0
    local sum_rate_voltage  = 0
    local sum_rate_power    = 0
    local sum_rate_energy   = 0
    local sum_energy_now    = 0
    local sum_energy_full   = 0
    local sum_charge_full   = 0
    local sum_charge_design = 0

    for i, battery in ipairs(self.batteries) do
        local bstr    = self.pspath .. battery.name
        local present = files.read_first_line(bstr .. "/present")

        if tonumber(present) == 1 then
            -- current_now(I)[uA], voltage_now(U)[uV], power_now(P)[uW]
            local rate_current = tonumber(files.read_first_line(bstr .. "/current_now"))
            local rate_voltage = tonumber(files.read_first_line(bstr .. "/voltage_now"))
            local rate_power   = tonumber(files.read_first_line(bstr .. "/power_now"))
            local charge_full  = tonumber(files.read_first_line(bstr .. "/charge_full"))
            local charge_design = tonumber(files.read_first_line(bstr .. "/charge_full_design"))

            -- energy_now(P)[uWh], charge_now(I)[uAh]
            local energy_now = tonumber(files.read_first_line(bstr .. "/energy_now") or
                               files.read_first_line(bstr .. "/charge_now"))

            -- energy_full(P)[uWh], charge_full(I)[uAh]
            local energy_full = tonumber(files.read_first_line(bstr .. "/energy_full") or
                                charge_full)

            local energy_percentage = tonumber(files.read_first_line(bstr .. "/capacity")) or
                                      math.floor((energy_now / energy_full) * 100)

            self.batteries[i].status = files.read_first_line(bstr .. "/status") or "N/A"
            self.batteries[i].perc   = energy_percentage or self.batteries[i].perc

            if not charge_design or charge_design == 0 then
                self.batteries[i].capacity = 0
            else
                self.batteries[i].capacity = math.floor((charge_full / charge_design) * 100)
            end

            sum_rate_current  = sum_rate_current + (rate_current or 0)
            sum_rate_voltage  = sum_rate_voltage + (rate_voltage or 0)
            sum_rate_power    = sum_rate_power + (rate_power or 0)
            sum_rate_energy   = sum_rate_energy + (rate_power or (((rate_voltage or 0) * (rate_current or 0)) / 1e6))
            sum_energy_now    = sum_energy_now + (energy_now or 0)
            sum_energy_full   = sum_energy_full + (energy_full or 0)
            sum_charge_full   = sum_charge_full + (charge_full or 0)
            sum_charge_design = sum_charge_design + (charge_design or 0)
        end

    end

    self.capacity = math.floor(math.min(100, (sum_charge_full / sum_charge_design) * 100))
    self.status = #self.batteries > 0 and self.batteries[1].status or "N/A"

    for _, battery in ipairs(self.batteries) do
        if battery.status == "Discharging" or battery.status == "Charging" then
            self.status = battery.status
        end
    end

    self.ac_status = tonumber(files.read_first_line(string.format("%s%s/online", self.pspath, self.ac))) or "N/A"

    if self.status ~= "N/A" then
        if self.status ~= "Full" and sum_rate_power == 0 and self.ac_status == 1 then
            self.perc  = math.floor(math.min(100, (sum_energy_now / sum_energy_full) * 100) + 0.5)
            self.time  = "00:00"
            self.watt  = 0

        -- update {perc,time,watt} iff battery not full and rate > 0
        elseif self.status ~= "Full" then
            local rate_time = 0
            -- Calculate time and watt if rates are greater then 0
            if (sum_rate_power > 0 or sum_rate_current > 0) then
                local div = (sum_rate_power > 0 and sum_rate_power) or sum_rate_current

                if self.status == "Charging" then
                    rate_time = (sum_energy_full - sum_energy_now) / div
                else -- Discharging
                    rate_time = sum_energy_now / div
                end

                if 0 < rate_time and rate_time < 0.01 then -- check for magnitude discrepancies (#199)
                    local rate_time_magnitude = math.abs(math.floor(math.log10(rate_time)))
                    rate_time = rate_time * 10^(rate_time_magnitude - 2)
                end
             end

            local hours   = math.floor(rate_time)
            local minutes = math.floor((rate_time - hours) * 60)
            self.perc  = math.floor(math.min(100, (sum_energy_now / sum_energy_full) * 100) + 0.5)
            self.time  = string.format("%02d:%02d", hours, minutes)
            self.watt  = tonumber(string.format("%.2f", sum_rate_energy / 1e6))
        elseif self.status == "Full" then
            self.perc  = 100
            self.time  = "00:00"
            self.watt  = 0
        end
    end

    self.perc = self.perc == nil and 0 or self.perc

    self:settings()

    self:run_notification()

    running = false
end

local fullnotification = false

function Battery:run_notification()
    local critic_perc = self.critic_perc or { 5, 15 }
    local full_notify = self.full_notify or self.notify

    if self.notify == "on" then
        if self.status == "Discharging" then
            if tonumber(self.perc) <= critic_perc[1] then
                self.id = naughty.notify({
                    preset = self.notification_critical_preset,
                    replaces_id = self.id
                }).id
            elseif tonumber(self.perc) <= critic_perc[2] then
                self.id = naughty.notify({
                    preset = self.notification_low_preset,
                    replaces_id = self.id
                }).id
            end
            fullnotification = false
        elseif self.status == "Full" and full_notify == "on" and not fullnotification then
            self.id = naughty.notify({
                preset = self.notification_charged_preset,
                replaces_id = self.id
            }).id
            fullnotification = true
        end
    end
end

function Battery:start_timer()
    local comm = [[acpi_listen]]
    local pid = awful.spawn.with_line_callback(comm, {
            stdout = function(line)
                if string.find(line, "battery") or string.find(line, "ac_adapter") then
                    self:full_update()
                end
                --gears.timer {
                    --timeout = 0.2,
                    --autostart = true,
                    --single_shot = true,
                    --callback = function()
                        --self:full_update()
                    --end
                --}
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

function Battery:new(args)
    local b = {}
    b.pspath = args.pspat or "/sys/class/power_supply/"
    b.widget = args.widget or {
        widget = wibox.container.background,
        {
            widget = wibox.widget.textbox,
            id = "text"
        }
    }
    b.settings = args.settings
    b.batteries = {}
    b.ac = "AC0"
    b.notify = "on"
    b.status = "N/A"

    b.notification_critical_preset = args.notification_critical_preset or {
        title = "Battery exhausted",
        text = "Shutdown inminent",
        timeout = 15,
        fg = "#000000",
        bg = "#FFFFFF",
    }
    b.notification_low_preset = args.notification_low_preset or {
        title = "Battery low",
        text = "Plug the cable!",
        timeout = 15,
        fg = "#202020",
        bg = "#CDCDCD",
    }
    b.notification_charged_preset = args.notification_charged_preset or {
        title = "Battery full",
        text = "You can unplug the cable",
        timeout = 15,
        fg = "#202020",
        bg = "#CDCDCD",
    }


    self.__index = self
    setmetatable(b, self)

    if #b.batteries == 0 then b:get_batteries() end

    gears.timer {
        timeout = 5,
        autostart = true,
        single_shot = true,
        callback = function()
            b:full_update()
        end
    }

    b:full_update()
    b:start_timer()

    return b
end

return Battery

-- vim: shiftwidth=4: tabstop=4
