local IComponent = class("IComponent")

function IComponent:ctor(owner)
	self._Owner = owner
	self._Name = ""
end

function IComponent:_init(data)

end

function IComponent:init(data)
	self._Name = data.name
	self:_init(data)
end

function IComponent:getName()
	return self._Name
end

function IComponent:postInit()

end

function IComponent:_update(dt)

end

function IComponent:render()

end

function IComponent:onMessage(callbackName,...)
	local callback = self[callbackName]
	if callback then
		return callback(self,...)
	end
end

function IComponent:update(dt)
	self:_update(dt)
end

function IComponent:_release()

end

function IComponent:release()
	self:_release()
end

return IComponent