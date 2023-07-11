local ProjectileBite = 
{
	id = 2022,
	type = projectile_type.projectile_type_segment,
	name = "ProjectileBite",
	
	sounds =
	{
		fire = 
		{
			
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
			damage = 4,
			persistance = 0.2,
		},

		{
			name = "StatusComponent",
		},
	}
}

return ProjectileBite