local SoldierSkillUpgradePage = class("SoldierSkillUpgradePage",_GModel.IBasePage)
local configManager    = TWRequire("ConfigDataManager")
local ConstCfg 		   = TWRequire("ConstCfg")
local SimpleAniNode    = TWRequire("SimpleAniNode")

function SoldierSkillUpgradePage:_init(data)
	self._skillId = data.id
	self._curStarLevel = 0
	self._cfg = configManager:getConfigById(self._skillId)
	self._key = "SoldierSkill_"..tostring(self._skillId)

	self:initUI()
	self:onRefreshStars()
end

function SoldierSkillUpgradePage:initUI()
	self._LevelUpAni = SimpleAniNode.new("UI/Effects/SkillLevelUpgrade.csb",false)
	self:addChildNode("effectNode",self._LevelUpAni)
	self._LevelUpAni:setPosition(cc.p(0,0))
	self._LevelUpAni:stop()

	local panelBG = self:getNode("PanelBG")
	panelBG:onTouch(handler(self,self._close))
	
	self:addBtnClickListener("btnClose",self._close)
	self:addBtnClickListener("btnReset",self.onBtnReset)
	self:addBtnClickListener("btnUpgrade",self.OnBtnUpgrade)

	self:setNodeVisibleLang("Title")
	self:setNodeVisibleLang("ContentText")
	self:setNodeVisibleLang("TextComsume")
	self:setNodeVisibleLang("text_reset")
	self:setNodeVisibleLang("text_upgrade")

	self:addListener(MessageDef_GameLogic.MSG_RefreshSkillStars,self.onRefreshStars)
end

function SoldierSkillUpgradePage:onRefreshStars()
	if not self._cfg then return end

	local temp  = getPlayerSetting(self._key,SettingType.TYPE_INT,0)
	local starCount = tonumber(temp.Value)
	self._curStarLevel = starCount
	local isMax = self._curStarLevel >= ConstCfg.SKILL_STAR_COUNT
	local nextLevelInfo = nil
	if isMax then
		nextLevelInfo = self._cfg.levels[ConstCfg.SKILL_STAR_COUNT]
	else
		nextLevelInfo = self._cfg.levels[starCount + 1]
	end

	self._curUpgradeStar = nextLevelInfo.star

	self:setLabelTextLang("ContentText",_Lang(nextLevelInfo.desc))
	self:setLabelText("TextComsumeNum",nextLevelInfo.star)

	for i=1,ConstCfg.SKILL_STAR_COUNT do
		self:setNodeVisible(string.format("SkillStar%d",i),i<=starCount)
	end

	temp = getPlayerSetting("finishStarCount",SettingType.TYPE_INT,0)
	local finishStarCount = temp.Value

	temp  = getPlayerSetting("SoldierSkillGetUsedStar",SettingType.TYPE_INT,0)
	local usedStar = tonumber(temp.Value)

	self._curCanUsed = finishStarCount - usedStar
	self:setLabelText("TextStarCount",self._curCanUsed)
	self:setButtonEnable("btnUpgrade",not isMax)
	self:setSpriteFrame("Icon",self._cfg.icon)
	self:setLabelTextLang("Title",_Lang(self._cfg.title))
	self:setButtonEnable("btnReset",self._curStarLevel > 0 )
end

function SoldierSkillUpgradePage:onBtnReset()
	local temp  = getPlayerSetting("SoldierSkillGetUsedStar",SettingType.TYPE_INT,0)
	local usedStar = tonumber(temp.Value)

	local stars = 0
	local levels = self._cfg.levels
	for i=1,self._curStarLevel do
		stars = stars + levels[i].star
	end

	usedStar = usedStar - stars
	setPlayerSetting("SoldierSkillGetUsedStar",SettingType.TYPE_INT,usedStar)
	setPlayerSetting(self._key,SettingType.TYPE_INT,0)

	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_RefreshSkillStars)
end

function SoldierSkillUpgradePage:OnBtnUpgrade()
	if self._curCanUsed >= self._curUpgradeStar then
		local temp  = getPlayerSetting("SoldierSkillGetUsedStar",SettingType.TYPE_INT,0)
		local usedStar = tonumber(temp.Value)
		usedStar = usedStar + self._curUpgradeStar

		setPlayerSetting("SoldierSkillGetUsedStar",SettingType.TYPE_INT,usedStar)

		local newSkillLevel = self._curStarLevel + 1
		if newSkillLevel >= ConstCfg.SKILL_STAR_COUNT then
			newSkillLevel = ConstCfg.SKILL_STAR_COUNT
		end

		setPlayerSetting(self._key,SettingType.TYPE_INT,newSkillLevel)

		gRootManager:ShowMsgBox("@SkillUpgradeSuccess")

		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_RefreshSkillStars)

		QueueEvent(EventType.ScriptEvent_Sound,{id = "Sound_SkillUpgrade"})

		self._LevelUpAni:play()
	else
		gRootManager:ShowMsgBox("@WarningOutofStar",false)
	end
end

return SoldierSkillUpgradePage