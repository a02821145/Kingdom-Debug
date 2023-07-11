local TriggerHealthGiver = 
{
	id = 5001,
	type = actor_type.type_health,
	updateQuad = false,
	
	components = 
	{
		{
			name = "TriggerHealthGiverComponent",
			triggerRange = 10,
			respawnDelay = 10,
		},
		{
			name = "StatusComponent",
		},
	}
}

return TriggerHealthGiver