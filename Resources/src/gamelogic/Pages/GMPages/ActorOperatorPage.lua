local ActorOperatorPage = class("ActorOperatorPage",_GModel.IBasePage)

local default_playerConut = 1
local default_enemyCount = 1

local btnStatus = 
{
	status_none=1,
	status_remove_actor=2,
	status_add_actor = 3,
	status_move_actor = 4
}


local btnStatusCallback =
{
	[btnStatus.status_remove_actor] = "_onRemoveActor",
	[btnStatus.status_add_actor] = "_onAddActor",
	[btnStatus.status_move_actor] = "_onMoveActor"
}

function ActorOperatorPage:_init(data)
	self:_initBtns()
	self:_initUI()
	self:_initEvents()
	self:_scheduleUpdate()
	self:refreshCharacters()
end

function ActorOperatorPage:_initBtns()
	self:addBtnClickListener("BtnAddPlayer",self.onAddPlayer)
	self:addBtnClickListener("BtnAddEnemy",self.onAddEnemy)
	self:addBtnClickListener("BtnRemove",self.onBtnRemoveActor)
	self:addBtnClickListener("BtnRestart",self.onBtnRestart)

	self:addCheckBoxListener("CBShowSpriteAni",self.onCBShowSpriteAni)
	self:addCheckBoxListener("CBShowMoveSprite",self.onCBShowMoveSprite)
	self:addCheckBoxListener("CBShowSpine",self.onCBShowSpine)
	self:addCheckBoxListener("CBShowMap",self.onCBShowMap)
	self:addCheckBoxListener("CBShowBuilding",self.onCBShowBuilding)
end

function ActorOperatorPage:_initUI()
	self._TFPlayerConut = self:getNode("TFPlayerCount")
	self._TFEnemyCount  = self:getNode("TFEnemyCount")
	self._TFLevel		= self:getNode("TFLevel")
	self._CBShowSprite  = self:getNode("CBShowSpriteAni")
	self._CBShowSpine   = self:getNode("CBShowSpine")
	self._CBShowMoveSprite   = self:getNode("CBShowMoveSprite")
	self._CBShowBuilding     = self:getNode("CBShowBuilding")
end

function ActorOperatorPage:_initEvents()
	-- body
	RegisterEventListener(EventType.ScriptEvent_Touch,handler(self,self.onTouchBegin))
end

function ActorOperatorPage:refreshCharacters()
	self._btnList = {}

	local btnSoldierCopy = self:getNode("BtnPlayerCopy")
	local viewList = self:GetListView("LVCharacter")
	viewList:removeAllChildren()

	local configManager = TWRequire("ConfigDataManager")
	local characters = configManager:getMod("Characters")
	local chacterSelHandler = handler(self,self.onSelectCharacter)
	for _,char in pairs(characters) do
		local btn = btnSoldierCopy:clone()
		local str = char.id..":"..char.name
		btn:setTitleText(str)
		viewList:addChild(btn)
		btn.charcterID = char.id
		btn:addClickEventListener(chacterSelHandler)
		table.insert(self._btnList,btn)

		if char.id == self.curSelectedID then
			btn:setHighlighted(true)
		end
	end

	self.curSelectedID = 1005
	self.unitCount = default_playerConut

	self.isAddPlayer = false
	self.isAddEnemy = false
	self.btnStatus = btnStatus.status_none

	self:setTimer(1)
end

function ActorOperatorPage:onAddPlayer()
	local strCount = self._TFPlayerConut:getString()
	local count = tonumber(strCount)
	if type(count) ~= "number" then
		LogError("ActorOperatorPage:onAddPlayer Invalid param type not number")
		return
	end

	local count = tonumber(strCount)
	self.unitCount = count
	self.isAddPlayer = true
	self.btnStatus = btnStatus.status_add_actor
end

function ActorOperatorPage:onAddEnemy()
	local strCount = self._TFEnemyCount:getString()
	local count = tonumber(strCount)

	if type(count) ~= "number" then
		LogError("ActorOperatorPage:onAddEnemy Invalid param type not number")
		return
	end

	self.unitCount = count
	self.isAddEnemy = true
	self.btnStatus = btnStatus.status_add_actor
end

function ActorOperatorPage:onBtnRemoveActor()
	self.btnStatus = btnStatus.status_remove_actor
end

function ActorOperatorPage:onSelectCharacter(sender)
	self.curSelectedID = sender.charcterID

	for _,btn in ipairs(self._btnList) do
		btn:setHighlighted(false)
	end

	sender:setHighlighted(true)
end

function ActorOperatorPage:onBtnRestart()
	QueueEvent(EventType.ScriptEvent_Restart)
end

function ActorOperatorPage:onTouchBegin(message)
	-- body
	local pos = message.pos

	local funcName =  btnStatusCallback[self.btnStatus]
	if self[funcName] then
		self[funcName](self,pos)
	end
end

function ActorOperatorPage:_onAddActor(pos)
	local team = actor_team.team_none
	if self.isAddPlayer then
		team = actor_team.team_player
	elseif self.isAddEnemy then
		team = actor_team.team_NPC
	end

	if team ~= actor_team.team_none then
		local strLevel = self._TFLevel:getString()
		local iLevel = tonumber(strLevel)
		local data =
		{
			command="createActor",
			team = team,
			id=self.curSelectedID,
			pos=pos,
			num=self.unitCount,
			level = iLevel
		}

		QueueEvent(EventType.ScriptEvent_ActorCommand,data)

		local isSelectedSprite = self._CBShowSprite:isSelected()
		local isSelectedSpine = self._CBShowSpine:isSelected()
		local isSelectedMoveSprite = self._CBShowMoveSprite:isSelected()
		local isSelectedBuilding = self._CBShowBuilding:isSelected()

		self:setComponentActive("SpriteAniComponent",isSelectedSprite)
		self:setComponentActive("MoveSpriteComponent",isSelectedMoveSprite)
		self:setComponentActive("SpineComponent",isSelectedSpine)
		self:setComponentActive("BuildingComponent",isSelectedBuilding)
	end

	self.isAddPlayer = false
	self.isAddEnemy = false

	self.btnStatus = btnStatus.status_none
end

function ActorOperatorPage:_onRemoveActor(pos)
	QueueEvent(EventType.ScriptEvent_ActorCommand,{command="removeActor",pos=pos})
end

function ActorOperatorPage:updateTimer1()
	self:refreshCurSelectActorInfo()
end

function ActorOperatorPage:refreshCurSelectActorInfo()
	local data = getActorDebugInfo()

	if data and next(data) then	
		local sv = self:GetListView("LVPlayerInfo")
		sv:removeAllChildren()
		self:_showDebugInfo(data,sv)
		sv:forceDoLayout()
	end
end

function ActorOperatorPage:_showDebugInfo(data,viewList)
	if not data or not next(data) then return end

	local tabList = {}

	for key,value in pairs(data) do
		if type(value) == "table" then
			self:_addItemInfo(key,"---------",viewList)
			self:_showDebugInfo(value,viewList)
		else
			self:_addItemInfo(key,value,viewList)
		end
	end
end

function ActorOperatorPage:_addItemInfo(key,value,viewList)
	local panelItemCopy = self:getNode("panelItemCopy")
	propertyItem = panelItemCopy:clone()
	viewList:addChild(propertyItem)

	local textPropertyName = cc.utils.findChild(propertyItem,"TextPropertyName")
	local textProperty = cc.utils.findChild(propertyItem,"TextProperty")
	textPropertyName:setString(key)
	textProperty:setString(tostring(value))
end

function ActorOperatorPage:onCBShowSpriteAni(event)
	local isSelect = event.name == "selected"

	local data = getActorDebugInfo()
	local id = nil
	if data then
		id = data.id
	end

	self:setComponentActive("SpriteAniComponent",isSelect,id)
end

function ActorOperatorPage:onCBShowMoveSprite(event)
	local isSelect = event.name == "selected"

	self:setComponentActive("MoveSpriteComponent",isSelect)
end

function ActorOperatorPage:onCBShowSpine(event)

	local isSelect = event.name == "selected"

	self:setComponentActive("SpineComponent",isSelect)
end

function ActorOperatorPage:onCBShowBuilding(event)
	local isSelect = event.name == "selected"

	self:setComponentActive("BuildingComponent",isSelect)
end

function ActorOperatorPage:setComponentActive(name,isSelect,id)

	local params = 
	{
		id = id,
		Component = name,
		active = isSelect,
	}

	QueueEvent(EventType.ScriptEvent_SetComponentActive,params)
end

function ActorOperatorPage:onCBShowMap(event)
	local isSelect = event.name == "selected"

	local data1 = 
	{
		nodeName = "mapNode",
		isShow = isSelect
	}

	local data2 = 
	{
		nodeName = "drawNode",
		isShow = not isSelect
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)
	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data2)
end

return ActorOperatorPage