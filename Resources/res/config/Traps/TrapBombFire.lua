local TrapBombFire = 
{
	id = trap_type.trap_type_bomb_fire,
	type = actor_type.type_trap,
	name = "@Building_Name_40001",
	desc = "@Building_Desc_40001",
	radius = 16,
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
			name = "TrapBombFireComponent",
			radius = 16,
			checkTime = 1,
			damage = 10,
			lifeTime=15,
			damage_type = damage_type.at_phyisc,
			attachSCB = "UI/InGame/ItemsBombFire.csb",
		},
	},

}

return TrapBombFire