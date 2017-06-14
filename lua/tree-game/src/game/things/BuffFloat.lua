--[[--
buff飘字
]]

local FloatNum = class("FloatNum", function()
    return display.newNode()
end)

function FloatNum:ctor(params)
    self:setCascadeOpacityEnabled(true)
    local fontName = "res/views/ui_res/imagefont/buff"..params.value..".png"
    local text = display.newSprite(fontName)
    self:addChild(text)
    --local baseNumWidth = text:getContentSize().width
    --text:setPosition(cc.p(-baseNumWidth/2, 0))
    self:_action_1()
end

function FloatNum:_action_1()
    self:setScale(0.1)
    local move = cc.MoveBy:create(0.08,cc.p(0, 21))
    local scale = cc.ScaleTo:create(0.08,1)
    local spawn = cc.Spawn:create(move, scale)

    local move1 = cc.MoveBy:create(0.08,cc.p(0, 8))
    local scale1 = cc.ScaleTo:create(0.08,1.3)
    local spawn1 = cc.Spawn:create(move1, scale1)

    local move2 = cc.MoveBy:create(0.05,cc.p(0, -8))
    local scale2 = cc.ScaleTo:create(0.05,1.2)
    local spawn2 = cc.Spawn:create(move2, scale2)

    local move3 = cc.MoveBy:create(0.04,cc.p(0, -8))
    local scale3 = cc.ScaleTo:create(0.04,1.2)
    local spawn3 = cc.Spawn:create(move3, scale3)

    local delay = cc.DelayTime:create(0.2)

    local move4 = cc.MoveBy:create(0.3,cc.p(0, 45))
    local fade = cc.FadeOut:create(0.3)
    local spawn4 = cc.Spawn:create(move4, fade)

    local callFun = cc.CallFunc:create(function()
        self:dispose()
    end)
    local seq = cc.Sequence:create(spawn, spawn1, spawn2, spawn3, delay, spawn4, callFun)
    self:runAction(seq)
end

--销毁
function FloatNum:dispose()
    self:removeFromParent()
end

return FloatNum