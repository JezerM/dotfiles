local setmetatable = setmetatable
local wibox = require("wibox")
local gears = require("gears")
local layout = require("awful.layout")
--local screen = require("awful.screen")
local tooltip = require("awful.tooltip")
local beautiful = require("beautiful")
local surface = require("gears.surface")

local Powerline = require("utils/powerline")

local capi = { screen = screen, tag = tag }

Layoutbox = {
    normal_bg = "",
    active_bg = "",
    font = "",
    shape = gears.shape.powerline,
    screen = 1,
    mt = {},
}

local boxes = nil

local function get_screen(s)
    return s and capi.screen[s]
end

local function update(w, screen)
    local screen = get_screen(screen)
    local name = layout.getname(layout.get(screen))
    w._layoutbox_tooltip:set_text(name or "[no name]")

    local img = surface.load_silently(beautiful["layout_" .. name], false)

    w:get_children_by_id('imagebox')[1].image = img
    w:get_children_by_id("textbox")[1].text = img and "" or name
end

local function update_from_tag(t)
    local screen = get_screen(t.screen)
    local w = boxes[screen]
    if w then
        update(w, screen)
    end
end


function Layoutbox.new(o)
    o = o or {}
    local screen = get_screen(o.screen or 1)

    if boxes == nil then
        boxes = setmetatable({}, { __mode = "kv" })
        capi.tag.connect_signal("property::selected", update_from_tag)
        capi.tag.connect_signal("property::layout", update_from_tag)
        capi.tag.connect_signal("property::screen", function()
            for s, w in pairs(boxes) do
                if s.valid then
                    update(w, s)
                end
            end
        end)
        Layoutbox.boxes = boxes
    end

    local w = boxes[screen]
    if not w then
        w = Powerline:new({
            inner_widget = {
                    {
                        id     = "imagebox",
                        resize = true,
                        widget = wibox.widget.imagebox
                    },
                    {
                        id     = "textbox",
                        widget = wibox.widget.textbox
                    },
                    layout = wibox.layout.fixed.horizontal
            },
            shape = o.shape or gears.shape.powerline,
            normal_bg = o.normal_bg or "#505050",
            active_bg = o.active_bg,
            font = o.font,
        }).widget

        w._layoutbox_tooltip = tooltip {objects = {w}, delay_show = 1}

        update(w, screen)
        boxes[screen] = w
    end

    return w
end

function Layoutbox.mt:__call(...)
    return Layoutbox.new(...)
end

return setmetatable(Layoutbox, Layoutbox.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
