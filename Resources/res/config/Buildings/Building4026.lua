local Building = 
{
	id = building_type.enemy_add_shoot_building,
	type = actor_type.type_building,
	name = "@Building_Name_4013",
	desc = "@Building_Desc_4013",
	canBeOp = false,
	upID = 200026,
	team = actor_team.team_NPC,
	icon = "buliding_icon_4025.png",
	updateQuad = false,
	
	
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
			buildingName = "arrow workshop",
			csb = "UI/buildings/Building4026.csb",
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