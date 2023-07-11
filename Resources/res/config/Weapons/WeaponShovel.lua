local weaponShovel = 
{
	id = 3005,
	bulletId = 2005,
	type = actor_type.weapon_type_segment,
	name = "weaponShovel",
	targetType = actor_type.type_resource,
	attackType = actor_status.as_attack,
	
	rounds = 0,
	maxRoundsCarried = 0,
	firingFreq = 2,
	idealRange = 10,
	soundRange = 0,

	vertex = 
	{
		v1 = {x=0,y=-1},
		v2 = {x=10,y=-1},
		v3 = {x=10,y=1},
		v4 = {x=0,y=1},
	},


	color = {r=50, g=0, b=50, a=255}
}

return weaponShovel