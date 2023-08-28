local data = {

	[100001]={
		id = 100001,
		name = 'Coins',
		title = '@ItemTitle10001',
		desc = '@ItemDes10001',
		value = 100,
		range = 0,
		cost = 100,
		icon = 'd327pixelicon64_16.png',
		touchScript = "ItemAskNode",
		prepareState = true,
	},

	[100003]={
		id = 100003,
		name = 'Firebomb',
		title = '@ItemTitle10003',
		desc = '@ItemDes10003',
		value = 50,
		range = 100,
		cost = 50,
		icon = 'd2700pixelicon64_19.png',
	},

	[100004]={
		id = 100004,
		name = 'Repair',
		title = '@ItemTitle10004',
		desc = '@ItemDes10004',
		value = 100,
		range = 0,
		cost = 60,
		icon = 'd3024pixelicon64_20.png',
		touchScript = "ItemFixBuildingAskNode",
	},

	-- [100005]={
	-- 	id = 100005,
	-- 	name = 'Call',
	-- 	title = '@ItemTitle10005',
	-- 	desc = '@ItemDes10005',
	-- 	radius = 130,
	-- 	cost = 120,
	-- 	icon = 'd2862pixelicon64_22.png',
	-- },

	[100006]={
		id = 100006,
		name = 'Rain',
		title = '@ItemTitle10006',
		desc = '@ItemDes10006',
		value = 100,
		radius = 250,
		cost = 150,
		rainCount = 20,
		icon = 'd2590pixekicon64_236.png',
	},

	[100007]={
		id = 100007,
		name = 'Invincible',
		title = '@ItemTitle10007',
		desc = '@ItemDes10007',
		radius = 150,
		value = 8,
		cost = 80,
		icon = 'pixelicon64_invincible.png',
	},

	[100008]={
		id = 100008,
		name = 'Hammer of Thor',
		title = '@ItemTitle10008',
		desc = '@ItemDes10008',
		radius = 100,
		value = 5,
		cost = 50,
		icon = 'leishen_chui_cion.png',
	}

}
return data