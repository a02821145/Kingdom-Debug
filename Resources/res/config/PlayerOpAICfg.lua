local PlayerOpAICfg = 
{
	[1] = 
	{
		type = EPlayerAIType.PlayerAITypeNormal,--AI 类型中庸
		FireCannonRatio = 60, --炮塔初始释放概率
		FireCannonStep = 2,   --炮塔每秒释放概率增幅
		FireFarmerRatio = 50, --攻击目标农民概率
		FireSoldierRatio = 50, --攻击目标士兵概率
		FireGuardRatio = 0,    --攻击目标防守士兵概率

		WolfEventRatio = 15,	--召唤技能狼概率
		WolfEventAddDelta = 0,  --召唤技能狼每秒概率增幅

		createSoldierCountRatio = --造兵数量
		{
			[1] = 15,
			[2] = 25,
			[3] = 30,
			[4] = 30
		},

		createSoldierPreference = --兵种倾向
		{
			MyPreference = 0,--我方组合
			Preference = {}, --组合内容数组
			CounterTheEnemy = 0, --克制敌军
			AttackBuilding = 0, --建筑目标
		},

		createSoldierTypes = --兵种倾向
		{
			[actor_profession.prof_low_soldier] = 12.5,
			[actor_profession.prof_infantryman] = 15,
			[actor_profession.prof_archer] = 15,
			[actor_profession.prof_cavalier] = 15,
			[actor_profession.prof_wisard] = 15,
			[actor_profession.prof_wisard_master] = 14.5,
			[actor_profession.prof_thief] = 8,
			[actor_profession.prof_catapult] = 5,
		},
	},

	[2] = --快攻
	{
		type = EPlayerAIType.PlayerAITypeFast,
		FireCannonRatio = 100,
		FireCannonStep = 0,
		FireFarmerRatio = 0,
		FireSoldierRatio = 100,
		FireGuardRatio = 0,
		WolfEventRatio = 30,
		WolfEventAddDelta = 5,

		createSoldierCountRatio = 
		{
			[1] = 85,
			[2] = 10,
			[3] = 5,
		},

		createSoldierPreference = --兵种倾向
		{
			MyPreference = 60,--我方组合
			Preference = 
			{
				actor_profession.prof_infantryman,
				actor_profession.prof_archer,
				actor_profession.prof_thief
			}, --组合内容数组

			CounterTheEnemy = 0, --克制敌军
			AttackBuilding = 0, --建筑目标
		},

		createSoldierTypes = --兵种倾向
		{
			[actor_profession.prof_low_soldier] = 12.5,
			[actor_profession.prof_infantryman] = 15,
			[actor_profession.prof_archer] = 15,
			[actor_profession.prof_cavalier] = 14,
			[actor_profession.prof_wisard] = 12.5,
			[actor_profession.prof_wisard_master] = 12.5,
			[actor_profession.prof_thief] = 14.5,
			[actor_profession.prof_catapult] = 4,
		},
	},

	[3] =  --后期大神
	{
		type = EPlayerAIType.PlayerAITypeLateStageGod,
		FireCannonRatio = 60,
		FireCannonStep = 4,
		FireFarmerRatio = 30,
		FireSoldierRatio = 60,
		FireGuardRatio = 10,
		WolfEventRatio = 20,
		WolfEventAddDelta = 0,

		createSoldierCountRatio = 
		{
			[3] = 5,
			[4] = 10,
			[5] = 20,
			[6] = 20,
			[7] = 20,
			[8] = 15,
			[9] = 10
		},

		createSoldierPreference = --兵种倾向
		{
			MyPreference = 0,--我方组合
			Preference = {}, --组合内容数组

			CounterTheEnemy = 30, --克制敌军
			AttackBuilding = 30, --建筑目标
		},

		createSoldierTypes = --兵种倾向
		{
			[actor_profession.prof_low_soldier] = 4,
			[actor_profession.prof_infantryman] = 14.5,
			[actor_profession.prof_archer] = 15,
			[actor_profession.prof_cavalier] = 16.5,
			[actor_profession.prof_wisard] = 14.5,
			[actor_profession.prof_wisard_master] = 14.5,
			[actor_profession.prof_thief] = 6,
			[actor_profession.prof_catapult] = 15,
		},
	},

	[4] = --操作高手
	{
		type = EPlayerAIType.PlayerAITypeMaster,
		FireCannonRatio = 60,
		FireCannonStep = 4,
		FireFarmerRatio = 60,
		FireSoldierRatio = 20,
		FireGuardRatio = 20,
		WolfEventRatio = 0,
		WolfEventAddDelta = 1,

		createSoldierCountRatio = 
		{
			[1] = 10,
			[2] = 20,
			[3] = 30,
			[4] = 30,
			[5] = 10
		},

		createSoldierPreference = --兵种倾向
		{
			MyPreference = 30,--我方组合
			Preference = {
				actor_profession.prof_infantryman,
				actor_profession.prof_archer,
				actor_profession.prof_wisard_master
			}, --组合内容数组

			CounterTheEnemy = 30, --克制敌军
			AttackBuilding = 0, --建筑目标
		},

		createSoldierTypes = --兵种倾向
		{
			[actor_profession.prof_low_soldier] = 12.5,
			[actor_profession.prof_infantryman] = 12.5,
			[actor_profession.prof_archer] = 12.5,
			[actor_profession.prof_cavalier] = 12.5,
			[actor_profession.prof_wisard] = 12.5,
			[actor_profession.prof_wisard_master] = 12.5,
			[actor_profession.prof_thief] = 12.5,
			[actor_profession.prof_catapult] = 12.5,
		},
	},
}

return PlayerOpAICfg