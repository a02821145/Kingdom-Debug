local level = 
{
	level =  4,
	name = "level4",
	mapTmx = "maps/realLevelMap4.png",
	mapInfo = "maps/Level4.ini",
	prepareMusic = "prepareMusic1",
	BGMusic = "MusicAttack1",
	bonus = 150,

	weather = 
	{
		20002,
	},

	unLockList = 
	{
		{
			id=1007,
			isBuilding = false,
		},

		{
			id=1008,
			isBuilding = false,
		},

		{
			id=building_type.player_arrow_tower,
			isBuilding = true,
		},

		{
			id=building_type.enemy_arrow_tower,
			isBuilding = true,
		},
	},

	ugpradeList = 
	{
		{id = 1006,level = 2},
		{id = building_type.enemy_main_building,level = 3},
		{id = building_type.enemy_fence_building,level = 3},
		{id = building_type.enemy_long_canon_building,level = 3 },
		{id = building_type.enemy_wooden_wall,level = 3},
		{id = building_type.enemy_wooden_door,level = 3},
		{id = building_type.enemy_stone_wall,level = 3},
		{id = building_type.enemy_stone_door,level = 2 },
		{id = building_type.enemy_house,level =3 },
		{id = building_type.enemy_ware_house,level = 3},
		{id = building_type.enemy_add_def_building,level = 3},
		{id = building_type.enemy_add_spd_buildnig,level = 3 },
		{id = building_type.enemy_add_shoot_building,level = 2 },
	},

	forbidenList =
	{
		1007,
		1008,
		1021,
		1022,
		1023,
		1024,
		1025,
		1026,
		building_type.player_church,
		building_type.enemy_church,
		building_type.player_arrow_tower,
		building_type.enemy_arrow_tower,
		building_type.player_add_atk_building,
		building_type.enemy_add_atk_building,
		building_type.player_cannon_buliding,
		building_type.enemy_cannon_buliding,
		building_type.player_magic_tower,
		building_type.enemy_magic_tower,
	},

	Tips = 
	{
		id = 100004,
		page = "IntroducePage4",
	},
}

return level