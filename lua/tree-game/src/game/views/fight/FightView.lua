local FightView=class("FightView",base.BaseView)

function FightView:init()
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()    
    self.jumpBtn = self.view:getChildByName("Button_1")
    self.jumpBtn:addTouchEventListener(handler(self,self.onJumpClick))   
    self.fastBtn = self.view:getChildByName("Button_5")
    self.fastBtn:addTouchEventListener(handler(self,self.onFastClick))   
    self._tjdjTxt = self.view:getChildByName("Image_29")
    self._dfName = self.view:getChildByName("Text_12")  
    self._lvlTxt = self.view:getChildByName("AtlasLabel_1")  
    self._huiheNum = self.view:getChildByName("AtlasLabel_2")
    self._jjcPanel = self.view:getChildByName("Panel_3")
    self.fbPanel = self.view:getChildByName("Panel_1")
    self._jjcPanel:setVisible(false)
    self.fastBack = false
    --界面文本
    self.view:getChildByName("Button_1"):setTitleText(res.str.FIGHT_DESC1)
end

function FightView:initFightUI()
    self:setFastBtn()
    self:changeView()
end

---更新回合数
function FightView:updateHuiHe(num_)
    self._huiheNum:setString(num_)
end

function FightView:setFastBtn()
    if fight_guide == true then return end  ---如果是新手战斗则不用设置
    local speeds = {0.9, 1.2, 1.55,0.1}
    local key = cache.Player.DataInfo.roleId.key 
    local s = MyUserDefault.getIntegerForKey(key..user_default_keys.FIGHT_SPEED)
    --if s==0 then s = 1 end
    ---设置默认速度
    local vip = cache.Player:getVip()
    local level = cache.Player:getLevel()
    if (vip>=3 or level >= 30) then
        if s~=3 then
            MyUserDefault.setIntegerForKey(key..user_default_keys.FIGHT_SPEED, 3)
        end
        s=3       
    elseif (vip>=2 or level >= 5) then
        if s~=2 then
            MyUserDefault.setIntegerForKey(key..user_default_keys.FIGHT_SPEED, 1)
        end
        s=2
    else
        s=1
    end
    if fight_test==true then s = 1 end
    local source = {res.btn.FIGHT_MUL_1, res.btn.FIGHT_MUL_2, res.btn.FIGHT_MUL_3,res.btn.FIGHT_MUL_3}
    for j=1, #speeds do
        if j == s then
            self.speedIndex = j
            break
        end
    end
    local img = self.view:getChildByName("Button_5"):getChildByName("Image_30")
    img:loadTexture(source[self.speedIndex])
    fight_speed = speeds[self.speedIndex]
    --self:setSchedulerScale(fight_speed)
end

function FightView:onJumpClick( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        if (self.FightType == 1 and cache.Fight.canJump == true) 
            or self.FightType == 2 or self.FightType == 3 
            or self.FightType == 4 or  self.FightType == 5 or self.FightType == 6 
            or self.FightType == 7  or self.FightType == 8 or self.FightType == 9
            or self.FightType == 10 or self.FightType == 11 or self.FightType == 12 then
            mgr.Fight:jumpFight()
        else
            if g_var.fight_skip_bt ~= 0 then --作弊跳过
                mgr.Fight:jumpFight()
            elseif self.FightType == 1 then
                G_TipsOfstr(res.str.FIGHT_TIPS1)
            end
        end
    end
end

function FightView:onFastClick( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        local vip = cache.Player:getVip()
        local level = cache.Player:getLevel()
        if vip<2 and level < 5 and (self.speedIndex + 1)==2 then

           -- G_TipsOfstr("达到5级或者VIP2级才能开启2倍加速")
            G_TipsOfstr(string.format(res.str.FIGHT_TIPS2, 5,2,2))
            return 
        end
        if vip<3 and level < 30 and (self.speedIndex + 1)==3 then
            if self.fastBack == false then
                self.fastBack = true
               -- G_TipsOfstr("达到30级或者VIP3级才能开启3倍加速")
                G_TipsOfstr(string.format(res.str.FIGHT_TIPS2, 30,3,3))
                return 
            else
                self.fastBack = false
                self.speedIndex = 0
            end  
        end
               
        local speeds = {0.9, 1.2, 1.55}
        self.speedIndex = self.speedIndex + 1
        if self.speedIndex>= #speeds+1 then self.speedIndex = 1 end
        local s = self.speedIndex
        local key = cache.Player.DataInfo.roleId.key
        MyUserDefault.setIntegerForKey(key..user_default_keys.FIGHT_SPEED, s)
        fight_speed = speeds[self.speedIndex]
        self:setSchedulerScale(speeds[self.speedIndex])
        local img = self.view:getChildByName("Button_5"):getChildByName("Image_30")
        local source = {res.btn.FIGHT_MUL_1, res.btn.FIGHT_MUL_2, res.btn.FIGHT_MUL_3,res.btn.FIGHT_MUL_3}
        img:loadTexture(source[self.speedIndex])
    end
end

---加速
function FightView:setSchedulerScale(scale_)
    local pScheduler = cc.Director:getInstance():getScheduler()
    pScheduler:setTimeScale(scale_)
    fight_speed = 1
end

function FightView:changeView()
    self.FightType = cache.Fight:getType()
    if self.FightType == 1 then  --副本 
        self._tjdjTxt:setVisible(true)
        self._dfName:setVisible(false)
        self._lvlTxt:setVisible(true)
        local fbInfo = conf.Copy:getFbInfo(cache.Fight:getData().sId)
        self._lvlTxt:setString(fbInfo.match_level)
    elseif self.FightType == 2 then  --竞技场
        self._lvlTxt:setVisible(false)
        self._tjdjTxt:setVisible(false)
        self._dfName:setVisible(true)
        local name = cache.Fight.curFightName
        self._dfName:setString(name)
    elseif self.FightType == 0 then --公共战斗
        self._lvlTxt:setVisible(false)
        self._tjdjTxt:setVisible(false)
        self._dfName:setVisible(false)
        self.jumpBtn:setVisible(false)
        self.fastBtn:setVisible(false)
        --self._huiheNum:setVisible(false)
        self.view:getChildByName("Image_1"):setVisible(false)
        self.view:getChildByName("AtlasLabel_2"):setVisible(false)
        self.view:getChildByName("Image_2"):setVisible(false)
        self.view:getChildByName("AtlasLabel_2_0"):setVisible(false)
    elseif self.FightType == 3 or self.FightType == 4 then --爬塔战斗
        self._lvlTxt:setVisible(false)
        self._tjdjTxt:setVisible(false)
        self._dfName:setVisible(false)
    elseif self.FightType == 5 then 
        self._tjdjTxt:setVisible(false)
        self._lvlTxt:setVisible(false)
        self._dfName:setVisible(true)
        self._dfName:setString("")
        --local name = cache.Fight.curFightName
        local video = cache.Contest:getVideo()
        local id = proxy.copy:getVideoid()
        local flag = false
        for k , v in pairs(video.videoArrays) do 
            if v.videoId.key == id.key then 
                local name = v.roleAName.." VS "..v.roleBName
                self._dfName:setString(name)
                flag = true
                break
            end 
        end 

        if not flag then 
             for k , v in pairs(video.selfVideo) do 
                if v.videoId.key == id.key then 
                    local name = v.roleAName.." VS "..v.roleBName
                    self._dfName:setString(name)
                    break
                end 
            end 
        end 
    elseif self.FightType == 6 then
        self._lvlTxt:setVisible(false)
        self._tjdjTxt:setVisible(false)
        self._dfName:setVisible(false)
        self.jumpBtn:setVisible(false)
        self.fastBtn:setVisible(false)
        --self._huiheNum:setVisible(false)
        self.view:getChildByName("Image_1"):setVisible(false)
        self.view:getChildByName("AtlasLabel_2"):setVisible(false)
        self.view:getChildByName("Image_2"):setVisible(false)
        self.view:getChildByName("AtlasLabel_2_0"):setVisible(false)
        self.fastBtn:setVisible(true)
        --self.jumpBtn:setVisible(true)
    elseif self.FightType == 7  then
        self._lvlTxt:setVisible(false)
        self._tjdjTxt:setVisible(false)
        self._dfName:setVisible(true)
        local name = cache.Fight.curFightName
        self._dfName:setString(name)
    elseif self.FightType == 8 then 
        self._lvlTxt:setVisible(false)
        self._tjdjTxt:setVisible(false)
        self._dfName:setVisible(true)
        local name = cache.Fight.curFightName
        self._dfName:setString(name)
    elseif self.FightType == 9 then
        --todo
        
        self._tjdjTxt:setVisible(false)
        self._dfName:setVisible(false)
        self._lvlTxt:setVisible(false)
    elseif  self.FightType == 10 then
        self._lvlTxt:setVisible(false)
        self._tjdjTxt:setVisible(false)
        self._dfName:setVisible(true)
        local name = cache.Fight.curFightName
        self._dfName:setString(name)
    elseif  self.FightType == 11 then
        self._tjdjTxt:setVisible(false)
        self._lvlTxt:setVisible(false)
        self._dfName:setVisible(true)
        local _t = cache.Fight:getData()
        self._dfName:setString(_t.atkRoleName.." VS ".._t.defRoleName)
        self._dfName:setColor(COLOR[2])
    elseif self.FightType == 12 then
        self._tjdjTxt:setVisible(false)
        self._dfName:setVisible(false)
        self._lvlTxt:setVisible(false)
    end
end

---战斗开场动画
function FightView:fightBeganDh(params_)
    if self.FightType == 1 or self.FightType == 9 then  --副本 
        local p = {id=404806,x=display.cx,y=display.cy,addTo=self.fbPanel,depth=200,endCallFunc=function()
            if params_.endCallFunc then params_.endCallFunc() end
            self:setSchedulerScale(fight_speed)
        end}
        mgr.effect:playEffect(p)
        mgr.Sound:playFightPrepare()
    elseif self.FightType == 2 or self.FightType == 7 or self.FightType == 8  or self.FightType == 10 then  --竞技场 , --7 文件岛抢夺 8 阵营战
        self._jjcPanel:setVisible(true)
        local z = self._jjcPanel:getChildByName("Panel_2")
        local y = self._jjcPanel:getChildByName("Panel_2_0")
        local zFirst = z:getChildByName("Image_18")
        zFirst:setVisible(false)
        local yFirst = y:getChildByName("Image_34")
        yFirst:setVisible(false)
        local zhead = z:getChildByName("Image_6")
        local yhead = y:getChildByName("Image_6_12")
        if cache.Fight.curFightSex == 1 then
            zhead:loadTexture("res/views/ui_res/icon/icon_jjc_tx1.png")
        else
            zhead:loadTexture("res/views/ui_res/icon/icon_jjc_tx2.png")
        end
        if cache.Player:getRoleSex() == 1 then
            yhead:loadTexture("res/views/ui_res/icon/icon_jjc_tx1.png")
        else
            yhead:loadTexture("res/views/ui_res/icon/icon_jjc_tx2.png")
        end
        ---数值
        local dfNameTxt = z:getChildByName("Text_1")
        local dfZlTxt = z:getChildByName("Text_2")
        local wfNameTxt = y:getChildByName("Text_1_4")
        local wfZlTxt = y:getChildByName("Text_2_6")
        dfNameTxt:setString(cache.Fight.curFightName)
        dfZlTxt:setString(cache.Fight.curFightPower)
        wfNameTxt:setString(cache.Player:getName())
        wfZlTxt:setString(cache.Player:getPower())

        if self.FightType == 8  then
            if cache.Camp:getSelfcamp() == 2 then
                wfNameTxt:setString(cache.Fight.curFightName)
                wfZlTxt:setString(cache.Fight.curFightPower)

                dfNameTxt:setString(cache.Player:getName())
                dfZlTxt:setString(cache.Player:getPower())
            end 
        end
        ---动画
        local z = self._jjcPanel:getChildByName("Panel_2")
        z:setPositionX(-130)
        local y = self._jjcPanel:getChildByName("Panel_2_0")
        y:setPositionX(120)
        local vs = self._jjcPanel:getChildByName("Image_8")
        vs:setVisible(false)
        local zPosX = z:getPositionX()
        local zPosY = z:getPositionY()
        local yPosX = y:getPositionX()
        local yPosY = y:getPositionY()
        z:setPositionX(zPosX - 400)
        y:setPositionX(yPosX + 400)
        local move1 = cc.MoveTo:create(0.3, cc.p(zPosX, zPosY))
        local move2 = cc.MoveTo:create(0.3, cc.p(yPosX, yPosY))
        z:runAction(cc.EaseBackOut:create(move1))
        y:runAction(cc.EaseBackOut:create(move2))

        local delay = cc.DelayTime:create(0.3)
        local callFunc = cc.CallFunc:create(function()
            --vs动画
            local fadein = cc.FadeIn:create(0.1)
            local scale = cc.ScaleTo:create(0.1, 1)
            local delay2 = cc.DelayTime:create(0.5)
            local call = cc.CallFunc:create(function()
                --先手动画
                --[[local atk = params_.data["bouts"][1]["atk"]
                local xs 
                if atk > 20 then
                    xs = zFirst
                else
                    xs = yFirst
                end

                if self.FightType == 8  then
                    if tonumber(dfZlTxt:getString())> tonumber(wfZlTxt:getString()) then
                        xs = yFirst 
                    elseif  tonumber(dfZlTxt:getString())== tonumber(wfZlTxt:getString()) then   --战力相同 邪恶出手
                        xs = yFirst
                    else
                        xs = zFirst
                    end
                end]]

                if params_.data.win >= 20 then
                    xs = zFirst
                else
                    xs = yFirst
                end

                local fadein3 = cc.FadeIn:create(0.1)
                local scale3 = cc.ScaleTo:create(0.1, 1)
                local delay3 = cc.DelayTime:create(0.7)
                local call3 = cc.CallFunc:create(function()
                    --消失动画
                    local fadeout4 = cc.FadeOut:create(0.1)
                    local zMove4 = cc.MoveTo:create(0.3, cc.p(zPosX - 400, zPosY))
                    local yMove4 = cc.MoveTo:create(0.3, cc.p(yPosX + 400, yPosY))
                    local delay4 = cc.DelayTime:create(0.3)
                    local call4 = cc.CallFunc:create(function()
                        self._jjcPanel:setVisible(false)
                        if params_.endCallFunc then params_.endCallFunc() end
                        self:setSchedulerScale(fight_speed)
                    end)
                    z:runAction(cc.EaseBackIn:create(zMove4))
                    y:runAction(cc.EaseBackIn:create(yMove4))
                    vs:runAction(fadeout4)
                    y:runAction(cc.Sequence:create(delay4, call4))
                end)
                --xs:setVisible(true)
                xs:setScale(3)
                xs:runAction(cc.Sequence:create(cc.Spawn:create(fadein3, scale3), delay3, call3))
            end)
            vs:setVisible(true)
            vs:setScale(3)
            vs:runAction(cc.Sequence:create(cc.Spawn:create(fadein, scale), delay2, call))
        end)
        y:runAction(cc.Sequence:create(delay, callFunc))
    else
        if params_.endCallFunc then params_.endCallFunc() end
        self:setSchedulerScale(fight_speed)
    end
end

function FightView:jumpDh()
    self.fbPanel:setVisible(false)
    self._jjcPanel:setVisible(false)
end

return FightView