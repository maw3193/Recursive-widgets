--[[
TEXT EDIT: Text box that tracks cursor position to insert and remove characters.
--]]

local wtextbox = require "lib/recursivewidgets/wtextbox"

local textedit = setmetatable({}, wtextbox)

textedit.template = {
	cursorpos = 0,
	cursor = "|",
	redrawcanvas = function(self)
		self.canvas:renderTo(function()
			local beforestring = self.text:sub(1,self.cursorpos)
			local afterstring = self.text:sub(self.cursorpos + 1)
			love.graphics.setBackgroundColor(0,0,0,0)
			love.graphics.clear()
			love.graphics.printf(beforestring..self.cursor..afterstring, 0, -self.scrollpos, self.width, self.align)
		end)
	end,

}
setmetatable(textedit.template, wtextbox.template)
textedit.template.__index = textedit.template

return textedit
