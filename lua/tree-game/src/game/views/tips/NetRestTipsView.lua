local NetRestTipsView=class("NetRestTipsView",base.BaseTipsView)

function NetRestTipsView:ctor()

end
function NetRestTipsView:init(  )
	self.showtype = view_show_type.NET
	self.view = self:addSelfView()
	
	self.button_sure = self.view:getChildByTag(0):getChildByTag(2)--按钮
	gui.GUIButton.new(self.button_sure,handler(self,self.onCallBack))
	self.btn_cancel = self.view:getChildByTag(0):getChildByTag(3)--取消按钮
	gui.GUIButton.new(self.btn_cancel,handler(self,self.oncancelCallBack))
	self.Panel_text = self.view:getChildByName("Panel_text"):setVisible(false)
	self.text1 = self.view:getChildByName("Panel"):getChildByName("Text_1")
	self.text = self.view:getChildByTag(0):getChildByTag(115)
	self._t_width = self.Panel_text:getContentSize().width
	self._t_height = self.Panel_text:getContentSize().height
	self.view:setOpacity(0)

	local basePanel = self.view:getChildByName("Panel")
	self.checkbox = basePanel:getChildByName("CheckBox_1")
	self.checkbox:setVisible(false)
	self.checktext = basePanel:getChildByName("Text_1_1")
	self.checktext:setVisible(false)
	--[[local _spr = self.view:getChildByName("Panel"):getChildByName("Image_7")
	_spr:setPositionY(_spr:getPositionY()-30)
	_spr:setScale(0.5)
	_spr:ignoreContentAdaptWithSize(true)]]--

	transition.execute(self.view, cc.FadeIn:create(0.5), {
	    --delay = 1.0,
	    --easing = "backout",
	    --onComplete = function()
	      --  print("move completed")
	   -- end,
	})

	self:initDec()
end

function NetRestTipsView:initDec()
	-- body
	self.button_sure:setTitleText(res.str.SURE)
	self.btn_cancel:setTitleText(res.str.CANCEL)
	self.text1:setString(res.str.TIPS_DESC_MASTER)
end

function NetRestTipsView:setData(data_,bl)
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
		local uirichtext = require("game.cocosstudioui.UIRichText").new()
		uirichtext:setContentSize(200,100)
		uirichtext:setPosition(p_width/2-uirichtext:getContentSize().width/2,p_height/2)
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
    self:showHidePanel(true)
end

function NetRestTipsView:restShowTips()
	self:showHidePanel(true)
end

function NetRestTipsView:isReConnet()
	if self.loadNode then return true end
	return false
end

function NetRestTipsView:showHidePanel(flag__)
	self.view:getChildByName("Panel"):setVisible(flag__)
	if flag__ == true then
			if self.loadNode then
					self.loadNode:removeSelf()
					self.loadNode = nil
			end
	   -- if self.label__ then
    --         self.label__:removeSelf()
    --         self.label__ = nil
	   -- end
	else
	   if self.loadNode == nil then
	   			self.loadNode = display.newNode()
	   			self:addChild(self.loadNode)
				  local params = {id=404825,x=display.cx+40,y=display.cy-30,addTo=self.loadNode,scale=0.5,depth=5}
				  mgr.effect:playEffect(params)
            -- self.label__ = cc.ui.UILabel.new({
            -- UILabelType = 2, text = "正在重连中...", size = 64})
            -- :align(display.CENTER, display.cx, display.cy)
            -- :addTo(self)
	   end
	end
	
end

function NetRestTipsView:onCallBack( send_ ,event_type )
	if event_type == ccui.TouchEventType.ended then
		if self.data.sure then
			self:showHidePanel(false)
			self.data.sure()	
		end
	end
end

function NetRestTipsView:oncancelCallBack(  send_ ,event_type  )
	if event_type == ccui.TouchEventType.ended then
		if self.data.cancel then 
			self.data.cancel()
		end
	end
end

function NetRestTipsView:addSelfView(  )
	local selfview=self:loadUI(res.views.ui.test_tips)
	selfview:addTo(self)
	return selfview
end

return NetRestTipsView