local ProjectileCatapultCannon = 
{
	id = 2019,
	type = projectile_type.projectile_type_cannon,
	name = "ProjectileCatapultCannon",
	
	sounds =
	{
		fire = 
		{
			"SoundCatapultFire",
		},

		die = 
		{
			"Sound_CatapultStoneBroken"
		},
	},

	components = 
	{
		{
			name = "MoveComponent",
			mass = 1,
			maxSpeed = 300,
			maxForce  = 50,
		},

		{
			name = "TeamComponent",
		},
		
		{
			name = "DamageCurveComponent",
			blastRadius = 100,
			length = 3,
			damage = 10,
			curRatio = 0.7,
			effect = 7023
		},

		{
			name = "StatusComponent",
		},

		{
			name = "MoveSpriteComponent",
			path = "Rock_Outline_32.png",
			batchPath = "UI/TextureUI/Projectiles.png",
			layer = ESpriteLayer.layerProjectile,
			isSpriteFrame = true,
			rotate = true,
		},
	}

}

return ProjectileCatapultCannon