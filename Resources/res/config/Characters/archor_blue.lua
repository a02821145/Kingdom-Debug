local conf = 
{
	id = 1013,
	oppId = 1014,
	name = "@SoldierAnchorName",
	desc = "@SoldierAnchorDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_archer,
	radius = 15,
	showPriority = 3,
	CDTime = 5,
	cost = 12,
	icon = "icon_soldier_1011.png",
	team = actor_team.team_player,
	upID = 10007,
	spId = 80001,
	population = 2,
	canStandOnBuilding = true,
	displayCSB = "UI/displayAni/displayAni1013.csb",

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

		alive = 
		{
			"Knight_01_Dialogue_Evil_Is_Near",
			"Knight_01_Dialogue_Brilliant",
			"Knight_01_Dialogue_Look_For_Details",
		},
	},

	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "d3371pixekicon64_238.png",displayName =  "@PropertyAttack",upAdd = "atk"},
		[3] = {com = "WeaponSysComponent",icon = "d4pixelicon64_7.png",displayName =  "@PropertyAttack",upAdd = "secondAtk"},
		[4] = {com = "HealthComponent",icon="d6638pixekicon64_2311.png", displayName =  "@PropertyPhyDef",upAdd = "def",vName = "def"},
		[5] = {com = "MoveComponent",icon="d2331pixekicon64_234.png", displayName =  "@PropertySpeed",vName = "maxSpeed"},
		[6] = {com = "MemoryComponent",icon="d2558attackRange.png", displayName =  "@PropertyAttackRange",vName = "ViewDistance"},
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
			maxHealth = 50,
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
			maxSpeed = 40,
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
				3007,
				3008
			}
		},

		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/AnchorBlue.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			shootIndex1 = 255,
			attackIndex1 = 318,

			animations =
			{
				[actor_status.as_alive]  = {"stand01","stand02"},
				[actor_status.as_dead]   = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_attack] = {"attack"},
				[actor_status.as_shoot]  = {"shoot"},
				[actor_status.as_stand]  = {"stand01","stand02"},
			},
		},

		-- {
		-- 	name = "SpriteBatchAniComponent",
		-- 	pngPath = "UI/TextureUI/AnchorBlue.png",
		-- 	defaultSp = "AnchorBlue-stand01_00.png",

		-- 	animations =
		-- 	{
		-- 		[actor_status.as_alive]  = {"stand01","stand02"},
		-- 		[actor_status.as_dead]   = {"die"},
		-- 		[actor_status.as_moving] = {"walk"},
		-- 		[actor_status.as_attack] = {"attack"},
		-- 		[actor_status.as_shoot]  = {"shoot"},
		-- 		[actor_status.as_stand]  = {"stand01","stand02"},
		-- 	},

		-- 	attackNodePos = 
		-- 	{
		-- 		x = 12.17,
		-- 		y = 7.56
		-- 	},

		-- 	aniAttackCallback = 
		-- 	{
		-- 		"AnchorBlue-attack_09.png",
		-- 		"AnchorBlue-shoot_15.png",
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand01"] = {str = "AnchorBlue-stand01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["stand02"] = {str = "AnchorBlue-stand02_%s.png",startIndex = 0,endIndex = 59,time= 0.03 },
		-- 		["die"] = {str = "AnchorBlue-die_%s.png",startIndex = 0,endIndex = 47,time= 0.03 },
		-- 		["attack"] = {str = "AnchorBlue-attack_%s.png",startIndex = 0,endIndex = 25,time= 0.03 },
		-- 		["walk"] = {str = "AnchorBlue-walk_%s.png",startIndex = 0,endIndex = 23,time= 0.03 },
		-- 		["shoot"] = {str = "AnchorBlue-shoot_%s.png",startIndex = 0,endIndex = 37,time= 0.03 },
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