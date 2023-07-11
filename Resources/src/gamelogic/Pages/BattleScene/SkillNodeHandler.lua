local SimpleAniNode = TWRequire("SimpleAniNode")
local SkillNodeHandler = class("SkillNodeHandler",_GModel.IBaseInterface,_GModel.IMsgInterface)

function SkillNodeHandler:ctor(skillNode)
	self:setSceneNode(skillNode)
	self:_scheduleUpdate()

	self._mask = self:getNode("LoadingBarSK")
    self._mask:setPercent(100)

    self:setButtonEnable("BtnSkill",false)
    self:addBtnClickListener("BtnSkill",self.OnBtnSkill)
    self._Damage = 0
    self._CDTime = 0
    self._OwnerId = -1
    self._CanPutSkill = false
    self._StartCD = false
    self._CurTime =  0
    self._Pause = false
    self._startHander = handler(self,self.Start)

    self._missleReadyAni = SimpleAniNode.new("UI/Effects/MissleReadyEffect.csb")
    self:addChildNode("SpSkill",self._missleReadyAni)
    self._missleReadyAni:setPosition(cc.p(64,64))
    self._missleReadyAni:setVisible(false)
end

function SkillNodeHandler:OnBtnSkill()
	self:setButtonEnable("BtnSkill",false)
	self._mask:setVisible(true)
	self._CanPutSkill = true
	local data1 = 
	{
		nodeName = "warnItemNode",
		isShow = true
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)

end

function SkillNodeHandler:SetDamge(damage)
	self._Damage = damage
end

function SkillNodeHandler:SetCDTime(CDTime)
	self._CDTime = CDTime
end

function SkillNodeHandler:SetOwnerId(id)
	self._OwnerId = id
end

function SkillNodeHandler:SetCanPutSKill(canPutSkill)
	self._CanPutSkill = canPutSkill
end

function SkillNodeHandler:GetCanPutSkill()
	return self._CanPutSkill
end

function SkillNodeHandler:_update(dt)
	if not self._StartCD then
		return
	end

	if self._Pause then
		return
	end

	self._CurTime = self._CurTime - dt
	if self._CurTime < 0 then
		self:setButtonEnable("BtnSkill",true)
		QueueEvent(EventType.ScriptEvent_Sound,{id = "Sound_Skill_Ready"})
		self._missleReadyAni:setVisible(true)
		self._StartCD = false
		return
	end

	local ratio =  self._CurTime/self._CDTime
	if ratio <= 0 then
		ratio = 0
	end

	self._mask:setPercent(ratio*100)
end

function SkillNodeHandler:PutSkill(pos)
	self._CanPutSkill = false

	local data1 = 
	{
		nodeName = "warnItemNode",
		isShow = false
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)

	local cannonBuilding = _GModel.sActorManager:getActorById(self._OwnerId)
	if cannonBuilding then
		cannonBuilding:sendMessageToComponent("BuildingComponent","Attack",pos.x,pos.y,actor_status.as_shoot,actor_type.type_none)
	end

	gRootManager:AddTimer(4,false,self._startHander)
	self._missleReadyAni:setVisible(false)

	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_AddEffect,{id = 7043 , pos = pos,layer="RoadLayer"})
end

function SkillNodeHandler:Start()
	self._CanPutSkill = false
	self:setButtonEnable("BtnSkill",false)
	self._mask:setPercent(100)
	self._StartCD = true
	self._CurTime = self._CDTime
	-- self._mask:setVisible(false)


	-- local progress = cc.ProgressTo:create(self._CDTime, 0)
	-- self._progressTimer:setPercentage(100)
    -- self._progressTimer:runAction(progress)

    -- local delay = cc.DelayTime:create(self._CDTime)
    -- local sequence = cc.Sequence:create(delay, cc.CallFunc:create(function ( )
	-- 	self:setButtonEnable("BtnSkill",true)
	-- 	QueueEvent(EventType.ScriptEvent_Sound,{id = "Sound_Skill_Ready"})
	-- 	self._missleReadyAni:setVisible(true)
	-- end))

	-- self._mask:runAction(sequence)
end

function SkillNodeHandler:Pause(isPause)
	self._Pause = isPause
end


function SkillNodeHandler:Stop()
	self._Damage = 0
    self._CDTime = 0
    self._OwnerId = -1
    self._CanPutSkill = false
    self._missleReadyAni:setVisible(false)
end

function SkillNodeHandler:_Release()
	self:Stop()
	self._missleReadyAni:removeFromParent()
end

return SkillNodeHandler