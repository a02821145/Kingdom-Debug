local SimpleAniNode = class("SimpleAniNode",ccui.Widget,_GModel.IBaseInterface)

function SimpleAniNode:ctor(str,isLoop)
	self:load(str)

	isLoop = isLoop == nil and true or isLoop

	if isLoop then
		self:playTimeLine("start",true)
	end
end

function SimpleAniNode:play()
	self:setVisible(true)
	self:playTimeLine("start",false)
end

function SimpleAniNode:stop()
	self:setVisible(false)
end

return SimpleAniNode