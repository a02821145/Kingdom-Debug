local BasementScene = class("BasementScene", cc.load("mvc").ViewBase,_GModel.IBaseInterface,_GModel.IMsgInterface)

function BasementScene:onCreate()
	self:load("UI/Senes/BasementScene.csb")
end

function BasementScene:_init(data)
	
end

return BasementScene