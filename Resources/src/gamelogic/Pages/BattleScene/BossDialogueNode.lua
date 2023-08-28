local BossDialogueNode = class("BossDialogueNode", ccui.Widget,_GModel.IBaseInterface,_GModel.IMsgInterface)

function BossDialogueNode:ctor(data)
	self:load("UI/InGame/InGameDialogueBox.csb")
	self:setNodeVisibleLang("content")
end

return BossDialogueNode