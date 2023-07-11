local IntroducePage2 = class("IntroducePage2",_GModel.IBasePage)

function IntroducePage2:_init(data)
	self._id = data.id
	self:setNodeVisibleLang("tips_title_text")
	self:setNodeVisibleLang("content_text")
	self:setNodeVisibleLang("btn_text_ok")

	self:playTimeLine("start",true)

	self:addBtnClickListener("btnOK",self.onBtnClose)
end

function IntroducePage2:onBtnClose()
	self:_close()
	cc.UserDefault:getInstance():setBoolForKey("Tips"..self._id,true)
end

return IntroducePage2