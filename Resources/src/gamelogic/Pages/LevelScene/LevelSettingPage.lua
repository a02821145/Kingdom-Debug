local UserOptionKey = TWRequire("UserOptionKey")

local LevelSettingPage     = class("LevelSettingPage",_GModel.IBasePage)

function LevelSettingPage:_init(data)

	local bSoundOn = cc.UserDefault:getInstance():getBoolForKey(UserOptionKey.SoundOn,true)
	local bMusicOn = cc.UserDefault:getInstance():getBoolForKey(UserOptionKey.MusicOn,true)

	local soundTexStr = bSoundOn and "Sound Outline 128.png" or "Sound Off Outline 128.png"
	local musicTexStr = bMusicOn and "Music Outline 128.png" or "Music Off Outline 128.png"

	self:setButtonTexture("BtnSound",soundTexStr,soundTexStr,nil,1)
	self:setButtonTexture("BtnMusic",musicTexStr,musicTexStr,nil,1)

	self:addBtnClickListener("BtnMusic",self.onBtnMusic)
	self:addBtnClickListener("BtnSound",self.onBtnSound)
	self:addBtnClickListener("BtnLanguage",self.onBtnLanguage)
	self:addBtnClickListener("BtnClose",self._close)
	self:addBtnClickListener("BtnClear",self.onClearProgress)
	self:addBtnClickListener("btnChinese",self.onChangeLangChinese)
	self:addBtnClickListener("btnEnglish",self.onChangeLangEnglish)
	self:setNodeVisible("PanelLanguage",false)

	local panelLang = self:getNode("PanelLanguage")
	panelLang:onTouch(handler(self,self.onCloseLanguage))

	local panelBG = self:getNode("PanelBG")
	panelBG:onTouch(handler(self,self._close))

	self:setNodeVisibleLang("TextSetting")
	self:setNodeVisibleLang("TextMusic")
	self:setNodeVisibleLang("TextSound")
	self:setNodeVisibleLang("TextLanguage")
	self:setNodeVisibleLang("TextClear")
end

function LevelSettingPage:onBtnMusic()
	local bMusicOn = cc.UserDefault:getInstance():getBoolForKey(UserOptionKey.MusicOn,true)
	bMusicOn = not bMusicOn
	local musicTexStr = bMusicOn and "Music Outline 128.png" or "Music Off Outline 128.png"
	self:setButtonTexture("BtnMusic",musicTexStr,musicTexStr,nil,1)
	cc.UserDefault:getInstance():setBoolForKey(UserOptionKey.MusicOn, bMusicOn)

	QueueEvent(EventType.ScriptEvent_Sound,{cmd = "MusicOn",isOn=bMusicOn})
	QueueEvent(EventType.ScriptEvent_Sound,{id = "MusicMap",type="music"})
end

function LevelSettingPage:onBtnSound()
	local bSoundOn = cc.UserDefault:getInstance():getBoolForKey(UserOptionKey.SoundOn,true)
	bSoundOn = not bSoundOn
	local soundTexStr = bSoundOn and "Sound Outline 128.png" or "Sound Off Outline 128.png"
	self:setButtonTexture("BtnSound",soundTexStr,soundTexStr,nil,1)
	cc.UserDefault:getInstance():setBoolForKey(UserOptionKey.SoundOn, bSoundOn)
	QueueEvent(EventType.ScriptEvent_Sound,{cmd = "SoundOn",isOn=bSoundOn})
end

function LevelSettingPage:onBtnLanguage()
	self:setNodeVisible("PanelLanguage",true)
end

function LevelSettingPage:onCloseLanguage()
	self:setNodeVisible("PanelLanguage",false)
end

function LevelSettingPage:onChangeLangChinese()
	self:ChangeLang("zh")
end

function LevelSettingPage:onChangeLangEnglish()
	self:ChangeLang("en")
end

function LevelSettingPage:ChangeLang(lang)
	local curLangStr = cc.UserDefault:getInstance():getStringForKey("language","none")
	if curLangStr == lang then
		self:setNodeVisible("PanelLanguage",false)
		return
	end

	local function changeLangOKCallback()
		local StringUtil = TWRequire("StringUtil")
		cc.UserDefault:getInstance():setStringForKey("language",lang)
    	StringUtil:setCurrentLang(lang)

		local params = {
            playAni = true,
        }

        gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowLoading,{show = true})


        local function afterChangeLang()
        	gRootManager:CloseAllPages()
        	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_ChangeLange)
        	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_ShowLoading,{show = false})
        end

        gRootManager:AddTimer(1,false,afterChangeLang)
	end

	local params = 
	{
		text = "@Warning1",
		callbackOK = changeLangOKCallback,
	}

	gRootManager:OpenPage("CheckBoxPage",params,false)
end

function LevelSettingPage:onClearProgress()
	local function clearProgressOKCallback()
		local fileUtils = cc.FileUtils:getInstance()
		local writeablePath = fileUtils:getWritablePath()
		local userXmlFile = writeablePath.."UserDefault.xml";
		local userLogFile = writeablePath.."TWLog.txt"

		local MD5 = TWRequire("Md5")
		local userPlayerSettingFile = writeablePath..MD5.sumhexa("defaultPlayerSetting.txt")

		DeleteSingleFileOrEmptyDirectory(userXmlFile)
		DeleteSingleFileOrEmptyDirectory(userLogFile)
		DeleteSingleFileOrEmptyDirectory(userPlayerSettingFile)

		print("userXmlFile = "..userXmlFile)
		print("userLogFile = "..userLogFile)
		print("userPlayerSettingFile = "..userPlayerSettingFile)

		local params = {
            playAni = true,
            needLoad = false,
        }

        gRootManager:ChangeScene("MainScene",params)

        gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowLoading,{show = true})
	end

	local params = 
	{
		text = "@Warning3",
		callbackOK = clearProgressOKCallback,
	}

	gRootManager:OpenPage("CheckBoxPage",params,false)
end

return LevelSettingPage