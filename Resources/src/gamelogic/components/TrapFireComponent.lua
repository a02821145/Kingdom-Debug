local TrapFireComponent = class("TrapFireComponent",_GModel.IComponent)

function TrapFireComponent:_init(data)
	self._Radius = data.radius
	self._CheckTimes = data.checkTime
	self._CurCheckTimes = data.checkTime + math.random(0,5)
	self._Status = actor_status.as_alive
	self._Damage = data.damage
	self._DamageType = data.damage_type
	self._effect_path = data.attachSCB
	self._effectNode = nil
	self._Pos = self._Owner:getPosition()
	self._MoveDelta = data.moveDelta

	local team = self._Owner:getTeam()

	self._params  = {
		radius = self._Radius,
		pos = self._Pos,
		type = actor_type.type_soilder,
		count = 8,
		team = team == actor_team.team_none and nil or self._Owner:GetReverseTeam()
	}

	self._Owner:SetDisplayComponent("TrapFireComponent")

	local sceneNode = _GModel.sSpriteAniManager:getSpriteBatchNode("RoadLayer",data.sp,data.spFile)
	self._effectNode = sceneNode
	self._effectNode:setPosition(self._Pos.x + self._MoveDelta.x,self._Pos.y + self._MoveDelta.y)

	local listStrList = {}
	local aniInfo = data.ani
	for i=aniInfo.startIndex,aniInfo.endIndex do
		local str = string.format(aniInfo.fmt,i)
		table.insert(listStrList,str)
	end

	local r = math.random(1,aniInfo.delay)
	local ani = _GModel.sSpriteAniManager:createAniSpriteFrames(listStrList,aniInfo.time)
	local seq = cc.Sequence:create(ani,cc.DelayTime:create(r))
	self._effectNode:runAction(cc.RepeatForever:create(seq))
end

function TrapFireComponent:_update(dt)
	if self._Status == actor_status.as_die then
		return
	end

	self._CurCheckTimes = self._CurCheckTimes - dt
	if self._CurCheckTimes <= 0 then
		local actors = ActorManager.GetActorByRadius(self._params)
		if next(actors) then
			for _,id in pairs(actors) do
				local targetActor = _GModel.sActorManager:getActorById(id)
				if targetActor then
					targetActor:sendMessageToComponent("HealthComponent","ReduceHealth",self._Damage,self._DamageType)
				end
			end
		end

		self._CurCheckTimes = self._CheckTimes + math.random(0,5)
	end
end

function TrapFireComponent:SetValid(isValid)
	local isValid = tonumber(isValid)
	local c = cc.WHITE
	if isValid == EPutActorState.EPAS_INVALID then
		c = cc.RED
	elseif isValid == EPutActorState.EPAS_VALID then
		c = cc.GREEN
	end

	self._effectNode:setColor(c)
end

function TrapFireComponent:SetPosition(x_,y_)
	local x = tonumber(x_)
	local y = tonumber(y_)
	self._effectNode:setPosition(x+ self._MoveDelta.x,y + self._MoveDelta.y)
end

function TrapFireComponent:render()
	_GModel.sSpriteAniManager:drawCircle(self._Pos,self._Radius,cc.c4f(1.0, 0.2, 0.5, 1),false)
end

function TrapFireComponent:_release()

	if self._effectNode then
		self._effectNode:removeFromParent()
	end

	self._effectNode = nil
end

return TrapFireComponent