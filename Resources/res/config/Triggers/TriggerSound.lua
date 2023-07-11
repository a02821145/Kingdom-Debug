local TriggerSound = 
{
	id = 5003,
	type = actor_type.type_sound_trigger,
	updateQuad = false,
	
	components = 
	{
		{
			name = "StatusComponent",
		},

		{
			name = "TriggerSoundComponent",
			limitedLifetime = 8,
		},
	}
}

return TriggerSound