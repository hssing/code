--[[--
飘字
]]

local FloatNum = class("FloatNum", function()
    return display.newNode()
end)

function FloatNum:ctor(params)
    self.data = params
    self:setCascadeOpacityEnabled(true)
    local fontName
    local hurtType = params.type
    local text
    local actionType = 1
    if hurtType == 1 then  --伤害
        fontName = res.font.FLOAT_NUM[1]
        local zh
        if params.value2 then 
            zh = params.value2
        else
            zh = params.value
        end
        text = cc.LabelAtlas:_create(zh.."",fontName,30,41,string.byte("."))
        self:addChild(text)
        local baseNumWidth = text:getContentSize().width
        text:setPosition(cc.p(-baseNumWidth/2, 0))
    elseif hurtType == 2 then  --回复
        fontName = res.font.FLOAT_NUM[2]
        text = cc.LabelAtlas:_create(params.value.."",fontName,30,41,string.byte("."))
        self:addChild(text)
        local baseNumWidth = text:getContentSize().width
        text:setPosition(cc.p(-baseNumWidth/2, 0))
    elseif hurtType == 3 then  --技能飘字
        fontName = "res/views/ui_res/imagefont/"..params.value..".png"
        text = display.newSprite(fontName)
        self:addChild(text)
        if params.value2 then
            actionType = 2
            local fUrl
            if params.value == "baoji" then
                fUrl = res.font.FLOAT_NUM[3]
            elseif params.value == "baoji2" then
                fUrl = res.font.FLOAT_NUM[2]
            elseif params.value == "gedang" then
                fUrl = res.font.FLOAT_NUM[7]
            end
            local zh
            if params.value3 then 
                zh = params.value3
            else
                zh = params.value2
            end
            local baojiTxt = cc.LabelAtlas:_create(zh.."",fUrl,30,41,string.byte("."))
            self:addChild(baojiTxt)
            local baseNumWidth = baojiTxt:getContentSize().width
            text:setPosition(0, 52)
            baojiTxt:setPosition(cc.p(-baseNumWidth/2, 0))
        end
    elseif hurtType == 4 then  --怒气
        local url
        local url2
        local node = display.newNode()
        self:addChild(node)
        if params.value > 0 then
            url = "nuqi_2"
            url2 = "res/views/ui_res/imagefont/jiahao.png"
            fontName = res.font.FLOAT_NUM[2]
        else
            fontName = res.font.FLOAT_NUM[1]
            url = "nuqi_1"
            url2 = "res/views/ui_res/imagefont/jianhao.png"
        end
        local num = cc.LabelAtlas:_create(math.abs(params.value).."",fontName,30,41,string.byte("."))
        num:setAnchorPoint(0.5,0.5)
        text = display.newSprite("res/views/ui_res/imagefont/"..url..".png")
        local fh = display.newSprite(url2)
        local size1 = text:getContentSize()
        local size2 = fh:getContentSize()
        local size3 = num:getContentSize()     
        text:setPosition(0,0)
        fh:setPosition((size1.width+size2.width)/2,0)
        num:setPosition((size1.width/2+size2.width+size3.width/2), 0)
        node:addChild(text)
        node:addChild(fh)
        node:addChild(num)
        node:setPositionX(-(size1.width+size2.width+size3.width)/2+size1.width/2)
    elseif hurtType == 5 then  --buff伤害
        local node = display.newNode()
        self:addChild(node)
        local fontName = res.font.FLOAT_NUM[1]
        local fontName2 = "res/views/ui_res/imagefont/buff"..params.value2..".png"
        local numTxt = cc.LabelAtlas:_create(params.value.."",fontName,30,41,string.byte("."))
        numTxt:setAnchorPoint(0.5,0.5)
        local text = display.newSprite(fontName2)
        local size1 = text:getContentSize()
        local size2 = numTxt:getContentSize()
        node:addChild(text)
        node:addChild(numTxt)
        text:setPosition(size1.width/2,0)
        numTxt:setPosition((size1.width+size2.width/2),0)
        node:setPositionX(-(size1.width+size2.width)/2)
    end
    
    if actionType==1 then
        self:_action_1()
    else
        self:_action_2()
    end
    
end

function FloatNum:_action_1()
    self:setScale(0.1)
    --移动21，放大1
    local move = cc.MoveBy:create(0.08,cc.p(0, 21))
    local scale = cc.ScaleTo:create(0.08,2)
    local spawn = cc.Spawn:create(move, scale)
    --移8，放大1.3
    local move1 = cc.MoveBy:create(0.08,cc.p(0, 8))
    local scale1 = cc.ScaleTo:create(0.08,1.5)
    local spawn1 = cc.Spawn:create(move1, scale1)
    --移动-8，缩小1.2
    local move2 = cc.MoveBy:create(0.1,cc.p(0, -8))
    local scale2 = cc.ScaleTo:create(0.05,1.5)
    local spawn2 = cc.Spawn:create(move2, scale2)
    --停顿延,0.2
    local delay = cc.DelayTime:create(0.6)
    --缩小0.2 渐变消失
    local scale3 = cc.ScaleTo:create(0.2,0.2)
    local fade = cc.FadeOut:create(0.2)
    local spawn4 = cc.Spawn:create(scale3, fade)
    --飘字结束回调
    local callFun = cc.CallFunc:create(function()
        local func = self.data.completeCall
        if func then
            func()
        end
        self:dispose()
    end)
    --动作执行
    local seq = cc.Sequence:create(spawn, spawn1, spawn2,delay, spawn4, callFun)
    self:runAction(seq)
end

function FloatNum:_action_2()
    self:setScale(0.2)
    --移动21，放大1
    local move = cc.MoveBy:create(0.08,cc.p(0, 21))
    local scale = cc.ScaleTo:create(0.08,2.5)
    local spawn = cc.Spawn:create(move, scale)
    --移8，放大1.3
    local move1 = cc.MoveBy:create(0.08,cc.p(0, 8))
    local scale1 = cc.ScaleTo:create(0.08,1.7)
    local spawn1 = cc.Spawn:create(move1, scale1)
    --移动-8，缩小1.2
    local move2 = cc.MoveBy:create(0.1,cc.p(0, -8))
    local scale2 = cc.ScaleTo:create(0.05,1.7)
    local spawn2 = cc.Spawn:create(move2, scale2)
    --停顿延,0.2
    local delay = cc.DelayTime:create(0.6)
    --缩小0.2 渐变消失
    local scale3 = cc.ScaleTo:create(0.2,0.2)
    local fade = cc.FadeOut:create(0.2)
    local spawn4 = cc.Spawn:create(scale3, fade)
    --飘字结束回调
    local callFun = cc.CallFunc:create(function()
        local func = self.data.completeCall
        if func then
            func()
        end
        self:dispose()
    end)
    --动作执行
    local seq = cc.Sequence:create(spawn, spawn1, spawn2,delay, spawn4, callFun)
    self:runAction(seq)
end

--销毁
function FloatNum:dispose()
    self:removeChild(self.baseNum)
    self:removeFromParent()
end

return FloatNum