--[[

     Blackburn Awesome WM theme 3.0
     github.com/lcpz

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local utils = require("utils")

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local gruvbox_colors = {
    -- Background
    bg = "#282828",
    bg0 = "#282828",
    bg0_s = "#32302f",
    bg0_h = "#1d2021",
    bg1 = "#3c3836",
    bg2 = "#504945",
    bg3 = "#665c54",
    bg4 = "#7c6f64",

    -- Foreground
    fg = "#ebdbb2",
    fg0 = "#fbf1c7",
    fg1 = "#ebdbb2",
    fg2 = "#d5c4a1",
    fg3 = "#bdae93",
    fg4 = "#a89984",

    -- Grayer
    gray = "#928374",
    gray1 = "#a89984",
    gray2 = "#928374",

    -- Normal Colors
    red = "#cc241d",
    green = "#98971a",
    yellow = "#d79921",
    blue = "#458588",
    purple = "#b16286",
    aqua = "#689d6a",
    orange = "#d65d0e",

    -- Light colors
    light_red = "#fb4934",
    light_green = "#b8bb26",
    light_yellow = "#fabd2f",
    light_blue = "#83a598",
    light_purple = "#d3869b",
    light_aqua = "#8ec07c",
    light_orange = "#fe8019",
}

local theme                                     = {}

theme.useless_gap                               = 1
theme.wallpaper                                 = "wall.png"
-- Fonts
theme.font                                      = "MesloLGS NF 8"
theme.taglist_font                              = "MesloLGS NF 8"
-- Normal... yap
theme.fg_normal                                 = gruvbox_colors.fg
theme.fg_focus                                  = gruvbox_colors.blue
theme.bg_normal                                 = gruvbox_colors.bg
theme.bg_focus                                  = gruvbox_colors.bg
theme.fg_urgent                                 = gruvbox_colors.fg
theme.bg_urgent                                 = gruvbox_colors.red
theme.bg_systray                                = theme.bg_normal
-- Border
theme.border_width                              = dpi(2)
theme.border_normal                             = gruvbox_colors.bg2
theme.border_focus                              = gruvbox_colors.light_blue
-- Tags
theme.taglist_fg_focus                          = gruvbox_colors.fg
theme.taglist_bg_focus                          = gruvbox_colors.blue
theme.taglist_bg_occupied                       = gruvbox_colors.bg1
-- Tasks
theme.tasklist_fg_focus                         = gruvbox_colors.fg
theme.tasklist_bg_focus                         = gruvbox_colors.blue
theme.tasklist_bg_normal                        = gruvbox_colors.bg3
theme.tasklist_bg_minimize                      = gruvbox_colors.bg1
theme.tasklist_spacing                          = dpi(4)
-- Dock
theme.dock_bg_normal = gruvbox_colors.bg1
theme.dock_fg_normal = gruvbox_colors.fg
theme.dock_bg_focus  = gruvbox_colors.light_aqua
theme.dock_bg_minimize = gruvbox_colors.bg0_h
theme.dock_border_color = gruvbox_colors.bg3
-- Snap
local rounded_bar = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 5)
end

theme.snap_bg = gruvbox_colors.light_red
theme.snap_border_width = dpi(4)
theme.snap_shape = rounded_bar
theme.snapper_gap = theme.useless_gap

--theme.tasklist_shape                            = rounded_bar
-- Menu
theme.menu_height                               = dpi(18)
theme.menu_width                                = dpi(130)

theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = false

-- Titlebar

theme.titlebar_size = dpi(22)
theme.titlebar_fg = gruvbox_colors.fg
theme.titlebar_bg = gruvbox_colors.bg

theme.notification_font = "MesloLGS NF 8.5"
theme.notification_max_width = dpi(350)
theme.notification_min_width = dpi(100)
theme.notification_bg = gruvbox_colors.bg .. "aa"
theme.notification_fg = gruvbox_colors.fg
theme.notification_spacing = dpi(30)
theme.notification_margin = dpi(20)
theme.notification_icon_resize_strategy = 'center'
theme.notification_icon_size = dpi(32)

theme.hotkeys_bg = gruvbox_colors.bg0_s .. "cc"
theme.hotkeys_group_margin = dpi(20)
theme.hotkeys_fg = gruvbox_colors.fg
theme.hotkeys_modifiers_fg = gruvbox_colors.fg3

theme.icon_theme = "Nord-Icon"

awful.util.tagnames   = { "A", "B", "C", "D", "E", "F" }

local markup     = lain.util.markup
local separators = lain.util.separators

-- App menu
local appmenu = utils.powerline:new{
    markup = "<b>   </b>",
    font = theme.font,
    normal_bg = gruvbox_colors.bg1,
    active_bg = gruvbox_colors.light_blue,
	shape = utils.powerline.flipped_arrow,
    --buttons = awful.util.appmenu_buttons, -- This is inside full rc.lua
}

local appmenu_t = awful.tooltip {
    objects = { appmenu.widget },
    bg = gruvbox_colors.bg1,
    fg = gruvbox_colors.fg,
    font = "MesloLGS NF 8",
}
appmenu.widget:connect_signal("mouse::enter", function(c)
    appmenu_t.text = "App menu"
end)

-- Power menu
local powermenu = utils.powerline:new{
    markup = "<b>   </b>",
    font = theme.font,
    normal_bg = gruvbox_colors.bg1,
    active_bg = gruvbox_colors.light_red,
    shape = utils.powerline.arrow,
    --buttons = awful.util.powermenu_buttons, -- This is inside full rc.lua
}

local powermenu_t = awful.tooltip {
    objects = { powermenu.widget },
    bg = gruvbox_colors.bg1,
    fg = gruvbox_colors.fg,
    font = "MesloLGS NF 8",
}
powermenu.widget:connect_signal("mouse::enter", function(c)
    powermenu_t.text = "Power menu"
end)

-- Textclock

local mytextclock = utils.powerline:new {
    inner_widget = {
        widget = wibox.widget.textclock("  %H:%M ")
    },
    shape = utils.powerline.flipped_powerline,
    normal_bg = gruvbox_colors.bg1,
    active_bg = gruvbox_colors.orange,
    font = theme.font,
}

-- Separators
local first     = wibox.widget.textbox('<span font="Terminus 4"> </span>')
local blank     = separators.arrow_right("alpha", "alpha")

local barheight = dpi(18)

function theme.at_screen_connect(s)

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt({
            bg = "#00000000",
            bg_cursor = gruvbox_colors.fg1,
        })

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = utils.layoutbox({
        margin = {left = 2, right = 2},
        shape = gears.shape.rectangle,
        normal_bg = gruvbox_colors.bg1,
        active_bg = gruvbox_colors.aqua,
        font = theme.font,
        screen = s,
    })
    --s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    --s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = awful.util.taglist_buttons,
        style = {
            shape = gears.shape.circle,
        },
        layout = {
            spacing = 2,
            spacing_widget = {
                color  = '#00000000',
                shape  = gears.shape.rectangle,
                widget = wibox.widget.separator,
            },
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
        {
            {
                {
                    id     = 'text',
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            left  = 3,
            right = 3,
            widget = wibox.container.margin
        },
        id     = 'background_role',
        widget = wibox.container.background,
        inactive_bg = "#00000000",
        active_bg = gruvbox_colors.blue,
        hover_bg = gruvbox_colors.light_blue,
        -- Add support for hover colors and an index label
        create_callback = function(self, tag, index, objects) --luacheck: no unused args
            self:get_children_by_id('text')[1].markup = '<b>  </b>'
            self:connect_signal('mouse::enter', function()
                self.bg = self.hover_bg
            end)
            self:connect_signal('mouse::leave', function()
                if tag.selected then self.bg = theme.taglist_bg_focus
                elseif #tag:clients() > 0 then self.bg = theme.taglist_bg_occupied
                else self.bg = self.inactive_bg end

            end)
            self:update_callback(tag, index, objects)
        end,
        update_callback = function(self, tag, index, objects) --luacheck: no unused args
                if tag.selected then
                    self:get_children_by_id('text')[1].markup = '<b>  </b>'
                    self.bg = theme.taglist_bg_focus
                elseif #tag:clients() > 0 then
                    self:get_children_by_id('text')[1].markup = '<b>  </b>'
                    self.bg = theme.taglist_bg_occupied
                else
                    self:get_children_by_id('text')[1].markup = '<span color="#a89984"><b>  </b></span>'
                    self.bg = self.inactive_bg
                end
        end,
    },
    }

    -- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        type = "desktop",
        screen = s,
        height = barheight,
        ontop = true,
        bg = gruvbox_colors.bg .. "00"
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            {
                layout = wibox.layout.fixed.horizontal,
				first,
                appmenu.widget,
                s.mytaglist,
                s.mylayoutbox,
                s.mypromptbox,
                blank,
                first,
            },
            bg = gruvbox_colors.bg .. "dd",
            shape = utils.powerline.flipped_arrow,
            widget = wibox.container.background,
        },
		--s.mytasklist, -- Middle widget
		nil,
        { -- Right widgets
            {
                layout = wibox.layout.fixed.horizontal,
				blank,
                {
                    mytextclock.widget,

                    spacing = -8,
                    fill_space = true,
                    layout = wibox.layout.fixed.horizontal,
                },
                powermenu.widget,
            },
            bg = gruvbox_colors.bg .. "ee",
            shape = utils.powerline.arrow,
            widget = wibox.container.background,
        },
    }

    local function change_wibox_visibility(client)
        if client.screen == s then
            s.mywibox.ontop = not client.fullscreen
        end
    end

    client.connect_signal("property::fullscreen", change_wibox_visibility)
    client.connect_signal("focus", change_wibox_visibility)

end

return theme
-- vim: tabstop=4 shiftwidth=4
