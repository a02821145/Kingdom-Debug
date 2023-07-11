local IManager = class("IManager",_GModel.IMsgInterface)

function IManager:ctor()
	
end

function IManager:_Init()

end

function IManager:onStartGame()

end

function IManager:onGameOver()

end

function IManager:onRestart()

end

function IManager:onEnter()
	self:_Init()
end

function IManager:_Update(dt)

end

function IManager:update(dt)
	self:_Update(dt)
end

function IManager:render()
	
end

function IManager:_Release(isExit)

end

function IManager:afterChangeScene()
	
end

function IManager:onExit()
	self:_Release(true)
	self:_removeAllMsg()
end

return IManager