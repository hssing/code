local InspireView=class("InspireView",base.BaseView)

function InspireView:init(index)
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
    
    --关闭
    self._closebtn = self.view:getChildByName("Button_2")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))

    self.btn2 = self.view:getChildByName("Panel_1"):getChildByName("Button_14")
    self.btn2:addTouchEventListener(handler(self,self.onBtnSureCallBack))

    self.yqTxt = self.view:getChildByName("Panel_1"):getChildByName("Text_4")
    self.yqTxt:setString(cache.Copy.towerData.guts)


    self.checkBox = self.view:getChildByName("Panel_1"):getChildByName("CheckBox_1")
    self.checkBox:addEventListener(handler(self,self.onCheckBoxCallBack))
    if cache.Copy.isPushInspire == 1 then
        self.checkBox:setSelected(true)
    else
        self.checkBox:setSelected(false)
    end

    --按钮
    for i=1, 6 do
        local btn = self.view:getChildByName("Panel_1"):getChildByName("Panel_1_"..i):getChildByName("Button_3_"..i)
        btn:addTouchEventListener(handler(self,self.onBtnClickHandler))
        btn:setTag(i)
    end
    self.needYQ = {10,20,30,10,20,30}

    --界面文本
    local panel = self.view:getChildByName("Panel_1")
    panel:getChildByName("Text_1"):setString(res.str.CLIMB_DESC15) 
    panel:getChildByName("Text_1_0"):setString(res.str.CLIMB_DESC16) 
    panel:getChildByName("Text_5"):setString(res.str.CLIMB_DESC18) 
    panel:getChildByName("Text_2"):setString(res.str.CLIMB_DESC9) 
    
    panel:getChildByName("Panel_1_1"):getChildByName("Text_3"):setString(string.format(res.str.CLIMB_DESC17, 10))
    panel:getChildByName("Panel_1_2"):getChildByName("Text_3_5"):setString(string.format(res.str.CLIMB_DESC17, 20))
    panel:getChildByName("Panel_1_3"):getChildByName("Text_3_7"):setString(string.format(res.str.CLIMB_DESC17, 30))
    panel:getChildByName("Panel_1_4"):getChildByName("Text_3_9"):setString(string.format(res.str.CLIMB_DESC17, 10))
    panel:getChildByName("Panel_1_5"):getChildByName("Text_3_11"):setString(string.format(res.str.CLIMB_DESC17, 20))
    panel:getChildByName("Panel_1_6"):getChildByName("Text_3_13"):setString(string.format(res.str.CLIMB_DESC17, 30))
    
     self.btn2:setTitleText(res.str.CLIMB_DESC19)





end

function InspireView:onCheckBoxCallBack(send,eventype )
    if eventype == 0 then  --勾选
        cache.Copy.isPushInspire = 1
    else--不勾选
        cache.Copy.isPushInspire = 0
    end
    print("_______________________________",cache.Copy.isPushInspire)
end

function InspireView:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:onCloseSelfView()
    end
end

function InspireView:onBtnClickHandler( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        local index = send:getTag()
        local value = cache.Copy.towerData.guts
        local need = self.needYQ[index]
        if value >= need then
            mgr.NetMgr:send(115003,{index=index})
        else
            G_TipsOfstr(res.str.CLIMB_TIPS9)
        end
    end
end

function InspireView:updateYQ()
    self.yqTxt:setString(cache.Copy.towerData.guts)
end

function InspireView:onCloseSelfView()
    self.super.onCloseSelfView(self)
end

return InspireView