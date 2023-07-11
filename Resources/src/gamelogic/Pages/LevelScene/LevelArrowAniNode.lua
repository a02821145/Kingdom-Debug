local LevelArrowAniNode = class("LevelArrowAniNode",ccui.Widget,_GModel.IBaseInterface)

function LevelArrowAniNode:ctor()
	self:load("UI/buildings/curLevelArrow.csb")
	self:playTimeLine("start",true)
end

return LevelArrowAniNode