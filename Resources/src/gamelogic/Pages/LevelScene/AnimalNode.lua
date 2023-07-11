local AnimalNode = class("AnimalNode",ccui.Widget,_GModel.IBaseInterface)
local Vector2D  = TWRequire("Vector2D")

local  AnimalState = 
{
	StateIdle = 1,
	StateWalk = 2
}

function AnimalNode:ctor(name)
	local fileUtils = cc.FileUtils:getInstance()
	local animalName = string.split(name,"_")[1]
	local str = string.format("UI/animals/animal%s.csb",animalName)
	local strCfg = string.format("config/Animals/%sCfg.lua",animalName)
	local cfgData = fileUtils:getStringFromFile(strCfg)
	local cfg = assert(loadstring(cfgData))()

	self._Name = name
	self._Speed = cfg.speed
	local idleArray = string.split(cfg.idleTime,',')
	self._MinIdleTime = tonumber(idleArray[1])
	self._MaxIdleTime = tonumber(idleArray[2])

	self._IdleTime = math.random(self._MinIdleTime,self._MaxIdleTime)
	self._Dir = Vector2D.new(0,0)
	self._Pos = Vector2D.new(0,0)
	self._MoveTime = 0

	self._State = AnimalState.StateIdle

	self:load(str)

	self:_scheduleUpdate()

	self:playTimeLine("idle",true)
end

function AnimalNode:SetPos(x,y)
	self._Pos:Set(x,y)
	self:setPosition(x,y)
end

function AnimalNode:getName()
	return self._Name
end

function AnimalNode:setRoads(roads)
	self._roads = roads
end

function AnimalNode:_update(dt)
	if self._State == AnimalState.StateIdle then
		self._IdleTime = self._IdleTime - dt
		if self._IdleTime <=0 then
			local index = math.random(1,#self._roads)
			local newPos = self._roads[index]
			local dir  = newPos - self._Pos
			self._MoveTime = dir:Length()/self._Speed
			self._CurMoveTime = 0
			dir:SetNormalize()
			self:setScaleX(dir.x < 0 and 1 or -1)
			self._Dir = dir
			self:playTimeLine("walk",true)
			self._State = AnimalState.StateWalk
			self._StartPos = Vector2D.new(self._Pos.x,self._Pos.y)
			self._EndPos = newPos
		end
	elseif self._State == AnimalState.StateWalk then
		self._CurMoveTime = self._CurMoveTime + dt

		if self._CurMoveTime >= self._MoveTime then
			self:playTimeLine("idle",true)
			self._State = AnimalState.StateIdle
			self._IdleTime = math.random(self._MinIdleTime,self._MaxIdleTime)
		else
			local ratio = self._CurMoveTime/self._MoveTime
			local newPos = Vector2D.Lerp(self._StartPos,self._EndPos,ratio )
			self:SetPos(newPos.x,newPos.y)
		end
	end

end

return AnimalNode