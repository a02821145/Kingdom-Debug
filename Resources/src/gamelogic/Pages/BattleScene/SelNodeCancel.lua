local SelNodeCancel = class("SelNodeCancel", ccui.Widget,_GModel.IBaseInterface,_GModel.IMsgInterface)

function SelNodeCancel:ctor()
	self:load("UI/Pages/BattlePage/SelNodeCancel.csb")

	self._panelBG = self:getNode("panelBG")
	self._panelBG:setSwallowTouches(false)
	--panelBG:onTouch(handler(self,self.onCancelSelect))
end

function SelNodeCancel:Show(isShow)
	self._panelBG:onTouch(isShow and handler(self,self.onCancelSelect) or nil)
	self:setNodeVisible("icon",isShow)
end

function SelNodeCancel:onCancelSelect()
	
end

return SelNodeCancel
