local DebugTestView=class("DebugTestView",base.BaseView)


function DebugTestView:init()
  -- self:setTouchEnabled(false)
  self.showtype= view_show_type.TOP
  self.view=self:addSelfView()
  -- self.view:setTouchEnabled(true)
  -- self.viewaddTouchEventListener(handler(self,function))
  -- self.view:set
  self:setContentSize(self.view:getContentSize())
  self.inputTxt = self.view:getChildByTag(16)
  self.view:getChildByTag(15):addTouchEventListener(handler(self,self.onbtnTextHandler))
  self.view:getChildByTag(21):addTouchEventListener(handler(self,self.onbtnCloseHandler))
  self.view:getChildByTag(16):setVisible(false)
  -- self.view:getChildByTag(21):setPositionY(self.view:getChildByTag(21):getPositionY()-100)
  self:setTouchSwallowEnabled(false)
  self.view:getChildByName("Image_1"):setTouchEnabled(true)
  self.inputTxt = cc.ui.UIInput.new({
    image = res.image.RED_PONT,
    x = 280,
    y = self.view:getChildByTag(16):getPositionY(),
    size = cc.size(500, 50)
  })
  self.inputTxt:addTo(self)

  local pushBtn = self.view:getChildByName("Button_10")
  pushBtn:addTouchEventListener(handler(self,self.pushTest))

--   local function onEdit(textfield, eventType)
--     if event == 0 then
--         print("rrrrrrrrrrrrrrrrrr")
--     elseif event == 1 then
--         -- DETACH_WITH_IME
--          print("rrrrrrrrrrrrrrrrrr")
--     elseif event == 2 then
--         -- INSERT_TEXT
--          print("rrrrrrrrrrrrrrrrrr")
--     elseif event == 3 then
--         -- DELETE_BACKWARD
--          print("rrrrrrrrrrrrrrrrrr")
--     end
-- end
--   local textfield =cc.ui.UIInput.new({
--       UIInputType = 1,
--      listener = onEdit,
--       size = cc.size(500, 600),
--       x=100,
--       y=500,
--       text="safsdfsdfsd",
--   })

--   self:addChild(textfield)
end

function DebugTestView:onbtnTextHandler( send_,eventtype )
  if eventtype == ccui.TouchEventType.ended then
    mgr.NetMgr:testCommand(self.inputTxt:getText())
   print(self.inputTxt:getText())
  end
end

function DebugTestView:onbtnCloseHandler(send_,eventtype_)
  if eventtype_ == ccui.TouchEventType.ended then
    --mgr.ViewMgr:closeView(_viewname.DEBUG_TEST)
     self:closeSelfView()

  end
end

function DebugTestView:pushTest(send_,eventtype_)
    if eventtype_ == ccui.TouchEventType.ended then
        G_Init_PushMsg___()
    end
end

return DebugTestView