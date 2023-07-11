local WeatherManager   = class("WeatherManager",_GModel.IManager)
local configManager    = TWRequire("ConfigDataManager")

function WeatherManager:_Init()
	self._curWeather = nil
	self._weatherCfg = {}
	self._createTime = 50
	self._nextCreateTime = math.random(self._createTime,self._createTime*1.5)+50
	self._isStartGame = false
end


function WeatherManager:onStartGame()
	self._weatherCfg = {}

	local levelInfo = _GModel.LevelManager:getCurLevelInfo()
	local weathers = levelInfo.weather
	
	if weathers and next(weathers) then
		for _,weatherId in ipairs(weathers) do
			local weatherInfo = configManager:getConfigById(weatherId)
			print("WeatherManager:onStartGame weatherInfo=")
			dump(weatherInfo)
			table.insert(self._weatherCfg,weatherInfo)
		end
	end

	self._isStartGame = true
end

function WeatherManager:onRestart()
	self._isStartGame = false
	self._nextCreateTime = math.random(self._createTime,self._createTime*1.5)
end

function WeatherManager:onGameOver()
	self._isStartGame = false
	self._weatherCfg = {}
end

function WeatherManager:_Update(dt)
	if not self._isStartGame then return end

	if not next(self._weatherCfg) then return end
	
	self._nextCreateTime = self._nextCreateTime - dt
	if self._nextCreateTime <= 0 then
		local len = #self._weatherCfg
		local index = math.random(1,len)
		local weatherInfo = self._weatherCfg[index]

		local pos = PlayerManager.getPlayerCenter()

		local data =
		{
			command = "createActorN",
			team = actor_team.team_none,
			id = weatherInfo.id,
			pos = pos,
			num=1,
			checkArea = false,
			checkAddToWorld = false,
		}
		
		local lifeTime = weatherInfo.ScriptComponents[1].lifeTime
		QueueEvent(EventType.ScriptEvent_ActorCommand,data)

		self._nextCreateTime = math.random(self._createTime,self._createTime*1.5) + lifeTime
	end
end

function WeatherManager:_Release()

end

return WeatherManager