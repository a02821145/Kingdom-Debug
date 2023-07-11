local level = 
{
	level =  3,
	name = "level3",
	mapTmx = "maps/realLevelMap3.png",
	mapInfo = "maps/Level3.ini",
	prepareMusic = "prepareMusic1",
	BGMusic = "MusicAttack1",
	bonus = 120,

	weather = 
	{
		20002,
	},

	unLockList = 
	{
		{
			id=1005,
			isBuilding = false,
		},

		{
			id=1006,
			isBuilding = false,
		},

		{
			id=building_type.player_stone_door,
			isBuilding = true,
		},

		{
			id=building_type.enemy_stone_door,
			isBuilding = true,
		},

		{
			id=building_type.player_add_shoot_building,
			isBuilding = true,
		},

		{
			id=building_type.enemy_add_shoot_building,
			isBuilding = true,
		},
	},

	ugpradeList = 
	{
		{id = 1002,level = 3},
		{id = 1004,level = 3},
		{id = 1010,level = 3},
		{id = 1012,level = 3},
		{id = 1014,level = 3},
		{id = 1016,level = 3},
		{id = 1018,level = 3},
		{id = 1020,level = 2},
		{id = building_type.enemy_stone_wall,level = 2},
		{id = building_type.enemy_add_spd_buildnig,level = 2},
	},

	forbidenList =
	{
		1005,
		1006,
		1007,
		1008,
		1021,
		1022,
		1023,
		1024,
		1025,
		1026,
		building_type.player_stone_door,
		building_type.enemy_stone_door,
		building_type.player_church ,
		building_type.enemy_church,
		building_type.player_arrow_tower,
		building_type.enemy_arrow_tower,
		building_type.player_add_atk_building,
		building_type.enemy_add_atk_building,
		building_type.player_add_shoot_building,
		building_type.enemy_add_shoot_building,
		building_type.player_cannon_buliding,
		building_type.enemy_cannon_buliding,
		building_type.player_magic_tower,
		building_type.enemy_magic_tower,
	},
}

return level