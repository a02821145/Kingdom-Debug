local conf = 
{
	id = 1002,
	oppId = 1001,
	name = "@SoldierSpearManName",
	desc = "@SoldierSpearManDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_lower_soldier_spear,
	radius = 16,
	showPriority = 1,
	icon = "icon_soldier_spear.png",
	CDTime = 4,
	cost = 5,
	team = actor_team.team_NPC,
	population = 0,
	isGuard = true,
	upID = 10001,

	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "d4pixelicon64_7.png",displayName =  "@PropertyAttack",upAdd = "atk"},
	},

	regulators = 
	{
		{name = "triggerTestRegulator",time=8},
	},

	sounds = 
	{
		die = 
		{
			"Knight_02_Death",
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
			maxHealth = 40,
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
			maxSpeed = 68,
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

			weapons = 
			{
				3001,
			}
		},

		
		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/FarmerSpearRed.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			attackIndex1 = 63,
			
			animations =
			{
				[actor_status.as_alive] = {"stand"},
				[actor_status.as_dead] = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_attack] ={"attack"},
				[actor_status.as_stand] = {"stand"},
			},
		},

		-- {
		-- 	name = "SpriteBatchAniComponent",
		-- 	pngPath = "UI/TextureUI/FarmerSpearRed.png",
		-- 	defaultSp = "FarmerSpearRed-stand01_00.png",

		-- 	animations =
		-- 	{
		-- 		[actor_status.as_alive] = {"stand"},
		-- 		[actor_status.as_dead] = {"die"},
		-- 		[actor_status.as_moving] = {"walk"},
		-- 		[actor_status.as_attack] ={"attack"},
		-- 		[actor_status.as_stand] = {"stand"},
		-- 	},

		-- 	attackNodePos = 
		-- 	{
		-- 		x = 33.34,
		-- 		y = 26.68
		-- 	},

		-- 	aniAttackCallback = 
		-- 	{
		-- 		"FarmerSpearRed-attack01_08.png",
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand"] = {str = "FarmerSpearRed-stand01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["die"] = {str = "FarmerSpearRed-die_%s.png",startIndex = 0,endIndex = 24,time= 0.03 },
		-- 		["walk"] = {str = "FarmerSpearRed-walk_%s.png",startIndex = 0,endIndex = 23,time= 0.03 },
		-- 		["attack"] = {str = "FarmerSpearRed-attack01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
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