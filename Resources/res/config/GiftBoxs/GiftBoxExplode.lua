local GiftBoxExplode = 
{
	name = "GiftBoxExplode",
	id = 11002,
	type = actor_type.type_giftbox,
	updateQuad = false,
	
	components = 
	{
		{
			name = "GiftBoxComponent",
			radius = 32,
			damageRadius = 100,
			value = 50,
			regulator = 5,
			disappearTime = 0.1,
			normalPic = "box1Close.png",
			openPic	= "box1Open.png",
			spFile = "UI/TextureUI/TrapAni.png",
			picScale = 0.3,
			lifeTime = 60,
			type = gift_box_type.type_giftbox_explode,
			effect = 7006,
		},
		{
			name = "StatusComponent",
		},

		{
			name = "TeamComponent",
			team = actor_team.team_none
		},

	}
}

return GiftBoxExplode