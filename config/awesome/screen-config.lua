local gears         = require("gears")
local awful         = require("awful")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local dpi           = require("beautiful.xresources").apply_dpi
local widgets       = require("widgets")
local naughty       = require("naughty")
local inspect       = require("inspect")

-- Function to call on screen startup
local function at_screen_connect(s)

    -- If wallpaper is a function, call it with the screen
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Promptbox
    local promptbox_w = awful.widget.prompt {
        screen = s,
        bg = "#00000000",
        bg_cursor = beautiful.colors.fg1,
    }

    local keyboard_layout_w = awful.widget.keyboardlayout {}
    local date_w = widgets.base:new {
        icon = { markup = "  ", bg = beautiful.colors.light_red },
        inner_widget = wibox.widget.textclock("%a %b %d"),
        bg_normal = "#00000000",
        bg_active = beautiful.colors.light_red,
    }
    local time_w = widgets.base:new {
        icon = { markup = "  ", bg = beautiful.colors.light_orange },
        inner_widget = wibox.widget.textclock("%H:%M"),
        bg_normal = "#00000000",
        bg_active = beautiful.colors.light_orange,
    }
    local systray_w = wibox.widget.systray()
    local hostname_w = widgets.base:new {
        icon = { markup = "  ", bg = beautiful.colors.bg3 },
        inner_widget = wibox.widget.textbox(awful.util.hostname),
        bg_normal = "#00000000",
        bg_active = beautiful.colors.bg3,
    }
    local power_w = widgets.base:new {
        markup = "  ",
        --markup = "  ",
        bg_normal = beautiful.colors.purple,
        bg_active = beautiful.colors.light_purple,
        margins = { left = dpi(2), right = dpi(2) },
    }
    local power_w_tooltip = awful.tooltip {
        objects = { power_w.widget },
        bg = beautiful.colors.bg1,
        fg = beautiful.colors.fg,
    }
    power_w.widget:connect_signal("mouse::enter", function()
        power_w_tooltip.text = "Power menu"
    end)

    local battery_w = widgets.battery:new {
        widget = widgets.base:new {
            icon = { markup = "  ", bg = beautiful.colors.light_green },
            markup = " 0% ",
            bg_normal = "#00000000",
            bg_active = beautiful.colors.light_green,
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

            if self.perc >= 30 then self.widget.bg_active = beautiful.colors.green
            elseif self.perc >= 15 then self.widget.bg_active = beautiful.colors.yellow
            else self.widget.bg_active = beautiful.colors.red end

            local text_value = self.perc .. "% "

            self.widget:get_children_by_id("text")[1]:set_markup(text_value)
            self.widget:get_children_by_id("icon")[1]:set_markup(bat_header)
        end
    }
    battery_w.widget:buttons(gears.table.join(
            awful.button({ }, 1, function() battery_w:full_update() end)
        ))
    local battery_w_tooltip = awful.tooltip {
        objects = { battery_w.widget },
        bg = beautiful.colors.bg1,
        fg = beautiful.colors.fg,
    }
    battery_w.widget:connect_signal("mouse::enter", function()
        battery_w_tooltip.text = battery_w.status or "N/A"
    end)

    local layoutbox_w = awful.widget.layoutbox(s)

    layoutbox_w:buttons(gears.table.join(
            awful.button({ }, 1, function() awful.layout.inc(1) end),
            awful.button({ }, 2, function() awful.layout.set(awful.layout.layouts[1]) end),
            awful.button({ }, 3, function() awful.layout.inc(-1) end),
            awful.button({ }, 4, function() awful.layout.inc(1) end),
            awful.button({ }, 5, function() awful.layout.inc(-1) end)
        ))

    local taglist_w = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = awful.util.taglist_buttons,
        style = {
            shape = gears.shape.circle,
        },
        layout = {
            spacing = 2,
            spacing_widget = {
                color = "#00000000",
                shape = gears.shape.rectangle,
                widget = wibox.widget.separator,
            },
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id = "text",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = dpi(4),
                right = dpi(4),
                widget = wibox.container.margin,
            },
            id = "background_role",
            widget = wibox.container.background,
            inactive_bg = "#00000000",
            hover_bg = beautiful.taglist_bg_hover,

            create_callback = function(self, tag, index, objects)
                self:get_children_by_id("text")[1].markup = "<b>  </b>"
                self:connect_signal("mouse::enter", function()
                    self.bg = self.hover_bg
                    --if #tag:clients() > 0 then
                        ---- BLING: Update the widget with the new tag
                        --awesome.emit_signal("bling::tag_preview::update", tag)
                        ---- BLING: Show the widget
                        --awesome.emit_signal("bling::tag_preview::visibility", s, true)
                    --else
                        --awesome.emit_signal("bling::tag_preview::visibility", s, false)
                    --end
                end)
                self:connect_signal("mouse::leave", function()
                    if tag.selected then self.bg = beautiful.taglist_bg_focus
                    elseif #tag:clients() > 0 then self.bg = beautiful.taglist_bg_occupied
                    else self.bg = self.inactive_bg end

                    --awesome.emit_signal("bling::tag_preview::visibility", s, false)
                end)
                self:update_callback(tag, index, objects)
            end,
---@diagnostic disable-next-line: unused-local
            update_callback = function(self, tag, index, objects)
                if tag.selected then
                    self:get_children_by_id("text")[1].markup = "<b>  </b>"
                    self.bg = beautiful.taglist_bg_focus
                elseif #tag:clients() > 0 then
                    self:get_children_by_id("text")[1].markup = "<b>  </b>"
                    self.bg = beautiful.taglist_bg_occupied
                else
                    self:get_children_by_id("text")[1].markup = "<span color='#a89984'><b>  </b></span>"
                    self.bg = self.inactive_bg
                end
            end
        }
    }
    local tasklist_w = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = awful.util.tasklist_buttons,
        layout = {
            spacing = 10,
            layout = wibox.layout.flex.horizontal,
        },
        widget_template = {
            {
                {
                    {
                        {
                            id = "icon_role",
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget = wibox.container.margin,
                    },
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = 10,
                right = 10,
                widget = wibox.container.margin,
            },
            id = "background_role",
            bg = beautiful.tasklist_bg_focus,
            widget = wibox.container.background,

--@diagnostic disable-next-line: unused-local
            create_callback = function(self, task, index, objects)
                self:connect_signal("mouse::enter", function()
                    if client.focus == task then self.bg = beautiful.tasklist_bg_hover
                    elseif task.minimized then self.bg = beautiful.tasklist_bg_hover
                    else self.bg = beautiful.tasklist_bg_hover end
                end)
                self:connect_signal("mouse::leave", function()
                    if client.focus == task then self.bg = beautiful.tasklist_bg_focus
                    elseif task.minimized then self.bg = beautiful.tasklist_bg_minimize
                    else self.bg = beautiful.tasklist_bg_normal end
                end)
            end,
--@diagnostic disable-next-line: unused-local
            update_callback = function(self, task, index, objects)
                local text_widget = self:get_children_by_id("text_role")[1]
                if task.minimized then
                    text_widget.visible = false
                else
                    text_widget.visible = true
                end
            end
        }
    }

    local wibox_bar = awful.wibar {
        screen = s,
        position = "top",
        type = "desktop",
        height = beautiful.wibar_height,
        ontop = true,
        bg = beautiful.wibar_bg
    }

    wibox_bar:setup {
        widget = wibox.container.margin,
        left = dpi(8),
        right = dpi(8),
        top = dpi(6),
        bottom = dpi(6),
        {
            layout = wibox.layout.align.horizontal,
            expand = "outside",
            { -- Left widget
                {
                    hostname_w.widget,
                    layoutbox_w,
                    promptbox_w,

                    spacing = dpi(5),
                    layout = wibox.layout.fixed.horizontal,
                },
                shape = gears.shape.rectangle,
                widget = wibox.container.background,
            },
            {
                {
                    taglist_w,
                    layout = wibox.layout.fixed.horizontal,
                },
                left = dpi(8),
                right = dpi(8),
                widget = wibox.container.margin,
            },
            {
                {
                    layout = wibox.layout.align.horizontal,
                    nil,
                    nil,
                    {
                        systray_w,
                        keyboard_layout_w,
                        battery_w.widget,
                        date_w.widget,
                        time_w.widget,
                        power_w.widget,

                        spacing = dpi(5),
                        layout = wibox.layout.fixed.horizontal,
                    },
                },
                shape = gears.shape.rectangle,
                widget = wibox.container.background,
            }
        }
    }

    local function change_wibox_visibility(client)
        if client.screen == s then
            wibox_bar.ontop = not client.fullscreen
        end
    end

    client.connect_signal("property::fullscreen", change_wibox_visibility)
    client.connect_signal("focus", change_wibox_visibility)

    s.promptbox = promptbox_w
    s.wibox = wibox_bar
end

return {
    at_screen_connect = at_screen_connect
}

-- vim: shiftwidth=4: tabstop=4