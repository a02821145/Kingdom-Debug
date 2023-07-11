local BasementScene = class("BasementScene", cc.load("mvc").ViewBase,_GModel.IBaseInterface,_GModel.IMsgInterface)

function BasementScene:onCreate()
	self:load("UI/Senes/BasementScene.csb")
end

function BasementScene:_init(data)
	self:InitUI()

	if data.playAni then
		 print("BasementScene:_init playAni")
		 self:setNodeVisible("LoadingNode",true)
   		 self:playTimeLine("endLoading",false)
	end
end

function BasementScene:InitUI()
	self:addBtnClickListener("btnback",self.onBtnBack)
end


function BasementScene:onBtnBack()
	local function GotoLevelScene()
		local params = { 
	        playAni = true
	    }

		gRootManager:ChangeScene("LevelScene",params)
	end

	self:playTimeLine("startLoading",false,GotoLevelScene)
end

return BasementScene