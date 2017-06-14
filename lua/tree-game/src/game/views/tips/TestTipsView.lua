local TestTipsView=class("TestTipsView",base.BaseTipsView)

function TestTipsView:ctor()

end
function TestTipsView:init(  )
	self.showtype = view_show_type.TOP
	self.view=self:addSelfView()
	self.button_sure=self.view:getChildByTag(0):getChildByTag(2)--按钮
	gui.GUIButton.new(self.button_sure,handler(self,self.onCallBack))
	self.btn_cancel = self.view:getChildByTag(0):getChildByTag(3)--取消按钮
	gui.GUIButton.new(self.btn_cancel,handler(self,self.oncancelCallBack))
	self.Panel_text=self.view:getChildByName("Panel_text"):setVisible(false)
	
	local basePanel = self.view:getChildByName("Panel")
	self.text1=basePanel:getChildByName("Text_1")
	-- self.text = self.view:getChildByTag(0):getChildByTag(115)
	-- self.text:ignoreContentAdaptWithSize(false)
	local baseText = self.view:getChildByTag(0):getChildByTag(115)
	baseText:setString("")
	baseText:setVisible(false)

	self.text = display.newTTFLabel({
		    text = "",
		    font = res.ttf[1],
		    size = 24,
		    color = COLOR[1],
		    align = cc.TEXT_ALIGNMENT_LEFT,
		    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
		    dimensions = cc.size(280, 0), 
		})
	self.text:setAnchorPoint(cc.p(0,1))
	self.text:setPosition(baseText:getPositionX(), self.text1:getPositionY()-20)
	basePanel:addChild(self.text)

	self.image_Bg = self.view:getChildByTag(0):getChildByName("Image_Bg")

	self._t_width=self.Panel_text:getContentSize().width
	self._t_height=self.Panel_text:getContentSize().height
	self.view:setOpacity(0)

	self.checkbox = basePanel:getChildByName("CheckBox_1")
	self.checkbox:setVisible(false)
	self.checkbox:setSelected(false)

	--self._checkbox:setSelected(false)
	--self._checkbox:addEventListener(handler(self, self.checkBoxCallback))

	self.checktext =  basePanel:getChildByName("Text_1_1")
	self.checktext:setString("")
	self.checktext:setVisible(false)



	self:initDec()

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
	--[[local bg_img = self.view:getChildByTag(0):getChildByTag(1)
	local lab_txt =  ccui.Text:create() ;
    lab_txt:setFontSize(30)
    lab_txt:setString(self.data.richtext)
    lab_txt:setPosition(bg_img:getContentSize().width/2,bg_img:getContentSize().height/2)
    bg_img:addChild(lab_txt)]]--
    self.text1:setString(res.str.TIPS_DESC_MASTER)

end

function TestTipsView:initDec()
	-- body
	self.button_sure:setTitleText(res.str.SURE)
	self.btn_cancel:setTitleText(res.str.CANCEL)
end

function TestTipsView:setData(data_,bl,bl2)
	-- body
	self.view:setVisible(true)
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
	-- local richtext=ccui.RichText:create()
	-- local text=ccui.RichElementText:create(1,cc.c3b(255,255,255),255,self.data.richtext,"Helvetica",25)
	-- richtext:pushBackElement(text)
	-- self.data.Special= "我靠撒点粉"
	-- if self.data.Special then
	-- 	 text=ccui.RichElementText:create(1,cc.c3b(255,0,0),255,self.data.Special,"Helvetica",25)
	-- 	richtext:pushBackElement(text)
	-- end
	-- richtext:formatText()
	-- local w=richtext:getVirtualRendererSize().width

	-- local h=richtext:getVirtualRendererSize().height

	-- -- self.data.Alignment = HORIZONTAL_CENTER_UP

	-- if self.data.Alignment == VERTICAL_CENTER_LIFE then
	-- 	richtext:setPosition(w/2,self._t_height/2)
	-- elseif self.data.Alignment == HORIZONTAL_CENTER_UP then
	-- 	richtext:setPosition(self._t_width/2,self._t_height-h/2)
	-- else
	-- 	richtext:setPosition(self._t_width/2,self._t_height/2)
	-- end
	-- self.Panel_text:addChild(richtext)

		if bl then
			self.Panel_text:setVisible(true)
			self.text:setVisible(false)
			self.text1:setVisible(false)
			local p_width = self.Panel_text:getContentSize().width
			local p_height = self.Panel_text:getContentSize().height 
			local uirichtext = require("game.cocosstudioui.UIRichText").new()
			uirichtext:setContentSize(p_width,0)
			uirichtext:setPosition(0,p_height/2+40)
			for i=1,#self.data.richtext do
				uirichtext:pushBackElement(self.data.richtext[i])
			end
			uirichtext:formatText()
			self.Panel_text:addChild(uirichtext)
		elseif bl2 then --这个有限制 不能换行 注意使用
			self.Panel_text:setVisible(true)
			self.text:setVisible(false)
			self.text1:setVisible(false)
			local posx = self.image_Bg:getContentSize().width*0.33 --每一行左边的开始坐标
			local posy = self.image_Bg:getContentSize().height*0.65

			for k , v in pairs(self.data.richtext) do 
				if v.text then 
					local str = string.split(v.text, "\n")
					for i , j in pairs(str) do 
						local label = display.newTTFLabel({
							text = j,
							size = v.fontSize,
							align = cc.TEXT_ALIGNMENT_LEFT, -- 文字内部居左对齐
							x = posx,
							y = posy,
							font = res.ttf[1],
							color = v.color
						})
						label:setAnchorPoint(0,0.5) --锚点一定要左边
						label:addTo(self.image_Bg)
						if i == #str then 
							posx = posx + label:getContentSize().width	
						else
							posx = self.image_Bg:getContentSize().width*0.33
							posy = posy - label:getContentSize().height
						end
					end 
									
				elseif v.img then 
					local img = display.newSprite(v.img)
					img:setAnchorPoint(0,0.5)
					img:setPosition(posx, posy)
					img:addTo(self.image_Bg)

					posx = posx + img:getContentSize().width
				elseif v.title then 
					self.text1:setVisible(true)
				end 
			end 
		else
			if self.data.richtext then
				self.text:setString(self.data.richtext)
			end
		end

		if self.data.checktext  then 
			self.checkbox:setVisible(true)
			self.checktext:setVisible(true)
			self.checktext:setString(self.data.checktext or "" )
		end
end

function TestTipsView:onCallBack( send_ ,event_type )
	if event_type == ccui.TouchEventType.ended then
		self.view:setVisible(false)
		if self.data.sure then 
			self.data.sure(self.checkbox:isSelected())
		end	

		--[[local view = mgr.ViewMgr:get(_viewname.DIG_SET)
		local view2 = mgr.ViewMgr:get(_viewname.COMPOSE)
		local view3 = mgr.ViewMgr:get(_viewname.LUCKYDRAW)
		if not view and  not view2 and  not view3  and not tolua.isnull(self) then 
			self:closeSelfView()
		end ]]--
		if self and not tolua.isnull(self) then
			self:closeSelfView()
		end

		
	end
end

function TestTipsView:oncancelCallBack(  send_ ,event_type  )
	-- body
	if event_type == ccui.TouchEventType.ended then
		--self.view:setVisible(false)
		if self.data.cancel then 
			self.data.cancel()
		end
		if self and not tolua.isnull(self) then
			self:closeSelfView()
		end
		--mgr.ViewMgr:closeView(self:getPathName())	
	end
end


function TestTipsView:addSelfView(  )
	--print("TestTipsView.TestTipsView")
	local selfview=self:loadUI(res.views.ui.test_tips)
	selfview:addTo(self)
	return selfview
end

return TestTipsView