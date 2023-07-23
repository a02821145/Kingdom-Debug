local weaponSword = 
{
	id = 3010,
	bulletId = 2010,
	type = actor_type.weapon_type_segment,
	name = "weaponSword",
	attackType = actor_status.as_attack,
	
	damageMoreTargetTypes = 
	{
		actor_type.type_soilder
	},

	damageMoreTargetProfs =
	{
		actor_profession.prof_cavalier,
	},

	rounds = 0,
	maxRoundsCarried = 0,
	firingFreq = 3,
	idealRange = 15,
	soundRange = 0,

	vertex = 
	{
		v1 = {x=0,y=-1},
		v2 = {x=10,y=-1},
		v3 = {x=10,y=1},
		v4 = {x=0,y=1},
	},


	color = {r=50, g=255, b=50, a=255}
}

return weaponSword