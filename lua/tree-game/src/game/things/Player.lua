--[[--
战斗角色
]]

local FloatNum = import(".FloatNum")

local Player = class("Player",require("game.things.BaseThing"))

function Player:ctor(id_)
    Player.super.ctor(self, id_, "Player")
    self:setCascadeOpacityEnabled(true)
    self._playerTotalHp = 0
    self._playerHp = 0
    self.playerAnger = 0
    self:setNameState(false)
end

---------------------
---- public
---------------------

function Player:setInfo( data_ )
    self.playerAnger = data_.maxMp
    self._playerTotalHp = data_.maxHp
    if not data_.currHp or data_.currHp == 0 then 
        self._playerHp = data_.maxHp
    else
        self._playerHp = data_.currHp
    end
end

function Player:setNameState(state_)
    self._playerName:setVisible(state_)
end

function Player:updateAnger(num_)
    self.playerAnger = self.playerAnger+num_
    if self.playerAnger > 9 then
        self.playerAnger = 9
    elseif self.playerAnger < 0 then
        self.playerAnger = 0
    end
    self:addAgnerEffect()
    return self.playerAnger
end

function Player:addAgnerEffect()
    if self.playerAnger >= 4 then
        if not self.angerEffect then
            local params = {id=404820,x=-5,y=63,addTo=self,loadComplete=function(arm)
                self.angerEffect = arm
            end}
            mgr.effect:playEffect(params)
        end
    else
        if self.angerEffect then
            self.angerEffect:removeSelf()
            self.angerEffect = nil
        end
    end
end

---------------------------
--伤害
--@param value_ 伤害值
function Player:hurt(value_)
    self._playerHp = self._playerHp - value_
    if self._playerHp > self._playerTotalHp then
        self._playerHp = self._playerTotalHp
    end
    return self._playerHp, self._playerTotalHp
end

---------------------------
--技能飘字
function Player:floatSkillName(value_)
    local floatNum = FloatNum.new({
        type = 3,
        value = value_
    })
    self._topEffLayer:addChild(floatNum)
    floatNum:setPosition(0,self:getCenterH()*2)
end

function Player:setPos(x_,y_)
    self:setPosition(x_, y_)
    self:setLocalZOrder(10000 - y_)
end

function Player:gotoTop()
    self:setLocalZOrder(20000)
end
function Player:gotoCenter()
    self:setLocalZOrder(10000 - 480)
end
function Player:gotoBottom()
    self:setLocalZOrder(10000 - self:getPositionY())
end

---------------------------
--获取角色上下层
function Player:getTopLayer()
    return self._topEffLayer
end
function Player:getBottomLayer()
    return self._bottomEffLayer
end

---------------------------
--销毁
function Player:dispose()
    Player.super.dispose(self, "Player")
end

---------------------
---- private
---------------------

---------------------------
--创建血条
function Player:_createHeadBar()
    
end


return Player