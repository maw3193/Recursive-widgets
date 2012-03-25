local colour = {
	red = {255,0,0,255},
	green = {0,255,0,255},
	blue = {0,0,255,255},
	black = {0,0,0,255},
	white = {255,255,255,255},
	deftransparency = 127,
	transparent = function(self, name, level)
		local alpha
		if level == nil then
			level = self.deftransparency
		end
		local col = self[name]
		return {col[1], col[2], col[3], level}
		
	end,
}

return colour
