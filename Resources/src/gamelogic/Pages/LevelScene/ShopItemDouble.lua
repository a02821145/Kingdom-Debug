local ShopItemDouble = class("ShopItemDouble", ccui.Widget,_GModel.IBaseInterface)
local ShopItem = TWRequire("ShopItem")

function ShopItemDouble:ctor(data)
	self:load("UI/Pages/ShopPage/ShopItemDouble.csb")
	self._data = data

	self:_initUI()
	self:setContentSize(420,256)
end

function ShopItemDouble:_initUI()

	for i,data in ipairs(self._data) do
		local parentNode = self:getNode("item"..i)
		local item = ShopItem.new(data)
		parentNode:addChild(item)
	end
end

return ShopItemDouble