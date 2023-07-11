local EditorActorPage = class("EditorActorPage",_GModel.IBasePage)
local common = TWRequire("common")

local ValueType = 
{
	type_string = 1,
	type_number = 2
}

function EditorActorPage:_init(data)
	self:_initUI()
	self:_initBtns()
end

function EditorActorPage:_initBtns( )
	-- body
	self:addBtnClickListener("BtnSave",self.onSave)
	self:addBtnClickListener("BtnApply",self.onApply)
	self:addBtnClickListener("BtnRevert",self.onRevert)
end

function EditorActorPage:_initUI()
	local configManager = TWRequire("ConfigDataManager")
	local characters = configManager:getMod("Characters")
	local weapons = configManager:getMod("Weapons")
	local projectiles = configManager:getMod("Projectiles")

	self._LVProperty = self:GetListView("LVProperty")
	self._TextSpace = self:getNode("TextSpace")
	self._SpaceSize = self._TextSpace:getContentSize();

	self:_initActors("Characters",characters)
	self:_initActors("Weapons",weapons)
	self:_initActors("Projectiles",projectiles)
end

function EditorActorPage:_initActors(name,datas)
	local BtnActorCopy = self:getNode("BtnActorCopy")
	local TextTypeCopy = self:getNode("TextTypeCopy")
	local LVActor = self:GetListView("LVActor")

	local NewTextTitle = TextTypeCopy:clone()
	NewTextTitle:setString(name)
	LVActor:addChild(NewTextTitle)

	local actorSelHandler = handler(self,self._onSelectActor)
	for _,data in ipairs(datas) do
		local newBtn = BtnActorCopy:clone()
		newBtn:addClickEventListener(actorSelHandler)
		newBtn:setTitleText(data.name)
		newBtn.data = data
		LVActor:addChild(newBtn)
	end

	LVActor:forceDoLayout()
end

function EditorActorPage:_onSelectActor(sender)
	self._LVProperty:removeAllChildren()

	self.curData = common:table_simple_copy(sender.data)
	self.curDataOrig = common:table_simple_copy(sender.data)

	self:refershProperty(sender.data)

	self._LVProperty:forceDoLayout()
end

function EditorActorPage:refershProperty(data,keyTable,level)
	local TitleTextCopy = self:getNode("TitleTextCopy")
	keyTable = keyTable or {}
	level = level or 0

	for key,value in pairs(data) do
		local newKeyTable = common:table_simple_copy(keyTable)
		table.insert(newKeyTable,key)

		local vType = type(value)
		if vType == "table" then
			local title = TitleTextCopy:clone()
			title:setString(key)
			self._LVProperty:addChild(title)
			self:refershProperty(value,newKeyTable,level+1)
		elseif vType == "string" then
			self:addPanelString(key,value,ValueType.type_string,newKeyTable,level)
		elseif vType == "number" then
			self:addPanelString(key,value,ValueType.type_number,newKeyTable,level)
		end
	end
end

function EditorActorPage:onPropertyChange(sender,eventType)
	local keyTable = sender.keyTable
	local valueType = sender.valueType

	local str = sender:getString()
	local value = nil

	if valueType == ValueType.type_number then
		value = tonumber(str)
	else
		value = str
	end

	local t = self.curData
	local len = #keyTable

	for i,key in ipairs(keyTable) do
		if i == len then
			if type(t[key]) == type(value) then
				t[key] = value
			end
		else
			t = t[key]
		end
	end
end

function EditorActorPage:addPanelString(key,value,valueType,keyTable,level)
	local PanelStringCopy = self:getNode("PanelStringCopy"..level)

	local PanelString = PanelStringCopy:clone()
	local PanelSize = PanelString:getContentSize()

	local SpaceWidth = self._SpaceSize.width * level
	PanelString:setContentSize(SpaceWidth+PanelSize.width,PanelSize.height)

	for i=1,level do
		local textSpace = self._TextSpace:clone()
		PanelString:addChild(textSpace)
		textSpace:setPosition(cc.p(SpaceWidth*(i-1),0))
	end

	local TitleBG = cc.utils.findChild(PanelString,"TitleBG")
	local InputText = cc.utils.findChild(PanelString,"InputNum")

	local TextTitle = cc.utils.findChild(PanelString,"Title")
	local InputText = cc.utils.findChild(PanelString,"InputNum")

	local titleSize = TextTitle:getContentSize()

	TextTitle:setString(key)
	InputText:setString(value)
	InputText.valueType = valueType
	InputText.keyTable = common:table_simple_copy(keyTable)
	
	InputText:addEventListener(handler(self,self.onPropertyChange))

	self._LVProperty:addChild(PanelString)
end


function EditorActorPage:onSave() --save 还有问题
	-- if self.curData then
	-- 	local configManager = TWRequire("ConfigDataManager")
	-- 	configManager:saveConfig(self.curData)
	-- end
end

function EditorActorPage:onRevert()
	self.curData = common:table_simple_copy(self.curDataOrig)
	
	self._LVProperty:removeAllChildren()

	self:refershProperty(self.curData)

	self._LVProperty:forceDoLayout()

end

function EditorActorPage:onApply()
	if self.curData then
		QueueEvent(EventType.ScriptEvent_ChangeProperty,{data = self.curData})
	end
end

return EditorActorPage