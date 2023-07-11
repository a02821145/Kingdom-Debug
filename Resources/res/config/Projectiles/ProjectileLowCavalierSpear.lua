local ProjectileLowCavalierSpear = 
{
	id = 2003,
	type = projectile_type.projectile_type_segment,
	name = "ProjectileLowCavalierSpear",
	
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
	}
}

return ProjectileLowCavalierSpear