local WaterWall = 
{
	id = 4102,
	type = actor_type.type_water_wall,
	updateQuad = false,

	components = 
	{
		{
			name = "ShapeComponent",
			shapeType = actor_shape_type.shape_type_line
		},
	},
}

return WaterWall