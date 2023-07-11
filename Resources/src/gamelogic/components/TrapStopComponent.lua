local TrapStopComponent = class("TrapStopComponent",_GModel.IComponent)

function TrapStopComponent:_init(data)
	print("TrapStopComponent:_init")
	self._Radius = data.radius
	self._TrapTime = data.trapTime
	self._CheckTimes = data.checkTimes
	self._CurCheckTimes = data.checkTimes
	self._Status = actor_status.as_alive
	self._TrapTime = data.trapTime
	self._EffectId = data.effectId
	self._Pos = self._Owner:getPosition()
	
	self._sp = _GModel.sSpriteAniManager:createSpriteFrame(data.sp,"RoadLayer")
	self._sp:setPosition(self._Pos.x,self._Pos.y)
	self._params  = {
		radius = self._Radius,
		pos = self._Pos,
		type = actor_type.type_soilder,
		count = 1,
		team = self._Owner:GetReverseTeam()
	}

	self._Owner:SetDisplayComponent("TrapStopComponent")
end

function TrapStopComponent:_update(dt)
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
				targetActor:SetStopTime(self._TrapTime)
				targetActor:sendMessageToComponent("StatusComponent","SetStatus",true,actor_status.as_stop)
			end

			local targetPos = targetActor:getPosition()
			self._Owner:sendMessageToComponent("StatusComponent","SetStatus",true,actor_status.as_die)

			self._Status = actor_status.as_die
			
			gMessageManager:sendMessage(MessageDef_GameLogic.MSG_AddEffect,{id = self._EffectId , pos = targetPos})

			return
		end

		self._CurCheckTimes = self._CheckTimes
	end
end

function TrapStopComponent:SetValid(isValid)
	print("TrapStopComponent:SetValid isValid=",isValid)

	local isValid = tonumber(isValid)
	local c = cc.WHITE
	if isValid == EPutActorState.EPAS_INVALID then
		c = cc.RED
	elseif isValid == EPutActorState.EPAS_VALID then
		c = cc.GREEN
	end

	self._sp:setColor(c)
end

function TrapStopComponent:SetPosition(x_,y_)
	local x = tonumber(x_)
	local y = tonumber(y_)
	self._sp:setPosition(x,y)
end

function TrapStopComponent:SetIsTry(isTry_)
	print("TrapStopComponent:SetIsTry isTry=",isTry_)
	local isTry = tonumber(isTry_) == 1
	if isTry then
		_GModel.sSpriteAniManager:changeLayer(self._sp,"TryPutLayer")
	else
		_GModel.sSpriteAniManager:changeLayer(self._sp,"RoadLayer")
	end
end

function TrapStopComponent:_release()
	if self._sp then
		self._sp:removeFromParent()
	end

	self._sp = nil
end

function TrapStopComponent:render()
	_GModel.sSpriteAniManager:drawCircle(self._Pos,16,cc.c4f(1.0, 0.2, 0.5, 1),false)
end

return TrapStopComponent