local GuideView=class("GuideView",base.BaseView)

function GuideView:init(index)
    self.showtype=view_show_type.GUIDE
    self.view=self:addSelfView()
    
    self.dialoguePanel = self.view:getChildByName("Panel_2")
    self.dialoguePanel:addTouchEventListener(handler(self,self.onPanelClickHandler))
    
    self.textNode = self.dialoguePanel:getChildByName("Panel_1")
    
    self.jumpBtn = self.view:getChildByName("Button_2")
    self.jumpBtn:addTouchEventListener(handler(self,self.onJumpClickHandler))


    --界面文本
    self.jumpBtn:setTitleText(res.str.GUILD_DEC61)


end

function GuideView:onJumpClickHandler( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        mgr.Guide:killGuide()
    end
end

function GuideView:enterGuide( params_ )
    print("__________引导开始id=",params_.id)
    self.guideData = params_
    --引导配置
    self.config = conf.guide:getGuideById(params_.id)
    --是否允许跳过
    if self.config.jump then
        self.jumpBtn:setVisible(false)
    end
    --清理
    if self.clip then
        self.clip:removeSelf()
        self.clip = nil
    end
    if self.shape4 then
        self.shape4:removeSelf()
        self.shape4 = nil
    end
    --判断是否有剧情对话
    if self.config.dialogues then
        self:_plotDialogue()
        if self.fingerEff and self.fingerEff:isVisible()==true then
            self.fingerEff:setVisible(false)
        end
    else
        self:_guide()
    end
end

---添加有圆圈的指示区域
function GuideView:_clipping()
    self.dialoguePanel:setVisible(false)
    local rect = self.config.rect
    local clickX = rect[2]
    local clickY
    local btnWidth = rect[4]
    local btnHeight = rect[5]
    if rect[1] == 1 then
        clickY = display.height - rect[3]
    elseif rect[1] == 2 then
        clickY = rect[3]
    elseif rect[1] == 3 then
        clickY = rect[3]*(display.height/960)
    end
    
    local circle = cc.Node:create()
    self.clip = cc.ClippingNode:create(circle)
    self.clip:setInverted(true)
    self.clip:setAlphaThreshold(0)
    self:addChild(self.clip, -1)
    self.blackLayer = cc.LayerColor:create(cc.c4b(0,0,0,0),display.width,display.height)
    self.clip:addChild(self.blackLayer)
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(function(touch,event)
        local x=touch:getLocation().x
        local y=touch:getLocation().y
        print("_________________________________点击的坐标：(",x,",",y,")")
        if x>clickX-btnWidth/2 and x <clickX+btnWidth/2 and y>clickY-btnHeight/2 and y<clickY+btnHeight/2 then
            listener:setSwallowTouches(false)
            return true
        end
        listener:setSwallowTouches(true)
        return true
    end,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(function(touch,event)
        local x=touch:getLocation().x
        local y=touch:getLocation().y
        if x>clickX-btnWidth/2 and x <clickX+btnWidth/2 and y>clickY-btnHeight/2 and y<clickY+btnHeight/2 then
            --mgr.Guide:continueGuide()
        end
    end,cc.Handler.EVENT_TOUCH_ENDED)
    listener:registerScriptHandler(function(touch,event)
        --listener:setSwallowTouches(true)
    end,cc.Handler.EVENT_TOUCH_MOVED)
    local eventDispatcher = self.blackLayer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.blackLayer)
    
    ------------------------------------------------------------
    -- self.shape4 = display.newRect(cc.rect(clickX-btnWidth/2, clickY-btnHeight/2, btnWidth, btnHeight),
    --     {borderColor = cc.c4f(0,1,0,1), borderWidth = 1})
    -- self:addChild(self.shape4)
    ------------------------------------------------------------

    local glNode  = cc.GLNode:create()
    glNode:setContentSize(cc.size(100, 100))
    glNode:setAnchorPoint(cc.p(0.5, 0.5))
    local function primitivesDraw()
        gl.lineWidth(2)
        cc.DrawPrimitives.drawColor4B(0, 0, 0, 1)
        cc.DrawPrimitives.drawSolidCircle(cc.p(clickX,clickY), 40, 0, 50, 1,1)
    end
    glNode:registerScriptDrawHandler(primitivesDraw)
    circle:addChild(glNode)
    
    --手指效果
    if not self.fingerEff then
        self.fingerEff = mgr.BoneLoad:loadArmature(404816)
        self:addChild(self.fingerEff, 200)     
        -- local params = {id=404816,x=clickX,y=clickY,addTo=self,depth=200,loadComplete=function(arm)
        --     self.fingerEff = arm
        -- end}
        -- mgr.effect:playEffect(params)
    end
    self.fingerEff:setPosition(clickX, clickY)
end

---箭头指引
function GuideView:_guide()
    self.dialoguePanel:setVisible(false)
    if self.config.rect then
        if self.fingerEff and self.fingerEff:isVisible()==false then
            self.fingerEff:setVisible(true)
        end
        self:_clipping()
    else
        mgr.Guide:checkGuideEnd()
        self:onCloseSelfView()
    end
end

---剧情对话
function GuideView:_plotDialogue()
    self.dialoguePanel:setVisible(true)
    self.speakIndex = 1
    self:_speak()
end

---开始对话
function GuideView:_speak()
    --判断是否对话完成进入指引
    if #self.config.dialogues < self.speakIndex then
        if self.guideData and self.guideData.endPlotCall then
            local func = self.guideData.endPlotCall
            func()
            self.guideData.endPlotCall = nil
        end
        self:_guide()
        return 
    end
    --显示对话内容
    self.textNode:removeAllChildren()
    local dogId = self.config.dialogues[self.speakIndex]
    local dogCof = conf.guide:getDialogueById(dogId)
    if dogCof then
        --语音
        if dogCof.sound then
            local time = dogCof.yanchi
            mgr.Sound:playCoolSound(dogCof.sound, time)
        end
        --对话内容
        local text = dogCof.dec
        local params = {text=dogCof.dec,width=530,height=80}
        local text = G_RichText(params)
        text:setPosition(-270,-50)
        self.textNode:addChild(text)
        --半身像
        local img = self.dialoguePanel:getChildByName("Panel_4"):getChildByName("Image_2")
        img:ignoreContentAdaptWithSize(true)
        local posX = 410
        local url
        if dogCof.img_id == 1 then
            local ps = cache.Player:getRoleSex()
            if ps==1 then
                url = "res/views/ui_res/bg/plot_role_1.png"
            else
                url = "res/views/ui_res/bg/plot_role_0.png"
            end
            posX = 220
            img:setScaleX(-1)
        else
            url = "res/cards/"..dogCof.img_id..".png"
            posX = 500
            img:setScaleX(1)
        end
        img:setPositionX(posX)
        img:loadTexture(url)
    end
    -----------------------------------------------
    if #self.config.dialogues == self.speakIndex then  --进化特效
        if self.config.effect and self.config.effect == 98 then
            self:playDigitalEffect(function()
                if self.guideData and self.guideData.endPlotCall then
                    local func = self.guideData.endPlotCall
                    func()
                    self.guideData.endPlotCall = nil
                end
                self:removeSelf()
            end)
        end
    end
    -----------------------------------------------
    self.speakIndex = self.speakIndex + 1   
end

---剧情对话背景点击
function GuideView:onPanelClickHandler( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        self:_speak()
    end
end

---新手引导角色出现效果
function GuideView:playNewerEffect()
    local img = self.dialoguePanel:getChildByName("Panel_4"):getChildByName("Image_2")
    img:setVisible(false)
    local ex = img:getPositionX()-67
    local ey = img:getPositionY()+176
    local params = {id=404816,x=ex,y=ey,playIndex=1,addTo=self,depth=200,triggerFun=function(tag)
        local params = {id=404816,x=ex,y=ey,playIndex=2,addTo=self,depth=200}
        mgr.effect:playEffect(params)
        img:setVisible(true)
        img:runAction(cc.FadeIn:create(0.8))
    end}
    mgr.effect:playEffect(params)
end

---数码机滚动
function GuideView:playDigitalEffect(callFun_)
    local digital = display.newSprite(res.image.BG_BAOLONGJI)
    local f = cc.p(500,400)
    digital:setPosition(f)
    local mid = cc.p(500,500)
    local e = cc.p(150, 700)
    local bezier = {
        f,
        mid,
        e,
    }
    local callFunc = cc.CallFunc:create(function()
        local m1 = cc.MoveBy:create(0.1,cc.p(-8,-16))
        local m2 = cc.MoveBy:create(0.1,cc.p(16,0))
        local m3 = cc.MoveBy:create(0.1,cc.p(-8,16))
        local seq = cc.Sequence:create(m1, m2, m3)
        digital:runAction(cc.Repeat:create(seq,2))
        local delay = cc.DelayTime:create(0.6)
        local endCall = cc.CallFunc:create(function()
            local params = {id=404816,x=digital:getPositionX(),y=digital:getPositionY(),playIndex=3,addTo=self,depth=200,endCallFunc=function()
                digital:removeSelf()
                if callFun_ then callFun_() end
            end}
            mgr.effect:playEffect(params)
        end)
        digital:runAction(cc.Sequence:create(delay, endCall))
    end)
    local bezierForward = cc.BezierTo:create(0.1, bezier)
    digital:runAction(cc.Sequence:create(bezierForward, callFunc))
    self:addChild(digital)
end

function GuideView:onCloseSelfView()
    self.super.onCloseSelfView(self)
end

return GuideView