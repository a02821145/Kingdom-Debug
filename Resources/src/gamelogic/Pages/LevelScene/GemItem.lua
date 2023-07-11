local GemItem = class("GemItem", ccui.Widget,_GModel.IBaseInterface,_GModel.IMsgInterface)

function GemItem:ctor(data,callback)
	self:load("UI/Pages/ShopPage/GemItem.csb")
	self._data = data
	self._callback= callback
	self:refreshUI()

	self:setContentSize(250,400)
	self:playTimeLine("seleted",true)
	self:setNodeVisible("selected",false)

end

function GemItem:refreshUI()
	self:setSpriteFrame("icon",self._data.icon)
	self:setLabelText("gemCount",self._data.gemCount)
	self:setLabelText("money",self._data.money)

	local panelBG = self:getNode("PanelSelect")
	panelBG:setSwallowTouches(false)
	panelBG:onTouch(handler(self,self.onSelect))
end

function GemItem:onSelect(event)
	if event.name == "ended" and self._callback then
		self._callback(self)
	end
end

function GemItem:ShowSelected(show)
	self:setNodeVisible("selected",show)
end

function GemItem:GetID()
	return self._data.id
end

return GemItem