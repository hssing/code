--
-- Author: Your Name
-- Date: 2015-07-27 20:37:24
--

local TowerAlert = class("TowerAlert",base.BaseView)

function TowerAlert:init(index)
    self.ShowAll=true
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()

    --self.bigTxt = {"一","二","三","四"}
    self.hartTxt = self.view:getChildByName("Panel_1"):getChildByName("Text_2")

    --关闭
    self._closebtn = self.view:getChildByName("Panel_1"):getChildByName("Button_6_2_2")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))

    --界面文本
    local panel = self.view:getChildByName("Panel_1")
    panel:getChildByName("Text_1"):setString(res.str.CLIMB_DESC20)
    panel:getChildByName("Text_3"):setString(string.format(res.str.CLIMB_DESC21, 10))

    self._closebtn:setTitleText(res.str.CLIMB_DESC22)

end

function TowerAlert:setData(data_)
    local str = data_.hardStr
    self.hartTxt:setString(str)
end

function TowerAlert:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:onCloseSelfView()
    end
end

return TowerAlert