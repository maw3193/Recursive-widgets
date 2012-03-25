local widgets = {}
local colour = require("lib/recursivewidgets/colour")

widgets.guitemplate = {
	width = 0,
	height = 0,
	widgets = nil, --creation function makes its new table
	focussed = nil, --points to the widget currently in focus
	resized = function(self)
		self.width = love.graphics:getWidth()
		self.height = love.graphics:getHeight()
	end,
	update = function(self, dt)
		for k,v in pairs(self.widgets) do
			v:update(dt)
		end
	end,
	draw = function(self)
		for k,v in pairs(self.widgets) do
			v:draw()
		end
	end,
	keypressed = function(self, key)
	
	end,
	keyreleased = function(self, key)
	
	end,
	mousepressed = function(self, x, y, button)
	
	end,
	mousereleased = function(self, x, y, button)
	
	end,
	getX = function(self)
		return 0
	end,
	getY = function(self)
		return 0
	end,
}
widgets.guitemplate.__index = widgets.guitemplate


function widgets.newgui(self, screenx, screeny)
	local temp = setmetatable({}, widgets.guitemplate)
	temp:resized()
	temp.widgets = {}
	
	return temp
end


widgets.template = {
	posx = 0,
	posy = 0,
	width = 64,
	height = 64,
	parent = nil,
	bordercol = colour.red,
	bgcol = colour:transparent("blue"),
	update = function(self, dt)
	
	end,
	draw = function(self)
		local x = self:getX()
		local y = self:getY()
		local w = x + self.width
		local h = y + self.height

		love.graphics.setColor(self.bgcol)
		love.graphics.rectangle("fill", x, y, w, h)

		love.graphics.setColor(self.bordercol)
		love.graphics.rectangle("line", x, y, w, h)

	end,
	keypressed = function(self, key)
	
	end,
	keyreleased = function(self, key)
	
	end,
	mousepressed = function(self, x, y, button)
	
	end,
	mousereleased = function(self, x, y, button)
	
	end,
	getX = function(self)
		if self.parent then
			return self.parent:getX() + self.posx
		else
			return self.posx
		end
	end,
	getY = function(self)
		if self.parent then
			return self.parent:getY() + self.posy
		else
			return self.posy
		end
	end,
	testpoint = function(self, x, y, button)
		if x >= self:getX()
			and x <= self:getX() + self.width
			and y >= self:getY()
			and y <= self:getY() + self.height
		then 
			return true
		else
			return false
		end
	end,
}
widgets.template.__index = widgets.template

widgets.new = function(self, data)
	local temp = setmetatable({}, self.template)
	if data then
		for k,v in pairs(data) do
			temp[k] = v
		end
	end
	return temp
end

widgets.addto = function(self, parent, data)
	if not data then
		data = {}
	end
	if parent then
		data[parent] = parent
	end
	local temp = self:new(data)
	table.insert(parent.widgets, temp)
end

return widgets
