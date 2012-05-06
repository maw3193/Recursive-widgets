--[[
Button: Widget that can have a label and icon widget, and responds to clicks
--]]
local widgets = require "lib/recursivewidgets/widgets"
local wicon = require "lib/recursivewidgets/wicon"
local icon = require "lib/recursivewidgets/icon"
local colour = require "lib/recursivewidgets/colour"
local weakref = require "lib/recursivewidgets/weakref"

local button = setmetatable({}, widgets)

button.closeparent = function(self, x, y, button)
	if button == "l" then
		local parent = self:getParent()
		local parentowner = parent:getParent()
		
		if parentowner.focussed == parent then
			parentowner.focussed = nil
		end
		
		for i, v in ipairs(parentowner.widgets) do
			if v == parent then
				table.remove(parentowner.widgets, i)
			end
		end
	end
	return false
end

button.resizegrab = function(self, x, y, button)
	print("calling resizegrab")
	self.grabbed = true
	self.grabbedx = x
	self.grabbedy = y
	self.grabbedw = self:getParent().width
	self.grabbedh = self:getParent().height
	return true
end
button.resizerelease = function(self, x, y, button)
	print("calling resizerelease")
	--[[
	local dx = x - self.grabbedx
	local dy = y - self.grabbedy
	local par = self:getParent()
	if par.stretch then
		dx, dy = par:checkresizewidth(dx, dy)
		par:resize(dx, dy)
	end
	--]]	
	self.grabbed = false
	return true
end

button.resizeupdate = function(self, dt)
	if self.grabbed then
		
		local dx = love.mouse.getX() - self.grabbedx
		local dy = love.mouse.getY() - self.grabbedy
		--local newwidth = self.grabbedw + dx
		--local newheight = self.grabbedh + dy
		local par = self:getParent()
		if par.stretch then
			dx, dy = par:checkresizewidth(dx, dy)
			par:resize(dx, dy)
		end
		
		self.grabbedx = self.grabbedx + dx
		self.grabbedy = self.grabbedy + dy
		
	end
end

button.template = {
	is_a = "button",
	iconr = 0,
	iconpath = nil,
	iconscale = 1,
	bordercol = colour.white,
	bgcol = colour:transparent("white"),
	draw = function(self)
		widgets.template.draw(self)
		if self.wicon then
			self.wicon:draw()
		end
		if self.wlabel then
			self.wlabel:draw()
		end
	end,
	keypressed = function(self, key, unicode)
		self:userkeypressed(key, unicode)
		return true
	end,
	keyreleased = function(self, key, unicode)
		self:userkeyreleased(key, unicode)
		return true
	end,
	mousepressed = function(self, x, y, button)
		self:usermousepressed(x, y, button)
		return true
	end,
	mousereleased = function(self, x, y, button)
		self:usermouserepeased(x, y, button)
		return true
	end,
}
button.template.__index = button.template
setmetatable(button.template, widgets.template)

button.new = function(self, data)
	local temp = widgets.new(self, data)
	if temp.iconpath and not temp.wicon then
		temp.wicon = wicon:new{
			iconr = temp.iconr,
			iconpath = temp.iconpath,
			iconscale = temp.iconscale,
			iconcol = temp.iconcol
		}
	end
	if temp.wicon then
		temp.wicon.parent = weakref:new(temp)
	end
	if temp.wlabel then
		temp.wlabel.parent = weakref:new(temp)
	end
	
	return temp
end

return button
