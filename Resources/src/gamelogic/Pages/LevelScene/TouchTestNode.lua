local touchTestNode = class("touchTestNode",ccui.Widget,_GModel.IBaseInterface)

function touchTestNode:ctor()
	self:load("UI/Pages/UpGradePage/touchTestNode.csb")

	local panelTouch = self:getNode("panelTouch")
	panelTouch:onTouch(handler(self,self.onTouchEvents))
	self:setContentSize(170,170)
	panelTouch:setSwallowTouches(false)
end

function touchTestNode:onTouchEvents(event)
	print("touchTestNode:onTouchEvents")
end

return touchTestNode