local conf = 
{
	id = 1024,
	oppId = 1023,
	name = "@SoldierMasterWisardName",
	desc = "@SoldierMasterWisardDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_wisard_master,
	radius = 20,
	showPriority = 9,
	CDTime = 8,
	cost = 35,
	icon = "icon_soldier_1015.png",
	team = actor_team.team_NPC,
	population = 3,
	upID = 10012,

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
			"Knight_01_Dialogue_Darkness_Strikes_At_Night",
			"Knight_01_Dialogue_What_Is_Your_Wish_Questioning",
			"Knight_01_Dialogue_I_Stand_For_The_Light"
		}
	},

	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "d3371pixekicon64_238.png",displayName =  "@PropertyAttack",upAdd = "atk"},
		[3] = {com = "HealthComponent",icon="d6638pixekicon64_2311.png", displayName =  "@PropertyPhyDef",upAdd = "def",vName = "def"},
		[4] = {com = "WeaponSysComponent",icon = "d4342pixekicon64_239.png",displayName =  "@PropertyMagAttack",upAdd = "magAtk"},
		[5] = {com = "HealthComponent",icon="d6649pixekicon64_2312.png", displayName =  "@PropertyPhyDef",upAdd = "magDef",vName = "magDef"},
		[6] = {com = "MoveComponent",icon="d2331pixekicon64_234.png", displayName =  "@PropertySpeed",upAdd = "spd",vName = "maxSpeed"},
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
			name = "HealthComponent",
			maxHealth = 60,
			def = 1,
			magDef = 3,
		},
		{
			name = "VertexRenderComponent",
			hitFlashTime = 0.2,
			vextexCount = 4,
			vextexScale = 2,
			v1 = {x=-3,y=8},
			v2 = {x=3,y=10},
			v3 = {x=3,y=-10},
			v4 = {x=-3,y=-8},
		},
		{
			name = "MoveComponent",
			mass = 1,
			maxSpeed = 60,
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
				30141,
				3015
			}
		},

		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/MasterRed.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			attackIndex1 = 118,
			shootIndex1 = 180,

			animations =
			{
				[actor_status.as_alive]  = {"stand"},
				[actor_status.as_dead]   = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_attack] = {"attack01"},
				[actor_status.as_shoot]  = {"attack02"},
				[actor_status.as_stand]  = {"stand"},
			},
		},

		-- {
		-- 	name = "SpriteBatchAniComponent",
		-- 	pngPath = "UI/TextureUI/MasterRed.png",
		-- 	defaultSp = "MasterRed-stand_00.png",

		-- 	animations =
		-- 	{
		-- 		[actor_status.as_alive]  = {"stand"},
		-- 		[actor_status.as_dead]   = {"die"},
		-- 		[actor_status.as_moving] = {"walk"},
		-- 		[actor_status.as_attack] = {"attack01"},
		-- 		[actor_status.as_shoot]  = {"attack02"},
		-- 		[actor_status.as_stand]  = {"stand"},
		-- 	},

		-- 	attackNodePos = 
		-- 	{
		-- 		x = 34.16,
		-- 		y = 11.21
		-- 	},

		-- 	aniAttackCallback = 
		-- 	{
		-- 		"MasterRed-attack01_14.png",
		-- 		"MasterRed-attack02_11.png",
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand"] = {str = "MasterRed-stand_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["die"] = {str = "MasterRed-die_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["walk"] = {str = "MasterRed-walk_%s.png",startIndex = 0,endIndex = 23,time= 0.03 },
		-- 		["attack01"] = {str = "MasterRed-attack01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["attack02"] = {str = "MasterRed-attack02_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
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
					name = "AttackTargetGoal_Evaluator",
					regulator = 2,
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
				-- 	name = "GetHealthGoal_Evaluator",
				-- 	regulator = 2,

				-- },
				-- {
				-- 	name = "ExploreGoal_Evaluator",
				-- },
				-- {
				-- 	name = "CureTeammateGoal_Evaluator",
				-- 	regulator = 2,
				-- },
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