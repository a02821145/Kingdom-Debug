local Building = 
{
	id = building_type.enemy_main_building,
	type = actor_type.type_building,
	name = "@Building_Name_4001",
	desc = "@Building_Desc_4001",
	canBeOp = false,
	upID = 200002,
	team = actor_team.team_NPC,
	icon = "buliding_icon_4001.png",
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
			buildingName = "Castle",
			csb = "UI/buildings/Building4002.csb",
			sfPath = "UI/TextureUI/buildings.png",
			effect = 7004,
		},
		
		{
			name = "HealthComponent",
			maxHealth = 120,
			buildingDef = 5,
		},

		{
			name = "BuildingProperty",
		},
	},
}

return Building