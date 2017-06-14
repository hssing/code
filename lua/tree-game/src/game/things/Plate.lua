local Plate = class("Plate",function()
    return display.newNode()
end)

function Plate:ctor()
    self._plateNode = display.newNode()
    self:addChild(self._plateNode)
    --self._plateNode:setPositionY(-10)
    
    local bgTop = display.newSprite("res/views/ui_res/bg/plate_top.png")
    bgTop:setPosition(0, 2)
    self._plateNode:addChild(bgTop)
    local bg = display.newSprite("res/views/ui_res/bg/plate_bg_1.png")
    self._plateNode:addChild(bg)
    bg:setPosition(0, 2)
    
    --血条信息-最下面
    self.lifeBar3 = cc.ProgressTimer:create(display.newSprite("res/views/ui_res/bg/plate_hp3.png"))
    self.lifeBar3:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.lifeBar3:setMidpoint(cc.p(0, 1))
    self.lifeBar3:setBarChangeRate(cc.p(1, 0))
    self.lifeBar3:setPercentage(100)
    self.lifeBar3:setPosition(2,-5-9)
    self._plateNode:addChild(self.lifeBar3)
    --血条信息-黄色
    self.lifeBar2 = cc.ProgressTimer:create(display.newSprite("res/views/ui_res/bg/plate_hp2.png"))
    self.lifeBar2:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.lifeBar2:setMidpoint(cc.p(0, 1))
    self.lifeBar2:setBarChangeRate(cc.p(1, 0))
    self.lifeBar2:setPercentage(100)
    self.lifeBar2:setPosition(2,-5-9)
    self._plateNode:addChild(self.lifeBar2)
    --血条信息-红色
    self.lifeBar = cc.ProgressTimer:create(display.newSprite("res/views/ui_res/bg/plate_hp.png"))
    self.lifeBar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.lifeBar:setMidpoint(cc.p(0, 1))
    self.lifeBar:setBarChangeRate(cc.p(1, 0))
    self.lifeBar:setPercentage(100)
    self.lifeBar:setPosition(2,-5-9)
    self._plateNode:addChild(self.lifeBar)  
    self:updateBlood(100,100)
    
    --怒气信息
    self.anger = cc.ProgressTimer:create(display.newSprite("res/views/ui_res/bg/plate_mp.png"))
    self.anger:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.anger:setMidpoint(cc.p(0, 1))
    self.anger:setBarChangeRate(cc.p(1, 0))
    self.anger:setPercentage(0)
    self.anger:setPosition(0,-8)
    self._plateNode:addChild(self.anger)
    self._angerPos = {{-30,-8},{-14,-12},{14,-12},{30,-8}}
    self.nqImg = nil
    
    --阴影
    self._shadow = display.newSprite(res.image.PLAYER_SHADOW)
    self:addChild(self._shadow)
    self._shadow:setPosition(0,-60)
end

function Plate:setInfo( data_ )
    self._curAnger = data_.maxMp
    local tHp = data_.maxHp
    local cHp
    if not data_.currHp or data_.currHp == 0 then 
        cHp = data_.maxHp
    else
        cHp = data_.currHp
    end
    self:updateBlood(cHp,tHp)
    self:updateAnger(data_.maxMp)
end

---------------------------
--抖动
function Plate:shake(funCall_)
    local move = cc.MoveTo:create(1/20,cc.p(0, -4))
    local scale= cc.RotateTo:create(1/20,-10.35)
    local spawn = cc.Spawn:create(move, scale)
    local move1 = cc.MoveTo:create(1/20,cc.p(0, -10))
    local scale1= cc.RotateTo:create(1/20,5.86)
    local spawn1 = cc.Spawn:create(move1, scale1)
    local move2 = cc.MoveTo:create(1/20,cc.p(0, 0))
    local scale2= cc.RotateTo:create(1/20,0)
    local spawn2 = cc.Spawn:create(move2, scale2)
    local callFun = cc.CallFunc:create(function()
        if funCall_ then funCall_() end
    end)
    local seq = cc.Sequence:create(spawn, spawn1, spawn2, callFun)
    self._plateNode:runAction(seq)
end

function Plate:updateInfo(params_)
	if params_.type == 1 then
	   self:updateBlood(params_.cur,params_.total)
	else
	   self:updateAnger(params_.count)
	end
end

function Plate:updateBlood(hp_, max_)
    local rate = hp_ / max_
    local pro = cc.ProgressTo:create(0.1,  rate*100)
    local callFunc = cc.CallFunc:create(function()
        local pro2 = cc.ProgressTo:create(0.2,  rate*100)
        local callFunc2 = cc.CallFunc:create(function()
            self.lifeBar3:runAction(cc.ProgressTo:create(0.3,  rate*100))
        end)
        local seq = cc.Sequence:create(pro2, callFunc2)
        self.lifeBar2:runAction(seq)
    end)
    local seq = cc.Sequence:create(pro, callFunc)
    self.lifeBar:runAction(seq)
end

function Plate:updateAnger(num)
    --if num>4 then num = 4 end
    local function loop(index_)
        if index_ > self._curAnger then
            self._curAnger = self._curAnger + 1
            if self._curAnger < 5 then
                local pos = self._angerPos[self._curAnger]
                local rate = self._curAnger*25
                self.anger:runAction(cc.ProgressTo:create(0.02,  rate))
                local params = {id=404081,addTo=self._plateNode, x=pos[1], y=pos[2],triggerFun=function(type_, tars_, effConf_)
                    if type_ == "end_call" then
                        loop(num)
                    end        
                end}
                mgr.effect:playEffect(params)
            end
        end
    end
    if num > 4 then
        if self.nqImg then
            self.nqImg:removeSelf()
        end
        self.nqImg = display.newSprite("res/views/ui_res/icon/nq_add"..num..".png", 60, 0)
        self:addChild(self.nqImg)
    else
        if self.nqImg then
            self.nqImg:removeSelf()
            self.nqImg = nil
        end
    end
    if num > self._curAnger then
        loop(num)
    else
        self._curAnger = num
        local rate = num*25
        self.anger:runAction(cc.ProgressTo:create(0.4,  rate))
    end  
end

function Plate:dispose()
    self:removeFromParent()
end

return Plate