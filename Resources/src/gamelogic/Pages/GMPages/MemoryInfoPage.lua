local MemoryInfoPage = class("MemoryInfoPage",_GModel.IBasePage)

function MemoryInfoPage:_init(data)
	self:_scheduleUpdate()
	self:_initUI()
end

function MemoryInfoPage:_initUI()
	self:_refreshMemoryInfo()
	self:setTimer(1)
end

function MemoryInfoPage:updateTimer1()
	self:_refreshMemoryInfo()
end

function MemoryInfoPage:_refreshMemoryInfo()
	local panelItemCopy = self:getNode("panelItemCopy")
	local memoryInfo = getMemoryInfo()

	local viewList = self:getNode("ListViewMemory")
	viewList:removeAllChildren()

	for key,value in pairs(memoryInfo) do
		propertyItem = panelItemCopy:clone()
		viewList:addChild(propertyItem)

		local textPropertyName = cc.utils.findChild(propertyItem,"TextPropertyName")
		local textProperty = cc.utils.findChild(propertyItem,"TextProperty")
		textPropertyName:setString(key)
		textProperty:setString(tostring(value))
	end

	viewList:forceDoLayout()
end

return MemoryInfoPage