local QuadTreeInfoPage = class("QuadTreeInfoPage",_GModel.IBasePage)

function QuadTreeInfoPage:_init(data)
	self:_initUI()
end

function QuadTreeInfoPage:_initUI()
	local panelItemCopy = self:getNode("panelItemQuadTreeCopy")
	local LVQuadTree = self:GetListView("QuadtreeInfoSv")

	local quadTreeInfo = getQuadTreeInfo()

	LVQuadTree:removeAllChildren()

	self.debugQuadTreeList = {}

	if quadTreeInfo and next(quadTreeInfo) then
		for k,v in pairs(quadTreeInfo) do
			local panelQuad = panelItemCopy:clone()
			LVQuadTree:addChild(panelQuad)

			local textQuad = cc.utils.findChild(panelQuad,"text_quad")
			textQuad:setString(v)
			local quadCheck = cc.utils.findChild(panelQuad,"quad_check")
			quadCheck.quadName = v

			local clickHandler = handler(self,self.onShowDebugQuadTree)
			quadCheck:addEventListener(clickHandler)
			table.insert(self.debugQuadTreeList,quadCheck)
		end
	end

	LVQuadTree:forceDoLayout()
end

function QuadTreeInfoPage:onShowDebugQuadTree(sender,eventType)
	if eventType == 0 then
		for _,cb in ipairs(self.debugQuadTreeList) do
			if cb ~= sender then
				cb:setSelected(false)
			end
		end
	end

	local isSelected = sender:isSelected()
	setQuadTreeDebug(sender.quadName,isSelected)
end

return QuadTreeInfoPage