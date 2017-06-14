local CopyAwardView=class("CopyAwardView",base.BaseView)

function CopyAwardView:init(index)
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
    
    self._closebtn = self.view:getChildByName("Panel_1"):getChildByName("Button_close")
    self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))
    self._expTxt = self.view:getChildByName("Panel_1"):getChildByName("Text_21")
    self._moneyTxt = self.view:getChildByName("Panel_1"):getChildByName("Text_20")
    self._tzTimes = self.view:getChildByName("Panel_1"):getChildByName("Text_22_1_0")
    
    self.awards = {}
    self.itemNames = {}
    for i=1, 3 do
        local itemBtn = self.view:getChildByName("Panel_1"):getChildByName("ItemAward_"..i)
        itemBtn:setEnabled(true)
        itemBtn:addTouchEventListener(handler(self,self.onItemBtnClick))
        self.awards[i] = itemBtn --gui.GUIButton.new(itemBtn,handler(self,self.onItemBtnClick))
        self.itemNames[i] = self.view:getChildByName("Panel_1"):getChildByName("ItemName_"..i)
    end


    --界面文本
    local panel = self.view:getChildByName("Panel_1")
    panel:getChildByName("Text_22_1"):setString(res.str.COPY_DESC7)
    panel:getChildByName("Text_22"):setString(res.str.COPY_DESC8)
    panel:getChildByName("Text_22_0"):setString(res.str.COPY_DESC9)
    


end

function CopyAwardView:onItemBtnClick( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        local id = send.tag
        G_openItem(id)
    end
end

function CopyAwardView:setData( data )
    local chapterConf = conf.Copy:getFbInfo(data.fId)
    self._expTxt:setString(chapterConf["exp"])
    self._moneyTxt:setString(chapterConf["money_jb"])
    self._tzTimes:setString(data.fbCount.."/"..chapterConf.max_count)
     
    local items = chapterConf["box"] or {}
    for i=1, 3 do
        if i>#items then
            self.awards[i]:setVisible(false)
            self.itemNames[i]:setVisible(false)
        else
            local itemSrc=mgr.ConfMgr.getItemSrc(items[i][1])
            local path=mgr.PathMgr.getItemImagePath(itemSrc)

            local type=conf.Item:getType(items[i][1])
            if type == pack_type.SPRITE then 
                path=mgr.PathMgr.getImageHeadPath(itemSrc)
            end 

            local img = self.awards[i]:getChildByName("ItemImg_"..i)
            img:loadTexture(path)
            self.awards[i].tag = items[i][1]
            self.itemNames[i]:setString(mgr.ConfMgr.getItemName(items[i][1]))
            local lv=conf.Item:getItemQuality(items[i][1])
            local framePath=res.btn.FRAME[lv]
            self.awards[i]:loadTextureNormal(framePath)
            self.itemNames[i]:setColor(COLOR[lv])
        end
    end
end

function CopyAwardView:onBtnSureCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        self.super.closeSelfView(self)
    end
end

return CopyAwardView