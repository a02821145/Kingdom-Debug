local conf = 
{
	id = 1016,
	oppId = 1015,
	name = "@SoldierInfrantryName",
	desc = "@SoldierInfrantryDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_infantryman,
	radius = 15,
	showPriority = 4,
	CDTime = 6,
	icon = "icon_soldier_1005.png",
	cost = 16,
	population = 2,
	team = actor_team.team_NPC,
	upID = 10008,
	
	regulators = 
	{
		{name = "triggerTestRegulator",time=8},
	},

	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "d4pixelicon64_7.png",displayName =  "@PropertyAttack",upAdd = "atk"},
		[3] = {com = "HealthComponent",icon="d6638pixekicon64_2311.png", displayName =  "@PropertyPhyDef",upAdd = "def",vName = "def"},
		[4] = {com = "MoveComponent",icon="d2331pixekicon64_234.png", displayName =  "@PropertySpeed",upAdd = "spd",vName = "maxSpeed"},
	},

	sounds = 
	{
		die = 
		{
			"Knight-Death_b",
		},

		alive = 
		{
			"Knight_01_Dialogue_Attack_Exclamation",
			"Knight_02_Dialogue_For_Honor_Exclamation",
			"Knight_01_Dialogue_Defend_Yourselves_02",
			"Knight_01_Dialogue_I_Have_No_Fear",
		},
	},

	components = 
	{

		{
			name = "TeamComponent",
			team = actor_team.team_NPC,
		},
		{
			name = "PathComponent",
		},
		{
			name = "StatusComponent",
		},
		{
			name = "HealthComponent",
			maxHealth = 55,
			def  = 1.5,
		},
		{
			name = "VertexRenderComponent",
			hitFlashTime = 0.2,
			vextexCount = 4,
			vextexScale =2,
			v1 = {x=-3,y=8},
			v2 = {x=3,y=10},
			v3 = {x=3,y=-10},
			v4 = {x=-3,y=-8},
		},
		{
			name = "MoveComponent",
			mass = 1,
			maxSpeed = 38,
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
				3010,
			}
		},

		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/InfantrymanRed.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			attackIndex1 = 321,
			attackIndex2 = 382,
			
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
		-- 	pngPath = "UI/TextureUI/InfantrymanRed.png",
		-- 	defaultSp = "InfantrymanRed-stand01_00.png",

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
		-- 		x = 0,
		-- 		y = 26.68
		-- 	},

		-- 	aniAttackCallback = 
		-- 	{
		-- 		"InfantrymanRed-attack01_15.png",
		-- 		"InfantrymanRed-attack02_12.png",
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand01"] = {str = "InfantrymanRed-stand01_%s.png",startIndex = 0,endIndex = 59,time= 0.03 },
		-- 		["stand02"] = {str = "InfantrymanRed-stand02_%s.png",startIndex = 0,endIndex = 67,time= 0.03 },
		-- 		["die"] = {str = "InfantrymanRed-die_%s.png",startIndex = 0,endIndex = 27,time= 0.03 },
		-- 		["walk"] = {str = "InfantrymanRed-walk_%s.png",startIndex = 0,endIndex = 19,time= 0.03 },
		-- 		["attack01"] = {str = "InfantrymanRed-attack01_%s.png",startIndex = 0,endIndex = 32,time= 0.03 },
		-- 		["attack02"] = {str = "InfantrymanRed-attack02_%s.png",startIndex = 0,endIndex = 31,time= 0.03 },
		-- 	}
		-- },

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
					name = "AttackFarmerGoal_Evaluator",
					profession = actor_profession.prof_farmer,
					regulator = 0.5,
					ratio = 30,
				},

				{
					name = "GetItemGoal_Evaluator",
					regulator = 2,
					type = actor_type.type_giftbox

				},
				
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