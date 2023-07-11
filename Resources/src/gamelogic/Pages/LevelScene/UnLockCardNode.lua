local UnLockCardNode = class("UnLockCardNode",ccui.Widget,_GModel.IBaseInterface)
local configManager = TWRequire("ConfigDataManager")
local DisplayAniNode = TWRequire("DisplayAniNode")

function UnLockCardNode:ctor(data)
	self:load("UI/Pages/LevelScene/UnlcokCardEffect.csb")

	self._id = data.id
	self._isBuilding = data.isBuilding

	self:InitUI()
end

function UnLockCardNode:InitUI()
	local info = configManager:getConfigById(self._id)
	self:setNodeVisibleLang("name")
	
	if info then
		local pNode = self:getNode("SpineNode")
		self:setLabelTextLang("name",_Lang(info.name))

		local displayNode = DisplayAniNode.new(info.displayCSB,self._isBuilding)
		pNode:addChild(displayNode)

		if self._isBuilding then
			displayNode:ResetPos()
		else
			displayNode:setPosition(cc.p(0,0))
		end
	end
end

return UnLockCardNode