--[[
A frame that comes with a bunch of widgets by default.
--]]
local widgets = require "lib/recursivewidgets/widgets"
local frame = require "lib/recursivewidgets/wframe"
local label = require "lib/recursivewidgets/wlabel"
local icon = require "lib/recursivewidgets/wicon"
local panel = require "lib/recursivewidgets/wpanel"
local button = require "lib/recursivewidgets/wbutton"
local windowstyle = require "lib/recursivewidgets/windowstyle"
local colour = require "lib/recursivewidgets/colour"

local window = setmetatable({}, frame)
window.__index = window

window.template = {
	titletext = "Default title text",
	titletextalign = "center", 
	titlehalign = "center",
	titlevalign = "top",
	
	closeiconpath = "art/cross.png",
	closeiconr = 0,
	closeiconscale = 1,
	closeiconcol = colour.red,
	
	stretchiconpath = "art/arrow.png",
	stretchiconr = math.pi/4,
	stretchiconscale = 1,
	stretchiconcol = colour.white,
	
	windowiconpath = nil,
	windowiconr = 0,
	windowiconscale = 1,
	windowiconcol = colour.white,
	
}
window.template.__index = window.template
setmetatable(window.template, frame.template)

window.new = function(self, data)
	if not data then
		data = {}
	end
	local temp = frame.new(self, data)
	local closebutton = button:addto(temp, {mousereleased=button.closeparent, halign="right", iconpath=temp.closeiconpath,
	                                        iconr=temp.closeiconr, iconscale=temp.closeiconscale,
	                                        iconcol=temp.closeiconcol})
	closebutton.width = closebutton.wicon.width
	closebutton.height = closebutton.wicon.height
	local stretchbutton = button:addto(temp, {mousereleased=button.resizerelease, mousepressed=button.resizegrab,
	                                          update=button.resizeupdate, halign="right",
	                                          valign="bottom", iconpath=temp.stretchiconpath, iconr=temp.stretchiconr, 
	                                          iconscale=temp.stretchiconscale, iconcol=temp.stretchiconcol})
	stretchbutton.width = stretchbutton.wicon.width
	stretchbutton.height = stretchbutton.wicon.height
	label:addto(temp, {text=temp.titletext, textalign=temp.titletextalign, halign=temp.titlehalign, valign=temp.titlevalign,
	                   width=temp.width-32})
	if temp.windowiconpath then
		icon:addto(temp, {iconpath = temp.windowiconpath, iconr=temp.windowiconr, iconscale=temp.windowiconscale,
		                  iconcol=temp.windowiconcol})
	end
	return temp
end

return window
