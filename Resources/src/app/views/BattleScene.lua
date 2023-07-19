local BattleScene 	= class("BattleScene", cc.load("mvc").ViewBase,_GModel.IBaseInterface,_GModel.IMsgInterface)
local configManager    = TWRequire("ConfigDataManager")
local CharacterSelNode = TWRequire("CharacterSelNode")
local MapScaleHandler  = TWRequire("MapScaleHandler")
local PutSelNode    = TWRequire("PutSelNode")
local BagItemNode   = TWRequire("BagItemNode")
local common 		= TWRequire("common")
local ConstCfg 		= TWRequire("ConstCfg")
local Vector2D 		= TWRequire("Vector2D")
local SimpleAniNode = TWRequire("SimpleAniNode")
local SkillNodeHandler = TWRequire("SkillNodeHandler")
local GolemNodeHandler = TWRequire("GolemNodeHandler")
local GolemLevelStart = 6

local SimulateTouchType = 
{
	TouchNone = 1,
	TouchAmply = 2,
	TouchSmall = 3
}

local GameState = 
{
	StateBuyAndSell = 1,
	GameStart = 2,
}

local BuyAndSellState = 
{
	Buy = 1,
	Sell = 2
}

local SelectedFrameMap1 = 
{
	["Troops"]  = "btnSoldierSelected",
	["Fotress"] = "btnBuildingSelected"
}

local SelectedFrameMap2 = 
{
	["Buy"] = "btnBuySelected",
	["Sell"] = "btnSellSelected"
} 

local SimulatorTouchTime = 0.5

local PopValidColor = cc.c4b(73,244,73,255)
local PopInValidColor = cc.c4b(216,177,17,255)

local function sortBuilding(a,b)
	return ConstCfg.buildingShowPrio[a.data.id] < ConstCfg.buildingShowPrio[b.data.id]
end

function BattleScene:onCreate()
	self:load("UI/Senes/BattleScene.csb")
	self:_scheduleUpdate()
	self:_initTouches()
	self:_initKeyBoard()
	self:_initMouseEvent()
	self:initKeyPressCallback()
	self:initMsg()
	self:initEvents()
	self:initUI()
	self:initSimulatorTouch()
end

function BattleScene:_init(data)
	self._level = data.level
	self._playAni = data.playAni
	self._totalPop = 0
	self._curPop = 0

	self._gameLoadedFinish = false
	self._curChaSelect =  {}
	self._difficulty = data.difficulty

	self._uiLoadingNode = cc.CSLoader:createNode("UI/Senes/SceneLoadingNode.csb")
	self._uiLoadingTimeline = cc.CSLoader:createTimeline("UI/Senes/SceneLoadingNode.csb")
	self:addChild(self._uiLoadingNode)
	self._uiLoadingNode:runAction(self._uiLoadingTimeline)

	if data.playAni then
		 self:setSceneNodeVisible("LoadingNode",true,self._uiLoadingNode)
   		 self:playSceneNodeTimeLine(self._uiLoadingTimeline,"endLoading",false)
	end

	self:startGame()
	
	self:refreshCharacterLV()
	self:refreshBuildingLV()
	self:refreshPutSoldierLV()

	self:resizeImgs(self._WinSize)

	_GModel.PlayerManager:SetPrepareMoney(0)
	_GModel.PlayerManager:SetPreparePop(0)
end

function BattleScene:initSimulatorTouch()
	self._CurSimulatorTime = 0
	self._SimulatorTouchType = SimulateTouchType.TouchNone
	self._SimulatorTouchPoint = cc.p(0,0)
	self._SimulatorTouchP1 = cc.p(0,0)
	self._SimulatorTouchP2 = cc.p(0,0)
	self._SimulatorTouchDir1 = cc.p(-1,0)
	self._SimulatorTouchDir2 = cc.p(1,0)
	self._SimulatorSpeed = 300
end

function BattleScene:_Release()
	self._selectSoldierAni:setVisible(false)

	self._curChaSelect =  {}
	self._curBagItemNode = nil
	self._curNewbieCmdId = nil
    self._curNewbieCmds = nil
    self._NewbieEventMap = nil

    if self._SkillNodeHandler then
    	self._SkillNodeHandler:Release()
    end

    self._SkillNodeHandler = nil

    if self._GolemNodeHandler then
    	self._GolemNodeHandler:Release()
    end

    self._GolemNodeHandler = nil

    if self._BattleSceneNewbieHandler then
    	self._BattleSceneNewbieHandler:Release()
    end

    self._BattleSceneNewbieHandler = nil

	_GModel.PlayerManager:SetPrepareMoney(0)
	_GModel.PlayerManager:SetPreparePop(0)
	_GModel.PlayerManager:SetCurSelectId(0)

	for _,putNode in pairs(self._PutNodeList) do
		putNode:Release()
	end

	self._PutNodeList = {}

	for _,charNode in pairs(self._characterList) do
		charNode:Release()
	end

	self._characterList = {}
end

function BattleScene:initMsg()
	self:addListener(MessageDef_GameLogic.MSG_ShowSceneNode,self.onShowSceneNode)
	self:addListener(MessageDef_GameLogic.MSG_GameOver,self.onGameOver)
	self:addListener(MessageDef_GameLogic.MSG_Restart,self.onRestart)
	self:addListener(MessageDef_GameLogic.MSG_PlayBattleSceneAni,self.onPlaySceneAni)
	self:addListener(MessageDef_GameLogic.MSG_RefreshBattleCoins,self.onRefreshCoins)
	self:addListener(MessageDef_GameLogic.MSG_RefreshTryMoney,self.onTryPutMoney)
	self:addListener(MessageDef_GameLogic.MSG_OnShow_Bag,self.onShowBag)
	self:addListener(MessageDef_GameLogic.MSG_Refresh_CharacterList,self.OnRefreshCharacterList)
end

function BattleScene:initEvents()
	RegisterEventListener(EventType.ScriptEvent_GameCmd,handler(self,self.onGameCmdEvent))
end

function BattleScene:initUI()
	self._uiSceneNode = cc.CSLoader:createNode("UI/Senes/BattleSceneUINode.csb")
	self._uiSceneTimeline = cc.CSLoader:createTimeline("UI/Senes/BattleSceneUINode.csb")
	self:addChild(self._uiSceneNode)
	self._uiSceneNode:runAction(self._uiSceneTimeline)

	self._CharacterLV = self:getSceneNode(self._uiSceneNode,"LVCharacterSelect")
	self._PutBuildingLV  = self:getSceneNode(self._uiSceneNode,"LVPutBuilding")
	self._PutSoldierLV   = self:getSceneNode(self._uiSceneNode,"LVPutSoldier")
	self._EnemyMoneyText = self:getSceneNode(self._uiSceneNode,"EnemyMoneyText")
	self._LVBG   = self:GetSceneNodeListView(self._uiSceneNode,"LVBG")
	self._BtnBag = self:getSceneNode(self._uiSceneNode,"btnBag")
	self._NewbieNode = self:getSceneNode(self._uiSceneNode,"NewbieNode")
	self._PanelNewbie = self:getSceneNode(self._uiSceneNode,"PanelNewbie")

	self._BtnBagSelected = false

	self._Pause = false
	self._PutNodeList = {}

	local director = cc.Director:getInstance()
	self._WinSize = director:getWinSize()
	self._Center = Vector2D.new(self._WinSize.width * 0.5,self._WinSize.height * 0.5)

	local moveNode = self:getNode("moveNode")
	local skillNode = self:getSceneNode(self._uiSceneNode,"SkillNode")
	self._SkillNodeHandler = SkillNodeHandler.new(skillNode)
	self._MapScaleHandler = MapScaleHandler.new(moveNode)

	self:addSceneNodeBtnClickListener("BtnSelectSoldier",self.OnSelectSoldier,self._uiSceneNode)
	self:addSceneNodeBtnClickListener("BtnGM",self.onShowGMPage,self._uiSceneNode)
	self:addSceneNodeBtnClickListener("BtnPause",self.onPause,self._uiSceneNode)
	self:addSceneNodeBtnClickListener("btnBuy",self.OnStateBuy,self._uiSceneNode)
	self:addSceneNodeBtnClickListener("btnSell",self.OnStateSell,self._uiSceneNode)
	self:addSceneNodeBtnClickListener("btnStart",self.OnStateStart,self._uiSceneNode)
	self:addSceneNodeBtnClickListener("btnSoldier",self.onSelectSoldierLV,self._uiSceneNode)
	self:addSceneNodeBtnClickListener("btnBuilding",self.onSelectBuildingLV,self._uiSceneNode)
	self:addSceneNodeBtnClickListener("btnStudy",self.onRestartNewbie,self._uiSceneNode)

	self:addBtnClickListener("btnSure",self.onBtnBuyAndSellSure)
	self:addBtnClickListener("btnCancel",self.onBtnBuyAndSellCancel)
	self:addSceneNodeBtnClickListener("btnCancelPut",self.onBtnCancelPut,self._uiSceneNode)
	self:addSceneNodeBtnClickListener("btnBag",self.onBtnBag,self._uiSceneNode)
	
	self:initTextWarningAni()

	self:setSceneNodeVisible("BtnGM",SHOW_GM,self._uiSceneNode)
	self:setSceneNodeVisible("PanelNewbie",false,self._uiSceneNode)
	self._selectSoldierAni = SimpleAniNode.new("UI/InGame/selectAni5.csb")
	self._selectSoldierAni:setScaleX(0.75)
	self._selectSoldierAni:setScaleY(0.8)
	self:addChildNode("BtnSelectSoldier",self._selectSoldierAni)
	
	self._selectSoldierAni:setPosition(cc.p(60,60))
	self._selectSoldierAni:setVisible(false)
	self._ItemAskNode = self:getSceneNode(self._uiSceneNode,"ItemAskNode")

	self._DecisiveTimeAni = SimpleAniNode.new("UI/InGame/DecisiveAniNode.csb")
	self._DecisiveTimeAni:setPosition(cc.p(0,0))
	self._DecisiveTimeAni:stop()
	self._DecisiveTimeAni:setNodeVisibleLang("TextDecisive")
	self:addChildNode("UIEffectNode",self._DecisiveTimeAni)
	self._CurDecisiveTime = 0

	self:setSceneNodeVisibleLang("btn_text_study",true,self._uiSceneNode)
	self:setSceneNodeVisibleLang("btn_text_buy",true,self._uiSceneNode)
	self:setSceneNodeVisibleLang("btn_text_sell",true,self._uiSceneNode)
	self:setSceneNodeVisibleLang("btn_text_start",true,self._uiSceneNode)
	self:setSceneNodeVisibleLang("btn_text_troops",true,self._uiSceneNode)
	self:setSceneNodeVisibleLang("btn_text_fotress",true,self._uiSceneNode)
	self:setSceneNodeVisibleLang("BagPanelNoItems",true,self._uiSceneNode)
	self:setSceneNodeVisibleLang("select_troop_frame",true,self._uiSceneNode)
end

function BattleScene:relocate()

end

function BattleScene:resizeImgs(winSize)
	self:resetLocationByRatio("LoadingNode",self._uiLoadingNode)
	self:resetLocationByRatio("BtnPause",self._uiSceneNode)

	self:setNodeContentSize("loadingBackground",winSize,self._uiLoadingNode)
	self:setPositionByDeltaTR("PanelBtnSelect",self._uiSceneNode)
	self:setPositionByDeltaTR("btnSoldier",self._uiSceneNode)
	self:setPositionByDeltaTR("btnBuilding",self._uiSceneNode)
	self:setPositionByDeltaTR("BtnSelectSoldier",self._uiSceneNode)

	self:setPositionByDeltaTR("newbieBtnTroops",self._uiSceneNode)
	self:setPositionByDeltaTR("newbieBtnFotress",self._uiSceneNode)
	self:setPositionByDeltaTR("newbieBtnSell",self._uiSceneNode)
	self:setPositionByDeltaTR("newbieBtnStart",self._uiSceneNode)


	self:setPositionByDeltaTR("newbiePanelSoldier1",self._uiSceneNode)
	self:setPositionByDeltaTR("newbiePanelSoldier2",self._uiSceneNode)
	self:setPositionByDeltaTR("newbiePanelSoldier3",self._uiSceneNode)
	self:setPositionByDeltaTR("newbiePanelMoney",self._uiSceneNode)
	self:setPositionByDeltaTR("newbiePanelPop",self._uiSceneNode)
	
	self:setPositionByDeltaRight("btnCancelPut",self._uiSceneNode)
	self:setPositionByDeltaRight("bagNode",self._uiSceneNode)
end

function BattleScene:initNewbieNode()
   	local BattleSceneNewbieHandler = TWRequire("BattleSceneNewbieHandler")
   	if self._BattleSceneNewbieHandler then
   		self._BattleSceneNewbieHandler:Release()
   	end
	self._BattleSceneNewbieHandler = nil

	local levelData = _GModel.LevelManager:getLevelData(self._level)
	if levelData and levelData.newbieId then
		local params = 
		{
			center = self._Center,
			parentNode = self,
			NewbieNode = self._NewbieNode,
			PanelNewbie = self._PanelNewbie,
			levelData = levelData,
			winSize = self._WinSize
		}

		self._BattleSceneNewbieHandler = BattleSceneNewbieHandler.new(params) 
	end


	local showBtnStudy = self._level == 1 and self._BattleSceneNewbieHandler == nil
	self:setSceneNodeVisible("btnStudy",showBtnStudy,self._uiSceneNode)
end

function BattleScene:initTextWarningAni()
	self:setSceneNodeVisibleLang("TextItemWarning",true, self._uiSceneNode)
	self._TextItemWarning = self:getSceneNode(self._uiSceneNode,"warnItemNode")
	local textItemWarning = self:getSceneNodeLang("TextItemWarning",self._uiSceneNode)
	local act1 = cc.Show:create()
    local act2 = cc.DelayTime:create(0.5)
    local act3 = cc.Hide:create()
    local act4 = cc.DelayTime:create(0.5)

    local actSeq = cc.Sequence:create(act1,act2,act3,act4)
    local action = cc.RepeatForever:create(actSeq)
    textItemWarning:stopAllActions()
    textItemWarning:runAction(action)
    self._TextItemWarning:setVisible(false)
end

function BattleScene:setComponentActive(name,isSelect,id)

	local params = 
	{
		id = id,
		Component = name,
		active = isSelect,
	}

	QueueEvent(EventType.ScriptEvent_SetComponentActive,params)
end

function BattleScene:OnStateBuy()
	self._BuyAndSellState = BuyAndSellState.Buy

	local data =
	{
		command="ChangeGameState",
		subCmd  =  "changeBuyAndSell",
		state = BuyAndSellState.Buy
	}

	self:ShowSelectNode(true)
	self:setNodeVisible("PutActorNode",false)
	self:setSceneNodeVisible("playerCreateAreaNode",false,self._uiSceneNode)

	self:ShowSelectTroopFrame("Buy",SelectedFrameMap2)

	TriggerEvent(EventType.ScriptEvent_GameCommand,data)
end

function BattleScene:onEventPlaySceneAni(data)
	local newData = {}
	newData.ani = data.ani
	newData.loop =  tonumber(data.loop)==1 and true or false
	newData.isUINode = tonumber(data.isUINode)==1 and true or false
	
	self:onPlaySceneAni(newData)
end

function BattleScene:onPlaySceneAni(data)
	if data and data.ani then

		if data.isUINode then
			self:playSceneNodeTimeLine(self._uiSceneTimeline,data.ani,data.loop or false)
		else
			self:playTimeLine(data.ani,data.loop or false)
		end
	end
end

function BattleScene:ShowSelectTroopFrame(str,SelectedFrameMap)
	for k,v in pairs(SelectedFrameMap) do
		self:setSceneNodeVisible(v,k == str,self._uiSceneNode)
	end
end


function BattleScene:onTouchInBagPanel(pos)
	if not self._BtnBagSelected then return end

	local bagPanel = self:getNode("BagPannel")
	local touchRect = bagPanel:getCapInsets()

	if not cc.rectContainsPoint(touchRect,pos) then
		self._BtnBagSelected = false
		self:ShowBag(self._BtnBagSelected)
	end
end

function BattleScene:onBtnBag()
	self._BtnBagSelected = not self._BtnBagSelected

	self:ShowBag(self._BtnBagSelected)
end

function BattleScene:onShowBag(data)
	self._BtnBagSelected = data.isShow
	self:ShowBag(self._BtnBagSelected)
end

function BattleScene:ShowBag(isShow)
	self._BtnBag:setHighlighted(isShow)

	self:setNodeVisible("BagPannel",isShow)

	if isShow then
		local hasItems = false
		local selectBagHander = handler(self,self.onSelectBag)

		self._LVBG:removeAllChildren()

		for id,cfg in pairs(_GModel.items) do
			local Key = "BackpackItem_"..tostring(id)
			local packageItemCount = getPlayerSetting(Key,SettingType.TYPE_INT,0)

			if packageItemCount.Value > 0 then
				local itemNode = BagItemNode.new(cfg,packageItemCount.Value,selectBagHander)
				itemNode:SetShowMask(self._CurGameState ~= GameState.GameStart)
				self._LVBG:addChild(itemNode)
				hasItems = true
			end
		end
		self._LVBG:forceDoLayout()

		self:setNodeVisibleLang("BagPanelNoItems",not hasItems)
	else
		self._LVBG:removeAllChildren()
		self._curBagItemNode = nil
		self._ItemAskNode:removeAllChildren()
		self:setNodeVisibleLang("BagPanelNoItems",false)
	end
end


function BattleScene:OnRefreshCharacterList(data)
	if self._characterList[data.id] then
		self._characterList[data.id]:refreshFarmerForbiden()
	end
end

function BattleScene:onBtnTrap()

end

function BattleScene:onSelectBag(bagItemNode,data)
	if self._curBagItemNode then
		self._curBagItemNode:setSelect(false)
	end

	self._curBagItemNode = bagItemNode

	if self._curBagItemNode then
		self._curBagItemNode:setSelect(true)
	end

	self._curSelectItemId = nil
	self._TextItemWarning:setVisible(false)

	if data.touchScript then
		self._ItemAskNode:removeAllChildren()
		local itemAskNode = TWRequire(data.touchScript)
		local askNode = itemAskNode.new(data)
		self._ItemAskNode:addChild(askNode)
	else
		self._BtnBagSelected = false
		self:ShowBag(false)
		self._curSelectItemId = data.id
		self._TextItemWarning:setVisible(true)
	end
end

function BattleScene:onHideSelectTroop()
	self:StopTimeLine()
	self:playTimeLine("hidePanel",false)
end

function BattleScene:onShowSelectTroop()
	self:StopTimeLine()
	self:playTimeLine("showPanel",false)
end

function BattleScene:OnStateSell()
	self._BuyAndSellState = BuyAndSellState.Sell

	self:ShowSelectNode(false)
	self:setNodeVisible("PutActorNode",false)

	self:setNodesVisible({
		PutActorNode = false,
		playerCreateAreaNode = false,
	})


	local data =
	{
		command="ChangeGameState",
		subCmd  =  "changeBuyAndSell",
		state = BuyAndSellState.Sell
	}

	self:ShowSelectTroopFrame("Sell",SelectedFrameMap2)
	TriggerEvent(EventType.ScriptEvent_GameCommand,data)
end

function BattleScene:ShowSelectNode(show)
	self:setNodesVisible({
		btnSoldier = show,
		btnBuilding = show,
		PanelBtnSelect = show,
	})
end

function BattleScene:OnStateStart()
	if self._NewbieEventMap then
		local newbieEventData = self._NewbieEventMap[self.OnStateStart]
		if newbieEventData then
			newbieEventData.callback(self,newbieEventData.params)
			self._NewbieEventMap[self.OnStateStart]  = nil
			self:setNodeVisible("PanelNewbie",true)

			self._Pause = true
			gMessageManager:sendMessage(MessageDef_GameLogic.MSG_PauseGame,{isPause = true})
		end
	end

	self._CurGameState = GameState.GameStart
	self:setNodesVisible({
		PanelBuyAndSell = false,
		LVPutBuilding = false,
		LVCharacterSelect = true,
		LVPutSoldier = false,
		btnSoldier = false,
		btnBuilding = false,
		PutActorNode = false,
    	BtnSelectSoldier = true,
    	bagNode = true,
    	playerCreateAreaNode = false,
    	PanelBtnSelect = true
	})

	local data =
	{
		command="ChangeGameState",
		subCmd  =  "changeGameState",
		state = GameState.GameStart
	}

	_GModel.PlayerManager:SetPrepareMoney(0)
	_GModel.PlayerManager:SetPreparePop(0)

	self:setNodeVisible("bagNode",self._Level ~=1)
	self:setNodeVisible("GolemNode",self._showGolem)

	self._Pause = false

	TriggerEvent(EventType.ScriptEvent_GameCommand,data)
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_GameStart)

	cc.AudioEngine:stopAll()

	gRootManager:AddTimer(2,false,function( ... )
		QueueEvent(EventType.ScriptEvent_Sound,{id = self._curLevelData.BGMusic,type="music"})
	end)

	self._BtnBagSelected = false
	self:ShowBag(false)
	QueueEvent(EventType.ScriptEvent_Sound,{id = "GameStartHorn"})

	local levelTips = self._curLevelData.Tips
	if levelTips then
		local isUnlockTips = cc.UserDefault:getInstance():getBoolForKey("Tips"..levelTips.id,false)

		if not isUnlockTips then
			gRootManager:OpenPage(levelTips.page,{id = levelTips.id})
		end
	end

	self._CurDecisiveTime = ConstCfg.Decisive_Time*60
	local str = common:format_time(self._CurDecisiveTime)
	self:setLabelText("TextDecisiveBattle",str,self._uiSceneNode)
	self._DecisiveTimeAni:stop()

	if self._GolemNodeHandler then
		 self._GolemNodeHandler:Start()
	end
end

function BattleScene:onSelectSoldierLV()
	self:setNodeVisible("LVPutBuilding",false)
	self:setNodeVisible("LVPutSoldier",true)
	self:ShowSelectTroopFrame("Troops",SelectedFrameMap1)
end

function BattleScene:onSelectBuildingLV()
	self:setNodeVisible("LVPutBuilding",true)
	self:setNodeVisible("LVPutSoldier",false)
	self:ShowSelectTroopFrame("Fotress",SelectedFrameMap1)
end

function BattleScene:onSelectCharacterCallback(selNode)
	self._curChaSelect[selNode] = true
end

function BattleScene:onRestartNewbie()
	setPlayerSetting("newbieCmd_"..tostring(self._level.newbieId),SettingType.TYPE_BOOL,false)

	self:initNewbieNode()
end

function BattleScene:refreshCharacterLV()
	local characters = configManager:getModByProperty("Characters","team",actor_team.team_player)

	local charactersUnlcok = {}
	local charactersLock = {}

	for _,v in ipairs(characters) do
		local isForbiden =  not not self._forbidenList[v.id]
		local isForbidenUse = not not self._forbidenUseList[v.id]

		if not v.isGuard and not isForbiden and not isForbidenUse then
			local temp = getPlayerSetting("unit_unlock_"..tostring(v.id),SettingType.TYPE_BOOL,false)
			local data =  {}
			data.cfg = v
			data.unlock = temp.Value

			if temp.Value then
				table.insert(charactersUnlcok,data)
			else
				table.insert(charactersLock,data)
			end
		end
	end

	table.sort( charactersUnlcok,function( a,b )
		return a.cfg.showPriority < b.cfg.showPriority
	end )

	table.sort( charactersLock,function( a,b )
		return a.cfg.showPriority < b.cfg.showPriority
	end )

	local selectCb = handler(self,self.onSelectCharacterCallback)
	local allList = charactersUnlcok

	self._CharacterLV:removeAllChildren()
	self._characterList = {}

	for _,cha in ipairs(allList) do
		local charNode = CharacterSelNode.new(cha.cfg,cha.unlock,selectCb)
		self._CharacterLV:addChild(charNode)
		self._characterList[cha.cfg.id] = charNode
	end

	self._CharacterLV:forceDoLayout()
end

function BattleScene:getChaSelNode(id)
	return self._characterList[id]
end

function BattleScene:refreshBuildingLV()
	local buildings = configManager:getMod("Buildings")
	local traps = configManager:getMod("Traps")
	local upGradeCfgs = configManager:getMod("Upgrade")

	local upGradeCfgs = configManager:getMod("Upgrade")
	local upGradeCfgsMap = {}

	for _,v in ipairs(upGradeCfgs) do
		upGradeCfgsMap[v.id] = v
	end

	local fortressList = {}
	local fortressListUnlock = {}

	for _,fortress in pairs(buildings) do
		local isForbiden =  not not self._forbidenList[fortress.id]
		local isForbidenUse = not not self._forbidenUseList[fortress.id]

		if fortress.team == actor_team.team_player and fortress.cost and not isForbiden and not isForbidenUse then
			local temp = getPlayerSetting("unit_unlock_"..tostring(fortress.id),SettingType.TYPE_BOOL,false)
			local data =  {}
			data.data = fortress
			data.unlock = temp.Value

			if temp.Value then
				table.insert(fortressList,data)
			else
				table.insert(fortressListUnlock,data)
			end
		end
	end

	table.sort( fortressList,sortBuilding)
	table.sort( fortressListUnlock,sortBuilding)

	local allList = common:table_merge_by_order(fortressList,fortressListUnlock)

	self._PutBuildingLV:removeAllChildren()

	for _,fortress in ipairs(fortressList) do
		local fortressNode = PutSelNode.new(fortress.data,fortress.unlock,upGradeCfgsMap[fortress.data.upID])
		self._PutBuildingLV:addChild(fortressNode)
		table.insert(self._PutNodeList,fortressNode)
	end

	self._PutBuildingLV:forceDoLayout()
end

function BattleScene:refreshPutSoldierLV()
	local characters = configManager:getModByProperty("Characters","team",actor_team.team_player)

	local charactersUnlcok = {}

	for _,v in ipairs(characters) do
		local isForbiden =  not not self._forbidenList[v.id]
		local isForbidenUse = not not self._forbidenUseList[v.id]

		if v.profession ~= actor_profession.prof_farmer and v.isGuard and not isForbiden and not isForbidenUse then
			local temp = getPlayerSetting("unit_unlock_"..tostring(v.id),SettingType.TYPE_BOOL,false)
			if temp.Value then
				local data =  {}
				data.cfg = v
				data.unlock = temp.Value
				table.insert(charactersUnlcok,data)
			end
		end
	end

	table.sort( charactersUnlcok,function( a,b )
		return a.cfg.showPriority < b.cfg.showPriority
	end )

	local allList = charactersUnlcok

	self._PutSoldierLV:removeAllChildren()

	for _,cha in ipairs(allList) do
		local charNode = PutSelNode.new(cha.cfg,cha.unlock)
		self._PutSoldierLV:addChild(charNode)
		table.insert(self._PutNodeList,charNode)
	end

	self._PutSoldierLV:forceDoLayout()
end

function BattleScene:startGame()
	self._curLevelData = nil
	local levelData = _GModel.LevelManager:getLevelData(self._level)
	if levelData then
		self._CurGameState = GameState.StateBuyAndSell
		self._BuyAndSellState = BuyAndSellState.Buy
		self._BuyAndSellId = nil

		local app = cc.Application:getInstance()
		local target = app:getTargetPlatform()

		self.showGraph = false

		self:setNodesVisible({
    		mapNode = not self.showGraph,
    		drawNode = self.showGraph,
    		PutActorNode = false,
    	})

    	self:setSceneNodesVisible({
    		PanelBuyAndSell = true,
    		LVPutBuilding = false,
    		LVPutSoldier = true,
    		LVCharacterSelect = false,
    		PanelCharacterInfo = false,
    		BtnSelectSoldier = false,
    		bagNode = true,
    		BagPannel = false,
    		btnCancelPut = false,
    		SkillNode = false,
    		GolemNode = false,
    		warnItemNode = false,
    		NewbieWarnItemNode = false,
    	},self._uiSceneNode)

    	self:ShowSelectTroopFrame("Troops",SelectedFrameMap1)
    	self:ShowSelectTroopFrame("Buy",SelectedFrameMap2)

    	local copyLevelData = common:table_simple_copy(levelData)
    	copyLevelData.difficulty = self._difficulty

		QueueEvent(EventType.ScriptEvent_StartGame,copyLevelData)
		QueueEvent(EventType.ScriptEvent_Sound,{id = levelData.prepareMusic,type="music"})

		self._gameLoadedFinish = false
		if not SHOW_GM then
			self:setComponentActive("SpriteAniComponent",true)
			self:setComponentActive("MoveSpriteComponent",true)
			self:setComponentActive("SpineComponent",true)
			self:setComponentActive("BuildingComponent",true)

			local data1 = 
			{
				nodeName = "mapNode",
				isShow = true
			}

			local data2 = 
			{
				nodeName = "drawNode",
				isShow = false
			}

			gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)
			gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data2)
		end

		_GModel.LevelManager:setCurLevel(self._level)
		_GModel.PlayerManager:SetCurSelectId(0)
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_PauseGame,{isPause = false})
	end

	self._CurDecisiveTime = ConstCfg.Decisive_Time*60
	local str = common:format_time(self._CurDecisiveTime)
	self:setLabelText("TextDecisiveBattle",str,self._uiSceneNode)

	self._showGolem = false

	self._curLevelData = levelData
	local forbidenList = levelData.forbidenList
	local forbidenUseList = levelData.hardFofbidUse

	self._forbidenList = {}
	self._forbidenUseList = {}

	if forbidenList and next(forbidenList) then
		for _,id in ipairs(forbidenList) do
			self._forbidenList[id] = true
		end
	end

	if forbidenUseList and next(forbidenUseList) and self._difficulty == level_difficulty.level_difficulty_hard then
		for _,id in ipairs(forbidenUseList) do
			self._forbidenUseList[id] = true
		end
	end
end

function BattleScene:onGameOver()
	local function EventGameOver()
		local data =
		{
			command="GameOver",
		}

		QueueEvent(EventType.ScriptEvent_GameCommand,data)
	end

	self._uiLoadingTimeline:stop()

    self:setSceneNodeVisible("LoadingNode",true,self._uiLoadingNode)
    self:playSceneNodeTimeLine(self._uiLoadingTimeline,"startLoading",false,EventGameOver)
end

function BattleScene:initKeyPressCallback()
	self:setKeyPressedCallback(cc.KeyCode.KEY_CTRL,cc.KeyCode.KEY_G,self.onShowGMPage) --按键组合
	self:setKeyPressedCallback(cc.KeyCode.KEY_ESCAPE,self.onHideTopPage)
	self:setKeyPressedCallback(cc.KeyCode.KEY_S,self.OnSimulateSmall)
	self:setKeyPressedCallback(cc.KeyCode.KEY_A,self.OnSimulateAmply)
end

function BattleScene:_onSingleTouchMoved(pos,delta)
	if not self._gameLoadedFinish then return end

	--self:offsetPosition("moveNode",delta)
	local mapNode = self:getNode("mapNode")
	local nodePos = mapNode:convertToNodeSpace(pos)

	TriggerEvent(EventType.ScriptEvent_Touch,{type=touch_type.single_touch_move,pos = nodePos,delta=delta})
end

function BattleScene:_onMultiTouchMoved(touchesPos,touchesDeltas)
	if not self._gameLoadedFinish then return end

	if self._MapScaleHandler then
		self._MapScaleHandler:OnTouchesMoved(touchesPos,touchesDeltas)
	end
end

function BattleScene:_onMultiTouchEnd(touchesPos)
	if not self._gameLoadedFinish then return end

	if self._MapScaleHandler then
		self._MapScaleHandler:OnTouchesEnd()
	end
end

function BattleScene:_onKeyRelease(keyStr)
	if not self._gameLoadedFinish then return end

	Log("BattleScene:_onKeyRelease key =%s",keyStr)
	QueueEvent(EventType.ScriptEvent_KeyEvent,{keyCode = keyStr})
end

function BattleScene:processTouchItem(nodePos)
	if self._curSelectItemId then
		gMessageManager:sendMessage(MessageDef_GameLogic.Msg_OnItem_Event,{id = self._curSelectItemId,pos=nodePos})
		self._TextItemWarning:setVisible(false)
		self._BtnBagSelected = false
		self:ShowBag(false)

		local Key = "BackpackItem_"..tostring(self._curSelectItemId)
		local packageItemCount = getPlayerSetting(Key,SettingType.TYPE_INT,0)
		local count = packageItemCount.Value - 1
		setPlayerSetting(Key,SettingType.TYPE_INT,count)
		self._curSelectItemId = nil
	end
end

function BattleScene:_onSingleTouchBegin(pos)
	if not self._gameLoadedFinish then return end

	-- print("BattleScene:_onSingleTouchBegin")

	if self._NewbieId then
		if self._NewbieTaskList and next(self._NewbieTaskList) then
			local taskData = self._NewbieTaskList[1]

			local nodeRect = cc.rect(taskData.x,taskData.y,taskData.width,taskData.height)
			if cc.rectContainsPoint(nodeRect,pos) then
				local CB = self[taskData.callback]
				if CB then
					table.remove(self._NewbieTaskList,1)
					CB(taskData.nextId)
					self:setNodeVisible("PanelNewbie",false)
				end
			end
		end
	end

	self:onTouchInBagPanel(pos)

	local mapNode = self:getNode("mapNode")
	local nodePos = mapNode:convertToNodeSpace(pos)

	if self._SkillNodeHandler:GetCanPutSkill() then
		self._SkillNodeHandler:PutSkill(nodePos)
		return
	end

	self:processTouchItem(nodePos)

	if _GModel.PlayerManager:GetPrepareMoney() > 0 then
		 local data2 =
		{
			command="onCommandDeSelectCtrl",
		}

		TriggerEvent(EventType.ScriptEvent_GameCommand,data2)
	end

	TriggerEvent(EventType.ScriptEvent_Touch,{type=touch_type.single_touch_begin,pos=nodePos,realPos = pos })
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_TouchMapPos,{pos = nodePos})

	if self._MapScaleHandler then
		self._MapScaleHandler:OnTouchesBegin(pos)
	end
end

function BattleScene:_onSingleTouchEnd(pos)
	if not self._gameLoadedFinish then return end

	local mapNode = self:getNode("mapNode")
	local nodePos = mapNode:convertToNodeSpace(pos)

	TriggerEvent(EventType.ScriptEvent_Touch,{type=touch_type.touch_end,pos=nodePos})

	self:setSpriteNum("pixel_number%d.png",self._curPop,"currentP_%s",self._uiSceneNode)

	_GModel.PlayerManager:SetPreparePop(0)
end

function BattleScene:onShowGMPage()
	gRootManager:OpenPage("GMPage")
end

function BattleScene:onHideTopPage()
	gMessageManager:sendMessage(MessageDef_RootManager.MSG_CloseCurPage)
end

function BattleScene:onScaleGameMap(scaleDelta)
	if self._MapScaleHandler then
		self._MapScaleHandler:OnScaleMap(scaleDelta)
	end
end

function BattleScene:onGameCmdEvent(data)
	local cmdStr = data.funcName
	local func 	 = self[cmdStr]
	if func then
		func(self,data)
	end
end

function BattleScene:_update(dt)
	if self._Pause then return end

	if self._MapScaleHandler then
		self._MapScaleHandler:Update(dt)
	end

	if self._SkillNodeHandler then
		self._SkillNodeHandler:update(dt)
	end

	if self._GolemNodeHandler then
		self._GolemNodeHandler:update(dt)
	end

	for _,cha in pairs(self._characterList) do
		cha:update(dt)
	end

	self:UpdateSimpluator(dt)

	self:UpdateDecisiveTime(dt)
end

function BattleScene:onShrinkMap()
	self:onScaleGameMap(-1)
end

function BattleScene:onMagnifyMap()
	self:onScaleGameMap(1)
end

function BattleScene:onSkillNodeEvent(data)
	if data.cmd == "set" then
		self._SkillNodeHandler:SetDamge(tonumber(data.damage))
		self._SkillNodeHandler:SetCDTime(tonumber(data.CDTime))
		self._SkillNodeHandler:SetOwnerId(tonumber(data.id))
	elseif data.cmd == "start" then
		self._SkillNodeHandler:Start()
	elseif data.cmdd == "stop" then
		self._SkillNodeHandler:Stop()
	end
end

function BattleScene:releaseGolemHander()
	if self._GolemNodeHandler then
    	self._GolemNodeHandler:Release()
    end
    self._GolemNodeHandler = nil
end

function BattleScene:onGolemNodeEvent(data)
	if data.cmd == "show" then
		self:releaseGolemHander()
		local golemNode = self:getSceneNode(self._uiSceneNode,"GolemNode")
		local golMask = self:getSceneNode(self._uiSceneNode,"SpGolemMask")
		self._GolemNodeHandler = GolemNodeHandler.new(golemNode,golMask)
		self._showGolem = true
	elseif data.cmd == "hide" then
	    self:releaseGolemHander()
		self:setSceneNodeVisible("GolemNode",false,self._uiSceneNode)
		self._showGolem = false
	elseif data.cmd == "CDTime" then
		if self._GolemNodeHandler then
			self._GolemNodeHandler:SetCDTime(tonumber(data.value))
		end
	end
end

function BattleScene:onShowSceneNode(data)
	local nodeName = data.nodeName
	local isShow   = data.isShow
	self:setNodeVisible(nodeName,isShow)
end

function BattleScene:onEventShowSceneNode(data)	
	local newData = {}
	newData.nodeName = data.nodeName
	newData.isShow = tonumber(data.isShow) == 1
	self:onShowSceneNode(newData)
end

function BattleScene:onBtnCancelPut()
	for selNode,_ in pairs(self._curChaSelect) do
		selNode:CancelSelect()
	end

	self:setNodeVisible("btnCancelPut",false)

	self._curChaSelect =  {}

	_GModel.PlayerManager:SetPrepareMoney(0)
	_GModel.PlayerManager:SetPreparePop(0)

	local money = _GModel.PlayerManager:GetPlayerCoins()
	local dataMoney = {}
	dataMoney.team = actor_team.team_player
	dataMoney.money = money
	self:onRefreshMoney(dataMoney)

	self:setSpriteNum("pixel_number%d.png",self._curPop,"currentP_%s",self._uiSceneNode)
end

function BattleScene:onRefreshMoney(data)
	local team = tonumber(data.team)
	local money = data.money
	local nMoney = tonumber(money)

	if team == actor_team.team_player then
		self:setSpriteNum("pixel_number%d.png",nMoney,"PlayerMoney_%s",self._uiSceneNode)
	elseif team == actor_team.team_NPC then
		self._EnemyMoneyText:setString(money)
	end

	local prepareMoney = _GModel.PlayerManager:GetPrepareMoney()

	if team == actor_team.team_player then
		_GModel.PlayerManager:SetPlayerCoins(nMoney)

		if prepareMoney > 0 then
			local deltaMoney = nMoney - prepareMoney
			self:setSpriteNum("pixel_number%d.png",deltaMoney,"PlayerMoney_%s",self._uiSceneNode)

			for _,cha in pairs(self._characterList) do
				cha:setForbidenByMoney(deltaMoney)
			end
		else
			for _,cha in pairs(self._characterList) do
				cha:setForbidenByMoney(nMoney)
			end
		end
	end
end

function BattleScene:onRefreshCoins()
	local coins = _GModel.PlayerManager:GetPlayerCoins()

	self:setSpriteNum("pixel_number%d.png",coins,"PlayerMoney_%s",self._uiSceneNode)
end

function BattleScene:onTotalPopulation(data)
	local team = tonumber(data.team)

	if team == actor_team.team_player then
		self._totalPop = tonumber(data.Pop)
		self:setSpriteNum("pixel_number%d.png",self._totalPop,"totalP_%s",self._uiSceneNode)

		self:setNodeColor("currentP",self._curPop <= self._totalPop and PopValidColor or PopInValidColor,self._uiSceneNode)
	else
		self:setLabelText("EnemyTotalPopText",data.Pop,self._uiSceneNode)
	end
end

function BattleScene:onCurPopulation(data)
	local team = tonumber(data.team)

	local preparePop = _GModel.PlayerManager:GetPreparePop()

	if team == actor_team.team_player then
		self._curPop = tonumber(data.Pop)

		self:setSpriteNum("pixel_number%d.png",data.Pop + preparePop,"currentP_%s",self._uiSceneNode)

		self:setNodeColor("currentP",(self._curPop + preparePop) <= self._totalPop and PopValidColor or PopInValidColor,self._uiSceneNode)
	else
		self:setLabelText("EnemyPopText",data.Pop,self._uiSceneNode)
	end
end

function BattleScene:onPause()
	gRootManager:OpenPage("PausePage")
end

function BattleScene:onSelectActor(data)
	self:setSceneNodeVisible("PanelCharacterInfo",tonumber(data.select) == 1,self._uiSceneNode)

	if data.select then
		local cfgId = data.configId
		local level = data.level
		local speed = data.speed
		local viewDist = data.view
		local def = data.def
		local health = data.health
		local magDef = data.magDef
		local atk = data.attack
		local name = data.name
		local team = data.team

		self:setLabelText("LLevel",level,self._uiSceneNode)
		self:setLabelText("LHealth",health,self._uiSceneNode)
		self:setLabelText("LAttack",atk,self._uiSceneNode)
		self:setLabelText("LDefence",def,self._uiSceneNode)
		self:setLabelText("LMagic",0,self._uiSceneNode)
		self:setLabelText("LMagicDefence",magDef,self._uiSceneNode)
		self:setLabelText("LView",viewDist,self._uiSceneNode)
		self:setLabelText("LSpeed",speed,self._uiSceneNode)
		self:setLabelText("LName",name,self._uiSceneNode)
		self:setLabelText("LTeam",team,self._uiSceneNode)
	end
end

function BattleScene:UpdateSimpluator(dt)
	if self._SimulatorTouchType == SimulateTouchType.TouchNone then
		return
	end

	self._CurSimulatorTime = self._CurSimulatorTime - dt
	if self._CurSimulatorTime <=0 then
		self._SimulatorTouchType = SimulateTouchType.TouchNone
		self._MapScaleHandler:OnTouchesEnd()
		return
	end

	local movePoints = {}
	local moveDeltas = {}
	local moveDelta1 = cc.pMul(self._SimulatorTouchDir1,self._SimulatorSpeed * dt)
	local moveDelta2 = cc.pMul(self._SimulatorTouchDir2,self._SimulatorSpeed * dt)
	local movePoint1 = cc.pAdd(self._SimulatorTouchP1,moveDelta1)
	local movePoint2 = cc.pAdd(self._SimulatorTouchP2,moveDelta2)

	table.insert(movePoints,movePoint1)
	table.insert(movePoints,movePoint2)

	table.insert(moveDeltas,moveDelta1)
	table.insert(moveDeltas,moveDelta2)

	if self._MapScaleHandler then
		self._MapScaleHandler:OnTouchesMoved(movePoints,moveDeltas)
	end
end

function BattleScene:UpdateDecisiveTime(dt)
	if self._CurDecisiveTime > 0 then
		self._CurDecisiveTime = self._CurDecisiveTime - dt
		if self._CurDecisiveTime <=0 then
			self._CurDecisiveTime = 0
			self._DecisiveTimeAni:play(function( ... )
				-- body
				local data =
				{
					command="onCommandFinalTime",
				}

				QueueEvent(EventType.ScriptEvent_GameCommand,data)
			end)
			QueueEvent(EventType.ScriptEvent_Sound,{id = "Stinger_Ready_For_War"})
		end

		local str = common:format_time(self._CurDecisiveTime)
		self:setLabelText("TextDecisiveBattle",str,self._uiSceneNode)
	end
end

function BattleScene:OnSelectSoldier()
	local isVisible = self._selectSoldierAni:isVisible()

	local data =
	{
		command="SelectActors",
		isSelect = not isVisible
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,data)

	self._selectSoldierAni:setVisible(not isVisible)
end

function BattleScene:onTryPutMoney(data)
	if data.cancel and tonumber(data.cancel) == 1 then
		_GModel.PlayerManager:SetPrepareMoney(0)
		return
	end 

	local iCost = tonumber(data.cost)
	local iPop = tonumber(data.pop)

if self._CurGameState == GameState.GameStart then
	_GModel.PlayerManager:AddPrepareMoney(iCost)
	_GModel.PlayerManager:AddPreparePop(iPop)
else
	_GModel.PlayerManager:SetPrepareMoney(iCost)
	_GModel.PlayerManager:SetPreparePop(iPop)
end

	local prepareMoney = _GModel.PlayerManager:GetPrepareMoney()
	local preparePop   = _GModel.PlayerManager:GetPreparePop()

	local nMoney = _GModel.PlayerManager:GetPlayerCoins()
	local deltaMoney = nMoney - prepareMoney

	self:setSpriteNum("pixel_number%d.png",deltaMoney,"PlayerMoney_%s",self._uiSceneNode)

	self:setSpriteNum("pixel_number%d.png",(self._curPop + preparePop),"currentP_%s",self._uiSceneNode)
end

function BattleScene:onGameLoadFinish()
	QueueEvent(EventType.ScriptEvent_Sound,{id = "GUITransitionOpen"})
	self:playSceneNodeTimeLine(self._uiLoadingTimeline,"endLoading",false)

	if self._curLevelData then
		QueueEvent(EventType.ScriptEvent_Sound,{id = self._curLevelData.prepareMusic,type="music"})
	end

	self._gameLoadedFinish = true

	self:initNewbieNode()
end

function BattleScene:onGameOverFinish()
	local params = { 
        playAni = true
    }

	gRootManager:ChangeScene("LevelScene",params)
end

function BattleScene:OnCheckOut(data)
	gRootManager:OpenPage("CheckOutPage",data)

	gMessageManager:sendMessage(MessageDef_GameLogic.Msg_LevelScene_EndGame)
end

function BattleScene:OnSimulateAmply()
	self._SimulatorTouchType = SimulateTouchType.TouchAmply

	self._SimulatorTouchP1 = cc.p(860,540)
	self._SimulatorTouchP2 = cc.p(1060,540)

	self._SimulatorTouchDir1 = cc.p(-1,0)
	self._SimulatorTouchDir2 = cc.p(1,0)

	self._CurSimulatorTime = SimulatorTouchTime

	if self._MapScaleHandler then
		self._MapScaleHandler:OnTouchesBegin(self._SimulatorTouchP1)
		self._MapScaleHandler:OnTouchesBegin(self._SimulatorTouchP2)
	end
end

function BattleScene:onBuyAndSellActorId(data)
	self._BuyAndSellId = tonumber(data.id)

	if self._BuyAndSellId > 0 then
		self:setNodeVisible("PutActorNode",true)

		self:setNodePosition("PutActorNode",tonumber(data.posX),tonumber(data.posY))
	end
end

function BattleScene:onSelectSoldierTouchEnd()
	self._selectSoldierAni:setVisible(false)
end

function BattleScene:onBuyAndSellValid(data)
	
	local isValid = tonumber(data.isValid)
	self:setButtonEnable("btnSure",isValid==1)
end

function BattleScene:onBuyAndSellFinish(data)
	local cmd 	 = data.Cmd
	local isSure = data.isSure

	self:setNodeVisible("PutActorNode",false)
	self:setNodeVisible("playerCreateAreaNode",false)
end

function BattleScene:onBtnBuyAndSellSure()
	self:setNodeVisible("PutActorNode",false)

	local data =
	{
		command="onCommandBuyAndSell",
		isSure = true,
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,data)

	local prepareMoney = _GModel.PlayerManager:GetPrepareMoney()

	_GModel.PlayerManager:updateCoins(prepareMoney)

	_GModel.PlayerManager:SetPrepareMoney(0)
	_GModel.PlayerManager:SetPreparePop(0)

	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_RefreshBattleCoins)
end

function BattleScene:onBtnBuyAndSellCancel()
	self:setNodeVisible("PutActorNode",false)

	local data =
	{
		command="onCommandBuyAndSell",
		isSure = false,
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,data)

	_GModel.PlayerManager:SetPrepareMoney(0)
	_GModel.PlayerManager:SetPreparePop(0)

	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_RefreshBattleCoins)
end

function BattleScene:OnSimulateSmall()
	self._SimulatorTouchType = SimulateTouchType.TouchSmall

	self._SimulatorTouchP1 = cc.p(560,540)
	self._SimulatorTouchP2 = cc.p(1360,540)

	self._SimulatorTouchDir1 = cc.p(1,0)
	self._SimulatorTouchDir2 = cc.p(-1,0)

	self._CurSimulatorTime = SimulatorTouchTime

	if self._MapScaleHandler then
		self._MapScaleHandler:OnTouchesBegin(self._SimulatorTouchP1)
		self._MapScaleHandler:OnTouchesBegin(self._SimulatorTouchP2)
	end
end

function BattleScene:onCmdScriptPause(data)
	local isPause = tonumber(data.isPause) == 1
	self._Pause = isPause
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_PauseGame,{isPause = isPause})

	if self._SkillNodeHandler then
		self._SkillNodeHandler:Pause(isPause)
	end

	if self._GolemNodeHandler then
		self._GolemNodeHandler:Pause(isPause)
	end
	
	for _,cha in pairs(self._characterList) do
		cha:Pause(isPause)
	end
end

function BattleScene:onRestart(data)
	self:setNodesVisible({
    		mapNode = not self.showGraph,
    		drawNode = self.showGraph,
    		PutActorNode = false,
    		playerCreateAreaNode = false,
    	})


	self:setSceneNodesVisible({
		mapNode = not self.showGraph,
		drawNode = self.showGraph,
		PanelBuyAndSell = true,
		LVPutBuilding = false,
		LVPutSoldier = true,
		LVCharacterSelect = false,
		PanelCharacterInfo = false,
		btnSoldier = true,
		btnBuilding = true,
    	BtnSelectSoldier = false,
    	btnCancelPut = false,
    	SkillNode = false,
	},self._uiSceneNode)

	self:_Release()
	
	local skillNode = self:getSceneNode(self._uiSceneNode,"SkillNode")
	self._SkillNodeHandler = SkillNodeHandler.new(skillNode)

	self:refreshCharacterLV()
	self:refreshBuildingLV()
	self:refreshPutSoldierLV()

	self._uiLoadingTimeline:stop()

    self:setSceneNodeVisible("LoadingNode",true,self._uiLoadingNode)
    self:setSceneNodeVisible("GolemNode",false,self._uiSceneNode)

    self._CurDecisiveTime = ConstCfg.Decisive_Time*60
    local str = common:format_time(self._CurDecisiveTime)
	self:setLabelText("TextDecisiveBattle",str,self._uiSceneNode)

	self._DecisiveTimeAni:stop()

    self._showGolem = false
    self:playSceneNodeTimeLine(self._uiLoadingTimeline,"startLoading",false,function (  )
    	-- body
    	QueueEvent(EventType.ScriptEvent_Restart)
    end)
end


return BattleScene