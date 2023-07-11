local IBasePage = class("IBasePage",cc.Node,_GModel.IMsgInterface,_GModel.IBaseInterface)

function IBasePage:ctor()
	
end

function IBasePage:Enter(data,pageName)
	if self._init then
		self:_init(data)
	end

	self:enableNodeEvents()
	self:setName(pageName)

	self._isBlankClose = false

	self._pageName = pageName

	local director = cc.Director:getInstance()
	local winSize = director:getWinSize()
	local panelBG = self:getNode("PanelBG")
	if panelBG then
		panelBG:setContentSize(winSize.width,winSize.height)
		panelBG:setPosition(winSize.width*0.5,winSize.height*0.5)
	end

	self:resetLocationByRatio("PosNode")
	self:setPosition(cc.p(0,0))
end

function IBasePage:GetPageName()
	return self._pageName or ""
end

function IBasePage:_close()
	gRootManager:ClosePage(self._pageName)
end

function IBasePage:onCleanup()
	self:_removeAllMsg()
	self:_ReleaseBaseInterface()
	self:_Release()
end

function IBasePage:addNoTouchLayer(isBlankClose)
	local director = cc.Director:getInstance()
	local winSize = director:getWinSize()

	self._isBlankClose = isBlankClose
	local noTouchLayer = display.newLayer(cc.c4b(0,0,0,128),winSize)
	noTouchLayer:setName("noTouchLayer")
	noTouchLayer:setAnchorPoint(cc.p(0,0))
	noTouchLayer:setPosition(cc.p( 0,0))
	self:addChild(noTouchLayer)
	noTouchLayer:setLocalZOrder(-10000)
	noTouchLayer:setTouchEnabled(false)
	noTouchLayer:onTouch(handler(self,self._onNoTouchLayerCB),false,true)
end

function IBasePage:_onNoTouchLayerCB(event)
	if self._isBlankClose then
		self:_close()
	end
end

function IBasePage:_Release()

end

function IBasePage:Exit()
	self:removeSelf()
end

return IBasePage