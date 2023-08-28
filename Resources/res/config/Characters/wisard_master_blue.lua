local conf = 
{
	id = 1023,
	oppId = 1024,
	name = "@SoldierMasterWisardName",
	desc = "@SoldierMasterWisardDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_wisard_master,
	radius = 20,
	showPriority = 9,
	CDTime = 8,
	cost = 35,
	icon = "icon_soldier_1015.png",
	team = actor_team.team_player,
	upID = 10012,
	population = 3,
	isRemote = true,
	displayCSB = "UI/displayAni/displayAni1023.csb",

	regulators = 
	{
		{name = "triggerTestRegulator",time=8},
	},

	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "d3371pixekicon64_238.png",displayName =  "@PropertyAttack",upAdd = "atk"},
		[3] = {com = "HealthComponent",icon="d6638pixekicon64_2311.png", displayName =  "@PropertyPhyDef",upAdd = "def",vName = "def"},
		[4] = {com = "WeaponSysComponent",icon = "d4342pixekicon64_239.png",displayName =  "@PropertyMagAttack",upAdd = "magAtk"},
		[5] = {com = "HealthComponent",icon="d6649pixekicon64_2312.png", displayName =  "@PropertyMagDef",upAdd = "magDef",vName = "magDef"},
		[6] = {com = "MoveComponent",icon="d2331pixekicon64_234.png", displayName =  "@PropertySpeed",vName = "maxSpeed"},
		[7] = {com = "MemoryComponent",icon="d2558attackRange.png", displayName =  "@PropertyAttackRange",vName = "ViewDistance"},
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

	components = 
	{

		{
			name = "TeamComponent",
			team = actor_team.team_player,
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
			v1 = {x=-3,y=8},
			v2 = {x=3,y=10},
			v3 = {x=3,y=-10},
			v4 = {x=-3,y=-8},
		},
		{
			name = "MoveComponent",
			mass = 1,
			maxSpeed = 90,
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

			AttackPriority=
			{
				[1] = EAttackPriotry.AttackPriotryMeleeUnit,
				[2] = EAttackPriotry.AttackPriotryDist
			},
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
				3014,
				3015
			}
		},

		{
			name = "ProfressionComponent",
		},
		
		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/MasterBlue.csb",
			pngPath = "UI/TextureUI/SoldierAll.png",
			attackIndex1 = 118,
			shootIndex1 = 180,

			animations =
			{
				[actor_status.as_alive]  = {"stand"},
				[actor_status.as_dead]   = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_attack] = {"attack1"},
				[actor_status.as_shoot]  = {"shoot1"},
				[actor_status.as_stand]  = {"stand"},
			},
		},

		-- {
		-- 	name = "SpriteBatchAniComponent",
		-- 	pngPath = "UI/TextureUI/MasterBlue.png",
		-- 	defaultSp = "MasterBlue-stand_00.png",

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
		-- 		"MasterBlue-attack01_14.png",
		-- 		"MasterBlue-attack02_11.png",
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand"] = {str = "MasterBlue-stand_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["die"] = {str = "MasterBlue-die_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["walk"] = {str = "MasterBlue-walk_%s.png",startIndex = 0,endIndex = 23,time= 0.03 },
		-- 		["attack01"] = {str = "MasterBlue-attack01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["attack02"] = {str = "MasterBlue-attack02_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
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