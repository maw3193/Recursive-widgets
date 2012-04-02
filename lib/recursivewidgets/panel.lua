--[[
Panel is a widget that contains other widgets
--]]
local colour = require "lib/recursivewidgets/colour"
local widgets = require "lib/recursivewidgets/widgets"
local panel = setmetatable({}, widgets)
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
		v.parent = temp
	end
	return temp
end

return panel
