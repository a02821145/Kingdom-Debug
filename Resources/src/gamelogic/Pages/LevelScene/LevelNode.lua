local SimpleAniNode = TWRequire("SimpleAniNode")
local LevelNode = class("LevelNode", ccui.Widget,_GModel.IBaseInterface)

function LevelNode:ctor(data)
	self:load("UI/buildings/LevelNode.csb")
	self._isOpen = data.isOpen
	self._Level = data.level
	self._isCurrent = data.isCurrent
	self._isMax = data.isMax

	self:InitUI()
	self:playTimeLine("start",true)
	self:setPosition(cc.p(0,0))

	self:setNodeVisibleLang("TextLevel")

	local textLevelStr = _Lang("@LevelGuanKa",self._Level)
	if self._Level == 1 then
		textLevelStr = string.format("%s %s",textLevelStr,_Lang("@NoviceCollege"))
	end

	self:setLabelTextLang("TextLevel",textLevelStr)
end

function LevelNode:InitUI()
	self:setNodeVisible("btnLevelNotOccupy",not self._isOpen)
	self:setNodeVisible("btnLevelOccupy",self._isOpen)
	self:addBtnClickListener("btnClick",self.onSelectLevel)
	local curLevelNode = self:getNode("curLevelNode")
	curLevelNode:removeAllChildren()

	self._LevelCfg = _GModel.LevelManager:getLevelData(self._Level)

	if self._isCurrent then
		local LevelArrowAniNode = TWRequire("LevelArrowAniNode")
		local AniNode = LevelArrowAniNode.new()
		curLevelNode:addChild(AniNode)
		AniNode:setPosition(cc.p(0,0))
	end

	if self._isMax then
		self:setNodeVisible("btnLevelNotOccupy",false)
		self:setNodeVisible("btnLevelOccupy",false)
	end

	local fireEffectNode = self:getNode("FireEffectNode")
	fireEffectNode:removeAllChildren()

	if self._isCurrent then
		local effectNode = SimpleAniNode.new("UI/Effects/EffectCurLevel.csb")
		fireEffectNode:addChild(effectNode)
		effectNode:setPosition(cc.p(0,0))
	end
end

function LevelNode:onSelectLevel()
	if not self._LevelCfg then
		return
	end

	if self._LevelCfg.newbieId then
		local temp = getPlayerSetting("newbieCmd_"..tostring(self._LevelCfg.newbieId),SettingType.TYPE_BOOL,false)
		if not temp.Value then
			local params = {
				level = self._Level
			}

			gMessageManager:sendMessage(MessageDef_GameLogic.Msg_LevelScene_StartGame,params)
		else
			gRootManager:OpenPage("LevelSelectPage",{Level = self._Level})
		end
	else
		gRootManager:OpenPage("LevelSelectPage",{Level = self._Level})
	end
end

return LevelNode
