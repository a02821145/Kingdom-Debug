local TriggerButton = 
{
	id = 5002,
	type = actor_type.type_button_msg_trigger,
	updateQuad = false,
	
	components = 
	{
		{
			name = "StatusComponent",
		},

		{
			name = "TriggerOnButtonComponent",
		},
	}
}

return TriggerButton