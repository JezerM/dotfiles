local gears         = require("gears")
local awful         = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
                      require("awful.hotkeys_popup.keys")
local utils         = require("utils")

local modkey = awful.util.keys.modkey
local altkey = awful.util.keys.altkey

local brightness_controller = require("utils.brightness"):new{}

local global_keys = gears.table.join(
    -- Show help
    awful.key({ modkey }, "d", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),

    -- Take a screenshot
    awful.key({ modkey }, "s", utils.apps.screenshot,
        { description = "take a screenshot", group = "client" }),

    -- Lock screen
    awful.key({ modkey, altkey }, "l", utils.apps.lockscreen,
        { description = "lock screen", group = "client" }),

    -- Layout switching
    awful.key({ modkey }, "Tab", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "Tab", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),

    -- Tag browsing
    awful.key({ modkey }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }),

    -- Default client movement
    awful.key({ modkey }, "j", function() awful.client.focus.byidx(1) end,
        { description = "focus next by index", group = "client" }),
    awful.key({ modkey }, "k", function() awful.client.focus.byidx(-1) end,
        { description = "focus previous by index", group = "client" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1)    end,
        {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1)    end,
        {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative(1) end,
        {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
        {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}),

    -- Show/hide wibox
    awful.key({ modkey }, "b", function ()
            for s in screen do
                s.wibox.visible = not s.wibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "toggle wibox", group = "awesome"}),

    -- Standard program
    awful.key({ modkey }, "Return", function () awful.spawn(awful.util.terminal) end,
        {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Control" }, "q", awesome.quit,
        {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey }, "l", function () awful.tag.incmwfact(0.05) end,
        {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end,
        {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1, nil, true) end,
        {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1, nil, true) end,
        {description = "decrease the number of master clients", group = "layout"}),

    awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1, nil, true) end,
        {description = "increase the number of columns", group = "layout"}),

    awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1, nil, true) end,
        {description = "decrease the number of columns", group = "layout"}),

    -- Restore minimize
    awful.key({ modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end, {description = "restore minimized", group = "client"}),
    --
    -- Brightness
    awful.key({}, "XF86MonBrightnessUp", function()
            brightness_controller:inc(10, 10)
        end,
        {description = "increase brightness", group = "client"}),
    awful.key({}, "XF86MonBrightnessDown", function()
            brightness_controller:dec(10, 10)
        end,
        {description = "decrease brightness", group = "client"}),

    -- Prompt
    awful.key({ modkey }, "r", function () awful.screen.focused().promptbox:run() end,
        {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "x",
        function ()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().promptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {description = "lua execute prompt", group = "awesome"}),
    awful.key({ modkey }, "p", utils.apps.launcher,
        {description = "show rofi launcher", group = "launcher"})
)

local client_keys = gears.table.join(
    -- Fullscreen
    awful.key({ modkey }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),

    -- Kill client
    awful.key({ modkey, "Shift" }, "c", function (c)
            c:kill()
        end,
        {description = "close", group = "client"}),

    -- Toggle floating
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}),

    -- Client management
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
        {description = "move to master", group = "client"}),

    awful.key({ modkey }, "o", function (c) c:move_to_screen() end,
        {description = "move to screen", group = "client"}),

    -- Maximize, minimize
    awful.key({ modkey }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey }, "n", function (c) c.minimized = true end,
        {description = "minimize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    global_keys = gears.table.join(
        global_keys,
        -- View tag only
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then tag:view_only() end
            end,
            { description = "view tag #" .. i, group = "tag" }),

        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then awful.tag.viewtoggle(tag) end
            end,
            {description = "toggle tag #" .. i, group = "tag"}),

        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:move_to_tag(tag) end
                end
            end,
            {description = "move focused client to tag #"..i, group = "tag"}),

        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:toggle_tag(tag) end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

local client_buttons = gears.table.join(
    awful.button({ }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

return {
    global_keys = global_keys,
    client_keys = client_keys,
    client_buttons = client_buttons,
}

-- vim: shiftwidth=4: tabstop=4
