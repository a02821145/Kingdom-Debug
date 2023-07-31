local level = 
{
	level =  2,
	name = "level2",
	mapTmx = "maps/realLevelMap2.png",
	mapInfo = "maps/Level2.ini",
	prepareMusic = "prepareMusic1",
	BGMusic = "MusicAttack1",
	bonus = 100,

	unLockList = 
	{
		{
			id=1019,
			isBuilding = false,
		},

		{
			id=1020,
			isBuilding = false,
		},


		{
			id=building_type.player_stone_wall,
			isBuilding = true,
		},

		{
			id=building_type.enemy_stone_wall,
			isBuilding = true,
		},

		{
			id=building_type.player_add_spd_buildnig,
			isBuilding = true,
		},

		{
			id=building_type.enemy_add_spd_buildnig,
			isBuilding = true,
		},
	},

	ugpradeList = 
	{
		{id = 1018,level = 2},
		{id = building_type.enemy_main_building,level = 2},
		{id = building_type.enemy_fence_building,level = 2},
		{id = building_type.enemy_long_canon_building,level = 2},
		{id = building_type.enemy_wooden_wall,level = 2},
		{id = building_type.enemy_wooden_door,level = 2},
		{id = building_type.enemy_house,level = 2},
		{id = building_type.enemy_ware_house,level = 2},
		{id = building_type.enemy_add_def_building,level = 2},
	},

	forbidenList =
	{
		1005,
		1006,
		1007,
		1008,
		1019,
		1020,
		1021,
		1022,
		1023,
		1024,
		1025,
		1026,
		building_type.player_stone_wall,
		building_type.enemy_stone_wall,
		building_type.player_stone_door,
		building_type.enemy_stone_door,
		building_type.player_church ,
		building_type.enemy_church,
		building_type.player_arrow_tower,
		building_type.enemy_arrow_tower,
		building_type.player_add_atk_building,
		building_type.enemy_add_atk_building,
		building_type.player_add_spd_buildnig,
		building_type.enemy_add_spd_buildnig,
		building_type.player_add_shoot_building,
		building_type.enemy_add_shoot_building,
		building_type.player_cannon_buliding,
		building_type.enemy_cannon_buliding,
		building_type.player_magic_tower,
		building_type.enemy_magic_tower,
	},

	Tips = 
	{
		id = 100001,
		page = "IntroducePage1",
	},


	hardUseFog = true,
}

return level