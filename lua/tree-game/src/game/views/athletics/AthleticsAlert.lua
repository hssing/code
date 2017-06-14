local AthleticsAlert=class("AthleticsAlert",base.BaseView)

function AthleticsAlert:init(index)
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
    
    self._closebtn = self.view:getChildByName("Button_close")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))
    
    self._buyBtn = self.view:getChildByName("Button_2")
    self._buyBtn:addTouchEventListener(handler(self,self.onBtnBuyCallBack))
    
    self.totalTime = self.view:getChildByName("Text_4_2")
    self.curTime = self.view:getChildByName("Text_4_1")
    self.needMoney = self.view:getChildByName("Text_4")
    self.buyTimesTxt = self.view:getChildByName("Text_4_0")

    self:initDesc()

end


function AthleticsAlert:initDesc(  )
    -- body
    self.view:getChildByName("Text_33"):setString(res.str.ATHLET_DESC14)
    self._closebtn:getChildByName("Text_1_0_4"):setString(res.str.ATHLET_DESC15)
    self._buyBtn:getChildByName("Text_1_2"):setString(res.str.ATHLET_DESC16)
end


function AthleticsAlert:setData(data_)
    self.winType = 1
    self.data = data_
    local buyTimes = (data_.max - data_.cur)/5 + 1
    self.needMoney:setString(data_.yb)
    self.totalTime:setString(data_.max/5)
    self.curTime:setString(buyTimes)
end

function AthleticsAlert:setGuildFBData(data_)
    self.winType = 2
    self.data = data_
    local buyTimes = (data_.max - data_.cur) + 1
    self.needMoney:setString(data_.yb)
    self.totalTime:setString(data_.max)
    self.curTime:setString(buyTimes)
    self.buyTimesTxt:setString(1)
end
---日常副本
function AthleticsAlert:setDayFBData(data_)
    self.winType = 3
    self.data = data_
    printt(self.data)
    local buyTimes = data_.cur + 1
    self.needMoney:setString(data_.yb)
    self.totalTime:setString(data_.max)
    self.curTime:setString(buyTimes)
    self.buyTimesTxt:setString(1)
end

function AthleticsAlert:setCrossData( data_ )
    -- body
    self.winType = 4
    self.data = data_
    local buyTimes = data_.cur + 1
    self.needMoney:setString(data_.yb)
    self.totalTime:setString(data_.max)
    self.curTime:setString(buyTimes)

    self.buyTimesTxt:setString(conf.Item:getExp(221011011))
end

function AthleticsAlert:onBtnBuyCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        if not G_BuyAnything(2,self.data.yb) then
            self:onCloseSelfView()
            return 
        end
        if self.winType == 1 then
            local data ={stype = property_index.ATHLETICS_COUT,count = 5 }
            proxy.Radio:send101005(data)
        elseif self.winType == 3 then
            if G_BuyAnything(2, self.data.yb) then
                local data = {fbType = self.data.fbType}
                proxy.DayFuben:send121002(data)
            end
        elseif self.winType == 4 then
            debugprint("购买一次")
            local data ={stype = 40360,count = 0 }
            proxy.Radio:send101005(data)
        else
            mgr.NetMgr:send(117013,{buyCount=1})
        end 
        self:onCloseSelfView()
    end
end

function AthleticsAlert:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:onCloseSelfView()
    end
end


function AthleticsAlert:onCloseSelfView()
    self.super.onCloseSelfView(self)
end

return AthleticsAlert