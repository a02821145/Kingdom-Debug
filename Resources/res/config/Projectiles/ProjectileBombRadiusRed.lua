local ProjectileBombRadiusRed = 
{
	id = 20141,
	type = projectile_type.projectile_type_bomb_radius,
	name = "ProjectileBombRadiusRed",
	
	sounds =
	{
		fire = 
		{
			"Sound_Magic_rain",
		},
	},

	components = 
	{
		{
			name = "TeamComponent",
		},
		
		{
			name = "MoveComponent",
			radius = 0.8,
			scale = 0.8,
			mass = 0.1,
			maxSpeed = 0,
			maxForce  = 0,
		},

		{
			name = "DamageBombRadiusComponent",
			damage = 10,
			blastRadius = 50,
			effect = 70021,
			frameIndex = 15,
		},

		{
			name = "StatusComponent",
		},

		{
			name = "ProjectileProperty",

			popWords = 
			{
				ratio = 10,
				delay = 1,
				ids = 
				{
					7040,
				}
			},
		}
	}

}

return ProjectileBombRadiusRed