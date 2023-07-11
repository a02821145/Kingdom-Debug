local Vector2D = TWRequire("Vector2D")

local WeatherRainComponent = class("WeatherRainComponent",_GModel.IComponent)

local configManager = TWRequire("ConfigDataManager")

function WeatherRainComponent:_init(data)
	local damageList = string.split(data.damage,',')
	self._damageMin = tonumber(damageList[1])
	self._damageMax = tonumber(damageList[2])
	self._LifeTime = data.lifeTime
	self._mapSize = getMapSize()
	self._Speed = data.speed
	self._isDie = false
	self._Radius = data.radius
	self._ThunderTime = data.thunderTime
	self._CurThunderTime = data.thunderTime + math.random(1,3)
	self._ThunderCount = data.thunderCount

	self._effectNode,self._timeLine = _GModel.sSpriteAniManager:createCsbAniNode(data.attachSCB,"ProjectileLayer")
	self._timeLine:play("start", true)
	local pos = self._Owner:getPosition()
	self._effectNode:setPosition(pos.x,pos.y)

	local targetX = math.random(0,self._mapSize.width)
	local targetY = math.random(0,self._mapSize.height)
	self._TargetPos = Vector2D.new(targetX,targetY)
	self._Dir = self._TargetPos - pos
	self._Dir:SetNormalize()
	self._EffectId = data.effectId

	self._params  = {
		radius = data.thunderRadius,
		pos = pos,
		type = actor_type.type_soilder,
		count = 8,
	}

	self._thunderList = {}

	QueueEvent(EventType.ScriptEvent_Sound,{id = data.sound})
end

function WeatherRainComponent:_update(dt)
	if self._isDie then return end

	self._LifeTime = self._LifeTime - dt
	if self._LifeTime <= 0 then
		print("WeatherRainComponent:_update")
		self._Owner:sendMessageToComponent("StatusComponent","SetStatus",true,actor_status.as_die)
		self._isDie = true
		return
	end

	for _,Info in ipairs(self._thunderList) do
		Info.deltaTime = Info.deltaTime - dt
		if Info.deltaTime <= 0 then
			self._params.pos = Info.pos

			local actors = ActorManager.GetActorByRadius(self._params)
			if next(actors) then
				for _,id in ipairs(actors) do
					local targetActor = _GModel.sActorManager:getActorById(id)
					if targetActor then
						local damage = math.random(self._damageMin,self._damageMax)
						targetActor:sendMessageToComponent("HealthComponent","ReduceHealth",damage,damage_type.at_phyisc)
					end
				end
			end

			gMessageManager:sendMessage(MessageDef_GameLogic.MSG_AddEffect,{id = self._EffectId , pos = Info.pos})
			Info.remove = true
		end
	end

	if next(self._thunderList) then
		for i = #self._thunderList, 1, -1 do
			local info = self._thunderList[i]
			if info and info.remove then
				table.remove(self._thunderList,i)
			end
		end
	end

	local pos = self._Owner:getPositionDirect()
	pos = pos + self._Dir*self._Speed*dt

	self._CurThunderTime = self._CurThunderTime - dt
	if self._CurThunderTime <= 0 then
		local deltaTime = 0
		for i=1,self._ThunderCount do
			local Info = {}
			local newPos = {}
			newPos.x = pos.x + math.random(-self._Radius,self._Radius)
			newPos.y = pos.y + math.random(0,self._Radius)*0.2
			Info.pos = newPos
			local newDelta = math.random(1,5)*0.1

			Info.deltaTime = deltaTime + newDelta
			Info.remove = false

			deltaTime = deltaTime + newDelta
			table.insert(self._thunderList,Info)
		end

		self._CurThunderTime = self._ThunderTime  + math.random(1,3)
	end

	self._Owner:setPositionDirect(pos.x,pos.y)
	self._effectNode:setPosition(pos.x,pos.y)
end

function WeatherRainComponent:render()
	local pos = self._Owner:getPositionDirect() 
	_GModel.sSpriteAniManager:drawCircle(pos,self._Radius,cc.c4f(1.0, 0.2, 0.5, 1))
end

function WeatherRainComponent:_release()
	if self._effectNode then
		self._effectNode:removeFromParent()
	end
	
	self._effectNode = nil
	self._timeLine = nil
end

return WeatherRainComponent