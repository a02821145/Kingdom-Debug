local ProjectileArrowFire = 
{
	id = 20071,
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
			maxSpeed = 250,
			maxForce  = 50,
		},

		{
			name = "TeamComponent",
		},
		
		{
			name = "DamageCurveComponent",
			length = 3,
			damage = 8,
			curRatio = 0.8
		},

		{
			name = "StatusComponent",
		},

		{
			name = "MoveCsbComponent",
			path = "UI/InGame/ArrowFire.csb",
			batchPath = "UI/TextureUI/Projectiles.png",
			layer = ESpriteLayer.layerProjectile,
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

return ProjectileArrowFire