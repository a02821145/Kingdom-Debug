local sActorManager   = class("sActorManager",_GModel.IManager)
local configManager  = TWRequire("ConfigDataManager")
local Actor = TWRequire("Actor")

function sActorManager:_Init()
	self._actors = {}
	self._typeActors = {}
	self._cfgMaps = {}

	self:initMSg()
end

function sActorManager:initMSg()

	self:addListener(MessageDef_GameLogic.MSG_CreateScriptActor,self.onCreateActor)
	
	RegisterEventListener(EventType.ScriptEvent_Actor,handler(self,self.onCmdEvent))
end

function sActorManager:onCmdEvent(data)
	local cmdStr = data.funcName
	local func 	 = self[cmdStr]
	if func then
		func(self,data)
	end
end

function sActorManager:onCreateActor(data)
	local cfgId = tonumber(data.cfgId)
	local actorId = tonumber(data.id)
	local actorType = tonumber(data.type)
	local cfgData = configManager:getConfigById(cfgId)
	assert(cfgData, "failed to get cfg data cfgId ="..cfgId)

	local actor = Actor.new(data,cfgData)
	self._actors[actorId] = actor
	self._typeActors[actorType] = self._typeActors[actorType] or {}
	local actorMaps = self._typeActors[actorType]
	actorMaps[actorId] = actor
	self._typeActors[actorType] = actorMaps
	self._cfgMaps = self._cfgMaps or {}
	self._cfgMaps[cfgId] = self._cfgMaps[cfgId] == nil and 1 or (self._cfgMaps[cfgId] + 1)

	if cfgId == 1001 then
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_Refresh_CharacterList,{id=1001})
	end
end


function sActorManager:onActorUpdate(data)
	local dt = tonumber(data.dt)
	for _,actor in pairs(self._actors) do
		actor:update(dt)
	end

	local deadStr = data.deadIds

	if deadStr ~= "none" then
		local deadIdList = string.split(deadStr,',')
		for _,strId in pairs(deadIdList) do
			local id = tonumber(strId)
			self:releaseSingleActor(id)
		end
	end
end

function sActorManager:getActorById(id)
	if not self._actors[id] then
		return
	end

	return self._actors[id]
end

function sActorManager:onCmdSendMsgToCom(data)
	local id = data.id
	local comName = data.comName
	local funcName = data.callbackName

	local params = {}
	for i=1,10 do
		local p = data["param"..i]
		if p then
			table.insert(params,p)
		else
			break
		end
	end

	local actor = self:getActorById(id)
	if actor then
		actor:sendMessageToComponent(comName,funcName,unpack(params))
	end
end

function sActorManager:onCmdReleaseActor(data)
	local id = tonumber(data.id)
	self:releaseSingleActor(id)
end

function sActorManager:sendMessageToComponent(id,name,...)
	local actor = self:getActorById(id)
	if actor then
		actor:sendMessageToComponent(name,...)
	end
end

function sActorManager:releaseSingleActor(id)
	if not self._actors[id] then
		return
	end

	local actorType = self._actors[id]:getType()
	local cfgId = self._actors[id]:getCfgId()
	self._actors[id]:release()
	self._actors[id] = nil
	self._typeActors[actorType][id] = nil

	if self._cfgMaps[cfgId] then
		self._cfgMaps[cfgId] = self._cfgMaps[cfgId] - 1
	end

	if cfgId == 1009 then
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_Refresh_CharacterList,{id=cfgId})
	end
end

function sActorManager:getCgfCount(cfgId)
	if not self._cfgMaps[cfgId] then
		return 0
	end

	return self._cfgMaps[cfgId]
end

function sActorManager:onGameOver()
	self:ReleaseAllActors()
end

function sActorManager:onRestart()
	self:ReleaseAllActors()
end

function sActorManager:ReleaseAllActors()
	for id,actor in pairs(self._actors) do
		actor:release()
	end
	self._actors = {}

	self._typeActors = {}

	self._cfgMaps = {}
end

function sActorManager:_Update(dt)

end

function sActorManager:render()
	-- for _,actor in pairs(self._actors) do
	-- 	actor:render()
	-- end
end

function sActorManager:_Release()
	self._actors = {}

	self._typeActors = {}

	self._cfgMaps = {}
end

return sActorManager