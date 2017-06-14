--
-- Author: Your Name
-- Date: 2015-08-01 00:50:21
--


local InvitationView 

if g_language == LANGUAGE.CHINA then--简体中文
	InvitationView = class("InvitationView", base.BaseView)
elseif  g_language == LANGUAGE.CHINA_TW then--繁体
	InvitationView = class("InvitationView_tw", base.BaseView)
end

function InvitationView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	if g_language == LANGUAGE.CHINA then--简体中文
		self.panel1 = self.view:getChildByName("ScrollView"):getChildByName("Panel_1")
		self.panel2 = self.view:getChildByName("ScrollView"):getChildByName("Panel_2")
	elseif  g_language == LANGUAGE.CHINA_TW then--繁体
		self.listView = self.view:getChildByName("ListView_1")
		local size = 3
		for i=1,size do
			self.listView:pushBackCustomItem(self.view:getChildByTag(100 + i):clone())
			if i < size then
				self.listView:pushBackCustomItem(self.view:getChildByTag(1000):clone() )
			end
		end
		self.panel1 = self.listView:getItem(0)
		self.panel2 = self.listView:getItem(2)
		self.panel3 = self.listView:getItem(4)

		self.observerAwardBtn = self.panel3:getChildByName("Button_observer_2")-----查看奖励
		self.observerAwardBtn:addTouchEventListener(handler(self, self.observerAwardCallback))
		self.lv_invitated = self.panel3:getChildByName("Text_count_6")--达到30级的好友

		self.shareBtn = self.panel3:getChildByName("Button_10")
		self.shareBtn:addTouchEventListener(handler(self,self.shareBtnCallback))

	end

	self.panelItem1 = self.panel1:getChildByName("Panel_item1")
	self.panelItem2 = self.panel1:getChildByName("Panel_item2")
	self.inputField = self.panelItem1:getChildByName("TextField_code")
	self.sendBtn = self.panelItem1:getChildByName("Button_conmmit")


	------输入框
	self.inputUI = cc.ui.UIInput.new({---------邀请码输入框
		    image =res.image.TRANSPARENT,
		    x = self.inputField:getPositionX(),
		    y = self.inputField:getPositionY() + 4,
		    size = cc.size(230,40)
		})

	self.inputUI:setFontSize(20)

	--self.inputUI:setFontColor(cc.c3b(255,0,255))
	self.panelItem1:addChild(self.inputUI)
	self.inputField:removeFromParent()

	self.textLebel =self.panelItem2:getChildByName("Text_4")
	self.panelItem2:setVisible(false) 
	self.sendBtn:addTouchEventListener(handler(self,self.onSendBtnClickUpCallback))---邀请码输入按钮


	-------我邀请好友
	self.count = self.panel2:getChildByName("Text_count")------已邀请好友数
	self.observerBtn = self.panel2:getChildByName("Button_observer")-----查看已邀请好友
	self.myCodeLb = self.panel2:getChildByName("TextField_myCode")---我的邀请码
	self.myCodeLb:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)


	self.observerBtn:addTouchEventListener(handler(self, self.onObserverBtnClickupCallback))

	self.myCodeLb:setEnabled(false)
	self.myCodeLb:setPlaceHolder("")

	--界面文本
	self.panel1:getChildByName("Text_1"):setString(res.str.ACTIVE_TEXT23)
	self.panel1:getChildByName("Text_2"):setString(res.str.ACTIVE_TEXT24)
	self.panel1:getChildByName("Text_3"):setString(res.str.ACTIVE_TEXT25)
	
	self.panelItem1:getChildByName("Text_21"):setString(res.str.ACTIVE_TEXT26)
	self.panelItem2:getChildByName("Text_21_24"):setString(res.str.ACTIVE_TEXT28)
	self.sendBtn:setTitleText(res.str.ACTIVE_TEXT27)

	self.panel2:getChildByName("Text_2_17_0"):setString(res.str.ACTIVE_TEXT29)
	self.observerBtn:setTitleText(res.str.ACTIVE_TEXT31)

	
	local desc = self.panel2:getChildByName("Text_3_20")
	desc:setString(res.str.ACTIVE_TEXT30)
	desc:ignoreContentAdaptWithSize(false)
	desc:setContentSize(380,100)
	desc:setPositionY(desc:getPositionY() - 30)

	print(g_language,LANGUAGE.CHINA_TW)

	if g_language == LANGUAGE.CHINA_TW then
		local lv_descLb = self.panel3:getChildByName("Text_3_20_8")
		lv_descLb:setString(res.str.ACTIVE_TEXT34)
		self.observerAwardBtn:setTitleText(res.str.ACTIVE_TEXT35)
	end
	
	proxy.Invatate:reqInvitationInfo()
	
end




----输入邀请码
function InvitationView:onSendBtnClickUpCallback( sender,eventType )
	-- body

	if eventType == ccui.TouchEventType.ended then
		local code = self.inputUI:getText()

		if string.trim(code) == "" then
			G_TipsOfstr(res.str.INVITATE_TIPS1)
			return
		elseif self.code == code then
			G_TipsOfstr(res.str.INVITATE_TIPS5)
			return
		end


		proxy.Invatate:invitate(code)
	end


end

function InvitationView:changeUI( code )
	-- body
	self.panelItem1:setVisible(false)
	self.panelItem2:setVisible(true)
	self.textLebel:setString(code)

end

--------查看已邀请好友
function InvitationView:onObserverBtnClickupCallback( sender,eventType )
	-- body

	if eventType == ccui.TouchEventType.ended then
		--todo
		--self:onHide()
		proxy.Invatate:invitatedFriend()
		--mgr.ViewMgr:showView(_viewname.INVITATEDFRIENDLIST)
	end


end


--请求邀请码信息返回
function InvitationView:reqInfoSucc( data )
	self.myCodeLb:setString(data["roleKey"])
	self.data = data
	self.code = data["roleKey"]
	if data["tarRoleKey"]  ~= "" then
		self:changeUI(data["tarRoleKey"])
	end
	if  g_language == LANGUAGE.CHINA_TW then--繁体
		self.lv_invitated:setString(string.format(res.str.ACTIVE_TEXT36, data["levCount"]))
	end
	

	self.count:setString(string.format(res.str.HSUI_DESC39, data["renCount"]))
end

--请求输入邀请码返回
function InvitationView:reqInvitateSucc( data)
	if data["tarRoleKey"]  ~= "" then
		self:changeUI(data["tarRoleKey"])
	end
end


function InvitationView:observerAwardCallback( sender,eventType )
	-- body
	if eventType == ccui.TouchEventType.ended then
		local view = mgr.ViewMgr:showView(_viewname.INVITATEAWARD)
		view:setData( self.data["levCount"], self.data["levSign"])
	end


end



--分享
function InvitationView:shareBtnCallback( sender,eventType )
	-- body
	if eventType == ccui.TouchEventType.ended then
		sdk:share()
		--请求分享
		proxy.Invatate:reqShare(310011)
		print("share")
	end
end

return InvitationView