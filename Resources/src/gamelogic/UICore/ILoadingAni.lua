local ILoadingAni = class("ILoadingAni")

function ILoadingAni:initDoorNode()
	local leftDoor = self:getNode("DoorLeft")
	local rightDoor = self:getNode("DoorRight")

	leftDoor:setPosition(960,0)
	rightDoor:setPosition(960,0)
end

function ILoadingAni:PlayEndLoadingAnimatiopn( moveTime,callback )
    local leftDoor = self:getNode("DoorLeft")
    local rightDoor = self:getNode("DoorRight")

    leftDoor:setPosition(960,0)
    rightDoor:setPosition(960,0)

    local action = cc.MoveTo:create(moveTime, cc.p(0, 0))
    leftDoor:runAction(action)

    local act1 = cc.MoveTo:create(moveTime,cc.p(CC_DESIGN_RESOLUTION.width,0))
    local act2 = cc.CallFunc:create(function ()
        if callback then
            callback()
        end
    end)

    local action2 = cc.Sequence:create(act1,cc.DelayTime:create(0.2),act2)
    rightDoor:runAction(action2)

    QueueEvent(EventType.ScriptEvent_Sound,{id = "GUITransitionOpen"})

end

function ILoadingAni:PlayLoadingAnimation(moveTime,callback)
    local this = self
    local leftDoor = self:getNode("DoorLeft")
    local rightDoor = self:getNode("DoorRight")

    leftDoor:setPosition(0,0)
    rightDoor:setPosition(CC_DESIGN_RESOLUTION.width,0)

    local action = cc.MoveTo:create(moveTime, cc.p(960, 0))
    leftDoor:runAction(action)

    local act1 = cc.MoveTo:create(moveTime,cc.p(960,0))
    local act2 = cc.CallFunc:create(function ()
        if callback then
        	callback()
        end
    end)

    local action2 = cc.Sequence:create(act1,cc.DelayTime:create(0.2),act2)
    rightDoor:runAction(action2)

    QueueEvent(EventType.ScriptEvent_Sound,{id = "GUITransitionClose"})
end

return ILoadingAni