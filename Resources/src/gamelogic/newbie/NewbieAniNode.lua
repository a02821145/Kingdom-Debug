local NewbieAniNode = class("NewbieAniNode", ccui.Widget,_GModel.IBaseInterface)

function NewbieAniNode:ctor(data,clickCB)
	self:load(data.newbieCSB)
	self:playTimeLine("start",true)
	self:addBtnClickListener("btnNext",self.onBtnClick)
	self._clickCB = clickCB
	self._data = data

	self:setNodeVisibleLang("content_text")
	self:setNodeVisibleLang("btn_text_ok")
end

function NewbieAniNode:onBtnClick()
	if self._clickCB then
		self._clickCB(self._data.nextId)
	end
end

return NewbieAniNode