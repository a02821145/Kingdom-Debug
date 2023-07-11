local MsgBoxNode = class("MsgBoxNode", ccui.Widget,_GModel.IBaseInterface,_GModel.IMsgInterface)

local moveTime = 1
function MsgBoxNode:ctor(msg,possitive)
	if possitive then
		self:load("UI/Pages/LevelScene/MsgBoxNode.csb")
	else
		self:load("UI/Pages/LevelScene/MsgBoxNodeError.csb")
	end

	self:setLabelTextLang("MsgText",msg)
	self:setNodeVisibleLang("MsgText")

	local act1 = cc.MoveBy:create(moveTime,cc.p(0,150))
  	local move_ease_in = cc.EaseElasticOut:create(act1, moveTime)
  	local act2 = cc.DelayTime:create(moveTime)

  	local cb = cc.CallFunc:create(handler(self,self.Finsih))
  	local act_sq = cc.Sequence:create(move_ease_in,act2,cb)
  	self:runAction(act_sq)
end

function MsgBoxNode:Finsih()
	print("MsgBoxNode:Finsih")
	self:removeFromParent()
end

return MsgBoxNode
