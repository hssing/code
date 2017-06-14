local ClimbTowerView=class("ClimbTowerView",base.BaseView)

function ClimbTowerView:init(index)
    self.ShowAll=true
    self.showtype=view_show_type.UI
    self.viewSave = true
    self.view=self:addSelfView()
    
    --数据

    --？星难度
    self.hardWords = {res.str.CLIMB_DESC37
    ,res.str.CLIMB_DESC38
    ,res.str.CLIMB_DESC39
    ,res.str.CLIMB_DESC40
    ,res.str.RES_RES_36}
    --关闭
    self._closebtn = self.view:getChildByName("Button_close")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))
    --规则
    self._gzBtn = self.view:getChildByName("Panel_1"):getChildByName("Button_3")
    self._gzBtn:addTouchEventListener(handler(self,self.onGzBtnClick))
    --奖励
    self._awardBtn = self.view:getChildByName("Panel_1"):getChildByName("Button_4")
    self._awardBtn:addTouchEventListener(handler(self,self.onAwardBtnClick))
    --难度
    self._hardTxt = self.view:getChildByName("Panel_1"):getChildByName("Text_1")
    --关卡
    self._lvlTxt = self.view:getChildByName("Panel_1"):getChildByName("Text_4")
    --今日最高
    self._jrTop = self.view:getChildByName("Panel_1"):getChildByName("Text_3")
    --挑战3个按钮
    for i=1, 3 do
        local btn = self.view:getChildByName("Panel_1"):getChildByName("Panel_2_"..i):getChildByName("Button_5_"..i)
        btn:addTouchEventListener(handler(self,self.onFightClick))
        btn:setTag(i)
    end
    --一键五关
    self._fiveBtn = self.view:getChildByName("Panel_1"):getChildByName("Button_1")
    self._fiveBtn:addTouchEventListener(handler(self,self.onFiveBtnClick))
    self._fiveBtn:setVisible(false)
    --重置
    self._restBtn = self.view:getChildByName("Panel_1"):getChildByName("Button_10")
    self._restBtn:addTouchEventListener(handler(self,self.onRestBtnClick))
    self._restBtn:setVisible(false)
    --勇气鼓舞
    self._gwBtn = self.view:getChildByName("Panel_1"):getChildByName("Button_11")
    self._gwBtn:addTouchEventListener(handler(self,self.onGwBtnClick))
    --本次挑战
    self.curStarTxt = self.view:getChildByName("Panel_1"):getChildByName("Text_3_0")
    --当前生命
    self.curSmTxt = self.view:getChildByName("Panel_1"):getChildByName("Text_3_0_0")
    --鼓舞加成
    self.curYqTxt = self.view:getChildByName("Panel_1"):getChildByName("Text_13_0_0")
    self._addGjTxt = self.view:getChildByName("Panel_1"):getChildByName("Text_16")
    self._addSmTxt = self.view:getChildByName("Panel_1"):getChildByName("Text_16_0")
    --满级
    self._fullLevel = 101

    ----界面固定文本
    local panel = self.view:getChildByName("Panel_1")
    panel:getChildByName("Text_2"):setString(res.str.CLIMB_DESC5)
    panel:getChildByName("Text_2_0"):setString(res.str.CLIMB_DESC6)
    panel:getChildByName("Text_2_0_0"):setString(res.str.CLIMB_DESC7)
    panel:getChildByName("Text_13"):setString(res.str.CLIMB_DESC8)
    panel:getChildByName("Text_13_0"):setString(res.str.CLIMB_DESC9)
    panel:getChildByName("Text_14"):setString(res.str.CLIMB_DESC12)
    panel:getChildByName("Text_14_0"):setString(res.str.CLIMB_DESC13)

    self._restBtn:setTitleText(res.str.CLIMB_DESC11)
    self._gwBtn:setTitleText(res.str.CLIMB_DESC10)
    self._fiveBtn:setTitleText(res.str.CLIMB_DESC14)

     for i=1, 3 do
        local btn = self.view:getChildByName("Panel_1"):getChildByName("Panel_2_"..i):getChildByName("Button_5_"..i)
        btn:setTitleText(res.str.CLIMB_DESC22)
    end

end

---勇气鼓舞
function ClimbTowerView:onGwBtnClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        mgr.ViewMgr:showView(_viewname.TOWER_YQ)
    end
end

---重置
function ClimbTowerView:onRestBtnClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        local t = cache.Copy.towerData.restCount
        if t > 0 then
            local tt = cache.Copy.towerData.buyCount
            local money = conf.buyprice:getTowerPrice(tt+1)
            print("__________________",money)
            mgr.ViewMgr:showView(_viewname.TOWER_REST_TIMES):setData({money=money})
        else
            mgr.ViewMgr:showView(_viewname.TOWER_REST_VIP)
        end  
    end
end

---一键五关
function ClimbTowerView:onFiveBtnClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        --410011
        local myPower = cache.Player:getPower()
        local id = self._towerData.currPass
        local curGq = conf.Copy:getTowerGq(id)
        local wipeGq = curGq + 4
        if wipeGq > 100 then
            wipeGq = 100
        end
        local lageId = math.floor(id/10000)*10000+wipeGq*10
        if lageId > self._towerData.maxPassId then
            G_TipsOfstr(res.str.CLIMB_TIPS1)
            return
        end
        local fightId = id+3 ---加3是选择困难模式
        local cof = conf.Copy:getTowerInfo(lageId+3)
        if cof.power > myPower then
            G_TipsOfstr(res.str.CLIMB_TIPS2)
        else
            mgr.ViewMgr:showView(_viewname.COPY_WIPE):setData(fightId, fight_vs_type.tower)
            mgr.NetMgr:send(115004, {fId=fightId})
        end
        print("________________________________[爬塔]", id, lastId,cof.power)
    end
end

---挑战
function ClimbTowerView:onFightClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        local level = tonumber(string.sub(self._towerData.currPass,3,5))
        if level >= self._fullLevel then
            G_TipsOfstr(res.str.CLIMB_TIPS3)
            return
        end
        local count = cache.Copy.towerData.lastCount
        if count > 0 then
            local index = send:getTag()
            proxy.copy:onSFight(102003, {fId=self._towerData.currPass + index})
            --mgr.NetMgr:send(102003, {fId=self._towerData.currPass + index})
        else
            G_TipsOfstr(string.format(res.str.CLIMB_TIPS4, 0))
        end     
    end
end

---规则
function ClimbTowerView:onGzBtnClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        mgr.ViewMgr:showView(_viewname.GUIZE):showByName(2)
    end
end

---奖励
function ClimbTowerView:onAwardBtnClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        mgr.ViewMgr:showView(_viewname.TOWER_AWARD)
    end
end

function ClimbTowerView:setData( params_ )
    
end

function ClimbTowerView:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        mgr.SceneMgr:getMainScene():changeView(5)
    end
end

function ClimbTowerView:setLastBlood(value)
    self.curSmTxt:setString(value)
    if value <= 0 then
        self.curSmTxt:setColor(cc.c3b(255, 0, 0))
    else
        self.curSmTxt:setColor(cc.c3b(255, 165, 0))
    end
end

---从战斗结算界面返回更新数据
function ClimbTowerView:updateInfo()
    local data = cache.Fight:getData()
    self:setLastBlood(data.lastCount)
end

function ClimbTowerView:onCloseSelfView()
    self.super.onCloseSelfView(self)
end

--------------------------------------------------------------------------------------
function ClimbTowerView:rTowerInfo(data_)
    --410011
    --print("______________________________",data_.currPass)
    self._towerData = data_
    self._jrTop:setString(data_.maxStart)
    self.curStarTxt:setString(data_.start)
    self.curYqTxt:setString(data_.guts)
    self._addGjTxt:setString(data_.atk.."%")
    self._addSmTxt:setString(data_.hp.."%")
    self:setLastBlood(data_.lastCount)
    local hard = tonumber(string.sub(data_.currPass,2,2))
    print("我就是看看 难度是什么",hard,data_.currPass)
    self._hardTxt:setString(string.format(res.str.CLIMB_DESC1, self.hardWords[hard]))
    --self._hardTxt:setString(self.hardWords[hard].."星难度")
    local level = tonumber(string.sub(data_.currPass,3,5))
    local lStr = level
    if level > 100 then lStr = 100 end
    self._lvlTxt:setString(string.format(res.str.CLIMB_DESC2, lStr))
    --self._lvlTxt:setString("第 "..lStr.." 关")
    ---
    for i=1, 3 do
        local id = data_.currPass + i
        print("id "..id)
        local cof = conf.Copy:getTowerInfo(id)
        local txt = self.view:getChildByName("Panel_1"):getChildByName("Panel_2_"..i):getChildByName("Text_5_"..i)
        if cof.power<10000 then
            txt:setString(string.format(res.str.CLIMB_DESC3, cof.power))
            --txt:setString("推荐战力："..cof.power)
        else
            local v = math.floor(cof.power/1000)
            local v2 = v/10
            txt:setString(string.format(res.str.CLIMB_DESC4, v2))
            --txt:setString("推荐战力："..v2.."万")
        end
        
        local img = self.view:getChildByName("Panel_1"):getChildByName("Panel_2_"..i):getChildByName("Image_8_"..i)
        img:loadTexture("res/head/"..cof.icon..".png")
    end
    --
    if (data_.lastCount == 0 or level >= self._fullLevel) then
        self._fiveBtn:setVisible(false)
        self._restBtn:setVisible(true)
    else
        self._fiveBtn:setVisible(true)
        self._restBtn:setVisible(false)
    end
    --设置cache
    cache.Copy.towerStarLvl = hard
    cache.Copy.towerData = data_
    --初次爬塔推荐挑战星级
    local flag = MyUserDefault.getIntegerForKey(user_default_keys.FIRST_TOWER)
    if flag == 0 or cache.Copy.resetFlag == 1 then
        cache.Copy.resetFlag = 0
        local str = string.format(res.str.CLIMB_DESC1,self.hardWords[hard] )
        mgr.ViewMgr:showView(_viewname.TOWER_HARD_ALERT):setData({hardStr=str})
        if flag == 0 then
            MyUserDefault.setIntegerForKey(user_default_keys.FIRST_TOWER, 1)
        end
    end
    --弹星级提示框
    if data_.startAward ~= -1 then
        mgr.ViewMgr:showView(_viewname.TOWER_AWARD_ALERT):setData(data_)
    end
end

---勇气鼓舞返回
function ClimbTowerView:rTowerYq(data_)
    if data_.atk > cache.Copy.towerData.atk then
        G_TipsOfstr(string.format(res.str.CLIMB_TIPS5,data_.atk-cache.Copy.towerData.atk))
        --G_TipsOfstr("鼓舞成功，攻击+"..(data_.atk-cache.Copy.towerData.atk).."%")
    elseif data_.hp >  cache.Copy.towerData.hp then
       G_TipsOfstr(string.format(res.str.CLIMB_TIPS6, data_.hp - cache.Copy.towerData.hp))
        --G_TipsOfstr("鼓舞成功，生命+"..(data_.hp - cache.Copy.towerData.hp).."%")
    end
    cache.Copy.towerData.atk = data_.atk
    cache.Copy.towerData.hp = data_.hp
    self._addGjTxt:setString(data_.atk.."%")
    self._addSmTxt:setString(data_.hp.."%")
    self.curYqTxt:setString(data_.gust)
    cache.Copy.towerData.guts = data_.gust
    view = mgr.ViewMgr:get(_viewname.TOWER_YQ)
    if view then
        view:updateYQ()
    end
end

---扫荡更新
function ClimbTowerView:rTowerWipeUpdata(data_)
    local stars = data_.totalStart
    if stars > self._towerData.maxStart then
        self._towerData.maxStart = stars
        self._jrTop:setString(stars)
    end
    self._towerData.start = stars
    self.curStarTxt:setString(data_.thisStart)
    self.curYqTxt:setString(data_.totalGuts)
    cache.Copy.towerData.guts = data_.totalGuts
end

---战斗后更新
function ClimbTowerView:updateTower(state_)
    
    local data = cache.Fight:getData()
    local add = 0
    if state_ == true then add = 10 end
    self._towerData.lastCount = data.lastCount
    self._towerData.guts = data.totalGuts
    --print("____________________________________关卡",data.fId)
    self._towerData.currPass = math.floor(data.fId/10)*10 + add
    local level = tonumber(string.sub(self._towerData.currPass,3,5))
    if level < self._fullLevel then
        local result = data.fightReport.start
        if cache.Copy.isPushInspire == 0 or result<=0 then
            mgr.ViewMgr:showView(_viewname.TOWER_YQ)
        end    
    else
        mgr.ViewMgr:showView(_viewname.TOWER_PASS_VIEW)
    end
    self._towerData.start = data.totalStart
    local stars = data.totalStart
    if stars > self._towerData.maxStart then
        self._towerData.maxStart = stars
    end
    self._towerData.startAward = data.startAward or -1
    self:rTowerInfo(self._towerData)
    --self:updateRed()
end

function ClimbTowerView:updateRed()
    if self._towerData.lastCount <= 0 and cache.Copy.towerData.restCount <= 0 then
        cache.Player:setTowerNumber(false)
    else
        cache.Player:setTowerNumber(true)
    end
end

return ClimbTowerView