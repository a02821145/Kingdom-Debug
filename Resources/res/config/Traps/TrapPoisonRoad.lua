local TrapPoisonRoad = 
{
	id = trap_type.trap_type_poison_road,
	type = actor_type.type_trap,
	updateQuad = false,
	
	components = 
	{
		{
			name = "TeamComponent",
		},

		{
			name = "StatusComponent",
		},
	},


	ScriptComponents = 
	{
		{
			name = "TrapPoisonRoadComponent",
			lifeTime = 15,
			checkTime = 1,
			damage = 5,
			damage_type = damage_type.at_phyisc,
			attachSCB = "UI/Effects/EffectPoisonRoad.csb",
		},
	},
}

return TrapPoisonRoad