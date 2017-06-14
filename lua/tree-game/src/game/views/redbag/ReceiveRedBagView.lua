--
-- Author: Your Name
-- Date: 2015-08-25 19:43:13
--
local ReceiveRedBagView = class("ReceiveRedBagView", base.BaseView)

function ReceiveRedBagView:init(  )
	-- body
	self.showtype = view_show_type.TOP
	self.view=self:addSelfView()
	self:setNodeEventEnabled(true)

	self.panel = self.view:getChildByName("Panel_1")
	self.bntLoockOut = self.panel:getChildByName("Button_12")---查看红包按钮
	self.bntLoockOut:addTouchEventListener(handler(self,self.bntLoockOutCallback))
	self.panel:setPosition(display.cx,display.cy)

	self.btnClose = self.panel:getChildByName("Button_close")
	self.btnClose:addTouchEventListener(handler(self,self.onCloseSelfView))
	self.awardTypeIcon = self.panel:getChildByName("Image_27")
	self.checkBox = self.panel:getChildByName("CheckBox_1")

	self.checkBox:setSelected(not cache.Player:getShowRedbag())
	self.checkBox:addEventListener(handler(self, self.checkBoxCallback))


	--界面文本
	self.panel:getChildByName("Text_1"):setString(res.str.REDBAG_TEXT1)
	self.bntLoockOut:setTitleText(res.str.REDBAG_TEXT2)
	self.panel:getChildByName("Text_18"):setString(res.str.REDBAG_TEXT5)

end

function ReceiveRedBagView:onEnter(  )
	-- body
	--显示隐藏聊天 IOC
	local mainTopView = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	local mainView =  mgr.ViewMgr:get(_viewname.MAIN)
	if mainView and mainTopView and tolua.isnull(mainTopView.btnChat) == false then
		mainTopView.btnChat:setVisible(true)
	end
end


function ReceiveRedBagView:setData( data )
	--玩家信息
	self.data = data
	local facePanel = self.panel:getChildByName("Panel_face")
	local iconFrame = facePanel:getChildByName("Button_face_10")
	local iconFace = facePanel:getChildByName("Image_face_15")
	local nameLab = facePanel:getChildByName("Text_name_11")
	local vipIcon = facePanel:getChildByName("Image_vipright_19")
	local messageLab = self.panel:getChildByName("Text_14")
	local descLab =  self.panel:getChildByName("Text_15")

	messageLab:setString(data.contentStr)
	descLab:setString(data.moneyZs)

	if messageLab:getContentSize().width > 180 then
		messageLab:ignoreContentAdaptWithSize(false)
		messageLab:setContentSize(180,60)
	end
	
	messageLab:setPosition(self.panel:getContentSize().width / 2,messageLab:getPositionY())

	--vip
	local vip = data["vipLevel"]
	vipIcon:loadTexture(res.icon.VIP_LV[vip])

	--头像
	--local path = data["vipIcon"] == 1 and res.icon.ROLE_ICON.BOY or res.icon.ROLE_ICON.GRIL
	iconFace:loadTexture(G_GetHeadIcon(data["vipIcon"]))
	
	--昵称
	nameLab:setString(data["roleName"])

	iconFrame:addTouchEventListener(handler(self,self.viewPlayerInfo))
	iconFrame.roleId = data["roleId"]

	--奖励类型ICON
	self.awardTypeIcon:loadTexture(conf.Item:getExt03Icon(data.mId))
	if conf.Item:getExt03(data.mId) == 4 then
		self.awardTypeIcon:setPosition(self.awardTypeIcon:getPositionX(),self.awardTypeIcon:getPositionY() + 7)
	end
end

--查看玩家信息
function ReceiveRedBagView:viewPlayerInfo( send,eType )
	-- body
	if eType == ccui.TouchEventType.ended then
		--todo
		--mgr.ViewMgr:showView(_viewname.FRIENDINFO):setRoleID(send.roleId)
		local id = cache.Player:getRoleId()
		if id["key"] == send.roleId["key"] then
			G_TipsOfstr(res.str.CHAT_TIPS7)
			return
		end
		proxy.Chat:reqFriendInfo(send.roleId)
		--self:closeSelfView()
	end
end


---查看红包回调
function ReceiveRedBagView:bntLoockOutCallback( sender,eType )
	-- body
	if eType == ccui.TouchEventType.ended then
		--todo
		
		local view = mgr.ViewMgr:showView(_viewname.REDBAG_DETAIL,8)
		view:setData(self.data)
		self:closeSelfView()
	end
end


function ReceiveRedBagView:onCloseSelfView(  )
	self:closeSelfView()
	local chatView =  mgr.ViewMgr:get(_viewname.CHATTING)
	--如果聊天界面在显示中
	if chatView then
		--显示红包
		local view =  mgr.ViewMgr:get(_viewname.HORNTIPS)
		if view then
			view:setRedBagVisible(false)
		end
	else
		--显示隐藏聊天 IOC
		local mainTopView = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
		local mainView =  mgr.ViewMgr:get(_viewname.MAIN)
		if mainView and mainTopView and tolua.isnull(mainTopView.btnChat) == false then
			mainTopView.btnChat:setVisible(true)
		end
	end
end


function ReceiveRedBagView:onCloseSelfView( send,etype )
	if etype == ccui.TouchEventType.ended then
		mgr.ViewMgr:closeView(_viewname.RECEIVE_REDBAG)
	end
end


function ReceiveRedBagView:checkBoxCallback(sender,eventtype  )
	local key = g_var.debug_accountId .. "_" ..user_default_keys.REDBAG_SHOW
	if eventtype == ccui.CheckBoxEventType.selected then--选中
		local data = os.time() .. ""
		cache.Player:setShowRedBag(data)
		MyUserDefault.setStringForKey(key,data)
	else
		cache.Player:setShowRedBag("")
		MyUserDefault.setStringForKey(key,"")
	end 
end




return ReceiveRedBagView