--[[
Icon widget, holds and prints an icon.
--]]
local widgets = require "lib/recursivewidgets/widgets"
local icon = require "lib/recursivewidgets/icon"
local colour = require "lib/recursivewidgets/colour"
local wicon = setmetatable({}, widgets)

wicon.template = {
	is_a = "icon widget",
	iconr = 0,
	iconscale = 1,
	icon = nil,
	iconcol = colour.white,
	iconpath = nil,
	draw = function(self)
		widgets.template.draw(self)
		love.graphics.setColor(self.iconcol)
		self.icon:draw(self:getScreenX() + self.icon.ox, self:getScreenY() + self.icon.oy, self.iconr, self.iconscale)
	end,
}
wicon.template.__index = wicon.template
setmetatable(wicon.template, widgets.template)

wicon.new = function(self, data) --Accepts iconpath, ox, oy and iconcol in data
	if not data.iconpath then
		print("Error: Attempting to create icon widget without an icon path")
	else
		data.icon = icon:new(data.iconpath, data.ox, data.oy)
		if not data.width then
			data.width = data.icon.image:getWidth()
		end
		if not data.height then
			data.height = data.icon.image:getHeight()
		end
	end
	local temp = widgets.new(self, data)
	return temp
end

return wicon
