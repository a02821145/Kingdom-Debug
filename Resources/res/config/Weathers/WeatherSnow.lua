local WeatherSnow = 
{
	id = 20003,
	type = actor_type.type_weather,
	weatherType = weather_type.weather_type_snow,
	name = "@WeatherSnow",
	desc = "@WWeatherSnowDesc",
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
			name = "WeatherSnowComponent",
			lifeTime = 30,
			speed = 30,
			radius = 150,
			height = 80,
			checkTimes = 0.5,
			ratio = 40,
			attachSCB = "UI/InGame/SnowEffect.csb",
			batchPath = "UI/TextureUI/Projectiles.png",
			layer = ESpriteLayer.layerProjectile,
		}
	},
}

return WeatherSnow