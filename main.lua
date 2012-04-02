local widgets = require "lib/recursivewidgets/widgets"
local panels = require "lib/recursivewidgets/panel"
local frame = require "lib/recursivewidgets/frame"
local gui
function love.load()
	gui = widgets.newgui()
	widgets:addto(gui)
	frame:addto(gui, {halign="center", valign = "center", widgets={widgets:new()}})
end

function love.update(dt)
	gui:update(dt)
end

function love.draw()
	gui:draw()
end

function love.keypressed(key)
	gui:keypressed(key)
end

function love.keyreleased(key)
	gui:keyreleased(key)
end

function love.mousepressed(x, y, button)
	gui:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	gui:mousereleased(x, y, button)
end
