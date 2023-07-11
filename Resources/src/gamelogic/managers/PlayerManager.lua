local PlayerManager = class("PlayerManager",_GModel.IManager)

function PlayerManager:_Init()
	local temp = getPlayerSetting("playerMoney",SettingType.TYPE_INT,0)
	self._Gems = temp.Value
	self._buyFinishHandler = handler(self,self.onBuyFinish)
	self._curBuyId = nil
	self._curBuyItemId = nil
	self._curCoins = 0
	self._unlockList = {}
	self._levelNewbieList = {}
	self._prepareMoney = 0
	self._preparePop = 0
	self._curSelectId = 0
end

function PlayerManager:GetGems()
	return self._Gems
end

function PlayerManager:CheckGems(cost)
	if cost > 0 and self._Gems > 0 and self._Gems >= cost then
		return true
	end
	return false
end

function PlayerManager:updateGems(cost)
	self._Gems = self._Gems + cost

	setPlayerSetting("playerMoney",SettingType.TYPE_INT,self._Gems)
	
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_RefreshGems)
end

function PlayerManager:onBuyFinish()
	local item = _GModel.GemsCfg[self._curBuyId]
	self._Gems = self._Gems + item.gemCount
	self._curBuyId = nil

	setPlayerSetting("playerMoney",SettingType.TYPE_INT,self._Gems)
	gRootManager:ShowMsgBox(_Lang("@BuyGemsSuccess"))
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_ShowLoading,{show = false})
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_RefreshGems)
end

function PlayerManager:BuyGems(id)
	self._curBuyId = nil
	if not _GModel.GemsCfg[id] then
		LogError("invalid gem cfg id"..tostring(id))
		return
	end

	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_ShowLoading,{show = true})
	gRootManager:AddTimer(2,false,self._buyFinishHandler)
	self._curBuyId = id
end

function PlayerManager:BuyItems(id)
	if not _GModel.items[id] then
		LogError("invalid item cfg id"..tostring(id))
		return
	end

	local cfg = _GModel.items[id]
	if cfg then

		if not self:CheckGems(cfg.cost) then
			gRootManager:ShowMsgBox(_Lang("@GemsNotEnought"),false)
			return
		end

		self._Gems = self._Gems - cfg.cost
		setPlayerSetting("playerMoney",SettingType.TYPE_INT,self._Gems)
		gRootManager:ShowMsgBox(_Lang("@BuyItemSuccess", _Lang(cfg.title)))
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_RefreshGems)

		local Key = "BackpackItem_"..tostring(id)
		local packageItemCount = getPlayerSetting(Key,SettingType.TYPE_INT,0)
		local count = packageItemCount.Value + 1
		setPlayerSetting(Key,SettingType.TYPE_INT,count)
	end
end

function PlayerManager:AddPrepareMoney(money)
	self._prepareMoney = self._prepareMoney + money
end

function PlayerManager:SetPrepareMoney(money)
	self._prepareMoney = money
end

function PlayerManager:GetPrepareMoney()

	return self._prepareMoney
end

function PlayerManager:SetPreparePop(pop)
	self._preparePop = pop
end

function PlayerManager:GetPreparePop()
	return self._preparePop
end

function PlayerManager:AddPreparePop(pop)
	self._preparePop = self._preparePop + pop
end

function PlayerManager:SetPlayerCoins(coins)
	self._curCoins= coins
end

function PlayerManager:updateCoins(coins)
	self._curCoins = self._curCoins + coins
end

function PlayerManager:SetCurSelectId(id)
	self._curSelectId = id
end

function PlayerManager:GetCurSelectId()
	return self._curSelectId
end

function PlayerManager:GetPlayerCoins()
	return self._curCoins
end

function PlayerManager:addUnlcokItem(id,isBuilding)
	local temp = getPlayerSetting("unit_unlock_"..tostring(id),SettingType.TYPE_BOOL,false)
	if temp.Value then
		return
	end

	local data  = {}
	data.id = id
	data.isBuilding = isBuilding
	table.insert(self._unlockList,data)
end

function PlayerManager:getUnlockList()
	return self._unlockList
end

function PlayerManager:cleaUnlockList()
	self._unlockList  = {}
end

function PlayerManager:insertLevelNewbieId(id)
	local isFinish = cc.UserDefault:getInstance():getBoolForKey("newbieID"..id,false)

	if not isFinish then
		table.insert(self._levelNewbieList,id)
	end
end

function PlayerManager:getNextLevelNewbieId()
	if not next(self._levelNewbieList) then
		return nil
	end

	local id = self._levelNewbieList[1]
	table.remove(self._levelNewbieList,1)
	return id
end

return PlayerManager