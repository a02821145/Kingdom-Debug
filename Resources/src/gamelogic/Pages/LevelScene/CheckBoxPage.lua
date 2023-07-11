local CheckBoxPage = class("CheckBoxPage",_GModel.IBasePage)

function CheckBoxPage:_init(data)
	self._data = data
	self._callbackOK = data.callbackOK
	self._callbackCancel = data.callbackCancel

	self:initUI()
end


function CheckBoxPage:initUI()
	self:setNodeVisibleLang("content_text")
	self:setNodeVisibleLang("btn_text_ok")
	self:setNodeVisibleLang("btn_text_cancel")

	self:addBtnClickListener("btn_ok",self.onBtnOK)
	self:addBtnClickListener("btn_cancel",self.onBtnCancel)

	self:setLabelTextLang("content_text",_Lang(self._data.text))

	self:playTimeLine("start",false)
end

function CheckBoxPage:onBtnOK()
	if self._callbackOK then
		self._callbackOK()
	end

	self:_close()
end

function CheckBoxPage:onBtnCancel()
	if self._callbackCancel then
		self._callbackCancel()
	end

	self:_close()
end

return CheckBoxPage