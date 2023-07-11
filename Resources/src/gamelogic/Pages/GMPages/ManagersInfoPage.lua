local ManagersInfoPage = class("ManagersInfoPage",_GModel.IBasePage)

function ManagersInfoPage:_init(data)
	self:_scheduleUpdate()
	self:_initUI()
end

function ManagersInfoPage:_initUI()
	self._PanelNodeInfoCopy = self:getNode("PanelNodeInfoCopy")
	self._LVManagerInfo = self:GetListView("LVManagerInfo")

	self:_refreshInfo()
	self:setTimer(1)
end

function ManagersInfoPage:updateTimer1()
	self:_refreshInfo()
end

function ManagersInfoPage:_refreshInfo()
	local managersInfo = getManagersDebugInfo()
	self._LVManagerInfo:removeAllChildren()

	for _,managerInfo in pairs(managersInfo) do
		for key,info in pairs(managerInfo) do
			self:insertItem(key,info)
		end
	end

	self._LVManagerInfo:forceDoLayout()
end

function ManagersInfoPage:insertItem(key,value)
	local panelInfo = self._PanelNodeInfoCopy:clone()
	local title = cc.utils.findChild(panelInfo,"TextTitle")
	local content = cc.utils.findChild(panelInfo,"TextContent")
	title:setString(key)
	content:setString(tostring(value))
	self._LVManagerInfo:addChild(panelInfo)
end

return ManagersInfoPage