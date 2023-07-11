local WeatherTornado = 
{
	id = 20001,
	type = actor_type.type_weather,
	weatherType = weather_type.weather_type_tornado,
	name = "@WeatherTornado",
	desc = "@WeatherTornadoDesc",
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
			name = "WeatherTornadoComponent",
			damage = "7,10",
			freq = 16,
			lifeTime = 20,
			speed = 30,
			effectId = 7008,
			radius = 80,
			sound = "SoundWind",
			batchPath = "UI/TextureUI/Projectiles.png",
			layer = ESpriteLayer.layerProjectile,
		}
	},
}

return WeatherTornado