local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi   = require("beautiful.xresources").apply_dpi
local math = require("math")
local cairo = require("lgi").cairo
local inspect = require("inspect")

local naughty = require("naughty")

local bling = require("bling")

local function find_widget_in_wibox(wb, widget)
  local function find_widget_in_hierarchy(h, widget)
    if h:get_widget() == widget then
      return h
    end
    local result
    for _, ch in ipairs(h:get_children()) do
      result = result or find_widget_in_hierarchy(ch, widget)
    end
    return result
  end
  local h = wb._drawable._widget_hierarchy
  return h and find_widget_in_hierarchy(h, widget)
end

Dock = {
}

local function gen_placement(w)
    local maximize = (w.position == "right" or w.position == "left") and
        "maximize_vertically" or "maximize_horizontally"
    local placement = awful.placement[w.position] + awful.placement[maximize]
    --local placement = awful.placement[w.position]
    return placement
end

function Dock.move(w, coords)
    local placement = gen_placement(w)
    placement(w, {
            attach = true,
            update_workarea = false,
            margins = w.margins,
            offset = coords
        })
end

function Dock.set_position(w, position)
    w.position = position

    local placement = gen_placement(w)

    placement(w, {
            attach = true,
            update_workarea = false,
            margins = w.margins,
    })

    w.task_preview.placement_fn = function(c)
        awful.placement[position](c, {
                margins = w.size + dpi(10)
            })
    end
end

function Dock.toggle(w)
    local hidden = w.hidden
    w.visible = true
    --w.visible = not w.visible

    local value = {}
    local size = w.size + w.margins

    if w.position == "top" then value.y = -size
    elseif w.position == "bottom" then value.y = size
    elseif w.position == "left" then value.x = -size
    elseif w.position == "right" then value.x = size
    end

    if hidden then
        w.move(w, value)
        w.opacity = 0
        w.hidden = false
    else
        w.move(w, {x = 0, y = 0})
        w.opacity = 1
        w.hidden = true
    end
end

function Dock.new(screen)

    local dock_size = dpi(35)
    local margins = dpi(5)
    local position = "right"

    local dock_width = nil
    local dock_height = nil

    local direction = nil

    if position == "left" or position == "right" then
        dock_width = dock_size
        direction = "vertical"
    else
        dock_height = dock_size
        direction = "horizontal"
    end

    local task_preview = bling.widget.task_preview.enable {
            height = 200,                 -- The height of the popup
            width = 300,                  -- The width of the popup
            placement_fn = function(c)    -- Place the widget using awful.placement (this overrides x & y)
                awful.placement[position](c, {
                        margins = dock_size + dpi(10),
                })
            end
        }

    local mytasklist = awful.widget.tasklist {
        screen = screen,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = awful.util.tasklist_buttons,
        style = {
            fg_normal = beautiful.dock_fg_normal,
            bg_normal = beautiful.dock_bg_normal,
            bg_focus = beautiful.dock_bg_focus,
            bg_minimize = beautiful.dock_bg_minimize,
            shape = gears.shape.rounded_rect,
            shape_border_color = beautiful.dock_border_color,
            shape_border_width = dpi(2),
        },
        layout = {
            layout = wibox.layout.flex[direction]
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            resize = true,
                            forced_height = dpi(20),
                            widget = wibox.widget.imagebox,
                        },
                        margins = 4,
                        widget  = wibox.container.margin,
                    },
                    halign = "center",
                    valign = "center",
                    layout = wibox.container.place,
                },
                left = 2, right  = 2,
                top  = 3, bottom = 3,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            bg = beautiful.tasklist_bg_focus,
            widget = wibox.container.background,
            create_callback = function(self, task, index, object)
                self:connect_signal("mouse::enter", function()
                    awesome.emit_signal("bling::task_preview::visibility", screen,
                                        true, task)
                end)
            end
        },
    }
    mytasklist:connect_signal("mouse::leave", function()
        awesome.emit_signal("bling::task_preview::visibility", screen,
                            false, mytasklist)
    end)

    local w = wibox {
        type = "dock",
        width = dock_width,
        height = dock_height,
        bg = "#00000000",
        ontop = true,
        screen = screen,
    }

    w:setup {
        expand = "none",
        layout = wibox.layout.align[direction],
        nil,
        {
            {
                {
                    {
                        layout = wibox.layout.fixed[direction],
                        mytasklist,
                    },
                    widget  = wibox.container.margin,
                },
                id = "background",
                bg = "#00000000",
                widget = wibox.container.background,
            },
            widget  = wibox.container.margin,
        },
        nil,
    }

    local function update_input_shape()
        local h = find_widget_in_wibox(w, mytasklist)
        local x, y, width, height = h:get_matrix_to_device()
                             :transform_rectangle(0, 0, h:get_size())

        local img = cairo.ImageSurface(cairo.Format.A1, w.width, w.height)
        local cr = cairo.Context(img)

        cr:translate(0, (w.height / 2) - (height / 2) )
        gears.shape.rectangle(cr, width, height)

        cr:fill()
        w.shape_input = img._native
        img:finish()
    end

    w:connect_signal("mouse::enter", function()
        update_input_shape()
    end)

    w.move = Dock.move
    w.toggle = Dock.toggle
    w.size = dock_size
    w.direction = direction
    w.margins = margins
    w.visible = true
    w.hidden = false

    w.tasklist = mytasklist
    w.task_preview = task_preview

    Dock.set_position(w, position)

    print(inspect(mytasklist))

    return w
end

return Dock
-- vim: tabstop=4 shiftwidth=4
