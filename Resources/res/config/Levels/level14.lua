local level = 
{
	level =  14,
	name = "level14",
	mapTmx = "maps/realLevelMap14.png",
	mapInfo = "maps/Level14.ini",
	prepareMusic = "prepareMusic1",
	BGMusic = "MusicAttack1",
	bonus = 310,

	weather = 
	{
		20001,
		20002,
		20003,
	},

	ugpradeList = 
	{
		{id = 1026,level = 8},

		{id = building_type.enemy_main_building,level = 8},
		{id = building_type.enemy_fence_building,level = 8},
		{id = building_type.enemy_long_canon_building,level = 8 },
		{id = building_type.enemy_wooden_wall,level = 8},
		{id = building_type.enemy_wooden_door,level = 8},
		{id = building_type.enemy_stone_wall,level = 8},
		{id = building_type.enemy_stone_door,level = 8 },
		{id = building_type.enemy_house,level =8 },
		{id = building_type.enemy_ware_house,level = 8},
		{id = building_type.enemy_church,level = 8},
		{id = building_type.enemy_arrow_tower,level = 8},
		{id = building_type.enemy_add_atk_building,level = 8 },
		{id = building_type.enemy_add_def_building,level = 8},
		{id = building_type.enemy_add_spd_buildnig,level = 8 },
		{id = building_type.enemy_add_shoot_building,level = 8 },
		{id = building_type.enemy_magic_tower,level = 8 },
		{id = building_type.enemy_cannon_buliding,level = 7 },
	},
}

return level