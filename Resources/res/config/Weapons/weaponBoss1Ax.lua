local weaponBoss1Ax = 
{
	id = 3023,
	bulletId = 2031,
	type = actor_type.weapon_type_segment,
	name = "weaponBoss1Ax",
	attackType = actor_status.as_attack,

	rounds = 0,
	maxRoundsCarried = 0,
	firingFreq = 1,
	idealRange = 30,
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

return weaponBoss1Ax