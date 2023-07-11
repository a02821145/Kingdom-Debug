local PausePage = class("PausePage",_GModel.IBasePage)

function PausePage:_init(data)
	local data =
	{
		command="PauseGame",
		isPause = true,
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,data)

	self:addBtnClickListener("btnContinue",self.onContinue)
	self:addBtnClickListener("btnRestart",self.OnRestartGame)
	self:addBtnClickListener("btnExit",self.OnExitGame)

	self:playTimeLine("start",false)

	self:setNodeVisibleLang("continueText")
	self:setNodeVisibleLang("restartText")
	self:setNodeVisibleLang("quitText")
end

function PausePage:onContinue()
	local data =
	{
		command="PauseGame",
		isPause = false,
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,data)

	self:_close()
end

function PausePage:OnRestartGame()
	self:_close()

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_Restart)
end

function PausePage:OnExitGame()
	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_GameOver)
end

return PausePage