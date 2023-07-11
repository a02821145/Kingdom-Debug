local RootManager = class("RootManager",_GModel.IMsgInterface);
local Stack = TWRequire("Stack") 

function RootManager:ctor()
	self._TimerList = {}
	self._TimerId = 1
	self.rootNode = nil
	self.uiNode = nil
	self.popUpNode = nil
	self.msgBoxNode = nil
	self.curSceneName = ""
	self.popupPageMap = {}
	self.pageStack = Stack:new()
	self.curScene = nil
	self:_initMsg()
end

function RootManager:_initMsg()
	TWRequire("messageDefine")
	initMessageId()
	
	self:addListener(MessageDef_RootManager.MSG_OpenPage,self._OpenPage)
	self:addListener(MessageDef_RootManager.MSG_ChangeScene,self._ChangeScene)
	self:addListener(MessageDef_RootManager.MSG_ClosePage,self._ClosePage)
	self:addListener(MessageDef_RootManager.MSG_CloseCurPage,self._CloseCurPage)
end


function RootManager:Instance()
	if self.instance == nil then
		self.instance = self:new()
	end

	return self.instance
end

function RootManager:OpenPage(pageName,pageArg,needNoTouchLayer,isBlankClose,instant)
	local message = {}
	message.pageName = pageName
	message.arg = pageArg
    message.isBlankClose = isBlankClose == nil and false or isBlankClose
    message.needNoTouchLayer = needNoTouchLayer == nil and true or needNoTouchLayer

    if instant then
    	gMessageManager:sendMessageInstant(MessageDef_RootManager.MSG_OpenPage,message)
    else
    	gMessageManager:sendMessage(MessageDef_RootManager.MSG_OpenPage,message)
    end
end

function RootManager:ClosePage(pageName,pageArg,instant)
	local message = {}
	message.pageName = pageName
	message.arg = pageArg

	if instant then
		gMessageManager:sendMessageInstant(MessageDef_RootManager.MSG_ClosePage,message)
	else
    	gMessageManager:sendMessage(MessageDef_RootManager.MSG_ClosePage,message)
    end
end

function RootManager:CloseAllPages()
	for _,page in pairs(self.popupPageMap) do
		self:ClosePage(page:GetPageName(),nil,true)
	end
end

function RootManager:_ClosePage(message)
	local pageName = message.pageName
	local arg = message.arg

	if pageName == nil then
		self:_CloseCurPage()
		return
	end

	local isLoaded,pageHandler = self:_CheckPageLoaded(pageName)
	if isLoaded then
		pageHandler:Exit()
		self.popupPageMap[pageName] = nil
		self.pageStack:Remove(pageName)

		gMessageManager:sendMessage(MessageDef_RootManager.MSG_PageClosed,{pageCount = self.pageStack:GetSize()})
	end
end

function RootManager:_CloseCurPage()
	if self.pageStack:GetSize() <=0 then
		return
	end

	local topPageName = self.pageStack:Top()
	local message = {}
	message.pageName = topPageName
    gMessageManager:sendMessage(MessageDef_RootManager.MSG_ClosePage,message)
end

function RootManager:_OpenPage(message)
	local pageName 		= message.pageName
	local pageArg  		= message.arg
	local isBlankClose	= message.isBlankClose
	local needNoTouchLayer = message.needNoTouchLayer

	if self:_CheckPageLoaded(pageName) then
		LogWarn("page %s has loaded",pageName)
		self:ClosePage(pageName,nil,true)
	end

	local pageInfo = _GModel.page_cfg[pageName]
	if not pageInfo then
		LogWarn("page info %s not define in page_cfg",pageName)
		return
	end

	local pageHandler = self:GetPageHandler(pageName,pageArg,pageInfo)
	if pageHandler then
		self:_AddPageToNode(pageHandler,self.popUpNode)

		self.popupPageMap[pageName] = pageHandler
		self.pageStack:Push(pageName)

		if needNoTouchLayer then
			pageHandler:addNoTouchLayer(isBlankClose)
		end
	end
end

function RootManager:GetPageHandler(pageName,arg,pageInfo)
	local page = TWRequire(pageName):create()
	if page then
		if pageInfo and pageInfo.csb then
			page:load(pageInfo.csb)
		end

		page:Enter(arg,pageName)
	else
		LogError("failed to get page %",pageName)
	end

	return page
end

function RootManager:_AddPageToNode(handlr,node)
	if node == nil then
		LogError("RootManager:_AddPageToNode node is nil")
		return
	end

	node:addChild(handlr)
end

function RootManager:_CheckPageLoaded(pageName)
	local page = self.popupPageMap[pageName]
	return page~=nil,page
end

function RootManager:CheckHasPage()
	return next(self.popupPageMap) ~= nil
end

function RootManager:update(dt)
	for _,page in pairs(self.popupPageMap or {}) do
		page:update(dt)
	end

	if self.curScene then
		self.curScene:update(dt)
	end

	self:_UpdateTimer(dt)
end

function RootManager:ShowMsgBox(text,possitive)
	if not self.msgBoxNode then
		return
	end

	local MsgBoxNode = TWRequire("MsgBoxNode")
	local newMsgNode = MsgBoxNode.new(text,possitive == nil and true or possitive)
	self.msgBoxNode:addChild(newMsgNode)
end

function RootManager:setNodesWithScene(scene)
	self.rootNode = scene.sceneNode
	self.curScene = scene
	assert(self.rootNode,"scene no have scene node")

	self.uiNode = cc.utils.findChild(scene,"GUINode")
	assert(self.uiNode, "RootManager:setNodesWithScene not have GUINode")

	self.popUpNode = cc.utils.findChild(scene,"PopUpNode")
	assert(self.popUpNode,"RootManager:setNodesWithScene not have PopUpNode")

	self.msgBoxNode = cc.utils.findChild(scene,"MsgBoxNode")
end

function RootManager:GetNode(name)
	assert(self.rootNode,"scene no have scene node")
	local sceneNode = cc.utils.findChild(self.rootNode,name)
	return sceneNode
end

function RootManager:ChangeScene(sceneName,data)
	if self.curSceneName == sceneName then
		LogError("Scene %s open already",sceneName)
		return
	end

	local message = {}
	message.sceneName = sceneName
	message.params = data
	gMessageManager:sendMessage(MessageDef_RootManager.MSG_ChangeScene, message)
end

function RootManager:AddLoadingNode(scene)
	local node = scene:getNode("LoadingNode")

	if node then
		local loadingNode = TWRequire("LoadingNode").new()
		node:addChild(loadingNode)
	end
end

function RootManager:_ChangeScene(data)
	print("RootManager:_ChangeScene")
	dump(data)

	local sceneName = data.sceneName

	local curScene = require("app.MyApp"):create():run(sceneName)

	self.curSceneName = sceneName
	self:CloseAllPages()
	self:setNodesWithScene(curScene)

	if curScene._init then
		curScene:_init(data.params)
	end	

	gMessageManager:sendMessageInstant(MessageDef_RootManager.MSG_AfterChangeScene)
end

function RootManager:AddTimer(timeDelay,isLoop,callback,params)
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

function RootManager:_UpdateTimer(dt)
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

function RootManager:Exit()
	self:_removeAllMsg()
	self.pageStack:Clear()

	for _,page in pairs(self.popupPageMap) do
		page:Exit()
	end
end

gRootManager = RootManager:Instance()