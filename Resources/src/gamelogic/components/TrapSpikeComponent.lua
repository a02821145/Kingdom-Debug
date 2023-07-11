local TrapSpikeComponent = class("TrapSpikeComponent",_GModel.IComponent)

function TrapSpikeComponent:_init(data)
	print("TrapSpikeComponent:_init")
	self._Radius = data.radius

	self._CheckTimes = data.checkTimes
	self._CurCheckTimes = data.checkTimes + math.random(0,data.checkTimes)
	self._Status = actor_status.as_alive
	self._EffectId = data.effectId
	self._Pos = self._Owner:getPosition()
	self._Damage = data.damage
	self._DamageType = data.damage_type

	self._sp = _GModel.sSpriteAniManager:getSpriteBatchNode("RoadLayer",data.sp,data.spFile)
	self._sp:setAnchorPoint(cc.p(0,0))
	self._sp:setPosition(self._Pos.x-16,self._Pos.y-16)

	self._params  = {
		radius = self._Radius,
		pos = self._Pos,
		type = actor_type.type_soilder,
		count = 1,
		team = self._Owner:GetReverseTeam()
	}

	self._Owner:SetDisplayComponent("TrapSpikeComponent")
end

function TrapSpikeComponent:_update(dt)
	if self._Status == actor_status.as_die then
		return
	end

	self._CurCheckTimes = self._CurCheckTimes -1
	if self._CurCheckTimes <=0 then
		
		local actors = ActorManager.GetActorByRadius(self._params)
		if next(actors) then
			local id = actors[1]
			local targetActor = _GModel.sActorManager:getActorById(id)
			if targetActor then
				targetActor:sendMessageToComponent("HealthComponent","ReduceHealth",self._Damage,self._DamageType)
			end

			self._Owner:sendMessageToComponent("StatusComponent","SetStatus",true,actor_status.as_die)

			self._Status = actor_status.as_die
			
			gMessageManager:sendMessage(MessageDef_GameLogic.MSG_AddEffect,{id = self._EffectId , pos = self._Pos})

			return
		end

		self._CurCheckTimes = self._CheckTimes + math.random(0,self._CheckTimes)
	end
end

function TrapSpikeComponent:SetValid(isValid)
	print("TrapSpikeComponent:SetValid isValid=",isValid)

	local isValid = tonumber(isValid)
	local c = cc.WHITE
	if isValid == EPutActorState.EPAS_INVALID then
		c = cc.RED
	elseif isValid == EPutActorState.EPAS_VALID then
		c = cc.GREEN
	end

	self._sp:setColor(c)
end

function TrapSpikeComponent:SetPosition(x_,y_)
	local x = tonumber(x_)-16
	local y = tonumber(y_)-16
	self._sp:setPosition(x,y)
end

function TrapSpikeComponent:_release()
	if self._sp then
		self._sp:removeFromParent()
	end

	self._sp = nil
end

function TrapSpikeComponent:render()
	_GModel.sSpriteAniManager:drawCircle(self._Pos,self._Radius,cc.c4f(1.0, 0.2, 0.5, 1),false)
end

return TrapSpikeComponent