local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi   = require("beautiful.xresources").apply_dpi
local math = require("math")
local cairo = require("lgi").cairo
local inspect = require("inspect")

local snap = require("utils/dock_snap")

local naughty = require("naughty")

local bling = require("bling")
local rubato = require("rubato")

local modkey = "Mod4"

Dock = {
}

local function rounded_shape(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, dpi(5))
end

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

local function get_direction(position)
    if position == "left" or position == "right" then
        return "vertical"
    elseif position == "top" or position == "bottom" then
        return "horizontal"
    end
end

local function gen_placement(w)
    local maximize = (w.position == "right" or w.position == "left") and
        "maximize_vertically" or "maximize_horizontally"
    local placement = awful.placement[w.position] + awful.placement[maximize]
    --local placement = awful.placement[w.position]
    return placement
end

local function getTaskListDefault(w)
    return {
        --screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = awful.util.tasklist_buttons,
        style = {
            fg_normal = beautiful.dock_fg_normal,
            bg_normal = beautiful.dock_bg_normal,
            bg_focus = beautiful.dock_bg_focus,
            bg_minimize = beautiful.dock_bg_minimize,
            shape = rounded_shape,
            --shape_border_color = beautiful.dock_border_color,
            --shape_border_width = dpi(1),
        },
        --layout = {
            --layout = wibox.layout.flex[direction]
        --},
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            resize = true,
                            widget = wibox.widget.imagebox,
                        },
                        margins = dpi(5),
                        widget  = wibox.container.margin,
                    },
                    halign = "center",
                    valign = "center",
                    layout = wibox.container.place,
                },
                forced_height = w.size - dpi(10),
                margins = dpi(1),
                widget = wibox.container.margin
            },
            id     = 'background_role',
            bg = beautiful.tasklist_bg_focus,
            widget = wibox.container.background,
            create_callback = function(self, task, index, object)
                self:connect_signal("mouse::enter", function()
                    awesome.emit_signal("bling::task_preview::visibility", s,
                                        true, task)
                end)
            end
        },
    }
end

local function update_input_shape(w)
    if not w.visible then
        return
    end
    local wb = w.wibox
    local h = find_widget_in_wibox(wb, w.tasklist)
    local x, y, width, height = 0, 0, wb.width, wb.height
    if width == 0 or height == 0 then
        return
    end
    if h == nil then
        --naughty.notify { text = "NIL"}
    else
        x, y, width, height = h:get_matrix_to_device()
                         :transform_rectangle(0, 0, h:get_size())
    end

    if width == 0 then width = wb.width end
    if height == 0 then height = wb.height end

    local img = cairo.ImageSurface(cairo.Format.A1, wb.width, wb.height)
    local cr = cairo.Context(img)
    if w.position == "left" or w.position == "right" then
        cr:translate(0, (wb.height / 2) - (height / 2) )
    else
        cr:translate((wb.width / 2) - (width / 2), 0 )
    end

    gears.shape.rectangle(cr, width, height)

    cr:fill()
    wb.shape_input = img._native
    img:finish()
end

local function build_dock(w, tasklist, position)
    local direction = get_direction(position)

    w.wibox:setup { layout = wibox.layout.align.vertical}
    local function rect_none(cr, width, height)
        gears.shape.rectangle(cr, 0, 0)
    end
    w.wibox.shape = rect_none
    w.wibox = nil

    w.wibox = wibox {
        type = "dock",
        bg = "#00000000",
        ontop = true,
        screen = w.screen,
    }
    w.wibox.visible = true

    if direction == "horizontal" then
        w.wibox.height = w.size
    else
        w.wibox.width = w.size
    end

    w.wibox:setup {
        expand = "none",
        layout = wibox.layout.align[direction],
        nil,
        {
            {
                {
                    {
                        layout = wibox.layout.fixed[direction],
                        tasklist,
                    },
                    widget  = wibox.container.margin,
                },
				widget  = wibox.container.margin,
				margins = dpi(5),
            },
			id = "background",
			bg = "#282828",
			widget = wibox.container.background,
			shape = rounded_shape,
        },
        nil,
    }

    w.wibox:connect_signal("mouse::enter", function()
        update_input_shape(w)
    end)

    w:toggle(true)
end
-- Remember to separate widget from wibox, like w = {position, size, widget = wibox}

function Dock:move(coords)
    local placement = gen_placement(self)
    placement(self.wibox, {
            attach = true,
            update_workarea = false,
            margins = self.margins,
            offset = coords,
            honor_workarea = true,
        })
end

function Dock:set_position(position)
    self.position = position or "bottom"
    local direction = get_direction(position)

    self.tasklist = awful.widget.tasklist(
            gears.table.join(
                getTaskListDefault(self),
                {
                    screen = self.wibox.screen,
                    layout = {
                        layout = wibox.layout.flex[direction]
                    },
                }
            )
        )
    self.tasklist:connect_signal("mouse::leave", function()
        self.task_preview.visible = false
    end)

    build_dock(self, self.tasklist, position)

    local placement = gen_placement(self)

    placement(self.wibox, {
            attach = true,
            update_workarea = false,
            margins = self.margins,
            honor_workarea = true,
    })

    self.task_preview.placement_fn = function(c)
        awful.placement.next_to(c, {
                mode = "geometry",
                margins = dpi(10),
                preferred_positions = {
                    "left", "right", "top", "bottom"
                },
                preferred_anchors = "middle",
                geometry = self.wibox,
        })
    end
    --snap.show_placeholder({x=0, y=0, width=200, height=200})

    self.wibox:buttons( gears.table.join(
            awful.button({ modkey }, 1, function(c)
                local wb = self.wibox
                local argy = {}
                local req       = "request::geometry"
                local context = "mouse.move"
                local mode = "after"

                mousegrabber.run(function(_mouse)
                    local geo = setmetatable(
                        mode == "live" and awful.placement.under_mouse(wb, argy) or wb:geometry(),
                        {__index=argy}
                    )
                    local t_geo = setmetatable(
                        mode == "live" and self.task_preview.placement_fn(self.task_preview) or self.task_preview:geometry(),
                        {__index={}}
                    )

                    snap.detect_areasnap(wb, 64)

                    -- Quit when the button is released
                    -- Return true to continue, else, below is executed
                    for _,v in pairs(_mouse.buttons) do
                        if v then return true end
                    end

                    snap.apply_areasnap(self)

                end, "fleur")
            end)
        )
    )
end

function Dock:toggle(set)
    --self.wibox.visible = true

	local value = {}
	local size = self.size + self.margins

	local function change_pos(pos)
		if self.position == "top" then value.y = -pos
		elseif self.position == "bottom" then value.y = pos
		elseif self.position == "left" then value.x = -pos
		elseif self.position == "right" then value.x = pos
		end
	end

	local timed = rubato.timed {
		intro = 0,
		prop_intro = true,
		duration = 0.25,
		rate = 60,
		easing = rubato.quadratic,
		subscribed = function(pos)
			change_pos(pos)
			self:move(value)
		end
	}
	local timed_intro = rubato.timed {
		intro = 0,
		prop_intro = true,
		duration = 0.25,
		rate = 60,
		easing = rubato.quadratic,
		subscribed = function(pos)
			change_pos(size - pos)
			self:move(value)
		end
	}

    if not set then
        self.visible = not self.visible
    end

    if self.visible then
		timed_intro.target = size
        --self:move({x = 0, y = 0})
        self.wibox.input_passthrough = false
		--self.wibox.opacity = 1
		--self.wibox.visible = true;
    else
		timed.target = size
        --self:move(value)
        self.wibox.input_passthrough = true
		--self.wibox.opacity = 0
		--self.wibox.visible = false;
    end
end


function Dock:new(args)

    local w = {}
    w.screen = args.screen

    w.size = args.size or dpi(35)
    w.margins = args.margins or dpi(5)
    w.position = args.position or "bottom"

    w.wibox = wibox {
        type = "dock",
        bg = "#00000000",
        ontop = true,
        screen = w.screen,
    }

    w.wibox.visible = true
    w.visible = true

    local task_preview = bling.widget.task_preview.enable {
            height = 200,
            width = 300,
            placement_fn = function(c)
                awful.placement.next_to(c, {
                        mode = "geometry",
                        margins = dpi(5),
                        preferred_positions = {
                            "left", "right", "top", "bottom"
                        },
                        preferred_anchors = "middle",
                        geometry = w.wibox,
                })
            end
        }


    w.task_preview = task_preview

    local function u()
        update_input_shape(w)
    end

    client.connect_signal("focus", u)
    tag.connect_signal("request::layout", u)
    tag.connect_signal("request::layouts", u)

    self.__index = self
    setmetatable(w, self)

    w:set_position(w.position)

    return w
end

return Dock
-- vim: tabstop=4 shiftwidth=4
