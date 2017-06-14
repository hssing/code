-- 重置次数，购买vip
-- Author: Your Name
-- Date: 2015-07-27 20:37:24
--

local TowerRestView = class("TowerRestView",base.BaseView)

function TowerRestView:init(index)
    self.ShowAll=true
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()

    --充值
    self._paybtn = self.view:getChildByName("Panel_1"):getChildByName("Button_6_2")
    self._paybtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))
    --关闭
    self._closebtn = self.view:getChildByName("Panel_1"):getChildByName("Button_5_4")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnCloseCallBack))

    --界面固定文本
    local panel = self.view:getChildByName("Panel_1")
    panel:getChildByName("Text_1"):setString(res.str.CLIMB_DESC49)
    panel:getChildByName("Text_2"):setString(res.str.RES_VIP_VIP)

    self._paybtn:setTitleText(res.str.CLIMB_DESC50)
    self._closebtn:setTitleText(res.str.CLIMB_DESC30)

end

function TowerRestView:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:closeSelfView()
        G_GoReCharge()   
    end
end

function TowerRestView:onBtnCloseCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:closeSelfView()
    end
end

function TowerRestView:closeSelfView()
    self.super.closeSelfView(self)
end

return TowerRestView