local level = 
{
	level =  11,
	name = "level11",
	mapTmx = "maps/realLevelMap11.png",
	mapInfo = "maps/Level11.ini",
	prepareMusic = "prepareMusic1",
	BGMusic = "MusicAttack1",
	bonus = 270,

	weather = 
	{
		20001,
		20002,
		20003,
	},

	ugpradeList = 
	{
		{id = 1002,level = 7},
		{id = 1004,level = 7},
		{id = 1006,level = 7},
		{id = 1008,level = 7},
		{id = 1010,level = 7},
		{id = 1012,level = 7},
		{id = 1014,level = 7},
		{id = 1016,level = 7},
		{id = 1018,level = 7},
		{id = 1020,level = 7},
		{id = 1022,level = 7},
		{id = 1024,level = 6},
		{id = 1026,level = 5},
		{id = building_type.enemy_add_atk_building,level = 6 },
		{id = building_type.enemy_magic_tower,level = 5 },
		{id = building_type.enemy_cannon_buliding,level = 4 },
	},
}

return level