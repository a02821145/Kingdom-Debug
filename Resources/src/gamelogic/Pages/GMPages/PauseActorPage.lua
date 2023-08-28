local PauseActorPage = class("PauseActorPage",_GModel.IBasePage)

function PauseActorPage:_init(data)
	self._CBPauseActor = self:getNode("CBPauseActor")

	self:addBtnClickListener("btnClose",self._close)

	self:_initEvents()
end

function PauseActorPage:_initEvents()
	-- body
	self._EventIdList = {}

	local id = RegisterEventListener(EventType.ScriptEvent_Touch,handler(self,self.onTouchBegin))
	table.insert(self._EventIdList,id)
end

function PauseActorPage:onTouchBegin(message)
	-- body
	local pauseActor = self._CBPauseActor:isSelected()

	local radius = 16
	local pos = message.pos

	local params =
	{
		command="onCommandPauseActor",
		isPause = pauseActor,
		pos = pos,
		radius = radius,
	}

	QueueEvent(EventType.ScriptEvent_GameCommand,params)
end

function PauseActorPage:_Release()
	for _,id in pairs(self._EventIdList) do
		RemoveEventListener(id)
	end
end

return PauseActorPage