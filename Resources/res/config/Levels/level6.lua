local level = 
{
	level =  6,
	name = "level6",
	mapTmx = "maps/realLevelMap6.png",
	mapInfo = "maps/Level6.ini",
	prepareMusic = "prepareMusic1",
	BGMusic = "MusicAttack1",
	bonus = 180,

	weather = 
	{
		20001,
		20002,
		20003,
	},

	unLockList = 
	{
		{
			id=1023,
			isBuilding = false,
		},

		{
			id=1024,
			isBuilding = false,
		},

		{
			id=building_type.player_add_atk_building,
			isBuilding = true,
		},

		{
			id=building_type.enemy_add_atk_building,
			isBuilding = true,
		},
	},

	ugpradeList = 
	{
		{id = 1006,level = 4},
		{id = 1008,level = 3},
		{id = 1020,level = 4},
		{id = 1022,level = 2},
		{id = building_type.enemy_main_building,level = 4},
		{id = building_type.enemy_fence_building,level = 4},
		{id = building_type.enemy_long_canon_building,level = 4 },
		{id = building_type.enemy_wooden_wall,level = 4},
		{id = building_type.enemy_wooden_door,level = 4},
		{id = building_type.enemy_stone_wall,level = 4},
		{id = building_type.enemy_stone_door,level = 4 },
		{id = building_type.enemy_house,level =4 },
		{id = building_type.enemy_ware_house,level = 4},
		{id = building_type.enemy_church,level = 2},
		{id = building_type.enemy_arrow_tower,level = 3},
		{id = building_type.enemy_add_def_building,level = 4},
		{id = building_type.enemy_add_spd_buildnig,level = 4 },
		{id = building_type.enemy_add_shoot_building,level = 4 },
	},

	forbidenList =
	{
		1023,
		1024,
		1025,
		1026,
		building_type.player_add_atk_building,
		building_type.enemy_add_atk_building,
		building_type.player_cannon_buliding,
		building_type.enemy_cannon_buliding,
		building_type.player_magic_tower,
		building_type.enemy_magic_tower,
	},

	Tips = 
	{
		id = 100002,
		page = "IntroducePage2",
	},
}

return level