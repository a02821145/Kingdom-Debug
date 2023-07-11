local ActorEditorPage = class("ActorEditorPage",_GModel.IBasePage)

function ActorEditorPage:_init(data)
	self:_initData()
	self:_initUI()
	self:refreshActors()
end

function ActorEditorPage:_initData()
	local configManager = TWRequire("ConfigDataManager")
	self._characters = configManager:getMod("Characters")
	self._weapons = configManager:getMod("Weapons")
	self._projectiles = configManager:getMod("Projectiles")
end

function ActorEditorPage:_initUI()
	self._LVActors	 = self:GetListView("LVActors")
	self._LVProperty = self:GetListView("LVProperty")

	self._PanelTitleCopy = self:getNode("PanelTitleCopy")
	self._TextSpaceCopy = self:getNode("TextSpaceCopy")
	self._BtnActorCopy = self:getNode("btnActorCopy")

end

function ActorEditorPage:refreshActors()

	local function AddActorData(titleStr,datas)
		local panelTitle = self._PanelTitleCopy:clone()
		local title = cc.utils.findChild(panelTitle,"title")
		title:setString(titleStr)
		self._LVActors:addChild(panelTitle)
		local selectActorHandler = handler(self,self.onSelectActor)
		for _,data in ipairs(datas) do
			local btn = self._BtnActorCopy:clone()
			btn:setTitleText(data.name)
			btn.data = data
			self._LVActors:addChild(btn)
			btn:addClickEventListener(selectActorHandler)
		end
	end

	self._LVActors:removeAllChildren()

	AddActorData("Characters",self._characters)
	AddActorData("Weapons",self._weapons)
	AddActorData("Projectiles",self._projectiles)

	self._LVActors:forceDoLayout()
end


function ActorEditorPage:onSelectActor(sender)
	
end

return ActorEditorPage