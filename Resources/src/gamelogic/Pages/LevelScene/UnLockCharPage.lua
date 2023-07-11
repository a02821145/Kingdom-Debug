local UnLockCharPage = class("UnLockCharPage",_GModel.IBasePage)
local UnLockCardNode =  TWRequire("UnLockCardNode")
local SimpleAniNode = TWRequire("SimpleAniNode")
local configManager = TWRequire("ConfigDataManager")

function UnLockCharPage:_init(data)
	self._ids = data.ids

	self._myIds = {}

	for _,idCfg in ipairs(self._ids) do
		local info = configManager:getConfigById(idCfg.id)
		if info.displayCSB then
			table.insert(self._myIds,idCfg)
		end
	end
	self._isSingle = #self._myIds%2 == 1

	self:initUI()
end

function UnLockCharPage:initUI()
	for i,idCfg in ipairs(self._myIds) do
		local sKey = string.format("Card%sNode%d",self._isSingle and "Single" or "Double",i)
		local pNode = self:getNode(sKey)
		pNode:removeAllChildren()

		local cardNode = UnLockCardNode.new(idCfg)
		pNode:addChild(cardNode)
		cardNode:setPosition(cc.p(0,0))
	end

	local effectNode = self:getNode("effectNode")
	effectNode:removeAllChildren()

	local sunEffect = SimpleAniNode.new("UI/Effects/effectSunShine.csb")
	effectNode:addChild(sunEffect)

	self:playTimeLine(self._isSingle and  "StartSingleCard" or "StartDoubleCard",false)

	self:addBtnClickListener("btnOK",self.onBtnOK)

	self._panelBG = self:getNode("PanelBG")
	self._panelBG:onTouch(handler(self,self.onTouchPanel))

	QueueEvent(EventType.ScriptEvent_Sound,{id = "UnLockSound"})

	self:setNodeVisibleLang("TextUnlcok")
	self:setNodeVisibleLang("textOK")
end

function UnLockCharPage:onTouchPanel(event)
	if event.name ~= "ended" then return end

	self:SaveUnLockInfo()

	self:_close()
end

function UnLockCharPage:onBtnOK()
	self:SaveUnLockInfo()

	self:_close()
end

function UnLockCharPage:SaveUnLockInfo()
	for i,idCfg in ipairs(self._ids) do
		setPlayerSetting("unit_unlock_"..tostring(idCfg.id),SettingType.TYPE_BOOL,true)
	end
end

return UnLockCharPage