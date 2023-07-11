local Building = 
{
	id = building_type.enemy_arrow_tower,
	type = actor_type.type_building,
	name = "@Building_Name_4008",
	desc = "@Building_Desc_4008",
	canBeOp = false,
	upID = 200016,
	cost = 30,
	team = actor_team.team_NPC,
	icon = "buliding_icon_4015.png",
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
			buildingName = "Arrow Tower",
			csb = "UI/buildings/Building4016.csb",
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