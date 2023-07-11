local ItemFixBuildingAskNode = class("ItemFixBuildingAskNode", ccui.Widget,_GModel.IBaseInterface)

function ItemFixBuildingAskNode:ctor(data)
	self:load("UI/InGame/BuildingFixAskAni.csb")
	self._data = data
	self:addBtnClickListener("Btn_Check",self.onBtnOK)
	self:addBtnClickListener("btn_cancel",self.onBtnCancel)
	self:playTimeLine("start",true)
end

function ItemFixBuildingAskNode:onBtnOK()
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

	local params  = {
		type = actor_type.type_building,
		team = actor_team.team_player
	}


	local actors = ActorManager.GetActorsByType(params)
	if next(actors) then
		for _,id in ipairs(actors) do
			local targetActor = _GModel.sActorManager:getActorById(id)
			if targetActor then
				local isHurted = targetActor:sendMessageToComponentRet("HealthComponent","IsHurted","bool")
				if isHurted then
					targetActor:sendMessageToComponent("BuildingComponent","ShowFixNode",false)
					targetActor:sendMessageToComponent("BuildingComponent","PlayFixEffect")
					targetActor:sendMessageToComponent("HealthComponent","ResetHealthToMax")
				end
			end
		end
	end
end

function ItemFixBuildingAskNode:onBtnCancel()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnShow_Bag,{isShow = false})

	local data1 = 
	{
		nodeName = "ItemAskNode",
		isShow = false
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)
end

return ItemFixBuildingAskNode