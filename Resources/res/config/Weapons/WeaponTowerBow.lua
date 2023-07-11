local weaponTowerBow = 
{
	id = 3016,
	bulletId = 2016,
	type = actor_type.weapon_type_curve,
	name = "weaponTowerBow",
	attackType = actor_status.as_shoot,
	
	damageMoreTargetTypes = 
	{
		actor_type.type_soilder
	},

	damageMoreTargetProfs =
	{
		actor_profession.prof_wisard_master,
	},

	rounds = 0,
	maxRoundsCarried = 0,
	firingFreq = 2,
	idealRange = 350,
	soundRange = 250,

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

return weaponTowerBow