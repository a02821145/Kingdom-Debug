local Vector2D 		= TWRequire("Vector2D")
local SimpleAniNode = TWRequire("SimpleAniNode")
local NewbieAniNode	= TWRequire("NewbieAniNode")
local BattleSceneNewbieHandler = class("BattleSceneNewbieHandler",_GModel.IBaseInterface,_GModel.IMsgInterface)

function BattleSceneNewbieHandler:ctor(params)
	self:setSceneNode(params.parentNode)
	self._parentNode = params.parentNode
	self._curNewbieCmdId = nil
    self._curNewbieCmds = nil
    self._NewbieEventMap = nil
    self._NewbieId = nil
    self._NewbieTaskList = {}

    self._NewbieNode = params.NewbieNode
    self._PanelNewbie = params.PanelNewbie
    self._Center = params.center
    self._WinSize = params.winSize

    local levelData = params.levelData

    local temp = getPlayerSetting("newbieCmd_"..tostring(levelData.newbieId),SettingType.TYPE_BOOL,false)
	if not temp.Value then
		self._NewbieId = levelData.newbieId
		local BattleSceneNewbieCfg = TWRequire("BattleSceneNewbieCfg")
		local newBieCommands = BattleSceneNewbieCfg[levelData.newbieId]

		if newBieCommands and newBieCommands.startId then
			self._curNewbieCmdId = newBieCommands.startId
    		self._curNewbieCmds = newBieCommands
    		self:processNewbie(self._curNewbieCmdId)
		end
	end

	self._BtnNewbie = self._PanelNewbie:getChildByName("btnNewbie")
    self:addListener(MessageDef_GameLogic.MSG_OnNewbie_Event,self.OnNewbieEvent)
end

function BattleSceneNewbieHandler:OnNewbieEvent(data)
	self:processNewbie(data.id)
end

function BattleSceneNewbieHandler:onNewbieCmdShowUI(data)
	local isShow = data.value
	local nodesList = string.split(data.nodes, ",")
	if next(nodesList) then
		for _,nodeName in ipairs(nodesList) do
			self:setNodeVisible(nodeName,isShow)
		end
	end

	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = data.nextId})
end

function BattleSceneNewbieHandler:onNewbieCmdListenEvent(data)
	
	local function clickNextCallback()
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = data.nextId})
		self._parentNode:removeBtnClickListener(data.value,clickNextCallback)
	end

	self._PanelNewbie:setVisible(false)
	self._parentNode:addBtnClickListener(data.value,clickNextCallback)
end

function BattleSceneNewbieHandler:onNewbieCmdFuncCallback(data)
	if data.value == self._curEventName then
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = self._curNextId})

		self._curNextId = nil
		self._curEventName = nil
	end
end

function BattleSceneNewbieHandler:onNewbieCmdFuncEvent(data)
	local function clickNextCallback()
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = data.nextId})
		self._parentNode:removeBtnClickListener(data.value,clickNextCallback)
	end

	self._curEventName = data.value
	self._curNextId = data.nextId

	self._PanelNewbie:setVisible(false)
	gMessageManager:registerMessageHandler(MessageDef_GameLogic.MSG_NewbieCallback,handler(self,self.onNewbieCmdFuncCallback) )
end

function BattleSceneNewbieHandler:onNewbieCmdDelayTime(data)
	gRootManager:AddTimer(data.value,false,function( ... )
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = data.nextId})
	end)
end

function BattleSceneNewbieHandler:onNewbieCmdFadein(data)
	local nodesList = string.split(data.nodes,",")
	if next(nodesList) then
		for _,nodeName in ipairs(nodesList) do
			local n = self:getNode(nodeName)
			n:setOpacity(0)
			local action = cc.FadeIn:create(data.value)
 			n:runAction(action)
		end
	end

	gRootManager:AddTimer(data.value+1,false,function( ... )
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = data.nextId})
	end)
end

function BattleSceneNewbieHandler:onNewbieCmdFocusBtn(data)
	local function clickNextCallback(id)
		self._NewbieNode:removeAllChildren()
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = id})
	end

	self._NewbieNode:removeAllChildren()

	local clip = cc.ClippingNode:create()
	clip:setInverted(true)
	clip:setAlphaThreshold(0.0)
	self._NewbieNode:addChild(clip)

	local layerColor = cc.LayerColor:create(cc.c4b(0,0,0,150))
	clip:addChild(layerColor)

	local nodesList = string.split(data.nodes,",")
	local CBList = nil
	if data.callbackList then
		CBList = string.split(data.callbackList,",")
	end

	local handDir = {"down","left","right","up"}

	if data.id == 100000051 then
		gRootManager:OpenPage("GMPage")
	end

	if next(nodesList) then
		local newbieNodef = cc.Node:create()
		for i,nodeName in ipairs(nodesList) do
			local btnNode = self:getNode(nodeName)
			local posX,posY = btnNode:getPosition()
			local size = btnNode:getContentSize()
			local niewBiePic = cc.Sprite:createWithSpriteFrameName("CryoGui9.png")
			local framePic = nil
			local strCallback = nil

			if CBList and next(CBList) then
				strCallback = CBList[i]
			end

			if strCallback then
				framePic = SimpleAniNode.new("UI/NewbieAni/newbieSelectFrame.csb",true)

				self._NewbieNode:addChild(framePic)
				framePic:setPosition(cc.p(posX,posY))
			end

			if strCallback and data.dir and framePic then
				for _,handStr in pairs(handDir) do
					local handStrKey = "hand_"..handStr
					framePic:setNodeVisible(handStrKey,data.dir == handStr)
				end
			end

			niewBiePic:setContentSize(size.width*1.2,size.height*1.2)
			newbieNodef:addChild(niewBiePic)
			niewBiePic:setPosition(cc.p(posX,posY))

			if strCallback and self[strCallback] then
				local cb = handler(self,self[strCallback])

				local function newbieBtnEvent()
					cb(data.nextId)
				end

				self._BtnNewbie:setPosition(posX,posY)
				self._BtnNewbie:setContentSize(cc.size(size.width*1.2,size.height*1.2))
				self._BtnNewbie:addClickEventListener(newbieBtnEvent)
			else
				self:createNewbieArrow(Vector2D.new(posX,posY))
			end
		end

		if data.newbieCSB then
			local pos = cc.p(self._WinSize.width*0.5,self._WinSize.height*0.5)
			local newbieAniNode = NewbieAniNode.new(data,clickNextCallback)
			self._NewbieNode:addChild(newbieAniNode)
			newbieAniNode:setPosition(pos)
		end

		clip:setStencil(newbieNodef)--设置模版
	end
end

function BattleSceneNewbieHandler:onNewbieCmdShowWarnText(data)
	self._PanelNewbie:setVisible(false)
	self:setNodeVisibleLang("NewbieTextItemWarning")
	local TextItemWarningNode = self:getNode("NewbieWarnItemNode")
	local textItemWarning = self:getNodeLang("NewbieTextItemWarning")
	local act1 = cc.Show:create()
    local act2 = cc.DelayTime:create(0.5)
    local act3 = cc.Hide:create()
    local act4 = cc.DelayTime:create(0.5)

   -- textItemWarning:setString(_Lang(data.value))
    local actSeq = cc.Sequence:create(act1,act2,act3,act4)
    local action = cc.RepeatForever:create(actSeq)
    textItemWarning:stopAllActions()
    textItemWarning:runAction(action)
    TextItemWarningNode:setVisible(true)

    self._NewbieNode:removeAllChildren()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = data.nextId})
end

function BattleSceneNewbieHandler:onNewbieCmdShowAni(data)
	local function clickNextCallback(id)
		self._NewbieNode:removeAllChildren()
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = id})
	end

	local clickHandler = clickNextCallback
	if data.callbackList and self[data.callbackList] then
		clickHandler = handler(self,self[data.callbackList])
	end

	self._NewbieNode:removeAllChildren()

	if data.nodes then
		local newData = {}
		newData.nodes = data.nodes
		self:onNewbieCmdFocusBtn(newData)
	end

	local newbieAniNode = NewbieAniNode.new(data,clickHandler)
	self._NewbieNode:addChild(newbieAniNode)
	newbieAniNode:setPosition(cc.p(self._WinSize.width*0.5,self._WinSize.height*0.5))
end

function BattleSceneNewbieHandler:onNewbieCmdEventPause(data)
	local params =
	{
		command="PauseGame",
		isPause = data.value,
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,params)

	self._NewbieNode:removeAllChildren()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = data.nextId})
end

function BattleSceneNewbieHandler:NewbieTask001(nextId)
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = nextId})
end

function BattleSceneNewbieHandler:NewbieTask0011(nextId)
	local data = 
	{
		nodeName = "playerCreateAreaNode",
		isShow = true
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data)

	local data2 =
	{
		command="onCommandTryCreateActor",
		id = 1001,
		level = 1,
		insertQuadtree = false,
		cost = 5
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,data2)

	self._NewbieNode:removeAllChildren()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = nextId})
end

function BattleSceneNewbieHandler:NewbieTask002(nextId)
	local data = 
	{
		nodeName = "playerCreateAreaNode",
		isShow = true
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data)
	
	local data2 =
	{
		command="onCommandTryCreateActor",
		id = 1003,
		level = 1,
		insertQuadtree = false,
		cost = 6,
		pos = {x = 1900,y = 560}
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,data2)

	self._NewbieNode:removeAllChildren()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = nextId})
end

function BattleSceneNewbieHandler:NewbieTask003(nextId)
	self._parentNode:OnStateSell()

	self._NewbieNode:removeAllChildren()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = nextId})
end

function BattleSceneNewbieHandler:NewbieTask004(nextId)
	self._parentNode:onSelectBuildingLV()

	self._NewbieNode:removeAllChildren()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = nextId})
end

function BattleSceneNewbieHandler:NewbieTask005(nextId)
	local data = 
	{
		nodeName = "playerCreateAreaNode",
		isShow = true
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data)

	local data2 =
	{
		command="onCommandTryCreateActor",
		id = building_type.player_wooden_wall,
		level = 1,
		insertQuadtree = false,
		cost = 11
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,data2)

	self._PanelNewbie:setVisible(false)
	self._NewbieNode:removeAllChildren()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = nextId})
end

function BattleSceneNewbieHandler:NewbieTask006(nextId)
	local data = 
	{
		nodeName = "playerCreateAreaNode",
		isShow = true
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data)

	local data2 =
	{
		command="onCommandTryCreateActor",
		id = building_type.player_house,
		level = 1,
		insertQuadtree = false,
		cost = 11
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,data2)

	self._PanelNewbie:setVisible(false)
	self._NewbieNode:removeAllChildren()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = nextId})
end

function BattleSceneNewbieHandler:NewbieTask007(nextId)
	local data = 
	{
		nodeName = "playerCreateAreaNode",
		isShow = true
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data)

	local data2 =
	{
		command="omCommandTryCreateActorList",
		id = building_type.player_fence_building,
		level = 1,
		insertQuadtree = false,
		cost = 5
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,data2)

	self._PanelNewbie:setVisible(false)
	self._NewbieNode:removeAllChildren()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = nextId})
end

function BattleSceneNewbieHandler:NewbieTask008(nextId)
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = nextId})
end

function BattleSceneNewbieHandler:NewbieTask0081(nextId)
	-- body
	self._PanelNewbie:setVisible(false)
	self._parentNode:OnStateStart()
	self._NewbieNode:removeAllChildren()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = nextId})
end


function BattleSceneNewbieHandler:NewbieTask009(nextId)
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = nextId})
end

function BattleSceneNewbieHandler:NewbieTask0091(nextId)
	local chaNode = self._parentNode:getChaSelNode(1009)
	if chaNode then
		local event = {}
		event.name = "ended"
		chaNode:onAddCreateActor(event)

		self._PanelNewbie:setVisible(false)
		self._NewbieNode:removeAllChildren()
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = nextId})
	end
end

function BattleSceneNewbieHandler:NewbieTask010(nextId)
	local chaNode = self._parentNode:getChaSelNode(1011)
	if chaNode then
		local event = {}
		event.name = "ended"
		chaNode:onAddCreateActor(event)

		self._PanelNewbie:setVisible(false)
		self._NewbieNode:removeAllChildren()
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = nextId})
	end
end

function BattleSceneNewbieHandler:onNewbieCmdCheckCondition1(data)
	local function CheckMoneyCanBuyPeasant(data)
		local coins = _GModel.PlayerManager:GetPlayerCoins()
		if coins >= 5 then
			gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = data.nextId})
		else
			gRootManager:AddTimer(0.5,false,CheckMoneyCanBuyPeasant,{nextId = data.nextId})
		end
	end

	self._PanelNewbie:setVisible(false)
	self._NewbieNode:removeAllChildren()

	gRootManager:AddTimer(0.5,false,CheckMoneyCanBuyPeasant,{nextId = data.nextId})
end

function BattleSceneNewbieHandler:onNewbieCmdCheckCondition2(data)
	local function CheckMoneyCanBuySoldier2(data)
		local coins = _GModel.PlayerManager:GetPlayerCoins()
		local fCount = _GModel.sActorManager:getCgfCount(1009)

		if coins >= 8 and fCount >= 1 then
			gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = data.nextId})

			local data1 = 
			{
				nodeName = "playerAreaNode",
				isShow = false,
			}

			gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)
		else
			gRootManager:AddTimer(0.5,false,CheckMoneyCanBuySoldier2,{nextId = data.nextId})
		end
	end

	self._PanelNewbie:setVisible(false)
	self._NewbieNode:removeAllChildren()

	gRootManager:AddTimer(0.5,false,CheckMoneyCanBuySoldier2,{nextId = data.nextId})
end


function BattleSceneNewbieHandler:onNewbieCmdCheckCondition3(data)
	local function CheckMoneyCanBuySoldier3(data)
		local fCount = _GModel.sActorManager:getCgfCount(1011)

		if fCount >= 1 then
			gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = data.nextId})
		else
			gRootManager:AddTimer(0.5,false,CheckMoneyCanBuySoldier3,{nextId = data.nextId})
		end
	end

	self._PanelNewbie:setVisible(false)
	self._NewbieNode:removeAllChildren()

	gRootManager:AddTimer(0.5,false,CheckMoneyCanBuySoldier3,{nextId = data.nextId})
end

function BattleSceneNewbieHandler:createNewbieArrow(pos)
	local dir = pos - self._Center
	dir:SetNormalize()
	local angle = math.atan2(dir.y, dir.x)
	angle = -math.radian2angle(angle)
	local arrowNode = SimpleAniNode.new("UI/NewbieAni/NewbieArrow.csb")
	arrowNode:setRotation(angle)
	local newPos = pos - dir*400

	arrowNode:setPosition(cc.p(newPos.x,newPos.y))
	self._NewbieNode:addChild(arrowNode)
end

function BattleSceneNewbieHandler:processNewbie(id)
	if not id then 
		self._curNewbieCmdId = nil
    	self._curNewbieCmds = nil
    	self._NewbieEventMap = nil
    	self._NewbieTaskList = {}
    	self._NewbieNode:removeAllChildren()
    	self._PanelNewbie:setVisible(false)
    	self._Pause = false
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_PauseGame,{isPause = false})

		if self._NewbieId then
			setPlayerSetting("newbieCmd_"..tostring(self._NewbieId),SettingType.TYPE_BOOL,true)
			self._NewbieId = nil
		end

		return 
	end

	local newCmd = self._curNewbieCmds[id]
	if newCmd then
		local newbieCB = self["onNewbieCmd"..newCmd.cmd]
		if newbieCB then
			self._curNewbieCmdId = id
			self._PanelNewbie:setVisible(true)
			newbieCB(self,newCmd)
		end
	end
end

return BattleSceneNewbieHandler