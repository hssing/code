--[[--
角色动作管理
]]

local PlayerActionMgr = class("PlayerActionMgr")

function PlayerActionMgr:ctor(player_)
    self._player = player_
    self._actionId = 0
    self._curAnction = nil
end

---------------------
---- public
---------------------

---------------------------
--切换状态
--@param id_  动作id
function PlayerActionMgr:changeAction(id_, params_)
    if id_==self._actionId then
        return
    end
    self._actionId = id_
    local player = self._player._bodyNode
    if self._curAnction then
        player:stopAction(self._curAnction)
    end
    if self:_specialAction(id_, params_) then
        return
    end
    local config = require("res.action."..id_.."")
    local info = config["info"]  --res.animation[id_..""]
    local rept = config["repeat"]
    local seqList = {}
    for i=1, #info do
        local spawnList = {}
        local frame = info[i]
        for j=1, #frame do
            local loc = frame[j]
            local type = loc["type"]
            local addSpeed 
            if loc["time"] then addSpeed = loc["time"] end
            local action
            if type == "scale" then
                local old = 1--self._player.pScale
                action = cc.ScaleTo:create(addSpeed,loc["value"][1]*old,loc["value"][2]*old)
            elseif type == "move" then
                action = cc.MoveTo:create(addSpeed,loc["value"])
            elseif type == "rotation" then
                action = cc.RotateTo:create(addSpeed,loc["value"])
            elseif type == "delay" then
                action = cc.DelayTime:create(addSpeed)
            elseif type == "trigger" then
                action = cc.CallFunc:create(function()
                    if params_ and params_.triggerCall then params_.triggerCall() end
                end)
            end
            table.insert(spawnList, action)
        end
        local spawn = cc.Spawn:create(spawnList)
        table.insert(seqList, spawn)
    end
    local callFun = cc.CallFunc:create(function()
        if rept ~= 1 then
            self._actionId = 0
            self._curAnction = nil
            self:changeAction(1001)
        end
        if params_ and params_.endCall then params_.endCall() end  --一个动作播放完成
    end)
    table.insert(seqList, callFun) 
    local seq = cc.Sequence:create(seqList)
    if rept == 1 then
        self._curAnction = cc.RepeatForever:create(seq)
    else
        self._curAnction = seq
    end
    player:runAction(self._curAnction) 
end


---------------------
---- private
---------------------

function PlayerActionMgr:_specialAction(id_, params_)
    if id_.."" == "1012" then
        self:_play1012(params_)
        return true
    elseif id_.."" == "1016" then
        self:_play1016(params_)
        return true
    elseif id_.."" == "1017" then
        self:_playe1017(params_)
        return true
    end
    return false
end

function PlayerActionMgr:_play1012(params_)
    local move = cc.MoveBy:create(0.1,cc.p(0, -310))
    local func = cc.CallFunc:create(function()
        if params_ and params_.endCall then params_.endCall() end
    end)
    if params_ and params_.triggerCall then params_.triggerCall() end
    local seq = cc.Sequence:create(move, func)
    self._player:runAction(seq)
end

function PlayerActionMgr:_play1016(params_)
    local node = self._player.body
    local r1 = cc.RotateTo:create(0.07,90)
    local r2 = cc.RotateTo:create(0.07,180)
    local r3 = cc.RotateTo:create(0.07,270)
    local r4 = cc.RotateTo:create(0.07,360)
    local func = cc.CallFunc:create(function()
        if params_ and params_.endCall then params_.endCall() end
        if params_ and params_.triggerCall then params_.triggerCall() end
    end) 
    local seq = cc.Sequence:create(func,r1,r2,r3,r4)
    node:runAction(seq)
end

---撞击动作
function PlayerActionMgr:_playe1017(params_)
    local node = self._player
    node:gotoTop()
    local tar = params_.tars[1].player
    local x1 = node:getPositionX()
    local y1 = node:getPositionY()
    local x2 = tar:getPositionX()
    local y2 = tar:getPositionY()
    local angle
    local offest
    if y2>y1 then
        offest = -50
        angle = 90-math.atan2((y2 - y1),(x2 - x1)) * 180 / math.pi
    else
        offest = 50
        angle = 90-math.atan2((y1 - y2),(x1 - x2)) * 180 / math.pi
    end
    --node:setRotation(angle)
    local scale = cc.ScaleTo:create(0.2,1.4)
    local move = cc.MoveBy:create(0.3,cc.p(0,offest))
    local rota = cc.RotateTo:create(0.02,angle)

    local move2 = cc.MoveTo:create(0.1,cc.p(x2, y2))
    local scale2 = cc.ScaleTo:create(0.1,1)
    local spawn = cc.Spawn:create(move2, scale2)

    local func = cc.CallFunc:create(function()
        if params_ and params_.triggerCall then params_.triggerCall() end
    end) 
    local move3 = cc.MoveBy:create(0.25,cc.p(0, -30))
    local rota2 = cc.RotateTo:create(0.02,0)
    local move4 = cc.MoveTo:create(0.1,cc.p(x1,y1))
    local func2 = cc.CallFunc:create(function()
        node:gotoBottom()
        if params_ and params_.endCall then params_.endCall() end
    end)
    local seq = cc.Sequence:create(scale, move, rota, spawn, func, move3, rota2, move4, func2)
    node:runAction(seq)
end

return PlayerActionMgr