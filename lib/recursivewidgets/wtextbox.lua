--[[
Textbox: Stores formatted text on a canvas
--]]
local widget = require "lib/recursivewidgets/widgets"
local colour = require "lib/recursivewidgets/colour"

local textbox = setmetatable({}, widget)
textbox.__index = textbox
textbox.template = {
	canvas = nil,
	text = nil,
	align = "left",
	bordercol = colour.white,
	--bgcol = colour:transparent("black"),
	scrollpos = 0,
	maxscroll = nil,
	makecanvas = function(self)
		self.canvas = love.graphics.newCanvas(self.width, self.height)
		self.canvas:setWrap("clamp", "clamp")
		self:recalculate()
		self:redrawcanvas()
	end,
	recalculate = function(self)
		local font = love.graphics.getFont()
		local _, wraplines = font:getWrap(self.text, self.width)
		local fontheight = font:getHeight()
		self.maxscroll = wraplines * fontheight - self.height
		
	end,
	redrawcanvas = function(self)
		self.canvas:renderTo(function()
			love.graphics.setBackgroundColor(0,0,0,0)
			love.graphics.clear()
			love.graphics.printf(self.text, 0, -self.scrollpos, self.width, self.align)
		end)
	end,
	draw = function(self)
		widget.template.draw(self)
		love.graphics.draw(self.canvas, self:getScreenX(), self:getScreenY())
	end,
	scroll = function(self, amount)
		local newtarget = self.scrollpos + amount
		if newtarget < 0 then
			self.scrollpos = 0
		elseif newtarget > self.maxscroll then
			self.scrollpos = self.maxscroll
		else
			self.scrollpos = newtarget
		end
		self:redrawcanvas()
	end,
	resetscroll = function(self)
		self.scrollpos = 0
		self:redrawcanvas()
	end,
	resize = function(self, dx, dy)
		widget.template.resize(self, dx, dy)
		self:makecanvas()
	end,
}
textbox.template.__index = textbox.template
setmetatable(textbox.template, widget.template)

textbox.new = function(self, data)
	local temp = widget.new(self, data)
	temp:makecanvas()
	return temp
end

return textbox
