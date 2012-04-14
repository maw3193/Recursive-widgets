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
	recalculate = function(self)
		local font = love.graphics.getFont()
		local _, wraplines = font:getWrap(self.text, self.width)
		local fontheight = font:getHeight()
		self.maxscroll = wraplines * fontheight - self.height + 1
	end,
	isvalidchar = function(self, charuni)
		if charuni > 31 and charuni < 127 then
			return true
		end
	end,
	addchar = function(self, char)
		local beforestring = self.text:sub(1, self.cursorpos)
		local afterstring = self.text:sub(self.cursorpos + 1)
		self.text = beforestring..char..afterstring
	end,
}
setmetatable(textedit.template, wtextbox.template)
textedit.template.__index = textedit.template

return textedit
