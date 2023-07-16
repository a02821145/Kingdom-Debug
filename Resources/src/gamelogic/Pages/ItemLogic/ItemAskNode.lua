local ItemAskNode = class("ItemAskNode", ccui.Widget,_GModel.IBaseInterface)

function ItemAskNode:ctor(data)
	self:load("UI/InGame/CoinSelectAni.csb")
	self._data = data
	self:addBtnClickListener("Btn_Check",self.onBtnOK)
	self:addBtnClickListener("btn_cancel",self.onBtnCancel)
	self:playTimeLine("start",true)
end

function ItemAskNode:onBtnOK()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_AddEffect,{id = 7016, pos = {x=0,y=0},isUIEffect = true})
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnShow_Bag,{isShow = false})

	local Key = "BackpackItem_"..tostring(self._data.id)
	local packageItemCount = getPlayerSetting(Key,SettingType.TYPE_INT,0)
	local num = tonumber(packageItemCount.Value)-1
	setPlayerSetting(Key,SettingType.TYPE_INT,num)

	local data1 = 
	{
		nodeName = "ItemAskNode",
		isShow = false
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)

	local data2 =
	{
		command="onCommandManager",
		name = "PlayerManager",
		team = actor_team.team_player,
		cmd =  "AddItemMoney",
		money = self._data.value
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,data2)

end

function ItemAskNode:onBtnCancel()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnShow_Bag,{isShow = false})

	local data1 = 
	{
		nodeName = "ItemAskNode",
		isShow = false
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)
end

return ItemAskNode