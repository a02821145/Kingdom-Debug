local conf = 
{
	id = 1021,
	oppId = 1022,
	name = "thief_blue",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_thief,
	name = "@SoldierThiefName",
	desc = "@SoldierThiefDesc",
	radius = 15,
	showPriority = 7,
	CDTime = 5,
	cost = 25,
	icon = "icon_soldier_1009.png",
	team = actor_team.team_player,
	upID = 10011,
	population = 2,
	displayCSB = "UI/displayAni/displayAni1021.csb",

	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "d4pixelicon64_7.png",displayName =  "@PropertyAttack",upAdd = "atk"},
		[3] = {com = "HealthComponent",icon="d6638pixekicon64_2311.png", displayName =  "@PropertyPhyDef",upAdd = "def",vName = "def"},
		[4] = {com = "MoveComponent",icon="d2331pixekicon64_234.png", displayName =  "@PropertySpeed",vName = "maxSpeed"},
	},
	

	regulators = 
	{
		{name = "triggerTestRegulator",time=8},
	},

	sounds = 
	{
		die = 
		{
			"Samurai Casualty 1",
			"Samurai Casualty 2",
			"Samurai Casualty 3",
			"Samurai Casualty 4",
			"Samurai Casualty 5",
			"Samurai Casualty 6",
			"Samurai Casualty 7",
			"Samurai Casualty 8",
		},

		alive = 
		{
			"Knight_01_Dialogue_My_Sword_Is_Bigger_Than_Yours",
			"Knight_01_Dialogue_Never_Fully_Trust_A_Healer",
			"Knight_01_Dialogue_Very_Wise"
		},
	},

	components = 
	{

		{
			name = "TeamComponent",
			team =  actor_team.team_player,
		},

		{
			name = "StatusComponent",
		},
		{
			name = "PathComponent",
		},
		{
			name = "HealthComponent",
			maxHealth = 50,
			def = 0.5,
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
			maxSpeed = 70,
			heading = {x=1,y= 0},
			maxHeadTurnRate = 0.2,
			maxForce  = 0.1,
			fov = 45,
		},
		{
			name = "MemoryComponent",
			ViewDistance = 150,
			regulator = 2,
			memorySpan = 5,
			ignoreSpan = 5,
		},
		{
			name = "VisualableComponent",
			CDTime = 2,
			Opacity = 100,
			HideSpeed = 100,
			StartDelay = 1,
		},
		{
			name = "TargetSysComponent",
			regulator = 10
		},
		{
			name = "ProfressionComponent",
		},
		{
			name = "WeaponSysComponent",
			AimAccuracy = 0.0,
			AimPersistance = 1,
			regulator = 2,

			weapons = 
			{
				3013,
			}
		},

		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/ThiefBlue.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			attackIndex1 = 120,
			attackIndex2 = 209,

			animations =
			{
				[actor_status.as_alive] = {"stand"},
				[actor_status.as_dead] = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_attack] ={"attack01","attack02"},
				[actor_status.as_stand] = {"stand"},
			},
		},

		-- {
		-- 	name = "SpriteBatchAniComponent",
		-- 	pngPath = "UI/TextureUI/ThiefBlue.png",
		-- 	defaultSp = "ThiefBlue-stand01_00.png",

		-- 	animations =
		-- 	{
		-- 		[actor_status.as_alive] = {"stand"},
		-- 		[actor_status.as_dead] = {"die"},
		-- 		[actor_status.as_moving] = {"walk"},
		-- 		[actor_status.as_attack] ={"attack01","attack02"},
		-- 		[actor_status.as_stand] = {"stand"},
		-- 	},

		-- 	attackNodePos = 
		-- 	{
		-- 		x = 6.72,
		-- 		y = 34.42
		-- 	},

		-- 	aniAttackCallback = 
		-- 	{
		-- 		"ThiefBlue-attack01_11.png",
		-- 		"ThiefBlue-attack02_20.png",
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand"] = {str = "ThiefBlue-stand01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["die"] = {str = "ThiefBlue-die_%s.png",startIndex = 0,endIndex = 24,time= 0.03 },
		-- 		["walk"] = {str = "ThiefBlue-walk_%s.png",startIndex = 0,endIndex = 19,time= 0.03 },
		-- 		["attack01"] = {str = "ThiefBlue-attack01_%s.png",startIndex = 0,endIndex = 37,time= 0.03 },
		-- 		["attack02"] = {str = "ThiefBlue-attack02_%s.png",startIndex = 0,endIndex = 39,time= 0.03 },
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
					profession = actor_profession.prof_wisard,
					regulator = 0.5,
					value = 2.2,
					ratio = 100,
				},

				{
					name = "AttackFarmerGoal_Evaluator",
					profession = actor_profession.prof_wisard_master,
					regulator = 0.5,
					value = 2.1,
					ratio = 100,
				},

				{
					name = "AttackFarmerGoal_Evaluator",
					profession = actor_profession.prof_farmer,
					regulator = 0.5,
					value = 2.0,
					ratio = 70,
				},

				{
					name = "AttackTargetGoal_Evaluator",
					regulator = 1,
				},
				-- {
				-- 	name = "AttackBuildingGoal_Evaluator",
				-- 	regulator = 1,
				-- },
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