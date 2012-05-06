--[[
TEXT PANEL: A panel that contains a text box and buttons to control it
--]]
local panel = require "lib/recursivewidgets/wpanel"
local button = require "lib/recursivewidgets/wbutton"
local wicon = require "lib/recursivewidgets/wicon"
local textbox = require "lib/recursivewidgets/wtextbox"

local textpanel = setmetatable({}, panel)
textpanel.__index = textpanel

textpanel.template = {
	is_a = "text panel",
	text = nil,
	buttonsize = 16,
	upiconpath = "art/arrow.png",
	upiconrot = -math.pi/2,
	downiconpath = "art/arrow.png",
	downiconrot = math.pi/2,
}
setmetatable(textpanel.template, panel.template)
textpanel.template.__index = textpanel.template

textpanel.new = function(self, data)
	if not data.panels then
		data.panels = {}
	end
	
	if not data.text then
		data.text = ""	
	end
	local temp = panel.new(self, data)
	local tb = textbox:addto(temp, {
		width = temp.width - temp.buttonsize,
		minwidth = temp.minwidth - temp.buttonsize,
		height = temp.height,
		minheight = temp.minheight,
		text = temp.text,
		stretch = true,
	})
	button:addto(temp, {
		is_a = "scroll up button",
		halign = "right",
		width = temp.buttonsize,
		height = temp.buttonsize,
		iconr = temp.upiconrot,
		iconpath = temp.upiconpath,
		target = tb,
		mousepressed = function(self, x, y, button)
			if button == "l" then
				self.target:scroll(-10)
			end
		end,
	})
	button:addto(temp, {
		is_a = "scroll down button",
		halign = "right",
		valign = "bottom",
		width = temp.buttonsize,
		height = temp.buttonsize,
		iconr = temp.downiconrot,
		iconpath = temp.downiconpath,
		target = tb,
		mousepressed = function(self, x, y, button)
			if button == "l" then
				self.target:scroll(10)
			end
		end,
	})
	return temp
end

return textpanel
