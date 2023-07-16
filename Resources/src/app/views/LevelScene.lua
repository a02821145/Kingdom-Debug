local Vector2D 		  = TWRequire("Vector2D")
local LevelNode       = TWRequire("LevelNode")
local UserOptionKey   = TWRequire("UserOptionKey")
local SimpleAniNode   = TWRequire("SimpleAniNode")
local DialogueHandler = TWRequire("DialogueHandler")
local NewbieAniNode	  = TWRequire("NewbieAniNode")

local LevelScene = class("LevelScene", cc.load("mvc").ViewBase,_GModel.IBaseInterface,_GModel.IMsgInterface)

function LevelScene:onCreate()
	self:load("UI/Senes/LevelScene.csb")
	self:_initTouches()
end

function LevelScene:_init(data)
	self:InitUI()
	self:InitAnimalNodes()
	self:onRefreshGems()
	self:_scheduleUpdate()
	self:CheckUnLockPage()
	self:processNewbie()
	self:onRefreshStar()

	QueueEvent(EventType.ScriptEvent_Sound,{id = "MusicMap",type="music"})

	if data.playAni then
		 print("LevelScene:_init playAni")
		 self:setNodeVisible("LoadingNode",true)
   		 self:playTimeLine("endLoading",false)
	end
end

function LevelScene:InitUI()
	self._showOptionPanel = false

	self:setNodeVisible("optionPanel",self._showOptionPanel)
	self:addBtnClickListener("btnShop",self.OnBtnShop)
	self:addBtnClickListener("btnUpgrade",self.OnBtnUpgrade)
	self:addBtnClickListener("btnOption",self.onBtnOption)
	self:addBtnClickListener("btn_gems",self.onBtnGems)
	self:addBtnClickListener("btn_bag",self.onBtnBackPack)
	self:addBtnClickListener("btnBase",self.onBtnBase)
	self:setNodeVisible("LoadingNode",false)
	self:setNodeVisible("Loading",false)

	self:addListener(MessageDef_GameLogic.Msg_LevelScene_StartGame,self.onEventStartGame)
	self:addListener(MessageDef_GameLogic.MSG_RefreshGems,self.onRefreshGems)
	self:addListener(MessageDef_GameLogic.MSG_ShowLoading,self.onShowLoading)
	self:addListener(MessageDef_GameLogic.MSG_PlayLevelSceneAni,self.onPlayLevelAni)
	self:addListener(MessageDef_GameLogic.MSG_ProcessNewbieCmd,self.onEventProcessNewbieCommand)
	self:addListener(MessageDef_GameLogic.MSG_Refresh_Stars,self.onRefreshStar)
	self:addListener(MessageDef_RootManager.MSG_PageClosed,self.onPageClosed)
	self:addListener(MessageDef_GameLogic.MSG_ChangeLange,self.onChangeLang)

	self:setNodeVisibleLang("btn_shop_text")
	self:setNodeVisibleLang("btn_text_upgrade")
	self:setNodeVisibleLang("btn_gems_text")
	self:setNodeVisibleLang("btn_text_backpack")

	local dialogueNode = self:getNode("DialogNode")
	if dialogueNode then
		self._dialogueHandler = DialogueHandler.new(dialogueNode)
	end

	self._backGroundBG = self:getNode("BackGround")
	self._backGroundSize =  self._backGroundBG:getContentSize()
	self._frameSize = self:getNode("frame"):getContentSize()

	self._backgroundMask = self:getNode("BackgroundMask")
	self._backgroundMask:setPercent(50)

	self._backgroundMask:setVisible(false)
	_GModel.PlayerManager:insertLevelNewbieId(10000001)

	self._NewbieNode = self:getNode("NewbieNode")
	self._PanelNewbie = self:getNode("PanelNewbie")
	self._BtnNewbie = self:getNode("btnNewbie")

	local director = cc.Director:getInstance()
	self._WinSize = director:getWinSize()
	self._Center = Vector2D.new(self._WinSize.width * 0.5,self._WinSize.height * 0.5)

	self:resizeImgs(self._WinSize)
end

function LevelScene:resizeImgs(winSize)
	self:setNodeContentSize("frame",winSize)
	self:setNodeContentSize("loadingBackground",winSize)
	self._frameSize = winSize

	self:resetLocationByRatio("frame")
	self:resetLocationByRatio("DialogNode")
	self:resetLocationByRatio("Loading")
	self:resetLocationByRatio("LoadingNode")

	self:setPositionByDeltaRight("btnShop")
	self:setPositionByDeltaRight("btnUpgrade")
	self:setPositionByDeltaRight("btn_gems")
	self:setPositionByDeltaRight("btn_bag")
end

function LevelScene:onChangeLang()
	self:setNodeVisibleLang("btn_shop_text")
	self:setNodeVisibleLang("btn_text_upgrade")
	self:setNodeVisibleLang("btn_gems_text")
	self:setNodeVisibleLang("btn_text_backpack")
end

function LevelScene:onRefreshStar(data)
	local data = getPlayerSetting("levelCount",SettingType.TYPE_INT)
	local levelCount = data.Value
	local totalStars = levelCount*3*3

	data = getPlayerSetting("finishStarCount",SettingType.TYPE_INT,0)
	local finishStarCount = data.Value
	local str = string.format("%d/%d",finishStarCount,totalStars)
	self:setLabelText("iStart",str)
end

function LevelScene:CheckUnLockPage()
	local unlockList = _GModel.PlayerManager:getUnlockList()

	if next(unlockList) then
		gRootManager:OpenPage("UnLockCharPage",{ids = unlockList })
		_GModel.PlayerManager:cleaUnlockList()
	end
end

function LevelScene:TestClipNode()
	local clip = cc.ClippingNode:create()
	clip:setInverted(true)
	clip:setAlphaThreshold(0.0)
	self:addChild(clip)

	local layerColor = cc.LayerColor:create(cc.c4b(0,0,0,150))
	clip:addChild(layerColor)

	local nodef = cc.Node:create()
    local close = cc.Sprite:createWithSpriteFrameName("CryoGui9.png")
    close:setContentSize(170,90)
    nodef:addChild(close)
    nodef:setPosition(cc.p(960,640))
    clip:setStencil(nodef)--设置模版  
end

function LevelScene:onPlayLevelAni(data)
	if data.aniName then
		self:playTimeLine(data.aniName,data.isLoop or false)
	end
end

function LevelScene:onPageClosed(data)
	
end

function LevelScene:processNewbie()
	if gRootManager:CheckHasPage() then
		return
	end

	local newbieCfg = TWRequire("LevelSceneNewbie")
	local curNewbieCfg = nil
	self._CurNewbieId = nil

	local nextNewbieId = _GModel.PlayerManager:getNextLevelNewbieId()
	if nextNewbieId then
		local cfg = newbieCfg[nextNewbieId]

		if cfg then
			self._CurNewbieId = nextNewbieId
			curNewbieCfg = cfg
		end
	end

	if curNewbieCfg == nil then
		self:setNodeVisible("PanelUIUP",true)
		self:setNodeVisible("PanelUIDown",true)
		self:setNodeVisible("DialogNode",false)
		self:InitLevels()
		self:localteToCurLevel()
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_PlayLevelSceneAni,{aniName = "showUI"})
	else
		self._curSubNewbieId = curNewbieCfg.startId
		self._curSubNewCfg = curNewbieCfg
		self:processNewbieCommand(self._curSubNewCfg[self._curSubNewbieId])
	end
end

function LevelScene:NewbieTask001(nextId)
	gRootManager:OpenPage("UpGradePage")
	self:setNodeVisible("PanelNewbie",false)
	self._NewbieNode:removeAllChildren()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_ProcessNewbieCmd,{id  = nextId})
end

function LevelScene:onNewbieCommandFocusBtn(data)
	local function clickNextCallback(id)
		self._NewbieNode:removeAllChildren()
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = id})
	end

	self._NewbieNode:removeAllChildren()

	local clip = cc.ClippingNode:create()
	clip:setInverted(true)
	clip:setAlphaThreshold(0.0)
	self._NewbieNode:addChild(clip)

	local layerColor = cc.LayerColor:create(cc.c4b(0,0,0,150))
	clip:addChild(layerColor)

	local nodesList = string.split(data.nodes,",")
	local CBList = nil
	if data.callbackList then
		CBList = string.split(data.callbackList,",")
	end

	if next(nodesList) then
		local newbieNodef = cc.Node:create()
		for i,nodeName in ipairs(nodesList) do
			local btnNode = self:getNode(nodeName)
			local posX,posY = btnNode:getPosition()
			local size = btnNode:getContentSize()
			local niewBiePic = cc.Sprite:createWithSpriteFrameName("CryoGui9.png")
			local framePic = cc.Sprite:createWithSpriteFrameName("selectBlackFrame Yelow.png")

			niewBiePic:setContentSize(size.width*1.2,size.height*1.2)
			framePic:setContentSize(size.width*1.3,size.height*1.3)

			newbieNodef:addChild(niewBiePic)
			self._NewbieNode:addChild(framePic)

			niewBiePic:setPosition(cc.p(posX,posY))
			framePic:setPosition(cc.p(posX,posY))

			if CBList and next(CBList) then
				local strCallback = CBList[i]

				if strCallback and self[strCallback] then
					local cb = handler(self,self[strCallback])

					local function newbieBtnEvent()
						cb(data.nextId)
					end

					self._BtnNewbie:setPosition(posX,posY)
					self._BtnNewbie:setContentSize(cc.size(size.width*1.2,size.height*1.2))
					self._BtnNewbie:addClickEventListener(newbieBtnEvent)
				end
			end

			self:createNewbieArrow(Vector2D.new(posX,posY))
		end

		clip:setStencil(newbieNodef)--设置模版

		if data.newbieCSB then
			local newbieAniNode = NewbieAniNode.new(data,clickNextCallback)
			self._NewbieNode:addChild(newbieAniNode)
			newbieAniNode:setPosition(cc.p(self._WinSize.width*0.5,self._WinSize.height*0.5))
		end
	end
end

function LevelScene:createNewbieArrow(pos)
	local dir = pos - self._Center
	dir:SetNormalize()
	local angle = math.atan2(dir.y, dir.x)
	angle = -math.radian2angle(angle)
	local arrowNode = SimpleAniNode.new("UI/NewbieAni/NewbieArrow.csb")
	arrowNode:setRotation(angle)
	local newPos = pos - dir*400

	arrowNode:setPosition(cc.p(newPos.x,newPos.y))
	self._NewbieNode:addChild(arrowNode)
end

function LevelScene:onNewbieCommandShowCurrentLevel(subCfg)
	self:setNodeVisible("DialogNode",false)
	self:InitLevels()
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_ProcessNewbieCmd,{id = subCfg.nextId})
end

function LevelScene:onNewbieCommandHideUI(subCfg)
	self:setNodeVisible("PanelUIUP",false)
	self:setNodeVisible("PanelUIDown",false)
	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_ProcessNewbieCmd,{id = subCfg.nextId})
end

function LevelScene:onNewbieCommandShowUI(data)
	local isShow = data.value
	local nodesList = string.split(data.nodes, ",")
	if next(nodesList) then
		for _,nodeName in ipairs(nodesList) do
			self:setNodeVisible(nodeName,isShow)
		end
	end

	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_ProcessNewbieCmd,{id  = data.nextId})
end


function LevelScene:onNewbieCommandFocusBtn(data)
	local function clickNextCallback(id)
		self._NewbieNode:removeAllChildren()
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_OnNewbie_Event,{id  = id})
	end

	self._NewbieNode:removeAllChildren()

	local clip = cc.ClippingNode:create()
	clip:setInverted(true)
	clip:setAlphaThreshold(0.0)
	self._NewbieNode:addChild(clip)

	local layerColor = cc.LayerColor:create(cc.c4b(0,0,0,150))
	clip:addChild(layerColor)

	local nodesList = string.split(data.nodes,",")
	local CBList = nil
	if data.callbackList then
		CBList = string.split(data.callbackList,",")
	end

	if next(nodesList) then
		local newbieNodef = cc.Node:create()
		for i,nodeName in ipairs(nodesList) do
			local btnNode = self:getNode(nodeName)
			local posX,posY = btnNode:getPosition()
			local size = btnNode:getContentSize()
			local niewBiePic = cc.Sprite:createWithSpriteFrameName("CryoGui9.png")
			local framePic = cc.Sprite:createWithSpriteFrameName("selectBlackFrame Yelow.png")

			niewBiePic:setContentSize(size.width*1.2,size.height*1.2)
			framePic:setContentSize(size.width*1.3,size.height*1.3)

			newbieNodef:addChild(niewBiePic)
			self._NewbieNode:addChild(framePic)

			niewBiePic:setPosition(cc.p(posX,posY))
			framePic:setPosition(cc.p(posX,posY))

			if CBList and next(CBList) then
				local strCallback = CBList[i]

				if strCallback and self[strCallback] then
					local cb = handler(self,self[strCallback])

					local function newbieBtnEvent()
						cb(data.nextId)
					end

					self._BtnNewbie:setPosition(posX,posY)
					self._BtnNewbie:setContentSize(cc.size(size.width*1.2,size.height*1.2))
					self._BtnNewbie:addClickEventListener(newbieBtnEvent)
				end
			end

			self:createNewbieArrow(Vector2D.new(posX,posY))
		end

		clip:setStencil(newbieNodef)--设置模版

		if data.newbieCSB then
			local newbieAniNode = NewbieAniNode.new(data,clickNextCallback)
			self._NewbieNode:addChild(newbieAniNode)
			newbieAniNode:setPosition(cc.p(self._WinSize.width*0.5,self._WinSize.height*0.5))
		end
	end
end

function LevelScene:onNewbieCommandShowDialogue(subCfg)
	local function DialogueHideCallback()
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_ProcessNewbieCmd,{id = subCfg.nextId})
	end

	local function DialogueFinishCallback()
		self:playTimeLine("HideDialogue",false,DialogueHideCallback)
	end

	if self._dialogueHandler then
		self._dialogueHandler:ShowDialogue(subCfg.dialogId)
		self._dialogueHandler:setFinishCallback(DialogueFinishCallback)
		self:playTimeLine("ShowDialogue",false)
	end
end

function LevelScene:onNewbieCommandMoveMap(subCfg)
	local delta = subCfg.Delta
	local times = 20.0
	local timeStep = subCfg.time/times
	local moveStep = {}
	moveStep.x = delta.x/times
	moveStep.y = delta.y/times

	local function funcMoveDelta(data)
		self:MoveBackGround(data)
	end

	local function funcMoveEnd()
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_ProcessNewbieCmd,{id = subCfg.nextId})
	end

	for i=1,times do
		gRootManager:AddTimer(i*timeStep,false,funcMoveDelta,moveStep)
	end

	gRootManager:AddTimer(subCfg.time+1,false,funcMoveEnd)
end

function LevelScene:onEventProcessNewbieCommand(data)
	local id = data.id
	if id == nil then
		cc.UserDefault:getInstance():setBoolForKey("newbieID"..self._CurNewbieId,true)
		return 
	end

	if self._curSubNewCfg and self._curSubNewCfg[id] then
		self:processNewbieCommand(self._curSubNewCfg[id])
	end
end

function LevelScene:processNewbieCommand(subCfg)
	print("LevelScene:processNewbieCommand cmd=",subCfg.cmd)
	if subCfg and subCfg.cmd then
		local cmdStr =  "onNewbieCommand"..subCfg.cmd
		local func = self[cmdStr]

		if func then
			func(self,subCfg)
		end
	end
end

function LevelScene:onRefreshGems()
	local gems = _GModel.PlayerManager:GetGems()
	self:setLabelText("GemsCount",gems)

	local diamonds = _GModel.PlayerManager:GetDiamond()
	self:setLabelText("iDiamond",diamonds)
end

function LevelScene:onEventStartGame(data)
    local function loadLevelScene()
        local params = {
			level = data.level,
			playAni = true,
			difficulty = data.difficulty
		}

		gRootManager:ChangeScene("BattleScene",params)
    end

    self:StopTimeLine()
    self:setNodeVisible("LoadingNode",true)
    self:playTimeLine("startLoading",false,loadLevelScene)
end

function LevelScene:onBtnBase()

	local function gotoBase()
		local params = {
			playAni = true,
		}

		gRootManager:ChangeScene("BasementScene",params)
	end

	self:playTimeLine("startLoading",false,gotoBase)
end

function LevelScene:onBtnOption()
	-- self._showOptionPanel = not self._showOptionPanel
	-- self:setNodeVisible("optionPanel",self._showOptionPanel)

	gRootManager:OpenPage("LevelSettingPage")
end

function LevelScene:onBtnHomePage()
	
	local function GotoMainScene()
		local params = {
	        playAni = true
	    }
		gRootManager:ChangeScene("MainScene",params)
	end

	self:PlayLoadingAnimation(0.5,GotoMainScene)
end

function LevelScene:InitLevels()
	local data = getPlayerSetting("levelCount",SettingType.TYPE_INT)
	local levelCount = data.Value

	data = getPlayerSetting("curUnFinishLevel",SettingType.TYPE_INT)
	local curLevel = data.Value

	for i=1,curLevel do
		if i <= levelCount then
			self:AddLevel(i,i< curLevel,i == curLevel,i == levelCount)
		end
	end

	local strLevel = string.format("%d/%d",curLevel-1,levelCount)
	self:setLabelText("iLevel",strLevel)

	if curLevel > levelCount then
		self._backgroundMask:setVisible(true)
		self._backgroundMask:setPercent(100)
	end
end

function LevelScene:InitAnimalNodes()
	local Vector2D = TWRequire("Vector2D")

	self._AnimalNodesList = {}

	local AnimalNode = TWRequire("AnimalNode")
	local animalNodes = self:getNode("AnimalNode")
	local animals = animalNodes:getChildren()

	for _,animal in pairs(animals) do
		local name = animal:getName()
		local n = AnimalNode.new(name)
		table.insert(self._AnimalNodesList,n)
		animal:getParent():addChild(n)
		local x,y = animal:getPosition()
		n:SetPos(x,y)
	end

	local roadNodes  = self:getNode("RoadNode")

	for _,animalNode in ipairs(self._AnimalNodesList) do
		local name = animalNode:getName()
		local roads = roadNodes:getChildByName(name.."_road")

		if roads then
			local posNodes = roads:getChildren()
			local posList = {}

			for _,posNode in ipairs(posNodes) do
				local posX,posY = posNode:getPosition()
				table.insert(posList,Vector2D.new(posX,posY))
			end

			animalNode:setRoads(posList)
		end
	end
end

function LevelScene:AddLevel(iLevel,isOpen,isCurrentLevel,isMax)
	local params = {
		level = iLevel,
		isOpen = isOpen,
		isCurrent = isCurrentLevel,
		isMax = isMax
	}

	local str = string.format("Level%dNode",iLevel)
	local lvNode = LevelNode.new(params)
	local lvParentNode = self:getNode(str)
	lvParentNode:addChild(lvNode)

	self._currentLevelPosX = nil
	self._currentLevelPosY = nil

	if isCurrentLevel then
		self._currentLevelPosX = lvParentNode:getPositionX()
		self._currentLevelPosY = lvParentNode:getPositionY()
	end
end

function LevelScene:localteToCurLevel()
	if self._currentLevelPosX and self._currentLevelPosY then

		local delta = {}
		delta.x = self._WinSize.width*0.5 - self._currentLevelPosX
		delta.y = self._WinSize.height*0.5 - self._currentLevelPosY

		local backGroundNode = self:getNode("BackGround")
		local x,y = 0,0

		x = delta.x
		y = delta.y

		x = cc.clampf(x,self._WinSize.width - self._backGroundSize.width,0)
		y = cc.clampf(y,self._WinSize.height - self._backGroundSize.height,0)

		backGroundNode:setPosition(x,y)
	end
end

function LevelScene:_update(dt)
	for _,animal in ipairs(self._AnimalNodesList) do
		animal:update(dt)
	end

	if self._dialogueHandler then
		self._dialogueHandler:update(dt)
	end
end

function LevelScene:OnBtnShop()
	gRootManager:OpenPage("ShopPage",nil,false)
end

function LevelScene:OnBtnUpgrade()
	gRootManager:OpenPage("UpGradePage")
end

function LevelScene:onBtnGems()
	gRootManager:OpenPage("GemShopPage")	
end

function LevelScene:onBtnBackPack()
	gRootManager:OpenPage("BackPackPage")
end

function LevelScene:_onSingleTouchMoved(pos,delta)
	self:MoveBackGround(delta)
end

function LevelScene:MoveBackGround(delta)
	local backGroundNode = self:getNode("BackGround")
	local x,y = backGroundNode:getPosition()
	x = x + delta.x
	y = y + delta.y

	x = cc.clampf(x,self._WinSize.width - self._backGroundSize.width,0)
	y = cc.clampf(y,self._WinSize.height - self._backGroundSize.height,0)

	backGroundNode:setPosition(x,y)
end

function LevelScene:relocate()

end

function LevelScene:onShowLoading(data)
	if data.show then
		self:playTimeLine("loading",false)
		self:setNodeVisible("Loading",true)
	else
		self:setNodeVisible("Loading",false)
	end
end

function LevelScene:_Release()
    cc.AudioEngine:stopAll()
end

return LevelScene