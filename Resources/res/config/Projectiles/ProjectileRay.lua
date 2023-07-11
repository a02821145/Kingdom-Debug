local ProjectileRay = 
{
	id = 2018,
	type = projectile_type.projectile_type_ray,
	name = "ProjectileRay",

	components = 
	{
		{
			name = "MoveComponent",
			radius = 0.8,
			scale = 0.8,
			mass = 0.1,
			maxSpeed = 5000,
			maxForce  = 1000,
		},

		{
			name = "TeamComponent",
		},
		
		{
			name = "DamageRayComponent",
			damage = 18,
			RayEffect = 7010,
			maxRayLen = 360,
		},

		{
			name = "MoveRayComponent",
			persistance = 0.1,
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
					7041,
					7042,
				}
			},
		}
	}
}

return ProjectileRay