local Building = 
{
	id = building_type.player_wooden_door,
	type = actor_type.type_building,
	name = "@Building_Name_4003",
	desc = "@Building_Desc_4003",
	canBeOp = true,
	upID = 200005,
	cost = 19,
	team = actor_team.team_player,
	icon = "buliding_icon_4005.png",
	displayCSB = "buildings/Building4005.csb",
	updateQuad = false,
	
	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth", upAdd = "healthAdd"},
		[2] = {com = "HealthComponent",icon = "pixekicon64_d6639.png",displayName = "@PropertyWallDef", upAdd = "def"},
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
			buildingName = "wooden gate",
			csb = "UI/buildings/Building4005.csb",
			sfPath = "UI/TextureUI/buildings.png",
			effect = 7004,
		},
		
		{
			name = "HealthComponent",
			maxHealth = 90,
			buildingDef = 1.5,
		},
	},
}

return Building