local ProjectileCannon = 
{
	id = 2017,
	type = projectile_type.projectile_type_cannon,
	name = "ProjectileCannon",
	
	sounds =
	{
		fire = 
		{
			"Dwarf_brea_shot2",
		},

		die = 
		{
			"Sound_Bomb1"
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
			damage = 15,
			curRatio = 0.5,
			effect = 7003
		},

		{
			name = "StatusComponent",
		},

		{
			name = "MoveSpriteComponent",
			path = "Cannon.png",
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
					7034,
					7035,
				}
			},
		}
	}

}

return ProjectileCannon