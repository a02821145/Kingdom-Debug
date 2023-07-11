local LevelSelectItemNode = TWRequire("LevelSelectItemNode")
local LevelSelectPage     = class("LevelSelectPage",_GModel.IBasePage)
local configManager       = TWRequire("ConfigDataManager")
local ConstCfg 		      = TWRequire("ConstCfg")

local game_mode = 
{
	easy = 1,
	normal = 2,
	hard = 3,
}

local game_mode_icon = 
{
	[game_mode.easy] = "mode_easy_icon",
	[game_mode.normal] = "mode_normal_icon",
	[game_mode.hard] = "mode_hard_icon",
}

local game_mode_str = 
{
	[game_mode.easy] = "easy",
	[game_mode.normal] = "normal",
	[game_mode.hard] = "hard",
}

local DiffDelta = 0.1

local function sortBuilding(a,b)
	return ConstCfg.buildingShowPrio[a.id] < ConstCfg.buildingShowPrio[b.id]
end

function LevelSelectPage:_init(data)
	self._Level = data.Level
	self._LevelData = _GModel.LevelManager:getLevelData(data.Level)
	local forbidenList = self._LevelData.forbidenList
	self._forbidenList = {}

	if forbidenList and next(forbidenList) then
		for _,id in ipairs(forbidenList) do
			self._forbidenList[id] = true
		end
	end
	
	self._SelectTab = {"selectEasy","selectNormal","selectHard"}
	self:_initUI()
end

function LevelSelectPage:_initUI()
	self:addBtnClickListener("btn_battle",self.onStartGame)
	self:addBtnClickListener("btn_close",self._close)
	self:addBtnClickListener("btn_left",self._onSelectLeft)
	self:addBtnClickListener("btn_right",self._onSelectRight)
	self:addBtnClickListener("btn_ok_tips",self._onCloseTips)

	self:setNodeVisibleLang("btn_text_battle")
	self:setNodeVisibleLang("mode_easy_text")
	self:setNodeVisibleLang("mode_normal_text")
	self:setNodeVisibleLang("mode_hard_text")
	self:setNodeVisibleLang("LevelName")
	self:setNodeVisibleLang("content_text")
	self:setNodeVisibleLang("btn_tips_text")

	self:setNodeVisible("TextNodeNormal",false)
	self:setNodeVisible("TextNodeHard",false)
	self:setNodeVisible("MapFog",false)

	self:setNodeVisible("PanelTips",false)
	self._curGameMode = game_mode.easy
	self:ShowModeIconDirect(game_mode.easy)
	self:playTimeLine("start",false,handler(self,self.ShowTips),1)
	self:setLabelTextLang("LevelName",_Lang("@LevelGuanKa",self._Level))
	self:setSpriteTexture("minimap",string.format("UI/minimaps/minimap%d.png",self._Level))
	self:ShowStarDirect()
	self:refreshStar()
	self:refreshTeams()
end

function LevelSelectPage:ShowTips( )
	local showTips = cc.UserDefault:getInstance():getBoolForKey("showSelectLevelTips",false)

	if not showTips then
		self:setNodeVisible("PanelTips",true)
	end
end

function LevelSelectPage:refreshTeams()
	self._LVEnemyCha = self:GetListView("LVEnemyCha")
	self._LVEnemyBuilding = self:GetListView("LVEnemyBuilding")
	self._LVMyCha = self:GetListView("LVMyCha")
	self._LVMyBuilding = self:GetListView("LVMyBuilding")

	local characters  = configManager:getMod("Characters")
	local buildings   = configManager:getMod("Buildings")
	local traps       = configManager:getMod("Traps")

	local tempChaList = {}
	local tempBuildingList = {}
	self._nodeItemList = {}

	for _,v in ipairs(characters) do
		local temp = getPlayerSetting("unit_unlock_"..tostring(v.id),SettingType.TYPE_BOOL,false)
		local isForbiden = not not self._forbidenList[v.id]
		if temp.Value and not isForbiden then
			local key    = "UnitLV_"..tostring(v.id)
			local temp   = getPlayerSetting(key,SettingType.TYPE_INT,1)
			local iLevel = tonumber(temp.Value)

			local data =  {}
			data.id = v.id
			data.level = iLevel
			data.icon  = v.icon
			data.team  = v.team
			data.spId = v.spId
			data.showPriority = v.showPriority
			table.insert(tempChaList,data)
		end
	end

	table.sort( tempChaList,function( a,b )
		return a.showPriority < b.showPriority
	end )

	self._LVEnemyCha:removeAllChildren()
	self._LVMyCha:removeAllChildren()

	for _,v in ipairs(tempChaList) do
		local itemNode = LevelSelectItemNode.new(v)
		if v.team == actor_team.team_player then
			self._LVMyCha:addChild(itemNode)
		elseif v.team == actor_team.team_NPC then
			self._LVEnemyCha:addChild(itemNode)
		end

		self._nodeItemList[v.id] = itemNode
	end

	self._LVEnemyCha:forceDoLayout()
	self._LVMyCha:forceDoLayout()

	for _,v in ipairs(buildings) do
		local temp = getPlayerSetting("unit_unlock_"..tostring(v.id),SettingType.TYPE_BOOL,false)
		local isForbiden = not not self._forbidenList[v.id]

		if temp.Value and not isForbiden then
			local key    = "UnitLV_"..tostring(v.id)
			local temp   = getPlayerSetting(key,SettingType.TYPE_INT,1)
			local iLevel = tonumber(temp.Value)

			local data =  {}
			data.id = v.id
			data.level = iLevel
			data.icon  = v.icon
			data.team  = v.team
			data.spId = v.spId
			table.insert(tempBuildingList,data)
		end
	end

	table.sort( tempBuildingList,sortBuilding)

	self._LVEnemyBuilding:removeAllChildren()
	self._LVMyBuilding:removeAllChildren()

	for _,v in ipairs(tempBuildingList) do
		local itemNode = LevelSelectItemNode.new(v)
		if v.team == actor_team.team_player then
			self._LVMyBuilding:addChild(itemNode)
		elseif v.team == actor_team.team_NPC then
			self._LVEnemyBuilding:addChild(itemNode)
		end
	end

	self._LVMyBuilding:forceDoLayout()
	self._LVEnemyBuilding:forceDoLayout()
end

function LevelSelectPage:refreshStar()

	local diffStr = game_mode_str[self._curGameMode]
	local strKey = string.format("%d_%s",self._Level,diffStr)
	local temp = getPlayerSetting(strKey,SettingType.TYPE_INT,0)

	for i=0,3 do
		self:setNodeVisible("SpStar"..i,i==temp.Value)
	end
end

function LevelSelectPage:ShowModeIconDirect(showMode)
	for mode,strIcon in pairs(game_mode_icon) do
		self:setNodeVisible(game_mode_icon[mode],mode == showMode)
	end

	self._curGameMode = showMode
	self._iconStr = game_mode_icon[showMode]

	if self._curGameMode <= game_mode.easy then
		self:setButtonEnable("btn_left",false)
		self:setButtonEnable("btn_right",true)
	elseif self._curGameMode >= game_mode.hard then
		self:setButtonEnable("btn_right",false)
		self:setButtonEnable("btn_left",true)
	else
		self:setButtonEnable("btn_right",true)
		self:setButtonEnable("btn_left",true)
	end
end

function LevelSelectPage:_onSelectLeft()
	local oldMode = self._curGameMode
	self._curGameMode = self._curGameMode -1
	if self._curGameMode <= game_mode.easy then
		self._curGameMode = game_mode.easy
		self:setButtonEnable("btn_left",false)
	end
	self:setButtonEnable("btn_right",true)
	self:ShowEffect(game_mode_icon[self._curGameMode])
	self:ShowStarEffect(oldMode,self._curGameMode)
	self:showLevelInfo(self._curGameMode)
	--self:setNodeVisible("MapFog",self._curGameMode == game_mode.hard)
end

function LevelSelectPage:_onSelectRight()
	local oldMode = self._curGameMode
	self._curGameMode = self._curGameMode + 1
	if self._curGameMode >= game_mode.hard then
		self._curGameMode = game_mode.hard
		self:setButtonEnable("btn_right",false)
	end

	self:setButtonEnable("btn_left",true)
	self:ShowEffect(game_mode_icon[self._curGameMode])
	self:ShowStarEffect(oldMode,self._curGameMode)
	self:showLevelInfo(self._curGameMode)
	--self:setNodeVisible("MapFog",self._curGameMode == game_mode.hard)
end

function LevelSelectPage:showLevelInfo(gameMode)
	self:setNodeVisible("TextNodeNormal",false)
	self:setNodeVisible("TextNodeHard",false)

	self:setNodeVisible("MapFog",false)

	for _,itemNode in pairs(self._nodeItemList) do
		itemNode:showForbiden(false)
	end

	local nodePanelDiff = self:getNode("PanelDiff")

	if gameMode == game_mode.normal then
		self:setNodeVisibleLang("textnormal")
		self:setNodeVisible("TextNodeNormal",true)
		self:setLabelTextLang("textnormal",_Lang("@DifficultyWarnText",DiffDelta*100))

		if not nodePanelDiff:isVisible() then
			self:playTimeLine("showDiff",false)
		end
	elseif gameMode == game_mode.hard then
		self:setNodeVisibleLang("texthard1")
		self:setNodeVisibleLang("texthard2")
		self:setNodeVisible("TextNodeHard",true)
		self:setLabelTextLang("texthard1",_Lang("@DifficultyWarnText",DiffDelta*100*2))

		for i=1,4 do
			self:setNodeVisible(string.format("SpForbid%d",i),false)
		end

		local hasForbidUseSoldier = false
		local hardFofbidUse = self._LevelData.hardFofbidUse
		if hardFofbidUse and next(hardFofbidUse) then
			local characters = configManager:getMod("Characters")
			local soldiersStr = ""
			for i,soldierID in ipairs(hardFofbidUse) do
				local sKey = string.format("SpForbid%d",i)
				local cha = configManager:getConfigById(soldierID)
				self:setNodeVisible(sKey,true)

				local sp = ConstCfg.SoldiersSmallIconSpMy[cha.profession]
				self:setSpriteFrame(sKey,sp)

				self._nodeItemList[soldierID]:showForbiden(true)
			end
			hasForbidUseSoldier = true
			self:setLabelTextLang("texthard2",_Lang("@ForbiddenUse",soldiersStr))
		else
			self:setNodeVisibleLang("texthard2",false)
		end

		if self._LevelData.hardUseFog then
			self:setNodeVisibleLang("texthard3")
			self:setLabelTextLang("texthard3",_Lang("@DifficultyWarFog"))
			self:setNodeVisible("MapFog",true)

			if hasForbidUseSoldier then
				self:setPositionLangY("texthard3",73)
			else
				self:setPositionLangY("texthard3",124)
			end
		else
			self:setNodeVisibleLang("texthard3",false)
		end
		if not nodePanelDiff:isVisible() then
			self:playTimeLine("showDiff",false)
		end
	else
		if nodePanelDiff:isVisible() then
			self:playTimeLine("hideDiff",false)
		end
	end
end

function LevelSelectPage:ShowEffect(newIconStr)
	local fadeTime = 0.3
	local newIcon = self:getNode(newIconStr)
	self:setNodeVisible(newIconStr,true)
	newIcon:setOpacity(0)

	local function callback()
		local action = cc.FadeIn:create(fadeTime)
		newIcon:runAction(action)
		self._iconStr = newIconStr

		for mode,v in pairs(game_mode_icon) do
			if mode ~= self._curGameMode then
				self:setNodeVisible(v,false)
			end
		end
	end

	local icon = self:getNode(self._iconStr)
	local action1 = cc.FadeOut:create(fadeTime)
	local action2 = cc.CallFunc:create(callback)
	local actSeq  = cc.Sequence:create(action1,action2)
	icon:runAction(actSeq)
end

function LevelSelectPage:ShowStarEffect(oldMode,newMode)
	if oldMode == newMode then return end

	local fadeTime = 0.3
	local diffStr = game_mode_str[oldMode]
	local strKey = string.format("%d_%s",self._Level,diffStr)
	local temp = getPlayerSetting(strKey,SettingType.TYPE_INT,0)
	local oldStarCount = temp.Value
	local spOld = self:getNode("SpStar"..oldStarCount)

	local function callback()
		local diffStr = game_mode_str[newMode]
		local strKey = string.format("%d_%s",self._Level,diffStr)
		local temp = getPlayerSetting(strKey,SettingType.TYPE_INT,0)
		local newStarCount = temp.Value
		local spNew = self:getNode("SpStar"..newStarCount)

		local action = cc.FadeIn:create(fadeTime)
		spNew:runAction(action)
		spNew:setVisible(true)
	end

	local action1 = cc.FadeOut:create(fadeTime)
	local action2 = cc.CallFunc:create(callback)
	local actSeq  = cc.Sequence:create(action1,action2)
	spOld:runAction(actSeq)
end

function LevelSelectPage:onStartGame()
	local params = {
		level = self._Level,
		difficulty = self._curGameMode
	}

	gMessageManager:sendMessage(MessageDef_GameLogic.Msg_LevelScene_StartGame,params)
end

function LevelSelectPage:_onCloseTips()
	self:setNodeVisible("PanelTips",false)
	cc.UserDefault:getInstance():setBoolForKey("showSelectLevelTips",true)
end

function LevelSelectPage:ShowStarDirect()
end

return LevelSelectPage