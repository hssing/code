--
-- Author: Your Name
-- Date: 2015-08-05 10:46:08
--


local ConfirmView = class("ConfirmView", base.BaseTipsView)

function ConfirmView:init(  )
	-- body
	self.showtype = view_show_type.TOP
	self.view=self:addSelfView()
	self.button_sure=self.view:getChildByTag(0):getChildByTag(2)--按钮
	gui.GUIButton.new(self.button_sure,handler(self,self.onCallBack))
	self.btn_cancel = self.view:getChildByTag(0):getChildByTag(3)--取消按钮
	gui.GUIButton.new(self.btn_cancel,handler(self,self.oncancelCallBack))
	self.Panel_text=self.view:getChildByName("Panel_text"):setVisible(false)
	self.text1=self.view:getChildByName("Panel"):getChildByName("Text_1")
	self.text = self.view:getChildByTag(0):getChildByTag(115)
	self.text:ignoreContentAdaptWithSize(false)

	self._t_width=self.Panel_text:getContentSize().width
	self._t_height=self.Panel_text:getContentSize().height
	self.view:setOpacity(0)

	local basePanel = self.view:getChildByName("Panel")
	self.checkbox = basePanel:getChildByName("CheckBox_1")
	self.checktext =  basePanel:getChildByName("Text_1_1")


	transition.execute(self.view, cc.FadeIn:create(0.5), {
    --delay = 1.0,
    --easing = "backout",
    --onComplete = function()
      --  print("move completed")
   -- end,
	})
	--[[local bg_img = self.view:getChildByTag(0):getChildByTag(1)
	local lab_txt =  ccui.Text:create() ;
    lab_txt:setFontSize(30)
    lab_txt:setString(self.data.richtext)
    lab_txt:setPosition(bg_img:getContentSize().width/2,bg_img:getContentSize().height/2)
    bg_img:addChild(lab_txt)]]--

    self.checkbox = basePanel:getChildByName("CheckBox_1")
	self.checkbox:setVisible(false)

	--self._checkbox:setSelected(false)
	--self._checkbox:addEventListener(handler(self, self.checkBoxCallback))

	self.checktext =  basePanel:getChildByName("Text_1_1")
	self.checktext:setString("")
	self.checktext:setVisible(false)

    self:initDec()
end

function ConfirmView:initDec()
	-- body
	self.button_sure:setTitleText(res.str.SURE)
	self.btn_cancel:setTitleText(res.str.CANCEL)
end


function ConfirmView:setData(data_,bl)
	-- body
	self.data = data_
	if self.data.surestr~=nil then 
		self.button_sure:setTitleText(self.data.surestr)
	end	

	if not self.data.cancel  then 
		self.btn_cancel:setVisible(false)
		--local y = self.button_sure:getPositionPercent().y;
		--local x = 0.5
		--self.button_sure:setPositionPercent(cc.p(x,y))
		self.button_sure:setPositionX(display.cx)
	else
		if self.data.cancelstr then 
			self.btn_cancel:setTitleText(self.data.cancelstr)
		end	
	end	


		if bl then
			self.Panel_text:setVisible(true)
			self.text:setVisible(false)
			self.text1:setVisible(false)
			local p_width = self.Panel_text:getContentSize().width
			local p_height = self.Panel_text:getContentSize().height 
			local uirichtext = ccui.RichText:create()
			uirichtext:setContentSize(p_width,0)
			uirichtext:setPosition(p_width/2,p_height/2+40)
			uirichtext:ignoreContentAdaptWithSize(false)
			for i=1,#self.data.richtext do
				uirichtext:pushBackElement(self.data.richtext[i])
			end
			uirichtext:formatText()
			self.Panel_text:addChild(uirichtext)
		else
			if self.data.richtext then
				 self.text:setString(self.data.richtext)
			end
		end
	

end

function ConfirmView:onCallBack( send_ ,event_type )
	if event_type == ccui.TouchEventType.ended then
		if self.data.sure then 
			self.data.sure()
		end	
		--mgr.ViewMgr:closeView(self:getPathName())
		self:closeSelfView()
	end
end

function ConfirmView:oncancelCallBack(  send_ ,event_type  )
	-- body
	if event_type == ccui.TouchEventType.ended then
		if self.data.cancel then 
			self.data.cancel()
		end
		self:closeSelfView()
		--mgr.ViewMgr:closeView(self:getPathName())	
	end
end


function ConfirmView:addSelfView(  )
	--print("TestTipsView.TestTipsView")
	local selfview=self:loadUI(res.views.ui.test_tips)
	selfview:addTo(self)
	return selfview
end







return ConfirmView