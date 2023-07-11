local ComponentManager = class("ComponentManager")

function ComponentManager:ctor(owner)
	self._Owner = owner
	self._ComponentsList = {}
end

function ComponentManager:initComponents(coms)
	if not coms or not next(coms) then
		return
	end

	for _,comCfg in ipairs(coms) do
		local comClass = TWRequire(comCfg.name)
		if comClass then
			local com = comClass.new(self._Owner)
			com:init(comCfg)
			self._ComponentsList[comCfg.name] = com
		end
	end

	for _,com in pairs(self._ComponentsList) do
		com:postInit()
	end
end

function ComponentManager:isScriptCompnent(name)
	return self._ComponentsList[name] ~= nil
end

function ComponentManager:sendMessageToComponent(name,callbackName,...)
	if self._ComponentsList[name] then
		return self._ComponentsList[name]:onMessage(callbackName,...)
	end
end

function ComponentManager:releaseAllComs()
	for _,com in pairs(self._ComponentsList) do
		com:release()
	end
	self._ComponentsList = {}
end

function ComponentManager:update(dt)
	for _,com in pairs(self._ComponentsList) do
		com:update(dt)
	end
end

function ComponentManager:render()
	for _,com in pairs(self._ComponentsList) do
		com:render()
	end
end

function ComponentManager:release()
	self:releaseAllComs()
end

return ComponentManager