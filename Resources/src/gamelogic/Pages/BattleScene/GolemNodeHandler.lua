local SimpleAniNode = TWRequire("SimpleAniNode")
local GolemNodeHandler = class("GolemNodeHandler",_GModel.IBaseInterface,_GModel.IMsgInterface)

function GolemNodeHandler:ctor(skillNode)
	self:setSceneNode(skillNode)
	self:_scheduleUpdate()

	self._mask = self:getNode("LoadingBarGL")
    self._mask:setPercent(100)

    self:setButtonEnable("BtnGolem",false)
    self:addBtnClickListener("BtnGolem",self.OnBtnGolem)

    self._CanPutGolem = false
    self._StartCD = false
    self._CurTime =  0
    self._Pause = false
    self._CDTime = 60

    local key    = "UnitLV_"..4001
	local temp   = getPlayerSetting(key,SettingType.TYPE_INT,1)
	local iLevel = tonumber(temp.Value)

    self._golemLevel = iLevel

    key = "UnitLV_"..1027
	setPlayerSetting(key,SettingType.TYPE_INT,iLevel)

    self._missleReadyAni = SimpleAniNode.new("UI/Effects/MissleReadyEffect.csb")
    self:addChildNode("SpGolem",self._missleReadyAni)
    self._missleReadyAni:setPosition(cc.p(64,64))
    self._missleReadyAni:setVisible(false)

    self:addListener(MessageDef_GameLogic.MSG_TouchMapPos,self.onTouchGameMap)
end

function GolemNodeHandler:onTouchGameMap(message)
	local pos = message.pos

	if not self._CanPutGolem then return end

	local data =
	{
		command="createActor",
		team = actor_team.team_player,
		id= 1027,
		pos=pos,
		num=1,
		level = self._golemLevel
	}

	if not ActorManager.createActors(data) then
		return
	end

	self:Start()
	self._missleReadyAni:setVisible(false)

		local data1 = 
	{
		nodeName = "playerAreaNode",
		isShow = false
	}

	local data2 = 
	{
		nodeName = "btnCancelPut",
		isShow = false,
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)
	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data2)
end

function GolemNodeHandler:OnBtnGolem()
	self:setButtonEnable("BtnGolem",false)
	self._CanPutGolem = true

	local data1 = 
	{
		nodeName = "playerAreaNode",
		isShow = true,
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)
end

function GolemNodeHandler:Start()
	self._CanPutGolem = false
	self:setButtonEnable("BtnGolem",false)
	self._mask:setPercent(100)
	self._StartCD = true
	self._CurTime = self._CDTime
end

function GolemNodeHandler:_update(dt)
	if not self._StartCD then
		return
	end

	if self._Pause then
		return
	end

	self._CurTime = self._CurTime - dt
	if self._CurTime < 0 then
		self:setButtonEnable("BtnGolem",true)
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

function GolemNodeHandler:Pause(isPause)
	self._Pause = isPause
end


function GolemNodeHandler:Stop()
    self._CDTime = 0
    self._CanPutGolem = false
    self._CanPutSkill = false
    self._missleReadyAni:setVisible(false)
end

function GolemNodeHandler:Release()
	self:Stop()
	self._missleReadyAni:removeFromParent()
end

return GolemNodeHandler