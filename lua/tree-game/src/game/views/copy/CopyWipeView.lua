local CopyWipeView=class("CopyWipeView",base.BaseView)

function CopyWipeView:init(index)
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()

    self._closebtn = self.view:getChildByName("Button_close")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))

    self._getBtn = self.view:getChildByName("Button_17")
    self._getBtn:addTouchEventListener(handler(self,self.onBtnGetClick))
    
    self._panel8 = self.view:getChildByName("Panel_8")
    self._scrollView = self.view:getChildByName("ScrollView_1")

    self._titleImg = self.view:getChildByName("Image_12")
    
    self._allData = {}
    self._allCells = {}


    --界面文本
    self._getBtn:setTitleText(res.str.COPY_DESC4)


end

function CopyWipeView:setData( data_ , type)
    self.fType = type
    self.fbId = data_
    if type == fight_vs_type.copy then
        self._titleImg:loadTexture("res/views/ui_res/imagefont/copy_saodangjieguo.png")
        self._wipeTime = 10
    elseif type == fight_vs_type.tower then
        self._titleImg:loadTexture("res/views/ui_res/imagefont/yijianwuguan.png")
        self._wipeTime = 5
    end
end

function CopyWipeView:rWipeInfo(data_)
    if type == fight_vs_type.tower then
        self.fbId = data_.fId
    end 
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
            local panel1 = cell:getChildByName("Panel_1")
            local panel2 = cell:getChildByName("Panel_2")
            jbTxt = panel1:getChildByName("Text_20_16")
            local img = panel2:getChildByName("Image_36_37")
            img:ignoreContentAdaptWithSize(true)
            expTxt = panel2:getChildByName("Text_21_18")
            if self.fType == fight_vs_type.tower then
                panel1:getChildByName("Image_31_33"):setVisible(false)
                panel1:getChildByName("Text_1"):setVisible(true)
                panel1:getChildByName("Text_1"):setString(res.str.COPY_DESC21)
                img:loadTexture("res/views/ui_res/icon/star_icon.png")
                jbTxt:setString(data_.guts)
                expTxt:setString(data_.thisStart)
            elseif self.fType == fight_vs_type.copy then
                expTxt:setString(data_.exp)
                jbTxt:setString(data_.moneyJb)
                img:loadTexture("res/views/ui_res/imagefont/copy_exp.png")
            end
            local items = data_.items
            local startx = 320 - 60*(#items - 1)
            if i == #self._allData then
                table.insert(dhMcs,panel1)
                table.insert(dhMcs,panel2)
            end
            for j=4, 1,-1 do
                local baseItem = cell:getChildByName("ItemAward_"..j)
                if j>#items then
                    baseItem:setVisible(false)
                else
                    baseItem:setPositionX(startx + 120*(j-1))
                    if i == #self._allData then
                        table.insert(dhMcs,baseItem)
                    end
                    local img = baseItem:getChildByName("awardImg_"..j)
                    local path= conf.Item:getItemSrcbymid(items[j].mId)
                    img:loadTexture(path)
                    local txt = baseItem:getChildByName("Text_1_"..j)
                    local str = conf.Item:getName(items[j].mId).."x"..items[j].amount
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
        local bianhao = cell:getChildByName("Text_19")
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
                if #self._allData < self._wipeTime then
                    local delay = cc.DelayTime:create(0.5)
                    local callFunc = cc.CallFunc:create(function()
                        if self.fType == fight_vs_type.copy then
                            mgr.NetMgr:send(107003,{fId=self.fbId})
                        elseif self.fType == fight_vs_type.tower then
                            self.fbId = self.fbId + 10
                            local level = tonumber(string.sub(self.fbId ,3,5))
                            if level <= 100 then
                                mgr.NetMgr:send(115004,{fId=self.fbId})
                            end
                        end
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

function CopyWipeView:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:closeSelfView()
    end
end

function CopyWipeView:onBtnGetClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:closeSelfView()
    end
end

function CopyWipeView:closeSelfView()
    --检查是否有升级
    G_DelayRoleUp()

    if self.fType == fight_vs_type.tower then
        --mgr.ViewMgr:showView(_viewname.TOWER_YQ)
        mgr.NetMgr:send(115001,{isRest=0})
    end
    
    self.super.closeSelfView(self)

    G_TaskShow(true)
end

return CopyWipeView