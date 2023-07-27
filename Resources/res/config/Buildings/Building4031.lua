local Building = 
{
	id = building_type.player_fence_building,
	type = actor_type.type_building,
	name = "@Building_Name_4016",
	desc = "@Building_Desc_4016",
	canBeOp = true,
	upID = 200031,
	cost = 1,
	createMultiple = true,
	team = actor_team.team_player,
	icon = "buliding_icon_4030.png",
	displayCSB = "buildings/Building4031.csb",
	updateQuad = false,
	
	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth", upAdd = "healthAdd"},
		[2] = {com = "HealthComponent",icon = "pixekicon64_d6639.png",displayName =  "@PropertyWallDef", upAdd = "def",vName = "buildingDef"},
	},

	components = 
	{
		{
			name = "ShapeComponent",
			shapeType = actor_shape_type.shape_type_rect,
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
			buildingName = "fence",
			csb = "UI/buildings/Building4031.csb",
			sfPath = "UI/TextureUI/buildings.png",
			effect = 7004,
			checkBoard = false,
			needUpdate = false,
		},
		
		{
			name = "HealthComponent",
			maxHealth = 25,
			buildingDef = 0.5,
		},
	},
}

return Building