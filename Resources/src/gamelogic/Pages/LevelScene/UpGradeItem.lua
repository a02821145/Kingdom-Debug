local UpGradeItem = class("UpGradeItem", ccui.Widget,_GModel.IBaseInterface,_GModel.IMsgInterface)

function UpGradeItem:ctor(data,callback,isbuilding,isUnlock)
	self._data = data
	self._callback = callback
	self._isUnLock = isUnlock

	if isbuilding then
		self:load("UI/Pages/UpGradePage/buildingIcon.csb")
	else
		self:load("UI/Pages/UpGradePage/headIcon.csb")
	end

	self:initUI()
end

function UpGradeItem:GetID()
	return self._data.id
end

function UpGradeItem:GetSkillId()
	return self._data.spId
end

function UpGradeItem:initUI()
	self:setContentSize(170,170)
	self:setNodeVisible("select",false)
	self:setNodeVisible("PanelUnLock",not self._isUnLock)
	self:setSpriteFrame("icon",self._data.icon)
	self:setNodeVisible("GuardNode",self._data.isGuard)
	local touchPanel = self:getNode("PanelBack")
	touchPanel:setSwallowTouches(false)

	if self._isUnLock then
		touchPanel:onTouch(handler(self,self.onClick))
	else
		touchPanel:onTouch(nil)
	end
	local key = "UnitLV_"..tostring(self._data.id)
	local temp = getPlayerSetting(key,SettingType.TYPE_INT,1)
	
	self:setLabelText("TextLV","Lv"..temp.Value)
end

function UpGradeItem:refreshLevel()
	local key = "UnitLV_"..tostring(self._data.id)
	local temp = getPlayerSetting(key,SettingType.TYPE_INT,1)
	
	self:setLabelText("TextLV","Lv"..temp.Value)
end

function UpGradeItem:onClick(event)
	if not event then return end

	if event and event.name == "ended" then
		if self._callback then
			self._callback(self,self._data)
		end
	end
end

function UpGradeItem:SetSelect(isSelect)
	self:setNodeVisible("select",isSelect)
end

return UpGradeItem