local weaponBowFire = 
{
	id = 30071,
	bulletId = 20071,

	type = actor_type.weapon_type_curve,
	name = "weaponBowFire",
	attackType = actor_status.as_shoot,
	damgeType= damage_type.at_puncture,

	rounds = 0,
	maxRoundsCarried = 0,
	firingFreq = 1,
	idealRange = 200,
	idealRangeMin = 30,
	soundRange = 50,

	desirabilityInRange = 1.2,
	desirabilityLessRange = 0,
	desirabilityMoreRange = 1.1,

	vertex = 
	{
		v1 = {x=0,y=-1},
		v2 = {x=10,y=-1},
		v3 = {x=10,y=1},
		v4 = {x=0,y=1},
	},


	color = {r=50, g=255, b=50, a=255}
}

return weaponBowFire