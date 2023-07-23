local conf = 
{
	id = 1019,
	oppId = 1020,
	name = "@SoldierWisardName",
	desc = "@SoldierWisardDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_wisard,
	radius = 15,
	showPriority = 5,
	cost = 14,
	CDTime = 5.5,
	icon = "icon_soldier_1013.png",
	team = actor_team.team_player,
	upID = 10010,
	population = 2,
	displayCSB = "UI/displayAni/displayAni1019.csb",

	regulators = 
	{
		{name = "triggerTestRegulator",time=8},
	},


	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "d4pixelicon64_7.png",displayName =  "@PropertyAttack",upAdd = "atk"},
		[3] = {com = "HealthComponent",icon="d6638pixekicon64_2311.png", displayName =  "@PropertyPhyDef",upAdd = "def",vName = "def"},
		[4] = {com = "WeaponSysComponent",icon = "d4342pixekicon64_239.png",displayName =  "@PropertyMagCure",upAdd = "magAtk"},
		[5] = {com = "HealthComponent",icon="d6649pixekicon64_2312.png", displayName =  "@PropertyMagDef",upAdd = "magDef",vName = "magDef"},
		[6] = {com = "MoveComponent",icon="d2331pixekicon64_234.png", displayName =  "@PropertySpeed",vName = "maxSpeed"},
		[7] = {com = "MoveComponent",icon="d2558attackRange.png", displayName = "@PropertyCureRange",vName = "cureRange"},
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
			maxSpeed = 60,
			heading = {x=1,y= 0},
			maxHeadTurnRate = 0.2,
			maxForce  = 0.1,
			fov = 45,
			cureRange = 200,
		},
		{
			name = "ProfressionComponent",
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
			csbPath = "UI/characters/WitchBlue.csb",
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
		-- 	pngPath = "UI/TextureUI/WitchBlue.png",
		-- 	defaultSp = "WitchBlue-stand01_00.png",

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
		-- 		"WitchBlue-attack01_13.png",
		-- 		"WitchBlue-attack02_14.png",
		-- 	},

		-- 	aniStrMap = 
		-- 	{
		-- 		["stand01"] = {str = "WitchBlue-stand01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["die"] = {str = "WitchBlue-die_%s.png",startIndex = 0,endIndex = 27,time= 0.03 },
		-- 		["walk"] = {str = "WitchBlue-walk_%s.png",startIndex = 0,endIndex = 23,time= 0.03 },
		-- 		["attack01"] = {str = "WitchBlue-attack01_%s.png",startIndex = 0,endIndex = 29,time= 0.03 },
		-- 		["attack02"] = {str = "WitchBlue-attack02_%s.png",startIndex = 0,endIndex = 31,time= 0.03 },
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