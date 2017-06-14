local CopyView=class("CopyView",base.BaseView)

function CopyView:init(index)
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
    
    self.maxChapter = 10
    self._bgList = {}
    self._curBgIndex = 0
    
    self._curHardLevel = cache.Copy.curHardLevel
    self._scrollView = self.view:getChildByName("ScrollView_1")
    self._scrollView:addEventListener(handler(self,self.scrollViewEvent))
    self._contentView = self._scrollView:getChildByName("Panel_1")
    --self._scrollView:setInnerContainerSize(cc.size(640,7280))
       
    --普通2
    self._easyBtn=self.view:getChildByName("Button_1")
    --self._easyBtn:addTouchEventListener(handler(self,self.onBtnEasyCallBack))
    --精英3
    self._hardBtn=self.view:getChildByName("Button_2")
    --噩梦
    self._emengBtn=self.view:getChildByName("Button_2_0")

    self.PageButton=gui.PageButton.new()
    self.PageButton:setBtnCallBack(handler(self,self.listButtonCallBack))
    self.PageButton:addButton(self._easyBtn)
    self.PageButton:addButton(self._hardBtn)
    self.PageButton:addButton(self._emengBtn)
    local idxAry = {}
    idxAry["2"] = 1
    idxAry["3"] = 2
    idxAry["7"] = 3
    self.PageButton:setSelectButton(idxAry[self._curHardLevel..""])
    if self._curHardLevel == 3 or self._curHardLevel == 7 then
        self:_addHardEffect()
    end

    if res.stop  or res.banshu then 
        self._easyBtn:setVisible(false)
        self._hardBtn:setVisible(false)
    end 
    
    self:_updateCanFight()

end

function CopyView:listButtonCallBack(index,eventtype,noClick)
    if index == 1 then
        local params = {id=404827,x=display.cx,y=display.cy,addTo=self,depth=1000,triggerFun=function(type_)
            if type_ == "next_effect" then
                if self.hardEffect then
                    self.hardEffect:removeSelf()
                    self.hardEffect = nil
                end
            end      
        end}
        mgr.effect:playEffect(params)
          
        self._curHardLevel = 2
        cache.Copy.curHardLevel = 2
        self._curBgIndex = 0
        self:_updateCanFight()
    elseif index == 2 then
        local lv = cache.Player:getLevel()
        if lv<40 then
            G_TipsOfstr(string.format(res.str.COPY_DESC14, 40))
            return nil
        end
        local params = {id=404827,x=display.cx,y=display.cy,addTo=self,triggerFun=function(type_)
            if type_ == "next_effect" then
                self:_addHardEffect()
            end      
        end,depth=1000}
        mgr.effect:playEffect(params)
        self._curHardLevel = 3
        cache.Copy.curHardLevel = 3
        self._curBgIndex = 0
        self:_updateCanFight()
    elseif index == 3 then
        local lv = cache.Player:getLevel()
        if lv<60 then
            G_TipsOfstr(string.format(res.str.COPY_DESC20, 60))
            return nil
        end
        local params = {id=404827,x=display.cx,y=display.cy,addTo=self,triggerFun=function(type_)
            if type_ == "next_effect" then
                self:_addHardEffect()
            end      
        end,depth=1000}
        mgr.effect:playEffect(params)
        self._curHardLevel = 7
        cache.Copy.curHardLevel = 7
        self._curBgIndex = 0
        self:_updateCanFight()
    end  
    return true 
end

function CopyView:scrollViewEvent(sender, evenType)
    if evenType == ccui.ScrollviewEventType.scrollToBottom then

    elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then

    elseif evenType == ccui.ScrollviewEventType.scrolling then
        self:scrollBg()
    end
end

function CopyView:scrollBg()
    local height = display.height - 50
    local pos = self._contentView:convertToWorldSpace(cc.p(0,0))
    --local index = 8-math.floor((math.abs(pos.y) / 1120 )) --当前应该加载的起始index  1-8
    local index = self:_getNodeIndex(math.abs(pos.y))
    --print("______________________________________________[副本]", pos.y, index)
    if self._curBgIndex ~= index then
        local min = index-1
        for key,value in pairs(self._bgList) do
            if (key == "b"..index or key == "b"..min) and self._curBgIndex~=0 then
            else
                value:removeSelf()
                self._bgList[key] = nil
            end
        end
        if min < 1 then min = 1 end
        for i=min,index do
            if not self._bgList["b"..i] then
                local fileName = "ikonNode"..i
                local bg = mgr.ViewMgr:loadUI(fileName):getChildByName("Panel_1"):clone()
                --local ikonNode = mgr.ViewMgr:loadUI(fileName)
                --local bg = ikonNode:getChildByName("Panel_1")
                self._contentView:addChild(bg)
                --bg:setPosition(0, (8-i)*1120)
                bg:setPosition(0, self:_getNodePos(i))
                self._bgList["b"..i] = bg         
                for m=1, 5 do
                    local btn = bg:getChildByName("Button_"..(m+4).."0")
                    local tag = (i-1)*5+m
                    btn:setTag(tag)
                    local url
                    if self._curHardLevel == 2 then
                        url = "res/views/ui_res/bg/stage"..tag..".png"
                    else
                        url = "res/views/ui_res/bg/stage"..tag..".png"
                    end
                    btn:loadTextureNormal(url)
                    if tag > self.curLevel then
                        btn:setEnabled(false)
                        btn:setBright(false)
                    else
                        btn:addTouchEventListener(handler(self,self.onButtonCallBack))
                    end
                    if tag == self.curLevel then
                        self:_addEffect(btn)
                    end
                end  
            end
        end
        self._curBgIndex = index
    end
end

function CopyView:_getNodePos(index_)
    local list = {1156,988,1266,1267,1315,1125,1317,1122,1272,0}
    local pos = 0
    for i=self.maxChapter,index_,-1 do
        pos = pos + list[i]
    end
    return pos
end

function CopyView:_getNodeIndex(pos_)
    local list = {1120,1156,988,1266,1267,1315,1125,1317,1122,1272}
    local flag = pos_
    for i=self.maxChapter, 1, -1 do
        flag = flag - list[i]
        if flag <= 0 then
            return i
        end
    end
    return 1
end

function CopyView:_addEffect(btn)
    local x = btn:getPositionX()
    local y = btn:getPositionY()
    local par = btn:getParent()
    local params = {id=404801,x=x,y=y,addTo=par, retain=true,depth=200}
    mgr.effect:playEffect(params)
end

function CopyView:_updateCanFight()
    self:_changFb()
    local pos = math.ceil(self.curLevel/5)
    self._scrollView:jumpToPercentVertical(100*(pos-1)/self.maxChapter)

    self:scrollBg()
end

function CopyView:_changFb()
    local max
    if self._curHardLevel == 2 then
        max = cache.Copy:getBaseFbMax()
        self.curLevel = math.floor((max%200000)/100)
    elseif self._curHardLevel == 3 then
        max = cache.Copy:getSuperFbMax()
        self.curLevel = math.floor((max%300000)/100)
    elseif self._curHardLevel == 7 then
        max = cache.Copy:getEmengFbMax()
        self.curLevel = math.floor((max%700000)/100)
    end 
end

function CopyView:onBtnEasyCallBack( sender,eventype )
    if eventype == ccui.TouchEventType.ended then
        local params = {id=404827,x=display.cx,y=display.cy,addTo=self,depth=1000,triggerFun=function(type_)
            if type_ == "next_effect" then
                if self.hardEffect then
                    self.hardEffect:removeSelf()
                    self.hardEffect = nil
                end
            end      
        end}
        mgr.effect:playEffect(params)
          
        self._easyBtn:setVisible(false)
        self._hardBtn:setVisible(true)
        self._curHardLevel = 2
        cache.Copy.curHardLevel = 2
        self._curBgIndex = 0
        self:_updateCanFight()
    end  
end

function CopyView:onBtnHardCallBack( sender,eventype )
    if eventype == ccui.TouchEventType.ended then
        local lv = cache.Player:getLevel()
        if lv<40 then
            G_TipsOfstr(string.format(res.str.COPY_DESC14, 40))
            return
        end
        local params = {id=404827,x=display.cx,y=display.cy,addTo=self,triggerFun=function(type_)
            if type_ == "next_effect" then
                self:_addHardEffect()
            end      
        end,depth=1000}
        mgr.effect:playEffect(params)

        self._easyBtn:setVisible(true)
        self._hardBtn:setVisible(false)
        self._curHardLevel = 3
        cache.Copy.curHardLevel = 3
        self._curBgIndex = 0
        self:_updateCanFight()
    end 
end

function CopyView:_addHardEffect()
    -- if self.hardEffect == nil then
    --     self.hardEffect = 1
    --     local p = {id=404829,x=display.cx,y=display.cy,addTo=self,depth=1000,loadComplete=function(arm)
    --         local scaleW = display.width / 640
    --         local scaleH = display.height/960
    --         arm:setScaleX(scaleW)
    --         arm:setScaleY(scaleH)
    --         self.hardEffect = arm
    --     end}
    --     mgr.effect:playEffect(p)
    -- end
end

function CopyView:onButtonCallBack( sender,eventype )
    if eventype == ccui.TouchEventType.ended then
        local index = sender:getTag()
        local id = self._curHardLevel*1000+index  --章节id
        local _, data = cache.Copy:getData(id)  --获取章节数据
        cache.Fight.curFightIndex = 0
        --如果空则请求服务端，负责直接调用缓存
        if not data then
            mgr.NetMgr:send(107001,{cId=id})
            mgr.SceneMgr:getMainScene():changeView(index, _viewname.COPY_CHAPTER)
        else
            mgr.SceneMgr:getMainScene():changeView(index, _viewname.COPY_CHAPTER)
            local view = mgr.ViewMgr:get(_viewname.COPY_CHAPTER)
            view:setData()
        end
    end
end

function CopyView:setData( data )
    self:_updateCanFight()
end

return CopyView