local weaponSpear = 
{
	id = 3011,
	bulletId = 2011,
	type = actor_type.weapon_type_segment,
	name = "weaponSpear",
	attackType = actor_status.as_attack,
	
	damageMoreTargetTypes = 
	{
		actor_type.type_soilder
	},

	damageMoreTargetProfs =
	{
		actor_profession.prof_low_soldier,
		actor_profession.prof_infantryman,
		actor_profession.prof_wisard_master
	},
	
	rounds = 0,
	maxRoundsCarried = 0,
	firingFreq = 1,
	idealRange = 15,
	soundRange = 0,
	desirabilityMoreRange= 0.1,
	
	vertex = 
	{
		v1 = {x=0,y=-1},
		v2 = {x=10,y=-1},
		v3 = {x=10,y=1},
		v4 = {x=0,y=1},
	},


	color = {r=50, g=255, b=50, a=255}
}

return weaponSpear