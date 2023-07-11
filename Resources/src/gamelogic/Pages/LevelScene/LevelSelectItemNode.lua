local LevelSelectItemNode = class("LevelSelectItemNode", ccui.Widget,_GModel.IBaseInterface,_GModel.IMsgInterface)
local ConstCfg = TWRequire("ConstCfg")

function LevelSelectItemNode:ctor(data)
	self._data = data

	self:load("UI/Pages/LevelScene/LevelSelectItemNode.csb")

	self:setNodeVisible("BGRed",data.team == actor_team.team_NPC)
	self:setNodeVisible("BGBlue",data.team == actor_team.team_player)

	self:setLabelText("TextLV",string.format("Lv%d",data.level))
	self:setSpriteFrame("icon",data.icon)

	self:setContentSize(180,180)

	self:setNodeVisible("PanelForBid",false)

	self:refershStars()
end

function LevelSelectItemNode:showForbiden(isShow)
	self:setNodeVisible("PanelForBid",isShow)
end

function LevelSelectItemNode:refershStars()
	local key    = "SoldierSkill_"..tostring(self._data.spId)
	local temp   = getPlayerSetting(key,SettingType.TYPE_INT,0)
	local starCount = tonumber(temp.Value)

	for i=1,ConstCfg.SKILL_STAR_COUNT do
		self:setNodeVisible(string.format("SkillStar%d",i),i<=starCount)
	end
end

return LevelSelectItemNode