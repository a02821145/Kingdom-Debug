local level = 
{
	level =  12,
	name = "level12",
	mapTmx = "maps/realLevelMap12.png",
	mapInfo = "maps/Level12.ini",
	prepareMusic = "prepareMusic1",
	BGMusic = "MusicAttack1",
	bonus = 290,

	weather = 
	{
		20001,
		20002,
		20003,
	},

	ugpradeList = 
	{
		{id = 1024,level = 7},
		{id = 1026,level = 6},

		{id = building_type.enemy_main_building,level = 7},
		{id = building_type.enemy_fence_building,level = 7},
		{id = building_type.enemy_long_canon_building,level = 7 },
		{id = building_type.enemy_wooden_wall,level = 7},
		{id = building_type.enemy_wooden_door,level = 7},
		{id = building_type.enemy_stone_wall,level = 7},
		{id = building_type.enemy_stone_door,level = 7 },
		{id = building_type.enemy_house,level =7 },
		{id = building_type.enemy_ware_house,level = 7},
		{id = building_type.enemy_church,level = 7},
		{id = building_type.enemy_arrow_tower,level = 7},
		{id = building_type.enemy_add_atk_building,level = 7 },
		{id = building_type.enemy_add_def_building,level = 7},
		{id = building_type.enemy_add_spd_buildnig,level = 7 },
		{id = building_type.enemy_add_shoot_building,level = 7 },
		{id = building_type.enemy_magic_tower,level = 6 },
		{id = building_type.enemy_cannon_buliding,level = 5 },
	},

	Tips = 
	{
		id = 100006,
		page = "IntroducePage6",
	},
}

return level