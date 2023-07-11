local LevelSceneNewbie = 
{
	[10000001] = 
	{
		startId = 100000011,
		[100000011] = {id = 100000011,cmd = "HideUI",nextId = 100000012},
		[100000012] = {id = 100000012,cmd = "ShowDialogue",dialogId =20000001,nextId = 100000013},
		[100000013] = {id = 100000013,cmd = "ShowDialogue",dialogId =20000002,nextId = 100000014},
		[100000014] = {id = 100000014,cmd = "ShowDialogue",dialogId =20000003,nextId = 100000015},
		[100000015] = {id = 100000015,cmd = "ShowDialogue",dialogId =20000004,nextId = 100000016},
		[100000016] = {id = 100000016,cmd = "ShowDialogue",dialogId =20000005,nextId = 100000017},
		[100000017] = {id = 100000017,cmd = "ShowDialogue",dialogId =20000006,nextId = 100000018},
		[100000018] = {id = 100000018,cmd = "MoveMap",Delta={x = 0,y = -200},time=1,nextId = 100000019},
		[100000019] = {id = 100000019,cmd = "ShowCurrentLevel"},
	},

	[10000002] = 
	{
		startId = 100000021,
		[100000021] = {id = 100000021,cmd = "ShowUI",nodes="PanelNewbie",value = true,nextId = 100000022},
		[100000022] = {id = 100000022,cmd = "FocusBtn",nodes = "btnUpgrade",callbackList = "NewbieTask001",newbieCSB = "UI/NewbieAni/NewbieLevelSceneStep1.csb"},
	},
}

return LevelSceneNewbie