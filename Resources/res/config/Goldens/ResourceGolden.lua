local ResourceGolden = 
{
	id = 6001,
	type = actor_type.type_resource,
	updateQuad = false,
	radius = 16,
	
	components = 
	{

		{
			name = "ItemComponent",
			pic = "Golden.png",
			batchPath = "UI/TextureUI/TrapAni.png",
		},

		{
			name = "TeamComponent",
		},
	}
}

return ResourceGolden
