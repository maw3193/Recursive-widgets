--[[
Label: Prints text to screen with alignment
--]]
local widgets = require "lib/recursivewidgets/widgets"
local label = setmetatable({}, widgets)

label.template = {
	text = "",
	textalign = "left",
	draw = function(self)
		widgets.template.draw(self)
		love.graphics.printf(self.text, self:getScreenX(), self:getScreenY(), self.width, self.textalign)
	end,
}
label.template.__index = label.template
setmetatable(label.template, widgets.template)

--label.new is functionally identical to widgets.new, but can do things with text and textalign

return label
