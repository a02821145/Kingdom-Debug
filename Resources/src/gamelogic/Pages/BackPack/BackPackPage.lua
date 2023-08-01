local BackPackPage = class("BackPackPage",_GModel.IBasePage)
local BackPackItem = TWRequire("BackPackItem")

function BackPackPage:_init()
	self:_initUI()
end

function BackPackPage:_initUI()
	self:addBtnClickListener("btn_close",self._close)
	self:setNodeVisibleLang("Title_Text")
	
	local panelBG = self:getNode("PanelBG")
    panelBG:onTouch(handler(self,self._close))

    self:setNodeVisibleLang("TextPanelClose")
    
	local nodeIndex =  1
	for id,cfg in pairs(_GModel.items) do
		local Key = "BackpackItem_"..tostring(id)
		local packageItemCount = getPlayerSetting(Key,SettingType.TYPE_INT,0)

		if packageItemCount.Value > 0 then
			local item = BackPackItem.new(cfg,packageItemCount.Value)
			local pNode = self:getNode("itemNode"..nodeIndex)
			pNode:addChild(item)
			item:setPosition(cc.p(0,0))
			nodeIndex = nodeIndex +  1
		end
	end
end

return BackPackPage