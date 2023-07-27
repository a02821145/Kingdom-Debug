
MessageDef_RootManager = 
{
	MSG_ChangeScene = 1,
    MSG_OpenPage = 2,
    MSG_ClosePage = 3,
    MSG_CloseCurPage = 4,
    MSG_SingleTouchBegin=5,
	MSg_SingleTouchMove=6,
	MSG_TouchEnd=7,
	MSG_MulitiTouchesBegin = 8,
	MSG_MultiTouchesMove = 9,
	MSG_AfterChangeScene = 10,
	MSG_PageClosed = 11
}

MessageDef_GameLogic = 
{
	MSG_Key = 1,
	MSG_ShowSceneNode = 2,
	MSG_TouchMapPos = 3,
	Msg_LevelScene_StartGame = 4,
	MSG_GameOver = 5,
	MSG_RefreshGems = 6,
	MSG_AddEffect = 7,
	MSG_GameStart = 8,
	MSG_CreateScriptActor = 9,
	MSG_PauseGame = 10,
	MSG_Restart = 11,
	MSG_SelectItem = 12,
	MSG_ShowLoading = 13,
	MSG_PlayLevelSceneAni = 14,
	MSG_ProcessNewbieCmd = 15,
	MSG_RefreshUpGrade = 16,
	MSG_PlayBattleSceneAni = 17,
	MSG_RefreshBattleCoins = 18,
	MSG_RefreshTryMoney = 19,
	Msg_LevelScene_EndGame = 20,
	Msg_OnItem_Event = 21,
	MSG_OnShow_Bag = 22,
	MSG_OnNewbie_Event = 23,
	MSG_Refresh_CharacterList = 24,
	MSG_Refresh_Stars = 25,
	MSG_ChangeLange = 26,
	MSG_RefreshSkillStars = 27,
	MSG_NewbieCallback = 28,
}

MessageDef_GM=
{
	MSG_Trigger_GM = 1,
	MSG_Fold_Tree=2,
	MSG_Refresh_DebugRender=3,
}

local MessageDef =
{
	MessageDef_RootManager,
	MessageDef_GameLogic,
	MessageDef_GM
}

MessageIDStrMap = 
{

}
function initMessageId()
	local baseId = 100000
	local msgIndex = 1

	for _,msgTab in ipairs(MessageDef) do
		for msgKey,_ in pairs(msgTab) do
			msgTab[msgKey] = baseId + msgIndex
			MessageIDStrMap[msgTab[msgKey]] = msgKey
			msgIndex = msgIndex + 1
		end
	end
end

MessageNoNeedPrint = {
	["MSg_SingleTouchMove"] = true,
}