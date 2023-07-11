local WeaponBuildingCannon = 
{
	id = 3020,
	bulletId = 2020,
	type = actor_type.weapon_type_curve,
	name = "WeaponBuildingCannon",
	attackType = actor_status.as_shoot,
	damgeType = damage_type.at_puncture,
	targetType = actor_type.type_soilder,
	
	rounds = 0,
	maxRoundsCarried = 0,
	firingFreq = 0.5,
	idealRange = 300,
	soundRange = 100,

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

return WeaponBuildingCannon