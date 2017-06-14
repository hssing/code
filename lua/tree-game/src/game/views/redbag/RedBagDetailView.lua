--
-- Author: Your Name
-- Date: 2015-08-25 19:40:24
--
local RedBagDetailView = class("RedBagDetailView", base.BaseView)

function RedBagDetailView:init(  )
	-- body
	self.showtype = view_show_type.TOP
	self.view=self:addSelfView()
	self:setNodeEventEnabled(true)

	self.panel = self.view:getChildByName("Panel_1")
	self.listView = self.panel:getChildByName("ListView_1")

	self.clonePanel = self.view:getChildByName("Panel_clone")

	-- for i=1,10 do
	-- 	self.listView:pushBackCustomItem(self.clonePanel:clone())
	-- end
	self.facePanel = self.panel:getChildByName("Panel_face_3")
	self.iconFrame = self.facePanel:getChildByName("Button_face_10_2")--头像狂
	self.iconFace = self.facePanel:getChildByName("Image_face_15_6")--头像
	self.nameLab = self.facePanel:getChildByName("Text_name_11_2")--昵称
	self.vipIcon = self.facePanel:getChildByName("Image_vipright_19_8")--vip
	self.messageLab = self.panel:getChildByName("Text_14_4")--留言
	self.descLab =  self.panel:getChildByName("Text_7") --红包个数、总额
	self.zhuanShiIcon = self.panel:getChildByName("Image_27_10") --砖石
	--self:setData({})
	self.panel:setPosition(display.cx,display.cy)
	self.btnClose = self.panel:getChildByName("Button_close")
	self.btnClose:addTouchEventListener(handler(self,self.onCloseSelfView))

	self.awardTypeIcon = self.panel:getChildByName("Image_27_10")
end

function RedBagDetailView:onEnter(  )
	-- body
	--显示隐藏聊天 IOC
	local mainTopView = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	local mainView =  mgr.ViewMgr:get(_viewname.MAIN)
	if mainView and mainTopView and tolua.isnull(mainTopView.btnChat) == false then
		mainTopView.btnChat:setVisible(true)
	end
end


function RedBagDetailView:setData( data )
	--data = {}
	--data.items = data.awards
	local items =data.awards
	self.listView:removeAllItems()
	--dump(items)
	for i=1,#items do
		local item = self.clonePanel:clone()
		local iconFrame = item:getChildByName("Button_face_10_6")
		local faceIcon = item:getChildByName("Image_face_15_18")
		local nameLab = item:getChildByName("Text_10")
		local zsCount = item:getChildByName("Text_11")
		local luckpanel = item:getChildByName("Panel_7")
		local awardIcon = item:getChildByName("Image_27")

		--手气最佳
		if items[i]["flag"] == 2 then
			luckpanel:setVisible(true)
		else
			luckpanel:setVisible(false)
		end
		--钻石
		zsCount:setString(items[i]["moneyZs"])

		--奖励类型
		awardIcon:loadTexture(conf.Item:getExt03Icon(data.mId))
		if conf.Item:getExt03(data.mId) == 4 then
			awardIcon:setPosition(awardIcon:getPositionX(),awardIcon:getPositionY() + 5)
		end


		--昵称
		nameLab:setString(items[i]["roleName"])
		--头像
		--local path = items[i]["roleIcon"] == 1 and res.icon.ROLE_ICON.BOY or res.icon.ROLE_ICON.GRIL
		faceIcon:loadTexture(G_GetHeadIcon(items[i]["roleIcon"])) 

		iconFrame:addTouchEventListener(handler(self,self.viewPlayerInfo))
		iconFrame.roleId = items[i]["roleId"]
		self.listView:pushBackCustomItem(item)
	end


	--顶部信息
	--红包数，钻石数
	local num1 = conf.Item:getExt01(data.mId)
	local num2 = conf.Item:getExt02(data.mId)
	self.descLab:setString(string.format(res.str.HSUI_DESC28, num1,num2))
	local x = self.descLab:getPositionX() + self.descLab:getContentSize().width + self.zhuanShiIcon:getContentSize().width / 2
	self.zhuanShiIcon:setPosition(x ,self.zhuanShiIcon:getPositionY())
	--头像框
	self.iconFrame:addTouchEventListener(handler(self,self.viewPlayerInfo))
	self.iconFrame.roleId = data["roleId"]

	--头像
	--local path = data["vipIcon"] == 1 and res.icon.ROLE_ICON.BOY or res.icon.ROLE_ICON.GRIL
	self.iconFace:loadTexture(G_GetHeadIcon(data["vipIcon"]))
	self.nameLab:setString(data["roleName"])
	--vip
	local vip = data["vipLevel"]
	self.vipIcon:loadTexture(res.icon.VIP_LV[vip])

	--留言
	self.messageLab:setString(data["contentStr"])
	if self.messageLab:getContentSize().width > 180 then
		self.messageLab:ignoreContentAdaptWithSize(false)
		self.messageLab:setContentSize(180,60)
	end

	--奖励类型ICON
	self.awardTypeIcon:loadTexture(conf.Item:getExt03Icon(data.mId))
	if conf.Item:getExt03(data.mId) == 4 then
		self.awardTypeIcon:setPosition(self.awardTypeIcon:getPositionX(),self.awardTypeIcon:getPositionY() + 5)
	end
	
	self.messageLab:setPosition(self.panel:getContentSize().width / 2,self.messageLab:getPositionY())
end


function RedBagDetailView:viewPlayerInfo( send,eType )
	-- body
	if eType == ccui.TouchEventType.ended then
		--todo
		
		local id = cache.Player:getRoleId()
		if id["key"] == send.roleId["key"] then
			G_TipsOfstr(res.str.CHAT_TIPS7)
			return
		end
		proxy.Chat:reqFriendInfo(send.roleId)
		--self:closeSelfView()
	end
end

function RedBagDetailView:onCloseSelfView( send,etype)
	if etype == ccui.TouchEventType.ended then
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
end



return RedBagDetailView