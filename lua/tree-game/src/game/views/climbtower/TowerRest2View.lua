-- 重置次数
-- Author: Your Name
-- Date: 2015-07-27 20:37:24
--

local TowerRest2View = class("TowerRest2View",base.BaseView)

function TowerRest2View:init(index)
    self.ShowAll=true
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()

    self.moneyTxt = self.view:getChildByName("Panel_1"):getChildByName("Panel_10"):getChildByName("Text_2")

    --关闭
    self._sureBtn = self.view:getChildByName("Panel_1"):getChildByName("Button_6_2_2")
    self._sureBtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))

    --关闭
    self._closebtn = self.view:getChildByName("Panel_1"):getChildByName("Button_5_4_4")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnCloseCallBack))

    ---花钱购买
    self.payPanel = self.view:getChildByName("Panel_1"):getChildByName("Panel_10")
    ---免费重置次数
    self.freePanel = self.view:getChildByName("Panel_1"):getChildByName("Panel_3")

    --界面固定文本
    self.payPanel:getChildByName("Text_1"):setString(res.str.CLIMB_DESC47)
    self.freePanel:getChildByName("Text_4"):setString(res.str.CLIMB_DESC46)

    self._closebtn:setTitleText(res.str.CLIMB_DESC30)
    self._sureBtn:setTitleText(res.str.CLIMB_DESC48)


end

function TowerRest2View:setData(data_)
    self._yb = data_.money
    if data_.money == 0 then
        self.payPanel:setVisible(false)
        self.freePanel:setVisible(true)
    else
        self.payPanel:setVisible(true)
        self.freePanel:setVisible(false)       
        self.moneyTxt:setString(self._yb)
    end   
end

function TowerRest2View:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        if self._yb > 0 then
            if not G_BuyAnything(2,self._yb) then
                self:onCloseSelfView()
                return
            end 
        end        
        mgr.NetMgr:send(115001,{isRest=1})
        cache.Copy.resetFlag = 1    
        self:onCloseSelfView()
    end
end

function TowerRest2View:onBtnCloseCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:onCloseSelfView()
    end
end

return TowerRest2View