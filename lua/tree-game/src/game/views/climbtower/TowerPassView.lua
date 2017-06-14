local TowerPassView=class("TowerPassView",base.BaseView)

function TowerPassView:init()
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
      
    self._cBtn = self.view:getChildByName("Panel_1"):getChildByName("Button_5")
    self._cBtn:addTouchEventListener(handler(self,self.onBtnContinueCallBack))
    self._nextBtn = self.view:getChildByName("Panel_1"):getChildByName("Button_6")
    self._nextBtn:addTouchEventListener(handler(self,self.onBtnNextCallBack)) 

    local panel1 = self.view:getChildByName("Panel_1")
    panel1:getChildByName("Text_2"):setString(res.str.CLIMB_DESC28)
    panel1:getChildByName("Text_1"):setString(res.str.CLIMB_DESC29)
   
    self._cBtn:setTitleText(res.str.CLIMB_DESC30)
    self._nextBtn:setTitleText(res.str.CLIMB_DESC11)


end

function TowerPassView:onBtnContinueCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then     
        self.super.closeSelfView(self)
    end
end

function TowerPassView:onBtnNextCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        local t = cache.Copy.towerData.restCount
        if t > 0 then
            local tt = cache.Copy.towerData.buyCount
            local money = conf.buyprice:getTowerPrice(tt+1)
            mgr.ViewMgr:showView(_viewname.TOWER_REST_TIMES):setData({money=money})
        else
            mgr.ViewMgr:showView(_viewname.TOWER_REST_VIP)
        end  
        self.super.closeSelfView(self)
    end
end

return TowerPassView