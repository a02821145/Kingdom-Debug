local ManagerCenter = class("ManagerCenter")

function ManagerCenter:ctor()
	self.managers = {}
	self.instance = nil
	self.pause = false
end

function ManagerCenter:Instance()
	if self.instance == nil then
		self.instance = self:new()
	end

	return self.instance
end

function ManagerCenter:Enter()
	local mgrNameList = TWRequire("ManagerList")

	if mgrNameList and next(mgrNameList) then
		for i,name in ipairs(mgrNameList) do
			self:addOneMgr(name)
		end
	end

	self:addMsgListener()
end

function ManagerCenter:addMsgListener()
	gMessageManager:registerMessageHandler(MessageDef_GameLogic.MSG_GameOver,handler(self,self.onGameOver))
	gMessageManager:registerMessageHandler(MessageDef_GameLogic.Msg_LevelScene_EndGame,handler(self,self.onGameOver))
	gMessageManager:registerMessageHandler(MessageDef_GameLogic.MSG_GameStart,handler(self,self.onStartGame))
	gMessageManager:registerMessageHandler(MessageDef_GameLogic.MSG_PauseGame,handler(self,self.onPause))
	gMessageManager:registerMessageHandler(MessageDef_GameLogic.MSG_Restart,handler(self,self.onRestart))
	gMessageManager:registerMessageHandler(MessageDef_RootManager.MSG_AfterChangeScene,handler(self,self.onAfterChangeScene))
end

function ManagerCenter:removeMsgListener()
	gMessageManager:removeAllMessageHandler(MessageDef_GameLogic.MSG_GameOver)
	gMessageManager:removeAllMessageHandler(MessageDef_GameLogic.Msg_LevelScene_EndGame)
	gMessageManager:removeAllMessageHandler(MessageDef_GameLogic.MSG_GameStart)
	gMessageManager:removeAllMessageHandler(MessageDef_GameLogic.MSG_PauseGame)
	gMessageManager:removeAllMessageHandler(MessageDef_RootManager.MSG_AfterChangeScene)
	gMessageManager:removeAllMessageHandler(MessageDef_GameLogic.MSG_Restart)
end

function ManagerCenter:onStartGame()
	self.pause  = false
	for _,mgr in ipairs(self.managers) do
		mgr:onStartGame()
	end
end

function ManagerCenter:onGameOver()
	for _,mgr in ipairs(self.managers) do
		mgr:onGameOver()
	end
end

function ManagerCenter:onRestart()
	for _,mgr in ipairs(self.managers) do
		mgr:onRestart()
	end
end

function ManagerCenter:onPause(data)
	self.pause = data.isPause
end

function ManagerCenter:onAfterChangeScene()
	for _,mgr in ipairs(self.managers) do
		mgr:afterChangeScene()
	end
end

function ManagerCenter:addOneMgr(name)
	local mgrClass = TWRequire(name)
	if mgrClass then
		mgrClass:onEnter()
		table.insert(self.managers,mgrClass)
	end
end

function ManagerCenter:update(dt)
	if self.pause then return end

	for _,mgr in ipairs(self.managers) do
		mgr:update(dt)
	end
end

function ManagerCenter:render()
	for _,mgr in ipairs(self.managers) do
		mgr:render()
	end
end

function ManagerCenter:Exit()
	for _,mgr in ipairs(self.managers) do
		mgr:onExit()
	end
	self.managers = {}

	self:removeMsgListener()
end

return ManagerCenter:Instance()