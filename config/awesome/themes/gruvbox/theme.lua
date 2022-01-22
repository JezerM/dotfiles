local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local dpi   = require("beautiful.xresources").apply_dpi

local rounded_bar = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, dpi(8))
end

local colors = {
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

local theme = {}

theme.dir = os.getenv("HOME") .. "/.config/awesome/themes/gruvbox"
theme.colors = colors

theme.useless_gap = dpi(3)
theme.wibar_height = dpi(30)
theme.wibar_bg = colors.bg

-- Font
theme.font = "MesloLGS NF 8"
theme.taglist_font = "MesloLGS NF 8"

-- Common colors
theme.fg_normal = colors.fg
theme.fg_focus = colors.blue
theme.fg_hover = colors.light_blue

theme.bg_normal = colors.bg
theme.bg_focus = colors.bg1
theme.bg_hover = colors.bg3

theme.fg_urgent = colors.fg
theme.bg_urgent = colors.red

-- Border
theme.border_width = dpi(2)
theme.border_normal = colors.bg2
theme.border_focus = colors.light_blue

-- Tags
theme.taglist_fg_focus = colors.fg
theme.taglist_bg_focus = colors.blue
theme.taglist_bg_hover = colors.light_blue
theme.taglist_bg_occupied = colors.bg1

-- Tasks
theme.tasklist_fg_focus = colors.fg
theme.tasklist_bg_focus = colors.blue
theme.tasklist_bg_normal = colors.bg1
theme.tasklist_bg_minimize = colors.bg0_h
theme.tasklist_bg_hover = colors.light_blue
theme.tasklist_spacing = dpi(4)

-- Snap
theme.snap_bg = colors.light_red
theme.snap_border_width = dpi(4)
theme.snap_shape = rounded_bar
theme.snapper_gap = theme.useless_gap

-- Icons
theme.layout_tile = theme.dir .. "/icons/tile.svg"
theme.layout_tileleft = theme.dir .. "/icons/tileleft.svg"
theme.layout_tilebottom = theme.dir .. "/icons/tilebottom.svg"
theme.layout_tiletop = theme.dir .. "/icons/tiletop.svg"
theme.layout_fairv = theme.dir .. "/icons/fairv.svg"
theme.layout_fairh = theme.dir .. "/icons/fairh.svg"
theme.layout_spiral = theme.dir .. "/icons/spiral.svg"
theme.layout_dwindle = theme.dir .. "/icons/dwindle.svg"
theme.layout_max = theme.dir .. "/icons/max.svg"
theme.layout_fullscreen = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier = theme.dir .. "/icons/magnifier.svg"
theme.layout_floating = theme.dir .. "/icons/floating.svg"

theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = false

-- Titlebar
theme.titlebar_size = dpi(22)

theme.titlebar_close_button_focus = theme.dir .. "/icons/titlebar/close_focus.svg"
theme.titlebar_close_button_normal = theme.dir .. "/icons/titlebar/close_normal.svg"
theme.titlebar_close_button_focus_hover = theme.dir .. "/icons/titlebar/close_focus_hover.svg"
theme.titlebar_close_button_normal_hover = theme.dir .. "/icons/titlebar/close_normal_hover.svg"

theme.titlebar_ontop_button_focus_active = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active = theme.dir .. "/icons/titlebar/maximized_focus_active.svg"
theme.titlebar_maximized_button_normal_active = theme.dir .. "/icons/titlebar/maximized_normal_active.svg"
theme.titlebar_maximized_button_focus_inactive = theme.dir .. "/icons/titlebar/maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.svg"

theme.titlebar_maximized_button_focus_active_hover = theme.dir .. "/icons/titlebar/maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_active_hover = theme.dir .. "/icons/titlebar/maximized_normal_active_hover.svg"
theme.titlebar_maximized_button_focus_inactive_hover = theme.dir .. "/icons/titlebar/maximized_focus_active.svg"
theme.titlebar_maximized_button_normal_inactive_hover = theme.dir .. "/icons/titlebar/maximized_normal_active_hover.svg"

theme.titlebar_minimize_button_focus_active = theme.dir .. "/icons/titlebar/minimize_active.svg"
theme.titlebar_minimize_button_normal_active = theme.dir .. "/icons/titlebar/minimize_inactive.svg"
theme.titlebar_minimize_button_focus_inactive = theme.dir .. "/icons/titlebar/minimize_active.svg"
theme.titlebar_minimize_button_normal_inactive = theme.dir .. "/icons/titlebar/minimize_inactive.svg"

theme.titlebar_fg = colors.fg
theme.titlebar_bg = colors.bg

theme.notification_font = "MesloLGS NF 8.5"
--theme.notification_width = dpi(100)
theme.notification_max_width = dpi(350)
theme.notification_min_width = dpi(100)
theme.notification_bg = colors.bg .. "aa"
theme.notification_fg = colors.fg
theme.notification_spacing = dpi(30)
theme.notification_margin = dpi(20)
theme.notification_icon_resize_strategy = 'center'
theme.notification_icon_size = dpi(32)

theme.hotkeys_bg = colors.bg0_s .. "cc"
theme.hotkeys_group_margin = dpi(20)
theme.hotkeys_fg = colors.fg
theme.hotkeys_modifiers_fg = colors.fg3

theme.icon_theme = "Nord-Icon"

theme.tag_preview_widget_border_radius = dpi(4)          -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = dpi(4)          -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity = 0.8              -- Opacity of each client
theme.tag_preview_client_bg = colors.bg0_s             -- The bg color of each client
theme.tag_preview_client_border_color = colors.light_aqua   -- The border color of each client
theme.tag_preview_client_border_width = dpi(2)           -- The border width of each client
theme.tag_preview_widget_bg = colors.bg0             -- The bg color of the widget
theme.tag_preview_widget_border_color = colors.bg2   -- The border color of the widget
theme.tag_preview_widget_border_width = dpi(3)           -- The border width of the widget
theme.tag_preview_widget_margin = dpi(3)                 -- The margin of the widget

theme.task_preview_widget_border_radius = dpi(4)          -- Border radius of the widget (With AA)
theme.task_preview_widget_bg = colors.bg0             -- The bg color of the widget
theme.task_preview_widget_border_color = colors.bg2   -- The border color of the widget
theme.task_preview_widget_border_width = dpi(3)           -- The border width of the widget
theme.task_preview_widget_margin = dpi(5)

theme.tabbar_ontop  = true
theme.tabbar_radius = dpi(5)                -- border radius of the tabbar
theme.tabbar_style = "modern"         -- style of the tabbar ("default", "boxes" or "modern")
theme.tabbar_font = "MesloLGS NF 8"          -- font of the tabbar
theme.tabbar_size = theme.titlebar_size + dpi(6)                 -- size of the tabbar
theme.tabbar_position = "bottom"          -- position of the tabbar
theme.tabbar_bg_normal = colors.bg0_h     -- background color of the focused client on the tabbar
theme.tabbar_fg_normal = colors.fg     -- foreground color of the focused client on the tabbar
theme.tabbar_bg_focus  = colors.bg     -- background color of unfocused clients on the tabbar
theme.tabbar_fg_focus  = colors.fg     -- foreground color of unfocused clients on the tabbar
theme.tabbar_disable = false           -- disable the tab bar entirely

theme.wallpaper = ""
theme.dock_size = dpi(30)


local function load_random_wallpaper()
    local wallpaper = gears.filesystem.get_random_file_from_dir(theme.dir .. "/wallpapers/",
        {"jpg", "png"}, true)
    theme.wallpaper = wallpaper
end

load_random_wallpaper()

return theme

-- vim: tabstop=4 shiftwidth=4
