local WeaponCatapultCannon = 
{
	id = 3019,
	bulletId = 2019,
	type = actor_type.weapon_type_curve,
	name = "WeaponCatapultCannon",
	attackType = actor_status.as_attack,
	damgeType = damage_type.at_punctureWall,
	targetType = actor_type.type_building,
	damageMoreTargetTypes = actor_type.type_building,

	rounds = 0,
	maxRoundsCarried = 0,
	firingFreq = 0.3,
	idealRange = 480,
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

return WeaponCatapultCannon