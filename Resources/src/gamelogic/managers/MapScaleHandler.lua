local MapScaleHandler = class("MapScaleHandler")
local ConstCfg 		   = TWRequire("ConstCfg")

local MAX_SCALE_LENGTH = 500
function MapScaleHandler:ctor(mapNode)
	self._MapNode = mapNode
	self._TouchStart = false
	self._StartTouchesPoint = {}
	self._TouchCenter = {}
	self._StartTouchLen = 0
	self._TouchList = {}
	local x,y = mapNode:getPosition()
	self._PosDelta = cc.p(0,0)
	self._OldMapPos = cc.p(x,y)
	self._OldScale = 1
end

function MapScaleHandler:OnTouchesBegin(touchesPoint)
	table.insert(self._StartTouchesPoint,touchesPoint)
	local startTouchesCount = #self._StartTouchesPoint


	if #self._StartTouchesPoint > 1 then
		local p = cc.pAdd(self._StartTouchesPoint[1],self._StartTouchesPoint[2])
		self._TouchCenter = cc.pMul(p,0.5)
		self._TouchStart = true
		local touchDir = cc.pSub(self._StartTouchesPoint[1],self._StartTouchesPoint[2])
		self._StartTouchLen = cc.pGetLength(touchDir)
		self._TouchCenter = self._MapNode:convertToNodeSpace(self._TouchCenter)
		local x,y = self._MapNode:getPosition()
		self._OldScale = self._MapNode:getScale()
		self._OldMapPos = cc.p(x,y)
	end
end

function MapScaleHandler:OnTouchesMoved(touchesPoint,touchesDelta)
	if not self._TouchStart then
		return
	end

	local len1 = cc.pGetLength(touchesDelta[1])
	local len2 = cc.pGetLength(touchesDelta[2])

	local dir1 = cc.pNormalize(touchesDelta[1])
	local dir2 = cc.pNormalize(touchesDelta[2])

	local dotValue = cc.pDot(dir1,dir2)
	if dotValue > 0 then
		return
	end

	local touchDir = cc.pSub(touchesPoint[1],touchesPoint[2])
	local touchLen = cc.pGetLength(touchDir)
	local deltaLen = touchLen - self._StartTouchLen
	local dir = deltaLen > 0 and 1 or -1
	deltaLen = math.abs(deltaLen)
	if deltaLen >= MAX_SCALE_LENGTH then
		deltaLen= MAX_SCALE_LENGTH
	end

	self:OnScaleMap(deltaLen * dir)
end

function MapScaleHandler:OnTouchesEnd()
	self._TouchStart = false
	self._StartTouchesPoint = {}
	self._TouchCenter = {}
	self._TouchList = {}
end

function MapScaleHandler:Update(dt)
	if not next(self._TouchList) then
		return
	end

	local scaleData = self._TouchList[1]
	table.remove(self._TouchList,1)
	
	local scale = self._OldScale + scaleData.speed/MAX_SCALE_LENGTH

	if scale >= ConstCfg.MAX_MAP_SCALE_SIZE then
		scale = ConstCfg.MAX_MAP_SCALE_SIZE
	end

	if scale <= ConstCfg.MIN_MAP_SCALE_SIZE then
		scale = ConstCfg.MIN_MAP_SCALE_SIZE
	end

	self._MapNode:setScale(scale)
	self:RelocalPos()
end

function MapScaleHandler:RelocalPos()
	local scale = self._MapNode:getScale()
	local scaleDelta = scale - self._OldScale
	local deltaPos = cc.pMul(self._TouchCenter,scaleDelta)
	local curPos = cc.pSub(self._OldMapPos,deltaPos)
	self._MapNode:setPosition(curPos.x,curPos.y)
end

function MapScaleHandler:OnScaleMap(force)
	local dir = force > 0 and 1 or -1
	local realForce = math.abs(force)


	local touchData = 
	{
		speed = realForce * dir
	}

	table.insert(self._TouchList,touchData)
end

return MapScaleHandler