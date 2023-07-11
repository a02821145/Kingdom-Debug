local NodeTreeInfoPage = class("NodeTreeInfoPage",_GModel.IBasePage)

local selectLevel = 3
local ignoreTypeList = 
{
	["Scene"] = true,
	["Layer"] = true,
}

local ignoreNodeList = 
{
	["LVNodeTree"] = true,
	["BattleScene"] = true,
	["PopUpNode"] = true,
}

local drawColor = cc.c4f(28/255,218/255,28/255,1)
local default_rectSize = 20

function NodeTreeInfoPage:_init(data)
	self:_initUI()
	self:_initMsg()
end

function NodeTreeInfoPage:_initUI()
	self._LVNodeTree = self:GetListView("LVNodeTree")
	self._LVSize = self._LVNodeTree:getContentSize()
	self._TextSpaceCopy = self:getNode("TextSpaceCopy")
	self._PanelStringCopy = self:GetListView("PanelStringCopy")
	self._BtnFoldTreeCopy = self:getNode("BtnFoldTreeCopy")
	self._drawNode = self:getNode("drawNode")
	self._PanelNodeInfoCopy = self:getNode("PanelNodeInfoCopy")
	self._PanelNodeInputCopy = self:getNode("PanelNodeInputCopy")
	self._PanelNodeCheckCopy = self:getNode("PanelNodeCheckCopy")

	self._LVNodeInfo = self:GetListView("LVNodeInfo")

	self._drawPrimitiveNode = cc.DrawNode:create()
    self._drawNode:addChild(self._drawPrimitiveNode)

	self._ShortestWidth = 0
	self._OldTag = 0
	self._CurSelectedNode = nil

	self._CurSelectedTitleBG = nil
	self._ScrolledPercent = 0
	self._findSelectNode = false
	self._findNode = false

	self._refreshRealTime = self:isCheckBoxSelected("CBRealTime")

	self._LVSpaceSize = self._TextSpaceCopy:getContentSize()
	self._LVNodeTree:onScroll(handler(self,self.onScrollCallback))
	
	self:addCheckBoxListener("CBRealTime",self.onRealTimeCB)
	self:_scheduleUpdate()
	-- self:setTimer(1)
	-- self:setTimer(0.1)

	self:refreshTree()
end

function NodeTreeInfoPage:_initMsg()
	self:addListener(MessageDef_GM.MSG_Fold_Tree,self.onFoldTreeNode)
	self:addListener(MessageDef_RootManager.MSG_SingleTouchBegin,self.onSelectNode)
end

function NodeTreeInfoPage:refreshTree()
	self._findNode = self._CurSelectedNode == nil and true or false

	self._LVNodeTree:removeAllChildren()
	
	local curScene = cc.Director:getInstance():getRunningScene()
	curScene.isFold = true
	self._ShortestWidth = 0
	self._CurSelectedTitleBG = nil

	self:insertNode(curScene)
	
	self._LVNodeTree:forceDoLayout()
	self._LVNodeTree:setContentSize(self._ShortestWidth,self._LVSize.height)

	if self._ScrolledPercent ~= self._LVNodeTree:getScrolledPercentVertical() then
		self._LVNodeTree:jumpToPercentVertical(self._ScrolledPercent)
	end
end

function NodeTreeInfoPage:updateTimer01()
	self:refreshDrawNode()
end

function NodeTreeInfoPage:updateTimer1()
	--self:refreshTree()
	if self._refreshRealTime then
		self:refreshTree()
	end
end

function NodeTreeInfoPage:refreshDrawNode()
	-- body
	if self._CurSelectedNode then
		self._drawPrimitiveNode:clear()

		local parentNode = self._CurSelectedNode:getParent()
		local anchorPoint = self._CurSelectedNode:getAnchorPoint()
		local size = self._CurSelectedNode:getContentSize()
		local x,y = self._CurSelectedNode:getPosition()
		local width = size.width
		local height = size.height

		x = x - anchorPoint.x*size.width
		y = y - anchorPoint.y*size.height

		if parentNode then
			local worldPos = parentNode:convertToWorldSpace(cc.p(x,y))
			local localPos = self._drawNode:convertToNodeSpace(worldPos)
			
			x = localPos.x
			y = localPos.y
		end

		if size.width * size.height == 0 then
			width = default_rectSize
			height = default_rectSize
		end

		self._drawPrimitiveNode:drawRect(cc.p(x,y),cc.p(x+width,y+height), drawColor)
	end
end

function NodeTreeInfoPage:insertNode(node,level)
	level = level or 0
	local name = node:getName()
	local childCount = node:getChildrenCount()
	local isFold = node.isFold or false
	local nodeType = "node"

	if node.getTypeName then
		nodeType = node:getTypeName()
	end

	name = string.format("%s[%s]",name,nodeType)
	local newPanelString = self._PanelStringCopy:clone()
	local Title = cc.utils.findChild(newPanelString,"Title")
	local TitleBG = cc.utils.findChild(newPanelString,"TitleBG")
	local PanelSize = newPanelString:getContentSize()
	local PanelWith = PanelSize.width

	for i=1,level do
		local newTextSpace = self._TextSpaceCopy:clone()
		newPanelString:addChild(newTextSpace)
		newTextSpace:setPosition(cc.p((i-1)*self._LVSpaceSize.width,0))
	end

	if level > 0 then
		TitleBG:setPositionX(level * self._LVSpaceSize.width)
		PanelWith= PanelWith + level * self._LVSpaceSize.width
	end

	TitleBG.node = node
	node.level = level
	TitleBG:addClickEventListener(handler(self,self.onClickPanelBG))
	Title:setString(name)

	if self._CurSelectedNode == node then
		self._findNode = true
		TitleBG:setBackGroundColorOpacity(128)
	end

	self._LVNodeTree:addChild(newPanelString)

	if childCount > 0 then
		local newBtn = self._BtnFoldTreeCopy:clone()
		local btnSize = newBtn:getContentSize()
		PanelWith = PanelWith + btnSize.width

		local clickFoldHandler = handler(self,self.onClickFold)

		if isFold then
			newBtn:setTitleText("-")
		else
			newBtn:setTitleText("+")
		end

		local TitleBGSize = TitleBG:getContentSize()
		local PosX = TitleBG:getPositionX()

		newBtn:addClickEventListener(clickFoldHandler)
		newBtn.node = node
		newPanelString:addChild(newBtn)
		newBtn:setPosition(cc.p(PosX+TitleBGSize.width,TitleBGSize.height*0.5))

		if isFold then
			local children = node:getChildren()

			for _,child in pairs(children) do
				self:insertNode(child,level+1)
			end
		end
	end

	if PanelWith > self._ShortestWidth then
		self._ShortestWidth = PanelWith
	end
	newPanelString:setContentSize(PanelWith,PanelSize.height)
end

function NodeTreeInfoPage:onClickPanelBG(sender)
	print("NodeTreeInfoPage:onClickPanelBG")

	if self._CurSelectedTitleBG  then
		self._CurSelectedTitleBG:setBackGroundColorOpacity(0)
	end

	if self._CurSelectedNode then
		self._CurSelectedNode:setTag(self._OldTag)
	end

	sender:setBackGroundColorOpacity(128)
	self._CurSelectedNode = sender.node
	self._CurSelectedTitleBG = sender
	self._OldTag = self._CurSelectedNode:getTag()
	self._CurSelectedNode:setTag(100001)
	self:refreshNodeInfo()
end

function NodeTreeInfoPage:onFoldTreeNode()
	local oldSize = self._LVNodeTree:getInnerContainerSize()
	local height = oldSize.height*self._ScrolledPercent*0.01
	self:refreshTree()
	local newSize = self._LVNodeTree:getInnerContainerSize()
	self._ScrolledPercent = (height/newSize.height)*100
end

function NodeTreeInfoPage:onClickFold(sender)
	-- body
	local isFold = not not sender.node.isFold
	sender.node.isFold = not isFold
	gMessageManager:sendMessage(MessageDef_GM.MSG_Fold_Tree)
end

function NodeTreeInfoPage:onScrollCallback(event)
	local sender = event.target

	if event.name and event.name == "SCROLLING" then
		self._ScrolledPercent = sender:getScrolledPercentVertical()
	end
end


function NodeTreeInfoPage:onSelectNode(message)
	local CurSelectedNodeList = {}
	local pos = message.pos

	local function selectNode(node,level)
		level = level or 0

		local parentNode = node:getParent()
		local count = node:getChildrenCount()
		local anchorPoint = node:getAnchorPoint()
		local size = node:getContentSize()
		local x,y = node:getPosition()

		if parentNode then
			local worldPos = parentNode:convertToWorldSpace(cc.p(x,y))
			local localPos = self._drawNode:convertToNodeSpace(worldPos)
			local touchPos = self._drawNode:convertToNodeSpace(pos)

			localPos.x = localPos.x - anchorPoint.x*size.width
			localPos.y = localPos.y - anchorPoint.y*size.height

			local nodeRect = cc.rect(localPos.x,localPos.y,size.width,size.height)
			if cc.rectContainsPoint(nodeRect,touchPos) then
				local canAddToList = true

				if node.getTypeName then
					local typeName = node:getTypeName()
					if ignoreTypeList[typeName] then
						canAddToList = false
					end
				end

				local name = node:getName()
				if ignoreNodeList[name] then
					canAddToList = false
				end

				if canAddToList then
					table.insert(CurSelectedNodeList,node)
				end
			end
		end

		if count > 0 then
			local children = node:getChildren()
			for _,child in ipairs(children) do
				selectNode(child,level+1)
			end
		end
	end

	local curScene = cc.Director:getInstance():getRunningScene()
	selectNode(curScene)

	if next(CurSelectedNodeList) then
		local len = #CurSelectedNodeList
		if len > 1 then
			table.sort(CurSelectedNodeList,function ( a,b )
				local size1 = a:getContentSize()
				local size2 = b:getContentSize()

				local area1 = size1.width*size1.height
				local area2 = size2.width*size2.height
				return area1 < area2
			end)
		end

		if self._CurSelectedNode then
			self._CurSelectedNode:setTag(self._OldTag)
		end

		self._CurSelectedNode = CurSelectedNodeList[1]
		self._OldTag = self._CurSelectedNode:getTag()
		self._CurSelectedNode:setTag(100001)
	end

	self:refreshNodeInfo()
	self:refreshTree()
end

function NodeTreeInfoPage:insertNodeInfoPanel(title,content )
	-- body
	local PanelNodeInfo =  self._PanelNodeInfoCopy:clone()
	local textTitle = cc.utils.findChild(PanelNodeInfo,"TextTitle")
	local textContent = cc.utils.findChild(PanelNodeInfo,"TextContent")
	textTitle:setString(title)
	textContent:setString(content)
	self._LVNodeInfo:addChild(PanelNodeInfo)
end


function NodeTreeInfoPage:insertNodeInputPanel(title,content,node,callback)
	local panelInput = self._PanelNodeInputCopy:clone()
	local textTitle = cc.utils.findChild(panelInput,"TextTitle")
	local tfInput = cc.utils.findChild(panelInput,"TFInput")

	textTitle:setString(title)
	tfInput:setString(content)
	tfInput.inputType = type(content)
	tfInput.node = node
	tfInput.callback = callback
	tfInput:onEvent(handler(self,self.onNodeEdit))
	self._LVNodeInfo:addChild(panelInput)
end

function NodeTreeInfoPage:insertNodeCBPanel(title,selected,node,callback)
	local panelInput = self._PanelNodeCheckCopy:clone()
	local textTitle = cc.utils.findChild(panelInput,"TextTitle")

	textTitle:setString(title)
	local cb = cc.utils.findChild(panelInput,"CB")
	cb.node = node
	cb.callback = callback
	cb:setSelected(selected)
	local clickHandler = handler(self,self.onCBEvent)
	cb:onEvent(clickHandler)
	self._LVNodeInfo:addChild(panelInput)
end

function NodeTreeInfoPage:onNodeEdit(event)
	local sender = event.target
	local inputType = sender.inputType
	local node = sender.node
	local callback = sender.callback
	local content = sender:getString()

	if not content or #content == 0 then
		return
	end

	if inputType == "number" then
		content = tonumber(content)
	end

	if not content then
		LogError("bad type ,need "..inputType)
		return
	end

	node[callback](node,content);
end

function NodeTreeInfoPage:onCBEvent(event)
	local sender = event.target
	local isSelect = event.name == "selected"
	local node = sender.node
	local callback = sender.callback

	node[callback](node,isSelect);
end

function NodeTreeInfoPage:refreshNodeInfo()
	if self._CurSelectedNode then
		self._LVNodeInfo:removeAllChildren()

		local nodeType = ""
		local nodeName = ""

		if self._CurSelectedNode.getTypeName then
			nodeType = self._CurSelectedNode:getTypeName()
		end

		self:insertNodeInfoPanel("type:",nodeType)

		nodeName = self._CurSelectedNode:getName()
		self:insertNodeInfoPanel("name:",nodeName)

		local visible = self._CurSelectedNode:isVisible()
		self:insertNodeCBPanel("visible",visible,self._CurSelectedNode,"setVisible")

		local x,y = self._CurSelectedNode:getPosition()
		self:insertNodeInputPanel("x:",x,self._CurSelectedNode,"setPositionX")
		self:insertNodeInputPanel("y:",y,self._CurSelectedNode,"setPositionY")

		local rotation = self._CurSelectedNode:getRotation()
		self:insertNodeInputPanel("rotation:",rotation,self._CurSelectedNode,"setRotation")

		local scaleX = self._CurSelectedNode:getScaleX()
		local scaleY = self._CurSelectedNode:getScaleY()
		local scaleZ = self._CurSelectedNode:getScaleZ()
		self:insertNodeInputPanel("scaleX:",scaleX,self._CurSelectedNode,"setScaleX")
		self:insertNodeInputPanel("scaleY:",scaleY,self._CurSelectedNode,"setScaleY")
		self:insertNodeInputPanel("scaleZ:",scaleZ,self._CurSelectedNode,"setScaleZ")

		local size = self._CurSelectedNode:getContentSize()
		self:insertNodeInputPanel("width:",size.width,self._CurSelectedNode,"setWidth")
		self:insertNodeInputPanel("height:",size.height,self._CurSelectedNode,"setHeight")

		local anchorPoint = self._CurSelectedNode:getAnchorPoint()
		self:insertNodeInfoPanel("anchor:",string.format("x:%s y:%s",anchorPoint.x,anchorPoint.y))

		local tag = self._CurSelectedNode:getTag()
		self:insertNodeInfoPanel("tag:",tostring(tag))

		local zOrder = self._CurSelectedNode:getLocalZOrder()
		self:insertNodeInputPanel("LocalZOrder:",zOrder,self._CurSelectedNode,"_setLocalZOrder")

		local GlobalZOrder = self._CurSelectedNode:getGlobalZOrder()
		self:insertNodeInputPanel("GlobalZOrder:",GlobalZOrder,self._CurSelectedNode,"setGlobalZOrder")

		local color = self._CurSelectedNode:getColor()
		self:insertNodeInfoPanel("color:",string.format("r:%s g:%s b:%s",color.r,color.g,color.b))

		local alpha = self._CurSelectedNode:getOpacity()
		self:insertNodeInfoPanel("alpha:",tostring(alpha))

		self._LVNodeInfo:forceDoLayout()
	end
end

function NodeTreeInfoPage:onRealTimeCB(event)
	-- body
	if event.name == "selected" then
		self._refreshRealTime = true
	elseif event.name == "unselected" then
		self._refreshRealTime = false
	end
end

return NodeTreeInfoPage