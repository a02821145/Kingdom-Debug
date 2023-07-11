local ConsoleHandler = class("ConsoleHandler",_GModel.IBaseInterface)

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

function ConsoleHandler:ctor(sceneNode)
	Log("ConsoleHandler:ctor")
end

function ConsoleHandler:init()
	
	self.curBtnStatus = btnStatus.status_none

	self.panelItemCopy = self:getNode("panelItemCopy")
	self.panelItemCopy2 = self:getNode("panelItemCopy2")
	self.panelItemCopy3 = self:getNode("panelItemCopy3")
	self.btnSoldierCopy = self:getNode("btn_soldier_copy")

	self.textDebugSpeed = self:getNode("text_speed")

	self:addBtnClickListener("BtnAdd10Player",self.onAdd10Player)
	self:addBtnClickListener("BtnAdd10Enemy",self.onAdd10Enemy)
	self:addBtnClickListener("btn_remove",self.onBtnRemoveActor)

	self:addBtnClickListener("BtnSlow",self.onBtnSlow)
	self:addBtnClickListener("BtnFast",self.onBtnFast)
	self:addBtnClickListener("BtnMove",self.onBtnMove)

	self:addCheckBoxListener("cb_showMemory",self.onShowMemory)
	self:addCheckBoxListener("cb_showQuadtree",self.onShowQuadTree)

	self.isAddPlayer = false
	self.isAddEnemy = false
	self.showPlayerInfo = true

	self.debugSpeed = 0
	self:_onShowCharacters()
end

function ConsoleHandler:_onShowCharacters()
	local viewList = self:getNode("SVCharacters")
	viewList:removeAllChildren()

	local configManager = TWRequire("ConfigDataManager")
	local characters = configManager:getMod("Characters")
	local chacterSelHandler = handler(self,self.onSelectCharacter)
	for _,char in pairs(characters) do
		local btn = self.btnSoldierCopy:clone()
		local str = char.id..":"..char.name
		btn:setTitleText(str)
		viewList:addChild(btn)
		btn.charcterID = char.id
		btn:addClickEventListener(chacterSelHandler)
	end

	self.curSelectedID = 1005
end

function ConsoleHandler:onSelectCharacter(sender)
	self.curSelectedID = sender.charcterID
end

function ConsoleHandler:_addItemInfo(key,value,viewList)
	propertyItem = self.panelItemCopy:clone()
	viewList:addChild(propertyItem)

	local textPropertyName = cc.utils.findChild(propertyItem,"TextPropertyName")
	local textProperty = cc.utils.findChild(propertyItem,"TextProperty")
	textPropertyName:setString(key)
	textProperty:setString(tostring(value))
end

function ConsoleHandler:_addItemInfo2(key,value,viewList)
	propertyItem = self.panelItemCopy2:clone()
	viewList:addChild(propertyItem)

	local textPropertyName = cc.utils.findChild(propertyItem,"TextPropertyName2")
	local textProperty = cc.utils.findChild(propertyItem,"TextProperty2")
	textPropertyName:setString(key)
	textProperty:setString(tostring(value))
end

function ConsoleHandler:_showDebugInfo(data,viewList)
	if not data or not next(data) then return end

	local tabList = {}

	for key,value in pairs(data) do
		if type(value) == "table" then
			table.insert(tabList,value)
		else
			self:_addItemInfo(key,value,viewList)
		end
	end

	if next(tabList) then
		for _,tab in ipairs(tabList) do
			self:_addItemInfo("----------","---------",viewList)
			self:_showDebugInfo(tab,viewList)
		end
	end
end

function ConsoleHandler:setActorInfo(data)
	if not self.showPlayerInfo then return end

	local sv = self:getNode("PlayerInfoSv")
	sv:removeAllChildren()
	self:_showDebugInfo(data,sv)
end

function ConsoleHandler:setMemoryInfo(data)
	if not data or not next(data) then return end
	local viewList = self:getNode("ListViewMemory")
	viewList:removeAllChildren()

	for key,value in pairs(data) do
		self:_addItemInfo2(key,value,viewList)
	end
end

function ConsoleHandler:onAdd10Player()
	self.isAddPlayer = true
	self.curBtnStatus = btnStatus.status_add_actor
end

function ConsoleHandler:onAdd10Enemy()
	self.isAddEnemy = true
	self.curBtnStatus = btnStatus.status_add_actor
end

function ConsoleHandler:onBtnRemoveActor()
	self.curBtnStatus = btnStatus.status_remove_actor
end

function ConsoleHandler:_onSingleTouchBegin(pos)
	local callback = btnStatusCallback[self.curBtnStatus]

	if callback and self[callback] then
		self[callback](self,pos)
	end

	self.curBtnStatus = btnStatus.status_none
end

function ConsoleHandler:_onAddActor(pos)
	local team = actor_team.team_none
	if self.isAddPlayer then
		team = actor_team.team_player
	elseif self.isAddEnemy then
		team = actor_team.team_NPC
	end

	if team ~= actor_team.team_none then
		QueueEvent(EventType.ScriptEvent_ActorCommand,{command="createActor",team = team,id=self.curSelectedID,pos=pos,num=1})
	end

	self.isAddPlayer = false
	self.isAddEnemy = false
end

function ConsoleHandler:_onMoveActor(pos)
	QueueEvent(EventType.ScriptEvent_ActorCommand,{command="moveActor",pos=pos})
end

function ConsoleHandler:onBtnMove()
	self.curBtnStatus = btnStatus.status_move_actor
end

function ConsoleHandler:_onRemoveActor(pos)
	QueueEvent(EventType.ScriptEvent_ActorCommand,{command="removeActor",pos=pos})
end

function ConsoleHandler:changeDebugSpeed(delta)
	self.debugSpeed = self.debugSpeed+delta
	self.debugSpeed = cc.clampf(self.debugSpeed,0,1)
	self.textDebugSpeed:setString(string.format("%.1f",self.debugSpeed))
	QueueEvent(EventType.ScriptEvent_DebugSpeed,{speed = self.debugSpeed})
end

function ConsoleHandler:onBtnSlow()
	self:changeDebugSpeed(0.1)
end

function ConsoleHandler:onBtnFast()
	self:changeDebugSpeed(-0.1)
end


function ConsoleHandler:onShowDebugQuadTree(sender,eventType)
	if eventType == 0 then
		for _,cb in ipairs(self.debugQuadTreeList) do
			if cb ~= sender then
				cb:setSelected(false)
			end
		end
	end

	local isSelected = sender:isSelected()
	setQuadTreeDebug(sender.quadName,isSelected)
end

return ConsoleHandler