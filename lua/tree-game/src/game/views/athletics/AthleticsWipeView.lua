local AthleticsWipeView=class("AthleticsWipeView",base.BaseView)

function AthleticsWipeView:init(index)
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()

    self._closebtn = self.view:getChildByName("Button_close")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))

    self._getBtn = self.view:getChildByName("Button_17")
    self._getBtn:addTouchEventListener(handler(self,self.onBtnGetClick))

    self._panel8 = self.view:getChildByName("Panel_8")
    self._scrollView = self.view:getChildByName("ScrollView_1")

    self._allData = {}
    self._allCells = {}
end

function AthleticsWipeView:setData( data_ )
    self.roleId = data_
    --mgr.NetMgr:send(114004,{uId=self.roleId})
end

function AthleticsWipeView:rWipeInfo(data_)
    table.insert(self._allData,data_)
    local cx = 0
    local cy = (#self._allData-1)*265
    local dhMcs = {}
    for i=1, #self._allData do
        local cell
        local jbTxt
        local expTxt
        if self._allCells[i] then
            cell = self._allCells[i]
        else
            cell = self._panel8:clone()
            self._scrollView:addChild(cell)
            table.insert(self._allCells,cell)
            local panel1 = cell:getChildByName("Panel_1_3")
            local panel2 = cell:getChildByName("Panel_2_5")
            jbTxt = panel1:getChildByName("Text_20_16_4")
            jbTxt:setString(data_.money_hz)
            expTxt = panel2:getChildByName("Text_21_18_6")
            expTxt:setString(data_.exp)
            local items = data_.items
            local startx = 320 -- 60*(#items - 1)
            if i == #self._allData then
                table.insert(dhMcs,panel1)
                table.insert(dhMcs,panel2)
            end
            for j=4, 1,-1 do
                local baseItem = cell:getChildByName("ItemAward_"..j)
                if j>#items or items[j].index==0 then
                    baseItem:setVisible(false)
                else
                    baseItem:setPositionX(startx)
                    if i == #self._allData then
                        table.insert(dhMcs,baseItem)
                    end
                    local img = baseItem:getChildByName("awardImg_"..j)
                    local itemSrc=mgr.ConfMgr.getItemSrc(items[j].mId)
                    local path=mgr.PathMgr.getItemImagePath(itemSrc)
                    local type=conf.Item:getType(items[j].mId)
                    if type == pack_type.SPRITE then 
                        path=mgr.PathMgr.getImageHeadPath(itemSrc)
                    end 
                    img:loadTexture(path)
                    local txt = baseItem:getChildByName("Text_1_"..j)
                    local str = mgr.ConfMgr.getItemName(items[j].mId).."x"..items[j].amount
                    txt:setString(str)
                    local lv=conf.Item:getItemQuality(items[j].mId)
                    txt:setColor(COLOR[lv])
                    local framePath=res.btn.FRAME[lv]
                    baseItem:loadTextureNormal(framePath)
                end
            end
        end
        if #self._allData==1 then
            cell:setPosition(0, 265)
        else
            cell:setPosition(0, cy-(i-1)*265)
        end
        local bianhao = cell:getChildByName("Text_19_2")
        bianhao:setString(i.."")
    end
    self._scrollView:setInnerContainerSize(cc.size(640,cy+265))
    self._scrollView:jumpToBottom()

    for i=1, #dhMcs do
        local mc = dhMcs[i]
        local x1 = mc:getPositionX()
        local y1 = mc:getPositionY()
        mc:setPositionX(x1 - 500)
        local delay = cc.DelayTime:create((i-1)*0.1+0.1)
        local move = cc.MoveTo:create(0.1, cc.p(x1, y1))
        if i == #dhMcs then
            local callFunc = cc.CallFunc:create(function()
                if #self._allData < 5 then
                    local delay = cc.DelayTime:create(0.5)
                    local callFunc = cc.CallFunc:create(function()
                        mgr.NetMgr:send(114004,{uId=self.roleId})
                    end)
                    self:runAction(cc.Sequence:create(delay, callFunc))
                end
            end)
            mc:runAction(cc.Sequence:create(delay, move, callFunc))
        else
            mc:runAction(cc.Sequence:create(delay, move))
        end
    end    
end

function AthleticsWipeView:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:closeSelfView()
    end
end

function AthleticsWipeView:onBtnGetClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:closeSelfView()
    end
end

function AthleticsWipeView:closeSelfView()
    --检查是否有升级
    G_DelayRoleUp()

    self.super.closeSelfView(self)
end

return AthleticsWipeView