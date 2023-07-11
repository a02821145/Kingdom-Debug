local TrapSurikenComponent = class("TrapSurikenComponent",_GModel.IComponent)

function TrapSurikenComponent:_init(data)
	self._Radius = data.radius
	self._CheckTimes = data.checkTimes
	self._CurCheckTimes = data.checkTimes
	self._Status = actor_status.as_alive
	self._Damage = data.damage
	self._DamageType = data.damage_type
	self._effect_path = data.attachSCB
	self._effectNode = nil
	self._Pos = self._Owner:getPosition()
	
	self._sp = _GModel.sSpriteAniManager:getSpriteBatchNode("RoadLayer",data.sp,data.spFile)

	self._sp:setPosition(self._Pos.x,self._Pos.y)

	self._params  = {
		radius = self._Radius,
		pos = self._Pos,
		type = actor_type.type_soilder,
		count = 8,
		team = self._Owner:GetReverseTeam()
	}

	self._hasTouch = false
	self._finishTime = data.finishTime
	self._Owner:SetDisplayComponent("TrapSurikenComponent")
end

function TrapSurikenComponent:_update(dt)
	if self._Status == actor_status.as_die then
		return
	end

	if self._hasTouch then
		self._finishTime = self._finishTime - dt
		if self._finishTime <= 0 then
			self._Owner:sendMessageToComponent("StatusComponent","SetStatus",true,actor_status.as_die)

			self._Status = actor_status.as_die
			return
		end
	end

	self._CurCheckTimes = self._CurCheckTimes -1
	if self._CurCheckTimes <=0 then
		local actors = ActorManager.GetActorByRadius(self._params)
		if next(actors) then
			self._hasTouch = true

			for _,id in pairs(actors) do
				local targetActor = _GModel.sActorManager:getActorById(id)
				if targetActor then
					targetActor:sendMessageToComponent("HealthComponent","ReduceHealth",self._Damage,self._DamageType)
				end
			end
		end

		self._CurCheckTimes = self._CheckTimes
	end

	if self._hasTouch and not self._effectNode then
		local sceneNode,timeLine = _GModel.sSpriteAniManager:createCsbAniNode(self._effect_path,"RoadLayer")
		timeLine:play("start",true)
		self._effectNode = sceneNode
		self._effectNode:setPosition(self._Pos)
		self._sp:setVisible(false)
	end
end

function TrapSurikenComponent:SetValid(isValid)
	print("TrapSurikenComponent:SetValid isValid=",isValid)

	local isValid = tonumber(isValid)
	local c = cc.WHITE
	if isValid == EPutActorState.EPAS_INVALID then
		c = cc.RED
	elseif isValid == EPutActorState.EPAS_VALID then
		c = cc.GREEN
	end

	self._sp:setColor(c)
end

function TrapSurikenComponent:SetPosition(x_,y_)
	local x = tonumber(x_)
	local y = tonumber(y_)
	self._sp:setPosition(x,y)
end

function TrapSurikenComponent:SetIsTry(isTry_)
	local isTry = tonumber(isTry_) == 1
	if isTry then
		_GModel.sSpriteAniManager:changeLayer(self._sp,"TryPutLayer")
	else
		_GModel.sSpriteAniManager:changeLayer(self._sp,"RoadLayer")
	end
end

function TrapSurikenComponent:_release()
	if self._sp then
		self._sp:removeFromParent()
	end

	self._sp = nil
	if self._effectNode then
		self._effectNode:removeFromParent()
	end

	self._effectNode = nil
end

return TrapSurikenComponent