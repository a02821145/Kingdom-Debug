local level = 
{
	level =  7,
	name = "level7",
	mapTmx = "maps/realLevelMap7.png",
	mapInfo = "maps/Level7.ini",
	prepareMusic = "prepareMusic1",
	BGMusic = "MusicAttack1",
	bonus = 210,

	weather = 
	{
		20001,
		20002,
		20003,
	},

	unLockList = 
	{

		{
			id=1025,
			isBuilding = false,
		},

		{
			id=1026,
			isBuilding = false,
		},

		{
			id=building_type.player_magic_tower,
			isBuilding = true,
		},

		{
			id=building_type.enemy_magic_tower,
			isBuilding = true,
		},
	},

	ugpradeList = 
	{
		{id = 1002,level = 5},
		{id = 1004,level = 5},
		{id = 1006,level = 5},
		{id = 1008,level = 4},
		{id = 1010,level = 5},
		{id = 1012,level = 5},
		{id = 1014,level = 5},
		{id = 1016,level = 5},
		{id = 1018,level = 5},
		{id = 1020,level = 5},
		{id = 1022,level = 3},
		{id = 1024,level = 2},
		{id = building_type.enemy_church,level = 3},
		{id = building_type.enemy_arrow_tower,level = 4 },
		{id = building_type.enemy_add_atk_building,level = 2 },
	},

	forbidenList =
	{
		1025,
		1026,
		building_type.player_cannon_buliding,
		building_type.enemy_cannon_buliding,
		building_type.player_magic_tower,
		building_type.enemy_magic_tower,
	},
}

return level