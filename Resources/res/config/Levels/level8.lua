local level = 
{
	level =  8,
	name = "level8",
	mapTmx = "maps/realLevelMap8.png",
	mapInfo = "maps/Level8.ini",
	prepareMusic = "prepareMusic1",
	BGMusic = "MusicAttack1",
	bonus = 230,

	weather = 
	{
		20001,
		20002,
		20003,
	},

	unLockList = 
	{
		{
			id=building_type.player_cannon_buliding,
			isBuilding = true,
		},

		{
			id=building_type.enemy_cannon_buliding,
			isBuilding = true,
		},
	},

	ugpradeList = 
	{
		{id = 1008,level = 5},
		{id = 1022,level = 4},
		{id = 1024,level = 3},
		{id = 1026,level = 2},
		{id = building_type.enemy_main_building,level = 5},
		{id = building_type.enemy_fence_building,level = 5},
		{id = building_type.enemy_long_canon_building,level = 5 },
		{id = building_type.enemy_wooden_wall,level = 5},
		{id = building_type.enemy_wooden_door,level = 5},
		{id = building_type.enemy_stone_wall,level = 5},
		{id = building_type.enemy_stone_door,level = 5 },
		{id = building_type.enemy_house,level =5 },
		{id = building_type.enemy_ware_house,level = 5},
		{id = building_type.enemy_church,level = 4},
		{id = building_type.enemy_arrow_tower,level = 5},
		{id = building_type.enemy_add_atk_building,level = 3 },
		{id = building_type.enemy_add_def_building,level = 5},
		{id = building_type.enemy_add_spd_buildnig,level = 5 },
		{id = building_type.enemy_add_shoot_building,level = 5 },
		{id = building_type.enemy_magic_tower,level = 2 },
	},

	forbidenList =
	{
		building_type.player_cannon_buliding,
		building_type.enemy_cannon_buliding,
	},
}

return level