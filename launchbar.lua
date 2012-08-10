local wibox = wibox
local io = io
local string = string
local table = table
local awful = awful
local print = print
local ipairs = ipairs
local tonumber = tonumber

module("launchbar")

function find_icon(icon_name, icon_dirs)
    if string.sub(icon_name, 1, 1) == '/' then
        if awful.util.file_readable(icon_name) then
            return icon_name
        else
            return nil
        end
    end
    if icon_dirs then
        for i, v in ipairs(icon_dirs) do
            print(i, v)
            if awful.util.file_readable(v .. "/" .. icon_name .. ".png") then
                return v .. "/" .. icon_name .. ".png"
            end
        end
    end
    return nil
end

function getValue(t, key)
    _, _, res = string.find(t, key .. " *= *([^%c]+)%c")
    return res
end

function new()
    launchbar = wibox.layout.fixed.horizontal()
    filedir = "~/.config/awesome/launchbar/"
    local items = {}
    local files = io.popen("ls " .. filedir .. "*.desktop")

    for f in files:lines() do
        local t = io.open(f):read("*a")
        table.insert(items, 
            { image = find_icon(getValue(t, "Icon"), { "/usr/share/icons/hicolor/22x22/apps" }),
              command = getValue(t, "Exec"),
              tooltip = getValue(t, "Name"),
              position = tonumber(getValue(t, "Position")) or 255 })
    end

    for i,v in ipairs(items[1]) do print(i,v) end
    table.sort(items, function(a, b) return a.position < b.position end)


    for i = 1, table.getn(items) do
        launchbar:add(awful.widget.launcher(items[i]))
    end

    return launchbar
end
