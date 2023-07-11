local CheckOutPage = class("CheckOutPage",_GModel.IBasePage)

local playSoundDelay = 2

function CheckOutPage:_init(data)
	self._IsWin =  tonumber(data.isWin) > 0
	self._gems = 0
	self._startCount = 0
	self._iLevel = tonumber(data.level)
	self._strDiff = data.diff

	if self._IsWin then
		self._gems = tonumber(data.gems)
		self._startCount = tonumber(data.star)

		for i=1,3 do
			self:setNodeVisible("star"..i,i == self._startCount)
		end

		self:setLabelText("gemTxt",self._gems)

		self:SaveStar()
	end

	self:initUI()
end


function CheckOutPage:initUI()
	self:setNodeVisible("WinNode",self._IsWin)
	self:setNodeVisible("LoseNode",not self._IsWin)
	self:addBtnClickListener("btnRestart",self.OnRestartGame)
	self:addBtnClickListener("btnExit",self.OnExitGame)

	self:playTimeLine("start",false)

	self._unlockLIst = nil
	self._upgradeList = nil
	self._newbieId = nil

	if self._IsWin then
		cc.AudioEngine:stopAll()
		gRootManager:AddTimer(playSoundDelay,false,function( ... )
			QueueEvent(EventType.ScriptEvent_Sound,{id = "GameOverVictory"})
		end)

		local levelData   = _GModel.LevelManager:getLevelData(self._iLevel)
		self._unlockList  = levelData.unLockList
		self._upgradeList = levelData.ugpradeList
		self._newbieId = levelData.newbieTaskId
	else
		cc.AudioEngine:stopAll()
		gRootManager:AddTimer(playSoundDelay,false,function( ... )
			QueueEvent(EventType.ScriptEvent_Sound,{id = "GameOverLose"})
		end)
	end
end

function CheckOutPage:SaveStar()
	local strKey = string.format("%d_%s",self._iLevel,self._strDiff)
	local temp = getPlayerSetting(strKey,SettingType.TYPE_INT,0)
	local curStarCount = temp.Value

	if curStarCount ~= self._startCount then
		local starData = getPlayerSetting("finishStarCount",SettingType.TYPE_INT,0)
		local newStarCount = starData.Value - curStarCount + self._startCount

		setPlayerSetting("finishStarCount",SettingType.TYPE_INT,newStarCount)

		setPlayerSetting(strKey,SettingType.TYPE_INT,self._startCount)
	end
end

function CheckOutPage:CheckUnLockList()
	if self._unlockList and next(self._unlockList) then

		for _,cfg in pairs(self._unlockList) do
			_GModel.PlayerManager:addUnlcokItem(cfg.id,cfg.isBuilding)
		end
	end
end

function CheckOutPage:CheckUpGrapdeList()
	if self._upgradeList and next(self._upgradeList) then
		for _,cfg in pairs(self._upgradeList) do
			local id = cfg.id
			local level = cfg.level

			local key    = "UnitLV_"..tostring(id)
			local temp   = getPlayerSetting(key,SettingType.TYPE_INT,1)
			local iLevel = tonumber(temp.Value)

			if level > iLevel then
				setPlayerSetting(key,SettingType.TYPE_INT,level)
			end
		end
	end
end

function CheckOutPage:OnRestartGame()
	self:_close()

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_Restart)
end

function CheckOutPage:OnExitGame()
	if self._IsWin then
		local strIsUnlock = string.format("Level%d_unLock",self._iLevel)
		local temp = getPlayerSetting(strIsUnlock,SettingType.TYPE_BOOL,false)
		if not temp.Value then
			setPlayerSetting(strIsUnlock,SettingType.TYPE_BOOL,true)
			local tempLevel = getPlayerSetting("curUnFinishLevel",SettingType.TYPE_INT)
			setPlayerSetting("curUnFinishLevel",SettingType.TYPE_INT,tempLevel.Value+1)
		end

		if self._newbieId then
			_GModel.PlayerManager:insertLevelNewbieId(self._newbieId)
		end

		_GModel.PlayerManager:updateGems(self._gems)

		self:CheckUnLockList()
		self:CheckUpGrapdeList()
	end

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_GameOver)
end

return CheckOutPage