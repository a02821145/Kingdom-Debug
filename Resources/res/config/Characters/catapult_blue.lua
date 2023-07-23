local conf = 
{
	id = 1025,
	oppId = 1026,
	name = "@SoldierCatapultName",
	desc = "@SoldierCatapultDesc",
	type = actor_type.type_soilder,
	profession = actor_profession.prof_catapult,
	radius = 30,
	showPriority = 10,
	CDTime = 30,
	cost = 50,
	icon = "buliding_icon_catapult.png",
	team = actor_team.team_player,
	upID = 10013,
	population = 5,
	displayCSB = "UI/displayAni/displayAni1025.csb",

	regulators = 
	{
		{name = "triggerTestRegulator",time=8},
	},

	displayProperty = 
	{
		[1] = {com = "HealthComponent",icon = "d2323pixekicon64_233.png",displayName =  "@PropertyHealth",vName = "maxHealth",upAdd = "healthAdd"},
		[2] = {com = "WeaponSysComponent",icon = "pixelicon64_33.png",displayName =  "@PropertyAttack",upAdd = "atk"},
		[3] = {com = "HealthComponent",icon="d6638pixekicon64_2311.png", displayName =  "@PropertyPhyDef",upAdd = "def",vName = "def"},
		[4] = {com = "MoveComponent",icon="d2331pixekicon64_234.png", displayName =  "@PropertySpeed",vName = "maxSpeed"},
		[5] = {com = "MemoryComponent",icon="d2558attackRange.png", displayName =  "@PropertyAttackRange",vName = "ViewDistance"},
	},


	sounds = 
	{
		die = 
		{
			"Sound_Catapult_Broken",
		},
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
			maxHealth = 50,
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
			maxSpeed = 45,
			heading = {x=1,y= 0},
			maxHeadTurnRate = 0.2,
			maxForce  = 0.1,
			fov = 45,
		},
		{
			name = "MemoryComponent",
			ViewDistance = 480,
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
				3019,
			}
		},

		{
			name = "SpriteAniComponent",
			csbPath = "UI/characters/CatapultBlue.csb",
			pngPath = "UI/TextureUI/CatapultAni.png",
			attackIndex1 = 41,
			isEightDir = true,

			animations =
			{
				[actor_status.as_alive]  = {"stand"},
				[actor_status.as_dead]   = {"die"},
				[actor_status.as_moving] = {"walk"},
				[actor_status.as_attack] = {"attack"},
				[actor_status.as_stand]  = {"stand"},
			},
		},

		{
			name = "BrainComponent",
			lowRangeOfBias = 0.5,
			highRangeOfBias = 1.5,
			regulator = 4,

			Evaluators = 
			{
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