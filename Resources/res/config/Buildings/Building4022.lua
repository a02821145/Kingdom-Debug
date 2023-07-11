local Building = 
{
	id = building_type.enemy_add_def_building,
	type = actor_type.type_building,
	name = "@Building_Name_4011",
	desc = "@Building_Desc_4011",
	canBeOp = false,
	upID = 200022,
	team = actor_team.team_NPC,
	icon = "buliding_icon_4021.png",
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
 			name = "BuildingProperty",
		},
		
		{
			name = "StatusComponent",
		},

		{
			name = "BuildingComponent",
			buildingName = "shield workshop",
			csb = "UI/buildings/Building4022.csb",
			sfPath = "UI/TextureUI/buildings.png",
			effect = 7004,
		},
		
		{
			name = "HealthComponent",
			maxHealth = 70,
			buildingDef = 1,
		},
	},
}

return Building