--[[

     Blackburn Awesome WM theme 3.0
     github.com/lcpz

--]]

local theme_assets = require("beautiful.theme_assets")
local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi
local math = require("math")
local table = require("table")

local naughty = require("naughty")

local utils = require("utils")
local inspect = require("inspect")

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
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/gruvbox"

theme.useless_gap                               = 2
theme.wallpaper                                 = theme.dir .. "/wall.png"
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
-- Icons
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.awesome_icon                              = theme.dir .."/icons/awesome.svg"
--theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
--theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.svg"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.svg"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.svg"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.svg"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.svg"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.svg"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.svg"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.svg"
theme.layout_max                                = theme.dir .. "/icons/max.svg"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.svg"
theme.layout_floating                           = theme.dir .. "/icons/floating.svg"

theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = false

-- Titlebar

theme.titlebar_size = dpi(22)

theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.svg"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.svg"
theme.titlebar_close_button_focus_hover        = theme.dir .. "/icons/titlebar/close_focus_hover.svg"
theme.titlebar_close_button_normal_hover        = theme.dir .. "/icons/titlebar/close_normal_hover.svg"

theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.svg"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.svg"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.svg"

theme.titlebar_maximized_button_focus_active_hover = theme.dir .. "/icons/titlebar/maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_active_hover = theme.dir .. "/icons/titlebar/maximized_normal_active_hover.svg"
theme.titlebar_maximized_button_focus_inactive_hover = theme.dir .. "/icons/titlebar/maximized_focus_active.svg"
theme.titlebar_maximized_button_normal_inactive_hover = theme.dir .. "/icons/titlebar/maximized_normal_active_hover.svg"

theme.titlebar_minimize_button_focus_active     = theme.dir .. "/icons/titlebar/minimize_active.svg"
theme.titlebar_minimize_button_normal_active    = theme.dir .. "/icons/titlebar/minimize_inactive.svg"
theme.titlebar_minimize_button_focus_inactive   = theme.dir .. "/icons/titlebar/minimize_active.svg"
theme.titlebar_minimize_button_normal_inactive  = theme.dir .. "/icons/titlebar/minimize_inactive.svg"

theme.titlebar_fg = gruvbox_colors.fg
theme.titlebar_bg = gruvbox_colors.bg

theme.notification_font = "MesloLGS NF 8.5"
--theme.notification_width = dpi(100)
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

theme.tag_preview_widget_border_radius = dpi(5)          -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = dpi(5)          -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity = 0.8              -- Opacity of each client
theme.tag_preview_client_bg = gruvbox_colors.bg0_s             -- The bg color of each client
theme.tag_preview_client_border_color = gruvbox_colors.light_aqua   -- The border color of each client
theme.tag_preview_client_border_width = 3           -- The border width of each client
theme.tag_preview_widget_bg = gruvbox_colors.bg0             -- The bg color of the widget
theme.tag_preview_widget_border_color = gruvbox_colors.bg2   -- The border color of the widget
theme.tag_preview_widget_border_width = dpi(3)           -- The border width of the widget
theme.tag_preview_widget_margin = 5                 -- The margin of the widget

theme.task_preview_widget_border_radius = dpi(5)          -- Border radius of the widget (With AA)
theme.task_preview_widget_bg = gruvbox_colors.bg0             -- The bg color of the widget
theme.task_preview_widget_border_color = gruvbox_colors.bg2   -- The border color of the widget
theme.task_preview_widget_border_width = 3           -- The border width of the widget
theme.task_preview_widget_margin = 5


awful.util.tagnames   = { "A", "B", "C", "D", "E", "F" }

local markup     = lain.util.markup
local separators = lain.util.separators

-- App menu
local appmenu = utils.powerline:new{
    markup = "<b>  </b>",
    font = theme.font,
    normal_bg = gruvbox_colors.bg1,
    active_bg = gruvbox_colors.light_blue,
	shape = gears.shape.rectangle,
    buttons = awful.util.appmenu_buttons,
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
    buttons = awful.util.powermenu_buttons,
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

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock.widget },
    notification_preset = {
        font = "MesloLGS NF 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- Battery
local battery = utils.battery:new {
    widget = utils.powerline:new {
        markup = " Battery ",
        normal_bg = gruvbox_colors.bg1,
        active_bg = gruvbox_colors.green,
        shape = utils.powerline.flipped_powerline,
    }.widget,
    settings = function(self)
        local bat_header = ""

        if     self.perc >= 99 then bat_header = "  "
        elseif self.perc >= 90 then bat_header = "  "
        elseif self.perc >= 80 then bat_header = "  "
        elseif self.perc >= 70 then bat_header = "  "
        elseif self.perc >= 60 then bat_header = "  "
        elseif self.perc >= 50 then bat_header = "  "
        elseif self.perc >= 40 then bat_header = "  "
        elseif self.perc >= 30 then bat_header = "  "
        elseif self.perc >= 20 then bat_header = "  "
        elseif self.perc >= 10 then bat_header = "  "
        else                        bat_header = "  " end

        if self.ac_status == 1 then
            bat_header = bat_header .. " "
        end

        if self.perc >= 30 then self.widget.active_bg = gruvbox_colors.green
        elseif self.perc >= 15 then self.widget.active_bg = gruvbox_colors.yellow
        else self.widget.active_bg = gruvbox_colors.red end

        local bat_p      = self.perc .. "% "
        local text_value = markup.font(theme.font, bat_header .. bat_p)

        self.widget:get_children_by_id("text")[1]:set_markup(text_value)
    end
}
battery.widget:buttons(gears.table.join(
    awful.button({ }, 1, function() battery:full_update() end)
))

bat_notification_charged_preset = {
    title = "Battery full",
    text = "You can unplug the cable",
    timeout = 10,
    fg = gruvbox_colors.fg,
    bg = gruvbox_colors.bg1
}
bat_notification_low_preset = {
    title = "Battery low",
    text = "Plug the cable!",
    timeout = 10,
    fg = gruvbox_colors.fg,
    bg = gruvbox_colors.yellow
}
bat_notification_critical_preset = {
    title = "Battery exhausted",
    text = "Shutdown inminent",
    timeout = 10,
    fg = gruvbox_colors.fg,
    bg = gruvbox_colors.red
}
local battery_t = awful.tooltip {
    objects = { battery.widget },
    bg = gruvbox_colors.bg1,
    fg = gruvbox_colors.fg,
    font = "MesloLGS NF 8",
}
battery.widget:connect_signal("mouse::enter", function(c)
    battery_t.text = battery.status
end)

-- PULSE volume
theme.volume = lain.widget.pulse({
    widget = utils.powerline:new({
        markup = " Volume ",
        font = theme.font,
        normal_bg = gruvbox_colors.bg1,
        active_bg = gruvbox_colors.purple,
        shape = utils.powerline.flipped_powerline,
    }).widget,
    settings = function()
        local header = "  "
        local vlevel = volume_now.left .. "-" .. volume_now.right .. "% "

        if volume_now.muted == "yes" then
            header = " 婢 "
        else
            header = "  "
        end

        local text_value = header .. vlevel

        widget:get_children_by_id("text")[1]:set_markup(text_value)
    end

})
local volume_t = awful.tooltip {
    objects = { theme.volume.widget },
    bg = gruvbox_colors.bg1,
    fg = gruvbox_colors.fg,
    font = "MesloLGS NF 8",
}
theme.volume.widget:connect_signal("mouse::enter", function()
    volume_t.text = "Volume at " .. volume_now.left .. "-" .. volume_now.right .. "%"
end)

-- Brightness

local brightness_widget = {}
brightness_widget = utils.brightness:new({
    widget = utils.powerline:new{
        markup = " Brightness ",
        normal_bg = gruvbox_colors.bg1,
        active_bg = gruvbox_colors.aqua,
        shape = utils.powerline.flipped_powerline,
    }.widget,
    font = theme.font,
    spacing = 4,
    settings = function(self)
        local header = "  "
        self.text_value = markup.font(theme.font, header .. self.brightness_value .. "% ")
    end
})

brightness_widget.widget:buttons(awful.util.table.join(
    awful.button({}, 1, function() awful.util.launch_rofi("applet_backlight") end),
    awful.button({}, 4, function() brightness_widget:inc() end),
    awful.button({}, 5, function() brightness_widget:dec() end)
))
local brightness_t = awful.tooltip {
    objects = { brightness_widget.widget },
    bg = gruvbox_colors.bg1,
    fg = gruvbox_colors.fg,
    font = "MesloLGS NF 8",
}
brightness_widget.widget:connect_signal("mouse::enter", function()
    brightness_t.text =  "Brightness at " .. brightness_widget.brightness_value .. "%"
end)

theme.brightness_widget = brightness_widget

-- Separators
local first     = wibox.widget.textbox('<span font="Terminus 4"> </span>')
local blank     = separators.arrow_right("alpha", "alpha")

local barheight = dpi(18)

local bling = require("bling")

local function load_random_wallpaper()
	local wallpaper = gears.filesystem.get_random_file_from_dir(theme.dir .. "/wallpapers/",
		{"jpg", "png"}, true)
	theme.wallpaper = wallpaper
end

load_random_wallpaper()


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

    bling.widget.tag_preview.enable {
            show_client_content = true,  -- Whether or not to show the client content
            x = 10,                       -- The x-coord of the popup
            y = 10,                       -- The y-coord of the popup
            scale = 0.25,                 -- The scale of the previews compared to the screen
            honor_padding = false,        -- Honor padding when creating widget size
            honor_workarea = false,       -- Honor work area when creating widget size
            placement_fn = function(c)    -- Place the widget using awful.placement (this overrides x & y)
                awful.placement.top_left(c, {
                    margins = {
                        top = 24,
                        left = 24
                    }
                })
            end
        }

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
                if #tag:clients() > 0 then
                    -- BLING: Update the widget with the new tag
                    awesome.emit_signal("bling::tag_preview::update", tag)
                    -- BLING: Show the widget
                    awesome.emit_signal("bling::tag_preview::visibility", s, true)
                else
                    awesome.emit_signal("bling::tag_preview::visibility", s, false)
                end
            end)
            self:connect_signal('mouse::leave', function()
                if tag.selected then self.bg = theme.taglist_bg_focus
                elseif #tag:clients() > 0 then self.bg = theme.taglist_bg_occupied
                else self.bg = self.inactive_bg end

                --awesome.emit_signal("bling::tag_preview::visibility", s, false)
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
    s.mytaglist:connect_signal("mouse::leave", function()
        awesome.emit_signal("bling::tag_preview::visibility", s, false)
    end)

    -- Create a tasklist widget
    --s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = awful.util.tasklist_buttons,
        style = {
            --shape = gears.shape.powerline
        },
        --layout = {
            --layout = wibox.layout.flex.horizontal
        --},
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 10,
                right = 10,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            bg = theme.tasklist_bg_focus,
            widget = wibox.container.background,
            create_callback = function(self, task, index, objects)
                self:connect_signal('mouse::enter', function()
                    if client.focus == task then self.bg = gruvbox_colors.light_blue
                    elseif task.minimized then self.bg = gruvbox_colors.bg2
                    else self.bg = gruvbox_colors.bg4 end
                end)
                self:connect_signal('mouse::leave', function()
                    if client.focus == task then self.bg = theme.tasklist_bg_focus
                    elseif task.minimized then  self.bg = theme.tasklist_bg_minimize
                    else self.bg = theme.tasklist_bg_normal end
                end)
            end,
            update_callback = function(self, task, index, objects)
                local text_widget = self:get_children_by_id("text_role")[1]
                if task.minimized then
                    text_widget.visible = false
                else
                    text_widget.visible = true
                    self.forced_width = nil
                end
            end
        },
    }

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
                    --wibox.widget.systray(),
                    brightness_widget.widget,
                    --bat.widget,
                    battery.widget,
                    theme.volume.widget,
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

    s.dock = utils.dock:new({
            screen = s,
            position = "right"
        })

end

return theme
-- vim: tabstop=4 shiftwidth=4
