local IBaseInterface = class("IBaseInterface")

function IBaseInterface:load(path)
	self.sceneNode = cc.CSLoader:createNode(path)
	self.timeLine  = cc.CSLoader:createTimeline(path)
	assert(self.sceneNode~=nil,"failed to load scence node"..path)
	assert(self.timeLine~=nil, "failed to load scence timeline"..path)
	self:addChild(self.sceneNode)
	self.sceneNode:runAction(self.timeLine)

	self.needUpdate = false
	self.nodes = {}
	self._listViews = {}
	self._btnClickCallbackList = {}

	self.sceneNode:setName(game_const.csb_tag_node)

	local director = cc.Director:getInstance()
	self._winSize = director:getWinSize()
	self._moveDelta =  0

	self:relocate()
end

function IBaseInterface:setSceneNode(sceneNode)
	self.needUpdate = false
	self.nodes = {}
	self._listViews = {}
	self._btnClickCallbackList = {}
	self.sceneNode = sceneNode
end

function IBaseInterface:getNode(nodeName)
	assert(nodeName~=nil,"IBaseInterface:getNode nodeName is nil")
	assert(self.sceneNode~=nil,"not yet load scene node nodeName")
	local node = self.nodes[nodeName]
	if not node then
		node = cc.utils.findChild(self.sceneNode,nodeName)
	end

	if not node then
		LogWarn("getNode failed to get node %s",nodeName)
	else
		self.nodes[nodeName] = node
	end

	return node
end

function IBaseInterface:getNodeLang(nodeName)
	local StringUtil = TWRequire("StringUtil")
	local isChineseW = StringUtil:isChinese()
	local endFix = isChineseW and "_zh" or ""

	return self:getNode(nodeName..endFix)
end

function IBaseInterface:getSceneNodeLang(nodeName,sceneNode)
	local StringUtil = TWRequire("StringUtil")
	local isChineseW = StringUtil:isChinese()
	local endFix = isChineseW and "_zh" or ""

	return self:getSceneNode(sceneNode,nodeName..endFix)
end

function IBaseInterface:playTimeLine(name,isLoop,callback,time)
	if not self.timeLine then
		LogError("timeline is nil")
		return
	end

	local actInfo = self.timeLine:getAnimationInfo(name)
	if actInfo and callback then
		local dur = (actInfo.endIndex - actInfo.startIndex)*0.05
		gRootManager:AddTimer(time ~= nil and time or dur,false,callback)
	end

	self.timeLine:play(name,isLoop)
end

function IBaseInterface:playSceneNodeTimeLine(timeLine,name,isLoop,callback,time)
	if not timeLine then
		LogError("timeline is nil")
		return
	end

	local actInfo = timeLine:getAnimationInfo(name)
	if actInfo and callback then
		local dur = (actInfo.endIndex - actInfo.startIndex)*0.05
		gRootManager:AddTimer(time ~= nil and time or dur,false,callback)
	end

	timeLine:play(name,isLoop)
end

function IBaseInterface:StopTimeLine()
	self.timeLine:stop()
end

function IBaseInterface:getSceneNode(sceneNode,nodeName)
	assert(sceneNode~=nil,"not yet load scene node")

	local node = self.nodes[nodeName]
	if not node then
		node = cc.utils.findChild(sceneNode,nodeName)
	end

	if not node then
		LogWarn("getSceneNode failed to get node %s",nodeName)
	else
		self.nodes[nodeName] = node
	end

	return node
end

function IBaseInterface:GetListView(name)
	self._listViews = self._listViews or {}
	local LV = self._listViews[name]

	if LV then return LV end

	LV = self:getNode(name)

	if LV then
		self._listViews[name] = LV
	end

	return LV
end

function IBaseInterface:GetSceneNodeListView(sceneNode,name)
	self._listViews = self._listViews or {}
	local LV = self._listViews[name]

	if LV then return LV end

	LV = self:getSceneNode(sceneNode,name)

	if LV then
		self._listViews[name] = LV
	end

	return LV
end


function IBaseInterface:_scheduleUpdate()

	self.needUpdate = true
end

function IBaseInterface:_update(dt)

end

function IBaseInterface:update(dt)
	if not self.needUpdate then return end

	self:_update(dt)

	self:_updateTimerList(dt)
end

function IBaseInterface:_updateTimerList(dt)
	if self.timers and next(self.timers) then
		for _,timer in ipairs(self.timers) do
			if self[timer.funcName] then
				timer.curTime = timer.curTime + dt
				if timer.curTime >= timer.timer then
					timer.curTime = 0
					self[timer.funcName](self)
				end
			end
		end
	end
end

function IBaseInterface:setTimer(timer)
	if not timer or type(timer) ~= "number" or timer <=0 then
		LogWarn("IBaseInterface:setTimer invalid timer")
		return
	end
	local strTimer = tostring(timer)
	strTimer = string.gsub(strTimer, "%p", "")

	self.timers = self.timers or {}
	local newTimer = {}
	newTimer.timer = timer
	newTimer.curTime = timer
	newTimer.funcName = "updateTimer"..strTimer
	Log("IBaseInterface:setTimer funcName =%s",newTimer.funcName)
	table.insert(self.timers,newTimer)
end

function IBaseInterface:setSpriteNum(fmt,num,spName,sceneNode)

	local wei_name = {
		[1] = "ge",
		[2] = "shi",
		[3] = "bai",
		[4] = "bai",
	}

	local parentNode = sceneNode and sceneNode or self.sceneNode
	for i,v in ipairs(wei_name) do
		local numberNode = cc.utils.findChild(parentNode,string.format(spName,v))
		if numberNode then
			numberNode:setVisible(false)
		else
			break
		end
	end

	local weiLen = #wei_name
	local iIndex = 1
	local lastNum = 0;

	if num == 0 then
		local numberNode = cc.utils.findChild(parentNode,string.format(spName,wei_name[1]))
		if numberNode then
			numberNode:setVisible(true)
			numberNode:setSpriteFrame(string.format(fmt,0))
		end

		return
	end

	while(num > 0 and iIndex <= weiLen )
	do
		local numberNode = cc.utils.findChild(parentNode,string.format(spName,wei_name[iIndex]))

		if not numberNode then
			break
		end

		local n1 = num%10
		num = math.floor(num/10)

		iIndex = iIndex + 1

		lastNum = n1
		numberNode:setVisible(true)
		numberNode:setSpriteFrame(string.format(fmt,n1))
	end

	local numberNode = cc.utils.findChild(parentNode,string.format(spName,wei_name[iIndex-1]))
	if numberNode and lastNum == 0 and iIndex > 1 then
		numberNode:setVisible(false)
	end
end

function IBaseInterface:_initTouches()
	local touchesBeginHandler = handler(self,self._onTouchesBegin)
	local touchesMoveHandler  = handler(self,self._onTouchesMoved)
	local touchesEndHandler   = handler(self,self._onTouchesEnded)

	local touchLayer = cc.Layer:create()
	local listener = cc.EventListenerTouchAllAtOnce:create()
    listener:registerScriptHandler(touchesBeginHandler, cc.Handler.EVENT_TOUCHES_BEGAN)
    listener:registerScriptHandler(touchesMoveHandler,  cc.Handler.EVENT_TOUCHES_MOVED )
    listener:registerScriptHandler(touchesEndHandler,   cc.Handler.EVENT_TOUCHES_ENDED )

    local eventDispatcher = touchLayer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, touchLayer) 
   
    self:addChild(touchLayer)
end

function IBaseInterface:_initMouseEvent()
	local mouseDownHandler = handler(self,self._onMouseDown)
	local mouseUpHandler = handler(self,self._onMouseUp)
	local mouseMoveHandler = handler(self,self._onMouseMove)
	local mouseScrollHandler = handler(self,self._onMouseScroll)

	local mouseLayer = cc.Layer:create()
	local listener = cc.EventListenerMouse:create()
	listener:registerScriptHandler(mouseDownHandler,cc.Handler.EVENT_MOUSE_DOWN)
	listener:registerScriptHandler(mouseUpHandler,cc.Handler.EVENT_MOUSE_UP)
	listener:registerScriptHandler(mouseMoveHandler,cc.Handler.EVENT_MOUSE_MOVE)
	listener:registerScriptHandler(mouseScrollHandler,cc.Handler.EVENT_MOUSE_SCROLL)

	self:addChild(mouseLayer)
end

function IBaseInterface:_initKeyBoard()
	local keyPressLayer = cc.Layer:create()
	local keyPressedHandler = handler(self,self._onKeyDownCallback)
	local keyReleaseHandler = handler(self,self._onKeyReleaseCallback)

	local keyboardEventListener = cc.EventListenerKeyboard:create()
    keyboardEventListener:registerScriptHandler(keyPressedHandler,cc.Handler.EVENT_KEYBOARD_PRESSED )
    keyboardEventListener:registerScriptHandler(keyReleaseHandler,cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = keyPressLayer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(keyboardEventListener, keyPressLayer) 
    self:addChild(keyPressLayer)

    self._KeyCodeList = {}
end

function IBaseInterface:_setAsRootNode()
	local rootManager = TWRequire("RootManager")
	rootManager:setNodesWithScene(self)
end

function IBaseInterface:_onTouchesBegin(touches, event)
	local touchesPos = {}
	for _,touch in ipairs(touches) do
		local location = touch:getLocation()
		table.insert(touchesPos,location)
	end

	self:_onSingleTouchBegin(touchesPos[1])

	local count = #touchesPos
	if count == 1 then
		gMessageManager:sendMessage(MessageDef_RootManager.MSG_SingleTouchBegin,{pos = touchesPos[1]})
	elseif count > 1 then
		gMessageManager:sendMessage(MessageDef_RootManager.MSG_MulitiTouchesBegin,{pos = touchesPos})
	end
end

function IBaseInterface:_onTouchesMoved(touches, event)
	local touchesPos = {}
	local touchesDeltas = {}

	for _,touch in ipairs(touches) do
		local location = touch:getLocation()
		local delta    = touch:getDelta()

		table.insert(touchesPos,location)
		table.insert(touchesDeltas,delta)
	end

	self:_onSingleTouchMoved(touchesPos[1],touchesDeltas[1])

	if #touchesPos > 1 then
		self:_onMultiTouchMoved(touchesPos,touchesDeltas)
	end

	local count = #touchesPos
	if count == 1 then
		gMessageManager:sendMessage(MessageDef_RootManager.MSg_SingleTouchMove,{pos = touchesPos[1],delta = touchesDeltas[1] })
	elseif count > 1 then
		gMessageManager:sendMessage(MessageDef_RootManager.MSG_MultiTouchesMove,{pos = touchesPos,delta = touchesDeltas })
	end
end

function IBaseInterface:_onTouchesEnded(touches, event)
	local touchesPos = {}
	for _,touch in ipairs(touches) do
		local location = touch:getLocation()
		table.insert(touchesPos,location)
	end

	self:_onSingleTouchEnd(touchesPos[1])
	self:_onMultiTouchEnd(touchesPos)

	gMessageManager:sendMessage(MessageDef_RootManager.MSG_TouchEnd)
end

function IBaseInterface:_onKeyRelease(key)
	Log("IBaseInterface:_onKeyRelease key =%s",key)
end

function IBaseInterface:_onKeyDown(key)
	Log("IBaseInterface:_onKeyDown key =%s",key)
end

function IBaseInterface:_onKeyDownCallback(key, event)
	table.insert(self._KeyCodeList,key)

	if next(self._KeyCodeList) then
		local key = ""
		local len = #self._KeyCodeList
		if len == 1 then
			local keyCode = self._KeyCodeList[1]
			key = cc.KeyCodeStr[keyCode]
		elseif len > 1 then
			local keyStrList = {}
			for _,keyCode in ipairs(self._KeyCodeList) do
				local keyStr = cc.KeyCodeStr[keyCode]
				table.insert(keyStrList,keyStr)
			end

			key = table.concat(keyStrList,"_")
		end

		if self.keyCallbackMap and next(self.keyCallbackMap) then
			local callback = self.keyCallbackMap[key]
			if callback then
				callback(self,key)
			end
		end
		
		self:_onKeyDown(key)
	end

end

function IBaseInterface:_onKeyReleaseCallback()
	if next(self._KeyCodeList) then
		local key = ""
		local len = #self._KeyCodeList
		if len == 1 then
			local keyCode = self._KeyCodeList[1]
			key = cc.KeyCodeStr[keyCode]
		elseif len > 1 then
			local keyStrList = {}
			for _,keyCode in ipairs(self._KeyCodeList) do
				local keyStr = cc.KeyCodeStr[keyCode]
				table.insert(keyStrList,keyStr)
			end

			key = table.concat(keyStrList,"_")
		end

		if self.keyReleaseCallbackMap and next(self.keyReleaseCallbackMap) then
			local callback = self.keyReleaseCallbackMap[key]
			if callback then
				callback(self,key)
			end
		end
		
		self:_onKeyRelease(key)
	end

	self._KeyCodeList = {}
end

function IBaseInterface:setKeyPressedCallback(...)
	local params = {...}
	local bindKeyTable = {}
	local callback = nil

	for _,v in ipairs(params) do
		if type(v) == "number" then
			local keyStr = cc.KeyCodeStr[v]
			if keyStr then
				table.insert(bindKeyTable,keyStr)
			end
		elseif type(v) == "function" then
			callback = v
		end
	end

	local key = ""
	local tabLen = #bindKeyTable

	if tabLen == 1 then
		key = bindKeyTable[1]
	elseif tabLen > 1 then
		key = table.concat(bindKeyTable,"_")
	end

	if #key > 0 then
		self.keyCallbackMap = self.keyCallbackMap or {}
		local h = handler(self,callback)
		self.keyCallbackMap[key] = h
	end
end

function IBaseInterface:setKeyReleaseCallback(...)
	local params = {...}
	local bindKeyTable = {}
	local callback = nil

	for _,v in ipairs(params) do
		if type(v) == "number" then
			local keyStr = cc.KeyCodeStr[v]
			if keyStr then
				table.insert(bindKeyTable,keyStr)
			end
		elseif type(v) == "function" then
			callback = v
		end
	end

	local key = ""
	local tabLen = #bindKeyTable

	if tabLen == 1 then
		key = bindKeyTable[1]
	elseif tabLen > 1 then
		key = table.concat(bindKeyTable,"_")
	end

	if #key > 0 then
		self.keyReleaseCallbackMap = self.keyReleaseCallbackMap or {}
		local h = handler(self,callback)
		self.keyReleaseCallbackMap[key] = h
	end
end

function IBaseInterface:_onSingleTouchBegin(pos)

end

function IBaseInterface:_onSingleTouchMoved(pos,delta)

end

function IBaseInterface:_onMultiTouchMoved(touchesPos,touchesDelta)

end

function IBaseInterface:_onSingleTouchEnd(pos)

end

function IBaseInterface:_onMultiTouchEnd(touchesPos)

end


function IBaseInterface:_onMouseDown()

end

function IBaseInterface:_onMouseUp()

end

function IBaseInterface:_onMouseMove()

end

function IBaseInterface:_onMouseScroll()

end

function IBaseInterface:setNodeVisible(nodeName,visible)
	local node = self:getNode(nodeName)
	if node then
		node:setVisible(visible)
	end
end

function IBaseInterface:setPositionLangY(nodeName,posY)
	local zhNode = self:getNode(nodeName.."_zh")
	local n = self:getNode(nodeName)
	zhNode:setPositionY(posY)
	n:setPositionY(posY)
end

function IBaseInterface:setSceneNodeVisible(nodeName,visible,sceneNode)
	local node = self:getSceneNode(sceneNode,nodeName)
	if node then
		node:setVisible(visible)
	end
end

function IBaseInterface:setNodeVisibleLang(nodeName,isShow)
	isShow = isShow == nil and true or isShow

	local StringUtil = TWRequire("StringUtil")
	local isChineseW = StringUtil:isChinese()
	local showEndFix = isChineseW and "_zh" or ""
	local hideEndFix = isChineseW and "" or "_zh"

	if isShow == true then
		self:setNodeVisible(nodeName..showEndFix,true)
		self:setNodeVisible(nodeName..hideEndFix,false)
	else
		self:setNodeVisible(nodeName..showEndFix,false)
		self:setNodeVisible(nodeName..hideEndFix,false)
	end
end

function IBaseInterface:setSceneNodeVisibleLang(nodeName,isShow,sceneNode)
	isShow = isShow == nil and true or isShow

	local StringUtil = TWRequire("StringUtil")
	local isChineseW = StringUtil:isChinese()
	local showEndFix = isChineseW and "_zh" or ""
	local hideEndFix = isChineseW and "" or "_zh"

	if isShow == true then
		self:setSceneNodeVisible(nodeName..showEndFix,true,sceneNode)
		self:setSceneNodeVisible(nodeName..hideEndFix,false,sceneNode)
	else
		self:setSceneNodeVisible(nodeName..showEndFix,false,sceneNode)
		self:setSceneNodeVisible(nodeName..hideEndFix,false,sceneNode)
	end
end

function IBaseInterface:setNodePosition(nodeName,x,y)
	local node = self:getNode(nodeName)
	if node then
		node:setPosition(x,y)
	end
end

function IBaseInterface:setNodesVisible(nodesMap)
	for nodeName,visible in pairs(nodesMap) do
		self:setNodeVisible(nodeName,visible)
	end
end

function IBaseInterface:setSceneNodesVisible(nodesMap,sceneNode)
	for nodeName,visible in pairs(nodesMap) do
		self:setSceneNodeVisible(nodeName,visible,sceneNode)
	end
end

function IBaseInterface:setLabelText(nodeName,str,sceneNode)
	local node = nil

	if sceneNode then
		node = self:getSceneNode(sceneNode,nodeName)
	else
		node = self:getNode(nodeName)
	end

	if node then
		node:setString(str)
	end
end

function IBaseInterface:setLabelTextLang(nodeName,str)

	local StringUtil = TWRequire("StringUtil")
	local isChineseW = StringUtil:isChinese()
	local showEndFix = isChineseW and "_zh" or ""

	self:setLabelText(nodeName..showEndFix,str)
end

function IBaseInterface:setNodeColorRGB(nodeName,r,g,b)
	local node = self:getNode(nodeName)
	if node then
		local c = cc.c3b(r,g,b)
		node:setColor(c)
	end
end

function IBaseInterface:setNodeColor(nodeName,c,sceneNode)
	local node = nil
	if sceneNode then
		node = self:getSceneNode(sceneNode,nodeName)
	else
		node = self:getNode(nodeName)
	end

	if node then
		node:setColor(c)
	end
end

function IBaseInterface:setTextColorRGBA(nodeName,r,g,b,a)
	local node = self:getNode(nodeName)
	if node then
		local c = cc.c4b(r,g,b,a)
		node:setTextColor(c)
	end
end

function IBaseInterface:setTextColor(nodeName,c,sceneNode)
	local node = nil
	if sceneNode then
		node = self:getSceneNode(sceneNode,nodeName)
	else
		node = self:getNode(nodeName)
	end

	if node then
		node:setTextColor(c)
	end
end

function IBaseInterface:offsetPosition(nodeName,offset)
	local node = self:getNode(nodeName)
	if node then
		local curPosX, curPosY = node:getPosition()
		curPosX = curPosX + offset.x
		curPosY = curPosY + offset.y
		node:setPosition(cc.p(curPosX,curPosY))
	end
end

function IBaseInterface:addBtnClickListener(btnName,callback)
	assert(callback,"IBaseInterface:addBtnClickListener callback is nil")

	local btnNode = self:getNode(btnName)
	if btnNode and callback then
		local callbackList = self._btnClickCallbackList[btnName] or {}
		local clickHandler = handler(self,callback)
		callbackList[callback] = clickHandler

		local function onClickHander()
			QueueEvent(EventType.ScriptEvent_Sound,{id = "GUIButtonCommon"})
			
			for CB1,CB2 in pairs(callbackList) do
				CB2()
			end
		end

		self._btnClickCallbackList[btnName] = callbackList
		btnNode:addClickEventListener(onClickHander)
	end
end

function IBaseInterface:addSceneNodeBtnClickListener(btnName,callback,sceneNode)
	assert(callback,"IBaseInterface:addBtnClickListener callback is nil")

	local btnNode = self:getSceneNode(sceneNode,btnName)
	if btnNode and callback then
		local callbackList = self._btnClickCallbackList[btnName] or {}
		local clickHandler = handler(self,callback)
		callbackList[callback] = clickHandler

		local function onClickHander()
			QueueEvent(EventType.ScriptEvent_Sound,{id = "GUIButtonCommon"})
			
			for CB1,CB2 in pairs(callbackList) do
				CB2()
			end
		end

		self._btnClickCallbackList[btnName] = callbackList
		btnNode:addClickEventListener(onClickHander)
	end
end



function IBaseInterface:removeBtnClickListener(btnName,callback)
	assert(callback,"IBaseInterface:removeBtnClickListener callback is nil")

	local callbackList = self._btnClickCallbackList[btnName] or {}
	callbackList[callback] = nil
	self._btnClickCallbackList[btnName] = callbackList
end

function IBaseInterface:addChildNode(name,childNode)
	local pNode = self:getNode(name)
	if pNode then
		pNode:addChild(childNode)
	end
end

function IBaseInterface:setButtonEnable(btnName,enable)
	local btnNode = self:getNode(btnName)
	if btnNode then
		btnNode:setEnabled(enable)
	end
end

function IBaseInterface:setButtonSelected(btnName,selected)
	local btnNode = self:getNode(btnName)
	if btnNode then
		btnNode:setSelected(enable)
	end
end

function IBaseInterface:addCheckBoxListener(checkName,callback)
	assert(callback,"IBaseInterface:addCheckBoxListener callback is nil")
	
	local checkbox = self:getNode(checkName)
	if checkbox then
		local clickHandler = handler(self,callback)
		checkbox:onEvent(clickHandler)
	end
end

function IBaseInterface:setCheckBoxSelect(checkName,sel)
	local checkbox = self:getNode(checkName)
	if checkbox then
		checkbox:setSelected(sel)
	end
end

function IBaseInterface:isCheckBoxSelected(name)
	local checkbox = self:getNode(name)
	if checkbox then
		return checkbox:isSelected()
	end

	return false
end

function IBaseInterface:addSceneCheckBoxListener(sceneName,checkName,callback)
	assert(callback,"IBaseInterface:addSceneCheckBoxListener callback is nil")

	local sceneNode = self:getNode(sceneName)
	if sceneNode then
		local checkbox = self:getSceneNode(sceneNode,checkName)
		local clickHandler = handler(self,callback)
		checkbox:onEvent(clickHandler)
	end
end

function IBaseInterface:setSpriteFrame(node,frameName)
	local sp = self:getNode(node)
	if sp then
		sp:setSpriteFrame(frameName)
	end
end

function IBaseInterface:setSpriteTexture( node,texName)
	local sp = self:getNode(node)
	if sp then
		sp:setTexture(texName)
	end
end

function IBaseInterface:setImageTexture(node,frameName,isPlist)
	isPlist = isPlist or 1
	local img = self:getNode(node)
	if img then
		img:loadTexture(frameName,isPlist)
	end
end

function IBaseInterface:setNodeContentSize(nodeName,size,sceneNode)
	local node = nil

	if sceneNode then
		node = self:getSceneNode(sceneNode,nodeName)
	else
		node = self:getNode(nodeName)
	end

	if node then
		node:setContentSize(size.width,size.height)
	end
end

function IBaseInterface:resetLocationByRatio(nodeName,sceneNode)
	local node = nil

	if sceneNode then
		node = self:getSceneNode(sceneNode,nodeName)
	else
		node = self:getNode(nodeName)
	end

	if node then
		local director = cc.Director:getInstance()
		local winSize = director:getWinSize()

		local oldX = node:getPositionX()
		local oldY = node:getPositionY()

		local ratioX = oldX/CC_DESIGN_RESOLUTION.width
		local ratioY = oldY/CC_DESIGN_RESOLUTION.height

		local newX = winSize.width  * ratioX
		local newY = winSize.height * ratioY
		node:setPosition(cc.p(newX,newY))
	end
end

function IBaseInterface:setPositionByDeltaTop(nodeName,sceneNode)
	local node = nil
	
	if sceneNode then
		node = self:getSceneNode(sceneNode,nodeName)
	else
		node = self:getNode(nodeName)
	end

	if node then
		local oldPosY = node:getPositionY()
		local deltaY = CC_DESIGN_RESOLUTION.height - oldPosY
		local newPosY = self._winSize.height - deltaY
		node:setPositionY(newPosY)
	end
end

function IBaseInterface:setPositionByDeltaRight(nodeName,sceneNode)
	local node = nil

	if sceneNode then
		node = self:getSceneNode(sceneNode,nodeName)
	else
		node = self:getNode(nodeName)
	end

	if node then
		local oldPosX = node:getPositionX()
		local deltaX = CC_DESIGN_RESOLUTION.width - oldPosX
		local newPosX = self._winSize.width - deltaX
		node:setPositionX(newPosX)
	end
end

function IBaseInterface:setPositionByDeltaRightDelta(nodeName,sceneNode)
	local node = nil

	if sceneNode then
		node = self:getSceneNode(sceneNode,nodeName)
	else
		node = self:getNode(nodeName)
	end

	if node then
		local oldPosX = node:getPositionX()
		local deltaX = CC_DESIGN_RESOLUTION.width - oldPosX
		local newPosX = self._winSize.width - deltaX - self._moveDelta
		node:setPositionX(newPosX)
	end
end

function IBaseInterface:setPositionByDeltaLeftDelta(nodeName)
	local node = nil

	if sceneNode then
		node = self:getSceneNode(sceneNode,nodeName)
	else
		node = self:getNode(nodeName)
	end

	if node then
		local oldPosX = node:getPositionX()
		local newPosX = oldPosX - self._moveDelta
		node:setPositionX(newPosX)
	end
end

function IBaseInterface:setPositionByDeltaTR(nodeName,sceneNode)
	self:setPositionByDeltaTop(nodeName,sceneNode)
	self:setPositionByDeltaRight(nodeName,sceneNode)
end

function IBaseInterface:setPositionByDeltaDown(nodeName)

end

function IBaseInterface:setPositionByDeltaLeft(nodeName)

end

function IBaseInterface:setButtonTexture(btnName,normal,select,disable,isPlist)
	local btn = self:getNode(btnName)
	if btn then
		isPlist = isPlist or 0
		disable = disable or ""
		btn:loadTextures(normal,select,disable,isPlist)
	end
end

function IBaseInterface:_ReleaseLV()
	for _,LV in pairs(self._listViews or {}) do
		LV:removeAllChildren()
	end

	self._listViews = {}
end

function IBaseInterface:relocate()	
	local director = cc.Director:getInstance()
    local winSize = director:getWinSize()
    self._moveDelta = 0

	if CC_DESIGN_RESOLUTION.autoscale == "FIXED_HEIGHT" then
		local deltaX = winSize.width - CC_DESIGN_RESOLUTION.width
		self:setPositionX(deltaX*0.5)
		self._moveDelta = deltaX*0.5
	elseif CC_DESIGN_RESOLUTION.autoscale == "FIXED_WIDTH" then
		local deltaY = winSize.height - CC_DESIGN_RESOLUTION.height
		self:setPositionY(deltaY*0.5)
		self._moveDelta = deltaY*0.5
	end

	self:resizeImgs(winSize)
end

function IBaseInterface:resizeImgs(winSize)

end

function IBaseInterface:_Release()

end

function IBaseInterface:_ReleaseBaseInterface()
	self.needUpdate = false
	self.timers = {}
	self.keyCallbackMap = {}
	self._btnClickCallbackList = {}
	self:_ReleaseLV()
end

function IBaseInterface:Release()
	self:_removeAllMsg()
	self:_ReleaseBaseInterface()
	self:_Release()
end

return IBaseInterface