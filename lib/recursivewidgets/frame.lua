--[[
Frame is a widget that contains other widgets and can be dragged around
--]]
local widgets = require "lib/recursivewidgets/widgets"
local colour = require "lib/recursivewidgets/colour"
local frame = setmetatable({}, widgets)

frame.template = {
	width = 128,
	height = 128,
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
			local newx = self.parent:getLocalX(x) - self.grabbedx
			local newy = self.parent:getLocalY(y) - self.grabbedy
			if newx + self.width > self.parent.width then
				newx = self.parent.width - self.width
			elseif newx < 0 then
				newx = 0
			end
			if newy + self.height > self.parent.height then
				newy = self.parent.height - self.height
			elseif newy < 0 then
				newy = 0
			end
			self.posx = newx
			self.posy = newy
			--print("new pos="..self.posx..","..self.posy)
		end
	end,
	keypressed = function(self, key)
		if self.focussed then
			self.focussed:keypressed(key)
		end
	end,
	keyreleased = function(self, key)
		if self.focussed then
			self.focussed:keyreleased(key)
		end
	end,
	mousepressed = function(self, x, y, button)
		for _,v in ipairs (self.widgets) do
			if v:testpoint(x, y) then
				if v:mousepressed(x, y, button) then
					self.focussed = v
					return true
				end
			end
		end
		self.grabbed = true
		print("screen pos="..x..","..y)
		print("local  pos="..self:getLocalX(x)..","..self:getLocalY(y))
		self.grabbedx = self:getLocalX(x)
		self.grabbedy = self:getLocalY(y)
		return true
	end,
	mousereleased = function(self, x, y, button)
		if self.focussed then
			if self.focussed:testpoint(x, y) then
				if self.focussed:mousereleased(x, y, button) then
					return true
				end
			end
		end
		self.grabbed = false
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
		v.parent = temp
	end
	if temp.halign == "center" then
		temp.posx = temp.parent.width / 2 - temp.width / 2 + temp.posx
		temp.halign = "left"
		print("Center-aligned frame has been converted to left-aligned")
	elseif temp.halign == "right" then
		temp.posx = temp.parent.width - temp.width + temp.posx
		temp.halign = "left"
		print("Right-aligned frame has been converted to left-aligned")
	end
	if temp.valign == "center" then
		temp.posy = temp.posy + temp.parent.height / 2 - temp.height / 2
		temp.valign = "top"
		print("Center-aligned frame has been converted to top-aligned")
	elseif temp.valign == "bottom" then
		temp.posy = temp.posy + temp.parent.height - temp.height
		temp.valign = "top"
		print("Bottom-aligned frame has been converted to top-aligned")
	end
	return temp
end

return frame
