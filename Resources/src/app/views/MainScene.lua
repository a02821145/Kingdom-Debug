require "gamelogic.init"

local StringUtil = TWRequire("StringUtil")

local MainScene = class("MainScene", cc.load("mvc").ViewBase, _GModel.IBaseInterface)

function MainScene:onCreate()
    self:load("UI/Senes/MainScene.csb")
    self:_initKeyBoard()
    self:_scheduleUpdate()

    self:setNodeVisible("LoadingNode",false)
    self:setNodeVisible("LoadingBarNode",true)
    self:setNodeVisible("StartNode",false)
    self:setNodeVisible("LoadingNumNode",true)
    self:playTimeLine("start",true)
    self:addBtnClickListener("btnStartGame",self.onClickStartGame)
    self:addBtnClickListener("btn_chinese",self.onClickSelectChinese)
    self:addBtnClickListener("btn_english",self.onClickSelectEnglish)

    self:setButtonEnable("btnStartGame",true)

    self._LoadingBar = self:getNode("LoadingBar")
    self._LoadingBar:setPercent(0)
    self._loadingList = {}

    self._needinitLoadingList = false
    self._needLoad = true

    local curLangStr = cc.UserDefault:getInstance():getStringForKey("language","none")
    if curLangStr == "none" then
        self:setNodeVisible("PanelLanguage",true)
        self:setNodeVisible("LoadingBarNode",false)
    else
        StringUtil:setCurrentLang(curLangStr)
        self:setNodeVisible("PanelLanguage",false)
        self._needinitLoadingList = true
    end
end


function MainScene:resizeImgs(winSize)
    self:setNodeContentSize("PanelBackGround",winSize)
    self:setNodeContentSize("loadingBackground",winSize)
    self:setNodeContentSize("PanelBG",winSize)
    self:setNodeContentSize("PanelLanguage",winSize)
    self:setPositionByDeltaRightDelta("SpCompass")
    self:setPositionByDeltaLeftDelta("NodeIcon")
    self:setPositionByDeltaLeftDelta("statueRed")
    
    self:resetLocationByRatio("LangBG")
    self:setPositionByDeltaTR("rightFlag")
end

function MainScene:initLoadingList()
    initGame(self._loadingList)

    local function playBackMusic()
        QueueEvent(EventType.ScriptEvent_Sound,{id = "MusicMainMenu",type="music"})
    end

    local function PreloadCSBCB()
        local fileUtils = cc.FileUtils:getInstance()
        local str = fileUtils:getStringFromFile("res/PreloadCSB.lua")
        local configList = loadstring(str)()
        for _,csPath in pairs(configList) do
            print("PreloadCSB ",csPath)
            cc.CSLoader:preloadCsbData(csPath)
        end
    end

    table.insert(self._loadingList,PreloadCSBCB)
    table.insert(self._loadingList,handler(self,self.setStartImgAni))
    table.insert(self._loadingList,playBackMusic)

    self._taskCount = #self._loadingList
   
    self:setLabelText("LoadingTotalNum", self._taskCount)
    self:setLabelText("LoadingNum",1)

    self:setNodeVisible("LoadingBarText_zn",StringUtil:isChinese())
    self:setNodeVisible("LoadingBarText",not StringUtil:isChinese())
end

function MainScene:setStartImgAni()
    local startImage1 = self:getNode("startImg")
    local startImage2 = self:getNode("startImg_zh")
    self:setNodeVisibleLang("startImg")

    startImage1:stopAllActions()
    startImage2:stopAllActions()

    self._startImage = self:getNodeLang("startImg")
    local act1 = cc.Show:create()
    local act2 = cc.DelayTime:create(0.5)
    local act3 = cc.Hide:create()
    local act4 = cc.DelayTime:create(0.5)

    local actSeq = cc.Sequence:create(act1,act2,act3,act4)
    local action = cc.RepeatForever:create(actSeq)
    self._startImage:runAction(action)
end

function MainScene:_init(data)
    self._needLoad = true

    if data and data.playAni then
         self:setNodeVisible("LoadingNode",true)
         self:playTimeLine("endLoading",false)

         if data.needLoad == false then
            self:setNodeVisible("StartNode",true)
            self:setNodeVisible("LoadingBarNode",false)
            self:setStartImgAni()

            QueueEvent(EventType.ScriptEvent_Sound,{id = "MusicMainMenu",type="music"})
            
            self._needLoad = false
         end

        local curLangStr = cc.UserDefault:getInstance():getStringForKey("language","none")
        if curLangStr == "none" then
            self:setNodeVisible("PanelLanguage",true)
            self:setNodeVisible("LoadingBarNode",false)
        end
    end

    if self._needinitLoadingList and self._needLoad then
        self:initLoadingList()
    end
end

function MainScene:_update(dt)
    if next(self._loadingList) then
        local cb = self._loadingList[1]
        cb()
        table.remove(self._loadingList,1)
        local left = #self._loadingList
        local loadedCount = self._taskCount - left
        local ratio = loadedCount/ self._taskCount
        self._LoadingBar:setPercent(ratio*100)

        self:setLabelText("LoadingNum",loadedCount)
        if ratio >= 1 then
            self:setNodeVisible("LoadingNumNode",false)
            self:setNodeVisible("LoadingBarNode",false)
            self:setNodeVisible("StartNode",true)
        end
    end
end

function MainScene:onClickSelectChinese()
    self:setLang("zh")
end

function MainScene:onClickSelectEnglish()
    self:setLang("en")
end

function MainScene:setLang(lang)
    cc.UserDefault:getInstance():setStringForKey("language",lang)
    StringUtil:setCurrentLang(lang)
    self:setNodeVisible("PanelLanguage",false)

    if self._needLoad == true then
        self:initLoadingList()
        self:setNodeVisible("LoadingBarNode",true)
    else
        self:setNodeVisible("StartNode",true)
        self:setNodeVisible("LoadingBarNode",false)
        self:setStartImgAni()
    end

    self:setNodeVisibleLang("startImg")
end

function MainScene:onClickStartGame()
    print("MainScene:onClickStartGame")

    local function loadLevelScene()
        local params = {
            playAni = true
        }

        gRootManager:ChangeScene("LevelScene",params)
    end

    self:setButtonEnable("btnStartGame",false)
    self:StopTimeLine()
    self:setNodeVisible("LoadingNode",true)
    self:playTimeLine("startLoading",false,loadLevelScene)
end

function MainScene:_Release()
    cc.AudioEngine:stopAll()
end


return MainScene
