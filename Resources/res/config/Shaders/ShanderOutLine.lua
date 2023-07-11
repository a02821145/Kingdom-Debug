local ShaderOutLine = 
{
	id = 9001,
	name = "ShaderOutLine",

	vertexName = "shader/PositionTextureColor.vsh",
	fragName = "shader/Outline.fsh",

	params = 
	{
		{
			locName = "u_outlineColor",
			type  = "Vec3",
			value = "1.0, 0.2, 0.3", 
		},

		{
			locName = "u_radius",
			type  = "GLfloat",
			value = "0.01",
		},
		{
			locName = "u_threshold",
			type  = "GLfloat",
			value = "1.75",
		}
	}
}

return ShaderOutLine