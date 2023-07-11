local TrapFire = 
{
	id = trap_type.trap_type_fire,
	type = actor_type.type_trap,
	name = "@Building_Name_40001",
	desc = "@Building_Desc_40001",
	icon = "long_wood_spike_icon.png",
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
			name = "TrapFireComponent",
			sp   = "Fire-Trap---Level-2_01.png",
			radius = 16,
			checkTime = 2,
			damage = 15,
			damage_type = damage_type.at_phyisc,
			moveDelta = {x=0,y=32},
			spFile = "UI/TextureUI/TrapAni.png",
			ani = {fmt = "Fire-Trap---Level-2_0%d.png",startIndex = 1,endIndex = 9,time = 0.1,delay = 3, },
		},
	},
}

return TrapFire