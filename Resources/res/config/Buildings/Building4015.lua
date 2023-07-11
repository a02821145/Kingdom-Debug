local Building = 
{
	id = building_type.player_arrow_tower,
	type = actor_type.type_building,
	name = "@Building_Name_4008",
	desc = "@Building_Desc_4008",
	canBeOp = true,
	upID = 200015,
	cost = 30,
	team = actor_team.team_player,
	icon = "buliding_icon_4015.png",
	displayCSB = "buildings/Building4015Display.csb",
	updateQuad = false,
	
	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth", upAdd = "healthAdd"},
		[2] = {com = "HealthComponent",icon = "pixekicon64_d6639.png",displayName =  "@PropertyWallDef", upAdd = "def"},
		[3] = {com = "WeaponSysComponent",icon = "pixekicon64_d2546.png",displayName =  "@PropertyAttack",upAdd = "atk"},
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
			team = actor_team.team_player,
		},

		{
			name = "StatusComponent",
		},

		{
			name = "BuildingComponent",
			buildingName = "Arrow Tower",
			csb = "UI/buildings/Building4015.csb",
			effect = 7004,
			sfPath = "UI/TextureUI/buildings.png",
			attachSCB = "InGame/ballista.csb",
		},
		
		{
			name = "HealthComponent",
			maxHealth = 80,
			buildingDef = 3,
		},

		{
			name = "MemoryComponent",
			ViewDistance = 350,
			regulator = 2,
			memorySpan = 5,
			ignoreSpan = 2,
		},

		{
			name = "TargetSysComponent",
			regulator = 5
		},
		{
			name = "WeaponSysComponent",
			AimAccuracy = 0.0,
			regulator = 4,
			weapons = 
			{
				3016,
			}
		},
	},
}

return Building