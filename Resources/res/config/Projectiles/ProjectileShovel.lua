local ProjectileShovel = 
{
	id = 2005,
	type = projectile_type.projectile_type_segment,
	name = "ProjectileShovel",
	
	sounds =
	{
		fire = 
		{
			"Samurai Sword 3",
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
			damage = 2,
			persistance = 0.1,
		},

		{
			name = "StatusComponent",
		},
	}
}

return ProjectileShovel