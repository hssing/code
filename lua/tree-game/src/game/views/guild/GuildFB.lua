--
-- Author: Your Name
-- Date: 2015-08-03 14:29:47
--

local GuildFB = class("GuildFB",base.BaseView)

function GuildFB:init(index)
    self.ShowAll=true
    self.bottomType = 2
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
    
    --战斗开关
    cache.Fight.isClickFight = false
    --关闭
    self._closebtn = self.view:getChildByName("Button_close")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))
    --信息
    self._zjTxt = self.view:getChildByName("AtlasLabel_1")
    self._bg = self.view:getChildByName("Image_32")
    --关卡     
    self._cell = self.view:getChildByName("Panel_5")
    self._box = self.view:getChildByName("Panel_3")
    self.cellList = {}   
    self._ydx = self.view:getChildByName("Image_3")
    self.lineList = {}   
    self._scrollView = self.view:getChildByName("ScrollView_1") 
    self._contentView = self._scrollView:getChildByName("Panel_2")
    self._scrollView:addEventListener(handler(self,self.scrollViewEvent))
    --挑战次数
    self.fightTime = self.view:getChildByName("Panel_5_0"):getChildByName("Panel_7_11"):getChildByName("Text_10_7")
    local addTimeBtn = self.view:getChildByName("Panel_5_0"):getChildByName("Panel_7_11"):getChildByName("Button_11_12")
    addTimeBtn:addTouchEventListener(handler(self,self.onAddTimeBtnClick))
    --挑战进度
    self.bar = self.view:getChildByName("Panel_9"):getChildByName("LoadingBar_1_2")
    self.batTxt = self.view:getChildByName("Panel_9"):getChildByName("exp_2")
    self.bar_resettiem = self.view:getChildByName("Panel_9"):getChildByName("exp_2_0")
    self.bar_resettiem:setString("")
    --规则
    local gzBtn = self.view:getChildByName("Button_1")
    gzBtn:addTouchEventListener(handler(self,self.onGzBtnClick))

    --通关奖励 副本排行 成员战绩
    local panle_5 = self.view:getChildByName("Panel_5_0")
    self.panle5 = panle_5

    local btnreward = panle_5:getChildByName("Button_Guild_31")
    btnreward:addTouchEventListener(handler(self,self.onbtnReward))

    local btnrank = panle_5:getChildByName("Button_Guild_32")
    btnrank:addTouchEventListener(handler(self, self.onbtnRank))

    local btnzhanji = panle_5:getChildByName("Button_Guild_33")
    btnzhanji:addTouchEventListener(handler(self, self.onbtnZhanji))
    
    self:setRedPoint()
    --背景
    self:changeBg()

    self:initDec()
    self:schedule(self.changeTimes,1.0,"changeTimes")
end

function GuildFB:changeTimes( ... )
    -- body
    local temp_cur = os.date("*t", cache.Player:getSeverTime())
    --printt(temp_cur)
    local lastRettime = (24 - temp_cur.hour - 1)*3600 + (60-temp_cur.min - 1)*60 + 60-temp_cur.sec

    self.bar_resettiem:setString(res.str.RES_RES_50..string.formatNumberToTimeString(lastRettime))
    
end

function GuildFB:initDec( ... )
    -- body
    --local Panel_1_0 = self.view:getChildByName("Panel_1_0")
    self.view:getChildByName("Button_1"):setTitleText(res.str.GUILD_DEC_09) 
end

function GuildFB:setRedPoint()
    -- body
    local function setRedPointPanle( ppa )
        -- body
        --printt(ppa)
        local count = ppa.num--cache.Player:getYJnumber()
        ppa.panle:removeAllChildren()
        if count > 0 then 
            local spr = display.newSprite(res.image.RED_PONT)
            spr:setPosition(ppa.panle:getContentSize().width/2+ppa.x
                , ppa.panle:getContentSize().height+ ppa.y )
            spr:addTo(ppa.panle)
        end 
    end

    --print("cache.Player:getGongHFuBJLNumber() = "..cache.Player:getGongHFuBJLNumber())
    --print("cache.Player:getGongHTongGJLNumber() = "..cache.Player:getGongHTongGJLNumber())

    
        --print("FuBJL")
    local btn =  self.panle5:getChildByName("Button_Guild_32")
    local params = {}
    params.num = cache.Player:getGongHFuBJLNumber()
    params.x = 30
    params.y = 0
    params.panle = btn
    --setRedPointPanle(params)

     

    local btn =  self.panle5:getChildByName("Button_Guild_31")
    local params = {}
    params.num = cache.Player:getGongHTongGJLNumber()
    params.x = 30
    params.y = 0
    params.panle = btn

    setRedPointPanle(params)

end

function GuildFB:onbtnReward(sender, eventype )
    if eventype == ccui.TouchEventType.ended then
        --debugprint("通关奖励")
        mgr.ViewMgr:showView(_viewname.GUILD_FB_REWARD)
    end 
end
function GuildFB:onbtnRank(sender, eventype )
    if eventype == ccui.TouchEventType.ended then
        local view = mgr.ViewMgr:get(_viewname.GUILD_TWO_RABK)
        if not view then 
            view = mgr.ViewMgr:showView(_viewname.GUILD_TWO_RABK)
            view:pageviewChange(2)
        end 
        --proxy.guild:sendguildRank(1)
        --proxy.guild:waitFor(517306)
    end 
end
function GuildFB:onbtnZhanji(sender, eventype )
    if eventype == ccui.TouchEventType.ended then
       mgr.ViewMgr:showView(_viewname.GUILD_ZHANJI)
    end 
end

function GuildFB:changeBg()
    local id = cache.Guild.guildFBID  --获取章节id, 章节数据
    local config = conf.guild:getGuildChapter(id)
    self._bg:loadTexture("res/maps/"..config.mapid2..".png")
end

--数据
function GuildFB:setData( params_ )

    --如果当前最后一个关卡
   -- 如果是最后一个章节,表示敬请期待、
    local maxIdx =  conf.guild:getMaxChapterIdx()
    if maxIdx <= params_.cId % 5000  then
        params_.cId = params_.cId - 1
        local data1 = cache.Guild:getGuildFbInfo()
        data1.maxHp = 100
        data1.currHp = 100
       -- data1.fbId = 510504
        cache.Guild:setGuildFbInfo(data1)
    end

    local data = cache.Guild:getGuildFbInfo()
    self.fightTime:setString(res.str.GUILD_DEC_10..data.fbCount)
    self.fbConf = conf.guild:getGuildChapter(params_.cId)  --获取章节数据
    self._fbData = cache.Guild:getGuildFbInfo()
    self.fbPass = false
    if math.floor(self._fbData.fbId/100) > params_.cId then
        self.fbPass = true
    end
    self:_setLevelInfo()
    local zjNum = params_.cId%5000 --当前章节
    self._zjTxt:setString(zjNum)
    self.bar:setPercent(data.currHp or 0)
    local percent = math.floor((data.currHp or 0)/(data.maxHp or 100)*100).."%"
    self.batTxt:setString(percent)
end

function GuildFB:_getProress()
    if self.fbPass then
        return 5 
    else
        return (self._fbData.fbId % math.floor(self._fbData.fbId/100))
    end
end

---购买次数
function GuildFB:onAddTimeBtnClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        local data = cache.Guild:getGuildFbInfo()
        if data.canBuyCount <= 0 then
            local vip = cache.Player:getVip()
            if vip >= 17 then
                G_TipsOfstr(res.str.GUILD_DEC_11)
                return 
            end
            if res.banshu then 
                G_TipsOfstr(res.str.TIPS_BUYOVER)
            else
                local function toChongzhi()
                    mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
                    G_GoReCharge()
                end

                local function cancel( ... )
                end
                local data__ = {}
                data__.vip = res.str.TIPS_BUYOVER
                data__.sure = toChongzhi
                data__.cancel = cancel
                data__.surestr= res.str.RECHARGE
                local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
                view:setData(data__)
            end 
        else
            local buyTimes = (data.maxBuyCount - data.canBuyCount) + 1
            local ttpr = conf.buyprice:getGuildFBPrice(buyTimes)
            local data = {cur=data.canBuyCount, max=data.maxBuyCount, yb=ttpr}
            mgr.ViewMgr:showView(_viewname.ATHLETICS_ALERT):setGuildFBData(data)
        end
    end
end

---点击规则
function GuildFB:onGzBtnClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        mgr.ViewMgr:showView(_viewname.GUIZE):showByName(8)
    end
end

---更新次数
function GuildFB:updateFBCount()
    local data = cache.Guild:getGuildFbInfo()
    self.fightTime:setString(res.str.GUILD_DEC_10..data.fbCount)
end

--关卡
function GuildFB:_setLevelInfo()
    if self.speakPanel then
        self.speakPanel:removeSelf()
        self.speakPanel = nil
    end
    if self.fightEffect then
        self.fightEffect:removeSelf()
        self.fightEffect = nil
    end
    --数据显示
    self.speakTime = 3
    local posList = {180,460}
    local par = self._scrollView:getChildByName("Panel_2")
    local cellH = 8*220 + 100
    local cell__
    local fbIds = self.fbConf.levels
    local progress = self:_getProress()
    for i=1, 8 do
        local cx = posList[(i-1)%2 + 1]
        local cy = 65 + (i-1)*220
        --宝箱0/关卡标志1
        local flag = i%2
        local index = math.floor((i+1)/2)
        --引导线
        if i ~= 8 then
            local line
            if self.lineList[i] then
                line = self.lineList[i]
            else
                line = self._ydx:clone()
                table.insert(self.lineList,line)
            end
            if not line:getParent() then
                par:addChild(line)
            end
            line:setPosition(cx, cy+50)
            if i%2 == 0 then
                line:setScaleX(-1)
            end    
        end
        --关卡单元
        local cell
        if self.cellList[i] then
            cell = self.cellList[i]
        else
            if flag == 1 then
                cell = self._cell:clone()
            else
                cell = self._box:clone()
            end        
            table.insert(self.cellList, cell)
        end
        if not cell:getParent() then
            par:addChild(cell)
        end
        cell:setPosition(cx, cy)

        --信息
        local fbConfig = conf.guild:getGuildFb(fbIds[index])
        --print("__________________", index)
        if flag == 1 then          
            local imgPanel = cell:getChildByName("Panel_9")
            local url = "res/cards/"..fbConfig.model..".png"
            local img = imgPanel:getChildByName("Image_25")
            local img__ = imgPanel:getChildByName("image_gray")
            local x__, y__
            if progress > index then   
                if img then
                    x__ = img:getPositionX()
                    y__ = img:getPositionY()
                    img:removeSelf()   
                end
                if img__ then
                    img = img__
                else
                    img = display.newGraySprite(url)
                    img:setName("image_gray")
                    imgPanel:addChild(img)
                    img:setPosition(x__, y__)
                    img:setAnchorPoint(cc.p(0,0))
                end
            else
                if img__ then
                    x__ = img__:getPositionX()
                    y__ = img__:getPositionY()
                    img__:removeSelf()   
                end
                if not img then
                    img = ccui.ImageView:create(url)
                    img:setName("Image_25")
                    imgPanel:addChild(img)
                    img:setPosition(x__, y__)
                    img:setAnchorPoint(cc.p(0,0))
                end
                img:ignoreContentAdaptWithSize(true)
                img:setEnabled(true)
                img:loadTexture(url)
                imgPanel:addTouchEventListener(handler(self,self.onLevelClickHandler)) 
            end       
            imgPanel:setTag(index)        
            imgPanel:setEnabled(true)        
            local scale = G_CardScale(fbConfig.model)
            img:setScale(scale)     
            local height = img:getContentSize().height*scale + 15
            imgPanel:setContentSize(cc.size(img:getContentSize().width*scale,img:getContentSize().height*scale))
            --名字
            local name = cell:getChildByName("Text_11")
            local str = fbConfig.name or ""
            name:setString(str)
            name:setPositionY(height+10)
        else
            --奖励 404831
            local awardBtn = cell:getChildByName("Button_20")
            awardBtn:setTag(fbIds[index])
            awardBtn:addTouchEventListener(handler(self,self.onAwardBtnClick))
            local award = self._fbData.gkAwards[fbIds[index]..""]
            local e__ = cell:getChildByName("404831")
            if award == 1 then
                if not e__ then
                    local params = {id=404831,playIndex=2,x=awardBtn:getPositionX(),addName="404831",y=awardBtn:getPositionY()+58,addTo=cell,depth=-10}
                    mgr.effect:playEffect(params)
                end
                awardBtn:loadTextureNormal("res/views/ui_res/icon/guild_box.png")
                awardBtn:setContentSize(102,89)
            else
                if progress > index then
                    awardBtn:loadTextureNormal("res/views/ui_res/icon/guild_box2.png")
                    awardBtn:setContentSize(117,117)
                else
                    awardBtn:loadTextureNormal("res/views/ui_res/icon/guild_box.png")
                    awardBtn:setContentSize(102,89)
                end    
                if e__ then
                    e__:removeSelf()
                end
            end
        end

        --说话
        if flag == 1 and index==progress then
            cell__ = cell
            self:_speak(fbConfig, i)
            self:_addEffect(i)
        end
    end
    
    --scrollView的相关设置 
    local lastPosY = 200
    if cell__ then
        lastPosY = cell__:getPositionY()
    end
    self._scrollView:setInnerContainerSize(cc.size(640,cellH))
    local p = (cellH - 830 - (lastPosY - 200))/(cellH-830)
    if p>1 then p = 1 end
    if p<0 then p = 0 end
    local percent = p*100
    self._scrollView:jumpToPercentVertical(percent)
    local pos = self._contentView:convertToWorldSpace(cc.p(0,0))
    self._recordy = pos.y
end

function GuildFB:_addEffect(index_)
    local cell = self.cellList[index_]
    local params = {id=404802,x=100,y=200,addTo=cell, retain=true,depth=200,loadComplete=function(effect)
        self.fightEffect = effect
    end}
    mgr.effect:playEffect(params)
end

function GuildFB:_speak(config, index_)
    if not config.speak then return end
    local cell = self.cellList[index_]
    self.speakConf = config.speak
    if index_%2 == 0 then
        self.speakPanel = self.view:getChildByName("Panel_1"):clone()
        self.speakTxt = self.speakPanel:getChildByName("Text_2")
        cell:addChild(self.speakPanel)
        self.speakPanel:setPosition(60, 100)
    else
        self.speakPanel = self.view:getChildByName("Panel_1_0"):clone()
        self.speakTxt = self.speakPanel:getChildByName("Text_2_4")
        cell:addChild(self.speakPanel)
        self.speakPanel:setPosition(140, 100)
    end
    
    self.speakIndex = 0
    self.speakPanel:setVisible(false)
    self.speakPanel:scheduleUpdateWithPriorityLua(function(dt)
        self.speakTime = self.speakTime  + dt
        if self.speakTime > 3 then
            self.speakTime = 0
            local txt
            self.speakIndex = self.speakIndex + 1
            if self.speakIndex > #self.speakConf then
                self.speakIndex = 1   
            end
            if self.speakPanel:isVisible()==false then
                self.speakPanel:setVisible(true)
            end
            txt = self.speakConf[self.speakIndex]
            self.speakTxt:setString(txt)
            self.speakPanel:setScale(0.1)
            local scale = cc.ScaleTo:create(0.4,1)
            --local scale2 = cc.ScaleTo:create(0.1,1)
            local act = cc.EaseElasticOut:create(scale)
            local seq = cc.Sequence:create(act)
            self.speakPanel:runAction(seq)
        end
    end, 1)
end

function GuildFB:scrollViewEvent(sender, evenType)
    if evenType == ccui.ScrollviewEventType.scrollToBottom then
        
    elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
        
    elseif evenType == ccui.ScrollviewEventType.scrolling then
        local pos = self._contentView:convertToWorldSpace(cc.p(0,0))
        if self._recordy then
            local len = (self._recordy - pos.y)*0.05
            local curY = self._bg:getPositionY()
            local y
            if curY + len < -140 then
                y = -140
            elseif curY + len > 0 then
                y = 0
            else
                y = curY + len
            end
            self._bg:setPositionY(y)
            self._recordy = pos.y
        end     
    end
end

--关卡点击
function GuildFB:onLevelClickHandler( sender,eventType )
    if cache.Fight.isClickFight == true then return end
    if eventType == ccui.TouchEventType.began then
        sender:setScale(1.2)
    elseif eventType == ccui.TouchEventType.moved then
        sender:setScale(1)
    elseif eventType == ccui.TouchEventType.ended then
        ---战斗
        sender:setScale(1)
        local index = sender:getTag()
        local progress = self:_getProress()
        if progress < index then
            G_TipsOfstr(res.str.GUILD_DEC_12)
            return
        elseif progress > index then
            G_TipsOfstr(res.str.GUILD_DEC_13)
            return
        end
        local check = self:checkCount()
        if check == true then
            return
        end
        
        local info = cache.Guild:getGuildFbInfo()
        info.oldFbId = self._fbData.fbId
        proxy.copy:onSFight(102004, {fId=self._fbData.fbId})
        --mgr.NetMgr:send(102004,{fId=self._fbData.fbId})
        cache.Fight.isClickFight = true
    end
end

function GuildFB:checkCount(buy_)
    local data = cache.Guild:getGuildFbInfo()
    if data.fbCount <= 0 then
        if data.canBuyCount <= 0 then
            local vip = cache.Player:getVip()
            if vip >= 17 then
                G_TipsOfstr(res.str.GUILD_DEC_14)
                return true
            end
            if res.banshu then 
                G_TipsOfstr(res.str.TIPS_BUYOVER)
            else
                local function toChongzhi()
                    mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
                    G_GoReCharge()
                end

                local function cancel( ... )
                end
                local data__ = {}
                data__.vip = res.str.TIPS_BUYOVER
                data__.sure = toChongzhi
                data__.cancel = cancel
                data__.surestr= res.str.RECHARGE
                local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
                view:setData(data__)
            end 
        else
            local buyTimes = (data.maxBuyCount - data.canBuyCount) + 1
            local ttpr = conf.buyprice:getGuildFBPrice(buyTimes)
            local data = {cur=data.canBuyCount, max=data.maxBuyCount, yb=ttpr}
            mgr.ViewMgr:showView(_viewname.ATHLETICS_ALERT):setGuildFBData(data)
        end
        return true
    end
    return false
end

--点击关卡奖励
function GuildFB:onAwardBtnClick( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        local fbId__ = sender:getTag()
        local award = self._fbData.gkAwards[fbId__..""]
        local fbConf = conf.guild:getGuildFb(fbId__)
        local data = {}
        data.awards = fbConf.awards
        data.fbId = fbId__
        if award == 1 then
            data.get = 1
        else
            data.get = 0
        end
        --debugprint("______________________________[公会副本奖励]", fbId__)
        mgr.ViewMgr:showView(_viewname.GUILD_FB_AWARD):setData(data)
    end
end

function GuildFB:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_FB_ENTER)
        local view = mgr.ViewMgr:get(_viewname.GUILD_FB_ENTER)
        if view then
            view:setData()
        end
    end
end

function GuildFB:rGetAwardBox(data)
    for i=1, #self.cellList do
        local cell = self.cellList[i]
        local awardBtn = cell:getChildByName("Button_20")
        if awardBtn then
            local tag = awardBtn:getTag()
            if tag == data.fbId then
                awardBtn:loadTextureNormal("res/views/ui_res/icon/guild_box2.png")
                awardBtn:setContentSize(117,117)
                local e__ = cell:getChildByName("404831")
                if e__ then
                    e__:removeSelf()
                end
            end
        end
    end
end

function GuildFB:onCloseSelfView()

    G_MainGuild()
end

return GuildFB