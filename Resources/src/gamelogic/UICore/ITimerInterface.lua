local ITimerInterface = class("ITimerInterface")

function ITimerInterface:addTimer(time,callback,isLoop)
	isLoop = isLoop == nil and false or isLoop
	
	self._timerList = self._timerList or {}
	local timer = {}
	timer.time =  time
	timer.curTime = time
	timer.callback = callback
	timer.isLoop = isLoop

	table.insert(self._timerList,timer)
end

function ITimerInterface:_updateTimers(dt)
	if self._timerList and next(self._timerList) then
		local len = #self._timerList
		for i=1,len,-1 do
			local timer = self._timerList[i]
			timer.curTime = timer.curTime - dt
			if timer.curTime <= 0 then
				timer.callback()
				if timer.isLoop then
					timer.curTime = timer.time
				else
					table.remove(self._timerList,i)
				end
			end
		end
	end
end

function ITimerInterface:_releaseTimers()
	self._timerList = {}
end

return ITimerInterface