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
	text = nil,
	buttonsize = 32,
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
		height = temp.height,
		text = temp.text,
	})
	button:addto(temp, {
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
