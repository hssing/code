local ChapterView=class("ChapterView",base.BaseView)

function ChapterView:init(index)
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
    self.viewSave = true
    
    cache.Fight.isClickFight = false
    self._closebtn = self.view:getChildByName("Button_close")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))
    
    self._zjTxt = self.view:getChildByName("AtlasLabel_1")
    self._zjTxt2 = self.view:getChildByName("Text_1")
    self._bg = self.view:getChildByName("Image_32")
    
    self.awards = {}
    self.itemNames = {}
    for i=1, 3 do
        local itemBtn = self.view:getChildByName("Panel_6"):getChildByName("Award_"..i)
        self.awards[i] = itemBtn
        itemBtn:setEnabled(true)
        itemBtn:addTouchEventListener(handler(self,self.onItemBtnClick))
        self.itemNames[i] = self.view:getChildByName("Panel_6"):getChildByName("ItemName_"..i)
    end
    
    self._cell = self.view:getChildByName("Panel_5")
    self.cellList = {}
    
    self._ydx = self.view:getChildByName("Image_3")
    self.lineList = {}
    
    self._scrollView = self.view:getChildByName("ScrollView_1") 
    self._contentView = self._scrollView:getChildByName("Panel_2")
    self._scrollView:addEventListener(handler(self,self.scrollViewEvent))

    local icon = self.view:getChildByName("Panel_6"):getChildByName("Image_4")
    icon:ignoreContentAdaptWithSize(true)
    if cache.Copy.curHardLevel == 2 then
        self.fullStars = 30
        self.needTl = 1
        icon:loadTexture("res/views/ui_res/imagefont/copy_sanshixing.png")       
    elseif cache.Copy.curHardLevel == 3 then
        self.fullStars = 15
        self.needTl = 2
        icon:loadTexture("res/views/ui_res/imagefont/copy_shiwuxing.png")
    elseif cache.Copy.curHardLevel == 7 then
        self.fullStars = 15
        self.needTl = 3
        icon:loadTexture("res/views/ui_res/imagefont/copy_shiwuxing.png")
    end
    
    --背景
    self:changeBg()
end

function ChapterView:changeBg()
    local id, data = cache.Copy:getData()  --获取章节id, 章节数据
    local config = conf.Copy:getChapterInfo(id)
    self._bg:loadTexture("res/maps/"..config.mapid2..".png")
end

function ChapterView:onItemBtnClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        local id = send.tag
        G_openItem(id)
    end
end

--30星奖励
function ChapterView:_setPassAward()
    local items = self._chapterConf["award"]
    for i=1, 3 do
        if i>#items then
            self.awards[i]:setVisible(false)
            self.itemNames[i]:setVisible(false)
        else
            local itemSrc=mgr.ConfMgr.getItemSrc(items[i][1])
            local path=mgr.PathMgr.getItemImagePath(itemSrc)
            local type=conf.Item:getType(items[i][1])
            if type == pack_type.SPRITE then 
                path=mgr.PathMgr.getImageHeadPath(itemSrc)
            end 
            
            local img = self.awards[i]:getChildByName("ItemImg_"..i)
            img:loadTexture(path)
            self.awards[i].tag = items[i][1]
            local str = mgr.ConfMgr.getItemName(items[i][1]).."x"..items[i][2]
            self.itemNames[i]:setString(str)
            local lv=conf.Item:getItemQuality(items[i][1])
            local framePath=res.btn.FRAME[lv]
            self.awards[i]:loadTextureNormal(framePath)
            self.itemNames[i]:setColor(COLOR[lv])
        end
    end
end

--关卡
function ChapterView:_setLevelInfo()
    local posList = {180,460}
    local fbInfo = self._chapterData["fbInfo"]
    ----------------------清理工作------------------------
    if self.speakPanel then
        self.speakPanel:removeSelf()
        self.speakPanel = nil
    end
    if self.fightEffect then
        self.fightEffect:removeSelf()
        self.fightEffect = nil
    end
    if #fbInfo < #self.cellList then
        local len = #self.cellList
        for k=len, #fbInfo+1, -1 do
            local locCell = self.cellList[k]
            locCell:removeFromParent()
            self.cellList[k] = nil
        end
    end
    for p=1, #self.lineList do
        local locLine = self.lineList[p]
        locLine:removeFromParent()
        self.lineList[p] = nil
    end
    -----------------------------------------------------
    local par = self._scrollView:getChildByName("Panel_2")
    local totalStars = 0
    local fixH = 400
    local cellH = (#fbInfo)*220 + 100
    if cellH<550 then cellH = fixH end
    for i=1, #fbInfo do
        local cx = posList[(i-1)%2 + 1]
        local cy = 65 + (i-1)*220
        --引导线
        if i ~= #fbInfo then
            local line = self._ydx:clone()
            par:addChild(line, 50+i)
            line:setPosition(cx, cy+50)
            if i%2 == 0 then
                line:setScaleX(-1)
            end
            table.insert(self.lineList,line)
        end    
        local fbConfig = conf.Copy:getFbInfo(fbInfo[i].fId)
        local cell
        if self.cellList[i] then
            cell = self.cellList[i]
        else
            cell = self._cell:clone()
            table.insert(self.cellList, cell)
        end
        local getStar = fbInfo[i].start
        if not cell:getParent() then
            par:addChild(cell, 100+i)
        end      
        if cache.Copy.hasNew == true and getStar == 0 then
            cell:setPosition(700, cy)
            local bezier = {
                cc.p(700, cy),
                cc.p((cx+(700-cx)/2), cy+50),
                cc.p(cx, cy),
            }
            local bezierForward = cc.BezierTo:create(0.5, bezier)
            local callFun = cc.CallFunc:create(function()
                local p = {id=404830,x=cell:getPositionX(),y=cell:getPositionY(),addTo=par,depth=10}
                mgr.effect:playEffect(p)
            end)
            local seq = cc.Sequence:create(bezierForward, callFun)
            cell:runAction(seq)
            cache.Copy.hasNew = false
            self.speakTime = 2
        else
            self.speakTime = 3
            cell:setPosition(cx, cy)
        end
        
        --图片信息
        local imgPanel = cell:getChildByName("Panel_9")
        local img = imgPanel:getChildByName("Image_25")
        img:ignoreContentAdaptWithSize(true)
        img:setTag(i)
        img:setEnabled(true)
        --imgPanel:setEnabled(true)
        img:addTouchEventListener(handler(self,self.onLevelClickHandler))
        local url = "res/cards/"..fbConfig.model..".png"
        local qua = tonumber(string.sub(fbConfig.model,4,4))
        local lvl = tonumber(string.sub(fbConfig.model,9,9))
        local scale = res.card.copy[qua..""][lvl]
        img:setScale(scale)
        img:loadTexture(url)
        local height = img:getContentSize().height*scale + 15
        imgPanel:setContentSize(cc.size(img:getContentSize().width*scale,img:getContentSize().height*scale))
        --名字
        local name = cell:getChildByName("Text_11")
        local str = fbConfig.name or res.str.COPY_DESC1
        name:setString(str)
        name:setPositionY(height+10)
        --奖励
        local awardBtn = cell:getChildByName("Button_20")
        awardBtn:setTag(i+100)
        awardBtn:setEnabled(true)
        awardBtn:addTouchEventListener(handler(self,self.onAwardBtnClick))
        if i==10 then
            name:setColor(cc.c3b(245,82,251))
            awardBtn:loadTextureNormal(res.icon.BAOXIANG2)
        else
            awardBtn:loadTextureNormal(res.icon.BAOXIANG1)
        end
        --扫荡
        local sdBtn = cell:getChildByName("Button_12")
        if getStar<3 then
            sdBtn:setVisible(false)
        else
            sdBtn:setVisible(true)
            sdBtn:setTag(i+200)
            sdBtn:addTouchEventListener(handler(self,self.onWipeBtnClick))
            local leftCount = fbInfo[i].fbCount
            if leftCount > 0 then
                sdBtn:setTitleText(string.format(res.str.COPY_DESC2, leftCount))
            else
                sdBtn:setTitleText(res.str.COPY_DESC3)
            end
            
        end
        --星星
        for j=1, 3 do
            local star = cell:getChildByName("ImageStar_"..j)
            if getStar == 0 then
                star:setVisible(false)
            else
                star:setVisible(true)
                if j>getStar then
                    star:setEnabled(false)
                    star:setBright(false)
                else
                    star:setEnabled(true)
                    star:setBright(true)
                end 
                star:setPositionY(height+35)
            end
        end
        --说话
        if getStar== 0 then    
            self:_speak(fbConfig, i)
            self:_addEffect(i)
        end
        totalStars = totalStars + getStar
    end
    
    ---30星奖励
    local btn30 = self.view:getChildByName("Panel_6"):getChildByName("Button_27")
    if totalStars >= self.fullStars and self._chapterData.award==0 then
        btn30:setEnabled(true)
        btn30:setTitleText(res.str.COPY_DESC4)
        btn30:addTouchEventListener(handler(self,self.onBtn30ClickHandler))
    else
        btn30:setEnabled(false)
        btn30:setBright(false)
        if self._chapterData.award == 1 then
            btn30:setTitleText(res.str.COPY_DESC5)
        else
            btn30:setTitleText(res.str.COPY_DESC4)
        end
    end
    self._scrollView:setInnerContainerSize(cc.size(640,cellH))
    local percent
    local lvl = cache.Player:getLevel()
    if cache.Fight.curFightIndex == 0 or lvl<20 then
        percent = 0
    else
        local cell__ = self.cellList[cache.Fight.curFightIndex]
        local p
        if (cellH - fixH) == 0 then
            p = 0
        else
            p = (cellH - fixH - (cell__:getPositionY() - fixH))/(cellH-fixH)
        end
        if p>1 then p = 1 end
        if p<0 then p = 0 end
        percent = p*100--((#fbInfo-cache.Fight.curFightIndex)/#fbInfo)*100+(#fbInfo+1-cache.Fight.curFightIndex)
        print("_________________________________", percent)
    end
    self._scrollView:jumpToPercentVertical(percent)
    local pos = self._contentView:convertToWorldSpace(cc.p(0,0))
    self._recordy = pos.y
end

---添加头上可战斗标志动画
function ChapterView:_addEffect(index_)
    local cell = self.cellList[index_]
    local params = {id=404802,x=100,y=200,addTo=cell, retain=true,loadComplete=function(effect)
        self.fightEffect = effect
    end,depth=200}
    mgr.effect:playEffect(params)
end

function ChapterView:_speak(config, index_)
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
    --self.speakTime = 0
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

function ChapterView:scrollViewEvent(sender, evenType)
    if evenType == ccui.ScrollviewEventType.scrollToBottom then
        
    elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
        
    elseif evenType == ccui.ScrollviewEventType.scrolling then
        local pos = self._contentView:convertToWorldSpace(cc.p(0,0))
        --print(pos.x, pos.y)
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
function ChapterView:onLevelClickHandler( sender,eventType )
    if cache.Fight.isClickFight == true then return end
    local panel = sender:getParent()
    if eventType == ccui.TouchEventType.began then
        panel:setScale(1.2)
    elseif eventType == ccui.TouchEventType.moved then
        panel:setScale(1)
    elseif eventType == ccui.TouchEventType.ended then
        ---战斗
        panel:setScale(1)
        local tl = cache.Player:getTili()
        if tl < self.needTl then
            G_GoBuyTili()
            return
        end   
        local fbInfo = self._chapterData["fbInfo"]
        local index = sender:getTag()
        local getStar = fbInfo[index].start
        if fbInfo[index].fbCount <= 0 then
            G_TipsOfstr(res.str.COPY_TIPS1)
            return
        end
        ---设置是否进行对话
        if getStar == 0 then
            cache.Fight.curFightIndex = 0
            cache.Fight.isFightPlot = true
        else
            cache.Fight.isFightPlot = false
            cache.Fight.curFightIndex = index
        end
        
        local function startFight()
            if getStar >= 3 then
                cache.Fight.canJump = true
            else
                cache.Fight.canJump = false
            end
            cache.Fight.fightState = 1
            --mgr.NetMgr:send(102001,{sId=fbInfo[index].fId})
            proxy.copy:onSFight(102001, {sId=fbInfo[index].fId})
            cache.Fight.isClickFight = true
        end
        
        local fbConf = conf.Copy:getFbInfo(fbInfo[index].fId)
        if cache.Fight.isFightPlot==true and fbConf and fbConf.plot then
            local params = {id=fbConf.plot, endPlotCall=function()
                --剧情对话结束
                startFight()
            end}
            mgr.Guide:startFightPlot(params)
        else
            startFight()
        end    
    end
end

function ChapterView:onWipeBtnClick( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        --if cache.Player:getLevel() 


        local fbInfo = self._chapterData["fbInfo"]
        local index = sender:getTag() - 200
        if fbInfo[index].fbCount <= 0 then
            G_TipsOfstr(res.str.COPY_TIPS1)
            return
        end
        local vip = cache.Player:getVip() 
        local level = cache.Player:getLevel() 
        if vip >= 3 or level>=60 then
            local tl = cache.Player:getTili()
            if tl < self.needTl then
                G_GoBuyTili()
                return
            end
            mgr.NetMgr:send(107003,{fId=fbInfo[index].fId})
            --mgr.ViewMgr:showView(_viewname.COPY_WIPE):setData(fbInfo[index].fId, fight_vs_type.copy)
            cache.Fight.fightState = 1
        else


            local data = {};
            data.richtext = res.str.ADVENTURE_WIPE
            data.sure = function( ... )
                G_GoReCharge()
            end
            data.cancel = function()
            end
            mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
        end      
    end
end

--点击关卡奖励
function ChapterView:onAwardBtnClick( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        local info = self._chapterData["fbInfo"][sender:getTag()-100]
        mgr.ViewMgr:showView(_viewname.CHAPTER_AWARD):setData(info)
    end
end

--30星奖励
function ChapterView:onBtn30ClickHandler( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        mgr.NetMgr:send(107002,{stype=self._chapterId})
    end
end

function ChapterView:setData( params_ )
    local function enterChapter()
        local id, data = cache.Copy:getData()  --获取章节id, 章节数据
        self._chapterData = data
        self._chapterId = id
        self._chapterConf = conf.Copy:getChapterInfo(id)
        
        self:_setPassAward()
        self:_setLevelInfo()
        
        local zjNum = id%(math.floor(id/100)*100) --当前章节
        self._zjTxt:setString(zjNum)
        self._zjTxt2:setString(self._chapterConf.name or res.str.COPY_DESC6)
        local ids = {1002,1012,1026,1042,1050,1060}
        mgr.Guide:continueGuide__(ids)
    end
    
    ---从胜利界面跳出
    if params_ and params_.type == 2 then
        enterChapter()
        self:checkChapter()
    else
        enterChapter()
        cache.Copy.hasFinish = false
    end

end


--跳转对应章节
function ChapterView:gotoChapter( )
    local fbInfo = self._chapterData["fbInfo"]
    local cellH = self._scrollView:getInnerContainerSize().height
    local percent
    local lvl = cache.Player:getLevel()
     local height = self.cellList[cache.Fight.curFightIndex]:getContentSize().height
    if cellH - self._scrollView:getContentSize().height <= 0 then
       percent = 0
   else
    percent = (height * (cache.Fight.curFightIndex)) / (cellH - self._scrollView:getContentSize().height)
   end

    -- if percent > 0.9 then
    --     percent = 1
    -- elseif percent < 0 then
    --     percent = 0
    -- end


     local p = (cellH - display.height - (height * cache.Fight.curFightIndex  - 200))/(cellH-display.height)
    if p>1 then p = 1 end
    if p<0 then p = 0 end
    local percent = p*100

    print(height * (cache.Fight.curFightIndex - 1),cellH,self._scrollView:getContentSize().height)
    self._scrollView:jumpToPercentVertical(percent)
    local pos = self._contentView:convertToWorldSpace(cc.p(0,0))
    self._recordy = pos.y
    self:addFiger()
    self.isJump = true
end


function ChapterView:addFiger(  )
    local layer = ccui.Layout:create()
    layer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    layer:setBackGroundColor(cc.c3b(0, 0, 0))
    layer:setBackGroundColorOpacity(0)
    layer:setContentSize(cc.size(display.width,display.height))
    layer:setTouchEnabled(true)
    layer:setTouchSwallowEnabled(false)
    layer:setSwallowTouches(false)
    --addto:addChild(layer,100) 
    mgr.SceneMgr:getNowShowScene():addChild(layer)

    self.maskLayer = layer

    local cell  = self.cellList[cache.Fight.curFightIndex]
   -- local x,y = cell:getPosition()
    local params =  {id=404816, x=100 ,
    y=70 ,addTo=cell, playIndex=0
    ,loadComplete = function ( var  )
        -- body
        self.maskLayer:addTouchEventListener(handler(self,self.onimgCardCallBack))
        self.firget_armature = var
    end}
    mgr.effect:playEffect(params)
    -- local data = {state = 0}
    -- local panle = self.img_card:clone()
    -- --panle:removeAllChildren()
    -- panle:setOpacity(0)
    -- panle:setPosition(pos)
    -- panle:addTo(layer)
end

function ChapterView:onimgCardCallBack( send,etype )
     --self.firget_armature:removeFromParent()
     if etype == ccui.TouchEventType.ended then
            if  self.firget_armature then
                self.firget_armature:removeFromParent()
                self.firget_armature = nil
            end
        if self.maskLayer then
           self.maskLayer:removeFromParent()
           self.maskLayer = nil
        end
         
     end
end




function ChapterView:checkChapter()
    ---触发新手引导
    mgr.Guide:startGuide()
    --
    local function nextView()
        if cache.Copy:get30Award()==0 and cache.Copy:getChapterStars()==self.fullStars then
            local btn30 = self.view:getChildByName("Panel_6"):getChildByName("Button_27")
            btn30:setEnabled(true)
            btn30:setBright(true)
            btn30:setTitleText(res.str.COPY_DESC4)
            btn30:addTouchEventListener(handler(self,self.onBtn30ClickHandler))
            mgr.ViewMgr:showView(_viewname.COPY_PERFECT_VIEW):setData(self._chapterId)
        else
            if cache.Copy.hasFinish == true then
                cache.Copy.hasFinish = false
                mgr.ViewMgr:showView(_viewname.COPY_PASS_VIEW):setData(self._chapterId)
            end
        end
    end
    --战斗剧情对话
    local fbId = cache.Fight:getData().sId
    local fbConf = conf.Copy:getFbInfo(fbId)
    if cache.Fight.isFightPlot==true and fbConf and fbConf.plot_end then
        local params = {id=fbConf.plot, endPlotCall=function()
            --剧情对话结束
            nextView()
        end}
        mgr.Guide:startFightPlot(params)
    else
        nextView()
    end 
end

function ChapterView:get30Award()
    ---30星奖励
    local btn30 = self.view:getChildByName("Panel_6"):getChildByName("Button_27")
    btn30:setEnabled(false)
    btn30:setBright(false)
    btn30:setTitleText(res.str.COPY_DESC5)
end

function ChapterView:updateCopyTimes(data)
    local fbInfo = self._chapterData["fbInfo"]
    for i=1, #fbInfo do
        if data.sId == fbInfo[i].fId then
            local leftCount = data.maxCount
            fbInfo[i].fbCount = leftCount
            local cell = self.cellList[i]
            local sdBtn = cell:getChildByName("Button_12")
            if sdBtn:isVisible() == true then
                if leftCount > 0 then
                    sdBtn:setTitleText(string.format(res.str.COPY_DESC2, leftCount))
                else
                    sdBtn:setTitleText(res.str.COPY_DESC3)
                end
            end
            break
        end
    end
end

function ChapterView:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        if self.isJump then
            self.isJump = false
            G_BackToMaterial()
            
           return
        end
        mgr.SceneMgr:getMainScene():changeView(3, _viewname.COPY):setData()
    end
end

function ChapterView:onCloseSelfView()
    self:dispose()
    self.super.onCloseSelfView(self)
end

return ChapterView