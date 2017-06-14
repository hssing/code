local AthleticsView=class("AthleticsView",base.BaseView)

function AthleticsView:init(index)
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
    self.viewSave = true

    cache.Fight.isClickFight = false
    self._closebtn = self.view:getChildByName("Button_close")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))

    self.btn_shop = self.view:getChildByName("Button_close_0")
    self.btn_shop:addTouchEventListener(handler(self,self.onBtnShopCallBack))

    self._cell = self.view:getChildByName("Panel_4")
    self.cellList = {}

    self._ydx = self.view:getChildByName("Image_16")
    self.lineList = {}

    self._scrollView = self.view:getChildByName("ScrollView_1")
    self._contentView = self._scrollView:getChildByName("Panel_2_2")
    self._tzBg = self.view:getChildByName("Image_2")
    self._scrollView:addEventListener(handler(self,self.scrollViewEvent))

    self._sBg = self.view:getChildByName("Image_32")
    self._bgList = {}
    self._curBgIndex = 0
    self._effList = {}
    
    --个人信息
    local panel5 = self.view:getChildByName("Panel_5")
    local oldx = panel5:getPositionX()
    local oldy = panel5:getPositionY()
    panel5:setPositionX(oldx + 300)
    self._myRank = panel5:getChildByName("Text_14")
    self._myCoolT = panel5:getChildByName("Text_16")
    self._myFightT = panel5:getChildByName("Text_18")
    self._myAward = panel5:getChildByName("Text_1")
    local move = cc.MoveTo:create(0.8,cc.p(oldx, oldy))
    panel5:runAction(move)     
    
    self._rolePosList = {{126,430},{430,126}}
    
    self.speakTime = 0

    --计时器
    self._nowTime = 0
    --冷却时间
    self._coolTime = 0
    --冷却总时间
    self._totalTime = 0
    --当前可挑战次数
    self._curTimes = 0


    -----界面固定文本
    panel5:getChildByName("Text_13"):setString(res.str.ATHLET_DESC1)
    panel5:getChildByName("Text_15"):setString(res.str.ATHLET_DESC2)
    panel5:getChildByName("Text_17"):setString(res.str.ATHLET_DESC3)
    panel5:getChildByName("Text_19"):setString(res.str.ATHLET_DESC4)
    panel5:getChildByName("Text_20"):setString(res.str.ATHLET_DESC5)

    self._cell:getChildByName("Button_10"):setTitleText(res.str.ATHLET_DESC17)
end

function AthleticsView:onAwardBtnClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        mgr.NetMgr:send(114003)
        self._awardBtn:setEnabled(false)
        self._awardBtn:setBright(false)
        self._awardBtn:setTitleText(res.str.ATHLET_DESC9)
        G_TipsOfstr(string.format(ATHLET_DESC10, self._athleticsData.money_hz))
       -- G_TipsOfstr("获得徽章"..self._athleticsData.money_hz)
    end
end

function AthleticsView:_displayCellByPos(pos_)
    local p = math.floor((-pos_)/197)
    debugprint("________________________________[竞技场]", p)
    local last = 22 - p
    local first = last - 6
    if first < 1 then first = 1 end
    if last < 1 then last = 1 end
    local posList = {85, 340}
    local len = #self._rankData
    local par = self._contentView
    local index = 1 + p
    local jjcFlag = cache.Copy:getJJCFlag()
    for i=last, first,-1 do
        if not self.cellList[index] then
            if jjcFlag == 1 then
                cx = posList[(index-1)%2 + 1]
                cy = 80 + (index-1)*197
            else
                cx = posList[(index)%2 + 1]
                cy = 80 + (index-1)*197
            end
            local info = self._rankData[i]
            local cell
            if self.cellList[index] then
                cell = self:createRoleCell(info, index, self.cellList[index])
            else
                cell = self:createRoleCell(info, index, self._cell:clone())
                self.cellList[index] = cell
            end
            if not cell:getParent() then
                par:addChild(cell, index+200)
            end
            cell:setPosition(cx, cy)
            cell:setTag(index)
        end
        index = index + 1
    end   
end

function AthleticsView:_getRange()
    local first = self.cellIndex - 4 
    if first < 1 then first = 1 end
    local last = first + 6
    return first, last
end

--关卡 85， 340
function AthleticsView:_setLevelInfo(data_)
    if #data_ <= 0 then
        self:_speak()
        return 
    end
    self._curBgIndex = 0
    local jjcFlag = cache.Copy:getJJCFlag()
    self._scrollTrue = false
    self._rankData = data_
    local posList = {85, 340}
    local cellH = (#data_+1)*197+120
    local par = self._contentView
    local len = #data_  
    local myPos = 1
    local myPosY = 0
    self._myRankNum = self:_getRank(data_)
    local min, max = self:_getRange()
    local dhState = 0
    local index = 22 - max + 1
    --------------------------------------------------清理
    if self.speakPanel then
        self.speakPanel:removeSelf()
        self.speakPanel = nil
    end
    for key,value in pairs(self._effList) do
        value:removeSelf()
    end
    self._effList = {}
    for key,value in pairs(self.cellList) do
        value:removeSelf()
    end
    self.cellList = {}
    --------------------------------------------------
    for i=max, min,-1 do
        local cx
        local cy
        if jjcFlag == 1 then
            cx = posList[(index-1)%2 + 1]
            cy = 80 + (index-1)*197
        else
            cx = posList[(index)%2 + 1]
            cy = 80 + (index-1)*197
        end
        --玩家信息
        local info = data_[i]
        if info.uId.key == cache.Player.DataInfo.roleId.key then
            myPos = i
            myPosY = cy
            local oldCache = cache.Copy:getJJCData()
            if oldCache and cache.Fight.curFightIndex > 0 then
                local r = oldCache[cache.Fight.curFightIndex]
                if info.uRank==r.uRank then
                    info = r
                    dhState = 1
                end
            end
        end
        
        local cell
        if self.cellList[index] then
            cell = self:createRoleCell(info, index, self.cellList[index])
        else
            cell = self:createRoleCell(info, index, self._cell:clone())
            self.cellList[index] = cell
        end
        if not cell:getParent() then
            par:addChild(cell, index+200)
        end
        cell:setPosition(cx, cy)
        cell:setTag(index)
        if dhState == 1 then
            local myCell = self:createRoleCell(data_[i], index, self._cell:clone())
            if not myCell:getParent() then
                par:addChild(myCell, index+200)
            end
            local flag
            if self:_checkRota(index) then
                flag = 1
            else
                flag = -1
            end
            myCell:setPosition(cx+200*flag, cy+200)
            --我跳过来
            local myMove = cc.MoveTo:create(0.4,cc.p(cx, cy))
            local callFunc2 = cc.CallFunc:create(function()
                --失败者滚走
                local rotation = cc.RepeatForever:create(transition.sequence({cc.RotateTo:create(0.2,180),cc.RotateTo:create(0.2,360)}))
                local move = cc.MoveTo:create(0.8, cc.p(cx-600*flag, cy+100))
                local callFunc = cc.CallFunc:create(function()
                    self.cellList[cell:getTag()] = myCell
                    cell:removeSelf()
                    local p = (cellH - display.height - (myPosY - 200))/(cellH-display.height)
                    if p>1 then p = 1 end
                    if p<0 then p = 0 end
                    local percent = p*100
                    self._scrollView:scrollToPercentVertical(percent,0.6,false)
                end)
                cell:runAction(rotation)
                cell:runAction(cc.Sequence:create(move, callFunc))
            end)
            local at = cc.EaseSineIn:create(myMove)
            myCell:runAction(cc.Sequence:create(at, callFunc2))
            dhState = 2
        end   
        index = index + 1
    end   
    --保存竞技场旧的排名
    cache.Copy:setJJCData(data_)
    cache.Fight.curFightIndex = 0
    
    self._scrollView:setInnerContainerSize(cc.size(640,cellH))
    if dhState == 2 then
        local p = (cellH - display.height - (myPosY - 200))/(cellH-display.height)+0.05
        if p>1 then p = 1 end
        if p<0 then p = 0 end
        local percent = p*100
        self._scrollView:jumpToPercentVertical(percent)
    else
        local p = (cellH - display.height - (myPosY - 200))/(cellH-display.height)
        if p>1 then p = 1 end
        if p<0 then p = 0 end
        local percent = p*100
        self._scrollView:jumpToPercentVertical(percent)
    end  
    self:scrollBg()
    self:_speak()
    self._scrollTrue = true
end

---获取玩家排名
function AthleticsView:_getRank(data_)
    for i=1, #data_ do
        if data_[i].uId.key == cache.Player.DataInfo.roleId.key then
            self.cellIndex = i
            return data_[i].uRank
        end
    end
end

---设置起点标志
function AthleticsView:_checkRota(index)
    local flag = cache.Copy:getJJCFlag()
    if (flag == 1 and index % 2 == 0) or (flag == 2 and index % 2 == 1) then
        return true
    end
    return false
end

function AthleticsView:createRoleCell(info, index, cell_)
    local cell = cell_
    local txtPanel = cell:getChildByName("Panel_7") 
    --图片信息
    local rolePanel = cell:getChildByName("Panel_14")
    local img = rolePanel:getChildByName("Image_13")
    img:ignoreContentAdaptWithSize(true)
    if info.uSex == 1 then
        img:loadTexture("res/views/ui_res/bg/jjc_rw_m.png")
    else
        img:loadTexture("res/views/ui_res/bg/jjc_rw_w.png")
    end
    img:setTag(info.index)
    img:addTouchEventListener(handler(self,self.onLevelClickHandler))
    
    --底部
    --local dbImg = cell:getChildByName("Image_3")
    --dbImg:ignoreContentAdaptWithSize(true)
    --dbImg:setVisible(false)

    --玩家自己检测
    local myFlagImg = cell:getChildByName("Image_15")
    if info.uId.key == cache.Player.DataInfo.roleId.key then
        self._myRank:setString(info.uRank)
        myFlagImg:loadTexture("res/views/ui_res/bg/jjc_rw_info1.png")
        ---特效
        local pIndex = 0
        if info.uRank <= 10 then
            pIndex = 1
        end
        local params = {id=404811,playIndex=0,x=-5,y=20,addTo=cell:getChildByName("Panel_2"),loadComplete=function(eff)
            if self._effList then self._effList[index] = eff end
        end,depth=200}
        mgr.effect:playEffect(params)
        --dbImg:loadTexture("res/views/ui_res/bg/jjc_rwdz.png")
        --dbImg:setVisible(true)
    else
        if info.uRank <= 10 then
            myFlagImg:loadTexture("res/views/ui_res/bg/jjc_rw_info3.png")
            local params = {id=404811,playIndex=1,x=-5,y=20,addTo=cell:getChildByName("Panel_2"),loadComplete=function(eff)
                self._effList[index] = eff
            end,depth=200}
            mgr.effect:playEffect(params)
            --dbImg:loadTexture("res/views/ui_res/bg/jjc_rwdz2.png")
            --dbImg:setVisible(true)
        else
            myFlagImg:loadTexture("res/views/ui_res/bg/jjc_rw_info2.png")
        end
    end
    
    if self:_checkRota(index) then
        rolePanel:setScaleX(-1)
        myFlagImg:setScaleX(-1)
        txtPanel:setPositionX(-115)
    else
        rolePanel:setScaleX(1)
        myFlagImg:setScaleX(1)
        txtPanel:setPositionX(-10)
    end    
    --战五次
    local sdBtn = cell:getChildByName("Button_10")
    if self._myRankNum >= info.uRank then
        sdBtn:setVisible(false)
    else
        sdBtn:addTouchEventListener(handler(self,self.onWipeBtnClick))
        sdBtn:setTag(info.index+100)
    end
    --名字
    local name = txtPanel:getChildByName("Text_8")
    name:setString(info.uName)
    local rank = txtPanel:getChildByName("Text_9")
    local pm10 = txtPanel:getChildByName("AtlasLabel_2")
    if info.uRank <= 10 then
        rank:setString(res.str.ATHLET_DESC7)    
        pm10:setString(info.uRank)
    else
        pm10:setVisible(false)
        rank:setString(res.str.ATHLET_DESC7..info.uRank)
    end
    local zl = txtPanel:getChildByName("Text_11")
    zl:setString(res.str.ATHLET_DESC8..info.uPower)
    return cell
end

function AthleticsView:scrollViewEvent(sender, evenType)
    if evenType == ccui.ScrollviewEventType.scrollToBottom then
        
    elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
        
    elseif evenType == ccui.ScrollviewEventType.scrolling then
        if self._scrollTrue then
            self:scrollBg(true)
        end    
        self._speakIndex = 0
    end
end

function AthleticsView:scrollBg(state_)
    local height = 1183
    local pos = self._contentView:convertToWorldSpace(cc.p(0,0)).y - 93
    local index = math.floor((math.abs(pos) / height )) + 1 --当前应该加载的起始index
    --debugprint("_______________________________________[竞技场]", self._curBgIndex, index, pos)
    if self._curBgIndex ~= index then
        local jjcFlag = cache.Copy:getJJCFlag()
        self._curBgIndex = index
        for key,value in pairs(self._bgList) do
            if key == "b"..index or key == "b"..(index+1) then
            else
                value:removeSelf()
                self._bgList[key] = nil
            end
        end
        for i=index,index+1 do
            local bg
            if not self._bgList["b"..i] then
                bg = self._tzBg:clone()
                self._contentView:addChild(bg,-10)
                self._bgList["b"..i] = bg
            else
                bg = self._bgList["b"..i]
            end
            local y__
            if jjcFlag == 1 then
                y__ = (i-1)*height
            else
                y__ = (i-1)*height - 197
            end
            bg:setPosition(0, y__)
        end
    end
    ---动态显示玩家
    if state_ == true then
        self:_displayCellByPos(pos)
    end
end

function AthleticsView:_speak()
    self._txtIndex = 1  --说话的编号
    if self.schNode then
        self.schNode:removeSelf()
        self.schNode = nil
    end
    self.schNode = display.newNode()
    self:addChild(self.schNode)
    self.schNode:scheduleUpdateWithPriorityLua(function(dt)
        self.speakTime = self.speakTime  + dt
        if self.speakTime > 3 then
            self.speakTime = 0
            local pos = self._contentView:convertToWorldSpace(cc.p(0,0))
            local min = math.floor((150-pos.y+1)/230 + 1) 
            local max = math.floor((550-pos.y+1)/230 + 1) 
            local who = min + self._speakIndex
            if who > max then
                self._speakIndex = 0
                who = min + self._speakIndex
            end
            if who == 3 then
                self._speakIndex = self._speakIndex + 1
                self.speakTime = 3
                return
            end
            local cell = self.cellList[who]
            if not cell then return end 
            if self.speakPanel then
                self.speakPanel:removeSelf()
                self.speakPanel = nil
            end
            if self:_checkRota(who) then
                self.speakPanel = self.view:getChildByName("Panel_1"):clone()
                self.speakTxt = self.speakPanel:getChildByName("Text_2_24")
                cell:addChild(self.speakPanel)
                self.speakPanel:setPosition(-30, 100)
            else
                self.speakPanel = self.view:getChildByName("Panel_1_0"):clone()
                self.speakTxt = self.speakPanel:getChildByName("Text_2_4_22")
                cell:addChild(self.speakPanel)
                self.speakPanel:setPosition(30, 100)
            end
            self._speakIndex = self._speakIndex + 1
            local txt = conf.Copy:getJJCSpeak()
            self.speakTxt:setString(txt[self._txtIndex])
            self._txtIndex = self._txtIndex + 1
            if self._txtIndex > #txt then
                self._txtIndex = 1
            end
            self.speakPanel:setScale(0.1)
            local scale = cc.ScaleTo:create(0.4,1)
            local act = cc.EaseElasticOut:create(scale)
            local seq = cc.Sequence:create(act)
            self.speakPanel:runAction(seq)
        end
    end, 1)
end

--点击挑战对象
function AthleticsView:onLevelClickHandler( sender,eventType )
    if cache.Fight.isClickFight == true then return end
    if eventType == ccui.TouchEventType.began then
        sender:setScale(0.5)
    elseif eventType == ccui.TouchEventType.moved then
        sender:setScale(0.35)
    elseif eventType == ccui.TouchEventType.ended then
        sender:setScale(0.35)

        local id = self._rankData[sender:getTag()].uId
        if id.key == cache.Player.DataInfo.roleId.key then
            G_TipsOfstr(res.str.ATHLET_DESC11)
            return
        end
        if self._rankData[sender:getTag()].index <= 10 and self._myRankNum > 20 then
            --G_TipsOfstr("20名以下不可挑战前10名")
            local data = {}
            data.richtext = res.str.ATHLET_DESC12
            data.surestr = res.str.ATHLET_DESC13
            data.sure = function()
                cache.Fight.curFightId = id
                cache.Friend:jumpToAthleticComp(true)
                mgr.NetMgr:send(114002,{tarId=id})
            end
            data.cancel = function()
                cache.Friend:jumpToAthleticComp(false)
            end
            local view = mgr.ViewMgr:showView(_viewname.TIPS)
            if view then view:setData(data) end
            return
        end
        ---战斗    
        if self:checkCount() == true then
            print("checkCount true")
            return
        end
        
        cache.Fight.fightState = 2
        cache.Fight.curFightId = id
        cache.Fight.curFightName = self._rankData[sender:getTag()].uName
        cache.Fight.curFightPower= self._rankData[sender:getTag()].uPower
        cache.Fight.curFightSex = self._rankData[sender:getTag()].uSex
        cache.Fight.curFightRank = self._rankData[sender:getTag()].uRank
        cache.Fight.curFightIndex = sender:getTag()
        local int64={low=self._rankData[sender:getTag()].uRank,high=0}
        print("________________________________挑战index", self._rankData[sender:getTag()].uRank)
        proxy.copy:onSFight(102002, {uId=int64})
        --mgr.NetMgr:send(102002,{uId=int64})
        cache.Fight.isClickFight = true
    end
end

function AthleticsView:checkCount()
    if self._athleticsData.aCount <= 0 then
        local iddata = nil 
        for k ,v in pairs(PRO_USE_ATHELETICS) do 
            local count = cache.Pack:getIteminfoByMid(pack_type.PRO,v)
            if count  then 
                iddata = count
                break
            end 
        end 

        if iddata then --优先使用道具
            local view = mgr.ViewMgr:showView(_viewname.ROLE_BUY_TILI)
            view:setUseMessage(iddata)
            return true
        end 


        if self._athleticsData.canBuyCount <= 0 then
            if res.banshu  then --or g_recharge
                G_TipsOfstr(res.str.TIPS_BUYOVER)
            else
                local function toChongzhi()
                    mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
                    G_GoReCharge()
                end

                local function cancel( ... )
                end
                local data = {}
                data.vip = res.str.TIPS_BUYOVER
                data.sure = toChongzhi
                data.cancel = cancel
                data.surestr= res.str.RECHARGE
                local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
                view:setData(data)
            end 
        else
            local buyTimes = (self._athleticsData.maxBuyCount - self._athleticsData.canBuyCount)/5 + 1
            local ttpr = conf.buyprice:getAthleticsPrice(buyTimes)
            local data = {cur=self._athleticsData.canBuyCount, max=self._athleticsData.maxBuyCount, yb=ttpr}
            mgr.ViewMgr:showView(_viewname.ATHLETICS_ALERT):setData(data)
        end
        return true
    end
    return false
end

function AthleticsView:setData( params_ )
    
end

function AthleticsView:onWipeBtnClick( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        if self:checkCount() == true then
            return
        end
        cache.Fight.fightState = 2
        local id={low=self._rankData[sender:getTag()-100].uRank,high=0}
        mgr.NetMgr:send(114004,{uId=id})
    end
end

function AthleticsView:onRAthleticsInfo(data_)
    self._athleticsData = data_
    self._myAward:setString(data_.money_hz)
    self._coolTime = data_.lastTime
    self._totalTime = data_.aTime
    self._curTimes = data_.aCount
    local max = cache.Player:getMaxAthleticsMax()
    if self._curTimes < max then
        self._myCoolT:setString(string.formatNumberToTimeString(self._coolTime))
    else
        self._myCoolT:setString(string.formatNumberToTimeString(0))
    end
    self._myFightT:setString(self._curTimes.."/"..max)
    self:_setLevelInfo(data_.arenaList)
    
    cache.Player:_setAthleticsCout(self._curTimes)
    cache.Player:_setAthleticsLastTime(self._coolTime)
    cache.Player:set_rearean()
    self:_beginCool()
end

function AthleticsView:_beginCool()
    local listener = function (dt)
            if self._coolTime > 0 then
                local max = cache.Player:getMaxAthleticsMax()
                if self._curTimes < max then
                    self._coolTime = self._coolTime - 1
                    self._myCoolT:setString(string.formatNumberToTimeString(self._coolTime))
                    self.tPause = false
                else
                    if not self.tPause then
                        self.tPause = true
                        self._myCoolT:setString(string.formatNumberToTimeString(0))
                    end
                end               
            else
                self._coolTime = self._totalTime    
                local max = cache.Player:getMaxAthleticsMax()
                if self._curTimes < max then
                    self._curTimes = self._curTimes + 1
                    self._myFightT:setString(self._curTimes.."/"..max)
                    self._athleticsData.aCount = self._curTimes
                    cache.Player:_setAthleticsCout(self._curTimes)
                    cache.Player:_setAthleticsLastTime(self._coolTime)
                    cache.Player:set_rearean()
                end
            end     
    end
    self:schedule(listener, 1.0, "Athletics_Listener")
end

---戰鬥結束調用
function AthleticsView:updateRank()
    local data = cache.Fight:getData()
    self._athleticsData.arenaList = data.arenaList
    self._athleticsData.aCount = data.jjcCount
    self._athleticsData.lastTime = cache.Player:getAthleticsLastTime()
    self._myFightT:setString(data.jjcCount.."/"..cache.Player:getMaxAthleticsMax())
    self:_setLevelInfo(data.arenaList)
    self._coolTime = self._athleticsData.lastTime
    self:_beginCool()
end

---战五次更新竞技场次数
function AthleticsView:updatejjcTimes(times_)
    self._athleticsData.aCount = times_
    self._curTimes = times_
    self._myFightT:setString(self._curTimes.."/"..cache.Player:getMaxAthleticsMax())
    cache.Player:_setAthleticsCout(self._curTimes)
end

---更新购买次数信息
function AthleticsView:updateGMTimes(data_)
    self._athleticsData.canBuyCount = data_.count
    self:updatejjcTimes(self._athleticsData.aCount+5)
end


function AthleticsView:onBtnShopCallBack(send,eventype )
    -- body
     if eventype == ccui.TouchEventType.ended then
        --mgr.SceneMgr:getMainScene():changeView(5)
        --G_mainView()
        mgr.SceneMgr:getMainScene():changeView(1,_viewname.SHOP)
    end
end

function AthleticsView:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        mgr.SceneMgr:getMainScene():changeView(5)
    end
end

function AthleticsView:onCloseSelfView()
    self.super.onCloseSelfView(self)
end

return AthleticsView