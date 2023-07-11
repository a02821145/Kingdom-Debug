local PutSelNode = class("PutSelNode", ccui.Widget,_GModel.IBaseInterface,_GModel.IMsgInterface)

function PutSelNode:ctor(data,isUnlock)
	self:load("UI/Pages/BattlePage/BuildingSelNode.csb")
	self._data = data
	self._isSoldier = data.type == actor_type.type_soilder
	self._isUnLock = isUnlock
	self._pop = data.population and data.population or 0

	self:setImageTexture("icon",self._data.icon)

	self._moneyCost = self:getNode("moneyCost")
	self._moneyCost:setString(self._data.cost)

	self:setNodeVisible("lock_icon",not isUnlock)
	self:setNodeVisible("forbiden",false)

	self._panelBG = self:getNode("panelBG")
	self._panelBG:setSwallowTouches(false)
	self._panelBG:onTouch(isUnlock and handler(self,self.onSelectPut) or nil)

	self:setContentSize(210,150)
end

function PutSelNode:setForbidenByMoney(money)
	if not self._isUnLock then
		return
	end

	self:setForbiden(money < self._data.cost)
end

function PutSelNode:setForbiden(forbid)
	self:setNodeVisible("forbiden",forbid)

	if self._isUnLock and not forbid then
		self._panelBG:onTouch(handler(self,self.onSelectPut))
	else
		self._panelBG:onTouch(nil)
	end
end

function PutSelNode:onSelectPut(event)

	if event.name ~= "ended" then return end
	
	local curSelectId = _GModel.PlayerManager:GetCurSelectId()
	if curSelectId ~= self._data.id then
		_GModel.PlayerManager:SetPrepareMoney(0)
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_RefreshBattleCoins)
	end

	_GModel.PlayerManager:SetCurSelectId(self._data.id)

	local curCost = _GModel.PlayerManager:GetPlayerCoins()
	local prepareMoney = _GModel.PlayerManager:GetPrepareMoney()

	if curCost < self._data.cost or (self._data.cost + prepareMoney) >  curCost then
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_PlayBattleSceneAni,{ani="moneyNotEnough",loop = false,isUINode = true })
		return
	end

	if self._pop > 0 then
		if not PlayerManager.checkPopisEnough(actor_team.team_player,self._pop) then
			gMessageManager:sendMessage(MessageDef_GameLogic.MSG_PlayBattleSceneAni,{ani="popNotEnough",loop = false,isUINode = true })
			return 
		end
	end

	local data = 
	{
		nodeName = "playerCreateAreaNode",
		isShow = true
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data)

	if self._data.createMultiple then
		local data2 =
		{
			command="omCommandTryCreateActorList",
			id = self._data.id,
			level = 1,
			insertQuadtree = false,
			cost = self._data.cost
		}

		QueueEvent(EventType.ScriptEvent_GameCommand,data2)
	else
		local data2 =
		{
			command="onCommandTryCreateActor",
			id = self._data.id,
			level = 1,
			insertQuadtree = false,
			cost = self._data.cost
		}

		QueueEvent(EventType.ScriptEvent_GameCommand,data2)
	end
end

return PutSelNode

