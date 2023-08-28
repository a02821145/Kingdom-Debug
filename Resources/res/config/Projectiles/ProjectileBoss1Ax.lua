local ProjectileBoss1Ax = 
{
	id = 2031,
	type = projectile_type.projectile_type_segment,
	name = "ProjectileAx",
	
	sounds =
	{
		
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
			bossDamage = 200,
			persistance = 0.2,
		},

		{
			name = "StatusComponent",
		},
	}
}

return ProjectileBoss1Ax