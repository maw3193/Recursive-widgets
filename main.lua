local widgets = require "lib/recursivewidgets/widgets"
local panel = require "lib/recursivewidgets/wpanel"
local frame = require "lib/recursivewidgets/wframe"
local icon = require "lib/recursivewidgets/icon"
local wicon = require "lib/recursivewidgets/wicon"
local label = require "lib/recursivewidgets/wlabel"
local colour = require "lib/recursivewidgets/colour"
local button = require "lib/recursivewidgets/wbutton"
local window = require "lib/recursivewidgets/window"
local textbox = require "lib/recursivewidgets/wtextbox"
local textedit = require "lib/recursivewidgets/wtextedit"
local textpanel = require "lib/recursivewidgets/wtextpanel"

local gui
local font
local newtext = "Argh bees everywhere! Run for your lives! Don't open that crate! It's full of bees! Worse than bees, spike-hornets! With bayonets and lasers! But wait, there's more! With the bee 'honey', we can do anything! We can reverse death itself!"

local function addwindowfunc()
	window:addto(gui, {halign="center", valign="center", windowiconpath="art/upicon.png", stretch=true, width=256, minwidth=256, minheight=256, height=256, widgets={
	                  	textpanel:new{text=newtext, posy=16, stretch=true, width=240, height=240, minwidth=240,
	                  	            minheight=240, bgcol=colour.black},
	                  }
	})
	return true
end

function love.load()
	font = love.graphics.newFont()
	love.graphics.setFont(font)
	love.keyboard.setKeyRepeat(0.1, 0.05)
	gui = widgets.newgui()
	gui.icons = {}
	icon:setstore(gui.icons)
	button:addto(gui, {mousereleased = addwindowfunc, wlabel=label:new{text="Make a new window"}})
	textedit:addto(gui, {text="ABCDE", valign="center", width=128, height=128, cursorpos=3})
	textpanel:addto(gui, {text=newtext, halign="center", valign="center"})
end

function love.update(dt)
	gui:update(dt)
end

function love.draw()
	gui:draw()
end

function love.keypressed(key, unicode)
	gui:keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
	gui:keyreleased(key, unicode)
end

function love.mousepressed(x, y, button)
	gui:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	gui:mousereleased(x, y, button)
end
