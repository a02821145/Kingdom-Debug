local DisplayAniNode = class("DisplayAniNode",ccui.Widget,_GModel.IBaseInterface)

function DisplayAniNode:ctor(strCSB,isBuilding)
	self:load(strCSB)

	if self.timeLine and self.timeLine:IsAnimationInfoExists("idle") then
		self:playTimeLine("idle",true)
	end

	if isBuilding then
		self:setNodeVisible("buidingDamage",false)
	end
end

function DisplayAniNode:ResetPos()
	local sizeNode = self:getNode("BuildingSize")
	local size = sizeNode:getContentSize()
	self:setPosition(-size.width*0.5,-size.height*0.5)
end

return DisplayAniNode