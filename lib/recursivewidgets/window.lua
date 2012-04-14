--[[
A frame that comes with a bunch of widgets by default.
It receives all the same data as frame, but also:
style = {close = {data}, stretch = {data}}
icon = {data},
title = "string"
--]]
local widgets = require "lib/recursivewidgets/widgets"
local frame = require "lib/recursivewidgets/wframe"
local label = require "lib/recursivewidgets/wlabel"
local icon = require "lib/recursivewidgets/wicon"
local panel = require "lib/recursivewidgets/wpanel"
local button = require "lib/recursivewidgets/wbutton"
local windowstyle = require "lib/recursivewidgets/windowstyle"

local window = setmetatable({}, frame)
window.__index = window

local titledefaults = {
	text = "Default title text",
	textalign = "center",
	halign = "center",
	valign = "top",
}

window.new = function(self, data)
	if not data.widgets then
		data.widgets = {}
	end
	local title = label:new(titledefaults)
	table.insert(data.widgets, title)
	if data.title then
		title.text = data.title
	end
	data.title = nil
	if data.icon then
		table.insert(data.widgets, icon:new(data.icon))
	end
	data.icon = nil

	local style
	if data.style then
		style = data.style
	else
		style = windowstyle
	end
	local closebutton = button:new{mousereleased = button.closeparent, halign = "right", wicon=icon:new(style.close)}
	closebutton.width = closebutton.wicon.width
	closebutton.height = closebutton.wicon.height
	table.insert(data.widgets, closebutton)

	local stretchbutton = button:new{mousepressed = button.resizegrab, mousereleased = button.resizerelease, update = button.resizeupdate,
	                                 halign = "right", valign = "bottom", wicon = icon:new(style.stretch)}
	stretchbutton.width = stretchbutton.wicon.width
	stretchbutton.height = stretchbutton.wicon.height
	table.insert(data.widgets, stretchbutton)
	
	if data.style then
		data.style = nil
	end
	
	local temp = frame:new(data)
	title.width = temp.width - 32
	return temp
end

return window
