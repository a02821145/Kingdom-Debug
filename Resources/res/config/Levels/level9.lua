local level = 
{
	level =  9,
	name = "level9",
	mapTmx = "maps/realLevelMap9.png",
	mapInfo = "maps/Level9.ini",
	prepareMusic = "prepareMusic1",
	BGMusic = "MusicAttack1",
	bonus = 250,

	weather = 
	{
		20001,
		20002,
		20003,
	},

	ugpradeList = 
	{
		{id = 1002,level = 6},
		{id = 1004,level = 6},
		{id = 1006,level = 6},
		{id = 1008,level = 6},
		{id = 1010,level = 6},
		{id = 1012,level = 6},
		{id = 1014,level = 6},
		{id = 1016,level = 6},
		{id = 1018,level = 6},
		{id = 1020,level = 6},
		{id = 1022,level = 5},
		{id = 1024,level = 4},
		{id = 1026,level = 3},
		{id = building_type.enemy_church,level = 5},
		{id = building_type.enemy_add_atk_building,level = 4},
		{id = building_type.enemy_magic_tower,level = 3},
		{id = building_type.enemy_cannon_buliding,level = 2},
	},
}

return level