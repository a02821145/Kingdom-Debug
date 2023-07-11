local TrapWaterRain = 
{
	id = trap_type.trap_type_water_rain,
	type = actor_type.type_trap,
	name = "@Building_Name_40001",
	desc = "@Building_Desc_40001",
	radius = 120,
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
			name = "TrapWaterRainComponent",
			radius = 120,
			damage = 100,
			damage_type = damage_type.at_puncture,
			attachSCB = "UI/Effects/WaterRainQuanTou.csb",
			batchPath = "UI/TextureUI/Projectiles.png",
			layer = ESpriteLayer.layerProjectile,
		},
	},

}

return TrapWaterRain