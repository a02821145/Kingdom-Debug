local Building = 
{
	id = building_type.player_ware_house,
	type = actor_type.type_building,
	name = "@Building_Name_4009",
	desc = "@Building_Desc_4009",
	canBeOp = false,
	upID = 200017,
	team = actor_team.team_player,
	icon = "buliding_icon_4017.png",
	displayCSB = "buildings/Building4017.csb",
	FogViewSize = 300,
	updateQuad = false,
	
	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth", upAdd = "healthAdd"},
		[2] = {com = "HealthComponent",icon = "pixekicon64_d6639.png",displayName =  "@PropertyWallDef", upAdd = "def"},
		[3] = {com = "BuildingProperty",icon = "pixelicon64_ware.png",displayName =  "@PropertyStorage", upAdd = "addValue"},
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
			buildingName = "ware house",
			csb = "UI/buildings/Building4017.csb",
			sfPath = "UI/TextureUI/buildings.png",
			effect = 7004,
		},
		
		{
			name = "HealthComponent",
			maxHealth = 60,
			buildingDef = 1,
		},

		{
			name = "BuildingProperty",
		},
	},
}

return Building