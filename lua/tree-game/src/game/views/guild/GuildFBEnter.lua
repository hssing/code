--
-- Author: Your Name
-- Date: 2015-08-03 16:01:06
--
local GuildFBEnter=class("GuildFBEnter",base.BaseView)

function GuildFBEnter:init(index)
    self.ShowAll=true
    self.bottomType = 2
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()

    self.passTable = {}
    --关闭
    self._closeBtn = self.view:getChildByName("Panel_11"):getChildByName("Button_close")
    self._closeBtn:addTouchEventListener(handler(self,self.onBtnCloseCallBack))
    --规则
    self._gzBtn = self.view:getChildByName("Panel_11"):getChildByName("Button_1")
    self._gzBtn:addTouchEventListener(handler(self,self.onGzBtnCallBack))

    --进度条
    self.bloodBar = self.view:getChildByName("Panel_9"):getChildByName("LoadingBar_1")
    self.bloodExp = self.view:getChildByName("Panel_9"):getChildByName("exp")
    self.bar_resettiem = self.view:getChildByName("Panel_9"):getChildByName("exp_0")
     self.bar_resettiem:setString("")
    --挑战次数
    self.fightTime = self.view:getChildByName("Panel_5"):getChildByName("Panel_7"):getChildByName("Text_10")
    local addTimeBtn = self.view:getChildByName("Panel_5"):getChildByName("Panel_7"):getChildByName("Button_11")
    addTimeBtn:addTouchEventListener(handler(self,self.onAddTimeBtnClick))
    --章节和名称
    self.chapterIndex = self.view:getChildByName("Panel_11"):getChildByName("AtlasLabel_1")
    
    self._scrollView = self.view:getChildByName("ScrollView_1")
    self._scrollView:addEventListener(handler(self,self.scrollViewEvent))
    self._contentView = self._scrollView:getChildByName("Panel_1")

    --通关奖励 副本排行 成员战绩
    local panle_5 = self.view:getChildByName("Panel_5")
    self.panle5 = panle_5

    local btnreward = panle_5:getChildByName("Button_Guild_31")
    btnreward:addTouchEventListener(handler(self,self.onbtnReward))

    local btnrank = panle_5:getChildByName("Button_Guild_32")
    btnrank:addTouchEventListener(handler(self, self.onbtnRank))

    local btnzhanji = panle_5:getChildByName("Button_Guild_33")
    btnzhanji:addTouchEventListener(handler(self, self.onbtnZhanji))

    self:setRedPoint()

    self:initDec()
    self:schedule(self.changeTimes,1.0,"changeTimes")
end

function GuildFBEnter:changeTimes( ... )
    -- body
    local temp_cur = os.date("*t", cache.Player:getSeverTime())
    local lastRettime = (24 - temp_cur.hour - 1)*3600 + (60-temp_cur.min - 1)*60 + 60-temp_cur.sec

    self.bar_resettiem:setString(res.str.RES_RES_50..string.formatNumberToTimeString(lastRettime))
    
end

function GuildFBEnter:initDec()
    -- body
    local Panel_11 = self.view:getChildByName("Panel_11")
    Panel_11:getChildByName("Button_1"):setTitleText(res.str.GUILD_DEC_09)
end

function GuildFBEnter:setRedPoint()
    -- body
    local function setRedPointPanle( ppa )
        -- body
        --printt(ppa)
        local count = ppa.num--cache.Player:getYJnumber()
        print("setRedPoint================",count)
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

function GuildFBEnter:onbtnReward(sender, eventype )
    -- body
    if eventype == ccui.TouchEventType.ended then
        --debugprint("通关奖励")
        mgr.ViewMgr:showView(_viewname.GUILD_FB_REWARD)
    end 
end
function GuildFBEnter:onbtnRank(sender, eventype )
    -- body
    if eventype == ccui.TouchEventType.ended then
        --proxy.guild:sendguildRank(1)
        --proxy.guild:waitFor(517306)

        local view = mgr.ViewMgr:get(_viewname.GUILD_TWO_RABK)
        if not view then 
            view = mgr.ViewMgr:showView(_viewname.GUILD_TWO_RABK)
            view:pageviewChange(2)
        end 
    end 
end
function GuildFBEnter:onbtnZhanji(sender, eventype )
    -- body
    if eventype == ccui.TouchEventType.ended then
       mgr.ViewMgr:showView(_viewname.GUILD_ZHANJI)
    end 
end

function GuildFBEnter:scrollViewEvent(sender, evenType)
    if evenType == ccui.ScrollviewEventType.scrollToBottom then

    elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then

    elseif evenType == ccui.ScrollviewEventType.scrolling then
        if self.canRoll then
            self:scrollBg()
        end  
    end
end

function GuildFBEnter:scrollBg()
    local pos = -self._contentView:convertToWorldSpace(cc.p(0,0)).y
    --更新背景
    local imgH = 960
    local gH = display.height
    for i=1, 2 do
        local img = self._contentView:getChildByName("Image_30_"..i)
        local imgY = img:convertToWorldSpace(cc.p(0,0)).y
        local y = img:getPositionY()
        --print("图片的坐标", imgY)
        if imgY <= -imgH then
            img:setPositionY(y+imgH*2)
        elseif imgY >= imgH then
            img:setPositionY(y-imgH*2)
        end
    end
    --更新关卡
    local btnH = 1085
    for j=1, 4 do
        local btn = self._contentView:getChildByName("Panel_12"):getChildByName("Button_"..j)
        local btnSize = btn:getContentSize()
        local btnY = btn:convertToWorldSpace(cc.p(0,0)).y
        local y = btn:getPositionY()
        local tag = btn:getTag()
        local nIndex
        if btnY - btnSize.height/2 > btnH then
            nIndex = tag - 4
            btn:setPositionY(y-360*4)
            self:_checkChapterOpen(nIndex, btn, j)
            local zjTxt = btn:getChildByName("Text_4_"..j)
            zjTxt:setString(string.format(res.str.GUILD_DEC_17,nIndex))
            --zjTxt:setString("第"..nIndex.."章")
            --debugprint("_______________________________[GuildFBEnter]章节", nIndex)
        elseif btnY + btnSize.height/2 < 0 then
            nIndex = tag+4
            btn:setPositionY(y+360*4)
            self:_checkChapterOpen(nIndex, btn, j)
            local zjTxt = btn:getChildByName("Text_4_"..j)
            zjTxt:setString(string.format(res.str.GUILD_DEC_17,nIndex))
            --zjTxt:setString("第"..zjTxt.."章")
            --debugprint("_______________________________[GuildFBEnter]章节", nIndex)
        end      
    end
end

function GuildFBEnter:_updateCanFight(data)
    local curLevel = math.floor(data.fbId/100)%5000
    local first = curLevel-1
    if first < 1 then first = 1 end
    local totalH = 305 + (curLevel)*360
    if totalH < display.height then totalH = display.height end
    for i = 1, 4 do
        debugprint("_______________________________[GuildFBEnter]章节", first)
        local index = (first-1)%4 + 1
        local btn = self._contentView:getChildByName("Panel_12"):getChildByName("Button_"..i)
        btn:addTouchEventListener(handler(self,self.onBtnCallBack))
        btn:setTag(first)
        local zjTxt = btn:getChildByName("Text_4_"..i)
        zjTxt:setString(string.format(res.str.GUILD_DEC_17,first))
        --zjTxt:setString("第"..first.."章")
        self:_checkChapterOpen(first, btn, i)
        local cy = 305 + (first-1)*360
        btn:setPositionY(cy)
        first  = first + 1
    end
    local bottomH = totalH - display.height
    local imgY = math.floor(bottomH / 960)*960
    for j=1, 2 do
        local img = self._contentView:getChildByName("Image_30_"..j)
        local locY = imgY + (j-1)*960
        img:setPositionY(locY)
    end
    self._scrollView:setInnerContainerSize(cc.size(640,totalH))
    self.canRoll = true
end

---购买次数
function GuildFBEnter:onAddTimeBtnClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:checkCount()
    end
end

---购买次数
function GuildFBEnter:checkCount()
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

---更新次数
function GuildFBEnter:updateFBCount()
    local data = cache.Guild:getGuildFbInfo()
    self.fightTime:setString(res.str.GUILD_DEC_10..data.fbCount)
  --  self.fightTime:setString("挑战次数："..data.fbCount)
end

--点击进入章节
function GuildFBEnter:onBtnCallBack( sender,eventype )
    if eventype == ccui.TouchEventType.ended then

        --如果是最后一个章节,表示敬请期待、
        local maxIdx =  conf.guild:getMaxChapterIdx()
        if maxIdx <= sender:getTag() or conf.guild:isForbiden(sender:getTag()) then
            G_TipsOfstr(res.str.GUILD_DEC_51)
            return
        end

        local glvl = cache.Guild:getGuildBaseInfo().guildLevel
        if glvl < 2 then
            G_TipsOfstr(res.str.GUILD_DEC_20)
            return
        end

        if  cache.Player:getLevel()<30 then 
            G_TipsOfstr(string.format(res.str.SYS_OPNE_LV,30))
            return 
        end 


        local index = sender:getTag()
        local info = cache.Guild:getGuildFbInfo()
        local cId__ = math.floor(info.fbId/100)
        local id = 5000+index  --章节id
        if id > cId__ then
            G_TipsOfstr(res.str.GUILD_DEC_18)
            return
        end
        if self.passTable[index] then
            G_TipsOfstr(res.str.GUILD_DEC_19)
            return
        end
        
        local lvl = cache.Player:getLevel()
        if lvl < 30 then
            G_TipsOfstr(res.str.GUILD_DEC_21)
            return
        end
        cache.Guild.guildFBID = id
        mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_FB)
        local view = mgr.ViewMgr:get(_viewname.GUILD_FB)
        if view then
            view:setData({cId=id})
        end
        --debugprint("__________________________[GuildFBEnter]", id)
    end
end

function GuildFBEnter:setData()


    local data = cache.Guild:getGuildFbInfo()
    local cId__ = math.floor(data.fbId/100)
    self._curChapterIndex = cId__%5000
    local chapterConf = conf.guild:getGuildChapter(cId__)
    self.chapterIndex:setString(self._curChapterIndex)
    self.bloodBar:setPercent(data.currHp or 0)
    local percent = math.floor((data.currHp or 0)/(data.maxHp or 100)*100).."%"
    self.bloodExp:setString(percent)
    --self.fightTime:setString("挑战次数："..data.fbCount)
    self.fightTime:setString(res.str.GUILD_DEC_10..data.fbCount)
    --界面
    self:_updateCanFight(data)
        --数据
   
    local maxIdx =  conf.guild:getMaxChapterIdx()
    if maxIdx <= math.floor(data.fbId/100) % 5000  then
        local data1 = cache.Guild:getGuildFbInfo()
        data1.maxHp = 100
        data1.currHp = 100
       -- data1.fbId = 510504
        cache.Guild:setGuildFbInfo(data1)
         self.bloodBar:setPercent(100)
        self.bloodExp:setString("100%")
    end
end

function GuildFBEnter:_checkChapterOpen(index_, tar, i__)

    local panel = tar:getChildByName("Panel_9_"..i__)
    local data = cache.Guild:getGuildFbInfo()
    local passIcon = tar:getChildByName("Image_47_"..i__)
    local numTxt = panel:getChildByName("Text_38_"..i__)
    local red = panel:getChildByName("Image_51_"..i__)

    --如果是最后一个章节,表示敬请期待、
    local maxIdx =  conf.guild:getMaxChapterIdx()
    if maxIdx <= index_ or  conf.guild:isForbiden(index_) then
        panel:setVisible(false)
        passIcon:setVisible(false)
        tar:getChildByName("Text_4_"..i__):setVisible(false)

        tar:setBright(false)
        local tempSrc = "res/views/ui_res/bg/guild_fb_qidai.png"
        local tmpSp = display.newSprite(tempSrc)
        tmpSp:setAnchorPoint(0.5,0.5)
        tmpSp:setName("tmpSP")
        tmpSp:addTo(tar)
        tmpSp:setPosition(tar:getContentSize().width/2,tar:getContentSize().height/2)
        tar:setTag(index_)

        print(maxIdx,tar:getTag(),"================")

    else
        panel:setVisible(true)
        passIcon:setVisible(true)
        tar:getChildByName("Text_4_"..i__):setVisible(true)
        if tar:getChildByName("tmpSP") then
            tar:getChildByName("tmpSP"):removeSelf()
        end
         tar:setBright(true)

        numTxt:setVisible(true)
        red:setVisible(true)
        panel:setVisible(true)
        tar:setTag(index_)
        if index_ > self._curChapterIndex then     
            panel:setVisible(false)
            passIcon:setVisible(false)
        elseif index_ == self._curChapterIndex then
            passIcon:setVisible(false)
            local bar = panel:getChildByName("LoadingBar_1_"..i__)
            local txt = panel:getChildByName("exp_3_"..i__)
            bar:setPercent(data.currHp or 0)
            local percent = math.floor((data.currHp or 0)/(data.maxHp or 100)*100).."%"
            txt:setString(percent)
            local awards = data.gkAwards
            local num = 0
            for i=1, 4 do
                local cId__ = (5000+index_)*100+i
                if awards[cId__..""] then
                    num = num + 1
                end
            end
            if num > 0 then
                numTxt:setString(num)
            else
                numTxt:setVisible(false)
                red:setVisible(false)
            end
        elseif index_ < self._curChapterIndex then
            passIcon:setVisible(true)
            local awards = data.gkAwards
            local state = false
            local num = 0
            for i=1, 4 do
                local cId__ = (5000+index_)*100+i
                if awards[cId__..""] then
                    num = num + 1
                end
            end
            debugprint("_______________________________[checkChapterOpen]", index_, num)
            if num > 0 then
                local bar = panel:getChildByName("LoadingBar_1_"..i__)
                local txt = panel:getChildByName("exp_3_"..i__)
                local numTxt = panel:getChildByName("Text_38_"..i__)
                numTxt:setString(num)
                bar:setPercent(100)
                txt:setString("100%")
            else
                panel:setVisible(false)
                self.passTable[index_] = 1
            end    
        end


    end

   
end

function GuildFBEnter:onGzBtnCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        mgr.ViewMgr:showView(_viewname.GUIZE):showByName(8)
    end
end

function GuildFBEnter:onBtnCloseCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:onCloseSelfView()
    end
end

function GuildFBEnter:onCloseSelfView()
    G_MainGuild()
end

return GuildFBEnter