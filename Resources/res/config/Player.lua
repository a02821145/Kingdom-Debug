local Player = 
{
	id = 8001,

	moneyRegulator = 1,
	moneyGen = 1,

	timeCreateDog = 60,
	createCount = 6,
	
	AI=
	{
		lowRangeOfBias = 0.5,
 		highRangeOfBias = 1.5,

 		Evaluators=
 		{
 			{
				name = "CreateFarmer_Evaluator",
				regulator = 1,
				maxFarmer = 3,
				value = 45,
				ratio1 = 90,
				ratio2 = 30,
			},

			{
				name = "CreateSoldier_Evaluator",
				profression = actor_profession.prof_low_soldier,
				regulator = 0.2,
				maxNum = 15,
				maxCreateEveryTime = 4,
				minValue = 0.1,
				value = 1.8,
				CDTime = 4,
			},

			{
				name = "CreateSoldier_Evaluator",
				profression = actor_profession.prof_archer,
				regulator = 0.2,
				maxNum = 15,
				maxCreateEveryTime = 4,
				minValue = 0.1,
				value = 1.7,
				CDTime = 5,
			},

			{
				name = "CreateSoldier_Evaluator",
				profression = actor_profession.prof_infantryman,
				regulator = 0.2,
				maxNum = 15,
				maxCreateEveryTime = 3,
				minValue = 0.1,
				value = 1.6,
				CDTime = 6,
			},

			{
				name = "CreateSoldier_Evaluator",
				profression = actor_profession.prof_cavalier,
				regulator = 0.3,
				maxNum = 10,
				maxCreateEveryTime = 4,
				minValue = 0.1,
				value = 1.0,
				CDTime = 7,
			},

			{
				name = "CreateSoldier_Evaluator",
				profression = actor_profession.prof_thief,
				regulator = 0.2,
				maxNum = 10,
				maxCreateEveryTime = 2,
				minValue = 0.1,
				value = 0.95,
				CDTime = 5,
			},

			{
				name = "CreateSoldier_Evaluator",
				profression = actor_profession.prof_wisard,
				regulator = 0.2,
				maxNum = 1,
				maxCreateEveryTime = 2,
				minValue = 0.1,
				value = 0.09,
				CDTime = 5.5,
			},

			{
				name = "CreateSoldier_Evaluator",
				profression = actor_profession.prof_wisard_master,
				regulator = 0.2,
				maxNum = 1,
				maxCreateEveryTime = 2,
				minValue = 0.1,
				value = 0.09,
				CDTime = 8,
			},

			{
				name = "CreateSoldier_Evaluator",
				profression = actor_profession.prof_catapult,
				regulator = 0.2,
				maxNum = 1,
				maxCreateEveryTime = 1,
				minValue = 0.09,
				value = 0.08,
				CDTime = 30,
			},

			-- {
			-- 	name = "CreateDog_Evaluator",
			-- 	timeCreateDog = 60,
			-- 	createCount = 6,
			-- 	value = 50,
			-- },
			-- {
			-- 	name = "FireBuildingCannon_Evaluator",
			-- 	regulator = 1,
			-- }
 		}
	}
}

return Player