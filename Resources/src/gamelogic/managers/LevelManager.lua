local LevelManager = class("LevelManager",_GModel.IManager)

function LevelManager:_Init()
	self.levels = {}
	self._forbidenList = {}

	local configManager = TWRequire("ConfigDataManager")
	local levels = configManager:getMod("Levels")

	for _,l in pairs(levels) do
		self.levels[l.name] = l
	end
end

function LevelManager:setCurLevel(level)
	self._curLevel = level
end

function LevelManager:getCurLevel()
	return self._curLevel
end

function LevelManager:getCurLevelInfo()
	return self:getLevelData(self._curLevel)
end

function LevelManager:getLevelData(level)
	local key = string.format("level%s",level)
	return self.levels[key]
end

function LevelManager:setForbidenUseList(forbidenList)
	self._forbidenList = forbidenList
end

function LevelManager:getForbiddenUseList()
	return self._forbidenList
end

function LevelManager:_Release()

end

return LevelManager