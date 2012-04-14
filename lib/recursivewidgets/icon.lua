--[[
An icon is a wrapper class for simple images loaded from files.
--]]
local icon = {} --the class it returns
icon.store = nil --the table where icons are stored, can be set & get.

icon.getstore = function(self) --returns the current store
	return self.store
end

icon.setstore = function(self, store) --sets the current store
	if store then
		self.store = store
	end
end

icon.template = {
	ox = 0,
	oy = 0,
	image = nil,
	draw = function(self, x, y, r, scale)
		love.graphics.draw(self.image, x, y, r, scale, scale, self.ox, self.oy)
	end,
}
icon.template.__index = icon.template

icon.new = function(self, path) --Creates and stores the image as an icon, if it already exists, returns that instead.
	if self.store[path] then
		return self.store[path]
	else
		local temp = setmetatable({}, self.template)

		temp.image = love.graphics.newImage(path)
		temp.ox = temp.image:getWidth() / 2
		temp.oy = temp.image:getHeight() / 2
		self.store[path] = temp
		return temp
	end
end

return icon
