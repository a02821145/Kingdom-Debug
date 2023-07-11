local BackPackItem = class("BackPackItem", ccui.Widget,_GModel.IBaseInterface)

function BackPackItem:ctor(data,count)
	self:load("UI/Pages/BackPack/PackItem.csb")

	self:setSpriteFrame("icon",data.icon)
	self:setLabelText("num",count)
end

return BackPackItem