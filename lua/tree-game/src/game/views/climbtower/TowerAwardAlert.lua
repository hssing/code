--
-- Author: Your Name
-- Date: 2015-07-28 15:55:30
--

local TowerAwardAlert = class("TowerAwardAlert",base.BaseView)

function TowerAwardAlert:init(index)
    self.ShowAll=true
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()

    --领取按钮
    self._getbtn = self.view:getChildByName("Panel_4"):getChildByName("Button_5")
    self._getbtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))


    --界面文本显示
    local panel4 = self.view:getChildByName("Panel_4")
    panel4:getChildByName("Text_13"):setString(res.str.CLIMB_DESC23)
    self._getbtn:setTitleText(res.str.CLIMB_DESC24)

end

function TowerAwardAlert:setData(data_)
    self.data = data_
    local config = conf.Copy:getTowerStarAward(cache.Copy.towerStarLvl)
    local ary = config.start_awards[data_.startAward+1]
    local len = (#ary - 1)/2
    local cell = self.view:getChildByName("Panel_4")
    for i=1, 3 do
        local startx = - 60*(len - 1)
        local item = cell:getChildByName("ItemAward_"..i)
        if i<=len then
            local index = 2+(i-1)*2
            local img = item:getChildByName("ItemImg_"..i)
            local path = conf.Item:getItemSrcbymid(ary[index])
            img:loadTexture(path)   
            local nameTxt = item:getChildByName("ItemName_"..i)
            local str = conf.Item:getName(ary[index]).."x"..ary[index+1]
            nameTxt:setString(str)
            local lv=conf.Item:getItemQuality(ary[index])
            nameTxt:setColor(COLOR[lv])
            local framePath=res.btn.FRAME[lv]
            item:loadTextureNormal(framePath)
            item:setPositionX(startx + 120*(i-1))
        else
            item:setVisible(false)
        end
    end
end

function TowerAwardAlert:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        mgr.NetMgr:send(115005, {startIndex=self.data.startAward})
        mgr.NetMgr:send(115007)
        self:onCloseSelfView()
    end
end

return TowerAwardAlert
