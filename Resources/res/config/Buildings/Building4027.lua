local Building = 
{
	id = building_type.player_cannon_buliding,
	type = actor_type.type_building,
	name = "@Building_Name_4014",
	desc = "@Building_Desc_4014",
	canBeOp = true,
	upID = 200027,
	cost = 38,
	team = actor_team.team_player,
	icon = "buliding_icon_4027.png",
	displayCSB = "buildings/Building4027Display.csb",
	FogViewSize = 300,
	updateQuad = false,
	
	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth", upAdd = "healthAdd"},
		[2] = {com = "HealthComponent",icon = "pixekicon64_d6639.png",displayName =  "@PropertyWallDef", upAdd = "def"},
		[3] = {com = "WeaponSysComponent",icon = "d2700pixelicon64_19.png",displayName =  "@PropertyAttack",upAdd = "atk"},
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
			buildingName = "Turret",
			csb = "UI/buildings/Building4027.csb",
			sfPath = "UI/TextureUI/buildings.png",
			effect = 7004,
			attachSCB = "InGame/PaoShouBlue.csb",
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