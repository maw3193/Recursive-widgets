local colour = require "lib/recursivewidgets/colour"
local icon = require "lib/recursivewidgets/icon"
local weakref = require "lib/recursivewidgets/weakref"
local util = require "lib/recursivewidgets/util"
local widgets = {}

widgets.guitemplate = {
	is_a = "gui",
	width = 0,
	height = 0,
	widgets = nil, --creation function makes its new table
	focussed = nil, --points to the widget currently in focus
	resized = function(self)
		local w = self.width
		local h = self.height
		self.width = love.graphics:getWidth()
		self.height = love.graphics:getHeight()
		local dx = self.width - w
		local dy = self.height - h
		if self.widgets then
			for k,v in pairs(self.widgets) do
				v:resize(dx, dy)
			end
		end
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
	keypressed = function(self, key, unicode)
		if self.focussed then
			self.focussed:keypressed(key, unicode)
		end
	end,
	keyreleased = function(self, key, unicode)
		if self.focussed then
			self.focussed:keyreleased(key, unicode)
		end
	end,
	mousepressed = function(self, x, y, button)
		for _,v in util.ripairs (self.widgets) do
			if v:testpoint(x, y) then
				if v:mousepressed(x, y, button) then
					self.focussed = v
					return true
				end
			end
		end
		return false
	end,
	mousereleased = function(self, x, y, button)
		if self.focussed then
			if self.focussed:mousereleased(x, y, button) then
				return true
				
			end
		end
		return false
	end,
	getLocalX = function(self, x)
		x = x or 0
		return x
	end,
	getLocalY = function(self, y)
		y = y or 0
		return y
	end,
	getScreenX = function(self)
		return 0
	end,
	getScreenY = function(self)
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
	is_a = "widget",
	posx = 0,
	posy = 0,
	halign = "left",
	valign = "top",
	width = 64,
	height = 64,
	minwidth = 64,
	minheight = 64,
	parent = nil, --REPLACE WITH A WEAK REFERENCE OBJECT THING
	bordercol = nil,
	bgcol = nil,
	stretch = false,
	update = function(self, dt)
		self:userupdate(dt)
	end,
	userupdate = function(self, dt)
	end,
	
	draw = function(self)
		local x = self:getScreenX()
		local y = self:getScreenY()
		local w = self.width
		local h = self.height
		if self.bgcol then
			love.graphics.setColor(self.bgcol)
			love.graphics.rectangle("fill", x, y, w, h)
		end
		if self.bordercol then
			love.graphics.setColor(self.bordercol)
			love.graphics.rectangle("line", x, y, w, h)
		end
		self:userdraw()
	end,
	userdraw = function(self)
	end,
	
	keypressed = function(self, key, unicode)
		self:userkeypressed(key, unicode)
	end,
	userkeypressed = function(self, key, unicode)
	end,
	
	keyreleased = function(self, key, unicode)
		self:userkeyreleased(self, key, uncode)
	end,
	userkeyreleased = function(self, key, unicode)
	end,
	
	mousepressed = function(self, x, y, button)
		self:usermousepressed(x, y, button)
	end,
	usermousepressed = function(self, x, y, button)
	end,
	
	mousereleased = function(self, x, y, button)
		self:usermousereleased(x, y, button)
	end,
	usermousereleased = function(self, x, y, button)
	end,
	
	getParent = function(self)
		return self.parent.value
	end,
	getScreenX = function(self, x)
		x = x or 0
		if self.halign == "right" then
			return self:getParent():getScreenX() + self:getParent().width - self.width + self.posx + x
		elseif self.halign == "center" then
			return self:getParent():getScreenX() + self:getParent().width / 2 - self.width / 2 + self.posx + x
		else
			return self:getParent():getScreenX() + self.posx + x
		end
	end,
	getScreenY = function(self, y)
		y = y or 0
		if self.valign == "bottom" then
			return self:getParent():getScreenY() + self:getParent().height - self.height + self.posy + y
		elseif self.valign == "center" then
			return self:getParent():getScreenY() + self:getParent().height / 2 - self.height / 2 + self.posy + y
		else
			return self:getParent():getScreenY() + self.posy + y
		end
	end,
	getLocalX = function(self, x)
		x = x or 0
		return x - self.posx + self:getParent():getLocalX()
	end,
	getLocalY = function(self, y)
		y = y or 0
		return y - self.posy + self:getParent():getLocalY()
	end,
	testpoint = function(self, x, y)
		if x >= self:getScreenX()
			and x <= self:getScreenX() + self.width
			and y >= self:getScreenY()
			and y <= self:getScreenY() + self.height
		then 
			return true
		else
			return false
		end
	end,
	checkresizewidth = function(self, dx, dy)
		if self.stretch and (dx ~= 0 or dy ~= 0) then
			local newwidth = self.width + dx
			local newdx = dx
			--[[
			print(self.is_a..": dx="..dx..", dy="..dy..", width="..self.width..
			       ", height="..self.height..", minwidth="..
			       self.minwidth..", minheight="..self.minheight)
			--]]
			if newwidth < self.minwidth then
				newdx = self.minwidth - self.width
				--print("shrinking resize width from "..dx.." to "..newdx)
			end
			local newheight = self.height + dy
			local newdy = dy
			if newheight < self.minheight then
				newdy = self.minheight - self.height
				--print("shrinking resize height from "..dy.." to "..newdy)
			end
			if self.widgets then
				for k,v in pairs(self.widgets) do
					newdx, newdy = v:checkresizewidth(newdx, newdy)
				end
			end
			dx = newdx
			dy = newdy
		end
		return dx, dy
		--TODO: Use  this function somewhere!
	end,
	resize = function(self, dx, dy)
		if self.stretch and dx ~= 0 and dy ~= 0 then
			local neww = self.width + dx
			local newh = self.height + dy
			local passdx
			local passdy
			if neww < self.minwidth then
				self.width = self.minwidth
				passdx = 0
			else
				passdx = dx
				self.width = neww
			end
			if newh < self.minheight then
				self.height = self.minheight
				passdy = 0
			else
				passdy = dy
				self.height = newh
			end

			if self.widgets 
			--and passthrough 
			then
				for k,v in pairs(self.widgets) do
					v:resize(passdx, passdy)
				end
			end
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
		data.parent = weakref:new(parent)
	end
	local temp = self:new(data)
	table.insert(parent.widgets, temp)
	return temp
end
widgets.__index = widgets
return widgets
