-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")


--local awesome       = require("awesome")
local gears         = require("gears")
local wibox         = require("wibox")
local awful         = require("awful")
                      require("awful.autofocus")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local utils         = require("utils")
local dpi           = require("beautiful.xresources").apply_dpi

os.setlocale("", "all")

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Some variable setting

local themes = {
    "gruvbox",
}
local chosen_theme = themes[1]
local modkey = "Mod4"
local altkey = "Mod1"

local terminal = "alacritty"
local editor = os.getenv("EDITOR") or "nvim"
local home = os.getenv("HOME")
local editor_cmd = terminal .. " -e " .. editor

awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4", "5" }
awful.util.keys = {
    modkey = modkey,
    altkey = altkey,
}

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating,
}
-- }}}

awful.util.launch_rofi = utils.apps.launch_rofi

awful.util.powermenu_buttons = gears.table.join(
    awful.button({ }, 1, function(a) utils.apps.power_menu() end) ---@diagnostic disable-line: unused-local
)

awful.util.taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
            c:jump_to()
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
     end),
     awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
     awful.button({ }, 5, function() awful.client.focus.byidx(-1) end)
)

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", home, chosen_theme))

-- {{{ Screen

screen.connect_signal("property::geometry", function(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

screen.connect_signal("arrange", function(s)
    local current_tag = awful.screen.focused().selected_tag
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if (only_one and not c.floating) or c.maximized or
            current_tag.layout == awful.layout.suit.floating
            then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

local screen_config = require("screen-config")

awful.screen.connect_for_each_screen(function(s)
    screen_config.at_screen_connect(s)
end)
-- }}}


-- {{{ Rules
local keys = require("keys")

root.keys(keys.global_keys)

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = keys.client_keys,
        buttons = keys.client_buttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen,
        --size_hints_honor = false,
     }
    },
    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true }
    },

    { rule = { class = "Plank" },
        properties = {
            border_width = 0,
            border_color = "#000",
            ontop = true,
            type = "window",
            no_border = true,
        }},
}
-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
     if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    local titlebar = awful.titlebar(c, {
        size = beautiful.titlebar_size
    })

    titlebar: setup {
        { -- Right
            {
                awful.titlebar.widget.closebutton    (c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.minimizebutton(c),
                --awful.titlebar.widget.floatingbutton (c),
                --awful.titlebar.widget.stickybutton   (c),
                --awful.titlebar.widget.ontopbutton    (c),
                layout = wibox.layout.fixed.horizontal()
            },
            left = dpi(3),
            right = dpi(3),
            widget = wibox.container.margin
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            left = dpi(3),
            right = dpi(10),
            widget = wibox.container.margin
        },
        --{ -- Left
            --awful.titlebar.widget.iconwidget(c),
            --buttons = buttons,
            --layout  = wibox.layout.fixed.horizontal
        --},
        nil,
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if not c.minimized then
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end
end)

client.connect_signal("focus", function(c)
    if c.no_border then return end
    c.border_color = beautiful.border_focus
    --c.border_width = dpi(2)
end)
client.connect_signal("unfocus", function(c)
    if c.no_border then return end
    c.border_color = beautiful.border_normal
    --c.border_width = 0
end)

-- }}}

awful.spawn.with_shell("~/.config/awesome/autostart.sh")

awful.spawn.with_shell(
       'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
       'xrdb -merge <<< "awesome.started:true";' ..
       -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
       'dex --environment Awesome --autostart --search-paths "~/.config/autostart"' -- https://github.com/jceb/dex
       )


require("widgets.dock")

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- vim: shiftwidth=4: tabstop=4
