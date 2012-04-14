--[[
TEXT EDIT: Text box that tracks cursor position to insert and remove characters.
--]]

local wtextbox = require "lib/recursivewidgets/wtextbox"

local textedit = setmetatable({}, wtextbox)

textedit.template = {
	cursorpos = 1,
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
	addchar = function(self, unichar)
		local beforestring = self.text:sub(1, self.cursorpos + 0)
		local afterstring = self.text:sub(self.cursorpos + 1)
		self.text = beforestring..string.char(unichar)..afterstring
		self:movecursor(1)
	end,
	remchar = function(self, offset)
		local beforepos = self.cursorpos + offset - 1
		local afterpos = beforepos + 2
		local beforestring = self.text:sub(0, beforepos)
		local afterstring = self.text:sub(afterpos)
		self.text = beforestring..afterstring
		self:movecursor(offset - 1)
	end,
	movecursor = function(self, amount)
		local cursordest = self.cursorpos + amount
		if cursordest < 0 then
			self.cursorpos = 0
		elseif cursordest > self.text:len() + 1 then
			self.cursorpos = self.text:len()
		else
			self.cursorpos = cursordest
		end
		self:recalculate()
		self:redrawcanvas()
	end,
	mousepressed = function(self, x, y, button)
		if button == "l" then
			return true
		end
	end,
	keypressed = function(self, key, unicode)
		if self:isvalidchar(unicode) then
			self:addchar(unicode)
		elseif key == "return" and (love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")) then
			self:addchar(string.byte"\n")
		elseif key == "backspace" then
			self:remchar(-0)
		elseif key == "delete" then
			self:remchar(1)
		elseif key == "left" then
			self:movecursor(-1)
		elseif key == "right" then
			self:movecursor(1)
		end
	end,
}
setmetatable(textedit.template, wtextbox.template)
textedit.template.__index = textedit.template

return textedit
