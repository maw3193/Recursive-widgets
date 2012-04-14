local colour = require "lib/recursivewidgets/colour"
local windowstyle = {
	close = {
		iconpath = "art/cross.png",
		iconr = 0,
		iconscale = 1,
		iconcol = colour.red,	
	},
	stretch = {
		iconpath = "art/arrow.png",
		iconr = math.pi / 4,
		iconscale = 1,
		iconcol = colour.white,	
	},	
}

return windowstyle
