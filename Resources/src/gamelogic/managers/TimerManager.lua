local TimerManager = class("TimerManager",_GModel.IManager)

function TimerManager:_Init()
	self._TimerList = {}
	self._TimerId = 1
end

function TimerManager:AddTimer(timeDelay,isLoop,callback,params)
	if timeDelay <= 0 then return end

	local Timer = {}
	Timer.timeDelay = timeDelay
	Timer.curTime = timeDelay
	Timer.callback = callback
	Timer.isLoop = isLoop
	Timer.params = params
	Timer.id = self._TimerId
	table.insert(self._TimerList,Timer)

	self._TimerId = self._TimerId + 1
	return Timer.id
end

function TimerManager:_Update(dt)
	if next(self._TimerList) then
		local len = #self._TimerList
		for i=len,1,-1 do
			local timer = self._TimerList[i]
			timer.curTime = timer.curTime - dt
			if timer.curTime <=0 then
				if timer.callback then
					timer.callback(timer.params)
				end

				if timer.isLoop then
					timer.curTime = timer.timeDelay
				else
					table.remove(self._TimerList,i)
				end
			end
		end
	end

end

function TimerManager:_Release()
	self._TimerList = {}
end

return TimerManager