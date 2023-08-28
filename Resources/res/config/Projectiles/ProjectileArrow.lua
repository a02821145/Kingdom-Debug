local ProjectileArrow = 
{
	id = 2007,
	type = projectile_type.projectile_type_arrow,
	name = "ProjectileArrow",
	
	sounds =
	{
		fire = 
		{
			"Sound_ArrowRelease1",
			"Sound_ArrowRelease2",
			"Sound_ArrowRelease3"
		},

		die = 
		{
			"Sound_ArrowHit1",
			"Sound_ArrowHit2",
			"Sound_ArrowHit3"
		},
	},

	components = 
	{
		{
			name = "MoveComponent",
			mass = 1,
			maxSpeed = 350,
			maxForce  = 50,
		},

		{
			name = "TeamComponent",
		},
		
		{
			name = "DamageCurveComponent",
			length = 3,
			damage = 8,
			curRatio = 0.5,
			collideEffect = 7046,
			collideEffectType = actor_type.type_soilder,
		},

		{
			name = "StatusComponent",
		},

		{
			name = "MoveSpriteComponent",
			path = "archer_arrow.png",
			batchPath = "UI/TextureUI/Projectiles.png",
			layer = ESpriteLayer.layerProjectile,
			isSpriteFrame = true,
			rotate = true,
		},

		{
			name = "ProjectileProperty",

			popWords = 
			{
				ratio = 10,
				delay = 0.5,
				ids = 
				{
					7029,
				}
			},
		}
	}

}

return ProjectileArrow