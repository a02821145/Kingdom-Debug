local TrapSpike = 
{
	id = trap_type.trap_type_spkie,
	type = actor_type.type_trap,
	name = "@Building_Name_40001",
	desc = "@Building_Desc_40001",
	icon = "long_metal_spikeicon.png",
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
			sp   = "long_metal_spike_01.png",
			radius = 16,
			checkTimes = 5,
			damage = 50,
			damage_type = damage_type.at_puncture,
			effectId = 7013,
			spFile = "UI/TextureUI/TrapAni.png",
		},
	},

}

return TrapSpike