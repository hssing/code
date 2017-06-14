local FightOverView=class("FightOverView",base.BaseView)

function FightOverView:init(index)
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
    self.name = _viewname.FIGHT_OVER
    
    self._isCanClick = false
    local panel = self.view:getChildByName("Panel_5")
    panel:setEnabled(true)
    panel:addTouchEventListener(handler(self,self.onPanelClickHandler))
    
    self._jjcPanel = self.view:getChildByName("Panel_2")
    local compareBtn = self._jjcPanel:getChildByName("Button_1")
    local againBtn = self._jjcPanel:getChildByName("Button_2")
    compareBtn:addTouchEventListener(handler(self,self.onCompareBtnClick))
    againBtn:addTouchEventListener(handler(self,self.onAgainBtnClick))
    self._moneyPanel = self.view:getChildByName("Panel_5"):getChildByName("Panel_1")
    
    self.dhPanel = self.view:getChildByName("Panel_5"):getChildByName("Panel_3")
    
    for i=1, 3 do
        local baseItem = self.view:getChildByName("Panel_5"):getChildByName("Panel_8"):getChildByName("ItemAward_"..i)
        baseItem:setEnabled(true)
        baseItem:setTag(i)
        baseItem:addTouchEventListener(handler(self,self.onTsBtnClickHandler))
        if i==1 and res.banshu == true then
            baseItem:setVisible(false)
        end
    end

    local clickSceneTxt = self.view:getChildByName("Panel_5"):getChildByName("Image_53")
    clickSceneTxt:runAction(cc.RepeatForever:create(cc.Sequence:create({
            cc.Spawn:create({
                cc.FadeTo:create(1, 100),
                cc.ScaleTo:create(1,0.95)
            }),
            cc.Spawn:create({
                cc.FadeTo:create(1, 255),
                cc.ScaleTo:create(1,1.2)
            })
        })))


    --界面文本
    compareBtn:setTitleText(res.str.COPY_DESC15)
    againBtn:setTitleText(res.str.COPY_DESC16)

    local panel8 = panel:getChildByName("Panel_8")
    panel8:getChildByName("Text_1"):setString(res.str.COPY_DESC17)
    panel8:getChildByName("Text_2"):setString(res.str.COPY_DESC18)

    self._moneyPanel:getChildByName("Text_3"):setString(res.str.COPY_DESC19)
    self._moneyPanel:getChildByName("Image_31_0_0"):setVisible(false)
    self._moneyPanel:getChildByName("Text_20_0"):setVisible(false)

    
    mgr.Sound:playFightFailture()
end

function FightOverView:setData(data_, type_)
    self._winType = type_
    local mTxt = self._moneyPanel:getChildByName("Text_20")
    local expTxt = self._moneyPanel:getChildByName("Text_21")
    expTxt:setString(data_.exp or 0)
    
    if type_ == 1 then
        mTxt:setString(data_.moneyJb)
        self:_fbInfo(data_)
    elseif type_ == 2 then
        mTxt:setString(data_.money_hz)
        self:_jjcInfo(data_)
    elseif type_ == 3 then
        mTxt:setString(data_.guts)
        self:_towerInfo(data_)  
    elseif type_ == 5 then 
        --self:_smdsInfo(data_)
    elseif type_ == 6 or type_ == 7 then 
        self:_wjdInfo(data_)
    elseif type_ == 8 then
        self:_campInfo(data_)
    elseif type_ == 9 then
        self:_DayfubenInfo(data_)
    elseif type_ == 10 then
        self:_crossinfo(data_)
    end
    
    self:_playDh(data_)
end

function FightOverView:_crossinfo( data_ )
    -- body
    self._jjcPanel:setVisible(false)
    self._moneyPanel:setVisible(true)

    self._moneyPanel:getChildByName("Image_31"):setVisible(false)
    self._moneyPanel:getChildByName("Image_31_0"):setVisible(false)
    self._moneyPanel:getChildByName("Image_31_0_0"):setVisible(true)
    self._moneyPanel:getChildByName("Text_20_0"):setString(res.str.RES_RES_33)
    self._moneyPanel:getChildByName("Text_20_0"):setVisible(true)
    local lab_shendian = self._moneyPanel:getChildByName("Text_20")
    lab_shendian:setString(data_.dshu)

    if data_.dshu ~= 0 then
    else
        self._moneyPanel:getChildByName("Image_30"):setVisible(false)
        self._moneyPanel:getChildByName("Image_31_0_0"):setVisible(false)
        self._moneyPanel:getChildByName("Text_20_0"):setVisible(false)
        self._moneyPanel:getChildByName("Text_20"):setVisible(false)
    end


    if data_.shVal > 0 then
        local spr = self._moneyPanel:getChildByName("Image_36")
        spr:ignoreContentAdaptWithSize(true)
        spr:loadTexture(res.image.SH)
        self._moneyPanel:getChildByName("Text_21"):setString(data_.shVal)
    else
        self._moneyPanel:getChildByName("Image_30_0"):setVisible(false)
        self._moneyPanel:getChildByName("Text_21"):setVisible(false)
        self._moneyPanel:getChildByName("Image_36"):setVisible(false)

    end
    

    --[[self._moneyPanel:getChildByName("Image_30_0"):setVisible(false)
    self._moneyPanel:getChildByName("Image_36"):setVisible(false)
    self._moneyPanel:getChildByName("Text_21"):setVisible(false)
    self._moneyPanel:getChildByName("Image_31"):setVisible(false)

    local img_di = self._moneyPanel:getChildByName("Image_30")
    local img_spr = self._moneyPanel:getChildByName("Image_31_0")
    img_spr:setScale(1.0)
    img_spr:ignoreContentAdaptWithSize(true)
    local lab_value = self._moneyPanel:getChildByName("Text_20")
    if data_.shVal <= 0 then
        img_di:setVisible(false)
        img_spr:setVisible(false)
        lab_value:setVisible(false)
    else
        img_di:setVisible(true)
        img_spr:setVisible(true)
        img_spr:loadTexture(res.image.SH)
        lab_value:setString(data_.shVal)
    end]]--

    -- 创建一个居中对齐的文字显示对象
    --[[if data_.lsWin > 0 then
        local label_1 = display.newTTFLabel({
            text = string.format(res.str.RES_RES_47,data_.lsWin),
            font = res.ttf[1],
            size = 24,
            align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
        })
        print("222222")
        label_1:setPositionX(img_di:getPositionX())
        label_1:setPositionY(img_di:getPositionY()+img_di:getContentSize().height+20)
        label_1:addTo(self._moneyPanel)
    end]]--

end

function FightOverView:_DayfubenInfo( data_ )
    -- body
    self._jjcPanel:setVisible(false)
    self._moneyPanel:setVisible(false)
end

function FightOverView:_campInfo(data_)
    -- body
    self._jjcPanel:setVisible(false)
    self._moneyPanel:setVisible(false)
end

function FightOverView:_wjdInfo( data_ )
    -- body
    self._jjcPanel:setVisible(false)
    self._moneyPanel:setVisible(false)
end

function FightOverView:_smdsInfo(data_)
    -- body
     self._jjcPanel:setVisible(false)
     self._moneyPanel:setVisible(false)
end

---副本挑战
function FightOverView:_fbInfo(data_)
    self._jjcPanel:setVisible(false)
    local jbIcon = self._moneyPanel:getChildByName("Image_31")
    jbIcon:setVisible(true)
    local hzIcon = self._moneyPanel:getChildByName("Image_31_0")
    hzIcon:setVisible(false)
end

---竞技场
function FightOverView:_jjcInfo(data_)
    self._jjcPanel:setVisible(true)
    local jbIcon = self._moneyPanel:getChildByName("Image_31")
    jbIcon:setVisible(false)
    local hzIcon = self._moneyPanel:getChildByName("Image_31_0")
    hzIcon:setVisible(true)
end

---爬塔
function FightOverView:_towerInfo(data_)
    self._jjcPanel:setVisible(false)
    local jbIcon = self._moneyPanel:getChildByName("Image_31")
    jbIcon:setVisible(false)
    local iconYq = self._moneyPanel:getChildByName("Text_3")
    iconYq:setVisible(true)
    --jbIcon:loadTexture("res/views/icon")
    local hzIcon = self._moneyPanel:getChildByName("Image_31_0")
    hzIcon:setVisible(false)
    local starIcon = self._moneyPanel:getChildByName("Image_36")
    starIcon:loadTexture("res/views/ui_res/icon/star_icon.png")
    starIcon:ignoreContentAdaptWithSize(true)
end

function FightOverView:PlayWenzi(failType)
    -- body
     local function run(spr)
        -- body
        local lastPosY = 80
        local a1 =  cc.MoveTo:create(0.08,cc.p(spr:getPositionX(),lastPosY-20))  -- 下
        local a2 =  cc.MoveTo:create(0.12,cc.p(spr:getPositionX(),lastPosY+50)) --  上
        local a3 =  cc.MoveTo:create(0.05,cc.p(spr:getPositionX(),lastPosY-10)) -- 下
        local a4 =  cc.MoveTo:create(0.1,cc.p(spr:getPositionX(),lastPosY+20)) -- 上
        local a5 =  cc.MoveTo:create(0.05,cc.p(spr:getPositionX(),lastPosY))--最后停留 

        local a6 = cc.CallFunc:create(function( ... )
            -- body
             self._isCanClick = true
        end)

        local sequence = cc.Sequence:create(a1,a2,a3,a4,a5,a6)
        spr:runAction(sequence)
    end
    print("failType = "..failType)
    local str 
    if failType == 1 then 
        str = res.font.FIGHT_DEC[7]
    elseif failType == 2 then 
        str = res.font.FIGHT_DEC[1]
    elseif failType == 3 then 
        str = res.font.FIGHT_DEC[2]
    end

    local posy = 200 --开始掉落前的高度
    local sprite = display.newSprite(str)
    sprite:setPosition(display.width/2,posy)
    sprite:addTo(self.dhPanel,1000)
    run(sprite)
end

function FightOverView:_playDh(data_)
    --[[local playStrList = {
        {0, 5},  --完败
        {0, 1},  --惨败
        {0, 2}}  --惜败
    print("失败类型"..data_.fightReport.start)
    local failType = math.abs(data_.fightReport.start)
    if failType >3 or failType<1 then failType = 1 end
    local dhList = playStrList[failType]
    local function trigger()
        local params = {id=404087,playIndex=4,x=display.width/2-4,y=0,addTo=self.dhPanel,triggerFun=trigger,depth=100}
        mgr.effect:playEffect(params)
    end
    for i=1, 2 do
        local params = {id=404087,playIndex=dhList[i],x=display.width/2-4,y=0,addTo=self.dhPanel, retain=true, triggerFun=trigger,depth=200,endCallFunc=function()
            self._isCanClick = true
        end}
        mgr.effect:playEffect(params)
    end ]]
    local playStrList = {
        {0, 1},  --完败
        {0, 1},  --惨败
        {0, 1}  --惜败
    }
    print("失败类型"..data_.fightReport.start)
    local failType = math.abs(data_.fightReport.start)
    if failType >3 or failType<1 then failType = 1 end
    local dhList = playStrList[failType]


    for i=1,#dhList do
        local v = dhList[i]
        local armature = mgr.BoneLoad:loadArmature(404087,v)
        armature:setPosition(display.width/2-4,0)
        if v == 1 then ---光
            armature:setPositionY(100)
            armature:addTo(self.dhPanel,100)
        else
            armature:addTo(self.dhPanel,101)
        end
        
        if i == 2  then 

        else
            armature:getAnimation():setFrameEventCallFunc(function(bone,event,originFrameIndex,intcurrentFrameIndex)
                if event == "a1" then 
                    self:PlayWenzi(failType)
                end
            end)
        end
    end

end

function FightOverView:onCompareBtnClick( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        local id = cache.Fight.curFightId
        mgr.NetMgr:send(114002,{tarId=id})
    end
end

function FightOverView:onAgainBtnClick( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        local count = cache.Fight:getData().jjcCount
        if count <= 0 then
            G_TipsOfstr(res.str.COPY_TIPS2)
            return
        end
        if self._isCanClick == false then
            return
        end
        self._isCanClick = false       
        local id = cache.Fight.curFightRank
        local int64={low=id,high=0}
        mgr.NetMgr:send(102002,{uId=int64})
        self:onCloseSelfView()
    end
end

function FightOverView:onPanelClickHandler( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        if self._isCanClick == false then
            return
        end
        self._isCanClick = false
        if self._winType == 1 or self._winType == 2 then
            if cache.Fight.fightLevelUp > 0 then
                local view=mgr.ViewMgr:get(_viewname.LEVEL_UP)
                if not view then
                    mgr.ViewMgr:showView(_viewname.LEVEL_UP):updateUi(cache.Fight.fightLevelParams)
                end
            else
                G_FightFromEnd(self._winType)
            end
        elseif self._winType == 3 then
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
                mgr.SceneMgr:getMainScene():changePageView(5)   
                mgr.SceneMgr:getMainScene():changeView(0, _viewname.CLIMB_TOWER)   
                local view = mgr.ViewMgr:get(_viewname.CLIMB_TOWER)
                if view then
                    view:updateTower(false)
                end
            end})
        elseif self._winType == 5 then 
                mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
                local view = mgr.SceneMgr:getMainScene():changeView(0, _viewname.CONTEST_MAIN)
                view:setData()

                local _view = mgr.ViewMgr:showView(_viewname.CONTEST_VIDEO)
                local data = cache.Contest:getVideo()
                _view:setData(data)
                if proxy.Contest:getrolename()  ~= cache.Player:getName() then 
                    _view:setOther(proxy.Contest:getrolename())
                end 
            end})
        elseif self._winType == 6 then 
            --todo
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
            local view = mgr.SceneMgr:getMainScene():changeView(0, _viewname.DIG_MIAN)
            view:setData(cache.Dig:getMainData())

            local daoId = cache.Dig:getCurDaoId()
            local view = mgr.ViewMgr:showView(_viewname.DIG_INNER_MAIN)
                view:setData({daoId = daoId,state = 4 })
        
            end})
        elseif self._winType == 7 then 
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
            local view = mgr.SceneMgr:getMainScene():changeView(0, _viewname.DIG_MIAN)
            --view:setData(cache.Dig:getOtherMsg(),2)

            local param = cache.Dig:getOtherMsg()
            local data = {roleId = param.roleId,roleName = param.roleName, type = 2  }
            proxy.Dig:sendDigMainMsg(data)
            mgr.NetMgr:wait(520002)

            end})
        elseif self._winType == 8 then 
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
                local view = mgr.SceneMgr:getMainScene():changeView(0, _viewname.CAMP_MIAN)
                --view:setData()
                proxy.Camp:send120101()
            end})
        elseif self._winType == 9 then
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
                local view = mgr.SceneMgr:getMainScene():changeView(0, _viewname.FUBEN_DAY)
                view:setData(cache.DayFuben:getData())
                view:warCallBack(cache.DayFuben:getCurPage())
                --proxy.Camp:send120101()
            end})
        elseif self._winType == 10 then
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
                local view = mgr.SceneMgr:getMainScene():changeView(0, _viewname.CROSS_WAR_MAIN)
                view:setData(cache.Cross:getKFdata())
            end})
        end

          ---显示红包
    local view = mgr.ViewMgr:get(_viewname.HORNTIPS)
    if view then
        view:showRedBag()
    end
        self:onCloseSelfView()
    end
end

---实力提升按钮
function FightOverView:onTsBtnClickHandler( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        local tag = sender:getTag()
        if tag == 1 then
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {completeCallFun = function()
                mgr.SceneMgr:getMainScene():changePageView(1)
                mgr.SceneMgr:getMainScene():changeView(3, _viewname.LUCKYDRAW)
            end})
        elseif tag == 2 then
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {completeCallFun = function()
                mgr.SceneMgr:getMainScene():changePageView(2)
                --mgr.SceneMgr:getMainScene():changeView(2)
            end})
        elseif tag == 3 then
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {completeCallFun = function()
                mgr.SceneMgr:getMainScene():changePageView(2)
                --mgr.SceneMgr:getMainScene():changeView(2)
            end})
        end
    end
end

function FightOverView:onCloseSelfView()
    -- body
    self:closeSelfView()
    G_TaskShow(true)
end

return FightOverView