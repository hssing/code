local CopyPassView=class("CopyPassView",base.BaseView)

function CopyPassView:init(index)
    self.showtype=view_show_type.UI
    self.view=self:addSelfView()
      
    self._continueBtn = self.view:getChildByName("Panel_1"):getChildByName("Button_5")
    self._continueBtn:addTouchEventListener(handler(self,self.onBtnContinueCallBack))
    self._nextBtn = self.view:getChildByName("Panel_1"):getChildByName("Button_6")
    self._nextBtn:addTouchEventListener(handler(self,self.onBtnNextCallBack)) 

    --界面文本
     self._continueBtn:setTitleText(res.str.COPY_DESC12) 
     self._nextBtn:setTitleText(res.str.COPY_DESC13) 

end

function CopyPassView:setData(data_)
    if self._richText then
        self._richText:removeFromParent()
    end
    local config = conf.Copy:getChapterInfo(data_)
    local zjName = config.name or ""
    local params = {text = {{res.str.COPY_DESC10, {255,255,255}, 22},
        {config.title.."："..zjName, {255,93,5}, 22},
        {res.str.COPY_DESC11, {255,255,255}, 22},
    }, width=340, height=200} 
    self._richText = G_RichText(params)
    self._richText:setPosition(80,-105)
    local panel = self.view:getChildByName("Panel_1")
    panel:addChild(self._richText)
end

function CopyPassView:onBtnContinueCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then     
        self.super.closeSelfView(self)
    end
end

function CopyPassView:onBtnNextCallBack( send,eventype )
    if eventype == ccui.TouchEventType.ended then
        local state = cache.Copy:gotoNext()
        if state == true then
            local view = mgr.ViewMgr:get(_viewname.COPY_CHAPTER)
            view:changeBg()
            view:setData()
        end 
        self.super.closeSelfView(self)
    end
end

return CopyPassView