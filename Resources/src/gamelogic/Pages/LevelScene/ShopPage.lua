local ShopPage = class("ShopPage",_GModel.IBasePage)
local ShopItem = TWRequire("ShopItem")

function ShopPage:_init()
	self:_initUI()
	self:_refreshItems()
end

function ShopPage:_initUI()
	local panelBG = self:getNode("PanelBG")
    panelBG:onTouch(handler(self,self._close))

	self:addBtnClickListener("btn_close",self._close)
	self:addBtnClickListener("btn_buy",self._onBuy)

	self:setNodeVisibleLang("Title_Text")
	self:setNodeVisibleLang("btn_text_buy")
	self:setNodeVisibleLang("infoTitle")
	self:setNodeVisibleLang("infoContent")
	self:resetLocationByRatio("background")

	self:setNodeVisibleLang("TextPanelClose")
end

function ShopPage:_refreshItems()
	self._CurSelectItem = nil
	
	local itemsList = {}

	for _,itemCfg in pairs(_GModel.items) do
		table.insert(itemsList,itemCfg)
	end

	table.sort( itemsList,function(a,b)
		return a.id < b.id
	end)

	local doubleDataList = {}
	local selectHandler = handler(self,self.onSelectItem)

	for i,itemCfg in ipairs(itemsList) do
		local str = "itemNode"..i
		local pNode = self:getNode(str)

		if not pNode then return end
		
		local item = ShopItem.new(itemCfg,selectHandler)
		item:setPosition(cc.p(0,0))

		if i == 1 then
			self._CurSelectItem = item
			self._CurSelectItem:SetIsSelect(true)
			self:setItemInfo(item)
		end

		pNode:addChild(item)
	end

end

function ShopPage:setItemInfo(item)
	self:setLabelTextLang("infoTitle",item:GetTitle())
	self:setLabelTextLang("infoContent",item:GetDes())
end

function ShopPage:onSelectItem(item)
	if self._CurSelectItem then
		self._CurSelectItem:SetIsSelect(false)
	end

	self._CurSelectItem = item
	self._CurSelectItem:SetIsSelect(true)
	self:setItemInfo(item)
end

function ShopPage:_onBuy()
	if not self._CurSelectItem then return end

	local itemID = self._CurSelectItem:GetID()

	_GModel.PlayerManager:BuyItems(itemID)
end

return ShopPage