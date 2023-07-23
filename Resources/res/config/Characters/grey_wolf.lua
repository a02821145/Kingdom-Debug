local conf = 
{
	id = 1029,
	oppId = 1030,
	name = "@SoldierCavalierName",
	desc = "@SoldierCavalierDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_wolf,
	radius = 16,
	showPriority = 6,
	CDTime = 7,
	cost = 0,
	team = actor_team.team_NPC,
	upID = 10015,
	population = 0,

	regulators = 
	{
		{name = "triggerTestRegulator",time=8},
	},

	sounds = 
	{
		
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
			name = "ProfressionComponent",
		},

		{
			name = "HealthComponent",
			maxHealth = 30,
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
			maxSpeed = 113,
			heading = {x=1,y= 0},
			maxHeadTurnRate = 0.2,
			maxForce  = 0.2,
			fov = 180,

			steering = {
				SeparationWeight =   0.5,
				WanderWeight     =  1.0,
				WallAvoidanceWeight =  0.5,
				ViewDistance     =  15.0,
				WallDetectionFeelerLength = 5,
				SeekWeight              =  0.5,
				ArriveWeight            =  1.0,
				Feelers			 = 4,
				WanderDist		 = 2.0,
				WanderRad		 = 1.2,
				WanderJitterPerSec = 40.0,
			},
		},
		{
			name = "MemoryComponent",
			ViewDistance = 150,
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
				3022,
			}
		},

		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/GreyWolf.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			attackIndex1 = 90,

			animations =
			{
				[actor_status.as_alive] = {"stand01","stand02"},
				[actor_status.as_dead] = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_attack] ={"attack"},
				[actor_status.as_stand] = {"stand01","stand02"},
			},
		},

		-- {
		-- 	name = "SpriteBatchAniComponent",
		-- 	pngPath = "UI/TextureUI/greyWolf.png",
		-- 	defaultSp = "__wolfgrey_idle_000.png",
		-- 	flapX = -1,

		-- 	animations =
		-- 	{
		-- 		[actor_status.as_alive] = {"stand01","stand02"},
		-- 		[actor_status.as_dead] = {"die"},
		-- 		[actor_status.as_moving] = {"walk"},
		-- 		[actor_status.as_attack] ={"attack"},
		-- 		[actor_status.as_stand] = {"stand01","stand02"},
		-- 	},

		-- 	attackNodePos = 
		-- 	{
		-- 		x = 29.76,
		-- 		y = 1.40
		-- 	},

		-- 	aniAttackCallback = 
		-- 	{
		-- 		"__wolfgrey_bite_005.png",
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand01"] = {str = "__wolfgrey_howl_0%s.png",startIndex = 0,endIndex = 9,time= 0.03 },
		-- 		["stand02"] = {str = "__wolfgrey_idle_0%s.png",startIndex = 0,endIndex = 19,time= 0.03 },
		-- 		["die"] = {str = "__wolfgrey_die_0%s.png",startIndex = 0,endIndex = 3,time= 0.05 },
		-- 		["walk"] = {str = "__wolfgrey_run_0%s.png",startIndex = 0,endIndex = 15,time= 0.03 },
		-- 		["attack"] = {str = "__wolfgrey_bite_0%s.png",startIndex = 0,endIndex = 9,time= 0.03 },
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
					name = "AttackFarmerGoal_Evaluator",
					profession = actor_profession.prof_farmer,
					regulator = 0.5,
					ratio = 80,
				},

				{
					name = "AttackFarmerGoal_Evaluator",
					profession = actor_profession.prof_catapult,
					regulator = 0.5,
					ratio = 90,
				},

				{
					name = "AttackTargetGoal_Evaluator",
					regulator = 1,
				},

				{
					name = "MoveToTargetBase_Evaluator",
					regulator = 1,
					value = 0.8,
				}
			}
		}
	},
}

return conf