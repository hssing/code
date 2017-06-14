--
-- Author: Your Name
-- Date: 2015-07-27 21:20:38
--

local FriendInfoView = class("FriendInfoView", base.BaseView)
local roleId

function FriendInfoView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.bgPanel = self.view:getChildByName("Panel_1")
	self.infoPanel = self.bgPanel:getChildByName("Panel_5")

	self.userStateLb = self.infoPanel:getChildByName("Text_state")
	self.faceFrame =  self.infoPanel:getChildByName("Button_frame")
	self.userLevelLb =  self.infoPanel:getChildByName("Text_lv")
	self.userPower =  self.infoPanel:getChildByName("Text_power")
	self.guildName = self.infoPanel:getChildByName("Text_1")
	self.nameLb = self.infoPanel:getChildByName("Text_name")
	self.vipIconImg =  self.infoPanel:getChildByName("Image_vip")
	self.imgFace = self.infoPanel:getChildByName("Image_face")
	self.imgguid = self.infoPanel:getChildByName("Image_2")
	--self.imgguid:setVisible(false)

	-- self.friendOperateBtn = self.bgPanel:getChildByName("Button_friend")
	-- self.emailBtn = self.bgPanel:getChildByName("Button_email")
	-- self.selfChatBtn = self.bgPanel:getChildByName("Button_selfChat")
	-- self.observeBtn = self.bgPanel:getChildByName("Button_observe")

	-- self.friendOperateBtn:addTouchEventListener(handler(self,self.onFriendOperateBtnClicked))
	-- self.emailBtn:addTouchEventListener(handler(self,self.onEmailBtnClicked))
	-- self.selfChatBtn:addTouchEventListener(handler(self,self.onSelfChatBtnClicked))
	-- self.observeBtn:addTouchEventListener(handler(self,self.onObserveBtnClicked))

	-- self.selfChatBtn:setTitleText(res.str.FRIEND_TEXT3)
	-- self.emailBtn:setTitleText(res.str.FRIEND_TEXT10)
	-- self.observeBtn:setTitleText(res.str.FRIEND_TEXT9)

	self.friendOperateBtn = self.bgPanel:getChildByName("Button_friend")
	local observeBtn = self.bgPanel:getChildByName("Button_observe")
	local fsxBtn = self.bgPanel:getChildByName("Button_fasixin")
	local selfChatBtn = self.bgPanel:getChildByName("Button_selfChat")
	--self.hmdBtn = self.bgPanel:getChildByName("Button_hmd")

	self.friendOperateBtn:addTouchEventListener(handler(self,self.onFriendOperateBtnClicked))
	selfChatBtn:addTouchEventListener(handler(self,self.onSelfChatBtnClicked))
	observeBtn:addTouchEventListener(handler(self,self.onObserveBtnClicked))
	fsxBtn:addTouchEventListener(handler(self,self.onFsxBtnClicked))
	--self.hmdBtn:addTouchEventListener(handler(self,self.onHmdBtnClicked))

	observeBtn:setTitleText(res.str.FRIEND_TEXT9)
	fsxBtn:setTitleText(res.str.FRIEND_TEXT10)
	selfChatBtn:setTitleText(res.str.FRIEND_TEXT3)

end

------设置查看玩家的Id
function FriendInfoView:setRoleID(id)
	-- body
	if id then
		--todo
		proxy.Chat:reqFriendInfo(id)
	end
	
end

--------跟新显示数据
function FriendInfoView:setData( data )
	printt(data)
	self.data = data
	if data.isOnline == 1 then
		self.userStateLb:setString(res.str.HSUI_DESC17)
	else
		self.userStateLb:setString(res.str.HSUI_DESC18)
	end

	if data.isFriend == 0 then
		self.friendOperateBtn:setTitleText(res.str.HSUI_DESC19)
	else
		self.friendOperateBtn:setTitleText(res.str.HSUI_DESC20)
	end

	self.userLevelLb:setString(data.roleLevel .. "")
	self.userPower:setString(data.power .. "")
	--self.guildName:setString(data.guildName)
	self.vipIconImg:loadTexture(res.icon.VIP_LV[data.vipLevel])
	self.faceFrame:loadTextureNormal(G_getChatPlayerFrameIcon(data.power))
	self.nameLb:setString(data.roleName)
	self.nameLb:setFontName(display.DEFAULT_TTF_FONT)
	self.nameLb:setFontSize(display.DEFAULT_TTF_FONT_SIZE)
	--local path = data["vipIcon"] == 1 and res.icon.ROLE_ICON.BOY or res.icon.ROLE_ICON.GRIL
	--self.imgFace:loadTexture(path)
	self.imgFace:loadTexture(G_GetHeadIcon(data["vipIcon"]))

	if data.guildName == nil or data.guildName == "" then
		self.guildName:setString(res.str.HSUI_DESC38)
	else
		self.guildName:setString(data.guildName)
	end
	self.guildName:setFontName(display.DEFAULT_TTF_FONT)
	self.guildName:setFontSize(display.DEFAULT_TTF_FONT_SIZE)
	roleId = data.roleId



end

function FriendInfoView:onFriendOperateBtnClicked( index,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then

		---天加好友
		if self.data["isFriend"] == 0 then
			--todo
			proxy.friend:reqInvitationFriend(self.data["roleId"])
			return
		end
		local data = {}
		data.cancel = self.cancelClicked
		data.sure = self.sureClicked
		data.cancelstr = res.str.HSUI_DESC21
		data.surestr = res.str.HSUI_DESC12

		--dump(self.data)

		local r1 = ccui.RichElementText:create(1,cc.c3b(255,255,255),255,res.str.FRIEND_TEXT18,res.ttf[1],24)
		local r2 = ccui.RichElementText:create(1,cc.c3b(255,192,0),255,self.data["roleName"],res.ttf[1],24)
		local r3 = ccui.RichElementText:create(1,cc.c3b(255,255,255),255,res.str.FRIEND_TEXT19,res.ttf[1],24)


		data.richtext = {}
		data.richtext[1] =  r1
		data.richtext[2] =  r2
		data.richtext[3] =  r3
		--self:onHide()
		self:closeSelfView()
		mgr.ViewMgr:showTipsView("tips.ConfirmView"):setData(data,true)

	end
end

------取消删除
function FriendInfoView:cancelClicked( sender,eType )
	-- body
end

--确定删除
function FriendInfoView:sureClicked(   )
	proxy.friend:reqDelFriend(roleId)
end

-----私聊
function FriendInfoView:onSelfChatBtnClicked( index,eventype )
	if eventype == ccui.TouchEventType.ended then
		local  view = mgr.ViewMgr:get(_viewname.CHATTING)
		local roleName = self.data["roleName"]
		if view then
			view:setSelfChatPlayerInfo(roleName)
			mgr.ViewMgr:showView(_viewname.CHATTING)
			self:closeRedbagView()
			self:closeSelfView()
			return
		end
		self:closeRedbagView()
		self:closeSelfView()
		mgr.SceneMgr:getMainScene():changeView(16):setSelfChatPlayerInfo(roleName)
	end
end

------查看阵容
function FriendInfoView:onObserveBtnClicked( index,eventype )
	if eventype == ccui.TouchEventType.ended then
		local roleId = cache.Player:getRoleId()
        local param = {tarAId =  roleId, tarBId =  self.data["roleId"] }
		proxy.Contest:sendCompare(param)
		mgr.NetMgr:wait(501201)
    end
end

----发私信
function FriendInfoView:onFsxBtnClicked( index,eventype )
	if eventype == ccui.TouchEventType.ended then
		local sxView = mgr.ViewMgr:showView(_viewname.PRIVATEEMAIL)
		sxView:setTargetRid(self.data.roleId,self.data.roleName)
		
		self:closeRedbagView()
		self:closeSelfView()
		
		-- mgr.SceneMgr:getMainScene():changeView(10)
	end
end

----黑名单
-- function FriendInfoView:onHmdBtnClicked( index,eventype )
-- 	if eventype == ccui.TouchEventType.ended then
		
-- 	end
-- end


function FriendInfoView:comPareCalllBack( data_ )
	cache.Friend:setOnlyClose(true)
	local view = mgr.ViewMgr:createView(_viewname.ATHLETICS_COMPARE)
	local data = {}

	--右边
	local data1 = {}
	data1.tarName = data_.tarBName
	data1.tarLvl = data_.tarBLvl
	data1.tarPower = data_.tarBPower
	data1.tarCards = data_.tarBCards
	data1.huoban = data_.tarBXhbs
	local roleName = cache.Player:getName()
	if data1.tarName == roleName then 
		data1.roleId = cache.Player:getRoleId()
	else
		data1.roleId =  self.data["roleId"]
	end 


	--左边
	local data = {}
	data.tarName = data_.tarAName
	data.tarLvl = data_.tarALvl
	data.tarPower = data_.tarAPower
	data.tarCards = data_.tarACards
	data.huoban = data_.tarAXhbs

	if data.tarName == self.data["roleName"] then 
		data.roleId = self.data["roleId"]
	else
		data.roleId = cache.Player:getRoleId()
	end 

	view:setData(data1,data)
	cache.Friend:setOnlyClose(false)
	cache.Friend:jumpToAthleticComp(true)
	mgr.ViewMgr:showView(_viewname.ATHLETICS_COMPARE)
	self:closeRedbagView()
	self:closeSelfView()
	
end

function FriendInfoView:closeRedbagView(  )
	local view = mgr.ViewMgr:get(_viewname.REDBAG_DETAIL)
	if view then
		view:closeSelfView()
	end

	local view = mgr.ViewMgr:get(_viewname.RECEIVE_REDBAG)
	if view then
		view:closeSelfView()
	end
end




return FriendInfoView