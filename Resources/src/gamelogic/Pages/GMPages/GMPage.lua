local GMPage = class("GMPage",_GModel.IBasePage)

local GMBtnCountOneRow = 8

function GMPage:_init(data)

	self:_initGMCommand()	
	self:addBtnClickListener("BtnClose",self._close)
end

function GMPage:_initGMCommand()
	local GMList = TWRequire("GMList")
	local oneRowGMList = {}

	for _,cmd in ipairs(GMList) do
		table.insert(oneRowGMList,cmd)
		local len = #oneRowGMList
		
		if len%GMBtnCountOneRow == 0 then
			self:_createOneRowCmd(oneRowGMList)
			oneRowGMList = {}
		end
	end

	if next(oneRowGMList) then
		self:_createOneRowCmd(oneRowGMList)
	end
end

function GMPage:_createOneRowCmd(cmdList)
	local BtnGMCopy = self:getNode("BtnGMCopy")
	local LVGMListHCopy = self:getNode("LVGMListHCopy")
	local LVGMAll = self:getNode("LVGMAll")

	local newLVGMListH = LVGMListHCopy:clone()

	for _,cmd in ipairs(cmdList) do
		local newBtn = BtnGMCopy:clone()
		newBtn:setTitleText(cmd)
		newLVGMListH:addChild(newBtn)

		local cmdFun = "on"..cmd
		local func = self[cmdFun]

		if func then
			local chacterSelHandler = handler(self,func)
			newBtn:addClickEventListener(chacterSelHandler)
		end
	end

	LVGMAll:addChild(newLVGMListH)
end

function GMPage:onEditorActor()
	gRootManager:OpenPage("EditorActorPage")
	self:_close()
end

function GMPage:onQuadTreeInfo()
	gRootManager:OpenPage("QuadTreeInfoPage")
	self:_close()
end

function GMPage:onMemoryInfo()
	gRootManager:OpenPage("MemoryInfoPage")
	self:_close()
end

function GMPage:onActorOperator()
	gRootManager:OpenPage("ActorOperatorPage")
	self:_close()
end

function GMPage:onNodeTreeInfo()
	gRootManager:OpenPage("NodeTreeInfoPage")
	self:_close()
end

function GMPage:onActorEditor()
	gRootManager:OpenPage("ActorEditorPage")
	self:_close()
end

function GMPage:onManagersInfo()
	gRootManager:OpenPage("ManagersInfoPage")
	self:_close()
end

function GMPage:onActorRenderDebug()
	-- body
	gRootManager:OpenPage("ActorDebugRenderPage")
	self:_close()
end

function GMPage:onFinishGame()
	gRootManager:OpenPage("DebugGameWinOrLosePage")
	self:_close()
end

function GMPage:onAIMaster()
	gRootManager:OpenPage("AIMasterChangePage");
	self:_close()
end

function GMPage:onPauseActorPage()
	gRootManager:OpenPage("PauseActorPage")
	self:_close()
end

return GMPage