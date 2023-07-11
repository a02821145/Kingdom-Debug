local Building = 
{
	id = building_type.enemy_cannon_buliding,
	type = actor_type.type_building,
	name = "@Building_Name_4014",
	desc = "@Building_Desc_4014",
	canBeOp = false,
	upID = 200028,
	cost = 38,
	team = actor_team.team_NPC,
	icon = "buliding_icon_4027.png",
	updateQuad = false,
	
	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth", upAdd = "healthAdd"},
		[2] = {com = "HealthComponent",icon = "pixekicon64_d6639.png",displayName =  "@PropertyWallDef", upAdd = "def"},
	},
	
	sounds = 
	{
		die = 
		{
			"Sound_Build_explode1",
			"Sound_Build_explode2",
		},
	},

	components = 
	{
		{
			name = "ShapeComponent",
			shapeType = actor_shape_type.shape_type_rect
		},

		{
			name = "TeamComponent",
			team = actor_team.team_NPC,
		},

		{
			name = "StatusComponent",
		},

		{
			name = "BuildingComponent",
			buildingName = "Turret",
			csb = "UI/buildings/Building4028.csb",
			sfPath = "UI/TextureUI/buildings.png",
			effect = 7004,
			attachSCB = "InGame/PaoShouRed.csb",
		},
		
		{
			name = "HealthComponent",
			maxHealth = 100,
			buildingDef = 4,
		},

		{
			name = "MemoryComponent",
			ViewDistance = 380,
			regulator = 2,
			memorySpan = 10,
			ignoreSpan = 2,
		},

		{
			name = "TargetSysComponent",
			regulator = 5
		},
		{
			name = "WeaponSysComponent",
			AimAccuracy = 0.0,
			regulator = 2,
			weapons = 
			{
				3017,
			}
		},
	},
}

return Building