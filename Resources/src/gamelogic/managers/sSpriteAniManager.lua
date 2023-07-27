local sSpriteAniManager = class("sSpriteAniManager",_GModel.IManager)
local configManager = TWRequire("ConfigDataManager")
local SimpleAniNode = TWRequire("SimpleAniNode")
local drawColor = cc.c4f(28/255,218/255,28/255,1)

function sSpriteAniManager:_Init()

	self:resetData()

	self:_initMsg()
end

function sSpriteAniManager:resetData()
	self._SpriteAniNode = nil
	self._BulidingNode = nil
	self._EffectNode = nil
	self._LayerMap = {}
	self._EffectNodeList = {}
end

function sSpriteAniManager:_initMsg()
	self:addListener(MessageDef_GameLogic.MSG_AddEffect,self.onEventAddEffect)
end

function sSpriteAniManager:afterChangeScene()
	self._SpriteAniNode  = gRootManager:GetNode("spriteAniNode")
	self._BulidingNode   = gRootManager:GetNode("buildingNode")
	self._RoadNode   	 = gRootManager:GetNode("roadNode")
	self._EffectNode	 = gRootManager:GetNode("effectNode")
	self._ProjectileNode = gRootManager:GetNode("projectileNode")
	self._UIEffectNode	 = gRootManager:GetNode("UIEffectNode")
	self._TryPutNode     = gRootManager:GetNode("tryPutLayerNode")
	self._DrawDynNodeIml = gRootManager:GetNode("drawDynNodeIml")
	self._DrawStaticNodeIml = gRootManager:GetNode("drawStaticNodeIml")

	self._LayerMap = {}

	if self._SpriteAniNode then
		self._LayerMap["SpriteLayer"] = self._SpriteAniNode
	end

	if self._BulidingNode then
		self._LayerMap["BuildingLayer"] = self._BulidingNode
	end

	if self._EffectNode then
		self._LayerMap["EffectLayer"] = self._EffectNode
	end

	if self._TryPutNode then
		self._LayerMap["TryPutLayer"] = self._TryPutNode
	end

	if self._UIEffectNode then
		self._LayerMap["UIEffectLayer"] = self._UIEffectNode
	end

	if self._RoadNode then
		self._LayerMap["RoadLayer"] = self._RoadNode
	end

	if self._ProjectileNode then
		self._LayerMap["ProjectileLayer"] = self._ProjectileNode
	end

	self._LayerEMap = {}
	self._LayerEMap["SpriteLayer"] = ESpriteLayer.layerActor
	self._LayerEMap["BuildingLayer"] = ESpriteLayer.layerBuilding
	self._LayerEMap["EffectLayer"] = ESpriteLayer.layerEffect
	self._LayerEMap["TryPutLayer"] = ESpriteLayer.layerTryLayer
	self._LayerEMap["RoadLayer"] = ESpriteLayer.layerRoadLayer
	self._LayerEMap["ProjectileLayer"] = ESpriteLayer.layerProjectile
end

function sSpriteAniManager:addSceneObject(id,pos)
	local cfg = _GModel.DecorationCfg[id]
	if cfg then
		local ext = _GModel.StringUtil:getExtension(cfg.path)
		local obj = nil
		if ext == "csb" then
			obj = SimpleAniNode.new(cfg.path,true)
		end

		if obj then
			obj:setPosition(pos)
			self._SpriteAniNode:addChild(obj)
		end
	end
end

function sSpriteAniManager:getSpriteBatchNode(LayerName,spriteName,batchNodeName)
	if not self._LayerMap[LayerName] then 
		LogError("sSpriteAniManager:createSpriteBatchNode not find layer %s",LayerName)
		return
	end

	local layer = self._LayerMap[LayerName]
	local eLayer = self._LayerEMap[LayerName]

	local success = SpriteAniManager.scriptCreateBatchNode(eLayer,batchNodeName)
	if success then
		local fileUtils = cc.FileUtils:getInstance()
		local fullpath = fileUtils:fullPathForFilename(batchNodeName)
		local btNode = cc.utils.findChild(layer,fullpath)
		local sp = cc.Sprite:createWithSpriteFrameName(spriteName)
		btNode:addChild(sp)
		return sp
	end

	return nil
end

function sSpriteAniManager:createSpriteFrame(spriteName,LayerName)
	if not self._LayerMap[LayerName] then 
		LogError("sSpriteAniManager:createSpriteFrame not find layer %s",LayerName)
		return
	end

	local layer = self._LayerMap[LayerName]
	local sp = cc.Sprite:createWithSpriteFrameName(spriteName)
	layer:addChild(sp)
	return sp
end

function sSpriteAniManager:createCsbAniNode(path,strLayer)
	local layerNode = self._LayerMap[strLayer]
	if layerNode then
		local sceneNode = cc.CSLoader:createNode(path)
		local timeLine  = cc.CSLoader:createTimeline(path)
		layerNode:addChild(sceneNode)
		sceneNode:runAction(timeLine)
		return sceneNode,timeLine
	end
end

function sSpriteAniManager:createCsbAniBatchNode(path,batchNodeName,LayerName)

	if not self._LayerMap[LayerName] then 
		LogError("sSpriteAniManager:createSpriteBatchNode not find layer %s",LayerName)
		return
	end

	local layer = self._LayerMap[LayerName]
	local eLayer = self._LayerEMap[LayerName]

	local success = SpriteAniManager.scriptCreateBatchNode(eLayer,batchNodeName)
	if success then
		local fileUtils = cc.FileUtils:getInstance()
		local fullpath = fileUtils:fullPathForFilename(batchNodeName)
		local btNode = cc.utils.findChild(layer,fullpath)

		local sceneNode = cc.CSLoader:createNode(path,btNode)
		local timeLine  = cc.CSLoader:createTimeline(path)
		sceneNode:runAction(timeLine)
		return sceneNode,timeLine
	end

	return nil,nil
end

function sSpriteAniManager:createAniSpriteFrames(frameStrList, time)
	if frameStrList == nil or type(frameStrList) ~= 'table' then
		return nil
	end

	local cache = cc.SpriteFrameCache:getInstance()
	local len = #frameStrList
	local sfList = {}

	for i=1,len do
		local str = frameStrList[i]
		local sf = cache:getSpriteFrame(str)
		if not sf then
			LogError("sSpriteAniManager:createAniSpriteFrames not SpriteFrame %s",str)
			return
		end

		table.insert(sfList,sf)
	end

	local animMixed = cc.Animation:createWithSpriteFrames(sfList, time)
	return cc.Animate:create(animMixed)
end

function sSpriteAniManager:onEventAddEffect(data)
	local effectId = data.id
	local pos  = data.pos
	local strLayer = data.layer

	local layer = nil
	if strLayer then
		layer = self._LayerMap[strLayer]
	end
	self:AddEffect(pos,effectId,data.isUIEffect,layer)
end

function sSpriteAniManager:AddEffect(pos,effectId,isUIEffect,effectLayer)
	isUIEffect = isUIEffect or false

	local effectNode = isUIEffect and self._UIEffectNode or self._ProjectileNode
	if effectLayer then
		effectNode = effectLayer
	end

	if not effectNode then return end

	local effectCfg = configManager:getConfigById(effectId)
	if effectCfg then
		local effectInfo = {}
		local sceneNode = cc.CSLoader:createNode(effectCfg.effect)
		local timeLine  = cc.CSLoader:createTimeline(effectCfg.effect)
		sceneNode:runAction(timeLine)
		sceneNode:setPosition(pos)
		timeLine:play("start", false)

		effectInfo.sceneNode = sceneNode
		effectInfo.timeLine  = timeLine
		effectInfo.id = effectId

		table.insert(self._EffectNodeList,effectInfo)

		if effectCfg.sound then
			QueueEvent(EventType.ScriptEvent_Sound,{id = effectCfg.sound})
		end

		if not useBatchNode then
			effectNode:addChild(sceneNode)
		end
	end
end

function sSpriteAniManager:changeLayer(node,LayerName)
	local layerNode = self._LayerMap[LayerName]
	if layerNode then
		node:retain()
		node:detachFromParent()
		layerNode:addChild(node)
	end
end

function sSpriteAniManager:_Update(dt)
	if next(self._EffectNodeList) then
		local removeList = {}
		local len = #self._EffectNodeList

		for i=len,1,-1 do
			local effectInfo = self._EffectNodeList[i]
			if not effectInfo.timeLine:isPlaying() then

				print("sSpriteAniManager remove effect id=",effectInfo.id)

				table.insert(removeList,i)
			end
		end

		for _,id in ipairs(removeList) do
			local effectInfo = self._EffectNodeList[id]
			effectInfo.sceneNode:removeFromParent()
			table.remove(self._EffectNodeList,id)
		end
	end
end

function sSpriteAniManager:tryGetDrawNode()
	if self._DrawStaticNodeIml and self._DrawDynNodeIml then
		return true
	end

	self._DrawDynNodeIml = gRootManager:GetNode("drawDynNodeIml")
	self._DrawStaticNodeIml = gRootManager:GetNode("drawStaticNodeIml")

	if self._DrawStaticNodeIml and self._DrawDynNodeIml then
		return true
	end

	return false
end

function sSpriteAniManager:drawCircle(pos,radius,color,isDyn)
	if not self:tryGetDrawNode() then return end

	isDyn = isDyn or true
	if isDyn and self._DrawDynNodeIml then
		   self._DrawDynNodeIml:drawCircle(pos, radius, 0, 10, true, color)
	elseif self._DrawStaticNodeIml then
		self._DrawStaticNodeIml:drawCircle(pos, radius, 0, 10, true, color)
	end
end

function sSpriteAniManager:drawRect(vMin,vMax,isDyn)
	if not self:tryGetDrawNode() then return end

	isDyn = isDyn or true
	if isDyn and self._DrawDynNodeIml then
		   self._DrawDynNodeIml:drawRect(vMin, vMax,drawColor)
	elseif self._DrawStaticNodeIml then
		self._DrawStaticNodeIml:drawRect(vMin, vMax,drawColor)
	end
end

function sSpriteAniManager:onGameOver()
	print("sSpriteAniManager:onGameOver")
	self:ReleaseEffectNode()
end

function sSpriteAniManager:onRestart()
	print("sSpriteAniManager:onRestart")
	self:ReleaseEffectNode()
end

function sSpriteAniManager:ReleaseEffectNode()
	for _,effectInfo in ipairs(self._EffectNodeList) do
		effectInfo.sceneNode:removeFromParent()
	end

	self._EffectNodeList = {}
	self._SpriteBatchNodeMap = {}

	self._DrawStaticNodeIml = nil
	self._DrawDynNodeIml = nil
end

function sSpriteAniManager:_Release(isExit)
	if isExit then return end

	self:ReleaseEffectNode()
end

return sSpriteAniManager