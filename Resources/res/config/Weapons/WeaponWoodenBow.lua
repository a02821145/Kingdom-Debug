local WeaponWoodenBow = 
{
	id = 3002,
	bulletId = 2002,
	type = actor_type.weapon_type_curve,
	name = "WeaponWoodenBow",
	attackType = actor_status.as_shoot,
	
	damageMoreTargetTypes = 
	{
		actor_type.type_soilder
	},

	damageMoreTargetProfs =
	{
		actor_profession.prof_cavalier
	},
	
	rounds = 0,
	maxRoundsCarried = 0,
	firingFreq = 0.7,
	idealRange = 200,
	soundRange = 50,

	vertex = 
	{
		v1 = {x=0,y=-1},
		v2 = {x=10,y=-1},
		v3 = {x=10,y=1},
		v4 = {x=0,y=1},
	},


	color = {r=50, g=255, b=50, a=255}
}

return WeaponWoodenBow