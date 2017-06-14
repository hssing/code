--[[--
战斗场景
]]
local Player = require("game.things.Player")
local Plate = require("game.things.Plate")

local FightScene = class(_scenename.FIGHT,base.BaseScene)

function FightScene:ctor() 
    ---背景
    local bg 
    if cache.Fight:getType() == 1 then  --副本
        local fightData = cache.Fight:getData()
        local zjId = math.floor(fightData.sId/100)
        local zjConf = conf.Copy:getChapterInfo(zjId)
        local url = "res/maps/"..zjConf.mapid..".png"
        bg = display.newSprite(url)
    elseif cache.Fight:getType() == 2 then  --竞技场
        bg = display.newSprite(res.texture["pic_map_1"])
    elseif cache.Fight:getType() == 4 then
        local id = cache.Guild.guildFBID  --获取章节id, 章节数据
        local config = conf.guild:getGuildChapter(id)
        bg = display.newSprite("res/maps/"..config.mapid..".png")
    elseif cache.Fight:getType() == 5 then  -- 数码大赛
        bg = display.newSprite(res.texture["chapter_map_5"])
    elseif  cache.Fight:getType() == 6    then  -- 文件岛 挑战
        bg = display.newSprite( "res/maps/chapter_map_1.png" )
    elseif cache.Fight:getType() == 7   then  -- 文件岛 巧夺
        bg = display.newSprite( "res/maps/chapter_map_1.png" )
    elseif cache.Fight:getType() == 8   then
        bg = display.newSprite( "res/maps/chapter_map_1.png" )
    elseif cache.Fight:getType() == 9   then -- 日常副本
        local fightData = cache.Fight:getData()
        local zjId = math.floor(fightData.sId/100)
        --local zjConf = conf.Copy:getChapterInfo(zjId)
        local zjConf = conf.DayFuben:getMap(zjId)
        local url = "res/maps/"..zjConf..".png"
        bg = display.newSprite(url)
    elseif cache.Fight:getType() == 10   then -- 跨服战
        bg = display.newSprite( "res/maps/chapter_map_1.png" )
    elseif cache.Fight:getType() == 11   then -- 跨服战录像
        bg = display.newSprite( "res/maps/chapter_map_1.png" )
    elseif cache.Fight:getType() == 12   then -- shijieboss
        bg = display.newSprite( "res/maps/chapter_map_1.png" )
    else
        bg = display.newSprite(res.texture["pic_map_1"])
    end
    bg:setScale(1.03)
    bg:setPosition(display.cx, display.cy)
    local scaleH = display.height/960
    local scaleW = display.width/640
    local scale = math.max(scaleH, scaleW)*1.03
    bg:setScale(scale)
    self:addChild(bg, -10)
    
    self.nodeScene = display.newNode()
    self:addChild(self.nodeScene)
    ---黑色背景特效层
    self._blackNode = display.newNode()
    self.nodeScene:addChild(self._blackNode)
    ---底盘层
    self._plateNode = display.newNode()
    self.nodeScene:addChild(self._plateNode)
    ---下层
    self._bottomEffLayer = display.newNode()
    self.nodeScene:addChild(self._bottomEffLayer)
    ---角色层
    self._playerLayer = display.newNode()
    self.nodeScene:addChild(self._playerLayer)
    ---上层
    self._topEffLayer = display.newNode()
    self.nodeScene:addChild(self._topEffLayer)
    
    --self.nodeScene:setScaleX(display.width/640)
    --self.nodeScene:setScaleY(display.height/960)
    self.nodeScene:setPositionY((display.height-960)/2)
        
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function()
        mgr.Fight:setPlayersName(true)
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(function()
        mgr.Fight:setPlayersName(false)
    end, cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

---添加引导view
function FightScene:addGuideView()
    local view = mgr.ViewMgr:createView(_viewname.GUIDE_VIEW)
    self:addChild(view, 100000)
    return view
end

---添加loading
function FightScene:addLoading()
    local view = mgr.ViewMgr:createView(_viewname.LOADING_VIEW)
    view:setData()
    self:addView(view)
    return view
end

function FightScene:addView(view,top)
  self:getRootLayer():addChild(view)
end

function FightScene:loading(callback)
  self._fightUI=mgr.ViewMgr:createView(_viewname.FIGHT)
  self:addView(self._fightUI)
  callback()
end

function FightScene:onEnter()
    self.super.onEnter(self)
    self:fight()
    cache.Fight.isClickFight = false
end

function FightScene:fight(clear_)
    if clear_ then 
        self:dispose()
    end
    --战斗UI
    self._fightUI:initFightUI()
    --开始战斗
    mgr.Fight:enterFight()
    --战斗音乐
    self:_fightSound()  
end

---战斗背景音乐
function FightScene:_fightSound()
    if fight_guide then
        mgr.Sound:playFightHardMusic()
    else
        local function checkLevel(id_)
            local lvl = tonumber(string.sub(id_,5,6))
            if lvl==10 then
                return true
            end
            return false
        end
        if cache.Fight:getType()==1 and checkLevel(cache.Fight:getData().sId)==true then
            mgr.Sound:playFightHardMusic()
        else
            mgr.Sound:playFightMusic()
        end
    end
end

function FightScene:fightStart(params_)
    self._fightUI:fightBeganDh(params_)
end
function FightScene:fightJump()
    self._fightUI:jumpDh()
end

---------------------------
--震屏--强
function FightScene:shakeScene()
    local move = cc.MoveBy:create(0.03,cc.p(-3, 8))
    local move1 = cc.MoveBy:create(0.05,cc.p(6, -3))
    local move2 = cc.MoveBy:create(0.08,cc.p(-3, -5))
    self.nodeScene:runAction(cc.Sequence:create(move, move1, move2))
end
---------------------------
--震屏-弱
function FightScene:shakeScene2()
    local move = cc.MoveBy:create(0.03,cc.p(-1.5, 4))
    local move1 = cc.MoveBy:create(0.05,cc.p(3, -1.5))
    local move2 = cc.MoveBy:create(0.08,cc.p(-1.5, -2.5))
    self.nodeScene:runAction(cc.Sequence:create(move, move1, move2))
end
---------------------------
--震屏--强
function FightScene:shakeScene3()
    local move = cc.MoveBy:create(0.03,cc.p(-3, 8))
    local move1 = cc.MoveBy:create(0.05,cc.p(6, -3))
    local move2 = cc.MoveBy:create(0.08,cc.p(-3, -5))
    self.nodeScene:runAction(cc.Sequence:create(move, move1, move2))
end

function FightScene:blackScene()
    if not self._black then
        self._black = cc.LayerColor:create(cc.c4f(0,0,0,150))
        self._black:setContentSize(display.width, display.height)
        self:addChild(self._black,-8)
    end
end
function FightScene:delBlackScene()
    if self._black then
        local tempBlack = self._black
        self._black = nil
        tempBlack:setCascadeOpacityEnabled(true)
        tempBlack:runAction(cc.Sequence:create({
            cc.FadeOut:create(0.4),
            cc.CallFunc:create(function()
                tempBlack:removeFromParent()            
            end)
        }))
    end
end

---------------------------
--底座
function FightScene:addBottomPlate(enemy_, player_)
    self._bottomPlates = {}
    for i=1,#enemy_ do
        local data = enemy_[i]
        local pos = conf.Skill:getPlayerPos(data.index)
        local e = Plate.new()
        e:setInfo(data)
        e:setPosition(pos[1],pos[2])
        self._plateNode:addChild(e)
        self._bottomPlates[data.index..""] = e
    end
    for i=1,#player_ do
        local data = player_[i]
        local pos = conf.Skill:getPlayerPos(data.index)
        local p = Plate.new()
        p:setInfo(data)
        self._plateNode:addChild(p)
        p:setPosition(pos[1],pos[2])
        self._bottomPlates[data.index..""] = p
    end  
end

-------------------------------
--添加/更新底座
function FightScene:updatePlate(data)
    if self._bottomPlates[data.index..""] then
        self._bottomPlates[data.index..""]:removeSelf()
        self._bottomPlates[data.index..""] = nil
    end
    local pos = conf.Skill:getPlayerPos(data.index)
    local p = Plate.new()
    p:setInfo(data)
    self._plateNode:addChild(p)
    p:setPosition(pos[1],pos[2])
    self._bottomPlates[data.index..""] = p
end

function FightScene:removeBottomPlate(key_)
    if self._bottomPlates[key_..""] then
        self._bottomPlates[key_..""]:dispose()
        self._bottomPlates[key_..""] = nil
    end
end

---------------------------
--底盘抖动
function FightScene:plateShake(index_, funCall_)
    local plate = self._bottomPlates[index_..""]
    plate:shake(funCall_)
end

function FightScene:plateUpdateInfo(params_)
    local plate = self._bottomPlates[params_["tar"]..""]
    plate:updateInfo(params_)
end

---------------------------
--战斗结束
function FightScene:fightResult()
    cache.Fight.fightState = 0
    --还原加速
    self._fightUI:setSchedulerScale(1)
    --战斗结果
	local fightData = cache.Fight:getData()
	local type = cache.Fight:getType()
    local result = fightData.fightReport.start
    if cache.Fight:getType() ==  5 or cache.Fight:getType() == 8 or cache.Fight:getType() == 11 
        or cache.Fight:getType() == 12 then 
        result = 1
    end

    if cache.Fight:getType() == 8 then  --比较特殊的 正义战
        if not cache.Camp:getSelfWin() then 
            result = 0
        end
    end

    if result > 0 then  --胜利
        mgr.ViewMgr:showView(_viewname.FIGHT_WIN):setData(fightData, type)
    else  --失败
        mgr.ViewMgr:showView(_viewname.FIGHT_OVER):setData(fightData, type)
    end
end

function FightScene:updateHuiHe(num_)
    self._fightUI:updateHuiHe(num_)
end

function FightScene:onExit()
  self.super.onExit(self)
end

function FightScene:getTopLayer()
    return self._topEffLayer
end
function FightScene:getPlayerLayer()
    return self._playerLayer
end
function FightScene:getBottomLayer()
    return self._bottomEffLayer
end

function FightScene:dispose()
    mgr.Fight:dispose()
    for key, value in pairs(self._bottomPlates) do
        value:removeSelf()
    end
    self._bottomPlates = {}
end

return FightScene
