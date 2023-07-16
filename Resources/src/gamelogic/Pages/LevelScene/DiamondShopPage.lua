local DiamondShopPage = class("DiamondShopPage",_GModel.IBasePage)
local DiamondItem = TWRequire("DiamondItem")

function DiamondShopPage:_init()
	self:_initUI()
	self:refreshGemsLV()
end

function DiamondShopPage:_initUI()
	self:playTimeLine("start",false)
	local panelBG = self:getNode("PanelBG")
    panelBG:onTouch(handler(self,self._close))

    self._LVGems = self:GetListView("LVList")

    self:addBtnClickListener("btnBuy",self.onBtnBuy)

    self:setNodeVisibleLang("TextPanelClose")
    self:setNodeVisibleLang("Title_text")
    self:setNodeVisibleLang("TextBuy")
end

function DiamondShopPage:onBtnBuy()
	if self._CurSelectItem then
		local id = self._CurSelectItem:getId()
		
		_GModel.PlayerManager:ExchangeDiamond(id)
	end
end

function DiamondShopPage:refreshGemsLV()
	local gemsList = {}
	self._CurSelectItem = nil

	for _,gemCfg in pairs(_GModel.DiamonsCfg) do
		table.insert(gemsList,gemCfg)
	end

	table.sort( gemsList,function ( a,b )
		return a.level < b.level
	end )

	self._LVGems:removeAllChildren()
	local clickCB = handler(self,self.onSelectCallback)
	for i,gemCfg in ipairs(gemsList) do
		local itemNode = DiamondItem.new(gemCfg,clickCB)
		self._LVGems:addChild(itemNode)

		if i == 1 then
			self._CurSelectItem = itemNode
			self._CurSelectItem:ShowSelected(true)
		end
	end

	self._LVGems:forceDoLayout()
end

function DiamondShopPage:onSelectCallback(item)
	if self._CurSelectItem then
		self._CurSelectItem:ShowSelected(false)
	end

	self._CurSelectItem = item
	self._CurSelectItem:ShowSelected(true)
end

function DiamondShopPage:_Release()
	self._LVGems:removeAllChildren()
end

return DiamondShopPage