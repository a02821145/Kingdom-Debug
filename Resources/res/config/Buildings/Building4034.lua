local Building = 
{
	id = building_type.enemy_long_canon_building,
	type = actor_type.type_building,
	name = "@Building_Name_4017",
	desc = "@Building_Desc_4017",
	canBeOp = false,
	upID = 200034,
	team = actor_team.team_NPC,
	icon = "buliding_icon_4033.png",
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
 			name = "LongCannonBuildingProperty",
 			CDTime = 50,
		},

		{
			name = "StatusComponent",
		},

		{
			name = "BuildingComponent",
			buildingName = "Cannon Tower",
			csb = "UI/buildings/Building4034.csb",
			sfPath = "UI/TextureUI/buildings.png",
			effect = 7004,
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