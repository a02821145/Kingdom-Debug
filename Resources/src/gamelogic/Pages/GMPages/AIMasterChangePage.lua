local AIMasterChangePage = class("AIMasterChangePage",_GModel.IBasePage)
local ConstCfg = TWRequire("ConstCfg")

function AIMasterChangePage:_init(data)
	self:addBtnClickListener("btn_normal",self.onBtnAINormal)
	self:addBtnClickListener("btn_fast",self.onBtnAIFastAttack)
	self:addBtnClickListener("btn_lastStageGolden",self.onBtnLastStage)
	self:addBtnClickListener("btn_master",self.onBtnMaster)
	self:addBtnClickListener("btn_close",self._close)

	self._CBTeam = self:getNode("CBTeam")
	local AIType = PlayerManager.getAIModel(actor_team.team_NPC)
	local str = ConstCfg.AIModeStrMap[AIType]
	self:setLabelText("Text_Cur_AI",str)

	AIType = PlayerManager.getAIModel(actor_team.team_player)
	str = ConstCfg.AIModeStrMap[AIType]
	self:setLabelText("Text_Cur_My_AI",str)

	local openNPCAI = getPlayerSetting("DebugNPCAI",SettingType.TYPE_BOOL,true)
	local openPlayerAI = getPlayerSetting("DebugPlayerAI",SettingType.TYPE_BOOL,false)

	openNPCAI = openNPCAI.Value
	openPlayerAI = openPlayerAI.Value

	local playerAISPeed = getPlayerSetting("playerAISpeed",SettingType.TYPE_FLOAT,1)
	playerAISPeed = tonumber(playerAISPeed.Value)
	
	self._SpeedSlider = self:getNode("SliderSpeed")
	local ratio = self._SpeedSlider:getPercent()
	print("AIMasterChangePage:_init ratio=",ratio)

	local speedRatio = playerAISPeed/ConstCfg.MAX_AI_SPEED

	self._SpeedSlider:onEvent(handler(self,self.onSlideSpeed))
	self._SpeedSlider:setPercent(speedRatio*100)

	self._cbMyAI = self:getNode("CBMyAI")
	self._cbNPCAI = self:getNode("CBComputerAI")

	self._cbMyAI:onEvent(handler(self,self.onCheckPlayerAI))
	self._cbNPCAI:onEvent(handler(self,self.onCheckNPCAI))

	self._cbMyAI:setSelected(openPlayerAI)
	self._cbNPCAI:setSelected(openNPCAI)

	self:setLabelText("TextSpeedValue",playerAISPeed)
end

function AIMasterChangePage:onCheckNPCAI(data)
	if data.name == "selected" then
		setPlayerSetting("DebugNPCAI",SettingType.TYPE_BOOL,true)
	elseif data.name == "unselected" then
		setPlayerSetting("DebugNPCAI",SettingType.TYPE_BOOL,false)
	end
	PlayerManager.onDebugAIChange()
end

function AIMasterChangePage:onCheckPlayerAI(data)
	if data.name == "selected" then
		setPlayerSetting("DebugPlayerAI",SettingType.TYPE_BOOL,true)
	elseif data.name == "unselected" then
		setPlayerSetting("DebugPlayerAI",SettingType.TYPE_BOOL,false)
	end

	PlayerManager.onDebugAIChange()
end

function AIMasterChangePage:onSlideSpeed(data)
	if data.name == "ON_PERCENTAGE_CHANGED" then
		local speedPercent = self._SpeedSlider:getPercent()
		local realSpeed = speedPercent *ConstCfg.MAX_AI_SPEED*0.01
		setPlayerSetting("playerAISpeed",SettingType.TYPE_FLOAT,realSpeed)
		PlayerManager.onDebugAIChange()
		self:setLabelText("TextSpeedValue",realSpeed)
	end
end

function AIMasterChangePage:onBtnAINormal()
	self:SetAIModelType(EPlayerAIType.PlayerAITypeNormal)
end

function AIMasterChangePage:onBtnAIFastAttack()
	self:SetAIModelType(EPlayerAIType.PlayerAITypeFast)
end

function AIMasterChangePage:onBtnLastStage()
	self:SetAIModelType(EPlayerAIType.PlayerAITypeLateStageGod)
end

function AIMasterChangePage:onBtnMaster()
	self:SetAIModelType(EPlayerAIType.PlayerAITypeMaster)
end

function AIMasterChangePage:SetAIModelType(t)
	local isMyTeamCheckk = self._CBTeam:isSelected();
	local team = isMyTeamCheckk and actor_team.team_player or actor_team.team_NPC
	PlayerManager.setAIModel(team,t)
	local strKey = isMyTeamCheckk and "PlayerAIModel_MY" or  "PlayerAIModel_EY"

	setPlayerSetting(strKey,SettingType.TYPE_INT,t)

	local AIType = PlayerManager.getAIModel(actor_team.team_NPC)
	local str = ConstCfg.AIModeStrMap[AIType]
	self:setLabelText("Text_Cur_AI",str)

	AIType = PlayerManager.getAIModel(actor_team.team_player)
	str = ConstCfg.AIModeStrMap[AIType]
	self:setLabelText("Text_Cur_My_AI",str)

end

return AIMasterChangePage