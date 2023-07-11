local level = 
{
	level =  18,
	name = "level18",
	mapTmx = "maps/realLevelMap18.png",
	mapInfo = "maps/Level18.ini",
	prepareMusic = "prepareMusic1",
	BGMusic = "MusicAttack1",
	bonus = 370,

	weather = 
	{
		20001,
		20002,
		20003,
	},

	ugpradeList = 
	{
		{id = building_type.enemy_main_building,level = 10},
		{id = building_type.enemy_fence_building,level = 10},
		{id = building_type.enemy_long_canon_building,level = 10 },
		{id = building_type.enemy_wooden_wall,level = 10},
		{id = building_type.enemy_wooden_door,level = 10},
		{id = building_type.enemy_stone_wall,level = 10},
		{id = building_type.enemy_stone_door,level = 10 },
		{id = building_type.enemy_house,level =10 },
		{id = building_type.enemy_ware_house,level = 10},
		{id = building_type.enemy_church,level = 10},
		{id = building_type.enemy_arrow_tower,level = 10},
		{id = building_type.enemy_add_atk_building,level = 10 },
		{id = building_type.enemy_add_def_building,level = 10 },
		{id = building_type.enemy_add_spd_buildnig,level = 10 },
		{id = building_type.enemy_add_shoot_building,level = 10 },
		{id = building_type.enemy_magic_tower,level = 10 },
		{id = building_type.enemy_cannon_buliding,level = 10 },
	},
}

return level