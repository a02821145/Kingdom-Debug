local DebugGameWinOrLosePage = class("DebugGameWinOrLosePage",_GModel.IBasePage)

function DebugGameWinOrLosePage:_init(data)
	self:_initUI()
end

function DebugGameWinOrLosePage:_initUI()

	self:addBtnClickListener("btnWin",self.onBtnWin)
	self:addBtnClickListener("btnLose",self.onBtnLose)

	self._TFStarCount = self:getNode("TFStarCount")
end

function DebugGameWinOrLosePage:onBtnWin()
	local str = self._TFStarCount:getString()
	local starCount = tonumber(str)

	local data =
	{
		command="onGMCommandCheckout",
		starCount = starCount,
		isWin = true,
	}

	print("DebugGameWinOrLosePage:onBtnWin")
	dump(data)
	
	QueueEvent(EventType.ScriptEvent_GameCommand,data)
end

function DebugGameWinOrLosePage:onBtnLose()
	local data =
	{
		command="onGMCommandCheckout",
		isWin = false,
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,data)
end


return DebugGameWinOrLosePage