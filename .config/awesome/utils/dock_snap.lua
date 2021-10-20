local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local cairo = require("lgi").cairo

local naughty = require("naughty")

local snappy = {}

local placeholder_w = nil

function snappy.show_placeholder(geo)
    if not geo then
        if placeholder_w then
            placeholder_w.visible = false
        end
        return
    end

    placeholder_w = placeholder_w or wibox {
        ontop = true,
        bg    = gears.color(beautiful.snap_bg or beautiful.bg_urgent or "#ff0000"),
    }

    placeholder_w:geometry(geo)

    local img = cairo.ImageSurface(cairo.Format.A1, geo.width, geo.height)
    local cr = cairo.Context(img)

    cr:set_operator(cairo.Operator.CLEAR)
    cr:set_source_rgba(0,0,0,1)
    cr:paint()
    cr:set_operator(cairo.Operator.SOURCE)
    cr:set_source_rgba(1,1,1,1)

    local line_width = beautiful.snap_border_width or 5
    cr:set_line_width(beautiful.xresources.apply_dpi(line_width))

    local f = beautiful.snap_shape or function()
        cr:translate(line_width,line_width)
        gears.shape.rounded_rect(cr,geo.width-2*line_width,geo.height-2*line_width, 10)
    end

    f(cr, geo.width, geo.height)

    cr:stroke()

    placeholder_w.shape_bounding = img._native
    img:finish()

    placeholder_w.visible = true
end

local function detect_screen_edges(c, snap)
    local coords = mouse.coords()

    local sg = c.screen.geometry

    local v, h = nil, nil

    if math.abs(coords.x) <= snap + sg.x and coords.x >= sg.x then
        h = "left"
    elseif math.abs((sg.x + sg.width) - coords.x) <= snap then
        h = "right"
    end

    if math.abs(coords.y) <= snap + sg.y and coords.y >= sg.y then
        v = "top"
    elseif math.abs((sg.y + sg.height) - coords.y) <= snap then
        v = "bottom"
    end

    return v, h
end

local function build_placement(snap, axis)
    return awful.placement.scale
        + awful.placement[snap]
        + (
            axis and awful.placement["maximize_"..axis] or nil
          )
end

local current_snap, current_axis = nil, nil

function snappy.detect_areasnap(c, distance)
    local old_snap = current_snap
    local v, h = detect_screen_edges(c, distance)

    current_snap = v or h or nil

    if old_snap == current_snap then return end

    current_axis = ( v and "horizontally" )
        or ( h and "vertically" )
        or nil

    -- Show the expected geometry outline
    snappy.show_placeholder(
        current_snap and build_placement(current_snap, current_axis)(c, {
            to_percent     = 0.2,
            honor_workarea = true,
            pretend        = true
        }) or nil
    )

end

function snappy.apply_areasnap(w)
    if not current_snap then return end

    placeholder_w.visible = false

    return w:set_position(current_snap)

end

return snappy
