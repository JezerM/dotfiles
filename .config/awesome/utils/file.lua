local awful = require("awful")
local gears = require("gears")

Filesystem = {}

function Filesystem.scandir(directory, callback)
    awful.spawn.easy_async("ls -1 " .. directory, function(out, err, reason, code)
        local lines = gears.string.split(out, "\n")
        callback(lines)
    end)
end

function Filesystem.scandir_line(directory, callback)
    awful.spawn.with_line_callback("ls -1 " .. directory, {
            stdout = function(line)
                callback(line)
            end
        })
end

function Filesystem.read_first_line(path)
    local file, first = io.open(path, "rb"), nil
    if file then
        first = file:read("*l")
        file:close()
    end
    return first
end

return Filesystem
