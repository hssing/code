--
-- Author: Your Name
-- Date: 2015-07-28 11:14:01
--
local ChattingView = class("ChattingView", base.BaseView)
local MsgClass =require("game.views.friends.MessageItem")
function ChattingView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self:setNodeEventEnabled(true)

	self.maxItemNum = 20
	self.textCountMax = 25
	self.facialCountMax = 3
	self.WorldChanelLimiteLV = 15 
	self.isShow = true
	self.isFacialPanelShow = false------表情面板是否展现
	self.autoScroll = true -------聊天消息是否自动滚动到底部


	self.ListGUIButton={}  --GUI按钮容器
	local size=4
	self.btn_panle = self.view:getChildByName("Panel_header")
	self.view:reorderChild(self.btn_panle,200)
	for i=1,size do
		local btn=self.btn_panle:getChildByTag(i+100)
		local gui_btn=gui.GUIButton.new(btn,nil,{ImagePath=res.image.RED_PONT,x=10,y=10})

		gui_btn:getInstance():setPressedActionEnabled(false)--guibutton默认点击会缩放，设置点击不需要缩放

		self.ListGUIButton[#self.ListGUIButton+1]=gui_btn
	end

	self.PageButton=gui.PageButton.new()--创建分页按钮管理器
	self.PageButton:setBtnCallBack(handler(self,self.onPageButtonCallBack))
	for i=1,#self.ListGUIButton do
		self.PageButton:addButton(self.ListGUIButton[i]:getInstance())
	end

	self.listView1 = self.view:getChildByName("Panel_5"):getChildByName("ListView")
	self.listView2 = self.view:getChildByName("Panel_5"):getChildByName("ListView2")
	self.listView = self.listView1
	self.listView1:addTouchEventListener(handler(self,self.listViewHandler))
	self.listView2:addTouchEventListener(handler(self,self.listViewHandler))


	self.inputPanel = self.view:getChildByName("Panel_input")
	local inputField = self.inputPanel:getChildByName("Panel_7"):getChildByName("TextField_input")
	self.btnSend = self.inputPanel:getChildByName("Button_send")
	self.btnFace = self.inputPanel:getChildByName("Button_addFace")


	self.facePanel = self.view:getChildByName("Panel_face")
	self.messagePanel = self.view:getChildByName("message")
	self.qipao = self.view:getChildByName("Image_qipao")

	--对谁说标签面板
	self.chat = self.view:getChildByName("chat")
	self.chatObjPanel = self.view:getChildByName("Panel_chatObj")

	-----对谁说输入面板
	self.inputChatObjPanel =self.inputPanel:getChildByName("Panel_inputChatObj")
	self.nameLabel = self.inputChatObjPanel:getChildByName("Text_12")
	-------输入框事件监听
	self.inputNameBox=cc.ui.UIInput.new({
		 	UIInputType == 2,
		    image = res.image.TRANSPARENT,
		    x = self.nameLabel:getPositionX(),
		    y = self.nameLabel:getPositionY(),
		   -- listener = self.editBoxHandler,
		    size = cc.size(self.nameLabel:getContentSize().width,self.nameLabel:getContentSize().height)
		})
	self.inputNameBox:registerScriptEditBoxHandler(handler(self, self.editBoxHandler))
	self.inputNameBox:setFontName(display.DEFAULT_TTF_FONT)
	self.inputNameBox:setFontSize(self.nameLabel:getFontSize())
	self.inputNameBox:setMaxLength(5)
	self.inputChatObjPanel:addChild(self.inputNameBox)


	--红包面版容器
	self.redBagClonePan = self.view:getChildByName("Panel_redBag")
	self.messageTxt = self.redBagClonePan:getChildByName("Text_1_3")
	self.messageTxt:ignoreContentAdaptWithSize(false)
	self.messageTxt:setContentSize(200,200)
	self.messageTxt:setPosition(88,-18)

	--称号面板容器
	self.titlePanel = self.view:getChildByName("Panel_title")


	self.chatRecodList = {}---------保存聊天记录
	self.chatData = {}
	self.chatData[1] = {}-------世界
	self.chatData[2] = {}-------公会
	self.chatData[3] = {}-------私聊
	self.chatData[4] = {}-------全部



	-------输入框事件监听
	self.messageLb=cc.ui.UIInput.new({
		 UIInputType == 2,
		    image = res.image.TRANSPARENT,
		    x = inputField:getPositionX(),
		    y = inputField:getPositionY(),
		    --listener = self.editBoxHandler,
		    size = cc.size(inputField:getContentSize().width,inputField:getContentSize().height )
		})

	--print(inputField:getFontName().."========================")
	self.messageLb:setFontName(inputField:getFontName())
	self.messageLb:setFontSize(28)
	inputField:removeFromParent()
	self.inputPanel:getChildByName("Panel_7"):addChild(self.messageLb)
	--self.messageLb:setPlaceHolder("点击输入文字")
	self.messageLb:setFontSize(28)

	self.messageLb:registerScriptEditBoxHandler(self.msgEditBoxHandler)
	self.btnFace:addTouchEventListener(handler(self,self.selectFacial))
	self.btnSend:addTouchEventListener(handler(self,self.sendMessage))

	self.selectedIdx = 1


	---文字初始化
	self.ListGUIButton[1]:getInstance():setTitleText(res.str.FRIEND_TEXT1)
	self.ListGUIButton[2]:getInstance():setTitleText(res.str.FRIEND_TEXT2)
	self.ListGUIButton[3]:getInstance():setTitleText(res.str.FRIEND_TEXT3)
	self.ListGUIButton[4]:getInstance():setTitleText(res.str.FRIEND_TEXT4)
	
	self.inputChatObjPanel:getChildByName("Text_11"):setString(res.str.FRIEND_TEXT5)
	self.inputChatObjPanel:getChildByName("Text_13"):setString(res.str.FRIEND_TEXT6)

	self.btnSend:setTitleText(res.str.FRIEND_TEXT7)
	self.chatObjPanel:getChildByName("Text_1"):setString(res.str.FRIEND_TEXT8)
	self.chatObjPanel:getChildByName("Text_3"):setString(res.str.FRIEND_TEXT6)

	self.chatData = cache.Chat:readData()
	self.PageButton:initClick(1)

	self:test()

end

function ChattingView:onEnter(  )
	-- body
	local view = mgr.ViewMgr:get(_viewname.HORNTIPS)
	if view then
		view:setRedBagVisible(false)
	end
end

function ChattingView:onExit(  )
	-- body
	local view = mgr.ViewMgr:get(_viewname.HORNTIPS)
	if view then
		view:setRedBagVisible(true)
	end
end


function ChattingView:EnterChattingView( )
	-- body
	self:setIsShow(true)
	-------读取聊天记录
	self.chatData = cache.Chat:readData()
	if self.selectedIdx ~= 1 then
		--todo
		self.PageButton:initClick(1)
	else
		self:onPageButtonCallBack( 1,ccui.TouchEventType.ended )
	end
	
end

function ChattingView:msgEditBoxHandler( strEventName,inputBox )
	-- body
	if strEventName == "began" then
       --self.messageLb:setText(self.inputField:getString())
    elseif strEventName == "changed" then
        -- 输入框内容发生变化
    elseif strEventName == "ended" then
        -- 输入结束
    elseif strEventName == "return" then
        -- 从输入框返回
       -- self.inputField:setString(self.messageLb:getText())
       -- self.messageLb:setText("")

    end


end



function ChattingView:editBoxHandler(strEventName,inputBox )
	-- body
	if strEventName == "began" then
       self.inputNameBox:setText(self.nameLabel:getString())
    elseif strEventName == "changed" then
        -- 输入框内容发生变化
    elseif strEventName == "ended" then
        -- 输入结束
    elseif strEventName == "return" then
        -- 从输入框返回
        self.nameLabel:setString(self.inputNameBox:getText())
        self.inputNameBox:setText("")

    end

	
end

function ChattingView:listViewHandler(sender,eType )
	-- body
	if eType == ccui.TouchEventType.moved then
		local layout = sender:getInnerContainer()
		local x,y = layout:getPosition()
		if y <= -100 then
			self.autoScroll = false
		else
			self.autoScroll = true
		end

	end
end




---将聊天信息添加到面板
function ChattingView:addItem(data)
	-- body
	--自己
	--data.titleId = 302001
	local item = self.messagePanel:clone()
	local facePanel = self.facePanel:clone()

	 item:setTouchEnabled(false)
	 item:setAnchorPoint(cc.p(0,0))
	 item:setPosition(cc.p(0,0))

	local qipao = self.qipao:clone()
	qipao:setName("qipao")
	local msg = MsgClass.new()
	msg:initWithStr(data.contentStr,200,100,60)

	qipao:setContentSize(msg:getContentSize().width + 70,msg:getContentSize().height + 40)
	qipao:addChild(msg)

	----设置item大小
	if qipao:getContentSize().height > facePanel:getContentSize().height + 20 then
		--todo
		--加上气泡的偏移量
		item:setContentSize(640,qipao:getContentSize().height + 50)
	else
		item:setContentSize(640,facePanel:getContentSize().height + 20)
	end
	item:addChild(qipao)

	local vipIconLeft = facePanel:getChildByName("Image_vipleft")
	local vipIconRight = facePanel:getChildByName("Image_vipright")
	vipIconLeft:setVisible(false)
	vipIconRight:setVisible(false)

	local temp = G_Split_Back(data["userInfo"]["roleIcon"])
	local IconFrame = facePanel:getChildByName("Button_face")
	local IconImg = facePanel:getChildByName("Image_face")
	local nameLabel = facePanel:getChildByName("Text_name")

	if IconFrame:getChildByName("vip") then 
		IconFrame:getChildByName("dw"):removeSelf()
	end

	local vip = data["userInfo"]["vipLevel"]
	if vip > 1 then 
		local spr = display.newSprite(res.icon.VIP_LV[vip])
		spr:setName("vip")
		spr:setPosition(temp.vip_pos)
		spr:addTo(IconFrame)
	end

	if IconFrame:getChildByName("dw") then 
		IconFrame:getChildByName("dw"):removeSelf()
	end
	if temp.dw > temp.min_dw then 
		local spr = display.newSprite(res.icon.DW_ICON[temp.dw])
		spr:setName("dw")
		spr:setPosition(temp.dw_pos)
		spr:addTo(IconFrame)
	end

	-------头像数据
	
	nameLabel:setString(data["userInfo"]["roleName"])---玩家名称
	nameLabel:setFontName(display.DEFAULT_TTF_FONT)
	nameLabel:setFontSize(20)
	--local path = G_getChatPlayerFrameIcon(data["userInfo"]["power"])
	IconFrame:loadTextureNormal(temp.frame_img)
	--local path = data["userInfo"]["roleIcon"] == 1 and res.icon.ROLE_ICON.BOY or res.icon.ROLE_ICON.GRIL
	IconImg:loadTexture(temp.icon_img)
	item:setName("item")
	
	--------玩家信息
	if data.userInfo["roleName"] and data.userInfo["roleName"] == cache.Player:getName() then
		 ----添加头像(玩家自己)
		msg:setPosition(msg:getContentSize().width/2 + 60,qipao:getContentSize().height/2 + 10)
		
		qipao:setFlippedX(true)
		msg:setFlippedX(true)
		facePanel:setPosition(item:getContentSize().width-facePanel:getContentSize().width/2-80,item:getContentSize().height-facePanel:getContentSize().height - 10)
		item:addChild(facePanel)
		local x = facePanel:getPositionX() - qipao:getContentSize().width/2
		local y = facePanel:getPositionY() - qipao:getContentSize().height/2 + 50 + facePanel:getContentSize().height / 2
		local pos = cc.p(x,y)
		qipao:setPosition(pos)
		

		if self.selectedIdx == 3 then
			--todo
			----------对谁说
			local objPanle = self.chatObjPanel:clone()
			local objName = objPanle:getChildByName("Text_objName")
			objName:setString(data["userInfo"]["toUser"])
			objName:setFontName(display.DEFAULT_TTF_FONT)
			objName:setFontSize(20)
			item:addChild(objPanle)
			objPanle:setPosition(facePanel:getPositionX() -objPanle:getContentSize().width - 20 ,item:getContentSize().height - 40)
		end

		--称号
		if self.selectedIdx ~=3 and data.titleId and data.titleId ~= 0  then
			local title = self.titlePanel:clone()
			item:addChild(title)
			title:setPosition(facePanel:getPositionX() - title:getContentSize().width + 25,facePanel:getPositionY() + 125)
			local titleIcon = title:getChildByName("Image_2")
			titleIcon:loadTexture(conf.Title:getIcon(data.titleId))

		end
		
		---头像按钮
		local btn = facePanel:getChildByName("Button_face")
		btn:addTouchEventListener(handler(self,function(  )
			G_TipsOfstr(res.str.CHAT_TIPS7)
		end))


	else------好友信息
		msg:setPosition(msg:getContentSize().width/2 + 30,qipao:getContentSize().height/2 + 10)

		facePanel:setPosition(10,item:getContentSize().height-facePanel:getContentSize().height - 10)
		item:addChild(facePanel)
		local x = facePanel:getPositionX() + facePanel:getContentSize().width + qipao:getContentSize().width/2 - 10
		local y = facePanel:getPositionY() - qipao:getContentSize().height/2 + 50 + facePanel:getContentSize().height / 2
		local pos = cc.p(x,y)
		qipao:setPosition(pos)

		--[[vipIconRight:setVisible(false)
		local vip = data["userInfo"]["vipLevel"]
		if vip <= 1 then
			vipIconLeft:setVisible(false)

		else
			vipIconLeft:loadTexture(res.icon.VIP_LV[vip])
		end]]--

		---头像按钮
		local btn = facePanel:getChildByName("Button_face")
		btn.roleId = data["userInfo"]["roleId"]
		btn:addTouchEventListener(handler(self,self.onItemFaceBtnClickUp))

		if data.titleId and data.titleId ~= 0  then
			--称号
			local title = self.titlePanel:clone()
			item:addChild(title)
			title:setPosition(facePanel:getPositionX() + facePanel:getContentSize().width -35,facePanel:getPositionY() + 125)
			local titleIcon = title:getChildByName("Image_2")
			titleIcon:loadTexture(conf.Title:getIcon(data.titleId))
		end
		

	end
	return item
end

--------红包消息
function ChattingView:addRedBagItem( data )
	--dump(data)
	--data.titleId = 302001
	local redBag = self.redBagClonePan:clone()
	local item = self.messagePanel:clone()
	local facePanel = self.facePanel:clone()
	--dump(cache.Player:getRoleId())
	local roleId = cache.Player:getRoleId()
	item:addChild(redBag)

	local vipIconLeft = facePanel:getChildByName("Image_vipleft")
	local vipIconRight = facePanel:getChildByName("Image_vipright")
	vipIconRight:setVisible(false)
	vipIconLeft:setVisible(false)

	if data.userInfo.roleId["key"] == roleId["key"] then--自己发的红包
		facePanel:setPosition(item:getContentSize().width-facePanel:getContentSize().width/2-80,item:getContentSize().height-facePanel:getContentSize().height - 10)
		local x = facePanel:getPositionX() - redBag:getContentSize().width - 10
		local y = facePanel:getPositionY() + facePanel:getContentSize().height / 2 - redBag:getContentSize().height / 2
		redBag:setPosition(x,y)

		--[[vipIconLeft:setVisible(false)

		local vip = data["userInfo"]["vipLevel"]
		if vip <= 1 then
			vipIconRight:setVisible(false)

		else
			vipIconRight:loadTexture(res.icon.VIP_LV[vip])
		end]]--


		---头像按钮
		local btn = facePanel:getChildByName("Button_face")
		btn:addTouchEventListener(handler(self,function(  )
			G_TipsOfstr(res.str.CHAT_TIPS7)
		end))


		--称号
		if self.selectedIdx ~=3 and data.titleId and data.titleId ~= 0 then
			local title = self.titlePanel:clone()
			item:addChild(title)
			title:setPosition(facePanel:getPositionX() - title:getContentSize().width + 25,facePanel:getPositionY() + 125)
			local titleIcon = title:getChildByName("Image_2")
			titleIcon:loadTexture(conf.Title:getIcon(data.titleId))

		end

	else--别人发的红包
		facePanel:setPosition(10,10)
		local x = facePanel:getPositionX() + facePanel:getContentSize().width
		local y = facePanel:getPositionY() + facePanel:getContentSize().height / 2 - redBag:getContentSize().height / 2
		redBag:setPosition(x,y)

		--[[vipIconRight:setVisible(false)
		local vip = data["userInfo"]["vipLevel"]
		if vip <= 1 then
			vipIconLeft:setVisible(false)

		else
			vipIconLeft:loadTexture(res.icon.VIP_LV[vip])
		end]]--

		---头像按钮
		local btn = facePanel:getChildByName("Button_face")
		btn.roleId = data["userInfo"]["roleId"]
		btn:addTouchEventListener(handler(self,self.onItemFaceBtnClickUp))

		if  data.titleId and data.titleId ~= 0 then
			--称号
			local title = self.titlePanel:clone()
			item:addChild(title)
			title:setPosition(facePanel:getPositionX() + facePanel:getContentSize().width -35,facePanel:getPositionY() + 125)
			local titleIcon = title:getChildByName("Image_2")
			titleIcon:loadTexture(conf.Title:getIcon(data.titleId))
		end
		
	end

	item:addChild(facePanel)
	item:setContentSize(640,facePanel:getContentSize().height + 20)
	redBag.hbId = data.hbId
	redBag:addTouchEventListener(handler(self,self.onGetRedBagCallback))

	-------头像数据
		local IconFrame = facePanel:getChildByName("Button_face")
		local IconImg = facePanel:getChildByName("Image_face")
		local nameLabel = facePanel:getChildByName("Text_name")
		nameLabel:setString(data["userInfo"]["roleName"])---玩家名称
		nameLabel:setFontName(display.DEFAULT_TTF_FONT)
		nameLabel:setFontSize(display.DEFAULT_TTF_FONT_SIZE)

		local temp =  G_Split_Back(data["userInfo"]["roleIcon"])

		if IconFrame:getChildByName("dw") then 
			IconFrame:getChildByName("dw"):removeSelf()
		end
		if temp.dw > temp.min_dw then 
			local spr = display.newSprite(res.icon.DW_ICON[temp.dw])
			spr:setName("dw")
			spr:setPosition(temp.dw_pos)
			spr:addTo(IconFrame)
		end

		if IconFrame:getChildByName("vip") then 
			IconFrame:getChildByName("vip"):removeSelf()
		end
		if temp.vip > 1 then 
			local spr = display.newSprite(res.icon.VIP_LV[temp.vip])
			spr:setName("vip")
			spr:setPosition(temp.vip_pos)
			spr:addTo(IconFrame)
		end



		IconImg:loadTexture(temp.icon_img)
		--[[local path = G_getChatPlayerFrameIcon(data["userInfo"]["power"])
		IconFrame:loadTextureNormal(path)
		--local path = data["userInfo"]["roleIcon"] == 1 and res.icon.ROLE_ICON.BOY or res.icon.ROLE_ICON.GRIL
		IconImg:loadTexture(G_GetHeadIcon(data["userInfo"]["roleIcon"]))
		--IconImg:loadTexture(path)]]--

		--红包留言信息
		local desc = redBag:getChildByName("Text_1_3")
		desc:setString(data.contentStr)
		desc:ignoreContentAdaptWithSize(false)
		desc:setContentSize(200,200)
		desc:setPosition(88,-23)

		item:setName("item")

	return item

end


-------新增消息，更新listView显示
function ChattingView:updateListView( item )
	-- body
		local len = #self.listView:getItems()
		self.listView:insertCustomItem (item,len)

		self:stopAllActions()
		local delay = cc.DelayTime:create(0.1)
		local delay2 = cc.DelayTime:create(1)
		local func = cc.CallFunc:create(function(  )
			-- body
			if self.autoScroll == true then
				self.listView:scrollToBottom(0.5,true)
			end

		end)

		local func2 = cc.CallFunc:create(function(  )
			-- body
			local len = #self.listView:getItems()
			if len > self.maxItemNum then
				self.listView:removeItem(0)
			end
		end)

		local seq = cc.Sequence:create({delay,func,delay2,func2})
		self:runAction(seq)

end

function ChattingView:scrollUp(  )
	-- body
	self:stopAllActions()
		local delay = cc.DelayTime:create(0.2)
		local func = cc.CallFunc:create(function( ... )
			-- body
			self.listView:scrollToBottom(0.5,true)
		end)

		local seq = cc.Sequence:create({delay,func})
		self:runAction(seq)
end

--------计算字符串中表情的数量
function ChattingView:calculateEmotionNum( msg )
	-- body
	local i = 0
	local j = 0
	local imgNum = 0
	repeat
		i,j = string.find(msg,"%[%d%d%]",j+1)

		if i and j then
			imgNum = imgNum + 1
		else
			break
		end

	until false

		return imgNum
	
end

-------设置私聊对象信息名字
function ChattingView:setSelfChatPlayerInfo( data )
	-- body
	self:setIsShow(true)
	self.autoScroll = true----自动滚动
	self.nameLabel:setString(data)
	-------读取聊天记录
	self.chatData = cache.Chat:readData()

	if self.selectedIdx ~= 3 then
		--todo
		self.PageButton:initClick(3)
	end
	

end


function ChattingView:createMsg(  )
	-- body
	local msg = {}
		msg.contentStr = self.messageLb:getText()
		msg.guildId = 0

		if self.selectedIdx == 3 then-----------私聊
			msg.roleName = self.nameLabel:getString() --cache.Player:getName()
			print(msg.roleName)
		elseif self.selectedIdx == 2 then-------公会
			msg.guildId = cache.Player:getGuildId()
		elseif self.selectedIdx == 1 or  self.selectedIdx == 4 then ------世界
			msg.roleName = ""
		end

		return msg

end


------顶部分页按钮
function ChattingView:onPageButtonCallBack( index,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then

		self.autoScroll = true-----默认可以在自动滚动

	----------如果表情面板显示，则关闭
		if self.isFacialPanelShow and self.isFacialPanelShow == true then
			mgr.ViewMgr:closeView(_viewname.FACIALS)
			self.isFacialPanelShow = false
		end 

		self.listView:removeAllItems()
		self.selectedIdx = index
		----添加消息记录

		--切换listView
		self.listView:setVisible(false)
		if index == 3 then
			self.listView = self.listView1
		else
			self.listView = self.listView2
		end
		self.listView:setVisible(true)

		local data = self.chatData[index]
		for i=1,#data do
			--local item = self:addItem(data[i])
			local item

			if data[i].msgType == "text" or  data[i].msgType == "horn" then
				item = self:addItem(data[i])
			else
				item = self:addRedBagItem(data[i])
			end
			self:updateListView(item)
		end

		if index == 3 then
			self.inputChatObjPanel:setVisible(true)
		else 
			self.inputChatObjPanel:setVisible(false)
		end

		self:receiveMsg()



		return self
	end
end

---------发送消息
function ChattingView:sendMessage( sender,etype)
	-- body
	if etype == ccui.TouchEventType.ended then
		--todo
		----------关闭表情面板
		local view = mgr.ViewMgr:get(_viewname.FACIALS)
		if view then
			mgr.ViewMgr:closeView(_viewname.FACIALS)
			self.isFacialPanelShow = false
		end

		-- if 1==1 then
		-- 	return
		-- end

		-----世界频道，检查玩家等级限制
		if self.selectedIdx == 1 or self.selectedIdx == 4 then
			local lv = cache.Player:getLevel()
			if lv < res.kai.chat_world then
				G_TipsOfstr(string.format(res.str.FRIEND_TIPS15,res.kai.chat_world ))
				return
			end
		elseif self.selectedIdx == 2 then
			local gId = cache.Player:getGuildId()
			--dump(gId)
			if gId == nil then
				G_TipsOfstr(res.str.CHAT_TIPS8)
				return

			elseif gId["key"] == "0_0" then
				G_TipsOfstr(res.str.CHAT_TIPS8)
				return
			end

		end

		if self.selectedIdx == 3 then
			local len = string.utf8len(self.nameLabel:getString())
			if len > 5 then
				G_TipsOfstr(res.str.CHAT_TIPS9)
				return
			elseif string.len(string.trim(self.nameLabel:getString())) == 0 then
				G_TipsOfstr(res.str.CHAT_TIPS1)
				return
			end

		end

		-------计算表情数、文字数目
		local emotionNum = self:calculateEmotionNum(self.messageLb:getText())
		local textFontNum = string.utf8len(self.messageLb:getText()) - emotionNum * string.utf8len("[00]")

		if string.len(self.messageLb:getText()) == 0 then
			G_TipsOfstr(res.str.CHAT_TIPS10)
			return
		elseif textFontNum > self.textCountMax - emotionNum * 4 then
			--todo

			G_TipsOfstr(string.format(res.str.CHAT_TIPS11,self.textCountMax))
			return
		elseif emotionNum > self.facialCountMax then

			G_TipsOfstr(string.format(res.str.CHAT_TIPS14,self.facialCountMax))
			return
		end

		local flag = conf.SensitiveWords:isContentSpecialChar(self.messageLb:getText())
		if flag then
			G_TipsOfstr(res.str.CHAT_TIPS13)
			return
		end
		
		----------读取敏感词
		local flag = conf.SensitiveWords:checkChatWords(self.messageLb:getText())
		if flag then
			self:createLocalData()
			return
		end
		
		--	创建消息
		local msg = self:createMsg()
		-- --发送消息
		 proxy.Chat:sendMessage(msg)
		
	end
end

function ChattingView:createLocalData(  )
	local data = {}
	data.msgType = "text"
	data.userInfo = {}
	data.userInfo["roleId"] = cache.Player:getRoleId()
	data.userInfo["roleName"] = cache.Player:getName()
	data.userInfo["power"] = cache.Player:getPower()
	data.userInfo["vipLevel"] = cache.Player:getVip()
	data.userInfo["toUser"] = self.nameLabel:getString()
	data.userInfo["roleIcon"] = cache.Player:getHead()
	--称号
	data.titleId = cache.Player:getRoleTitle()
	data.contentStr = self.messageLb:getText()
	local index = self.selectedIdx
	if index == 4 then
		index = 1
	end
	data.chatType = index

	if self.selectedIdx == 4 or self.selectedIdx == 1 then
		local len = #self.chatData[1]
		if len >= self.maxItemNum then
			table.remove(self.chatData[1],1) 
		end
		local len = #self.chatData[1]
		self.chatData[1][len + 1] = data

		local len = #self.chatData[4]
		if len >= self.maxItemNum then
			table.remove(self.chatData[4],1) 
		end
		local len = #self.chatData[4]
		self.chatData[4][len + 1] = data

	else
		local len = #self.chatData[self.selectedIdx]
		if len >= self.maxItemNum then
			table.remove(self.chatData[self.selectedIdx],1) 
		end
		local len = #self.chatData[self.selectedIdx]
		self.chatData[self.selectedIdx][len + 1] = data
	end

	local item = self:addItem(data)
	self:updateListView(item)
	self.messageLb:setText("")

	return data
end

----发送消息成功
function ChattingView:sendMsgSucc(  )

	-- local data = {}
	-- data.contentStr = self.messageLb:getText()
	-- --data.roleId = cache.Player:getRoleIdStr()
	-- data.msgType = "text"
	-- data.userInfo = {}
	-- data.userInfo["roleId"] = cache.Player:getRoleId()
	-- data.userInfo["roleName"] = cache.Player:getName()
	-- data.userInfo["power"] = cache.Player:getPower()
	-- data.userInfo["vipLevel"] = cache.Player:getVip()
	-- data.userInfo["toUser"] = self.nameLabel:getString()
	-- data.userInfo["roleIcon"] = cache.Player:getRoleSex()
	-- --称号
	-- data.titleId = cache.Player:getRoleTitle()

	-- ---如果消息数达到上限，移除最早一条
	-- local len = #self.chatData[self.selectedIdx]
	-- if len >= self.maxItemNum then
	-- 	--todo
	-- 	table.remove(self.chatData[self.selectedIdx],1) 
	-- end
	-- local len = #self.chatData[self.selectedIdx]
	-- self.chatData[self.selectedIdx][len + 1] = data
	-- local item = self:addItem(data)
	-- self:updateListView(item)

	-- ---------保存聊天记录
	-- cache.Chat:saveData(self.chatData)

	self.toUser = self.nameLabel:getString()
	self.messageLb:setText("")

end

--------删除好友成功
function ChattingView:delFriendSucc(data)
	-- body
	for i=1,#self.chatData[self.selectedIdx] do
		local roleId = self.chatData[self.selectedIdx][i]["userInfo"].roleId
		--dump(self.chatData[self.selectedIdx][i])
		if roleId["key"] == data.roleId["key"] then
			--todo
			local roleName = self.chatData[self.selectedIdx][i]["userInfo"].roleName
			
			G_TipsOfstr(string.format(res.str.FRIEND_TIPS1, roleName))
			return
		end
	end
end

function ChattingView:getMsgData( index )
	-- body
	local records = proxy.Chat:getRecoedByType(index)
	proxy.Chat:romoveRecordByType(index,self.maxItemNum)
	self.ListGUIButton[1]:setNumber(#proxy.Chat:getRecoedByType(1))
	self.ListGUIButton[2]:setNumber(#proxy.Chat:getRecoedByType(2))
	self.ListGUIButton[3]:setNumber(#proxy.Chat:getRecoedByType(3))

	self.ListGUIButton[index]:setNumber(0)

	return records
end

------接收到消息
function ChattingView:receiveMsg()
	-- body

	----获取消息，设置红点
	local index = self.selectedIdx
	if self.selectedIdx == 4 then
		index = 1
	end

	local records = self:getMsgData(index)

	for i=1,#records do
		local data = records[i]
		local msg = {}
		msg.contentStr = data.contentStr
		msg.userInfo = {}
		msg.msgType = data.msgType
		msg.chatType = data.chatType
		msg.titleId = data.titleId


		if data.hbId then
			msg.hbId = data.hbId
		end

		msg.userInfo["roleId"] = data["roleId"]
		msg.userInfo["roleName"] = data["roleName"]
		msg.userInfo["vipLevel"] = data["vipLevel"]
		msg.userInfo["power"] =  data["power"]
		msg.userInfo["roleIcon"] =  data["vipIcon"]

		msg.userInfo["toUser"] = data["toName"]

		if msg then
		---如果消息数达到上限，移除最早一条
		if self.selectedIdx == 3 or self.selectedIdx == 2  then-----针对公会和私聊
			local len = #self.chatData[self.selectedIdx]
			if len >= self.maxItemNum then
				--todo
				table.remove(self.chatData[self.selectedIdx],1) 
			end
			local len = #self.chatData[self.selectedIdx]
			self.chatData[self.selectedIdx][len + 1] = msg

		elseif self.selectedIdx == 1 or self.selectedIdx == 4 then--针对世界 和全部

			--不用加入 世界 中显示
			if msg.msgType == "text" or  msg.msgType == "horn" then
				local len = #self.chatData[1]
				if len >= self.maxItemNum then
					table.remove(self.chatData[1],1) 
				end
				local len = #self.chatData[1]
				self.chatData[1][len + 1] = msg
			end

			local len = #self.chatData[4]
			if len >= self.maxItemNum then
				table.remove(self.chatData[4],1) 
			end
			local len = #self.chatData[4]
			self.chatData[4][len + 1] = msg

		end

			--普通聊天、喇叭都是聊天类型，
			if msg.msgType == "text" then
				local item = self:addItem(msg)
				self:updateListView(item)
			elseif msg.msgType == "horn" then
				local item = self:addItem(msg)
				self:updateListView(item)
			elseif msg.msgType == "redBag" then
				if self.selectedIdx ~= 1 then
					local item = self:addRedBagItem(msg)
					self:updateListView(item)
				end
			end
			
			
		end

	end

	cache.Chat:saveData(self.chatData)
	
end

------点击玩家头像
function ChattingView:onItemFaceBtnClickUp( sender,eventType )
	-- body

	if eventType ==  ccui.TouchEventType.ended then
		--todo
		--mgr.ViewMgr:showView("friends.ChattingView")
		local roleId = sender.roleId
		proxy.Chat:reqFriendInfo(roleId)
	end

end


-----选择表情按钮
function ChattingView:selectFacial( sender,etype )
	-- body
	if etype == ccui.TouchEventType.ended then

		if self.isFacialPanelShow == false then
			--todo
			self.inputChatObjPanel:setVisible(false)
			mgr.ViewMgr:showView(_viewname.FACIALS):setDelegate(self)
			self.isFacialPanelShow = true
		else
			if self.selectedIdx == 3 then
				self.inputChatObjPanel:setVisible(true)
			end
			mgr.ViewMgr:closeView(_viewname.FACIALS)
			self.isFacialPanelShow = false
		end


	end
	
end

---选择表情
function ChattingView:facialSelected( imgId )
	-- body
	self.isFacialPanelShow = false
	if self.selectedIdx == 3 then
		--todo
		self.inputChatObjPanel:setVisible(true)
	end
	if self:calculateEmotionNum(self.messageLb:getText()) >= self.facialCountMax then
		--todo
		G_TipsOfstr(string.format(res.str.CHAT_TIPS14,self.facialCountMax))
		return
	end
	local img = "["..imgId.."]"
	self.messageLb:setText(self.messageLb:getText() .. img )

end

------领取红包
function ChattingView:onGetRedBagCallback( sender,etype )
	if etype == ccui.TouchEventType.ended then
		print("抢到红包啦。。。")
		--mgr.ViewMgr:showView(_viewname.RECEIVE_REDBAG):setData(sender.data)
		local data = {}
		data.hbId = sender.hbId
		--dump(data)
		proxy.Redbag:reqGetRedbag(data)
		--proxy.Redbag:reqGetRedbag()
	end

end





function ChattingView:onCloseSelfView( ... )
	-- body
	self.isShow = false
	--self:onHide()
	self:closeSelfView()
	G_mainView()
end

function ChattingView:setIsShow( flag )
	-- body
	self.isShow = flag
end

function ChattingView:getIsShow(  )
	-- body
	return self.isShow
end

function ChattingView:test( ... )

end



return ChattingView