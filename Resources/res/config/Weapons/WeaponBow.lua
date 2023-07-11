local weaponBow = 
{
	id = 3007,
	bulletId = 2007,
	type = actor_type.weapon_type_curve,
	name = "weaponBow",
	attackType = actor_status.as_shoot,
	
	damageMoreTargetTypes = 
	{
		actor_type.type_soilder
	},

	damageMoreTargetProfs =
	{
		actor_profession.prof_lower_cavalier,
		actor_profession.prof_cavalier
	},

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

return weaponBow