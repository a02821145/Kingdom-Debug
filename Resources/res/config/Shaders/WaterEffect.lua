local WaterEffect = 
{
	id = 9002,
	name = "WaterEffect",

	vertexName = "shader/WaterEffect.vsh",
	fragName = "shader/WaterEffect.fsh",

	params = 
	{
		{
			locName = "_BaseColor",
			type  = "Color",
			value = "20, 170, 255,128", 
		},

		{
			locName = "_WaveBaseColor",
			type = "Color",
			value = "0,80,95,128",
		},

		{
			locName = "_WaveTex",
			type = "sampler2D",
			value = "UI/Images/Caustics.png",
		}
	}
}

return WaterEffect