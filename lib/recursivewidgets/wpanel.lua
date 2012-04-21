--[[
Panel is a widget that contains other widgets
--]]
local colour = require "lib/recursivewidgets/colour"
local widgets = require "lib/recursivewidgets/widgets"
local weakref = require "lib/recursivewidgets/weakref"
local util = require "lib/recursivewidgets/util"
local panel = setmetatable({}, widgets)
panel.__index = panel
panel.template = {
	width = 128,
	height = 128,
	widgets = nil,
	focussed = nil,
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
	end,
	keypressed = function(self, key, unicode)
		if self.focussed then
			self.focussed:keypressed(key, unicode)
		end
	end,
	keyreleased = function(self, key, unicode)
		if self.focussed then
			self.focussed:keyreleased(key, unicode)
		end
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
		return true
	end,
	mousereleased = function(self, x, y, button)
		if self.focussed then
			self.focussed:mousereleased(x, y, button)
		end
		return true
	end,
}

panel.template.__index = panel.template

setmetatable(panel.template, widgets.template)


panel.new = function(self, data)
	if data.widgets == nil then
		data.widgets = {}
	end
	local temp = widgets.new(self, data)
	for k,v in pairs (temp.widgets) do
		v.parent = weakref:new(temp)
	end
	return temp
end

return panel
