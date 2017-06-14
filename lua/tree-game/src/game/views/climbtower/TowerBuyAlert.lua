--
-- Author: Your Name
-- Date: 2015-07-28 15:55:30
--

local TowerBuyAlert = class("TowerBuyAlert",base.BaseView)

function TowerBuyAlert:init(index)
    self.ShowAll=true
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()

    --购买按钮
    self._getbtn = self.view:getChildByName("Panel_4"):getChildByName("Button_5")
    self._getbtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))
    self._getbtn:setTag(10)
    --购买价格
    self._buyTxt1 = self.view:getChildByName("Panel_4"):getChildByName("Text_2_0")
    self._t1 = self.view:getChildByName("Panel_4"):getChildByName("Text_1")
    self._z1 = self.view:getChildByName("Panel_4"):getChildByName("Image_1")

    self._bt1 = self.view:getChildByName("Panel_4"):getChildByName("Text_1_0")
    self._bt2 = self.view:getChildByName("Panel_4"):getChildByName("Text_2_0")
    self._zs2 = self.view:getChildByName("Panel_4"):getChildByName("Image_1_0")

    self._buyTxt = self.view:getChildByName("Panel_4"):getChildByName("Text_2")

    --继续战斗按钮
    self._oneBtn = self.view:getChildByName("Panel_4"):getChildByName("Button_1")
    self._oneBtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))
    self._oneBtn:setTag(1)

    --关闭按钮
    self._closeBtn = self.view:getChildByName("Panel_4"):getChildByName("Button_2")
    self._closeBtn:addTouchEventListener(handler(self,self.onBtnAgainCallBack)) 

    local panel4 = self.view:getChildByName("Panel_4")
    panel4:getChildByName("Text_1_0"):setString(res.str.CLIMB_DESC25)
    panel4:getChildByName("Text_1"):setString(res.str.CLIMB_DESC25)

    self._getbtn:setTitleText(string.format(res.str.CLIMB_DESC26, 10))



end

function TowerBuyAlert:OpenBox(data)
    self._winState = 1
    local cell = self.view:getChildByName("Panel_4")
    for i=1, 3 do
        local item = cell:getChildByName("ItemAward_"..i)
        item:setVisible(false)
    end
    self.data = data
    self._buyTxt1:setString(data.buyMoney.."/"..cache.Fortune:getZs())
    self._oneBtn:setTitleText(res.str.CLIMB_DESC27)
    self._oneBtn:setPositionX(0)
    self._getbtn:setVisible(false)
    self._buyTxt:setVisible(false)
    self._t1:setVisible(false)
    self._z1:setVisible(false)
    self._bt1:setPositionX(-31.39)
    self._bt2:setPositionX(25.77)
    self._zs2:setPositionX(4.27)
end

function TowerBuyAlert:nextAward(data)
    self._winState = 2
    self.data = data
    self._buyTxt1:setString(data.buyMoney.."/"..cache.Fortune:getZs())
    self._buyTxt:setString(data.buyMoney10.."/"..cache.Fortune:getZs())
    self._oneBtn:setTitleText(string.format(res.str.CLIMB_DESC26, 1))
    self._oneBtn:setPositionX(-148.00)
    self._getbtn:setVisible(true)
    self._buyTxt:setVisible(true)
    self._t1:setVisible(true)
    self._z1:setVisible(true)
    self._bt1:setPositionX(-195.69)
    self._bt2:setPositionX(-138.53)
    self._zs2:setPositionX(-160.03)
    self:setData(self.data)
end

function TowerBuyAlert:setData(data_)
    if not data_ then return end
    self.data = data_
    local config = conf.Copy:getTowerStarAward(cache.Copy.towerStarLvl)
    local ary = data_.items
    local cell = self.view:getChildByName("Panel_4")
    local startx = - 60*(#ary - 1)
    for i=1, 3 do   
        local item = cell:getChildByName("ItemAward_"..i)
        if i<=#ary then
            local img = item:getChildByName("ItemImg_"..i)
            local path = conf.Item:getItemSrcbymid(ary[i].mId)
            img:loadTexture(path)   
            local nameTxt = item:getChildByName("ItemName_"..i)
            local str = conf.Item:getName(ary[i].mId).."x"..ary[i].amount
            nameTxt:setString(str)
            local lv=conf.Item:getItemQuality(ary[i].mId)
            nameTxt:setColor(COLOR[lv])
            local framePath=res.btn.FRAME[lv]
            item:loadTextureNormal(framePath)
            item:setPositionX(startx + 120*(i-1))
            item:setVisible(true)
        else
            item:setVisible(false)
        end
    end
    self._buyTxt1:setString(data_.buyMoney.."/"..cache.Fortune:getZs())
    self._buyTxt:setString(data_.buyMoney10.."/"..cache.Fortune:getZs())
end

function TowerBuyAlert:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        local panel = self.view:getChildByName("Panel_4")
        local box = panel:getChildByName("Image_2")
        if self.data.canBuyCount == 0 then
            G_TipsOfstr(res.str.CLIMB_TIPS7)
            self:onCloseSelfView()
            return
        end
        if self._winState == 1 then      
            local flag = G_BuyAnything(2, self.data.buyMoney, 1)
            if not flag then
                return
            end         
            local params =  {id=404804, x=box:getPositionX(),scale=2,y=box:getPositionY(),addTo=panel,depth=100}
            mgr.effect:playEffect(params)
            --self:setData(self.data)
            box:setVisible(false)
            mgr.NetMgr:send(115006, {count=1})
            mgr.Sound:playQianghua()
        else
            local tag = send:getTag()
            if tag == 1 then
                local flag = G_BuyAnything(2, self.data.buyMoney, 1)
                if not flag then
                    return
                end
            elseif tag == 10 then
                local flag = G_BuyAnything(2, self.data.buyMoney10, 1)
                if not flag then
                    return
                end
            end
            mgr.Sound:playQianghua()
            local params =  {id=404804, x=box:getPositionX(),scale=2,y=box:getPositionY(),addTo=panel,depth=100}
            mgr.effect:playEffect(params)
            self:setData(self.data)
            mgr.NetMgr:send(115006, {count=tag})
        end
    end
end

function TowerBuyAlert:onBtnAgainCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:onCloseSelfView()
    end
end

return TowerBuyAlert
