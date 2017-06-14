--[[--
战斗系统
]]
local Player = require("game.things.Player")
local scheduler = require("framework.scheduler")
local FightMgr = class("FightMgr")
local FloatNum = require("game.things.FloatNum")
local BuffFloat = require("game.things.BuffFloat")

function FightMgr:ctor()
    self:_init()
end

function FightMgr:_init()
    self._players       = {}      --战斗中的角色
    self._curCombatInfo = {}     --当前战斗所有信息
    self._combatList    = {}      --每次战斗队列
    self._curCursor     = 0       --当前游标
    self._curStep       = 1       --当前步数
    self.isJump         = false   --战斗状态
    self.hurtIndex      = 0

    self._skillEndState = false
    self._actionEndState = false
    self._shakeState = false
    self._skillMoveState = false  --标识该技能是否移动释放
    self._deathList = {}  --死亡列表
    --buff 容器
    self._buffList = {}
    self._buffEff = {}
end

---------------------
---- public
---------------------
function FightMgr:dispose()
    for key, value in pairs(self._players) do
        value:removeSelf()
    end
    self._players = {}
end

---------------------------
--进入战斗播报
--@param info_战斗信息
function FightMgr:enterFight()
    self:_init()
    local info_ = cache.Fight:getFightReport() or cache.Fight.data
    local enemy = info_["targetArmy"]
    local player = info_["selfArmy"]
    local initNum = 0
    --初始化底盘
    self:_getFightScene():addBottomPlate(enemy, player)
        
    --上阵
    local function endCallFun()
        initNum = initNum + 1
        if initNum == #enemy+#player then
            self:_getFightScene():fightStart({data=info_, endCallFunc=function()
                --战斗播报
                if self.isJump==false then
                    self._curCombatInfo = info_["bouts"]
                    self:_combatProcess()
                end
            end})
        end
    end  
    local layer = self:_getFightScene():getPlayerLayer()    
    for i=1,#enemy do
        local data = enemy[i]
        local pos = conf.Skill:getPlayerPos(data.index)
        local id = conf.Card:getModel(data.mid)
        local e = Player.new(id.."")
        e:thingScale(id.."")
        e:setInfo(data)
        layer:addChild(e)
        self._players[data.index..""] = e
        e:setPos(pos[1],pos[2])
        local player = e._bodyNode
        player:setScaleX(0)
        e:playAction(1018,{endCall=endCallFun, triggerCall=function()
            self:_getFightScene():plateShake(data.index)
        end})
    end 
    for i=1,#player do
        local data = player[i]
        local pos = conf.Skill:getPlayerPos(data.index)
        local id = conf.Card:getModel(data.mid)
        local p = Player.new(id.."")
        p:setInfo(data)
        layer:addChild(p)
        self._players[data.index..""] = p
        p:setPos(pos[1],pos[2])
        local player = p._bodyNode
        player:setScaleX(0)
        p:playAction(1018,{endCall=endCallFun, triggerCall=function()
            self:_getFightScene():plateShake(data.index)
        end})    
    end
end

function FightMgr:getPlayer(key_)
    local p = self._players[key_..""]
    if p then
        return p
    end
    return nil
end

---------------------
---- private
---------------------

---------------------------
--获取当前战斗
function FightMgr:_getAtk()
    local data = self._curCombatInfo[self._curCursor]
    return data["atk"]
end

---------------------------
-- step1：当前技能数据
function FightMgr:_combatProcess()
    self._curCursor = self._curCursor + 1
    if #self._curCombatInfo >= self._curCursor then
        local data = self._curCombatInfo[self._curCursor]
        self._curStep = 1  --当前战斗编号
        self.fightInfo = data  --当前战斗数据
        self.atkTar = self:getPlayer(data["atk"])  --当前攻击者
        self.skillInfo = conf.Skill:getInfoById(data["skillId"])  --当前战斗技能数据
        self._combatList = data["targets"]  --当前战斗过程
        --更新回合数
        self:_getFightScene():updateHuiHe(data["bout"])
        --计算buff的伤害--如果获得buff伤害死亡则终止
        local hurtBuffParams = {tar=data["atk"], buff=data["buffHurt"]or{}}
        local record = self:_hurtBuff(hurtBuffParams)
        --新手战斗表现
        if self:_guideFight() == true then
            record = 0
        end
        --每轮战斗间隔
        if record == 0 then
            return
        else
            local nextDelay = cc.DelayTime:create(record)
            local nextCall = cc.CallFunc:create(function()
                self:_startFight()
            end)
            self.atkTar:runAction(cc.Sequence:create(nextDelay, nextCall))
        end  
    else
        --TODO  战斗结束
        if fight_test==true then
            self._combatList = {}
            self._curStep = 1
            self._curCursor = 0
            self:_combatProcess()
        elseif fight_guide == true then
            fight_guide = false
            mgr.SceneMgr:LoadingScene(_scenename.ROLE,{completeCallFun= function()
                local view = mgr.ViewMgr:get(_viewname.CREATE_ROLE)
                view:FightOver()
            end})
        else
            self:fightEnd()
        end  
    end   
end

---战斗结束
function FightMgr:fightEnd()
    self._combatList = {}
    --self._curStep = 1
    --self._curCursor = 0
    self:_getFightScene():fightResult()
end

function FightMgr:_startFight()
    --攻击者获得buff
    local data = self.fightInfo
    local buffParams = {tar=data["atk"], buffs=data["buffs"]or{}}
    self:_addFightBuff(buffParams,1)

    --------------------------------打印输出
    local tars = "{"
    for i=1, #self._combatList do
        tars = tars..self._combatList[i]["tar"].."->伤害:"
        for key,value in pairs(self._combatList[i].hurts) do
            if key ~= "_size" then
                tars = tars.."["..key.."]:"..value..","
            end             
        end
        tars = tars.."|"
    end
    local hurt
    tars = tars.."}"
    print("战斗["..self._curCursor.."]：".."对象："..data["atk"]..",".."目标："..tars)
    --------------------------------

    if self.isJump then
        self:enterJump()
    else
        self:_combatStep()
    end
end

---------------------------
-- step2：释放技能
function FightMgr:_combatStep()
    ---------------------------------------------------------------------受到buff控制
    if #self._combatList == 0 then --无战斗过程则跳到下一个
        --清除出手对象的buff
        self:_updateBuff(self.fightInfo["atk"], 1)
        self:_combatProcess()
        return 
    end
    ---------------------------------------------------------------------
    if #self._combatList >= self._curStep then
        local call__ = function()
            local skill = self.skillInfo
            local skillTars = {}
            local skillNum = skill.skill_num
            for i=1,skillNum do
                local data = self._combatList[self._curStep] ---{["tar"]=23,["hurt"]=132,["buff"]={1000}}
                data.player = self._players[data["tar"]..""]
                table.insert(skillTars, data)
                self._curStep = self._curStep + 1
                if self._curStep > #self._combatList then
                    break
                end
            end
            self._fightCount = #skillTars
            self._shakeState = true
            self.atkTar:stopAllActions()
            local eId = self.skillInfo.attack_effect
            self:_effectTrigger(skillTars,eId)
        end
        
        if self.skillInfo.anger < 0 then  --怒气技能
            self:_updateAnger()
            local id = self.atkTar:getCardId()
            print("id 音效。。数码兽"..id)
            local sound = conf.Card:getSpeak(id)
            if sound then
                mgr.Sound:playSound(sound,false)
                local delay = cc.DelayTime:create(0.6)
                local callFun = cc.CallFunc:create(call__)
                self.atkTar:runAction(cc.Sequence:create(delay, callFun))
            else
                call__()
            end
        else
            call__()
        end         
    else
        ---TODO 本次技能释放完毕
        self:_skillEnd()
    end        
end

---------------------------
--角色回到底盘---移动战斗
function FightMgr:_back()
    if self._skillMoveState == true then
        self._skillMoveState = false
        local atk = self:_getAtk()
        local to = conf.Skill:getPlayerPos(atk)
        local curX = self.atkTar:getPositionX()
        local curY = self.atkTar:getPositionY()
        if curX~=to[1] or curY~=to[2] then
            self:_moveToPrepare({curX, curY},to,false)
        end       
    end     
end

---------------------------
--技能释放完毕
function FightMgr:_skillEnd()
    --技能状态
    self._skillEndState = true
    --移除技能黑屏
    self:_checkNextSkill()
end
---------------------------
--技能动作完毕
function FightMgr:_skillActionEnd()
    local atk = self:_getAtk()
    self.atkTar:gotoBottom()  --还原层
    self.atkTar:playAction(player_action.back_fall)  --回来动作
    
    --更新buff
    self:_updateBuff(self.fightInfo["atk"], 1)
    
    --攻击者获得buff
    local buffParams = {tar=self.fightInfo["atk"], buffs=self.fightInfo["buffs"]or{}}
    self:_addFightBuff(buffParams,2)
    
    
    --更新怒气
    if self.skillInfo.anger > 0 then
        self:_updateAnger()
    end
    --底盘抖动
    self:_getFightScene():plateShake(atk, function()
        self.atkTar:playAction(player_action.idle)
        self._actionEndState = true
        self:_checkNextSkill()
    end)
end
---------------------------
--更新怒气
function FightMgr:_updateAnger()
    local atk = self:_getAtk()
    local num = self.skillInfo.anger or 0
    local anger = self.atkTar:updateAnger(num)
    self:_getFightScene():plateUpdateInfo({tar=atk,type=2, count=anger})
end

---------------------------
--检查是否可以进入下个技能
function FightMgr:_checkNextSkill()
	if self._skillEndState == true and self._actionEndState == true then
	   self:_combatProcess()
	   self._skillEndState = false
	   self._actionEndState = false
	end
end

function FightMgr:_effectTrigger(skillTars_, effId_)
    local effConfig = conf.Effect:getInfoById(effId_)
    if effConfig.player_pos then
        self._skillMoveState = true
        local bat = skillTars_[1]
        local to = conf.Skill:getFightPos(bat["tar"], effConfig.player_pos)
        local atk = self:_getAtk()
        local from = conf.Skill:getPlayerPos(atk)
        self:_moveToPrepare(from,to,true,function()
            self:_effectAction(skillTars_, effConfig)
            if to[1] < 0 or to[1]>640 then
                self.atkTar:setPositionX(640-to[1])
            end
        end)
        if self.skillInfo.depth==1 then
            self.atkTar:gotoTop()
        else
            if atk > 20 then
                self.atkTar:gotoCenter()  
            end
        end
    else
        self:_effectAction(skillTars_, effConfig)
    end
    if effConfig.black then  --释放黑屏
        self:_getFightScene():blackScene()
    end
end

---------------------------
--角色移动
--@param from---to  移动的坐标
--@param dir_ true向上移动，false向下移动
--@params moveComplete_ 移动完成
function FightMgr:_moveToPrepare(from_, to_, dir_, prepareComplete_)
    local mid
    local action
    local m = math.abs(to_[2] - from_[2])/2
    if dir_ then
        local atk = self:_getAtk()
        if atk < 20 then
            mid = cc.p(from_[1], to_[2]-m)
        else
            mid = cc.p(to_[1], to_[2]+m)
        end
        action = player_action.atk_fall
    else
        mid = cc.p(to_[1], to_[2]+m)
        action = player_action.back_fall
    end
    local bezier = {
        cc.p(from_[1], from_[2]),
        mid,
        cc.p(to_[1], to_[2]),
    }
    local dis = math.sqrt((to_[2] - from_[2])*(to_[2] - from_[2]) + (to_[1] - from_[1])*(to_[1] - from_[1]))
    local time = dis/(1300+dis)
    local addSpeed = (time)
    local bezierForward = cc.BezierTo:create(addSpeed, bezier)
    local callFun = cc.CallFunc:create(function()
        if dir_ then
            self.atkTar:playAction(action)
            local delay = cc.DelayTime:create(0.12)
            local callFun = cc.CallFunc:create(function()
                prepareComplete_()
            end)
            self.atkTar:runAction(cc.Sequence:create(delay, callFun))
        else
            self:_skillActionEnd()
        end
    end)
    local seq = cc.Sequence:create(bezierForward, callFun)
    local addSpeed = (time/2)
    local scale1 = cc.ScaleTo:create(addSpeed,1.5)
    local scale2 = cc.ScaleTo:create(addSpeed,1)
    local seq1 = cc.Sequence:create(scale1, scale2)
    self.atkTar:showFilter(11)
    self.atkTar:runAction(cc.Spawn:create(seq, seq1))
end

function FightMgr:_effectAction(skillTars_, effConf_)
    self.multiIndex = 1  --记录连续攻击， 
    --TODO 动作触发帧回调函数
    local effectPlay___ = function()
        if effConf_.multi then
            local atkNum = effConf_.multi
            local tarNum = #self._combatList/atkNum
            local tars = {}
            for i=1, tarNum do
                local index = atkNum*(i-1) + self.multiIndex
                local data = skillTars_[index]
                table.insert(tars, data)
            end        
            self:_effectPlay(tars,effConf_)
            self.multiIndex = self.multiIndex + 1
        else
            self:_effectPlay(skillTars_,effConf_)
        end    
    end
    --TODO 动作完成回调
    local _effectEndCall = function()
        if effConf_.is_end then
            self:_skillActionEnd()
        end
    end
    --效果动作
    if effConf_.action then
        local action
        if type(effConf_.action) == "table" then  --需要切换动作
            if self:_getAtk() > 20 then
                action = effConf_.action[2]..""
            else
                action = effConf_.action[1]..""
            end
        else
            action = effConf_.action..""
        end
        local params = {endCall=_effectEndCall, triggerCall=effectPlay___, tars=skillTars_}
        self.atkTar:playAction(action,params)
    else
        effectPlay___()
    end
end

function FightMgr:_effectPlay(skillTars_, effConf_)
    local playIndex__ = 0
    if effConf_.play_index == 10 then
        playIndex__ = self.multiIndex-1
    end
    local eId = effConf_.id
    if effConf_.effect_type == 1 then  --路径效果
        for i=1, #skillTars_ do
            local params = {id=eId,playIndex=playIndex__,from=self.atkTar,to={skillTars_[i]},triggerFun=function(tars_, effConf_)
                self:_triggerCallFunc(tars_, effConf_)
            end}
            mgr.effect:playEffect(params)
        end
    elseif effConf_.effect_type == 2 or effConf_.effect_type == 4 then  --释放者效果
        local params = {id=eId,playIndex=playIndex__,from=self.atkTar,to=skillTars_,triggerFun=function(type_, tars_, effConf_)
            self:_triggerCallFunc(type_, tars_, effConf_)
        end}
        mgr.effect:playEffect(params)
    elseif effConf_.effect_type == 3 then  --受击者效果 
        for i=1, #skillTars_ do
            local params = {id=eId,playIndex=playIndex__,from=skillTars_[i].player,to={skillTars_[i]},triggerFun=function(type_, tars_, effConf_)
                self:_triggerCallFunc(type_, tars_, effConf_)
            end}
            mgr.effect:playEffect(params)
        end
     elseif effConf_.effect_type == 5 then  --无特效，直接受击
        self:_smitten(skillTars_)
     end
end

---------------------------
--效果触发帧回调
function FightMgr:_triggerCallFunc(type_, tars_, effConf_)
    if type_ == "hurt_call" then
        self:_smitten(tars_)
    elseif type_ == "next_effect" then
        self:_effectTrigger(tars_, effConf_.trigger_fun)
    elseif type_ == "end_call" then  --TODO 此事件暂时取消使用
    elseif type_ == "back_call" then
        self:_back()
    elseif type_ == "hit_action_call" then
        self:_hitAction(tars_, 1)
    elseif type_ == "hit_action_end" then
        self:_hitAction(tars_, 2)
    end
end

function FightMgr:_hitAction(tars_, type_)
    --浮空
    for i=1, #tars_ do
        local p = tars_[i].player
        local action
        if type_ == 1 then
            action = cc.MoveBy:create(1,cc.p(0, 60))
        elseif type_ == 2 then
            local move = cc.MoveBy:create(0.05,cc.p(0,-60))
            local callFunc = cc.CallFunc:create(function()
                self:_smitten({tars_[i]})
            end)
            action = cc.Sequence:create(move, callFunc)
        end       
        p:runAction(action)
    end
end

---------------------------
--效果完成回调
function FightMgr:_endCallFunc()
    if self._fightCount<= 0 then
        if self.skillInfo.delay then
            local delay = cc.DelayTime:create(self.skillInfo.delay)
            local callFunc = cc.CallFunc:create(function()
                self:_back()
                self:_checkDeath(function()
                    self:_combatStep()
                end)
            end)
            local seq = cc.Sequence:create(delay, callFunc)
            self.atkTar:runAction(seq)
        end
    end
end

---------------------------
--目标受击
--@param tars 受击目标数组
function FightMgr:_smitten(tars_)
    local hurdId = self.skillInfo.smitten_effect
    local hasBaoji = false
    for i=1, #tars_ do
        --受击伤害数据  
        local skillType = self:_hurt(tars_[i])
        self.hurtIndex = self.hurtIndex + 1
        --受击目标获得buff
        self:_addBuff(tars_[i])
        
        
        --受击效果  --部分技能无受击效果
        self._fightCount = self._fightCount - 1
        self:_endCallFunc()       
        local p = tars_[i].player
        if hurdId and skillType ~= 2 and skillType ~= 3 and skillType~=5 and skillType~=99 then
            local params = {id=hurdId[1],from=p,playIndex=hurdId[2]}
            mgr.effect:playEffect(params)
        end
        
        --受击动作，回复无受击动作
        if p then
            if skillType == 1 then  --通用受击
                if tars_[i]["tar"]>=11 and tars_[i]["tar"]<=16 then
                    p:playAction(1007)
                else
                    p:playAction(1006)
                end
                p:showFilter(7)--受击高亮     
            elseif skillType == 2 then  --闪避受击
                if tars_[i]["tar"]>=11 and tars_[i]["tar"]<=16 then
                    p:playAction(1026)
                else
                    p:playAction(1025)
                end
                p:showFilter(10, 0.36)--受击高亮
            elseif skillType == 3 then  --暴击
                hasBaoji = true
                local params = {id=404175,from=p}
                mgr.effect:playEffect(params)
                if tars_[i]["tar"]>=11 and tars_[i]["tar"]<=16 then
                    p:playAction(1007)
                else
                    p:playAction(1006)
                end
                p:showFilter(7)
            elseif skillType == 5 then  --格挡
                local params = {id=404176,from=p}
                mgr.effect:playEffect(params) 

                if tars_[i]["tar"]>=11 and tars_[i]["tar"]<=16 then
                    p:playAction(1007)
                else
                    p:playAction(1006)
                end
                p:showFilter(7)

            end    


        end     
    end

    --震屏
    if self._shakeState == true then
        if self.skillInfo.shake_type then
            self._shakeState = false
            if self.skillInfo.shake_type == 1 then
                self._getFightScene():shakeScene()
            else
                self._getFightScene():shakeScene2()
            end
        elseif hasBaoji == true then
            self._shakeState = false
            self._getFightScene():shakeScene3()
        end
    end
    
    --移除黑幕 
    self._getFightScene():delBlackScene()
end

--[[
  401-405:  伤害
  406：暴击
  407：闪避
  408：怒气变化
  409：恢复
  410：暴击恢复
  411：伤害飘字，仅仅做飘字用，
  412：格挡，value为伤害数值，无需传其他伤害
]]
function FightMgr:_hurt(data_)
    local skillType = 99
    local leftHp
    local currKey = data_["tar"]

    local p = self:getPlayer(currKey)
    if not p then return end  --如果角色为空跳过
    --技能伤害
    for key,value in pairs(data_.hurts) do
        if key=="401" or key=="402" or key=="403" or key=="404" or key=="405" then --伤害
            leftHp = self:dropBlood(currKey,{type=1,value=value,value2=data_.hurts["411"]})
            skillType = 1
        elseif key=="409" then  --回复
            skillType = 4
            self:_floatText({type=2,value=value}, p)
            local curHp, totalHp = p:hurt(-value)
            leftHp = curHp
            self:_getFightScene():plateUpdateInfo({tar=currKey,type=1, cur=curHp, total=totalHp})
        elseif key=="410" then --暴击回复
            skillType = 4
            self:_floatText({type=3,value="baoji2",value2=value}, p)
            local curHp, totalHp = p:hurt(-value)
            leftHp = curHp
            self:_getFightScene():plateUpdateInfo({tar=currKey,type=1, cur=curHp, total=totalHp})
        elseif key == "406" then --暴击
            self:_floatText({type=3,value="baoji",value2=value,value3=data_.hurts["411"]}, p)
            local curHp, totalHp = p:hurt(value)
            leftHp = curHp
            self:_getFightScene():plateUpdateInfo({tar=currKey,type=1, cur=curHp, total=totalHp})
            skillType = 3
        elseif key == "407" then  --闪避
            skillType = 2
            self:_floatText({type=3,value="shanbi"}, p)
        elseif key == "408" then  --怒气
            self:dropAnger(currKey,value)
        elseif key == "412" then  --格挡
            --leftHp = self:dropBlood(currKey,{type=1,value=value,value2=data_.hurts["411"]})
            skillType = 5
            self:_floatText({type=3,value="gedang",value2=value,value3=data_.hurts["411"]}, p)
            local curHp, totalHp = p:hurt(value)
            leftHp = curHp
            self:_getFightScene():plateUpdateInfo({tar=currKey,type=1, cur=curHp, total=totalHp})
        end
    end

    if leftHp and leftHp<=0 then
        table.insert(self._deathList, currKey)
    end
    return skillType
end

function FightMgr:dropBlood(tar, params)
    local p = self:getPlayer(tar)
    if not p then 
        print("该数码兽已经死亡返回血量9999，不用添加到死亡列表")
        return 9999
    end
    self:_floatText(params, p)
    local curHp, totalHp = p:hurt(params.value)
    self:_getFightScene():plateUpdateInfo({tar=tar,type=1, cur=curHp, total=totalHp})
    return curHp
end

function FightMgr:dropAnger(tar, value)
    local p = self:getPlayer(tar)
    local delay = cc.DelayTime:create(0.5)
    local callfunc = cc.CallFunc:create(function()
        self:_floatText({type=4,value=value}, p)
        local anger = p:updateAnger(value)
        self:_getFightScene():plateUpdateInfo({tar=tar,type=2, count=anger})
    end)
    p:runAction(cc.Sequence:create(delay, callfunc))
end

function FightMgr:_checkDeath(callBack_)
    if #self._deathList > 0 then
        local switch = false
        for i=1, #self._deathList do
            local key = self._deathList[i]
            local player = self._players[key..""]
            local params = {id=404080,from=player,endCallFunc=function()
                if switch == false then
                    switch = true
                    if callBack_ then callBack_() end
                end
            end}
            mgr.effect:playEffect(params)
            player:dispose()
            self._players[key..""] = nil
            self:_getFightScene():removeBottomPlate(key)
            ---移除玩家身上所有buff
            self._buffList[key] = nil
            self._buffEff[key] = nil
        end
        self._deathList = {}
    else
        if callBack_ then callBack_() end
    end
end

---------------------------
--技能飘字
function FightMgr:_floatText(params_, tar_)
    if self.isJump then
        return
    end
    local floatNum = FloatNum.new(params_)
    self:_getFightScene():getTopLayer():addChild(floatNum, 100000)
    local index = params_.index or 0
    floatNum:setPosition(tar_:getPositionX(),tar_:getCenterH()+tar_:getPositionY()+30*(index+1))
end

---------------------------
--buff飘字
function FightMgr:_floatBuff(params_, tar_)
    if self.isJump then
        return
    end
    if not params_.value then
        return
    end
    local floatNum = BuffFloat.new(params_)
    self:_getFightScene():getTopLayer():addChild(floatNum, 100000)
    floatNum:setPosition(tar_:getPositionX(),tar_:getCenterH()+tar_:getPositionY()+30)
end

function FightMgr:jumpFight()  
    print("战斗跳过...",self.isJump)
    if self._curCursor==0 and self.isJump == false then
        self.isJump = true
        self:_getFightScene():fightJump()
        local info_ = cache.Fight:getFightReport()
        self._curCombatInfo = info_["bouts"]
        self:enterJump()
    end
    self.isJump = true
end

function FightMgr:enterJump()
    local count = 0
    local currCombatInfo
    for i=1, #self._curCombatInfo do
        currCombatInfo = self._curCombatInfo[i]
        ---攻击者buff掉血
        if i > self._curCursor then
            local hurtBuffParams = {tar=currCombatInfo["atk"], buff=currCombatInfo["buffHurt"]or{}}
            self:_hurtBuff(hurtBuffParams)
        end    

        ---受击对象的掉血
        local data = currCombatInfo["targets"] or {}
        for i=1, #data do
            count = count + 1 
            if count > self.hurtIndex then
                self:_hurt(data[i])
            end
        end

    end

   -- for k,v in pairs(self._players) do
   --     print(k,"#######",v._playerHp)
   -- end

   print("回合数：",#self._curCombatInfo)

    self:_checkDeath(function()
        self:fightEnd()
        --self.isJump = false
    end)
end

---------------------------
--获取战斗场景
function FightMgr:_getFightScene()
    return display.getRunningScene()
end

function FightMgr:setPlayersName(state_)
    for key, value in pairs(self._players) do
        value:setNameState(state_)
    end
end

------------------------------------------------------------------------------------------buff相关
---攻击者获得buff, step_:1攻击前， 2攻击后
function FightMgr:_addFightBuff(params_, step_)
    local buffs = params_["buffs"]
    for key,value in pairs(buffs) do
        if key ~= "_size" then
            local buffConf
            if tonumber(key) < 200 and tonumber(key) > 100 then
                buffConf = conf.Skill:getBuffInfo(value)
                print("攻击者获得解晕buff", value)
            else
                buffConf = conf.Skill:getBuffInfo(key)
                print("攻击者获得buff", key)
            end
            
            if buffConf.step == step_ then
                if buffConf.affect_type == 12 then --移除buff
                    local tar = tonumber(key) - 100
                    self:_removeBuffByServer(tar, buffConf)
                else  --添加buff
                    self:_addSingleBuff(params_["tar"],key)
                end    
            end        
        end
    end
end

---受击者获得获得buff
function FightMgr:_addBuff(params_)
    --buff配置
    local buffs = params_["buffs"] or {}
    for key,value in pairs(buffs) do
        if key ~= "_size" then
            print("受击者获得buff", key)
            self:_addSingleBuff(params_["tar"],key)
        end
    end
end

---添加buff到对象 tar_目标， id_ buff ID
function FightMgr:_addSingleBuff(tar_, id_)
    local buffConf = conf.Skill:getBuffInfo(id_)
    local tar = self:getPlayer(tar_)
    local show = buffConf.show_id
    --buff效果
    if buffConf.effect_id then
        local params = {id=buffConf.effect_id,from=tar, loadComplete=function(arm,arg)
            if not self._buffEff[tar_] then
                self._buffEff[tar_] = {}
            end
            self._buffEff[tar_][id_..""] = arm
        end}
        mgr.effect:playEffect(params)
    end
    local pzState = true
    --buff数值
    if show==102 then  --增加怒气
        pzState = false
        self:dropAnger(tar_,buffConf.affect[2])
    elseif show == 103 then --减少怒气
        pzState = false
        self:dropAnger(tar_,buffConf.affect[1])
    end

    --buff飘字
    if pzState == true then
        self:_floatBuff({value=buffConf.show_id}, tar)
    end

    --buff存储
    if show==104 or show==105 or show==110 then
        if not self._buffList[tar_] then
            self._buffList[tar_] = {}
        end
        self._buffList[tar_][id_] = {curBout=0}
    end
end

---buff伤害
function FightMgr:_hurtBuff(params_)
    local index = 0
    local needTime = false
    for key, value in pairs(params_.buff) do
        if key ~= "_size" then
            needTime = true
            local buffConf = conf.Skill:getBuffInfo(key)
            local leftHp = self:dropBlood(params_["tar"], {type=5,value2=buffConf.show_id,value=value,index=index})
            print(self.isJump,"-@@@@@@@@@buff->id:",key,",伤害", value)
            --更新回合数
            self:_updateBuff(params_["tar"], 2)
            --血量为0死亡处理
            if leftHp and leftHp<=0 then
                table.insert(self._deathList, params_["tar"])
                if self.isJump ~= true then
                    self:_checkDeath(function()
                        self:_combatProcess()
                    end)
                end
                return 0
            end
            index = index + 1        
        end   
    end
    if needTime == true then
        return 0.8
    end
    return 0.05
end

---移除指定buff达到回合数
function FightMgr:_removeBuffById(tar_, id_)
    if self._buffList[tar_] and self._buffList[tar_][id_..""] then
        local info = self._buffList[tar_][id_..""]
        local buffConf = conf.Skill:getBuffInfo(id_)
        local totalBouts = buffConf.max_bout
        if info.curBout >= totalBouts then
            if buffConf.effect_id then 
                local eff = self._buffEff[tar_][id_]
                if eff and eff:getParent() then
                    eff:removeSelf()
                end
                self._buffEff[tar_][id_] = nil
            end
            self._buffList[tar_][id_] = nil
        end
    end
end

--服务器主动移除buff
function FightMgr:_removeBuffByServer(tar_, buffConf_)
    local tar = self:getPlayer(tar_)
    self:_floatBuff({value=buffConf_.show_id}, tar)
    if self._buffList[tar_] then
        for key, value in pairs(self._buffList[tar_]) do
            local buffConf = conf.Skill:getBuffInfo(key.."")
            if buffConf.effect_id then 
                local eff = self._buffEff[tar_][key..""]
                if eff and eff:getParent() then
                    eff:removeSelf()
                end
                self._buffEff[tar_][key..""] = nil
            end
            self._buffList[tar_][key..""] = nil
        end
    end
end

---更新玩家回合数 --- type_:1出手完毕调用, 2 伤害完毕
function FightMgr:_updateBuff(tar_, type_)
    if self._buffList[tar_] then
        local buffList = self._buffList[tar_]
        for key, value in pairs(buffList) do
            local buffConf = conf.Skill:getBuffInfo(key)
            if buffConf.show_id == 105 or buffConf.show_id == 110 then --灼烧和中毒伤害计算回合
                if type_ == 2 then
                    --回合数＋1
                    value.curBout = value.curBout + 1
                    --检测是否移除
                    self:_removeBuffById(tar_, key)
                end
            elseif buffConf.show_id == 104 then  --眩晕是出手完毕计算回合
                if type_ == 1 then
                    --回合数＋1
                    value.curBout = value.curBout + 1
                    --检测是否移除
                    self:_removeBuffById(tar_, key)
                end
            end
            
        end
    end
end

---新手战斗引导
function FightMgr:_guideFight()
    local data = self.fightInfo
    local guide = data["guide"]
    self.guideIndex = 1
    local buffParams = {tar=data["atk"], buffs=data["buffs"]or{}}
    if guide and #guide>0 then
        self:_guideStep()
        return true
    end
    return false
end

function FightMgr:_guideStep()
    local totalGuide = self.fightInfo["guide"]
    if self.guideIndex > #totalGuide then
        --本次引导结束
        self:_startFight()
        return
    end
    local id = self.fightInfo["guide"][self.guideIndex]
    local config = conf.guide:getGuideById(id)
    if config.dialogues then --对话
        local params = {id=id, endPlotCall=function()
            --剧情对话结束
            self.guideIndex = self.guideIndex + 1
            self:_guideStep()
        end}
        mgr.Guide:startFightPlot(params)
    elseif config.model then --切换模型
        --角色
        local atk = self:_getAtk()
        if self._players[atk..""] then
            self._players[atk..""]:removeSelf()
            self._players[atk..""] = nil
        end  
        local layer = self:_getFightScene():getPlayerLayer()    
        local pos = conf.Skill:getPlayerPos(atk)
        local mdel = conf.Card:getModel(config.model)
        local e = Player.new(mdel.."")
        local data = config.info
        e:setInfo(data)
        layer:addChild(e)
        self._players[atk..""] = e
        self.atkTar = e
        e:setPos(pos[1],pos[2])
        --更新底盘
        data.index = atk
        self:_getFightScene():updatePlate(data)
        --动画
        local player = e._bodyNode
        player:setScaleX(0)
        e:playAction(1018,{endCall=function()
            --添加模型结束
            self.guideIndex = self.guideIndex + 1
            self:_guideStep()
        end, triggerCall=function()
            self:_getFightScene():plateShake(atk)
        end})
    elseif config.effect then --添加特效
        if config.effect == 99 then
            local data1 = {mId=config.info[1], propertys={[307]={value=0}}}
            local data2 = {mId=config.info[2], propertys={[307]={value=3}}}
            G_playerJingjie(data1, data2, self:_getFightScene(), function()
                --效果播放完毕
                self.guideIndex = self.guideIndex + 1
                self:_guideStep()
                mgr.Sound:playFightHardMusic()
            end)
        else
            local params = {id=config.effect,x=display.cx, y=display.cy, addTo=self:_getFightScene(), triggerFun=function(tars_, effConf_)
                --效果播放完毕
                self.guideIndex = self.guideIndex + 1
                self:_guideStep()
            end}
            mgr.effect:playEffect(params)
        end
    end
end

return FightMgr