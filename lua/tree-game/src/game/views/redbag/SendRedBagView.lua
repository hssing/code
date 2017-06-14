--
-- Author: Your Name
-- Date: 2015-08-25 19:51:56
--

local SendRedBagView = class("SendRedBagView", base.BaseView)


function SendRedBagView:init(  )
	-- body
	self.showtype = view_show_type.TOP
	self.view=self:addSelfView()


	self.panel = self.view:getChildByName("Panel_1_0")
	self.btnSend =self.panel:getChildByName("Button_12_4")
	self.btnSend:addTouchEventListener(handler(self,self.onSendCallback))

	self.redBagCountLab = self.panel:getChildByName("Text_7")
	self.zsCount = self.panel:getChildByName("Text_7_0")
	self.redbagTypeIcon = self.panel:getChildByName("Image_15")
	self.textField = self.panel:getChildByName("Panel_5"):getChildByName("Text_11")
	self.awardTypeIcon = self.panel:getChildByName("Image_27_10")

	local size = self.panel:getChildByName("Panel_5"):getContentSize()

	self.inputBox = cc.ui.UIInput.new({
			UIInputType == 2,
		    image = res.image.TRANSPARENT,
		    x = self.textField:getPositionX(),
		    y = self.textField:getPositionY(),
		   -- listener = self.editBoxHandler,
		    size = cc.size(size.width,size.height)
		})

	self.inputBox:setAnchorPoint(0,0.5)
	self.inputBox:setFontSize(self.textField:getFontSize())
	self.inputBox:setFontName(self.textField:getFontName())

	self.panel:getChildByName("Panel_5"):addChild(self.inputBox)
	self.inputBox:registerScriptEditBoxHandler(handler(self, self.editBoxHandler))
	self.textField:ignoreContentAdaptWithSize(true)
	--self.textField:removeSelf()
	self.panel:setPosition(display.cx,display.cy)

	self.btnClose = self.panel:getChildByName("Button_close")
	self.btnClose:addTouchEventListener(handler(self,self.onCloseSelfView))

	--ui显示
	self.btnSend:setTitleText(res.str.REDBAG_TEXT3)
	self.panel:getChildByName("Text_9"):setString(res.str.REDBAG_TEXT4)
	self.textField:setString(res.str.HSUI_DESC29)
	
end

function SendRedBagView:setMid( data )
	self.mId = data.mId
	self.index = data.index
	self.type = conf.Item:getExtTpye(self.mId)
	self.redbagTypeIcon:loadTexture(res.font.RED_BAG_ICON[self.type])
	self.redBagCountLab:setString(conf.Item:getExt01(self.mId))
	self.zsCount:setString(conf.Item:getExt02(self.mId))
	self.awardTypeIcon:loadTexture(conf.Item:getExt03Icon(self.mId))

	--调整位置
	--print("==================",)
	if conf.Item:getExt03(self.mId) == 4 then
		self.awardTypeIcon:setPosition(self.awardTypeIcon:getPositionX(),self.awardTypeIcon:getPositionY() + 7)
	end
end


function SendRedBagView:editBoxHandler( strEventName,inputBox )
	-- body
	if strEventName == "began" then
       self.inputBox:setText(self.textField:getString())
       self.textField:setString("")
    elseif strEventName == "changed" then
        -- 输入框内容发生变化
    elseif strEventName == "ended" then
        -- 输入结束
    elseif strEventName == "return" then
        -- 从输入框返回
        if  string.utf8len(self.inputBox:getText()) <= 0 then
        	self.textField:setString(res.str.HSUI_DESC29)
        	return
        end
        self.textField:setString(self.inputBox:getText())
        self.inputBox:setText("")

    end


end

--[[]
		221015003 全服 小
		221015004 全服 中
--]]
function SendRedBagView:onSendCallback( sender,eType )
	if eType == ccui.TouchEventType.ended then
		local data = {}
		data.mId = self.mId
		data.index = self.index
		data.contentStr = self.textField:getString()

		if string.utf8len(self.textField:getString()) > 15 then
			G_TipsOfstr(string.format(res.str.CHAT_TIPS11, 15))
			return
		end

		--敏感字符
		if conf.SensitiveWords:isContentSpecialChar(self.textField:getString()) then
			G_TipsOfstr(res.str.CHAT_TIPS13)
			return
		end


		proxy.Redbag:sendRedBag(data)
		--self:sendRedBagSucc(data)
	end
end

function SendRedBagView:sendRedBagSucc( adata )
	-- local data = {}
	-- 	data.mId = self.mId
	-- 	data.contentStr = string.trim(self.textField:getString())
	-- 	data.msgType = "redBag"
	-- 	data.hbId = adata.hbId
	-- 	data.chatType = self.type

	-- 	local chatData = {}
	-- 	for k,v in pairs(data) do
	-- 		chatData[k] = v
	-- 	end

	-- 	--设置玩家信息
	-- 	data["roleId"] = cache.Player:getRoleId()
	-- 	data["roleName"] = cache.Player:getName()
	-- 	data["power"] = cache.Player:getPower()
	-- 	data["vipLevel"] = cache.Player:getVip()
	-- 	data["vipIcon"] = cache.Player:getRoleSex()

	-- 	cache.Redbag:addData(data)

	-- 	--将红包添加到显示列表，并加入聊天记录
	-- 	local view = mgr.ViewMgr:get(_viewname.HORNTIPS)
	-- 	if view then
	-- 		view:addRedbagData(data)
	-- 	end

		
	-- 	chatData["userInfo"] = {}
	-- 	chatData["userInfo"]["roleId"] = cache.Player:getRoleId()
	-- 	chatData["userInfo"]["roleName"] = cache.Player:getName()
	-- 	chatData["userInfo"]["power"] = cache.Player:getPower()
	-- 	chatData["userInfo"]["vipLevel"] = cache.Player:getVip()
	-- 	chatData["userInfo"]["roleIcon"] = cache.Player:getRoleSex()

		
	-- 	cache.Chat:addData(chatData)
		self:closeSelfView()

end





return SendRedBagView