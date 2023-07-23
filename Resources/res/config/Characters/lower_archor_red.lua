local conf = 
{
	id = 1004,
	oppId = 1003,
	name = "@SoldierLowerAncherName",
	desc = "@SoldierLowerAncherDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_lower_archer,
	radius = 16,
	showPriority = 2,
	CDTime = 5,
	cost = 8,
	icon = "icon_soldier_lower_soldier.png",
	team = actor_team.team_NPC,
	upID = 10002,
	population = 0,
	isGuard = true,
	canStandOnBuilding = true,
	
	regulators = 
	{
		{name = "triggerTestRegulator",time=8},
	},

	sounds = 
	{
		die = 
		{
			"Sound_HumanDead1",
			"Sound_HumanDead2",
			"Sound_HumanDead3",
			"Sound_HumanDead4",
		},
	},

	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "d3371pixekicon64_238.png",displayName =  "@PropertyAttack",upAdd = "atk"},
	},

	components = 
	{

		{
			name = "TeamComponent",
			team = actor_team.team_NPC,
		},

		{
			name = "StatusComponent",
		},
		{
			name = "PathComponent",
		},
		{
			name = "HealthComponent",
			maxHealth = 35,
		},
		{
			name = "VertexRenderComponent",
			hitFlashTime = 0.2,
			vextexCount = 4,
			v1 = {x=-3,y=8},
			v2 = {x=3,y=10},
			v3 = {x=3,y=-10},
			v4 = {x=-3,y=-8},
		},
		{
			name = "MoveComponent",
			mass = 1,
			maxSpeed = 45,
			heading = {x=1,y= 0},
			maxHeadTurnRate = 0.2,
			maxForce  = 0.1,
			fov = 45,
		},
		{
			name = "MemoryComponent",
			ViewDistance = 200,
			regulator = 2,
			memorySpan = 5,
			ignoreSpan = 5,
			updateByView = true,
			regStart = true,
		},
		{
			name = "TargetSysComponent",
			regulator = 5,
			regStart = true,
		},
		{
			name = "WeaponSysComponent",
			AimAccuracy = 0.0,
			AimPersistance = 1,
			regulator = 2,
			SwitchRegulator = 1,

			weapons = 
			{
				3002,
			}
		},

		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/FarmerAnchorRed.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			shootIndex1 = 135,
			
			animations =
			{
				[actor_status.as_alive] = {"stand01"},
				[actor_status.as_dead] = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_shoot] ={"shoot"},
				[actor_status.as_stand] = {"stand01"},
			},
		},

	-- 	{
	-- 		name = "SpriteBatchAniComponent",
	-- 		pngPath = "UI/TextureUI/FarmerAnchorRed.png",
	-- 		defaultSp = "gongjianshou-stand01_00.png",

	-- 		animations =
	-- 		{
	-- 			[actor_status.as_alive] = {"stand01"},
	-- 			[actor_status.as_dead] = {"die"},
	-- 			[actor_status.as_moving] = {"walk"},
	-- 			[actor_status.as_shoot] ={"shoot"},
	-- 			[actor_status.as_stand] = {"stand01"},
	-- 		},

	-- 		attackNodePos = 
	-- 		{
	-- 			x = 9.4,
	-- 			y = 10.21
	-- 		},

	-- 		aniAttackCallback = 
	-- 		{
	-- 			"gongjianshou-shoot_14.png"
	-- 		},

	-- 		aniStrMap = 
	-- 		{
	-- 			["stand01"] = {str = "gongjianshou-stand01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
	-- 			["die"] = {str = "gongjianshou-die_%s.png",startIndex = 0,endIndex = 47,time= 0.03  },
	-- 			["walk"] = {str = "gongjianshou-walk_%s.png", startIndex = 0,endIndex = 23,time= 0.03 },
	-- 			["shoot"] = {str = "gongjianshou-shoot_%s.png",startIndex=0,endIndex =37,time = 0.03  },
	-- 		}
	-- 	}
	},
}

return conf