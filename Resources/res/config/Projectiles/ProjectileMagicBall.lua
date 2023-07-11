local ProjectileMagicBall = 
{
	id = 2004,
	type = projectile_type.projectile_type_ball,
	name = "ProjectileMagicBall",
	
	sounds =
	{
		fire = 
		{
			"Sound_MagicBall",
		},
	},

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
			maxLen = 500,
		},
		{
			name = "StatusComponent",
		},

		{
			name = "MoveCsbComponent",
			path = "UI/InGame/MagicBallBlue.csb",
			batchPath = "UI/TextureUI/Projectiles.png",
			layer = ESpriteLayer.layerProjectile,
		},
	}

}

return ProjectileMagicBall