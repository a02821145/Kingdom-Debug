local IntroducePage5 = class("IntroducePage5",_GModel.IBasePage)

function IntroducePage5:_init(data)
	self._id = data.id
	self:setNodeVisibleLang("tips_title_text")
	self:setNodeVisibleLang("content_text")
	self:setNodeVisibleLang("btn_text_ok")

	self:playTimeLine("start",true)

	self:addBtnClickListener("btnOK",self.onBtnClose)
end

function IntroducePage5:onBtnClose()
	self:_close()
	cc.UserDefault:getInstance():setBoolForKey("Tips"..self._id,true)
end

return IntroducePage5