local ProjectileFist = 
{
	id = 2021,
	type = projectile_type.projectile_type_segment,
	name = "ProjectileFist",
	
	sounds =
	{
		fire = 
		{
			"Sound_GolemAttack",
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
			name = "DamageBombRadiusComponent",
			damage = 10,
			blastRadius = 35,
		},

		{
			name = "StatusComponent",
		},
	}
}

return ProjectileFist