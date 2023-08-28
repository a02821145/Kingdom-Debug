local conf = 
{
	id = 1003,
	oppId = 1004,
	name = "@SoldierLowerAncherName",
	desc = "@SoldierLowerAncherDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_lower_archer,
	radius = 16,
	showPriority = 2,
	CDTime = 5,
	cost = 8,
	icon = "icon_soldier_lower_soldier.png",
	team = actor_team.team_player,
	upID = 10002,
	population = 0,
	canStandOnBuilding = true,
	isGuard = true,
	isRemote = true,
	displayCSB = "UI/displayAni/displayAni1003.csb",

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
		[3] = {com = "MemoryComponent",icon="d2558attackRange.png", displayName =  "@PropertyAttackRange",vName = "ViewDistance"},
	},

	components = 
	{

		{
			name = "TeamComponent",
			team = actor_team.team_player,
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
			csbPath = "UI/characters/FarmerAnchorBlue.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			shootIndex1 = 135,
			
			animations =
			{
				[actor_status.as_alive] = {"stand01"},
				[actor_status.as_dead] = {"die"},
				[actor_status.as_shoot] ={"shoot1"},
				[actor_status.as_stand] = {"stand01"},
			},
		},

	-- 	{
	-- 		name = "SpriteBatchAniComponent",
	-- 		pngPath = "UI/TextureUI/FarmerAnchorBlue.png",
	-- 		defaultSp = "FarmerAnchorBlue-stand01_00.png",

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
	-- 			"FarmerAnchorBlue-shoot_14.png"
	-- 		},

	-- 		aniStrMap = 
	-- 		{
	-- 			["stand01"] = {str = "FarmerAnchorBlue-stand01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
	-- 			["die"] = {str = "FarmerAnchorBlue-die_%s.png",startIndex = 0,endIndex = 47,time= 0.03  },
	-- 			["walk"] = {str = "FarmerAnchorBlue-walk_%s.png", startIndex = 0,endIndex = 23,time= 0.03 },
	-- 			["shoot"] = {str = "FarmerAnchorBlue-shoot_%s.png",startIndex=0,endIndex =37,time = 0.03  },
	-- 		}
	-- 	}
	},
}

return conf