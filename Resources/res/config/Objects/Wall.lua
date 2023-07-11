local wall = 
{
	id = 4101,
	type = actor_type.type_wall,
	updateQuad = false,

	components = 
	{
		{
			name = "ShapeComponent",
			shapeType = actor_shape_type.shape_type_line
		},
	},
}

return wall