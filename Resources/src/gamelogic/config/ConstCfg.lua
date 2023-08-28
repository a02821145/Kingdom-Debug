local ConstCfg = 
{
	MAX_MAP_SCALE_SPEED = 0.05,
	MAX_MAP_SCALE_SIZE = 2,
	MIN_MAP_SCALE_SIZE = 1,
	MAP_SCALE_DEACCEL = 0.3,
	MAX_LEVEL = 10,
	SKILL_STAR_COUNT = 3,
	Decisive_Time = 15,

	buildingShowPrio = {
		[building_type.player_fence_building] = 1,
		[building_type.enemy_fence_building] = 1,
		[building_type.player_house] = 2,
		[building_type.enemy_house] = 2,
		[building_type.player_main_building] = 3,
		[building_type.enemy_main_building] = 3,
		[building_type.player_wooden_wall] = 4,
		[building_type.enemy_wooden_wall] = 4,
		[building_type.player_stone_wall] = 5,
		[building_type.enemy_stone_wall] = 5,
		[building_type.player_wooden_door] = 6,
		[building_type.enemy_wooden_door] = 6,
		[building_type.player_stone_door] = 7,
		[building_type.enemy_stone_door] = 7,
		[building_type.player_ware_house] = 8,
		[building_type.enemy_ware_house] = 8,
		[building_type.player_church] = 9,
		[building_type.enemy_church] = 9,
		[building_type.player_add_atk_building] = 10,
		[building_type.enemy_add_atk_building] = 10,
		[building_type.player_add_def_building] = 11,
		[building_type.enemy_add_def_building] = 11,
		[building_type.player_add_spd_buildnig] = 12,
		[building_type.enemy_add_spd_buildnig] = 12,
		[building_type.player_add_shoot_building] = 13,
		[building_type.enemy_add_shoot_building] = 13,
		[building_type.player_arrow_tower] = 14,
		[building_type.enemy_arrow_tower] = 14,
		[building_type.player_cannon_buliding] = 15,
		[building_type.enemy_cannon_buliding] = 15,
		[building_type.player_magic_tower] = 16,
		[building_type.enemy_magic_tower] = 16,
		[building_type.player_long_cannon_building] = 17,
		[building_type.enemy_long_canon_building] = 16,
		[trap_type.trap_type_stop] = 17,
	},

	SoldiersSmallIconSp = 
	{
		[actor_profession.prof_lower_soldier_spear] = "FarmerSpearRed-stand01_00.png",
		[actor_profession.prof_lower_archer] = "gongjianshou-stand01_00.png",
		[actor_profession.prof_lower_cavalier] = "FarmerCavalierRed-attack01_00.png",
		[actor_profession.prof_lower_wisard] = "LowerMasterRed-stand01_00.png",
		[actor_profession.prof_farmer] = "nongming-stand01_00.png",
		[actor_profession.prof_low_soldier] = "LowerSoldierRed-stand01_00.png",
		[actor_profession.prof_infantryman] = "InfantrymanRed-stand01_00.png",
		[actor_profession.prof_archer] = "AnchorRed-stand01_00.png",
		[actor_profession.prof_cavalier] = "CavalierRed-stand01_00.png",
		[actor_profession.prof_wisard] = "WitchRed-stand01_00.png",
		[actor_profession.prof_thief] = "ThiefRed-stand01_00.png",
		[actor_profession.prof_wisard_master] = "MasterRed-stand_00.png",
		[actor_profession.prof_catapult] = "catapult-upgrade_37.png",
	},

	SoldiersSmallIconSpMy = 
	{
		[actor_profession.prof_lower_soldier_spear] = "FarmerSpearBlue-stand01_00.png",
		[actor_profession.prof_lower_archer] = "FarmerAnchorBlue-stand01_00.png",
		[actor_profession.prof_lower_cavalier] = "FarmerCavalierBlue-stand01_00.png",
		[actor_profession.prof_lower_wisard] = "LowerMasterBlue-stand01_00.png",
		[actor_profession.prof_farmer] = "FarmerBlue-stand01_00.png",
		[actor_profession.prof_low_soldier] = "LowerSoldierBlue-stand01_00.png",
		[actor_profession.prof_infantryman] = "InfantrymanBlue-stand01_00.png",
		[actor_profession.prof_archer] = "AnchorBlue-stand01_00.png",
		[actor_profession.prof_cavalier] = "CavalierBlue-stand01_00.png",
		[actor_profession.prof_wisard] = "WitchBlue-stand01_00.png",
		[actor_profession.prof_thief] = "ThiefBlue-stand01_00.png",
		[actor_profession.prof_wisard_master] = "MasterBlue-stand_00.png",
		[actor_profession.prof_catapult] = "catapult-upgrade_37.png",
	},

	AIModeStrMap = 
	{
		[EPlayerAIType.PlayerAITypeNormal] = "中庸",
		[EPlayerAIType.PlayerAITypeFast] = "快攻",
		[EPlayerAIType.PlayerAITypeLateStageGod] = "后期大神",
		[EPlayerAIType.PlayerAITypeMaster] = "操作高手",
	},

	MIN_AI_SPEED = 0.1,
	MAX_AI_SPEED = 2,

	CreateSoldierTypeStrMap = 
	{
		["1"] = "我方组合",
		["2"] = "克制敌军",
		["3"] = "建筑目标",
		["4"] = "兵种序列",
	},

	BossDialogueBox = 
	{
		[actor_profession.prof_boss1] = "@Boss1Dialogue",
	},

	ProfessionChsMap = 
	{
		["1001"] = "@SoldierFarmerName",
		["1002"] = "@SoldierLowerSoldierName",
		["1003"] = "@SoldierInfrantryName",
		["1004"] = "@SoldierAnchorName",
		["1005"] = "@SoldierCavalierName",
		["1006"] = "@SoldierThiefName",
		["1007"] = "@SoldierWisardName",
		["1008"] = "@SoldierMasterWisardName",
		["1009"] = "",
		["1010"] = "",
		["1011"] = "",
		["1012"] = "",
		["1013"] = "@SoldierCatapultName",
	},
}

return ConstCfg