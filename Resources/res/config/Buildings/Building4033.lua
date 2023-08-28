local Building = 
{
	id = building_type.player_long_cannon_building,
	type = actor_type.type_building,
	name = "@Building_Name_4017",
	desc = "@Building_Desc_4017",
	canBeOp = false,
	upID = 200033,
	team = actor_team.team_player,
	icon = "buliding_icon_4033.png",
	displayCSB = "buildings/Building4033Display.csb",
	FogViewSize = 300,
	updateQuad = false,
	
	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth", upAdd = "healthAdd"},
		[2] = {com = "HealthComponent",icon = "pixekicon64_d6639.png",displayName =  "@PropertyWallDef", upAdd = "def"},
		[3] = {com = "WeaponSysComponent",icon = "pixekicon64_d2718.png",displayName =  "@PropertyAttack",upAdd = "atk"},
		[4] = {com = "WeaponSysComponent",icon = "pixelicon64_CD.png",displayName =  "@PropertyCDTime",upAdd = "addValue"},
	
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
 			name = "BuildingProperty",
 			CDTime = 50,
		},

		{
 			name = "LongCannonBuildingProperty",
 			CDTime = 50,
		},

		{
			name = "StatusComponent",
		},

		{
			name = "BuildingComponent",
			buildingName = "Cannon Tower",
			csb = "UI/buildings/Building4033.csb",
			effect = 7004,
			sfPath = "UI/TextureUI/buildings.png",
			attachSCB = "InGame/BuildingCannon.csb",
		},
		
		{
			name = "HealthComponent",
			maxHealth = 80,
			buildingDef = 2,
		},

		{
			name = "WeaponSysComponent",
			AimAccuracy = 0.0,
			regulator = 4,
			canUpdate = false,
			weapons = 
			{
				3020,
			}
		},
	},
}

return Building