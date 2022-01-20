local awful = require("awful")
local naughty = require("naughty")

local function lockscreen(s) ---@diagnostic disable-line: unused-local
    local socket = "/tmp/xidlehook.sock"
    local timer = 1
    local st = "xidlehook-client --socket " .. socket .. " control --action trigger --timer " .. timer
    awful.spawn(st)
end

local home = os.getenv("HOME")
local rofi_dir = home .. "/.config/rofi/bin/"

local function launch_rofi(rof)
    awful.spawn(rofi_dir .. rof)
end

local function launcher(s) ---@diagnostic disable-line: unused-local
    local launcher_type = "launcher_ribbon"
    awful.spawn(rofi_dir .. launcher_type)
end

local function app_menu(s) ---@diagnostic disable-line: unused-local
    local launcher_type = "launcher_slate"
    awful.spawn(rofi_dir .. launcher_type)
end

local function power_menu(s) ---@diagnostic disable-line: unused-local
    local launcher_type = "powermenu"
    awful.spawn(rofi_dir .. launcher_type)
end

local function screenshot(s) ---@diagnostic disable-line: unused-local
    --local st = home .. "/.takeScreenshot.sh"
    local st = rofi_dir .. "applet_screenshot"
    awful.spawn(st)
end

return {
    lockscreen = lockscreen,
    launch_rofi = launch_rofi,
    launcher = launcher,
    app_menu = app_menu,
    power_menu = power_menu,
    screenshot = screenshot
}
