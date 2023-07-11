local ProjectileMagicBallRed = 
{
	id = 20051,
	type = projectile_type.projectile_type_ball,
	name = "ProjectileMagicBallRed",
	
	components = 
	{
		{
			name = "MoveComponent",
			radius = 0.8,
			scale = 0.8,
			mass = 1,
			maxSpeed = 300,
			maxForce  = 50,
		},

		{
			name = "TeamComponent",
		},
		
		{
			name = "DamageBulletComponent",
			damage = 15,
		},
		{
			name = "StatusComponent",
		},

		{
			name = "MoveCsbComponent",
			path = "UI/InGame/MagicBallRed.csb",
		},
	}

}

return ProjectileMagicBallRed