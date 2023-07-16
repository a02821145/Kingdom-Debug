local Building = 
{
	id = building_type.enemy_wooden_door,
	type = actor_type.type_building,
	name = "@Building_Name_4003",
	desc = "@Building_Desc_4003",
	canBeOp = false,
	upID = 200006,
	cost = 19,
	team = actor_team.team_NPC,
	icon = "buliding_icon_4005.png",
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
			buildingName = "wooden gate",
			csb = "UI/buildings/Building4006.csb",
			sfPath = "UI/TextureUI/buildings.png",
			effect = 7004,
			standLevel = 1,
		},
		
		{
			name = "HealthComponent",
			maxHealth = 90,
			buildingDef = 1.5,
		},
	},
}

return Building