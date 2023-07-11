local WeaponMaskWandBallRed = 
{
	id = 30051,
	bulletId = 20051,
	type = actor_type.weapon_type_magic_ball,
	name = "WeaponMaskWandBallRed",
	attackType = actor_status.as_shoot,
	damgeType = damage_type.at_magic,

	rounds = 0,
	maxRoundsCarried = 0,
	firingFreq = 0.5,
	idealRange = 220,
	idealRangeMin = 50,
	soundRange = 100,

	vertex = 
	{
		v1 = {x=0,y=-1},
		v2 = {x=10,y=-1},
		v3 = {x=10,y=1},
		v4 = {x=0,y=1},
	},


	color = {r=50, g=255, b=50, a=255}
}

return WeaponMaskWandBallRed