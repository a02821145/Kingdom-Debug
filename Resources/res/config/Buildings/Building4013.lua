local Building = 
{
	id = building_type.player_church,
	type = actor_type.type_building,
	name = "@Building_Name_4007",
	desc = "@Building_Desc_4007",
	canBeOp = false,
	upID = 200013,
	team = actor_team.team_player,
	icon = "buliding_icon_4013.png",
	displayCSB = "buildings/Building4013.csb",
	FogViewSize = 200,
	updateQuad = false,
	
	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth", upAdd = "healthAdd"},
		[2] = {com = "HealthComponent",icon = "pixekicon64_d6639.png",displayName =  "@PropertyWallDef", upAdd = "def"},
		[3] = {com = "BuildingProperty",icon = "pixekicon64_WallDef.png",displayName =  "@PropertyADD", upAdd = "addValue",isRatio = true},
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
			buildingName = "church",
			csb = "UI/buildings/Building4013.csb",
			sfPath = "UI/TextureUI/buildings.png",
			effect = 7004,
			countStar = true,
		},
		
		{
			name = "HealthComponent",
			maxHealth = 50,
			buildingDef = 2,
		},

		{
			name = "BuildingProperty",
		},
	},
}

return Building