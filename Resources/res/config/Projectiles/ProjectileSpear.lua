local ProjectileSpear = 
{
	id = 2011,
	type = projectile_type.projectile_type_segment,
	name = "ProjectileSpear",
	
	sounds =
	{
		fire = 
		{
			"Samurai Sword 1",
			"Samurai Sword 2",
			"Samurai Sword 3",
			"Samurai Sword 4",
		},
	},

	components = 
	{
		{
			name = "MoveComponent",
			radius = 0.8,
			scale = 0.8,
			mass = 0.1,
			maxSpeed = 0,
			maxForce  = 0,
		},

		{
			name = "TeamComponent",
		},
		
		{
			name = "DamageSegmentComponent",
			damage = 10,
			persistance = 0.2,
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
					7030,
					7031,
				}
			},
		}
	}
}

return ProjectileSpear