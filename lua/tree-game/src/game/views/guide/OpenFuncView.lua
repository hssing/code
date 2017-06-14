local OpenFuncView=class("OpenFuncView",base.BaseView)
local pet=require("game.things.PetUi")
function OpenFuncView:init(index)
    self.showtype=view_show_type.GUIDE
    self.view=self:addSelfView()
    
    local goBtn = self.view:getChildByName("Panel_1"):getChildByName("Button_1")
    goBtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))
    
    self.imgBg = self.view:getChildByName("Panel_1"):getChildByName("Image_3")

    self.panle1 = self.view:getChildByName("Panel_1")
    self.panle2 = self.view:getChildByName("Panel_1_0")

    self.panle1:setVisible(false)
    self.panle2:setVisible(false)


end

function OpenFuncView:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then    
        if self.data.id == 3002 then
            mgr.SceneMgr:getNowShowScene():setOnlyPageIndex(5)
            mgr.NetMgr:send(114001)
        elseif self.data.id == 3003 then
            mgr.SceneMgr:getNowShowScene():setOnlyPageIndex(5)
            mgr.NetMgr:send(115001,{isRest=0})
        elseif self.data.id == 3004 then
            mgr.SceneMgr:getNowShowScene():setOnlyPageIndex(5)
            proxy.Contest:sendContest()
            mgr.NetMgr:wait(519001)
        elseif self.data.id == 3005 then 
            mgr.SceneMgr:getNowShowScene():setOnlyPageIndex(5)
            local data = {roleId = cache.Player:getRoleInfo().roleId }
            proxy.Dig:sendDigMainMsg(data)
            mgr.NetMgr:wait(520002)
        elseif  self.data.id == 3006 then
            --todo
            --[[G_setMaintopinit()
             mgr.SceneMgr:getMainScene():changeView(7)
            --点击背包
            local ids = {1035}
            mgr.Guide:continueGuide__(ids)]]--
        elseif self.data.index then
            mgr.SceneMgr:getMainScene():changePageView(self.data.index)
        elseif self.data.win_name then
            mgr.SceneMgr:getMainScene():changeView(1, self.data.win_name)
        end
        self:onCloseSelfView()
    end
end

function OpenFuncView:changeTimes()
    -- body
    if not self.time  then 
        self.time = 0
    end
    self.time = self.time - 1
    if self.time < 0 then
        self.time = 0
    end 

    local str = string.formatNumberToTimeString(self.time)
    local str1 = string.format(res.str.SYS_DEC3,str) 
    self.panle2:getChildByName("Text_1_0_2"):setString(str1)

    if self.btn then 
        self.btn:setTitleText(res.str.DEC_ERR_17)
    end
    if self.time == 0 then 
        if self.btn then 
            self.btn:setTitleText(res.str.DEC_ERR_18)
        end
    else
        if self.data.mId then 
            if self.btn then 
                self.btn:setTitleText(res.str.DEC_ERR_19)
            end
        end
    end
end

--添加星星
function OpenFuncView:addStar( num )
    local panxinxin = self.panle2:getChildByName("Panel_4")

    self.panle2:reorderChild(panxinxin,6)
    panxinxin:removeAllChildren()

    local starpath=res.image.STAR
    local size=num 
    local iconheight=panxinxin:getContentSize().height
    local iconwidth=panxinxin:getContentSize().width

    --local 
    local sprite=display.newSprite(starpath)
    local w = (sprite:getContentSize().width-5)*size
    local strposX = (iconwidth -w)/2 + sprite:getContentSize().width/2

    for i=1,size do
        local sprite=display.newSprite(starpath)
        sprite:setScale(0.8)
        sprite:setPosition(strposX+(sprite:getContentSize().width- 5)*(i-1),iconheight/2)
        panxinxin:addChild(sprite)
    end
end

function OpenFuncView:initData(flag)
    -- body

    local lab_dec = self.panle2:getChildByName("Text_1_0_1")
    lab_dec:setVisible(false)

    -- 左对齐，并且多行文字顶部对齐
    local label = display.newTTFLabel({
        text = res.str.SYS_DEC1,
        font = res.ttf[1],
        size = 22,
        align = cc.TEXT_ALIGNMENT_LEFT,
        valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
        dimensions = cc.size(lab_dec:getContentSize().width, 0),
        x = lab_dec:getPositionX(),
        y =lab_dec:getPositionY()
    })
    label:setAnchorPoint(cc.p(0,1))
    label:addTo(self.panle2)

    local btn = self.panle2:getChildByName("Button_1_3") 
    btn:addTouchEventListener(handler(self, self.onBtnSureCallBack))
    if flag then 
        btn:addTouchEventListener(handler(self,self.onbtnUseTools))
    end
    self.btn = btn

    local sys = conf.Sys:getValue("tool_time")

    local name = conf.Item:getName(sys[1])
    local colorlv = conf.Item:getItemQuality(sys[1])
    local json = conf.Item:getItemSrcbymid(sys[1])
    self:addStar(colorlv)

    local lab_name = self.panle2:getChildByName("Text_1")
    lab_name:setString(name)

    local img = self.panle2:getChildByName("Image_4_12_0")
    img:setVisible(false)

    local node = pet.new(sys[1],{})
    node:setScaleX(-0.6)
    node:setScaleY(0.6)
    node:setPosition(img:getPosition())
    node:addTo(self.panle2,5)
    

    local Intimacy_id=conf.Item:getIntimacyID(sys[1])
    local itemmac = conf.CardIntimacy:getIntimacy(Intimacy_id)

    
    local otherid = itemmac.effect_ids[sys[3]]
    local othenname = conf.Item:getName(otherid) 
    local  str = string.format(res.str.SYS_DEC2,othenname)
    self.panle2:getChildByName("Text_1_0"):setString(str)

    local str2 = itemmac.plus[sys[3]]
    self.panle2:getChildByName("Text_1_0_0"):setString(res.str.SYS_DEC4)

    self.time = sys[2]
    --print(" sys[2] = ".. sys[2])
    if flag then 
        self.time = 0
        if self.data.propertys[40108] then 
            self.time = 10800 - self.data.propertys[40108].value
            --print(" self.time = ".. self.time)
        end
    end

    self:changeTimes()
    self:schedule(self.changeTimes,1.0)
end

function OpenFuncView:setData(data_)
    --self.panle1:setVisible(false)
    --self.panle2:setVisible(false)

    self.data = data_
    if data_.img_id then
        self.imgBg:loadTexture("res/views/ui_res/bg/"..data_.img_id..".png")
    end

    if data_.id  == 3006 then --显示道具
        self.panle2:setVisible(true)
        self:initData()
    else
        self.panle1:setVisible(true)
    end
end

function OpenFuncView:onCloseSelfView()
    if self.data.id  == 3006 then
        G_TipsOfstr(res.str.MAILVIEW_DEC4)
    end

    self.super.onCloseSelfView(self)
end

function OpenFuncView:setTool()
    -- body 
    self.data =  cache.Pack:getIteminfoByMid(pack_type.PRO,221015065) 
    self.panle2:setVisible(true)
    self:initData(true)
end

function OpenFuncView:onbtnUseTools(send,eventype)
    -- body
    if eventype == ccui.TouchEventType.ended then 
        if self.time == 0 then    
            local data={}
            data.index=self.data.index
            data.amount= self.data.amount
            data.mId=self.data.mId

            debugprint("使用物品！！！data.index="..data.index.." data.amount = "..data.amount
                .."  data.mId ="..data.mId)

            proxy.pack:reqGetPack(data)           
        end
         self:onCloseSelfView()
    end
end

return OpenFuncView