local common = TWRequire("common")
local TrapWaterRainComponent = class("TrapWaterRainComponent",_GModel.IComponent)

function TrapWaterRainComponent:_init(data)
	self._Radius = data.radius
	self._Status = actor_status.as_alive
	self._Damage = data.damage
	self._DamageType = data.damage_type
	self._isDie = false
	self._Pos = self._Owner:getPosition()

	self._effectNode,self._timeLine = _GModel.sSpriteAniManager:createCsbAniNode(data.attachSCB,"EffectLayer")
	self._timeLine:play("start", false)
	self._effectNode:setPosition(self._Pos.x,self._Pos.y)

	self._params1  = {
		radius = self._Radius,
		pos = self._Pos,
		type = actor_type.type_soilder,
		count = 8,
		team = actor_team.team_NPC
	}

	self._params2  = {
		radius = self._Radius,
		pos = self._Pos,
		type = actor_type.type_building_colide_rect,
		count = 8,
		team = actor_team.team_NPC
	}

	local damageHandler = handler(self,self.CheckDamage)
	gRootManager:AddTimer(0.5,false,damageHandler)

	QueueEvent(EventType.ScriptEvent_Sound,{id = "sound_quantouhuaguo"})
end

function TrapWaterRainComponent:_update(dt)
	if self._isDie then return end

	if not self._timeLine:isPlaying() then
		self._Owner:sendMessageToComponent("StatusComponent","SetStatus",true,actor_status.as_die)
		self._isDie = true
		self._timeLine = nil
		self._effectNode:removeFromParent()
		self._effectNode = nil

		QueueEvent(EventType.ScriptEvent_Sound,{id = "Sound_quantouJizhong"})
	end
end

function TrapWaterRainComponent:CheckDamage()
	local actorSoldiers = ActorManager.GetActorByRadius(self._params1)
	--local actorBuildings = ActorManager.GetActorByRadius(self._params2)

	local actors = actorSoldiers

	if next(actors) then
		for _,id in pairs(actors) do
			local targetActor = _GModel.sActorManager:getActorById(id)
			if targetActor then
				targetActor:sendMessageToComponent("HealthComponent","ReduceHealth",self._Damage,self._DamageType)
			end
		end
	end
end

function TrapWaterRainComponent:_release()
	if self._effectNode then
		self._effectNode:removeFromParent()
	end

	self._effectNode = nil
	self._timeLine = nil
end

return TrapWaterRainComponent