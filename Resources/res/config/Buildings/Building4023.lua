local Building = 
{
	id = building_type.player_add_spd_buildnig,
	type = actor_type.type_building,
	name = "@Building_Name_4012",
	desc = "@Building_Desc_4012",
	canBeOp = true,
	upID = 200023,
	cost = 70,
	team = actor_team.team_player,
	icon = "buliding_icon_4023.png",
	displayCSB = "buildings/Building4023.csb",
	FogViewSize = 300,
	updateQuad = false,
	
	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth", upAdd = "healthAdd"},
		[2] = {com = "HealthComponent",icon = "pixekicon64_d6639.png",displayName =  "@PropertyWallDef", upAdd = "def"},
		[3] = {com = "BuildingProperty",icon = "d2344pixelicon64_addDef.png",displayName =  "@PropertyADD", upAdd = "addValue",isRatio = true},
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
		},
		
		{
			name = "StatusComponent",
		},

		{
			name = "BuildingComponent",
			buildingName = "horse workshop",
			csb = "UI/buildings/Building4023.csb",
			sfPath = "UI/TextureUI/buildings.png",
			effect = 7004,
			countStar = true,
		},
		
		{
			name = "HealthComponent",
			maxHealth = 70,
			buildingDef = 1,
		},
	},
}

return Building