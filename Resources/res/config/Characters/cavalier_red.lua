local conf = 
{
	id = 1018,
	oppId = 1017,
	name = "@SoldierCavalierName",
	desc = "@SoldierCavalierDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_cavalier,
	radius = 16,
	showPriority = 6,
	CDTime = 7,
	cost = 17,
	icon = "icon_soldier_1007.png",
	team = actor_team.team_NPC,
	population = 3,
	upID = 10009,

	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "d4pixelicon64_7.png",displayName =  "@PropertyAttack",upAdd = "atk"},
		[3] = {com = "HealthComponent",icon="d6638pixekicon64_2311.png", displayName =  "@PropertyPhyDef",upAdd = "def",vName = "def"},
		[4] = {com = "MoveComponent",icon="d2331pixekicon64_234.png", displayName =  "@PropertySpeed",upAdd = "spd",vName = "maxSpeed"},
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

		alive = 
		{
			"Knight_01_Dialogue_I_m_A_Knight",
			"Knight_01_Dialogue_For_The_King_01",
			"Knight_01_Dialogue_Hold_The_Line",
			"Knight_01_Dialogue_Ready_For_Battle",
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
			maxHealth = 60,
			def = 2,
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
			maxSpeed = 55,
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
				3011,
			}
		},

		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/CavalierRed.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			attackIndex1 = 210,
			attackIndex2 = 266,
			
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
		-- 	pngPath = "UI/TextureUI/CavalierRed.png",
		-- 	defaultSp = "CavalierRed-stand01_00.png",

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
		-- 		"CavalierRed-attack01_11.png",
		-- 		"CavalierRed-attact02_12.png",
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand01"] = {str = "CavalierRed-stand01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["stand02"] = {str = "CavalierRed-stand02_%s.png",startIndex = 0,endIndex = 48,time= 0.03 },
		-- 		["die"] = {str = "CavalierRed-die_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["walk"] = {str = "CavalierRed-walk_%s.png",startIndex = 0,endIndex = 15,time= 0.03 },
		-- 		["attack01"] = {str = "CavalierRed-attack01_%s.png",startIndex = 0,endIndex = 28,time= 0.03 },
		-- 		["attack02"] = {str = "CavalierRed-attact02_%s.png",startIndex = 0,endIndex = 34,time= 0.03 },
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
					regulator = 1,
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