-- Reusable functions

local string = string

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
