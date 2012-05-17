-- Reusable functions

local string = string
local tonumber = tonumber
local awful = awful

module("utils")

function gradient(min, max, val)
	if (val > max) then val = max end
	if (val < min) then val = min end

	local v = val - min
	local d = (max - min) * 0.5
	local red, green

	if (v <= d) then
		red = (255 * v) / d
		green = 255
	else
		red = 255
		green = 255 - (255 * (v-d)) / (max - min - d)
	end

	return string.format("#%02x%02x00", red, green)
end

function run_once(prg, times)
	if not prg then
		do return nil end
	end
	times = times or 1
	count_prog = 
	tonumber(awful.util.pread('ps aux | grep "' .. prg .. '" | grep -v grep | wc -l'))
	if times > count_prog then
		for l = count_prog, times-1 do
			awful.util.spawn_with_shell(prg)
		end
	end
end
