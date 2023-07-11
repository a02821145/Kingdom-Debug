local Vector2D = TWRequire("Vector2D")

local WeatherSnowComponent = class("WeatherSnowComponent",_GModel.IComponent)

function WeatherSnowComponent:_init(data)
	self._LifeTime = data.lifeTime
	self._mapSize = getMapSize()
	self._Speed = data.speed
	self._isDie = false
	self._Radius = data.radius
	self._CheckTimes = data.checkTimes
	self._Height = data.height
	self._curCheckTimes = self._CheckTimes
	self._Ratio = data.ratio

	self._effectNode,self._timeLine = _GModel.sSpriteAniManager:createCsbAniNode(data.attachSCB,"ProjectileLayer")
	self._timeLine:play("start", true)
	local pos = self._Owner:getPosition()
	self._effectNode:setPosition(pos.x,pos.y)

	local targetX = math.random(0,self._mapSize.width)
	local targetY = math.random(0,self._mapSize.height)
	self._TargetPos = Vector2D.new(targetX,targetY)
	self._Dir = self._TargetPos - pos
	self._Dir:SetNormalize()
end

function WeatherSnowComponent:_update(dt)
	if self._isDie then return end

	self._LifeTime = self._LifeTime - dt
	if self._LifeTime <= 0 then
		print("WeatherSnowComponent:_update")
		self._Owner:sendMessageToComponent("StatusComponent","SetStatus",true,actor_status.as_die)
		self._isDie = true
		return
	end

	self._curCheckTimes = self._curCheckTimes - dt
	if self._curCheckTimes <= 0 then
		local pos = self._Owner:getPositionDirect()
		local _vMin = {}
		local _vMax = {}
		_vMin.x = pos.x - self._Radius
		_vMin.y = pos.y
		_vMax.x = pos.x + self._Radius
		_vMax.y = pos.y + self._Height

		local params = 
		{
			min = _vMin,
			max = _vMax,
			type = actor_type.type_soilder,
		}

		local actors = ActorManager.GetActorByRect(params)
		if next(actors) then
			for _,id in pairs(actors) do
				local targetActor = _GModel.sActorManager:getActorById(id)
				if targetActor then
					local p1 = 
					{
						buffType = buff_type.buff_type_speed,
						actorId = id,
						time = 2,
						value = -50
					}

					BuffManager.AddBuffToActor(p1)

					local num = math.random(0,100)
					if num > (100 - self._Ratio) then
						local p2 = 
						{
							buffType = buff_type.buff_type_frozen,
							actorId = id,
						}

						BuffManager.AddBuffToActor(p2)
					end
				end
			end
		end

		self._curCheckTimes = self._CheckTimes
	end

	local pos = self._Owner:getPositionDirect()
	pos = pos + self._Dir*self._Speed*dt
	self._Owner:setPositionDirect(pos.x,pos.y)
	self._effectNode:setPosition(pos.x,pos.y)
end


function WeatherSnowComponent:_release()
	if self._effectNode then
		self._effectNode:removeFromParent()
	end
	
	self._effectNode = nil
	self._timeLine = nil
end

return WeatherSnowComponent