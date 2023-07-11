local TrapBombFireComponent = class("TrapBombFireComponent",_GModel.IComponent)

function TrapBombFireComponent:_init(data)
	print("TrapBombFireComponent:_init")
	self._LifeTime = data.lifeTime
	self._Radius = data.radius
	self._CheckTime = data.checkTime
	self._DamageType = data.damage_type
	self._CurCheckTime = 0
	self._Damage = data.damage
	self._isDie = false

	self._Pos = self._Owner:getPosition()
	self._effectNode,self._timeLine = _GModel.sSpriteAniManager:createCsbAniNode(data.attachSCB,"RoadLayer")
	self._timeLine:play("start", true)
	self._effectNode:setPosition(self._Pos.x,self._Pos.y)

	self._params  = {
		radius = self._Radius,
		pos = self._Pos,
		type = actor_type.type_soilder,
		count = 8,
		team = actor_team.team_NPC
	}
end

function TrapBombFireComponent:_update(dt)
	if self._isDie then return end

	self._LifeTime = self._LifeTime - dt
	if self._LifeTime <= 0 then
		self._Owner:sendMessageToComponent("StatusComponent","SetStatus",true,actor_status.as_die)
		self._isDie = true
		return
	end

	self._CurCheckTime = self._CurCheckTime - dt
	if self._CurCheckTime <= 0 then
		local actors = ActorManager.GetActorByRadius(self._params)
		if next(actors) then
			for _,id in pairs(actors) do
				local targetActor = _GModel.sActorManager:getActorById(id)
				if targetActor then
					targetActor:sendMessageToComponent("HealthComponent","ReduceHealth",self._Damage,self._DamageType)
				end
			end
		end
		self._CurCheckTime = self._CheckTime
	end
end


function TrapBombFireComponent:_release()
	if self._effectNode then
		self._effectNode:removeFromParent()
	end

	self._effectNode = nil
end

return TrapBombFireComponent