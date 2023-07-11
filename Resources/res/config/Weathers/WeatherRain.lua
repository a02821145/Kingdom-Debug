local WeatherRain = 
{
	id = 20002,
	type = actor_type.type_weather,
	weatherType = weather_type.weather_type_rain,
	name = "@WeatherRain",
	desc = "@WeatherRainDesc",
	updateQuad = false,
	
	components = 
	{
		{
			name = "StatusComponent",
		},
	},

	ScriptComponents = 
	{
		{
			name = "WeatherRainComponent",
			damage = "30,60",
			thunderTime = 1,
			thunderCount = 4,
			thunderRadius = 70,
			lifeTime = 20,
			speed = 30,
			radius = 150,
			effect = 7015,
			attachSCB = "UI/InGame/RainEffect.csb",
			batchPath = "UI/TextureUI/Projectiles.png",
			layer = ESpriteLayer.layerProjectile,
			sound="Sound_RainThunder",
			effectId = 7015,
		}
	},
}

return WeatherRain