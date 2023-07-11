local ProjectileLowerSpear = 
{
	id = 2001,
	type = projectile_type.projectile_type_segment,
	name = "ProjectileLowerSpear",

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
			damage = 6,
			persistance = 0.2,
		},

		{
			name = "StatusComponent",
		},
	}
}

return ProjectileLowerSpear