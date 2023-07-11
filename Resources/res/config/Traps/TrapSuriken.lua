local TrapSuriken = 
{
	id = trap_type.trap_type_suriken,
	type = actor_type.type_trap,
	name = "@Building_Name_40001",
	desc = "@Building_Desc_40001",
	icon = "trap_icons_huriken.png",
	cost = 80,
	createMultiple = true,
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
			name = "TrapSurikenComponent",
			sp   = "Suriken_01.png",
			radius = 16,
			checkTimes = 5,
			damage = 20,
			finishTime = 5,
			damage_type = damage_type.at_puncture,
			spFile = "UI/TextureUI/TrapAni.png",
			attachSCB = "UI/Traps/TrapSuriken.csb",
		},
	},

}

return TrapSuriken