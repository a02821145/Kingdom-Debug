local GemShopPage = class("GemShopPage",_GModel.IBasePage)
local GemItem = TWRequire("GemItem")

function GemShopPage:_init()
	self:_initUI()
	self:refreshGemsLV()
end

function GemShopPage:_initUI()
	self._LVGems = self:GetListView("LVGems")
	self:addBtnClickListener("btn_close",self._close)
	self:addBtnClickListener("btnBuy",self.onBuy)

	self:setNodeVisibleLang("Title_text")
	self:setNodeVisibleLang("btn_text_buy")
end


function GemShopPage:refreshGemsLV()
	self._CurSelectItem = nil

	local gemsList = {}

	for _,gemCfg in pairs(_GModel.GemsCfg) do
		table.insert(gemsList,gemCfg)
	end

	table.sort( gemsList,function ( a,b )
		return a.level < b.level
	end )

	self._LVGems:removeAllChildren()
	local clickCB = handler(self,self.onSelectCallback)
	for i,gemCfg in ipairs(gemsList) do
		local itemNode = GemItem.new(gemCfg,clickCB)
		self._LVGems:addChild(itemNode)

		if i == 1 then
			self._CurSelectItem = itemNode
			self._CurSelectItem:ShowSelected(true)
		end
	end

	self._LVGems:forceDoLayout()
end

function GemShopPage:onSelectCallback(item)

	if self._CurSelectItem then
		self._CurSelectItem:ShowSelected(false)
	end

	self._CurSelectItem = item
	self._CurSelectItem:ShowSelected(true)
end

function GemShopPage:onBuy()
	
	if not self._CurSelectItem then
		return
	end

	_GModel.PlayerManager:BuyGems(self._CurSelectItem:GetID())
end

function GemShopPage:_Release()
	self._LVGems:removeAllChildren()
end

return GemShopPage