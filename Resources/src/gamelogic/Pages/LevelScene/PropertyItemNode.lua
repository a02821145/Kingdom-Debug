local PropertyItemNode = class("AnimalNode",ccui.Widget,_GModel.IBaseInterface)

function PropertyItemNode:ctor(data,pInfo,upInfo)
	self:load("UI/Pages/UpGradePage/proprtyItem.csb")
	self:setSpriteFrame("icon",pInfo.icon)
	self:setLabelTextLang("explain",_Lang(pInfo.displayName))
	self:setNodeVisibleLang("explain")
	
	self._data = data
	self._upInfo = upInfo

	local key = "UnitLV_"..tostring(self._data.id)
	local temp = getPlayerSetting(key,SettingType.TYPE_INT,1)
	self._Level = tonumber(temp.Value)

	local coms = data.components
	for _,com in ipairs(coms) do
		if com.name == pInfo.com then
			local curLevelInfo = self._upInfo.levelInfo[self._Level]
			local curValue= 0
			local hasHasCurValue = false

			if curLevelInfo and pInfo.upAdd then
				curValue = tonumber(curLevelInfo[pInfo.upAdd])
				local str = curValue

				if pInfo.isRatio then
					str = str.."%"
				end

				self:setLabelText("value",str)
				hasHasCurValue = true
			end

			if not hasHasCurValue and pInfo.vName and com[pInfo.vName] then
				local str = com[pInfo.vName]
				self:setLabelText("value",str)
				self:setNodeVisible("value_upgrade",false)
			end

			local nextLevelInfo = self._upInfo.levelInfo[self._Level+1]
			if nextLevelInfo then
				if pInfo.upAdd and nextLevelInfo[pInfo.upAdd] then
					local vValue = tonumber(nextLevelInfo[pInfo.upAdd])
					self:setNodeVisible("value_upgrade",(vValue-curValue) ~= 0)
					local iValue = math.floor(vValue)

					if vValue ~= iValue then
						local str = string.format("->%.1f",vValue)

						if pInfo.isRatio then
							str = str.."%"
						end

						self:setLabelText("value_upgrade",str)
					else
						local str = string.format("->%d",vValue)
						if pInfo.isRatio then
							str = str.."%"
						end
						self:setLabelText("value_upgrade",str)
					end
				end
			else  --max level
				
				self:setNodeVisible("value_upgrade",false)
			end
			break
		end
	end
end

return PropertyItemNode