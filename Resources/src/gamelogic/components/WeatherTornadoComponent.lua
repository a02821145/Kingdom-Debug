local Vector2D = TWRequire("Vector2D")

local WeatherTornadoComponent = class("WeatherTornadoComponent",_GModel.IComponent)

local configManager = TWRequire("ConfigDataManager")

function WeatherTornadoComponent:_init(data)
	local damageList = string.split(data.damage,',')
	self._damageMin = tonumber(damageList[1])
	self._damageMax = tonumber(damageList[2])
	self._LifeTime = data.lifeTime
	self._mapSize = getMapSize()
	self._Freq = data.freq
	self._CurFreq = data.freq
	self._Speed = data.speed
	self._isDie = false
	self._Radius = data.radius
	local effectInfo = configManager:getConfigById(data.effectId)

	self._effectNode,self._timeLine = _GModel.sSpriteAniManager:createCsbAniNode(effectInfo.effect,"ProjectileLayer")
	self._timeLine:play("start", true)
	local pos = self._Owner:getPosition()
	self._effectNode:setPosition(pos.x,pos.y)

	local targetX = math.random(0,self._mapSize.width)
	local targetY = math.random(0,self._mapSize.height)
	self._TargetPos = Vector2D.new(targetX,targetY)
	self._Dir = self._TargetPos - pos
	self._Dir:SetNormalize()

	self._params  = {
		radius = self._Radius,
		pos = pos,
		type = actor_type.type_soilder,
		count = 128,
	}

	QueueEvent(EventType.ScriptEvent_Sound,{id = data.sound})
end

function WeatherTornadoComponent:_update(dt)
	if self._isDie then return end

	self._LifeTime = self._LifeTime - dt
	if self._LifeTime <= 0 then
		self._Owner:sendMessageToComponent("StatusComponent","SetStatus",true,actor_status.as_die)
		self._isDie = true
		return
	end

	local pos = self._Owner:getPositionDirect()
	pos = pos + self._Dir*self._Speed*dt
	
	if self._CurFreq <=0 then
		self._params.pos = pos
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
		self._CurFreq = self._Freq
	else
		self._CurFreq = self._CurFreq - 1
	end

	self._Owner:setPositionDirect(pos.x,pos.y)
	self._effectNode:setPosition(pos.x,pos.y)
end

function WeatherTornadoComponent:render()
	local pos = self._Owner:getPositionDirect() 
	_GModel.sSpriteAniManager:drawCircle(pos,self._Radius,cc.c4f(1.0, 0.2, 0.5, 1))
end

function WeatherTornadoComponent:_release()
	if self._effectNode then
		self._effectNode:removeFromParent()
	end
	
	self._effectNode = nil
	self._timeLine = nil
end

return WeatherTornadoComponent