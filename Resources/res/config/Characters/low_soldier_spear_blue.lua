local conf = 
{
	id = 1001,
	oppId = 1002,
	name = "@SoldierSpearManName",
	desc = "@SoldierSpearManDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_lower_soldier_spear,
	radius = 16,
	showPriority = 1,
	icon = "icon_soldier_spear.png",
	CDTime = 4,
	cost = 5,
	team = actor_team.team_player,
	upID = 10001,
	population = 0,
	isGuard = true,
	displayCSB = "UI/displayAni/displayAni1001.csb",

	regulators = 
	{
		{name = "triggerTestRegulator",time=8},
	},

	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "pixelicon64_d2538.png",displayName =  "@PropertyAttack",upAdd = "atk"},
		[3] = {com = "MoveComponent",icon="d2331pixekicon64_234.png", displayName =  "@PropertySpeed",vName = "maxSpeed"},
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
			csbPath = "UI/characters/FarmerSpearBlue.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			attackIndex1 = 63,
			
			animations =
			{
				[actor_status.as_alive] = {"stand"},
				[actor_status.as_dead] = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_attack] ={"attack1"},
				[actor_status.as_stand] = {"stand"},
			},
		},

		-- {
		-- 	name = "SpriteBatchAniComponent",
		-- 	pngPath = "UI/TextureUI/FarmerSpearBlue.png",
		-- 	defaultSp = "FarmerSpearBlue-stand01_00.png",

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
		-- 		"FarmerSpearBlue-attack01_08.png",
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand"] = {str = "FarmerSpearBlue-stand01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["die"] = {str = "FarmerSpearBlue-die_%s.png",startIndex = 0,endIndex = 24,time= 0.03 },
		-- 		["walk"] = {str = "FarmerSpearBlue-walk_%s.png",startIndex = 0,endIndex = 23,time= 0.03 },
		-- 		["attack"] = {str = "FarmerSpearBlue-attack01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
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