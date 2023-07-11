local conf = 
{
	id = 1027,
	oppId = 1028,
	name = "@SoldierCavalierName",
	desc = "@SoldierCavalierDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_golem,
	radius = 16,
	showPriority = 6,
	CDTime = 7,
	cost = 0,
	team = actor_team.team_player,
	upID = 10014,
	population = 0,

	regulators = 
	{
		{name = "triggerTestRegulator",time=8},
	},

	sounds = 
	{
		die = 
		{
			"Knight_02_Suffering_Shout_04",
		},

		alive = 
		{
			"Knight_01_Dialogue_I_Am_Hungry",
			"Knight_01_Dialogue_I_Smell_Evil",
			"Knight_01_Dialogue_Say_Your_Last_Words",
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
			name = "ProfressionComponent",
		},

		{
			name = "HealthComponent",
			maxHealth = 100,
			def = 2.5,
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
			maxSpeed = 30,
			heading = {x=1,y= 0},
			maxHeadTurnRate = 0.2,
			maxForce  = 0.2,
			fov = 45,

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
				3021,
			}
		},

		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/Golem.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			attackIndex1 = 138,

			animations =
			{
				[actor_status.as_alive] = {"stand01"},
				[actor_status.as_dead] = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_attack] ={"attack"},
				[actor_status.as_stand] = {"stand01"},
			},
		},

		{
			name = "BrainComponent",
			lowRangeOfBias = 0.5,
			highRangeOfBias = 1.5,
			regulator = 4,

			Evaluators = 
			{
				-- {
				-- 	name = "GetHealthGoal_Evaluator",
				-- 	regulator = 2,

				-- },
				-- {
				-- 	name = "ExploreGoal_Evaluator",
				-- },

				{
					name = "AttackTargetGoal_Evaluator",
					regulator = 1,
				},

				{
					name = "MoveFowardGoal_Evaluator",
					regulator = 1.0;
					value = 0.9,
				},
				
				{
					name = "MoveToTargetBase_Evaluator",
					regulator = 1,
					value = 0.8,
				}
				-- {
				-- 	name = "GetWeaponGoal_Evaluator",
				-- 	weaponType = actor_type.type_shotgun
				-- },
				-- {
				-- 	name = "GetWeaponGoal_Evaluator",
				-- 	weaponType = actor_type.type_rail_gun
				-- },
				-- {
				-- 	name = "GetWeaponGoal_Evaluator",
				-- 	weaponType = actor_type.type_rocket_launcher
				-- }
			}
		}
	},
}

return conf