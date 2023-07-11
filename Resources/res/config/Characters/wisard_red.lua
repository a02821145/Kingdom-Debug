local conf = 
{
	id = 1020,
	oppId = 1019,
	name = "@SoldierWisardName",
	desc = "@SoldierWisardDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_wisard,
	radius = 15,
	showPriority = 5,
	cost = 14,
	CDTime = 5.5,
	icon = "icon_soldier_1013.png",
	team = actor_team.team_NPC,
	population = 2,
	upID = 10010,

	regulators = 
	{
		{name = "triggerTestRegulator",time=8},
	},

	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "d4pixelicon64_7.png",displayName =  "@PropertyAttack",upAdd = "atk"},
		[3] = {com = "HealthComponent",icon="d6638pixekicon64_2311.png", displayName =  "@PropertyPhyDef",upAdd = "def",vName = "def"},
		[4] = {com = "WeaponSysComponent",icon = "d4342pixekicon64_239.png",displayName =  "@PropertyMagAttack",upAdd = "magAtk"},
		[5] = {com = "HealthComponent",icon="d6649pixekicon64_2312.png", displayName =  "@PropertyPhyDef",upAdd = "magDef",vName = "magDef"},
		[6] = {com = "MoveComponent",icon="d2331pixekicon64_234.png", displayName =  "@PropertySpeed",upAdd = "spd",vName = "maxSpeed"},
	},

	sounds = 
	{
		die = 
		{
			"Female-Elven-Archer-Death_a",
		},
	},

	components = 
	{

		{
			name = "TeamComponent",
			team = actor_team.team_NPC,
		},

		{
			name = "GroupComponent",
		},
		{
			name = "PathComponent",
		},
		{
			name = "StatusComponent",
		},
		{
			name = "ProfressionComponent",
		},
		{
			name = "HealthComponent",
			maxHealth = 60,
			magDef = 2,
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
			ViewDistance = 150,
			regulator = 2,
			memorySpan = 5,
			ignoreSpan = 0,
		},
		{
			name = "PathComponent",
		},
		{
			name = "TargetSysComponent",
			regulator = 5
		},
		{
			name = "WeaponSysComponent",
			AimAccuracy = 0.0,
			AimPersistance = 1,
			regulator = 2,
			SwitchRegulator = 1,
			
			weapons = 
			{
				3012
			}
		},

		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/WitchRed.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			attackIndex1 = 191,
			shootIndex1 = 130,

			animations =
			{
				[actor_status.as_alive]  = {"stand01"},
				[actor_status.as_dead]   = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_attack] = {"attack02"},
				[actor_status.as_shoot]  = {"attack01"},
				[actor_status.as_stand]  = {"stand01"},
			},
		},

		-- {
		-- 	name = "SpriteBatchAniComponent",
		-- 	pngPath = "UI/TextureUI/WitchRed.png",
		-- 	defaultSp = "WitchRed-stand01_00.png",

		-- 	animations =
		-- 	{
		-- 		[actor_status.as_alive]  = {"stand01"},
		-- 		[actor_status.as_dead]   = {"die"},
		-- 		[actor_status.as_moving] = {"walk"},
		-- 		[actor_status.as_attack] = {"attack02"},
		-- 		[actor_status.as_shoot]  = {"attack01"},
		-- 		[actor_status.as_stand]  = {"stand01"},
		-- 	},

		-- 	attackNodePos = 
		-- 	{
		-- 		x = 6.72,
		-- 		y = 34.42
		-- 	},

		-- 	aniAttackCallback = 
		-- 	{
		-- 		"WitchRed-attack01_13.png",
		-- 		"WitchRed-attack02_14.png",
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand01"] = {str = "WitchRed-stand01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["die"] = {str = "WitchRed-die_%s.png",startIndex = 0,endIndex = 27,time= 0.03 },
		-- 		["walk"] = {str = "WitchRed-walk_%s.png",startIndex = 0,endIndex = 23,time= 0.03 },
		-- 		["attack01"] = {str = "WitchRed-attack01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["attack02"] = {str = "WitchRed-attack02_%s.png",startIndex = 0,endIndex = 31,time= 0.03 },
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
					name = "CureTeammateGoal_Evaluator",
					regulator = 2,
				},
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