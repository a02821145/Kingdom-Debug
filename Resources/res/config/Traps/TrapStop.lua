local TrapStop = 
{
	id = trap_type.trap_type_stop,
	type = actor_type.type_trap,
	name = "@Building_Name_40001",
	desc = "@Building_Desc_40001",
	icon = "trap1.png",
	cost = 80,
	createMultiple = true,
	radius = 8,
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
			name = "TrapStopComponent",
			sp   = "trap1.png",
			radius = 8,
			trapTime = 5,
			checkTimes = 5,
			effectId = 7007,
		},
	},
}

return TrapStop