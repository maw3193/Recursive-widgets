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
local newtext = "One bee, two bees, three bees, four bees, five bees, six bees, seven bees, eight bees, nine bees, ten bees, eleven bees, twelve bees, thirteen bees, fourteen bees, fifteen bees, sixteen bees, seventeen bees, eighteen bees, nineteen bees, twenty bees, twenty one bees, twenty two bees, twenty three bees, twenty four bees, twenty five bees!"

local function addwindowfunc()
	window:addto(gui, {halign="center", valign="center", windowiconpath="art/upicon.png", stretch=true, width=64, minwidth=64, minheight=64, height=64, widgets={
	                  	textpanel:new{text=newtext, posy=16, stretch=true, width=48, height=48, minwidth=48,
	                  	            minheight=48, bgcol=colour.black},
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
