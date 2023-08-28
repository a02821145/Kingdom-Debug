local conf = 
{
	id = 1006,
	oppId = 1005,
	name = "@SoldierLowerCavalryName",
	desc = "@SoldierLowerCavalryDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_lower_cavalier,
	radius = 16,
	showPriority = 3,
	CDTime = 7,
	cost = 12,
	icon = "icon_soldier_lower_knight.png",
	team = actor_team.team_NPC,
	population = 0,
	isGuard = true,
	upID = 10003,

	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "d4pixelicon64_7.png",displayName =  "@PropertyAttack",upAdd = "atk"},
		[3] = {com = "HealthComponent",icon="d6638pixekicon64_2311.png", displayName =  "@PropertyPhyDef",upAdd = "def",vName = "def"},
	},

	regulators = 
	{
		{name = "triggerTestRegulator",time=8},
	},

	sounds = 
	{
		die = 
		{
			"Knight_01_Dialogue_cavalier_dead",
		},
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
			maxHealth = 55,
			def = 1,
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
			maxSpeed = 120,
			heading = {x=1,y= 0},
			maxHeadTurnRate = 0.2,
			maxForce  = 0.2,
			fov = 45,
		},
		{
			name = "MemoryComponent",
			ViewDistance = 250,
			regulator = 2,
			memorySpan = 5,
			ignoreSpan = 5,
			regStart = true,

			AttackPriority = 
			{
				[1] = EAttackPriotry.AttackPriotryRestrainUnit,
				[2] = EAttackPriotry.AttackPriotryRemoteUnit,
				[3] = EAttackPriotry.AttackPriotryDist
			},
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

			weapons = 
			{
				3003,
			}
		},

		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/FarmerCavalierRed.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			attackIndex1 = 210,
			attackIndex2 = 266,
			
			animations =
			{
				[actor_status.as_alive] = {"stand01","stand02"},
				[actor_status.as_dead] = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_attack] ={"attack1","attack2"},
				[actor_status.as_stand] = {"stand01","stand02"},
			},
		},

		-- {
		-- 	name = "SpriteBatchAniComponent",
		-- 	pngPath = "UI/TextureUI/FarmerCavalierRed.png",
		-- 	defaultSp = "FarmerCavalierRed-stand01_00.png",

		-- 	animations =
		-- 	{
		-- 		[actor_status.as_alive] = {"stand01","stand02"},
		-- 		[actor_status.as_dead] = {"die"},
		-- 		[actor_status.as_moving] = {"walk"},
		-- 		[actor_status.as_attack] ={"attack01","attack02"},
		-- 		[actor_status.as_stand] = {"stand01","stand02"},
		-- 	},

		-- 	attackNodePos = 
		-- 	{
		-- 		x = 20.03,
		-- 		y = 37.48
		-- 	},

		-- 	aniAttackCallback = 
		-- 	{
		-- 		"FarmerCavalierRed-attack01_11.png",
		-- 		"FarmerCavalierRed-attact02_17.png",
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand01"] = {str = "FarmerCavalierRed-stand01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["stand02"] = {str = "FarmerCavalierRed-stand02_%s.png",startIndex = 0,endIndex = 48,time= 0.03 },
		-- 		["die"] = {str = "FarmerCavalierRed-die_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["walk"] = {str = "FarmerCavalierRed-walk_%s.png",startIndex = 0,endIndex = 15,time= 0.03 },
		-- 		["attack01"] = {str = "FarmerCavalierRed-attack01_%s.png",startIndex = 0,endIndex = 28,time= 0.03 },
		-- 		["attack02"] = {str = "FarmerCavalierRed-attact02_%s.png",startIndex = 0,endIndex = 34,time= 0.03 },
		-- 	}
		-- },

		{
			name = "BrainComponent",
			lowRangeOfBias = 0.5,
			highRangeOfBias = 1.5,
			regulator = 4,

			Evaluators = 
			{
				{
					name = "AttackTargetInRangeGoal_Evaluator",
					regulator = 0.5,
				},

				{
					name = "BackToOrigtInRangeGoal_Evaluator",
					regulator = 1,
				},
			}
		}
	},
}

return conf