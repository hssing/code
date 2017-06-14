local CopyPerfectView=class("CopyPerfectView",base.BaseView)

function CopyPerfectView:init(index)
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
    
    self._closebtn = self.view:getChildByName("Button_close")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))
    
    self._getBtn = self.view:getChildByName("Button_5")
    self._getBtn:addTouchEventListener(handler(self,self.onBtnGetClick)) 


    --界面文本
    self._getBtn:setTitleText(res.str.COPY_DESC4)


end

function CopyPerfectView:setData( data_ )
    self.zjId = data_
    local items = conf.Copy:get30AwardItems(data_)
    local startx = 320 - 60*(#items - 1)
    for i=1, 3 do
        local txt = self.view:getChildByName("ItemName_"..i)
        local baseItem = self.view:getChildByName("ItemAward_"..i)
        if i>#items then
            baseItem:setVisible(false)
            txt:setVisible(false)
        else
            baseItem:setPositionX(startx + 120*(i-1))
            local img = baseItem:getChildByName("ItemImg_"..i)
            local itemSrc=mgr.ConfMgr.getItemSrc(items[i][1])
            local path=mgr.PathMgr.getItemImagePath(itemSrc)
             local type=conf.Item:getType(items[i][1])
        if type == pack_type.SPRITE then 
            path=mgr.PathMgr.getImageHeadPath(itemSrc)
        end 
            img:loadTexture(path)
            local str = mgr.ConfMgr.getItemName(items[i][1]).."x"..items[i][2]
            txt:setString(str)
            txt:setPositionX(startx + 120*(i-1))
            local lv=conf.Item:getItemQuality(items[i][1])
            local framePath=res.btn.FRAME[lv]
            baseItem:loadTextureNormal(framePath)
            txt:setColor(COLOR[lv])
        end        
    end
end

function CopyPerfectView:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self:onCloseSelfView()
    end
end

function CopyPerfectView:onBtnGetClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then       
        mgr.NetMgr:send(107002,{stype=self.zjId})
        self:onCloseSelfView()
    end
end

function CopyPerfectView:onCloseSelfView()
    if cache.Copy.hasFinish == true then
        cache.Copy.hasFinish = false
        mgr.ViewMgr:showView(_viewname.COPY_PASS_VIEW):setData(self.zjId)
    end
    self.super.onCloseSelfView(self)
end

return CopyPerfectView