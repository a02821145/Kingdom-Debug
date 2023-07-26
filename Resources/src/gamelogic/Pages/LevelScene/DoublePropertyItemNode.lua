local DoublePropertyItemNode = class("DoublePropertyItemNode",ccui.Widget,_GModel.IBaseInterface)
local PropertyItemNode = TWRequire("PropertyItemNode")

function DoublePropertyItemNode:ctor(data,upInfo)
	self:load("UI/Pages/UpGradePage/doublePropertyItem.csb")
	self._data = data
	self._upInfo = upInfo
	self:setContentSize(570,50)
end

function DoublePropertyItemNode:addLeft(cfg)
	local leftNode = self:getNode("pLeft")
	self:addProperty(leftNode,cfg)
end

function DoublePropertyItemNode:addRight(cfg)
	local rightNode = self:getNode("pRight")
	self:addProperty(rightNode,cfg)
end

function DoublePropertyItemNode:addProperty(pNode,cfg)
	local item = PropertyItemNode.new(self._data,cfg,self._upInfo)
	pNode:addChild(item)
	item:setPosition(cc.p(0,0))
end

return DoublePropertyItemNode