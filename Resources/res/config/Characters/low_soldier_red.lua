local conf = 
{
	id = 1012,
	oppId = 1011,
	name = "@SoldierLowerSoldierName",
	desc = "@SoldierLowerSoldierDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_low_soldier,
	radius = 16,
	showPriority = 2,
	icon = "icon_soldier_1003.png",
	CDTime = 4,
	cost = 8,
	team = actor_team.team_NPC,
	population = 1,
	upID = 10006,

	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "d4pixelicon64_7.png",displayName =  "@PropertyAttack",upAdd = "atk"},
		[3] = {com = "MoveComponent",icon="d2331pixekicon64_234.png", displayName =  "@PropertySpeed",upAdd = "spd",vName = "maxSpeed"},
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

		alive = 
		{
			"Knight_01_Dialogue_No_Mercy_Exclamation",
			"Knight_01_Dialogue_Only_For_The_Brave",
			"Knight_01_Dialogue_Strike_Exclamation",
			"Knight_01_Dialogue_To_The_Enemy",
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
			maxHealth = 45,
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
			ViewDistance = 250,
			regulator = 2,
			memorySpan = 5,
			ignoreSpan = 5,
			regStart = true,
		},
		{
			name = "TargetSysComponent",
			regulator = 10,
			regStart = true,
		},
		{
			name = "WeaponSysComponent",
			AimAccuracy = 0.0,
			AimPersistance = 1,
			regulator = 2,

			weapons = 
			{
				3006,
			}
		},

		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/LowerSoldierRed.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			attackIndex1 = 245,
			attackIndex2 = 326,
			
			animations =
			{
				[actor_status.as_alive] = {"stand01","stand02"},
				[actor_status.as_dead] = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_attack] ={"attack01","attack02"},
				[actor_status.as_stand] = {"stand01","stand02"},
			},
		},

		-- {
		-- 	name = "SpriteBatchAniComponent",
		-- 	pngPath = "UI/TextureUI/LowerSoldierRed.png",
		-- 	defaultSp = "LowerSoldierRed-stand01_00.png",

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
		-- 		x = 6.72,
		-- 		y = 34.42
		-- 	},

		-- 	aniAttackCallback = 
		-- 	{
		-- 		"LowerSoldierRed-attack01_17.png",
		-- 		"LowerSoldierRed-attack02_18.png",
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand01"] = {str = "LowerSoldierRed-stand01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["stand02"] = {str = "LowerSoldierRed-stand02_%s.png",startIndex = 0,endIndex = 52,time= 0.03 },
		-- 		["die"] = {str = "LowerSoldierRed-die_%s.png",startIndex = 0,endIndex = 24,time= 0.03 },
		-- 		["walk"] = {str = "LowerSoldierRed-walk_%s.png",startIndex = 0,endIndex = 23,time= 0.03 },
		-- 		["attack01"] = {str = "LowerSoldierRed-attack01_%s.png",startIndex = 0,endIndex = 39,time= 0.03 },
		-- 		["attack02"] = {str = "LowerSoldierRed-attack02_%s.png",startIndex = 0,endIndex = 39,time= 0.03 },
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
					ratio = 30,
				},

				{
					name = "GetItemGoal_Evaluator",
					regulator = 1,
					type = actor_type.type_giftbox

				},

				{
					name = "AttackTargetGoal_Evaluator",
					regulator = 1.0,
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
			}
		}
	},
}

return conf