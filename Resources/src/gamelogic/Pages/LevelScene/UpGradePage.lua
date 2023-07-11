local UpGradePage = class("UpGradePage",_GModel.IBasePage)
local UpGradeItem = TWRequire("UpGradeItem")
local DisplayAniNode = TWRequire("DisplayAniNode")
local configManager    = TWRequire("ConfigDataManager")
local SimpleAniNode = TWRequire("SimpleAniNode")
local common = TWRequire("common")
local ConstCfg = TWRequire("ConstCfg")

local SoldierShowPrio = {
	[actor_profession.prof_lower_soldier_spear] = 1,
	[actor_profession.prof_lower_archer] = 2,
	[actor_profession.prof_lower_cavalier] = 3,
	[actor_profession.prof_lower_wisard] = 4,
	[actor_profession.prof_farmer] = 5,
	[actor_profession.prof_low_soldier] = 6,
	[actor_profession.prof_infantryman] = 7,
	[actor_profession.prof_archer] = 8,
	[actor_profession.prof_cavalier] = 9,
	[actor_profession.prof_wisard] = 10,
	[actor_profession.prof_thief] = 11,
	[actor_profession.prof_wisard_master] = 12,
	[actor_profession.prof_catapult] = 13,
}

local MAX_LEVEL = 10

local function sortSoldier(a,b)
	return SoldierShowPrio[a.data.profession] < SoldierShowPrio[b.data.profession]
end

local function sortBuilding(a,b)
	return ConstCfg.buildingShowPrio[a.data.id] < ConstCfg.buildingShowPrio[b.data.id]
end

function UpGradePage:_init()
	self:initUI()

	self:initUpGradesInfo()

	self:refreshSoldiers()
end

function UpGradePage:initUI()
	self._LVUpgradeItems   = self:GetListView("LVPlayers")
	self._ListViewProperty = self:GetListView("ListViewProperty")

	self._displayNode = self:getNode("displayNode")
	self._currentItem =  nil

	self:addBtnClickListener("btn_close",self._close)
	self:addBtnClickListener("btnSolder",self.refreshSoldiers)
	self:addBtnClickListener("btnFortress",self.refreshFortress)
	self:addBtnClickListener("btn_upgrade",self.onUpgrade)
	self:addBtnClickListener("btnUpgradeSkill",self.onSKillUpgrade)
	self:addListener(MessageDef_GameLogic.MSG_RefreshUpGrade,self.onEventRefreshGems)
	self:addListener(MessageDef_GameLogic.MSG_RefreshSkillStars,self.onRefreshStars)

	self._curCost = 0
	self._curUnitKey = ""
	self._iLevel = 1

	self._UpgradeItems = {}

	self._LevelUpAni = SimpleAniNode.new("UI/Effects/LevelUpAni.csb",false)
	self:addChildNode("LevelUpNode",self._LevelUpAni)
	self._LevelUpAni:setPosition(cc.p(0,0))
	
	self:setNodeVisibleLang("Title_Text")
	self:setNodeVisibleLang("info")
	self:setNodeVisibleLang("name")
	self:setNodeVisibleLang("btn_text_upgrade")
	self:setNodeVisibleLang("btn_text_troop")
	self:setNodeVisibleLang("btn_text_fotress")
	self:setNodeVisibleLang("btn_text_upgrade")
	self:setNodeVisibleLang("KezhiText")
	self:setNodeVisibleLang("btnUpgradeSkillText")
end

function UpGradePage:initUpGradesInfo()
	local upGradeCfgs = configManager:getMod("Upgrade")
	self._upGradeCfgs = {}

	for _,v in ipairs(upGradeCfgs) do
		self._upGradeCfgs[v.id] = v
	end
end

function UpGradePage:refreshSoldiers()
	local configManager  = TWRequire("ConfigDataManager")
	local soldiersCfgList = configManager:getMod("Characters")

	local soldierList = {}
	local soldierListUnLock = {}

	for _,cfg in pairs(soldiersCfgList) do
		if cfg.team == actor_team.team_player and cfg.profession ~= actor_profession.prof_golem then
			local temp = getPlayerSetting("unit_unlock_"..tostring(cfg.id),SettingType.TYPE_BOOL,false)
			local data = {}
			data.data =  cfg
			data.isUnlock = temp.Value
			if data.isUnlock then
				table.insert(soldierList,data)
			else
				table.insert(soldierListUnLock,data)
			end
		end
	end

	table.sort( soldierList, sortSoldier )
	table.sort( soldierListUnLock, sortSoldier )

	local allList = common:table_merge_by_order(soldierList,soldierListUnLock)

	self:refreshList(allList,false)

	self:setNodeVisible("soldier_selected",true)
	self:setNodeVisible("fortress_selected",false)
end

function UpGradePage:refreshList(nodeList,isbuilding)
	self._currentItem = nil
	self._LVUpgradeItems:removeAllChildren()
	local firstNode = nil
	local cb = handler(self,self.clickCallback)
	for i,cfg in ipairs(nodeList) do
		local itemNode = UpGradeItem.new(cfg.data,cb,isbuilding,cfg.isUnlock)
		self._LVUpgradeItems:addChild(itemNode)
		self._UpgradeItems[cfg.data.id] = itemNode
		if i == 1 then
			firstNode = itemNode
		end	
	end

	self._LVUpgradeItems:forceDoLayout()

	if firstNode then
		local event = {x = 0, y = 0}
		event.name = "ended"
		firstNode:onClick(event)
	end

	self._LevelUpAni:stop()
end

function UpGradePage:refreshTouchTest()
	local TouchTestNode = TWRequire("TouchTestNode")

	self._LVUpgradeItems:removeAllChildren()

	for i=1,10 do
		local n = TouchTestNode.new()
		self._LVUpgradeItems:addChild(n)
	end

	self._LVUpgradeItems:forceDoLayout()
end

function UpGradePage:clickCallback(item,data)

	if self._currentItem then
		self._currentItem:SetSelect(false)
	end

	self._displayNode:removeAllChildren()

	self._currentItem = item
	self._currentItem:SetSelect(true)

	local displayNode = DisplayAniNode.new(data.displayCSB,data.type == actor_type.type_building)
	self._displayNode:addChild(displayNode)

	if data.type == actor_type.type_building then
		displayNode:ResetPos()
	else
		displayNode:setPosition(cc.p(0,0))
	end

	self:setLabelTextLang("name",_Lang(data.name))
	self:setLabelTextLang("info",_Lang(data.desc))

	self._LevelUpAni:stop()

	self:refreshProperty(data)
	self:refreshStars(data)
end

function UpGradePage:onEventRefreshGems(message)
	if not message.data then return end

	local upItem = self._UpgradeItems[message.data.id]
	if upItem then
		upItem:refreshLevel()
	end

	self:refreshProperty(message.data)
	self:refreshStars(message.data)
end

function UpGradePage:onRefreshStars()
	if self._currentItem then
		self:refreshStars( {spId = self._currentItem:GetSkillId()})
	end
end

function UpGradePage:refreshStars(data)
	local key    = "SoldierSkill_"..tostring(data.spId)
	local temp   = getPlayerSetting(key,SettingType.TYPE_INT,0)
	local starCount = tonumber(temp.Value)

	for i=1,ConstCfg.SKILL_STAR_COUNT do
		self:setNodeVisible(string.format("SkillStar%d",i),i<=starCount)
	end
end

function UpGradePage:refreshProperty(data)
	local panelBG = self:getNode("propertyBG")
	local panelChild = panelBG:getChildren()

	self._curCost = 0
	self._curUnitKey = ""
	for _,child in pairs(panelChild) do
		child:removeAllChildren()
	end

	if not data then return end
	self._data = data

	if data.displayProperty then
		local perpertyCount = #data.displayProperty
		local isDouble = perpertyCount%2 == 0
		local upInfo = self._upGradeCfgs[data.upID]
		local nodeIndex = 1

		self._ListViewProperty:removeAllChildren()
		local DoublePropertyItemNode = TWRequire("DoublePropertyItemNode")

		for i=1,perpertyCount,2 do
			local item = DoublePropertyItemNode.new(data,upInfo)
			self._ListViewProperty:addChild(item)
			local leftCfg = data.displayProperty[i]
			local rightCfg = data.displayProperty[i+1]
			item:addLeft(leftCfg)

			if rightCfg then
				item:addRight(rightCfg)
			end
		end

		self._ListViewProperty:forceDoLayout()

		-- local PropertyItemNode = TWRequire("PropertyItemNode")
		-- for k,cfg in pairs(data.displayProperty) do
		-- 	local item = PropertyItemNode.new(data,cfg,upInfo)
		-- 	local pNode = self:getNode("ppos"..nodeIndex)
		-- 	pNode:addChild(item)
		-- 	item:setPosition(cc.p(0,0))
		-- 	nodeIndex = nodeIndex + 1
		-- end

		local key    = "UnitLV_"..tostring(data.id)
		local temp   = getPlayerSetting(key,SettingType.TYPE_INT,1)
		local iLevel = tonumber(temp.Value)
		local levelInfo =  upInfo.levelInfo[iLevel+1]
		self._iLevel = iLevel
		self:setButtonEnable("btn_upgrade",iLevel < MAX_LEVEL)

		self:setLabelText("CostGems",0)

		if levelInfo and levelInfo.cost then
			self:setLabelText("CostGems",levelInfo.cost)
			self._curCost = tonumber(levelInfo.cost)
			self._curUnitKey = key
		end
	end

	self:initKezhi(data)
end

function UpGradePage:initKezhi(data)
	self:setNodeVisible("kezhiNode",false)
	local weaponCom = nil
	local components = data.components

	for _,com in pairs(components or {}) do
		if com.name == "WeaponSysComponent" then
			weaponCom = com
			break
		end
	end

	if weaponCom then
		local weapons = weaponCom.weapons
		if weapons and next(weapons) then
			local kezhiSoldiersList = {}

			local weaponsCfg = configManager:getMod("Weapons")
			for _,weaponId in ipairs(weapons) do
				local wCfg = configManager:getConfigById(weaponId)

				local damageMoreTargetTypes = wCfg.damageMoreTargetTypes
				local damageMoreTargetProfs = wCfg.damageMoreTargetProfs

				if damageMoreTargetTypes then
					local kezhiTypes = damageMoreTargetTypes[1]
					if kezhiTypes == actor_type.type_soilder then

						for _,soldierProf in ipairs(damageMoreTargetProfs) do
							table.insert(kezhiSoldiersList,soldierProf)
						end
					end
				end
			end

			local hasKezhi = next(kezhiSoldiersList)~= nil
			self:setNodeVisible("kezhiNode",hasKezhi)

			if hasKezhi then
				for i=1,3 do
					local prof = kezhiSoldiersList[i]
					local hasProf = prof ~= nil
					local sKey = "KezhiSp"..i
					self:setNodeVisible(sKey,hasProf)

					if hasProf then
						local sp = ConstCfg.SoldiersSmallIconSp[prof]
						self:setSpriteFrame(sKey,sp)
					end
				end
			end
		end
	end
end

function UpGradePage:refreshFortress()
	local configManager  = TWRequire("ConfigDataManager")
	local buildingsCfg = configManager:getMod("Buildings")
	local buildingList = {}
	local buildingListUnlcok = {}

	for _,cfg in pairs(buildingsCfg) do
		if ConstCfg.buildingShowPrio[cfg.id] and cfg.team == actor_team.team_player then
			local temp = getPlayerSetting("unit_unlock_"..tostring(cfg.id),SettingType.TYPE_BOOL,false)
			local data = {}
			data.data =  cfg
			data.isUnlock = temp.Value

			if data.isUnlock then
				table.insert(buildingList,data)
			else
				table.insert(buildingListUnlcok,data)
			end
		end
	end

	table.sort( buildingList, sortBuilding )
	table.sort( buildingListUnlcok, sortBuilding )
	
	local allList = common:table_merge_by_order(buildingList,buildingListUnlcok)

	self:refreshList(allList,true)

	self:setNodeVisible("soldier_selected",false)
	self:setNodeVisible("fortress_selected",true)
end

function UpGradePage:onSKillUpgrade()
	if not self._data or not self._data.spId then return end

	gRootManager:OpenPage("SoldierSkillUpgradePage",{id = self._data.spId})
end

function UpGradePage:onUpgrade()
	if self._iLevel >= MAX_LEVEL then
		gRootManager:ShowMsgBox(_Lang("@WarnMaxLevel"),false)
		return
	end

	if not _GModel.PlayerManager:CheckGems(self._curCost) then
		gRootManager:ShowMsgBox(_Lang("@GemsNotEnought"),false)
		return
	end

	_GModel.PlayerManager:updateGems(-self._curCost)

	local temp   = getPlayerSetting(self._curUnitKey,SettingType.TYPE_INT,1)
	local iLevel = tonumber(temp.Value)
	iLevel = iLevel + 1

	setPlayerSetting(self._curUnitKey,SettingType.TYPE_INT,iLevel)
	gRootManager:ShowMsgBox(_Lang("@UpgradeSuccess"))

	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_RefreshUpGrade,{data = self._data })

	self._LevelUpAni:play()

	QueueEvent(EventType.ScriptEvent_Sound,{id = "upgrade_success"})
end

return UpGradePage