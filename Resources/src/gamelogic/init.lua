import ".TWApi"
import ".messageDefine"
import ".AppPrecedure"

function PreLoadPlist(loadingList)
	local str = cc.FileUtils:getInstance():getStringFromFile("res/preLoadList.lua")
	local fileList = loadstring(str)()
	local cache = cc.SpriteFrameCache:getInstance()

	for _,filePath in pairs(fileList) do

		local function PreLoadPlistSub()
			if not cache:isSpriteFramesWithFileLoaded(filePath) then
				print("PreLoadPlist addSpriteFrames filePath=",filePath)
				cache:addSpriteFrames(filePath)
			end
		end

		table.insert(loadingList,PreLoadPlistSub)
	end
end

function PreLoadUnLock()
	local temp = getPlayerSetting("initUnlock",SettingType.TYPE_BOOL,false)
	local isInitUnlock = temp.Value

	if not isInitUnlock then
		local str = cc.FileUtils:getInstance():getStringFromFile("res/config/InitUnLockIds.lua")
		local initUnLockList = loadstring(str)()

		for _,id in ipairs(initUnLockList) do
			setPlayerSetting("unit_unlock_"..tostring(id),SettingType.TYPE_BOOL,true)
		end

		setPlayerSetting("initUnlock",SettingType.TYPE_BOOL,true)
	end
end

function initGame(loadingList)
	
	local configManager = TWRequire("ConfigDataManager")

	configManager:load(loadingList)


	local function loadingStep2()
		ProjectileManager.loadProjectileConfig(configManager:getMod("Projectiles"))
		WeaponManager.loadWeaponConfig(configManager:getMod("Weapons"))
		ActorManager.loadActorCfg(configManager:getMod("Characters"))
		ActorManager.loadActorCfg(configManager:getMod("Objects"))
		ActorManager.loadActorCfg(configManager:getMod("Triggers"))
		ActorManager.loadActorCfg(configManager:getMod("Buildings"))
		ActorManager.loadActorCfg(configManager:getMod("GiftBoxs"))
		ActorManager.loadActorCfg(configManager:getMod("Traps"))
		ActorManager.loadActorCfg(configManager:getMod("Weathers"))
		ActorManager.loadActorCfg(configManager:getMod("Goldens"))
	end

	local function loadingStep3()
		SoundManager.loadSoundConfig(configManager:getMod("Sound"))
		SkillManager.loadSkillConfig(configManager:getMod("Skills"))
		PlayerManager.loadPlayerCfg(configManager:getMod("Player"))
		ShaderManager.loadShaderConfig(configManager:getMod("Shaders"))
		UpgradeManager.loadUpGradeConfig(configManager:getMod("Upgrade"))
		GiftboxManager.loadGiftBoxConfig(configManager:getMod("GiftBoxs"))
		BuffManager.loadBuffConfig(configManager:getMod("Buffs"))
		loadSoldierSkillCfg(configManager:getMod("SoldierSkill"))
		loadPlayerOpAICfg(configManager:getMod("PlayerOpAICfg"))
	end


	local function loadingStep4()
		loadRenderDebug(configManager:getMod("DebugRenderList"))
	end


	PreLoadPlist(loadingList)


	local function loadingStep6()
		PreLoadUnLock()

		local mgrCenter = TWRequire("ManagerCenter")
		mgrCenter:Enter()
	end


	--table.insert(loadingList,loadingStep1)
	table.insert(loadingList,loadingStep2)
	table.insert(loadingList,loadingStep3)
	table.insert(loadingList,loadingStep4)
	table.insert(loadingList,loadingStep6)
end
