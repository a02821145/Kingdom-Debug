local TrapWoodenSpike = 
{
	id = trap_type.trap_type_spkie_wooden,
	type = actor_type.type_trap,
	name = "@Building_Name_40001",
	desc = "@Building_Desc_40001",
	icon = "long_wood_spike_icon.png",
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
			name = "TrapSpikeComponent",
			sp   = "small_wood_spike_01.png",
			radius = 16,
			checkTimes = 5,
			damage = 30,
			damage_type = damage_type.at_puncture,
			effectId = 7012,
			spFile = "UI/TextureUI/TrapAni.png",
		},
	},

}

return TrapWoodenSpike