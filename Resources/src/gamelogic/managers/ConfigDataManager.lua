local configDataManager = class("configDataManager")
local StringUtil = TWRequire("StringUtil")

function configDataManager:ctor()
	self.modList = {}
	self.idPathMap = {}
	self.modMap = {}
end

function configDataManager:Instance()
	if self.instance == nil then
		self.instance = self:new()
	end

	return self.instance
end

function configDataManager:load(loadingList)
	local fileUtils = cc.FileUtils:getInstance()
	local str = fileUtils:getStringFromFile("res/configPathList.lua")
	local configList = loadstring(str)()

	self.idPathMap = {}
	local idConfigMap = {}

	for _,configPath in pairs(configList) do
		local function loadSingleCfg()
			print("configDataManager:load configPath=",configPath)
			local str = fileUtils:getStringFromFile(configPath)
			local pathArray = string.split(configPath,'/')
			local config = assert(loadstring(str))()
			local pathLen = #pathArray

			if config == nil then
				LogError("failed to load config file %s ",configPath)
			end

			if config.id then
				local fullPath = fileUtils:fullPathForFilename(configPath)

				if idConfigMap[config.id] then
					LogError("duplicate id %d %s %s ",config.id,config.name,idConfigMap[config.id].name)
				end

				self.idPathMap[config.id] = fullPath
				idConfigMap[config.id] = config
			end

			if pathLen > 2 then
				modName = pathArray[pathLen-1]
				self.modList[modName] = self.modList[modName] or {}
				table.insert(self.modList[modName],config)
			else
				modName = pathArray[pathLen]
				modName = StringUtil:stripExtension(modName)
				self.modList[modName] = config
			end

			if _GModel then
				local filename = pathArray[pathLen]
				filename = StringUtil:stripExtension(filename)
				rawset(_GModel,filename,config)
			end
		end

		table.insert(loadingList,loadSingleCfg)
	end

	table.insert(loadingList,function()
		self.modMap = idConfigMap
	end)
end

function configDataManager:saveConfig(config)
	if not config.id then
		LogError("configDataManager:saveConfig coz not id param")
		return
	end

	local path = self.idPathMap[config.id]
	if path then
		local configStr = table.serialize(config)
		local fileUtils = cc.FileUtils:getInstance()
		fileUtils:writeStringToFile(configStr,path)
	else
		LogError("configDataManager:saveConfig coz not path not found")
	end
end

function configDataManager:getMod(modName)
	return self.modList[modName]
end

function configDataManager:getConfigById(id)
	return self.modMap[id]
end

function configDataManager:getModByProperty(modName,key,value)
	if not key or not value then
		return {}
	end

	local mods = {}

	local tempMod = self:getMod(modName)
	for _,m in ipairs(tempMod) do
		if m[key] and m[key] == value then
			table.insert(mods,m)
		end
	end

	return mods
end

return configDataManager:Instance()