local AthleticsCompareView=class("AthleticsCompareView",base.BaseView)

function AthleticsCompareView:init(index)
    self.ShowAll=true
    self.showtype=view_show_type.TOP
    self.view=self:addSelfView()

    self._closebtn = self.view:getChildByName("Button_6")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))
    
    --我方
    self._myNameTxt = self.view:getChildByName("Text_9")
    self._myLvlTxt = self.view:getChildByName("Text_11")
    self._myPowerTxt = self.view:getChildByName("Text_13")
    
    --敌方
    self._otherNameTxt = self.view:getChildByName("Text_9_0")
    self._otherLvlTxt = self.view:getChildByName("Text_11_0")
    self._otherPowerTxt = self.view:getChildByName("Text_13_0")

    --容器
    self.panel = self.view:getChildByName("Panel_1")

    self._itemPanel = self.view:getChildByName("Panel_9")
    self._lists = {{}, {}}

    self.view:getChildByName("Image_bg"):setTouchEnabled(true)
    G_FitScreen(self,"Image_bg")
end
--flag 表示是否是跨服的 1 跨服排位 2 跨服竞猜阵容对比
function AthleticsCompareView:setData(data_,data2_,flag)
    self.selfdata =  {}
    self.otherData = {}
    self.iskf = flag
    if not data2_ then 
        self._myNameTxt:setString(cache.Player:getName())
        self._myLvlTxt:setString(cache.Player:getLevel())
        self._myPowerTxt:setString(cache.Player:getPower())
        self.myCards = cache.Pack:getEquipCards()  --自己

        self.left_roleId = cache.Player:getRoleInfo().roleId
        self.otherData.huoban = data_.tarXhbs
    else
        self.allother = true
        self.myCards = data2_.tarCards
        self.left_roleId = data2_.roleId
        self.right_roleId = data_.roleId

        self.selfdata.huoban = data2_.huoban

        self._myNameTxt:setString(data2_.tarName)
        self._myLvlTxt:setString(data2_.tarLvl)
        self._myPowerTxt:setString(data2_.tarPower)

        self.otherData.huoban = data_.huoban
        for k=1, #data2_.tarCards do
            data2_.tarCards[k].propertys = vector2table(data2_.tarCards[k].propertys,"type")
        end
    end 
    
    self._otherNameTxt:setString(data_.tarName)
    self._otherLvlTxt:setString(data_.tarLvl)
    self._otherPowerTxt:setString(data_.tarPower)
    
    --self.otherData = data_


    self.otherCards = data_.tarCards  --对方


    for k=1, #data_.tarCards do
        data_.tarCards[k].propertys = vector2table(data_.tarCards[k].propertys,"type")
    end
   -- local cards = {self.myCards, self.otherCards}
    local cards = {{},{}}
    for k ,v in pairs(self.myCards) do 
        if v.propertys[308] and  v.propertys[308].value>0 then
            table.insert(cards[1],v)
        end
    end

    for k ,v in pairs(self.otherCards) do 
        if v.propertys[308] and  v.propertys[308].value>0 then
            table.insert(cards[2],v)
        end
    end
    self.selfdata.tarCards = self.myCards
    self.otherData.tarCards = self.otherCards

    local posxs = {20, 357}
    for j=1, #cards do
        for i=1, 6 do
            local item
            if self._lists[j][i] then
                item = self._lists[j][i]
            else
                item = self._itemPanel:clone()
                table.insert(self._lists[j], item)
            end
            if not item:getParent() then
                self.panel:addChild(item)
            end
            item:setPosition(posxs[j], 590-(i-1)*95)
            if i>#cards[j] then
                item:setVisible(false)
            else
                item:setVisible(true)
                --icon
                --品质
                local conf_data = conf.Item:getItemConf(cards[j][i].mId)
                local _7scard =  item:getChildByName("Image_13_0_0")
                _7scard:ignoreContentAdaptWithSize(true)
                --local _7slab = _7scard:getChildByName("AtlasLabel_1_2_5_7_11_2_2")
                 _7scard:setVisible(false)
                if checkint(conf_data.zhuan)>0 then
                    _7scard:setVisible(true)
                    _7scard:loadTexture(res.icon.ZHUANFRAME[1])
                   -- _7slab:setString(conf_data.zhuan)
                end

                local frame = item:getChildByName("Button_frame")
                frame:loadTextureNormal(res.btn.FRAME[conf.Item:getItemQuality(cards[j][i].mId)])

                local img = item:getChildByName("Button_frame"):getChildByName("Image_22")
                local path = conf.Item:getItemSrcbymid(cards[j][i].mId,cards[j][i].propertys)
                if path then
                    img:loadTexture(path)
                end
                --名字
                local nameTxt = item:getChildByName("Text_15")
                nameTxt:setString(conf.Item:getName(cards[j][i].mId,cards[j][i].propertys))
                local lv=conf.Item:getItemQuality(cards[j][i].mId)
                nameTxt:setColor(COLOR[lv])
                --等级
                local lvlTxt = item:getChildByName("Text_17")
                for key, value in pairs(cards[j][i].propertys) do
                    if value.type == 304 then
                        lvlTxt:setString(value.value)
                    end
                end
                --查看
                local btn = item:getChildByName("Button_13")
                btn:setTitleText(res.str.MAILVIEW_DEC2)
                btn.index = cards[j][i].index
                btn:setTag(j*100+i)
                btn:addTouchEventListener(handler(self,self.onSeeClickHandler))
            end
        end
    end
end

function AthleticsCompareView:onSeeClickHandler( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        local tag = send:getTag()
        local index = tag%100
        local type = math.floor(tag/100)
        self.petIndex = index
        local data 
        if  self.allother  then 
            local roleId 
            
            if type == 1 then
                roleId = self.left_roleId
                --printt(roleId)
                data = self.selfdata
                data.tarName = self._myNameTxt:getString()
            else
                roleId = self.right_roleId
                data = self.otherData
                data.tarName = self._otherNameTxt:getString()
            end 
            data.roleId = roleId
            data.reqType = 2
        else
            if type == 1 then
                data = self.selfdata
                data.tarName = self._myNameTxt:getString()
                data.roleId = self.left_roleId
                data.reqType = 2
                --self:onOpenDetail(self.myCards)
            else
                
                data = self.otherData

                data.tarName = self._otherNameTxt:getString()
                data.reqType = 1
                data.roleId = cache.Fight.curFightId.key--self.right_roleId
                --print("________________________对比信息",cache.Fight.curFightId.key, "__", send.index)
                --mgr.NetMgr:send(114005,{roleId=cache.Fight.curFightId, index=send.index})
                --view:setData(self.otherCards)
            end
        end  

        table.sort(data.tarCards,function( a,b )
            -- body
            local apos = a.propertys[308] and a.propertys[308].value or 999
            local bpos = b.propertys[308] and b.propertys[308].value or 999
            return apos < bpos
        end)
        local view= mgr.ViewMgr:showView(_viewname.OTHER_VIEW)
        view:setData(data,self.iskf)
        view:setChoose(send.index) 
    end
end

function AthleticsCompareView:onBtnSureCallBack( send,eventype )

    if eventype == ccui.TouchEventType.ended then
        self:onCloseSelfView()
        --只是关闭
        --[[
        
        ]]
        local flag = cache.Friend:getOnlyClose()
        if flag then 
            cache.Friend:setOnlyClose(false)
            return 
        end 


        -----------------如果是从玩家信息界面跳转过来，这关闭本界面即可
        local flag = cache.Friend:getJumpFlag()
        if flag and flag == true then
            cache.Friend:jumpToAthleticComp(false)
            local scene =  mgr.SceneMgr:getMainScene()
            if scene then 
                local view = mgr.ViewMgr:get(_viewname.GUILD_MEMBER)
                if not view then 
                    scene:addHeadView()
                end 
            end
            return
        end
       
        mgr.SceneMgr:getMainScene():changeView(3, _viewname.ATHLETICS)
        local view = mgr.ViewMgr:get(_viewname.ATHLETICS)
        local data = cache.Fight:getData().arenaList
        view:updateRank(data)     
    end
end

function AthleticsCompareView:onOtherCard(data_)
    local info = data_.itemInfo
    info.propertys = vector2table(info.propertys,"type")
    print("________________________对比信息", info.mId)
    self.petIndex = 1
    self:onOpenDetail({info},true)
end

function AthleticsCompareView:onOpenDetail(data_,flag)
    local view=mgr.ViewMgr:createView(_viewname.PETDETAIL)
    view:setData(data_)
    view:onCompareState()
    view:selectUpdate(self.petIndex,flag)
    mgr.ViewMgr:showView(_viewname.PETDETAIL)
end

function AthleticsCompareView:onCloseSelfView()
    local view = mgr.ViewMgr:get(_viewname.DIG_MIAN)
    if view then 
        local scene =  mgr.SceneMgr:getMainScene()
        if scene then 
            scene:addHeadView()
        end
    end

    self.super.onCloseSelfView(self)
end

return AthleticsCompareView