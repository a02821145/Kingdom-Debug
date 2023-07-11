local ShopItem = class("ShopItem", ccui.Widget,_GModel.IBaseInterface)

function ShopItem:ctor(data,cb)
	self:load("UI/Pages/ShopPage/ShopItem.csb")
	self._data = data
	self._selectCB = cb

	self:_initUI()
end

function ShopItem:_initUI()
	-- self:setLabelText("itemName",_Lang(self._data.title))
	-- self:setLabelText("des",_Lang(self._data.desc))
	self:setLabelText("gemCount",tostring(self._data.cost))
	self:setSpriteFrame("icon",self._data.icon)
	self:setNodeVisible("selectFrame",false)
	self:addBtnClickListener("btn_select",self.onBtnSelect)
end

function ShopItem:onBtnSelect()
	if self._selectCB then
		self._selectCB(self)
	end
end


function ShopItem:SetIsSelect(isSelect)
	self:setNodeVisible("selectFrame",isSelect)
end

function ShopItem:GetID()
	return self._data.id
end

function ShopItem:GetTitle()
	return _Lang(self._data.title)
end

function ShopItem:GetDes()
	return _Lang(self._data.desc)
end

return ShopItem