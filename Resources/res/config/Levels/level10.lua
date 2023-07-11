local level = 
{
	level =  10,
	name = "level10",
	mapTmx = "maps/realLevelMap10.png",
	mapInfo = "maps/Level10.ini",
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
		{id = 1022,level = 6},
		{id = 1024,level = 5},
		{id = 1026,level = 4},

		{id = building_type.enemy_main_building,level = 6},
		{id = building_type.enemy_fence_building,level = 6},
		{id = building_type.enemy_long_canon_building,level = 6 },
		{id = building_type.enemy_wooden_wall,level = 6},
		{id = building_type.enemy_wooden_door,level = 6},
		{id = building_type.enemy_stone_wall,level = 6},
		{id = building_type.enemy_stone_door,level = 6 },
		{id = building_type.enemy_house,level =6 },
		{id = building_type.enemy_ware_house,level = 6},
		{id = building_type.enemy_church,level = 6},
		{id = building_type.enemy_arrow_tower,level = 6},
		{id = building_type.enemy_add_atk_building,level = 5 },
		{id = building_type.enemy_add_def_building,level = 6},
		{id = building_type.enemy_add_spd_buildnig,level = 6 },
		{id = building_type.enemy_add_shoot_building,level = 6 },
		{id = building_type.enemy_magic_tower,level = 4 },
		{id = building_type.enemy_cannon_buliding,level = 3 },
	}
}

return level