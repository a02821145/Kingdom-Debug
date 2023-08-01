local level = 
{
	level =  1,
	name = "level1",
	mapTmx = "maps/realLevelMap1.png",
	mapInfo = "maps/Level1.ini",
	prepareMusic = "prepareMusic1",
	BGMusic = "MusicAttack1",
	bonus = 80,
	diamond = 40,
	newbieId = 10000001,
	difficulty = level_difficulty.level_difficulty_easy,

	unLockList = 
	{
		{
			id=1017,
			isBuilding = false,
		},

		{
			id=1018,
			isBuilding = false,
		},

		{
			id=building_type.player_long_cannon_building,
			isBuilding = true,
		},

		{
			id=building_type.enemy_long_canon_building,
			isBuilding = true,
		},

		{
			id=building_type.enemy_add_def_building,
			isBuilding = true,
		},

		{
			id=building_type.player_add_def_building,
			isBuilding = true,
		},
	},

	ugpradeList = 
	{
		{id = 1002,level = 2},
		{id = 1004,level = 2},
		{id = 1010,level = 2},
		{id = 1012,level = 2},
		{id = 1014,level = 2},
		{id = 1016,level = 2},
	},

	forbidenList =
	{
		1005,
		1006,
		1007,
		1008,
		1017,
		1018,
		1019,
		1020,
		1021,
		1022,
		1023,
		1024,
		1025,
		1026,
		building_type.player_long_cannon_building,
		building_type.enemy_long_canon_building,
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
		building_type.player_add_def_building,
		building_type.enemy_add_def_building,
		building_type.player_add_spd_buildnig,
		building_type.enemy_add_spd_buildnig,
		building_type.player_add_shoot_building,
		building_type.enemy_add_shoot_building,
		building_type.player_cannon_buliding,
		building_type.enemy_cannon_buliding,
		building_type.player_magic_tower,
		building_type.enemy_magic_tower,
	},

	hardFofbidUse = 
	{
		1013
	},
	
	--newbieTaskId = 10000002,
}

return level