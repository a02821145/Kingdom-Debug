local ActorDebugRenderPage = class("ActorDebugRenderPage",_GModel.IBasePage)
local configManager = TWRequire("ConfigDataManager")

function ActorDebugRenderPage:_init(data)
	self:_initUI()
	self:_initMsg()
	self:_refreshList()
end

function ActorDebugRenderPage:_initUI()
	self._LVCBRender = self:GetListView("LVCBRender")
	self._PanelCopy  = self:getNode("PanelCopy")
	self._DebugList = configManager:getMod("DebugRenderList")
end

function ActorDebugRenderPage:_initMsg()
	self:addListener(MessageDef_GM.MSG_Refresh_DebugRender,self._refreshList)
end

function ActorDebugRenderPage:_refreshList()
	self._LVCBRender:removeAllChildren()
	self._CheckEvents = {}
	self._CBList = {}

	for _,info in ipairs(self._DebugList) do
		local panelCB = self._PanelCopy:clone()
		self._LVCBRender:addChild(panelCB)

		local TextTitle = cc.utils.findChild(panelCB,"TextTitle")
		local CBShowCheck = cc.utils.findChild(panelCB,"CBShowCheck")
		TextTitle:setString(info)

		local clickHandler = nil
		if info == "SelectAll" then
			clickHandler = handler(self,self.onSelectAll)
		else
			clickHandler = handler(self,self.onCBSelectDebug)
		end

		CBShowCheck:addEventListener(clickHandler)
		CBShowCheck.value = info
		table.insert(self._CBList,CBShowCheck)
		self._CheckEvents[info] = false
	end

	self._LVCBRender:forceDoLayout()
end

function ActorDebugRenderPage:onSelectAll(sender,eventType)
	-- body
	local isSelected = sender:isSelected()
	for _,checkBox in ipairs(self._CBList) do
		if checkBox ~= sender then
			checkBox:setSelected(isSelected)
			local key = checkBox.value
			self._CheckEvents[key] = isSelected
		end
	end
	QueueEvent(EventType.ScriptEvent_DebugRender,self._CheckEvents)
end

function ActorDebugRenderPage:onCBSelectDebug(sender,eventType)
	local isSelected = sender:isSelected()
	local info = sender.value

	self._CheckEvents[info] = isSelected
	QueueEvent(EventType.ScriptEvent_DebugRender,self._CheckEvents)
end

return ActorDebugRenderPage