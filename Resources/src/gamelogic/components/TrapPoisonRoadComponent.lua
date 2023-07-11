local TrapPoisonRoadComponent = class("TrapPoisonRoadComponent",_GModel.IComponent)

function TrapPoisonRoadComponent:_init(data)
	self._Pos = self._Owner:getPosition()
	self._Damage = data.damage
	self._DamageType = data.damage_type
	self._LifeTime = data.lifeTime
	self._Status = actor_status.as_alive
	self._CheckTimes = data.checkTime
	self._curCheckTimes = self._CheckTimes

	self._effectNode,self._timeLine = _GModel.sSpriteAniManager:createCsbAniNode(data.attachSCB,"RoadLayer")
	self._timeLine:play("start", true)
	self._effectNode:setPosition(self._Pos.x,self._Pos.y)
	local sizeNode = self._effectNode:getChildByName("SizeNode")
	local size = sizeNode:getContentSize()

	self._vMin = {}
	self._vMax = {}
	self._vMin.x = self._Pos.x - size.width*0.5
	self._vMin.y = self._Pos.y - size.height*0.5
	self._vMax.x = self._Pos.x + size.width*0.5
	self._vMax.y = self._Pos.y + size.height*0.5

	self._params = 
	{
		min = self._vMin,
		max = self._vMax,
		team = actor_team.team_NPC,
		type = actor_type.type_soilder,
	}
end

function TrapPoisonRoadComponent:_update(dt)
	if self._Status == actor_status.as_die then
		return
	end

	self._LifeTime = self._LifeTime - dt
	if self._LifeTime <= 0 then
		self._Status = actor_status.as_die
		self._Owner:sendMessageToComponent("StatusComponent","SetStatus",true,actor_status.as_die)
		return
	end

	self._curCheckTimes = self._curCheckTimes - dt
	if self._curCheckTimes <= 0 then

		local actors = ActorManager.GetActorByRect(self._params)
		if next(actors) then
			for _,id in pairs(actors) do
				local targetActor = _GModel.sActorManager:getActorById(id)
				if targetActor then
					local p1 = 
					{
						buffType = buff_type.buff_type_speed,
						actorId = id,
						time = 2,
						value = -90
					}

					BuffManager.AddBuffToActor(p1)

					local p2 = 
					{
						buffType = buff_type.buff_type_poisoned,
						actorId = id,
						time = 2,
					}

					BuffManager.AddBuffToActor(p2)
				end
			end
		end

		self._curCheckTimes = self._CheckTimes
	end
end

function TrapPoisonRoadComponent:render()
	_GModel.sSpriteAniManager:drawRect(self._vMin,self._vMax)
end

function TrapPoisonRoadComponent:_release()
	if self._effectNode then
		self._effectNode:removeFromParent()
	end

	self._effectNode = nil
end

return TrapPoisonRoadComponent