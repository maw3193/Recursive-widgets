--[[
Frame is a widget that contains other widgets and can be dragged around
--]]
local widgets = require "lib/recursivewidgets/widgets"
local colour = require "lib/recursivewidgets/colour"
local weakref = require "lib/recursivewidgets/weakref"
local util = require "lib/recursivewidgets/util"
local frame = setmetatable({}, widgets)
frame.__index = frame

frame.template = {
	is_a = "frame",
	width = 128,
	height = 128,
	minwidth = 128,
	minheight = 128,
	widgets = nil,
	focussed = nil,
	grabbed = false,
	grabbedx = 0,
	grabbedy = 0,
	bordercol = colour.white,
	bgcol = colour:transparent("white"),
	draw = function(self)
		widgets.template.draw(self)
		for k,v in pairs(self.widgets) do
			v:draw()
		end
	end,
	update = function(self, dt)
		for k,v in pairs(self.widgets) do
			v:update(dt)
		end
		if self.grabbed then
			local x = love.mouse:getX()
			local y = love.mouse:getY()
			local newx = self:getParent():getLocalX(x) - self.grabbedx
			local newy = self:getParent():getLocalY(y) - self.grabbedy
			if newx + self.width > self:getParent().width then
				newx = self:getParent().width - self.width
			elseif newx < 0 then
				newx = 0
			end
			if newy + self.height > self:getParent().height then
				newy = self:getParent().height - self.height
			elseif newy < 0 then
				newy = 0
			end
			self.posx = newx
			self.posy = newy
		end
		self:userupdate(dt)
	end,
	keypressed = function(self, key, unicode)
		if self.focussed then
			self.focussed:keypressed(key, unicode)
		end
		self:userkeypressed(key, unicode)
	end,
	keyreleased = function(self, key, unicode)
		if self.focussed then
			self.focussed:keyreleased(key, unicode)
		end
		self:userkeyreleased(key, unicode)
	end,
	mousepressed = function(self, x, y, button)
		for _,v in util.ripairs (self.widgets) do
			if v:testpoint(x, y) then
				if v:mousepressed(x, y, button) then
					self.focussed = v
					return true
				end
			end
		end
		self.grabbed = true
		self.grabbedx = self:getLocalX(x)
		self.grabbedy = self:getLocalY(y)
		self:usermousepressed(x, y, button)
		return true
	end,
	mousereleased = function(self, x, y, button)
		if self.focussed then
			self.focussed:mousereleased(x, y, button)
		end
		self.grabbed = false
		self:usermousereleased(x, y, button)
		return true
	end,
}
frame.template.__index = frame.template
setmetatable(frame.template, widgets.template)

frame.new = function(self, data)
	if not data then
		data = {}
	end
	if data.widgets == nil then
		data.widgets = {}
	end
	local temp = widgets.new(self, data)
	for k,v in pairs (temp.widgets) do
		v.parent = weakref:new(temp)
	end
	if temp.halign == "center" then
		temp.posx = temp:getParent().width / 2 - temp.width / 2 + temp.posx
		temp.halign = "left"
		print("Center-aligned frame has been converted to left-aligned")
	elseif temp.halign == "right" then
		temp.posx = temp:getParent().width - temp.width + temp.posx
		temp.halign = "left"
		print("Right-aligned frame has been converted to left-aligned")
	end
	if temp.valign == "center" then
		temp.posy = temp.posy + temp:getParent().height / 2 - temp.height / 2
		temp.valign = "top"
		print("Center-aligned frame has been converted to top-aligned")
	elseif temp.valign == "bottom" then
		temp.posy = temp.posy + temp:getParent().height - temp.height
		temp.valign = "top"
		print("Bottom-aligned frame has been converted to top-aligned")
	end
	return temp
end

return frame
