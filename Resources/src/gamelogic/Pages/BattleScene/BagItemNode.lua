local SimpleAniNode = TWRequire("SimpleAniNode")

local BagItemNode = class("BagItemNode", ccui.Widget,_GModel.IBaseInterface)

function BagItemNode:ctor(data,num,selectCB)
	self:load("UI/Pages/BattlePage/BagItemNode.csb")
	self._data = data
	self._num = num
	self._selectCB = selectCB
	self._prepareState = data.prepareState

	self._selectedAni = SimpleAniNode.new("UI/InGame/selectAni2.csb")
	self:addChildNode("Panel",self._selectedAni)
	self._selectedAni:setPosition(cc.p(64,64))
	self._selectedAni:setVisible(false)

	self._panel = self:getNode("Panel")
	self._panel:onTouch(handler(self,self.onTouch))
	self._panel:setSwallowTouches(false)

	self._panelMask = self:getNode("PanelMask")
	self._panelMask:setSwallowTouches(false)

	local size = self._panel:getContentSize()
	self:setLabelText("num",num)
	self:setContentSize(size.width,size.height)

	self:setSpriteFrame("icon",data.icon)

	if self._prepareState then
		self:setNodeVisible("PanelMask",false)
	else
		self._panel:onTouch(nil)
	end
end

function BagItemNode:onTouch(event)
	if event.name ~= "ended" then return end

	if self._selectCB then
		self._selectCB(self,self._data)
	end
end

function BagItemNode:setSelect(isSelect)
	self._selectedAni:setVisible(isSelect)

	gMessageManager:sendMessage(MessageDef_GameLogic.Msg_OnItem_Event,{id = self._data.name,select = isSelect,selectCB = self._selectCB})
end

function BagItemNode:SetShowMask(showMask)
	if self._prepareState then return end

	self:setNodeVisible("PanelMask",showMask)
	if showMask then
		self._panel:onTouch(nil)
	else
		self._panel:onTouch(handler(self,self.onTouch))
	end
end

return BagItemNode