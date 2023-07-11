local TestPage1 = class("TestPage1",_GModel.IBasePage)

function TestPage1:_init(data)
	print("TestPage1:_init")
	self:_initBtns()
end

function TestPage1:_initBtns()
	self:addBtnClickListener("BtnOpen1",self._onOpen1)
	self:addBtnClickListener("BtnOpen2",self._onOpen2)
	self:addBtnClickListener("BtnClose",self._onBtnClose)
end

function TestPage1:_onOpen1()
	gRootManager:OpenPage("TestPage1")
end

function TestPage1:_onOpen2()
	-- body
	gRootManager:OpenPage("TestPage2")
end

function TestPage1:_onBtnClose()
	gRootManager:ClosePage(self:GetPageName())
end

function TestPage1:onEnter()
	print("TestPage1:onEnter")
end

function TestPage1:onExit()
	print("TestPage1:onExit")
end

function TestPage1:onEnterTransitionFinish()
	print("TestPage1:onEnterTransitionFinish")
end

function TestPage1:onExitTransitionStart()
	print("TestPage1:onExitTransitionStart")
end

function TestPage1:onCleanup()
	print("TestPage1:onCleanup")
end

return TestPage1