local ItemManager = class("ItemManager",_GModel.IManager)

function ItemManager:_Init()
	gMessageManager:registerMessageHandler(MessageDef_GameLogic.Msg_OnItem_Event,handler(self,self.onItemEvent))
end

function ItemManager:onItemEvent(data)
	local id = data.id
	local cmd = "onItemEvent_"..id
	local callback = self[cmd]

	if callback then
		callback(self,data)
	end
end

function ItemManager:onItemEvent_Coins(data)
	local data1 = 
	{
		nodeName = "ItemAskNode",
		isShow = data.select
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)
end

function ItemManager:onItemEvent_Repair(data)
	local data1 = 
	{
		nodeName = "ItemAskNode",
		isShow = data.select
	}

	gMessageManager:sendMessageInstant(MessageDef_GameLogic.MSG_ShowSceneNode,data1)

	local params  = {
		type = actor_type.type_building,
		team = actor_team.team_player
	}

	local actors = ActorManager.GetActorsByType(params)
	if next(actors) then
		for _,id in ipairs(actors) do
			local targetActor = _GModel.sActorManager:getActorById(id)
			if targetActor then
				local isHurted = targetActor:sendMessageToComponentRet("HealthComponent","IsHurted","bool")
				if isHurted then
					targetActor:sendMessageToComponent("BuildingComponent","ShowFixNode",data.select)
				end
			end
		end
	end
end

function ItemManager:onItemEvent_100005(data)
	local itemCfg = _GModel.items[100005]

	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_AddEffect,{id = 7018, pos = data.pos})

	local params  = {
		radius = itemCfg.radius,
		pos = data.pos,
		type = actor_type.type_soilder,
		count = 8,
		team = actor_team.team_NPC
	}

	local actors = ActorManager.GetActorByRadius(params)

	if next(actors) then
		for _,id in ipairs(actors) do
			local targetActor = _GModel.sActorManager:getActorById(id)
			if targetActor then
				local oppCfgData = targetActor:getOppCfgData()
				local spineData = nil

				for _,com in ipairs(oppCfgData.components) do
					if com.name == "SpineComponent" then
						spineData = com
						break
					end
				end

				gMessageManager:sendMessage(MessageDef_GameLogic.MSG_AddEffect,{id = 7019, pos = targetActor:getPosition()})
				targetActor:sendMessageToComponent("SpineComponent","ChangeTeam",spineData.resJson,spineData.resAtlas,targetActor:GetReverseTeam())
			end
		end
	end
end

function ItemManager:onItemEvent_100002(data)
	local itemCfg = _GModel.items[100002]
	local pos = data.pos

	local params = {}
	local vMin = {}
	local vMax = {}
	vMin.x = pos.x - itemCfg.hWidth
	vMin.y = pos.y - itemCfg.hHeight

	vMax.x = pos.x + itemCfg.hWidth
	vMax.y = pos.y + itemCfg.hHeight

	params.min = vMin
	params.max = vMax

	local canPut = ActorManager.CheckCanPutRectObject(params)
	if canPut then
		QueueEvent(EventType.ScriptEvent_ActorCommand,{command="createActorN",team = actor_team.team_player,id= trap_type.trap_type_poison_road,pos=pos,num=1,checkArea=false,checkAddToWorld = false})
	else
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_AddEffect,{id = 7005, pos = pos})
		self:addItem(data.id)
	end
end

function ItemManager:addItem(id)
	local Key = "BackpackItem_"..tostring(id)
	local packageItemCount = getPlayerSetting(Key,SettingType.TYPE_INT,0)
	local count = packageItemCount.Value + 1
	setPlayerSetting(Key,SettingType.TYPE_INT,count)
end

function ItemManager:onItemEvent_100003(data)
	local itemCfg = _GModel.items[100003]
	local pos = data.pos

	local params = {}
	local vMin = {}
	local vMax = {}

	vMin.x = pos.x - itemCfg.range*0.5
	vMin.y = pos.y - itemCfg.range*0.5

	vMax.x = pos.x + itemCfg.range*0.5
	vMax.y = pos.y + itemCfg.range*0.5

	params.min = vMin
	params.max = vMax
	params.count = 128

	local posList = ActorManager.GetValidPosByRect(params)
	
	if next(posList) then
		for _,pos in pairs(posList) do
			QueueEvent(EventType.ScriptEvent_ActorCommand,{command="createActorN",team = actor_team.team_player,id= trap_type.trap_type_bomb_fire,pos=pos,num=1,checkArea=false,checkAddToWorld = false})
		end
	else
		gMessageManager:sendMessage(MessageDef_GameLogic.MSG_AddEffect,{id = 7005, pos = pos})
		self:addItem(data.id)
	end

	QueueEvent(EventType.ScriptEvent_Sound,{id = "Sound_ItemBombFire"})
end

function ItemManager:onItemEvent_100006(data)
	local itemCfg = _GModel.items[100006]
	local pos = data.pos
	local radius =  itemCfg.radius


	local function createWaterRain(newPos)
		QueueEvent(EventType.ScriptEvent_ActorCommand,{command="createActorN",team = actor_team.team_player,id= trap_type.trap_type_water_rain,pos=newPos,num=1,checkArea=false,checkAddToWorld = false})
	end

	math.randomseed(os.time())

	for i=1,itemCfg.rainCount do
		local newPosX = pos.x + math.random(-radius,radius)
		local newPosY = pos.y + math.random(-radius,radius)
		local newPos = cc.p(newPosX,newPosY)

		gRootManager:AddTimer(0.5*(i-1),false,createWaterRain,newPos)
	end
end


function ItemManager:onItemEvent_100007(data)
	local itemCfg = _GModel.items[100007]
	local pos = data.pos
	local radius =  itemCfg.radius
	local value = itemCfg.value

	local params  = {
		radius = itemCfg.radius,
		pos = data.pos,
		type = actor_type.type_soilder,
		count = 16,
		team = actor_team.team_player
	}

	local actors = ActorManager.GetActorByRadius(params)
	if actors and next(actors) then
		for _,id in pairs(actors) do
			local targetActor = _GModel.sActorManager:getActorById(id)
			if targetActor then
				local p1 = 
				{
					buffType = buff_type.buff_type_invincible,
					actorId = id,
					time = value,
				}

				BuffManager.AddBuffToActor(p1)
			end
		end
	end
end

function ItemManager:onItemEvent_100008(data)
	local itemCfg = _GModel.items[100008]
	local pos = data.pos
	local radius =  itemCfg.radius
	local value = itemCfg.value

	gMessageManager:sendMessage(MessageDef_GameLogic.MSG_AddEffect,{id = 7048, pos = pos})

	local function itemCallback()
		QueueEvent(EventType.ScriptEvent_Sound,{id = "Sound_Harmer_Thor"})
		
		local params  = {
			radius = itemCfg.radius,
			pos = data.pos,
			type = actor_type.type_soilder,
			count = 16,
			team = actor_team.team_NPC
		}

		local actors = ActorManager.GetActorByRadius(params)
		if actors and next(actors) then
			for _,id in pairs(actors) do
				local targetActor = _GModel.sActorManager:getActorById(id)
				if targetActor then
					local p1 = 
					{
						buffType = buff_type.buff_type_dizziness,
						actorId = id,
						time = value,
					}

					BuffManager.AddBuffToActor(p1)
				end
			end
		end
	end

	self:addTimer(0.5,itemCallback)
end

function ItemManager:_Update(dt)

end

function ItemManager:onStartGame()

end

function ItemManager:onGameOver()

end

function ItemManager:onRestart()

end

function ItemManager:_Update()

end

return ItemManager