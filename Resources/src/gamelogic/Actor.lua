local Actor = class("Actor")
local common = TWRequire("common")
local Vector2D = TWRequire("Vector2D")
local ComponentManager = TWRequire("ComponentManager")
local configManager = TWRequire("ConfigDataManager")

function Actor:ctor(data,cfgData)
	local x,y = tonumber(data.posX),tonumber(data.posY)
	self._Pos = Vector2D.new(x,y)
	self._Type = tonumber(data.type)
	self._CfgData = cfgData
	self._Id = tonumber(data.id)
	self._Team = tonumber(data.team)
	self._ComponentManager = ComponentManager.new(self)
	self._ComponentManager:initComponents(self._CfgData.ScriptComponents)
	self._StopTime = 0
	self._CfgOppData = configManager:getConfigById(cfgData.oppId)
end

function Actor:GetID()
	return self._Id
end

function Actor:getCfgId()
	return self._CfgData.id
end

function Actor:getOppId()
	return self._CfgData.oppId
end

function Actor:getOppCfgData()
	return self._CfgOppData
end

function Actor:getTeam()
	return self._Team
end

function Actor:GetReverseTeam()
	local team = self._Team == actor_team.team_player and actor_team.team_NPC or actor_team.team_player
	return team
end

function Actor:SetStopTime(stopTime)
	self._StopTime = stopTime
	local params = 
	{
		id = self._Id,
		type = self._Type,
		StopTime = stopTime,
	}

	SetActorProperty(params)
end

function Actor:SetDisplayComponent(name)
	local params = 
	{
		id = self._Id,
		type = self._Type,
		DisplayName = name,
	}
	SetActorProperty(params)
end

function Actor:update(dt)
	if self._StopTime > 0 then
		self._StopTime = self._StopTime - dt
		return
	end

	if self._ComponentManager then
		self._ComponentManager:update(dt)
	end
end

function Actor:getPosition()
	local params = 
	{
		id = self._Id,
		type = self._Type,
		pos = true,
	}

	local LOPos = GetActorProperty(params)
	self._Pos:Set(LOPos.pos.x,LOPos.pos.y)
	return self._Pos
end

function Actor:setPositionDirect(x_,y_)
	self._Pos:Set(x_,y_)
end

function Actor:getPositionDirect()
	return self._Pos
end

function Actor:setPosition(x_,y_)
	self._Pos:Set(x_,y_)

	local params = 
	{
		id = self._Id,
		type = self._Type,
		Pos = {x=x_,y=y_},
	}

	SetActorProperty(params)
end

function Actor:getType()
	return self._Type
end

function Actor:render()
	if self._ComponentManager then
		self._ComponentManager:render()
	end
end

function Actor:release()
	self._ComponentManager:release()
	self._ComponentManager = nil
	self._CfgData = nil
end

function Actor:sendMessageToComponent(name,callbackName,...)
	if self._ComponentManager:isScriptCompnent(name) then
		 self._ComponentManager:sendMessageToComponent(name,callbackName,...)
	else
		local params = common:table_merge_by_order({...})
		table.insert(params,1,callbackName)
		ScriptSendMessageToComponent(self._Id,self._Type,name,"void",params)
	end
end

function Actor:sendMessageToComponentRet(name,callbackName,retType,...)
	if self._ComponentManager:isScriptCompnent(name) then
		 return self._ComponentManager:sendMessageToComponent(name,callbackName,...)
	else
		local params = common:table_merge_by_order({...})
		table.insert(params,1,callbackName)
		local ret = ScriptSendMessageToComponent(self._Id,self._Type,name,retType,params)
		return ret.Value
	end
end

return Actor