local level = 
{
	level =  5,
	name = "level5",
	mapTmx = "maps/realLevelMap5.png",
	mapInfo = "maps/Level5.ini",
	prepareMusic = "prepareMusic1",
	BGMusic = "MusicAttack1",
	bonus = 150,

	weather = 
	{
		20003,
	},

	unLockList = 
	{
		{
			id=1021,
			isBuilding = false,
		},

		{
			id=1022,
			isBuilding = false,
		},
		{
			id=building_type.player_church,
			isBuilding = true,
		},

		{
			id=building_type.enemy_church,
			isBuilding = true,
		},
	},

	ugpradeList = 
	{
		{id = 1002,level = 4},
		{id = 1004,level = 4},
		{id = 1006,level = 3},
		{id = 1008,level = 2},
		{id = 1010,level = 4},
		{id = 1012,level = 4},
		{id = 1014,level = 4},
		{id = 1016,level = 4},
		{id = 1018,level = 4},
		{id = 1020,level = 3},
		{id = building_type.enemy_stone_door,level = 3},
		{id = building_type.enemy_arrow_tower,level = 2},
		{id = building_type.enemy_add_shoot_building,level = 3}
	},

	forbidenList =
	{
		1021,
		1022,
		1023,
		1024,
		1025,
		1026,
		building_type.player_church,
		building_type.enemy_church,
		building_type.player_add_atk_building,
		building_type.enemy_add_atk_building,
		building_type.player_cannon_buliding,
		building_type.enemy_cannon_buliding,
		building_type.player_magic_tower,
		building_type.enemy_magic_tower,
	},

	Tips = 
	{
		id = 100005,
		page = "IntroducePage5",
	},
}

return level