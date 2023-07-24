local ProjectileBuildingCannon = 
{
	id = 2020,
	type = projectile_type.projectile_type_buliding_cannon,
	name = "ProjectileBuildingCannon",
	
	sounds =
	{
		fire = 
		{
			"Sound_RocketLaunt",
		},

		die = 
		{
			"Sound_Bomb1"
		},
	},

	components = 
	{
		{
			name = "MoveComponent",
			mass = 1,
			maxSpeed = 500,
			maxForce  = 50,
		},

		{
			name = "TeamComponent",
		},
		
		{
			name = "DamageCurveComponent",
			blastRadius = 100,
			length = 3,
			damage = 15,
			curRatio = 0.5,
			effect = 7026,
		},

		{
			name = "StatusComponent",
		},


		{
			name = "MoveCsbComponent",
			path = "UI/InGame/buildingCannonBlue.csb",
			path_red = "UI/InGame/buildingCannonRed.csb",
			batchPath = "UI/TextureUI/Projectiles.png",
			layer = ESpriteLayer.layerProjectile,
		},



		{
			name = "ProjectileProperty",

			popWords = 
			{
				ratio = 30,
				delay = 1,
				ids = 
				{
					7027,
					7028
				}
			},
		}
	}

}

return ProjectileBuildingCannon