local DiamondItem = class("DiamondItem", ccui.Widget,_GModel.IBaseInterface,_GModel.IMsgInterface)

function DiamondItem:ctor(data,callback)
	self:load("UI/Pages/ShopPage/DiamondItem.csb")
	self._data = data
	self._callback= callback

	self:setContentSize(250,380)
	self:playTimeLine("seleted",true)
	self:setNodeVisible("selected",false)

	self:refreshUI()
end

function DiamondItem:refreshUI()
	self:setSpriteFrame("icon",self._data.icon)
	self:setLabelText("gemCount",self._data.gemCount)
	self:setLabelText("money",self._data.gems)

	local panelBG = self:getNode("PanelSelect")
	panelBG:setSwallowTouches(false)
	panelBG:onTouch(handler(self,self.onSelect))
end

function DiamondItem:onSelect(event)
	if event.name == "ended" and self._callback then
		self._callback(self)
	end
end

function DiamondItem:getId()
	return self._data.id
end

function DiamondItem:ShowSelected(show)
	self:setNodeVisible("selected",show)
end

return DiamondItem