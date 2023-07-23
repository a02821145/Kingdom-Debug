local weaponThiefKnife = 
{
	id = 3013,
	bulletId = 2013,
	type = actor_type.weapon_type_segment,
	name = "weaponThiefKnife",
	attackType = actor_status.as_attack,
	damgeType = damage_type.at_puncture,
	
	damageMoreTargetTypes = 
	{
		actor_type.type_soilder
	},

	damageMoreTargetProfs =
	{
		actor_profession.prof_wisard_master,
		actor_profession.prof_wisard,
		actor_profession.prof_lower_wisard,
	},

	rounds = 0,
	maxRoundsCarried = 0,
	firingFreq = 1,
	idealRange = 15,
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

return weaponThiefKnife