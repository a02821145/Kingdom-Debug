local conf = 
{
	id = 1008,
	oppId = 1007,
	name = "@SoldierLowerMasterName",
	desc = "@SoldierLowerMasterDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_lower_wisard,
	radius = 16,
	showPriority = 4,
	CDTime = 5,
	cost = 15,
	icon = "icon_soldier_sceptre.png",
	team = actor_team.team_NPC,
	upID = 10004,
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
		[2] = {com = "WeaponSysComponent",icon = "d4342pixekicon64_239.png",displayName =  "@PropertyMagAttack",upAdd = "magAtk"},
		[3] = {com = "HealthComponent",icon="d6649pixekicon64_2312.png", displayName =  "@PropertyPhyDef",upAdd = "magDef",vName = "magDef"},
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
			maxHealth = 40,
			magDef = 1,
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
			ViewDistance = 220,
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
				30051,
			}
		},

		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/LowerMasterRed.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			shootIndex1 = 130,
			
			animations =
			{
				[actor_status.as_alive] = {"stand"},
				[actor_status.as_dead] = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_shoot] ={"attack01"},
				[actor_status.as_stand] = {"stand"},
			},
		},

		-- {
		-- 	name = "SpriteBatchAniComponent",
		-- 	pngPath = "UI/TextureUI/LowerMasterRed.png",
		-- 	defaultSp = "LowerMasterRed-stand01_00.png",

		-- 	animations =
		-- 	{
		-- 		[actor_status.as_alive] = {"stand01"},
		-- 		[actor_status.as_dead] = {"die"},
		-- 		[actor_status.as_moving] = {"walk"},
		-- 		[actor_status.as_shoot] ={"attack01"},
		-- 		[actor_status.as_stand] = {"stand01"},
		-- 	},

		-- 	attackNodePos = 
		-- 	{
		-- 		x = 22,
		-- 		y = 23.94
		-- 	},

		-- 	deltaPos =
		-- 	{
		-- 		x = 13.88,
		-- 		y = 0,
		-- 	},

		-- 	aniAttackCallback = 
		-- 	{
		-- 		"LowerMasterRed-attack01_12.png"
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand01"] = {str = "LowerMasterRed-stand01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["die"] = {str = "LowerMasterRed-die_%s.png",startIndex = 0,endIndex = 27,time= 0.03  },
		-- 		["walk"] = {str = "LowerMasterRed-walk_%s.png", startIndex = 0,endIndex = 23,time= 0.03 },
		-- 		["attack01"] = {str = "LowerMasterRed-attack01_%s.png",startIndex=0,endIndex =29,time = 0.03  },
		-- 	}
		-- }
	},
}

return conf