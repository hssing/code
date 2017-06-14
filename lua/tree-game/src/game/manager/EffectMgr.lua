--[[--
战斗角色
]]

local EffectMgr = class("EffectMgr")

---构造函数
function EffectMgr:ctor()

end

---------------------
---- public
---------------------

---------------------------
--播放技能效果
--@param  params 播放参数  retain=true,播放完毕不清理
-- {id=80000, x=0,y=0,addTo=nil,endCallFunc=nil,triggerFun=nil,loadComplete=nil,from=nil,to=nil, playIndex=0, retain=true}
function EffectMgr:playEffect(params) 
    local id = params.id..""
    local effConfig = conf.Effect:getInfoById(id)
    if not effConfig then
        print("无效果ID：", id)
    end 
    params.effConfig = effConfig
    local tarx = 0
    local tary = 0
    --效果层
    if not params.addTo then
        if effConfig.layer == 1 then  --角色上层
            params.addTo = params.from:getTopLayer()
        elseif effConfig.layer == 2 then --角色下层
            params.addTo = params.from:getBottomLayer()
        elseif effConfig.layer == 3 then --场景上层释放者下层
            params.addTo = self:_getFightScene():getPlayerLayer()
            tarx = params.from:getPositionX()
            tary = params.from:getPositionY()
        elseif effConfig.layer == 4 then --场景上层释放者上层
            params.addTo = self:_getFightScene():getTopLayer()
            tarx = params.from:getPositionX()
            tary = params.from:getPositionY()
        elseif effConfig.layer == 5 then --场景下层
            params.addTo = self:_getFightScene():getBottomLayer()
            tarx = params.from:getPositionX()
            tary = params.from:getPositionY()
        end
    end
    --效果坐标
    if not params.x and not params.y then
        if type(effConfig.pos) == "string" then  --配置点
            local to = conf.Skill:getFightPos(params.to[1]["tar"], effConfig.pos)
            params.x = to[1]
            params.y = to[2]
        elseif type(effConfig.pos) == "table" then  --偏移中心距离
            params.x = tarx + effConfig.pos[1]
            params.y = tary + effConfig.pos[2]
        else
            if effConfig.pos == 1 then  --脚下
                params.x = tarx
                params.y = tary
            elseif effConfig.pos == 2 then  --中心
                params.x = tarx
                params.y = params.from:getCenterH()+tary
            elseif effConfig.pos == 3 then  --头顶
                params.x = tarx
                params.y = params.from:getCenterH()*2+tary
            elseif effConfig.pos == 4 then  --敌方一排中心
                local key = params.to[1]["tar"]
                local h = params.to[1].player:getCenterH()
                local p = conf.Skill:getFightPos(key, "pos_2")
                params.x = p[1]
                params.y = p[2] + h
            elseif effConfig.pos == 5 then  --敌方纵排下面
                local key = params.to[1]["tar"]
                local p = conf.Skill:getFightPos(key, "pos_5")
                params.x = p[1]
                params.y = p[2]
            end
        end
    end
    self:_playCCS(params)
end

---销毁
function EffectMgr:dispose()
    
end

---------------------
---- private
---------------------

---------------------------
--播放效果
--@param  params 播放参数
function EffectMgr:_playCCS(arg_)
    local effName = arg_.effConfig.effect_id..""
    local function loadSuccess()
        local armature = ccs.Armature:create(effName)
        --效果播放动画轨
        if playspeed then 
            armature:getAnimation():setSpeedScale(playspeed)
        end 

        --是否切换动画轨[arg_.effConfig.play_index==1炽天使兽技能特殊处理]
        if arg_.effConfig and arg_.effConfig.play_index==1 then
            if (arg_.to[1]["tar"] <= 13 and arg_.to[1]["tar"]>=11) or (arg_.to[1]["tar"] <= 23 and arg_.to[1]["tar"]>=21) then
                armature:getAnimation():playWithIndex(arg_.effConfig.play_index)
            else
                armature:getAnimation():playWithIndex(0)
            end
        else
            if arg_.playIndex then
                armature:getAnimation():playWithIndex(arg_.playIndex)
            else
                armature:getAnimation():playWithIndex(0)
            end         
        end
        
        --是否执行回调，有父容器则执行
        local allowCall = false
        --效果的添加对象
        if arg_.addTo and not tolua.isnull(arg_.addTo) then
            allowCall = true
            local depth = arg_.depth or 10000
            arg_.addTo:addChild(armature, depth)
        end
        --效果name
        if arg_.addName then
            armature:setName(arg_.addName)
        end

        --效果坐标
        if arg_.x and arg_.y then
            armature:setPosition(arg_.x, arg_.y)
        end
        --旋转
        if arg_.Rotation then
            armature:setRotation(arg_.Rotation)
        end
        --缩放
        if arg_.effConfig.scale or arg_.scale then
            local s = arg_.scale or arg_.effConfig.scale
            armature:setScale(s)
        end
        --音效
        if arg_.effConfig.sound then
            mgr.Sound:playSound(arg_.effConfig.sound, false)
        end
        --轨迹效果
        local eType = arg_.effConfig.effect_type
        if eType and (eType==1 or eType==4) and arg_.to then
            --设置移动起点
            local p = arg_.to[1].player
            local x = p:getPositionX()
            local y
            if eType == 4 then
                local to = conf.Skill:getFightPos(arg_.to[1]["tar"], arg_.effConfig.effect_end)
                x = to[1]
                y = to[2]
            else
                y = p:getCenterH() + p:getPositionY()
            end
            --移动触发时间点
            local hurtcall = 1
            if arg_.effConfig.effect_trigger then
                hurtcall = arg_.effConfig.effect_trigger
            end
            --移除舞台
            local endFun = cc.CallFunc:create(function()           
                armature:removeFromParent()
            end)
            --移动触发时刻
            local hurtFun = cc.CallFunc:create(function()
                local trg = "hurt_call"
                if arg_.effConfig.trigger_fun ~= 1 then trg = "next_effect" end
                if arg_.triggerFun then arg_.triggerFun(trg, arg_.to, arg_.effConfig) end
            end)
            local angle = 90-math.atan2((y - arg_.y),(x - arg_.x)) * 180 / math.pi
            local dis = math.sqrt((y - arg_.y)*(y - arg_.y) + (x - arg_.x)*(x - arg_.x))
            local offsetY = arg_.effConfig.add_y or 0   --设置效果移动起始点
            local tx = offsetY/dis*(x - arg_.x)
            local ty = offsetY/dis*(y - arg_.y)
            local fromx = armature:getPositionX()
            local fromy = armature:getPositionY()
            armature:setPosition(fromx+tx,fromy+ty)
            --效果移动时间
            local time
            if arg_.effConfig.move_time then
                time = arg_.effConfig.move_time
            else
                armature:setRotation(angle)
                local disY = math.abs((y - arg_.y))
                time = disY/(1800)
            end
            local move = cc.MoveTo:create(time,cc.p(x,y))
            local delay = cc.DelayTime:create(time/hurtcall)
            local seq = cc.Sequence:create(move, endFun)
            local seq2 = cc.Sequence:create(delay, hurtFun)
            armature:runAction(seq2)
            armature:runAction(seq)
        end
        --效果镜像
        if arg_.effConfig.mirror then
            if arg_.to[1]["tar"] < 20 then --上打下镜像处理
                armature:setScaleY(-1)
            end
        end
        
        --加载完毕
        if arg_.loadComplete and allowCall then
            arg_.loadComplete(armature, arg_)
        end
        
        --TODO 触发帧回调
        armature:getAnimation():setFrameEventCallFunc(function(bone,event,originFrameIndex,intcurrentFrameIndex)
            if (arg_.triggerFun and allowCall) then arg_.triggerFun(event, arg_.to, arg_.effConfig) end
        end)
        
        --效果播放完毕
        armature:getAnimation():setMovementEventCallFunc(function(armature,movementType,movementID)
            if movementType == ccs.MovementEventType.complete then
                if (type(arg_.endCallFunc) == "function" and allowCall) then
                    arg_.endCallFunc(armature)
                end
                --清理
                if not arg_.retain then
                    armature:removeFromParent()
                end
                
            end
        end)
    end
    mgr.BoneLoad:addLoad(effName, loadSuccess)
end

---------------------------
--获取战斗场景
function EffectMgr:_getFightScene()
    return display.getRunningScene()
end

return EffectMgr