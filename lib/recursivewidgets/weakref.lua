local weakref = {}

weakref.template = {
	__mode = "v",
	name = "weakref",
	value = nil,
}
weakref.template.__index = weakref.template

weakref.new = function(self, v)
	local temp = setmetatable({}, self.template)
	temp.value = v
	return temp
end

return weakref
