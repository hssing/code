local FightWinView=class("FightWinView",base.BaseView)

function FightWinView:init(index)
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
    self.name = _viewname.FIGHT_WIN
    
    self._isCanClick = false
    self._zsPanel = self.view:getChildByName("Panel_5"):getChildByName("Panel_6")
    self._zsLabel = self._zsPanel:getChildByName("AtlasLabel_1")
    
    self._copyPanel = self.view:getChildByName("Panel_5"):getChildByName("Panel_8")
    self._jjcPanel = self.view:getChildByName("Panel_5"):getChildByName("Panel_8_0")
    self._guildPanel = self.view:getChildByName("Panel_5"):getChildByName("Panel_8_0_0")

    self.panle_boss = self.view:getChildByName("Panel_5"):getChildByName("Panel_8_1")
    
    local panel = self.view:getChildByName("Panel_5")
    panel:setEnabled(true)
    panel:addTouchEventListener(handler(self,self.onPanelClickHandler))

    --跨服战
    self.crosspanel = self.view:getChildByName("Panel_5"):getChildByName("Panel_8_0_1")
    self.crosspanel:setVisible(false) 
    
    self.dhPanel = self.view:getChildByName("Panel_5"):getChildByName("Panel_1")

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

    self._panelPos = cc.p(0,110)


    ---界面文本
    self._copyPanel:getChildByName("Panel_3"):getChildByName("Text_8"):setString(res.str.COPY_DESC19)
    mgr.Sound:playFightSuccess()
end



function FightWinView:setData(data_, type_)
    self._winType = type_
    if type_ == 1 then
        self:_fbInfo(data_)
    elseif type_ == 2 then
        self:_jjcInfo(data_)
    elseif type_ == 3 then
        self:_towerInfo(data_)
    elseif type_ == 4 then
        self:_guildInfo(data_)
    elseif type_ == 5 then 
        self:_smdsInfo(data_)
    elseif type_ == 6 then 
        self:_wjdInfo(data_)
    elseif type_ == 7 then 
        self:_wjdqdInfo(data_)
    elseif type_ == 8 then 
        self:_campInfo(data_) 
    elseif type_ == 9 then 
        self:_dayfbInfo(data_)
    elseif type_ == 10 then
        self:_crossInfo(data_) 
    elseif type_ == 11 then 
        self:_crossvedioInfo(data_)
    elseif type_ == 12 then 
         self:_BossInfo(data_)
    end
end

function FightWinView:_BossInfo( data_ )
    -- body
    self._copyPanel:setVisible(false)
    self._zsPanel:setVisible(false)
    self._jjcPanel:setVisible(false)
    self._guildPanel:setVisible(false)

    self.panle_boss:setPosition(self._panelPos)


    local panle = self.panle_boss:getChildByName("Panel_3_5") 
    local lab_hurt = panle:getChildByName("Text_20_6")
    lab_hurt:setString(data_.hurt)

    local lab_gongxian = panle:getChildByName("Text_21_8")

    local btnFrame = panle:getChildByName("ItemAward_2_4")
    local colorlv = conf.Item:getItemQuality(221051001) 
    btnFrame:loadTextureNormal(res.btn.FRAME[colorlv])

    local spr = btnFrame:getChildByName("awardImg_1_2_23")
    spr:loadTexture(conf.Item:getItemSrcbymid(221051001))

    local lab_name = btnFrame:getChildByName("Text_4_2_12")
    lab_name:setString(conf.Item:getName(221051001).."x"..data_.gold)

    local dec = panle:getChildByName("Text_4_2_12_0")
    dec:setString(res.str.RES_GG_62)

    local btnFrame1 = panle:getChildByName("ItemAward_2_4_0")
    btnFrame1:setVisible(false)

    for k ,v in pairs(data_.itemList) do 
        if k > 1 then 
            return 
        end
        btnFrame1:setVisible(true)
        local colorlv = conf.Item:getItemQuality(v.mId)
        btnFrame1:loadTextureNormal(res.btn.FRAME[colorlv])

        local spr = btnFrame1:getChildByName("awardImg_1_2_23_7")
        spr:loadTexture(conf.Item:getItemSrcbymid(v.mId))

         local lab_name = btnFrame1:getChildByName("Text_4_2_12_6")
         lab_name:setString(conf.Item:getName(v.mId).."x"..v.amount)
    end

    self:_playDh(data_)
end

function FightWinView:_crossvedioInfo( data_ )
    -- body
    self._copyPanel:setVisible(false)
    self._zsPanel:setVisible(false)
    self:_playDh(data_)
end

function FightWinView:_crossInfo( data_ )
    -- body
    self._jjcPanel:setVisible(false)
    self._guildPanel:setVisible(false)
    self._zsPanel:setVisible(false)
    self._copyPanel:setVisible(false)

    self.crosspanel:setVisible(true)
    local panel = self.crosspanel:getChildByName("Panel_3_10_15")
    panel:getChildByName("Text_20_10_16_0"):setString(res.str.RES_RES_33)
    --胜利点数
    local conf_data = conf.Cross:getDwItem(data_.roleDw)
    local morevalue = conf_data.lxwin_awards[data_.lsWin] or conf_data.lxwin_awards[#conf_data.lxwin_awards]

    local lab_dian = panel:getChildByName("Text_20_10_16")
    lab_dian:setString(data_.dshu-morevalue)

    local lab_dec =  panel:getChildByName("Text_20_1")
    local lab_times = panel:getChildByName("Text_20_2")
    local lab_dec_1 =  panel:getChildByName("Text_20_3")
    local lab_dec_2 =  panel:getChildByName("Text_20_4")
    local img_xian = panel:getChildByName("Image_35")
    --神魂
    local img_sh_di = panel:getChildByName("Image_30_0_57_59")
    local img_sh = panel:getChildByName("Image_36_59_61")
    local lab_sh = panel:getChildByName("Text_21_12_18")
    

    self.crosspanel:setPosition(self._panelPos)

    if data_.shVal <= 0 then
        img_sh_di:setVisible(false)
        img_sh:setVisible(false)
        lab_sh:setString("")
    else
        img_sh_di:setVisible(true)
        img_sh:setVisible(true)
        lab_sh:setString(data_.shVal)
    end

    if data_.dshu <= 0 then
        lab_dian:setVisible(false)
        panel:getChildByName("Image_36_59_61_0"):setVisible(false)
        panel:getChildByName("Text_20_10_16_0"):setVisible(false)
        panel:getChildByName("Image_30_52_55"):setVisible(false)

        lab_dec:setString("")
        lab_times:setString("")
        lab_dec_1:setString("")
        lab_dec_2:setString("")

        img_xian:setVisible(false)
    else
    	if morevalue > 0 then
        	lab_dec:setString(res.str.RES_RES_44)
        	lab_times:setString(string.format(res.str.RES_RES_45,data_.lsWin))
            lab_dec_1:setString(res.str.RES_RES_46)
            lab_dec_2:setString(morevalue)
            img_xian:setVisible(true)
        else
        	lab_dec:setString("")
            lab_times:setString("")
            lab_dec_1:setString("")
            lab_dec_2:setString("")

            img_xian:setVisible(false)
        end
        
    end
    self:_playDh(data_)
end

function FightWinView:_campInfo( data_ )
    -- body
    self._jjcPanel:setVisible(false)
    self._guildPanel:setVisible(false)
    self._zsPanel:setVisible(false)

    local count = self._copyPanel:getChildren()
    for k ,v in pairs(count) do 
        v:setVisible(false)
    end

    local Panel_3 = self._copyPanel:getChildByName("Panel_3")
    Panel_3:setVisible(true)

    local count = Panel_3:getChildren()
    for k ,v in pairs(count) do 
        v:setVisible(false)
    end
    local jb , hz ,winCount , stopwinCount = cache.Camp:getWinReward()
    local _img = Panel_3:getChildByName("Image_30")
    _img:setVisible(true)
    local img_type =  Panel_3:getChildByName("Image_31"):setVisible(true)
    local lab_txt = Panel_3:getChildByName("Text_20"):setVisible(true)
    lab_txt:setString(jb)

    local img2= Panel_3:getChildByName("Image_30_0")
    img2:setVisible(true)
    local img_type_hz =  Panel_3:getChildByName("Image_36"):setVisible(true)
    local lab_txt_hz = Panel_3:getChildByName("Text_21"):setVisible(true)
    lab_txt_hz:setString(hz)
    img_type_hz:ignoreContentAdaptWithSize(true)
    img_type_hz:loadTexture(res.image.BADGE)

    if cache.Camp:getSelfWin() then 
        local height = _img:getContentSize().height 
        if stopwinCount > 0 then 
            local params_ = {text = {}, width= _img:getContentSize().width , height=_img:getContentSize().height} 
            params_.text[#params_.text+1] = {res.str.DEC_ERR_69,{255,255,255},20}
            params_.text[#params_.text+1] = {stopwinCount,{255,0,0},20}
            params_.text[#params_.text+1] = {res.str.DEC_ERR_68,{255,255,255},20}

            local richtext = G_RichText(params_)
            richtext:setAnchorPoint(cc.p(0.5,0.5))
            richtext:setPosition(_img:getPositionX() + _img:getContentSize().width/4 ,_img:getPositionY()+height )
            richtext:addTo(Panel_3) 
            height = height*2
        end

        local params_ = {text = {}, width= _img:getContentSize().width , height=_img:getContentSize().height} 
        params_.text[#params_.text+1] = {res.str.DEC_ERR_67,{255,255,255},20}
        params_.text[#params_.text+1] = {winCount,{18,255,0},20}
        params_.text[#params_.text+1] = {res.str.DEC_ERR_68,{255,255,255},20}
        local richtext = G_RichText(params_)
        richtext:setAnchorPoint(cc.p(0.5,0.5))
        richtext:setPosition(_img:getPositionX() + _img:getContentSize().width/4,_img:getPositionY()+height - 20 )
        richtext:addTo(Panel_3) 
    else
        local height = _img:getContentSize().height 
        if winCount > 0 then 
            local params_ = {text = {}, width= _img:getContentSize().width , height=_img:getContentSize().height} 
            params_.text[#params_.text+1] = {res.str.DEC_ERR_75,{255,255,255},20}
            params_.text[#params_.text+1] = {winCount,{255,0,0},20}
            params_.text[#params_.text+1] = {res.str.DEC_ERR_68,{255,255,255},20}

            local richtext = G_RichText(params_)
            richtext:setAnchorPoint(cc.p(0.5,0.5))
            richtext:setPosition(_img:getPositionX() + _img:getContentSize().width/4 ,_img:getPositionY()+height )
            richtext:addTo(Panel_3) 
            height = height*2
        else
            _img:setVisible(false)
            img_type:setVisible(false)
            lab_txt:setVisible(false)

            img2:setVisible(false)
            img_type_hz:setVisible(false)
            lab_txt_hz:setVisible(false)
        end  
    end
    self:_playDh(data_)
end

function FightWinView:_wjdqdInfo( data_ )
    -- body
    self._jjcPanel:setVisible(false)
    self._guildPanel:setVisible(false)
    self._zsPanel:setVisible(false)

    local count = self._copyPanel:getChildren()
    for k ,v in pairs(count) do 
        v:setVisible(false)
    end

    local Panel_3 = self._copyPanel:getChildByName("Panel_3")
    Panel_3:setVisible(true)
    local count = Panel_3:getChildren()
    for k ,v in pairs(count) do 
        v:setVisible(false)
    end
    Panel_3:getChildByName("Image_30"):setVisible(true)
    local img_type =  Panel_3:getChildByName("Image_31"):setVisible(true)
    local lab_txt = Panel_3:getChildByName("Text_20"):setVisible(true)
    lab_txt:setString(data_.gotCount)

    local arg = conf.Item:getArg1(data_.resType)
    local mId =arg.arg5
    local icon = res.image.GOLD
    if mId == 221051003 then 
        icon = res.image.BADGE
    elseif mId == 221051002 then 
        icon = res.image.ZS
    else

    end 
    --[[if data_.resType == 2 then 
       icon = res.image.ZS
    elseif data_.resType == 3 then
        icon = res.image.BADGE
    else
        icon = res.image.GOLD
    end ]]--
    img_type:loadTexture(icon)

    local _txt = lab_txt:clone()
    _txt:setAnchorPoint(cc.p(1,0.5))
    _txt:setString(res.str.DEC_ERR_09)
    _txt:setPosition(img_type:getPositionX()-img_type:getContentSize().width/2,lab_txt:getPositionY())
    _txt:addTo(Panel_3)

    self:_playDh(data_)
end

function FightWinView:_wjdInfo(data_)
    -- body
    self._copyPanel:setVisible(true)
    self._zsPanel:setVisible(false)

    local reward = {}
    local array = self._copyPanel:getChildByName("Panel_3"):getChildren()
    for k ,v in pairs(array) do 
        v:setVisible(false)
    end 

    local t = {}
    t.btnframe = self._copyPanel:getChildByName("Panel_3"):getChildByName("ItemAward_1")
    t.spr = t.btnframe:getChildByName("awardImg_1_1")
    t.lab = t.btnframe:getChildByName("Text_4_1")
    table.insert(reward,t)

    local t = {}
    t.btnframe = self._copyPanel:getChildByName("Panel_3"):getChildByName("ItemAward_2")
    t.spr = t.btnframe:getChildByName("awardImg_1_2")
    t.lab = t.btnframe:getChildByName("Text_4_2")

    t.btnframe:setPositionX(t.btnframe:getPositionX()+5)

    table.insert(reward,t)

    local t = {}
    t.btnframe = self._copyPanel:getChildByName("Panel_3"):getChildByName("ItemAward_3")
    t.spr = t.btnframe:getChildByName("awardImg_1_3")
    t.lab = t.btnframe:getChildByName("Text_4_3")
    t.btnframe:setPositionX(t.btnframe:getPositionX()+10)
    table.insert(reward,t)

    local t = {}
    t.btnframe = self._copyPanel:getChildByName("Panel_3"):getChildByName("ItemAward_4")
    t.spr = t.btnframe:getChildByName("awardImg_1_4")
    t.lab = t.btnframe:getChildByName("Text_4_4")
    t.btnframe:setPositionX(t.btnframe:getPositionX()+15)
    table.insert(reward,t)

    for k , v in pairs(reward) do 
        v.btnframe:setVisible(false)
    end 

    local daoId = cache.Dig:getCurDaoId()
    local msg = conf.Tong:getItemMsg(900100+daoId)
    local rewarddata = msg.awards --奖励物品
    for k , v in pairs(rewarddata) do 
        if k > 3 then 
            break;
        end 
        local widget = reward[k]
        widget.btnframe:setVisible(true)
        printt(v)
        local colorlv = conf.Item:getItemQuality(v[1])
        local json = conf.Item:getItemSrcbymid(v[1]) 

        widget.btnframe:loadTextureNormal(res.btn.FRAME[colorlv])
        widget.spr:loadTexture(json)

        widget.lab:setString(conf.Item:getName(v[1]) .. "x"..v[2])
        widget.lab:setColor(COLOR[colorlv])
    end 

    self:_playDh(data_)
end
--日常副本
function FightWinView:_dayfbInfo(data_ )
    -- body
    self._copyPanel:setVisible(true)
    self._jjcPanel:setVisible(false)
    self._copyPanel:setPosition(self._panelPos)

    local Panel_3 = self._copyPanel:getChildByName("Panel_3")
    local mTxt = Panel_3:getChildByName("Text_20")
    local expTxt = Panel_3:getChildByName("Text_21")
    mTxt:setString("")
    expTxt:setString("")

    Panel_3:getChildByName("Image_30"):setVisible(false)
    Panel_3:getChildByName("Image_31"):setVisible(false)
    Panel_3:getChildByName("Image_30_0"):setVisible(false)
    Panel_3:getChildByName("Image_36"):setVisible(false)
    Panel_3:getChildByName("Image_36"):setVisible(false)
    Panel_3:getChildByName("Text_8"):setVisible(false)
    

   --[[ local img_m =  self._copyPanel:getChildByName("Panel_3"):getChildByName("Image_31")
    img_m:ignoreContentAdaptWithSize(true)
    img_m:loadTexture(res.image.GOLD)

    local img_z =  self._copyPanel:getChildByName("Panel_3"):getChildByName("Image_36")
    img_z:ignoreContentAdaptWithSize(true)
    img_z:loadTexture(res.image.ZS)]]

    --mTxt:setString(data_.moneyJb)
    --expTxt:setString(data_.moneyZs)
    --expTxt:setString(data_.exp)
    if data_.moneyZs > 0 then
        self._zsPanel:setVisible(true)
        self._zsLabel:setString(data_.moneyZs)
    else
        self._zsPanel:setVisible(false)
    end
    local items = data_.items
    local startx = 320 - 60*(#items - 1)
    for i=1, 4 do
        local baseItem = self._copyPanel:getChildByName("Panel_3"):getChildByName("ItemAward_"..i)
        if i>#items then
            baseItem:setVisible(false)
        else
            baseItem:setPositionX(startx + 120*(i-1))
            local img = baseItem:getChildByName("awardImg_1_"..i)
            local path= conf.Item:getItemSrcbymid(items[i].mId)
            img:loadTexture(path)
            local txt = baseItem:getChildByName("Text_4_"..i)
            local str = conf.Item:getName(items[i].mId).."x"..items[i].amount
            txt:setString(str)
            local lv=conf.Item:getItemQuality(items[i].mId)
            local framePath=res.btn.FRAME[lv]
            baseItem:loadTextureNormal(framePath)
            txt:setColor(COLOR[lv])
        end        
    end
    self:_playDh(data_)
end

---副本挑战
function FightWinView:_fbInfo(data_)
    self._copyPanel:setVisible(true)
    self._jjcPanel:setVisible(false)
    self._copyPanel:setPosition(self._panelPos)
    local mTxt = self._copyPanel:getChildByName("Panel_3"):getChildByName("Text_20")
    local expTxt = self._copyPanel:getChildByName("Panel_3"):getChildByName("Text_21")
    mTxt:setString(data_.moneyJb)
    expTxt:setString(data_.exp)
    if data_.moneyZs > 0 then
        self._zsPanel:setVisible(true)
        self._zsLabel:setString(data_.moneyZs)
    else
        self._zsPanel:setVisible(false)
    end
    local items = data_.items
    local startx = 320 - 60*(#items - 1)
    for i=1, 4 do
        local baseItem = self._copyPanel:getChildByName("Panel_3"):getChildByName("ItemAward_"..i)
        if i>#items then
            baseItem:setVisible(false)
        else
            baseItem:setPositionX(startx + 120*(i-1))
            local img = baseItem:getChildByName("awardImg_1_"..i)
            local path= conf.Item:getItemSrcbymid(items[i].mId)
            img:loadTexture(path)
            local txt = baseItem:getChildByName("Text_4_"..i)
            local str = conf.Item:getName(items[i].mId).."x"..items[i].amount
            txt:setString(str)
            local lv=conf.Item:getItemQuality(items[i].mId)
            local framePath=res.btn.FRAME[lv]
            baseItem:loadTextureNormal(framePath)
            txt:setColor(COLOR[lv])
        end        
    end
    self:_playDh(data_)
end

---竞技场
function FightWinView:_jjcInfo(data_)
    self._jjcData = data_
    self._jjcCards = {}
    self._backCards = {}
    self._zsPanel:setVisible(false)
    self._copyPanel:setVisible(false)
    self._jjcPanel:setVisible(true)
    self._jjcPanel:setPosition(self._panelPos)
    local mTxt = self._jjcPanel:getChildByName("Panel_3_10"):getChildByName("Text_20_10")
    local expTxt = self._jjcPanel:getChildByName("Panel_3_10"):getChildByName("Text_21_12")
    mTxt:setString(data_.money_hz)
    expTxt:setString(data_.exp)
    --排名情况
    local oldTxt = self._jjcPanel:getChildByName("AtlasLabel_2")
    local newTxt = self._jjcPanel:getChildByName("AtlasLabel_3")
    local oldLvl, oldIndex = self:_getRank(cache.Copy:getJJCData())
    local newLvl, __ = self:_getRank(data_.arenaList)
    oldTxt:setString(oldLvl)
    newTxt:setString(newLvl)
    if newLvl < oldLvl then
        cache.Copy:updateJJCFlag(cache.Fight.curFightIndex)  --更新竞技场奇偶
    end
    
    local items = data_.items
    for i=1, 3 do
        local card = self._jjcPanel:getChildByName("Image_20_"..i)
        card:setTag(i)
        card:addTouchEventListener(handler(self,self.onCardClickHandler))
        self._backCards[i] = card
        local card2 = self._jjcPanel:getChildByName("Panel_1_"..i)
        self._jjcCards[i] = card2
        local img = card2:getChildByName("Button_frame_0_"..i):getChildByName("Image_22_36_"..i)
        local path= conf.Item:getItemSrcbymid(items[i].mId)
        img:loadTexture(path)
        local scale = cc.ScaleTo:create(0.8,1.05)
        local scale2= cc.ScaleTo:create(0.8,1)
        local delay = cc.DelayTime:create(0.5 + (i-1)*1.6)
        local delay2 = cc.DelayTime:create(0.5 + (3-i)*1.6)
        local seq = cc.Sequence:create(delay, scale, scale2, delay2)
        self.cardScaleAction = cc.RepeatForever:create(seq)
        card:runAction(self.cardScaleAction)
    end 
    self:_playDh(data_)
    
    local delay = cc.DelayTime:create(4)
    local callFunc = cc.CallFunc:create(function()
        self:_steps(2)
    end)
    self.autoClickAction = cc.Sequence:create(delay, callFunc)
    self:runAction(self.autoClickAction)
end

function FightWinView:_getRank(data_)
    for i=1, #data_ do
        if data_[i].uId.key == cache.Player.DataInfo.roleId.key then
            return data_[i].uRank, i
        end
    end
end

function FightWinView:onCardClickHandler( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        self:stopAction(self.autoClickAction)
        self:_steps(sender:getTag()) 
    end
end

function FightWinView:_steps(index_)
    --停止触摸和放大动作
    for i=1, 3 do
        local card = self._jjcPanel:getChildByName("Image_20_"..i)
        card:stopAction(self.cardScaleAction)
        card:setEnabled(false)
    end
    
    --设置道具和翻牌
    self:_setCardItems(index_)
    self:_rollCard(index_, true)
    
    --翻其他2个
    local delay = cc.DelayTime:create(1)
    local callFunc = cc.CallFunc:create(function()
        for i=1, 3 do
            if index_ ~= i then
                self:_rollCard(i, false)
            end
        end
        self._isCanClick = true
    end)
    local seq = cc.Sequence:create(delay, callFunc)
    self:runAction(seq)
end

function FightWinView:_rollCard(index_, eff)
    local actIn = cc.Sequence:create(cc.Hide:create(),cc.DelayTime:create(0.2),cc.Show:create(),cc.OrbitCamera:create(0.2,1,0,270,90,0,0))
    local actOut = cc.Sequence:create(cc.OrbitCamera:create(0.2,1,0,0,90,0,0),cc.Hide:create())
    local backCard = self._backCards[index_]
    local frontCard = self._jjcCards[index_]
    backCard:runAction(actOut)
    frontCard:runAction(actIn)
    if eff==true then
        local params = {id=404807,x=backCard:getPositionX(),y=backCard:getPositionY(),addTo=self._jjcPanel,depth=200}
        mgr.effect:playEffect(params)
    end
    
end

function FightWinView:_setCardItems(index_)
    local items = self._jjcData.items
    local cards = {}
    for i=1, #items do
        if items[i].index == 1 then
            local img = self._jjcCards[index_]:getChildByName("Button_frame_0_"..index_):getChildByName("Image_22_36_"..index_)
            local btnFrame = self._jjcCards[index_]:getChildByName("Button_frame_0_"..index_)
            local path= conf.Item:getItemSrcbymid(items[i].mId)
            img:loadTexture(path)
            local txt = self._jjcCards[index_]:getChildByName("Text_"..index_)
            local str = conf.Item:getName(items[i].mId).."x"..items[i].amount
            txt:setString(str)
            local lv=conf.Item:getItemQuality(items[i].mId)
            local framePath=res.btn.FRAME[lv]
            btnFrame:loadTextureNormal(framePath)
            txt:setColor(COLOR[lv])
        else
            table.insert(cards,items[i])
        end 
    end   
    local j = 1
    for i=1, 3 do
        local img
        if i ~= index_ then
            local img = self._jjcCards[i]:getChildByName("Button_frame_0_"..i):getChildByName("Image_22_36_"..i)
            local btnFrame = self._jjcCards[i]:getChildByName("Button_frame_0_"..i)
            local path= conf.Item:getItemSrcbymid(cards[j].mId)
            img:loadTexture(path)
            local txt = self._jjcCards[i]:getChildByName("Text_"..i)
            local str = conf.Item:getName(cards[j].mId).."x"..cards[j].amount
            txt:setString(str)
            local lv=conf.Item:getItemQuality(cards[j].mId)
            local framePath=res.btn.FRAME[lv]
            btnFrame:loadTextureNormal(framePath)
            txt:setColor(COLOR[lv])
            j=j+1
        end       
    end
end

---爬塔挑战
function FightWinView:_towerInfo(data_)
    self._copyPanel:setVisible(true)
    self._jjcPanel:setVisible(false)
    self._zsPanel:setVisible(false)
    self._copyPanel:setPosition(self._panelPos)
    local icon1 = self._copyPanel:getChildByName("Panel_3"):getChildByName("Image_31")
    icon1:setVisible(false)
    local iconYq = self._copyPanel:getChildByName("Panel_3"):getChildByName("Text_8")
    iconYq:setVisible(true)
    local icon2 = self._copyPanel:getChildByName("Panel_3"):getChildByName("Image_36")
    icon2:loadTexture("res/views/ui_res/icon/star_icon.png")
    icon2:ignoreContentAdaptWithSize(true)
    local mTxt = self._copyPanel:getChildByName("Panel_3"):getChildByName("Text_20")
    local expTxt = self._copyPanel:getChildByName("Panel_3"):getChildByName("Text_21")
    mTxt:setString(data_.guts)
    expTxt:setString(data_.thisStart)
    local items = data_.items
    local startx = 320 - 60*(#items - 1)
    for i=1, 4 do
        local baseItem = self._copyPanel:getChildByName("Panel_3"):getChildByName("ItemAward_"..i)
        if i>#items then
            baseItem:setVisible(false)
        else
            baseItem:setPositionX(startx + 120*(i-1))
            local img = baseItem:getChildByName("awardImg_1_"..i)
            local path= conf.Item:getItemSrcbymid(items[i].mId)
            img:loadTexture(path)
            local txt = baseItem:getChildByName("Text_4_"..i)
            local str = conf.Item:getName(items[i].mId).."x"..items[i].amount
            txt:setString(str)
            local lv=conf.Item:getItemQuality(items[i].mId)
            local framePath=res.btn.FRAME[lv]
            baseItem:loadTextureNormal(framePath)
            txt:setColor(COLOR[lv])
            local framePath=res.btn.FRAME[lv]
            baseItem:loadTextureNormal(framePath)
        end        
    end
    self:_playDh(data_)
end

---公会
function FightWinView:_guildInfo(data_)
    self._guildPanel:setVisible(true)
    self._copyPanel:setVisible(false)
    self._jjcPanel:setVisible(false)
    self._zsPanel:setVisible(false)
    self._guildPanel:setPosition(self._panelPos)
    local hurtTxt = self._guildPanel:getChildByName("Panel_3_10_5"):getChildByName("Text_20_10_5")
    local gxTxt = self._guildPanel:getChildByName("Panel_3_10_5"):getChildByName("Text_21_12_7")
    hurtTxt:setString(data_.hitStr)
    gxTxt:setString(data_.guildPoint)

    self:_playDh(data_)
end

function FightWinView:_smdsInfo( data_ )
    -- body
    self._copyPanel:setVisible(false)
    self._zsPanel:setVisible(false)
    self:_playDh(data_)
end
--文字动画 胜利
function FightWinView:PlayWenzi( start )
    -- body
    local function run(spr)
        -- body
        local lastPosY = -20 
        local a1 =  cc.MoveTo:create(0.08,cc.p(spr:getPositionX(),lastPosY-20))  -- 下
        local a2 =  cc.MoveTo:create(0.12,cc.p(spr:getPositionX(),lastPosY+50)) --  上
        local a3 =  cc.MoveTo:create(0.05,cc.p(spr:getPositionX(),lastPosY-10)) -- 下
        local a4 =  cc.MoveTo:create(0.1,cc.p(spr:getPositionX(),lastPosY+20)) -- 上
        local a5 =  cc.MoveTo:create(0.05,cc.p(spr:getPositionX(),lastPosY))--最后停留 

        local sequence = cc.Sequence:create(a1,a2,a3,a4,a5)
        spr:runAction(sequence)
    end

    local str 
    if start == 4 then 
        str = res.font.FIGHR_OVER
    elseif start == 3 then 
        str = res.font.FIGHT_DEC[4]
    elseif start == 2 then 
        str = res.font.FIGHT_DEC[3]
    else
        str = res.font.FIGHT_DEC[5]
    end

    local posy = 200 --开始掉落前的高度
    local sprite = display.newSprite(str)
    sprite:setPosition(display.width/2,posy)
    sprite:addTo(self.dhPanel,1000)
    run(sprite)



    --[[local posy = 150

    display.addSpriteFrames("shengjijiemian-02.plist", "shengjijiemian-02.png")
    local sprite = display.newSprite("#SB-bai.png")
    sprite:setPosition(display.width/2+0,posy)
    sprite:addTo(self.dhPanel,1000)
    table.insert(self.lablist,sprite)

    local spr2 = display.newSprite("#SB-can.png")
    spr2:setPosition(sprite:getContentSize().width+sprite:getPositionX(),posy)
    spr2:addTo(self.dhPanel,1000)
    table.insert(self.lablist,spr2)

    local lastPosY = 0
    local function runA( spr )
        -- body
        local a1 =  cc.MoveTo:create(0.08,cc.p(spr:getPositionX(),lastPosY-20))  -- 下
        local a2 =  cc.MoveTo:create(0.12,cc.p(spr:getPositionX(),lastPosY+50)) --  上
        local a3 =  cc.MoveTo:create(0.05,cc.p(spr:getPositionX(),lastPosY-10)) -- 下
        local a4 =  cc.MoveTo:create(0.1,cc.p(spr:getPositionX(),lastPosY+20)) -- 上
        local a5 =  cc.MoveTo:create(0.05,cc.p(spr:getPositionX(),lastPosY))--最后停留 

        local sequence = cc.Sequence:create(a1,a2,a3,a4,a5)
        spr:runAction(sequence)
    end

    for k , v in pairs(self.lablist) do 
        runA(v)
    end]]--
end

function FightWinView:_playDh(data_)
    --[[local playStrList = {
        {0, 6, 1},
        {0, 5, 2},
        {0, 4, 3},
        {0, 3}}
    local dhList
    if self._winType == 4 or self._winType == 5 or  self._winType == 6 then --404832 --只有战斗结束
        dhList = playStrList[4] 
        local params = {id=404832,playIndex=0,x=display.width/2,y=0,addTo=self.dhPanel,retain=true,depth=100}
        mgr.effect:playEffect(params)
    else
        dhList = playStrList[math.abs(data_.fightReport.start)]
    end
    local function trigger() --恒定光效
        local params = {id=404086,playIndex=8,x=display.width/2,y=0,addTo=self.dhPanel,triggerFun=trigger,depth=100}
        mgr.effect:playEffect(params)
    end
    for i=1, #dhList do
        local params = {id=404086,playIndex=dhList[i],x=display.width/2,y=0,addTo=self.dhPanel, retain=true, triggerFun=trigger,endCallFunc=function()
            if self._winType == 1 or self._winType == 3 or self._winType == 4 or self._winType == 5 
                or self._winType == 6 or self._winType == 7 then
                self._isCanClick = true
            end
        end,depth=200}
        mgr.effect:playEffect(params)
    end]]--
    --test new
    local function forveraction()
        -- body
        local armature = mgr.BoneLoad:loadArmature(404086,4)
        armature:setPosition(display.width/2,0)
        armature:addTo(self.dhPanel,99)
    end


    local playStrList = {
        {0,1},
        {0,2},
        {0,3},
        {0,3}--战斗结束
    }
    local cid = math.abs(data_.fightReport.start)

    if self._winType == 8 then
        if cache.Camp:getSelfcamp() == 2 then
            cid = 4 + cid     
            if  cid > 4 then
                cid = 3 
            end 
        end
    end

    if self._winType == 4 or self._winType == 5 or  self._winType == 6 or self._winType == 11 or self._winType ==12 then --404832 --只有战斗结束 没有胜利失败文字
        cid = 4 
        dhList = playStrList[4] 
        --local armature = mgr.BoneLoad:loadArmature(404832)
        --armature:setPosition(display.width/2,0)
        --armature:addTo(self.dhPanel,100)
    else
        dhList = playStrList[cid]
    end 

    for i=1, #dhList do
        local v = dhList[i]
        local armature = mgr.BoneLoad:loadArmature(404086,v)
        armature:setPosition(display.width/2,0)
        armature:addTo(self.dhPanel,100)

        if i == 2  then 
            armature:getAnimation():setMovementEventCallFunc(function(armature,movementType,movementID)
                if movementType == ccs.MovementEventType.complete then
                    if self._winType == 1 or self._winType == 3 or self._winType == 4 or self._winType == 5 
                        or self._winType == 6 or self._winType == 7 or self._winType == 8  or  self._winType == 9 
                        or self._winType == 10 or self._winType == 11 or self._winType == 12 then
                        self._isCanClick = true --点击继续
                        forveraction() --旋转光效
                    end
                end
            end)
        else
            --todo
            armature:getAnimation():setFrameEventCallFunc(function(bone,event,originFrameIndex,intcurrentFrameIndex)
                if event == "next_effect" then 
                    --debugprint("开始掉字")
                    --if cid < 4 then --险胜 胜利 完胜
                        self:PlayWenzi(cid)
                    --end
                end
            end)
        end

    end
end

function FightWinView:onPanelClickHandler( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
        if self._isCanClick == false then
            return
        end
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
                    view:updateTower(true)
                end    
            end})
        elseif self._winType == 4 then
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
                if cache.Player:getGuildId().key~="0_0" then
                    mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_FB)
                    local view = mgr.ViewMgr:get(_viewname.GUILD_FB)
                    if view then
                        local data = cache.Fight:getData()
                        local cId__ = math.floor(data.fId/100)
                        view:setData({cId=cId__})
                    end
                else
                    G_mainView()
                    G_TipsOfstr(res.str.GUILD_DEC31)
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
                mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
                local view = mgr.SceneMgr:getMainScene():changeView(0, _viewname.DIG_MIAN)
                
                
                local daoId = cache.Dig:getCurDaoId()
                cache.Dig:insertDao(daoId)
                view:setData(cache.Dig:getMainData())
                
                local data = {roleId = cache.Player:getRoleInfo().roleId,daoId  = daoId}
                proxy.Dig:sendOneMsg(data)
                --mgr.NetMgr:wait(520001)

                --[[if self.result>0 then 

                    local data = {roleId = cache.Player:getRoleInfo().roleId,daoId  = cache.Dig:getCurDaoId()}
                    proxy.Dig:sendOneMsg(data)
                    mgr.NetMgr:wait(520001)
                end ]]--
            end})
        elseif self._winType == 7  then
            --todo
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
            local view = mgr.SceneMgr:getMainScene():changeView(0, _viewname.DIG_MIAN)
            --view:setData(cache.Dig:getOtherMsg(),2)
            local param = cache.Dig:getOtherMsg()
            local data = {roleId = param.roleId,roleName = param.roleName, type = 2  }
            proxy.Dig:sendDigMainMsg(data)
            mgr.NetMgr:wait(520002)
            end})
        elseif self._winType == 8  then
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
                local view = mgr.SceneMgr:getMainScene():changeView(0, _viewname.CAMP_MIAN)
                 proxy.Camp:send120101()
                --view:setData()
               -- view:warCallBack()
            end})
        elseif self._winType == 9  then
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
                local view = mgr.SceneMgr:getMainScene():changeView(0, _viewname.FUBEN_DAY)
                -- proxy.Camp:send120101()
                view:setData(cache.DayFuben:getData())
                view:warCallBack(cache.DayFuben:getCurPage())
            end})
        elseif self._winType == 10 then
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
                local view = mgr.SceneMgr:getMainScene():changeView(0, _viewname.CROSS_WAR_MAIN)
                view:setData(cache.Cross:getKFdata())
            end})
        elseif self._winType == 11 then
            mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
                local view = mgr.SceneMgr:getMainScene():changeView(0, _viewname.CROSS_WAR_MAIN)
                view:setData(cache.Cross:getKFdata())

                local view = mgr.ViewMgr:showView(_viewname.CROSS_WIN_WAR)
                view:setData(cache.Cross:getWinData())

                local view = mgr.ViewMgr:showView(_viewname.CROSS_VIDEO_TRUE)
                local data,hehe = cache.Cross:getinbefor()
                view:setPlayerData(clone(data),hehe)
            end})
         elseif self._winType == 12 then
             mgr.SceneMgr:LoadingScene(_scenename.MAIN, {loadMainView=false, completeCallFun = function()
                 local view = mgr.SceneMgr:getMainScene():changeView(0, _viewname.BOSS_MAIN)
                 view:setData(cache.Boss:getData())
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

function FightWinView:onCloseSelfView()
    -- body
    self:closeSelfView()
    G_TaskShow(true)
end

return FightWinView