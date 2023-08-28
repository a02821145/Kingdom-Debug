local CharacterSelNode = class("CharacterSelNode", ccui.Widget,_GModel.IBaseInterface,_GModel.IMsgInterface)
local ConstCfg 		= TWRequire("ConstCfg")

function CharacterSelNode:ctor(data,isUnlock,selectCB)
	self:load("UI/Pages/BattlePage/CharacterSelectNode.csb")
	self._data = data
	self._currentCreateNum = 0
	self._isUnLock = isUnlock
	self._selectCB = selectCB
	self._isPause = false

	self._pop = data.population and data.population or 0
	self:_scheduleUpdate()
	
	self:setContentSize(210,160)

	self:setSpriteFrame("HeadIcon",self._data.icon)

	self._createNum = self:getNode("createNum")

	self._panelBG = self:getNode("panelBG")
	self._panelBG:setSwallowTouches(false)
	self._panelBG:onTouch(isUnlock and handler(self,self.onAddCreateActor) or nil)

	local forbidBG = self:getNode("forbiden")
	forbidBG:setSwallowTouches(false)

	self:setSpriteNum("pixel_number%d.png",self._data.cost,"moneyCost_%s")

	self._mask = self:getNode("Mask")
    self._mask:setPercent(0)

    self:setNodeVisible("lock_icon",not isUnlock)
    self:setNodeVisible("createNum",false)
    self:setNodeVisible("forbiden",false)

    self:setNodeVisible("PopNode",self._pop > 0)
    self:setSpriteFrame("PopNum",string.format("pixel_number%d.png",self._pop))

    self:initMsg()
    self:refreshStars()

    self._forbiden = false
    self._showCD = false
    self._curCDTime = 0
    self._startCD = false

    local key    = "UnitLV_"..tostring(self._data.id)
	local temp   = getPlayerSetting(key,SettingType.TYPE_INT,1)
	local iLevel = tonumber(temp.Value)
	self._iLevel = iLevel
end

function CharacterSelNode:refreshStars()
	local key    = "SoldierSkill_"..tostring(self._data.spId)
	local temp   = getPlayerSetting(key,SettingType.TYPE_INT,0)
	local starCount = tonumber(temp.Value)

	for i=1,ConstCfg.SKILL_STAR_COUNT do
		self:setNodeVisible(string.format("SkillStar%d",i),i<=starCount)
	end
end

function CharacterSelNode:initMsg()
	self:addListener(MessageDef_GameLogic.MSG_TouchMapPos,self.onTouchGameMap)
end

function CharacterSelNode:onAddCreateActor(event)
	if event.name ~= "ended" then return end

	if self._showCD then return end

	if self._forbiden then return end

	local curCost = _GModel.PlayerManager:GetPlayerCoins()
	local prepareMoney = _GModel.PlayerManager:GetPrepareMoney()
	local preparePop   = _GModel.PlayerManager:GetPreparePop()

	if (self._currentCreateNum + 1) * self._data.cost > curCost or (self._data.cost + prepareMoney) >  curCost then
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_PlayBattleSceneAni,{ani="moneyNotEnough",loop = false,isUINode = true })
		return
	end

	self:setNodeVisible("maxNode",false)
	if self:CheckFarmerForbiden(self._currentCreateNum+1) then
		self:setNodeVisible("maxNode",true)
		self:setForbiden(true)
		return
	end

	if self._pop > 0 then
		if PlayerManager.checkPopisEnough(actor_team.team_player,self._pop*(self._currentCreateNum + 1)) or  PlayerManager.checkPopisEnough(actor_team.team_player,self._pop + preparePop) then
			gMessageManager:sendMessage(MessageDef_GameLogic.MSG_PlayBattleSceneAni,{ani="popNotEnough",loop = false,isUINode = true })
			return 
		end
	end

	self._currentCreateNum = self._currentCreateNum + 1
	self._createNum:setSpriteFrame( string.format("pixel_number%d.png",self._currentCreateNum))

	self:setNodeVisible("createNum",true)
	local data1 = 
	{
		nodeName = "playerAreaNode",
		isShow = true,
	}

	local data2 = 
	{
		nodeName = "btnCancelPut",
		isShow = true,
	}

	if self._selectCB then
		self._selectCB(self)
	end

	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_RefreshTryMoney,{cost =self._data.cost,pop = self._pop})
	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)
	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data2)
end

function CharacterSelNode:CancelSelect()
	self._currentCreateNum = 0
	self:setNodeVisible("createNum",false)

	local data1 = 
	{
		nodeName = "playerAreaNode",
		isShow = false,
	}

	self:setNodeVisible("maxNode",false)
	if  self:CheckFarmerForbiden(1) then
		self:setForbiden(true)
		self:setNodeVisible("maxNode",true)
		return
	end

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)
end

function CharacterSelNode:CheckFarmerForbiden(count)
	if self._data.id ~= 1009 then return false end

	count = count or 0

	local fCount = _GModel.sActorManager:getCgfCount(1009)
	local isEnought = (fCount +count)>3
	
	return isEnought
end

function CharacterSelNode:refreshFarmerForbiden()
	self:setNodeVisible("maxNode",false)
	if self:CheckFarmerForbiden(1) then
		self:setForbiden(true)
		self:setNodeVisible("maxNode",true)
	end
end

function CharacterSelNode:onTouchGameMap(message)
	if self._currentCreateNum <= 0 then 
		return 
	end

	local pos = message.pos

	local data =
	{
		command="createActor",
		team = actor_team.team_player,
		id= self._data.id,
		pos=pos,
		num=self._currentCreateNum,
		level = self._iLevel
	}

	if not ActorManager.createActors(data) then
		return
	end
	
	self._currentCreateNum = 0

	self._createNum:setSpriteFrame( string.format("pixel_number%d.png",0))

	local this = self
	self._startCD = true

	self._mask:setPercent(100)
	self._curCDTime = self._data.CDTime

    self:setNodeVisible("createNum",false)

	self._showCD = true
	
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
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_RefreshTryMoney,{cancel=1})
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_RefreshBattleCoins)
end

function CharacterSelNode:_update(dt)
	if not self._startCD then
		return
	end

	if self._isPause then
		return
	end

	self._curCDTime = self._curCDTime - dt
	if self._curCDTime <= 0 then
		self._showCD = false
		self:setNodeVisible("maxNode",false)
		if self:CheckFarmerForbiden(1) then
			self:setForbiden(true)
			self:setNodeVisible("maxNode",true)
		else
			local curCost = _GModel.PlayerManager:GetPlayerCoins()
			local prepareMoney = _GModel.PlayerManager:GetPrepareMoney()

			self:setForbiden(curCost + prepareMoney < self._data.cost)
		end

		self._startCD = false

		return
	end

	local ratio =  self._curCDTime/self._data.CDTime
	if ratio <= 0 then
		ratio = 0
	end

	self._mask:setPercent(ratio*100)
end

function CharacterSelNode:setForbidenByMoney(money)
	if not self._isUnLock then
		return
	end

	self:setNodeVisible("maxNode",false)
	if self:CheckFarmerForbiden(1) then
		self:setForbiden(true)
		self:setNodeVisible("maxNode",true)
		return
	end

	self:setForbiden(money < self._data.cost)
end

function CharacterSelNode:Pause(isPause)
	self._isPause = isPause
end

function CharacterSelNode:setForbiden(forbid)
	if self._isUnLock and not forbid then
		self._forbiden = forbid
	else
		self._forbiden = forbid
	end

	self:setNodeVisible("forbiden",self._forbiden)
end

function CharacterSelNode:setComponentActive(name,isSelect,id)

	local params = 
	{
		id = id,
		Component = name,
		active = isSelect,
	}

	QueueEvent(EventType.ScriptEvent_SetComponentActive,params)
end

return CharacterSelNode