--
-- Author: Your Name
-- Date: 2015-08-19 20:01:56
--

local HornView = class("HornView", base.BaseView)

local rowNum = 6
local colNum = 6
local itemSize = 50

function HornView:init(  )
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.isFacialPaneShow = false
	self.mainEnter = false


	self.topPanel = self.view:getChildByName("Panel_1")
	self.facePanel = self.topPanel:getChildByName("Panel_face")
	self.facePanel:setSwallowTouches(false)------表情面板
	self.facePanel:setVisible(false)

	self.listView =self.facePanel:getChildByName("ListView")----表情滑动层
	self.faceClone = self.view:getChildByName("Panel_clone")
	self.itemClone = self.view:getChildByName("Button_face")
	self.btnSend = self.topPanel:getChildByName("Panel_7"):getChildByName("Button_send")--发送按钮
	self.btnAdd = self.topPanel:getChildByName("Panel_7"):getChildByName("Button_add")----添加表情按钮
	self.btnAdd:addTouchEventListener(handler(self,self.addFacial))
	self.inputLab = self.topPanel:getChildByName("Panel_7"):getChildByName("Text_input")

	self.inputBox = cc.ui.UIInput.new({--------输入框
			UIInputType == 2,
		    image = res.image.TRANSPARENT,
		    x = self.inputLab:getPositionX(),
		    y = self.inputLab:getPositionY(),
		   -- listener = self.editBoxHandler,
		    size = cc.size(self.inputLab:getContentSize().width,self.inputLab:getContentSize().height)

		})


	self.inputBox:registerScriptEditBoxHandler(handler(self, self.editBoxHandler))

	self.topPanel:getChildByName("Panel_7"):addChild(self.inputBox)
	self.inputBox:setFontName(self.inputLab:getFontName())
	--self.inputBox:setPlaceHolder("点击输入文字")
	self.inputBox:setFontSize(30)
	self.btnSend:addTouchEventListener(handler(self,self.sendMsg))

	---消耗道具数据显示
	local fuckPanel = self.topPanel:getChildByName("Panel_5")
	self.usedHornLab = fuckPanel:getChildByName("Text_17")
	self.totalHornLab = fuckPanel:getChildByName("Text_14")
	--self.zhuansLab = self.topPanel:getChildByName("Panel_7"):getChildByName("Text_14")
	self.totalHornNum = cache.Pack:getItemAmountByMid(2,221015002)
	--self.totalHornNum = 1000
	self.totalHornLab:setString(self.totalHornNum)
	self.usedHornLab:setString("1/")

	--print("====================",self.totalHornNum,self.usedHornNum)

	local panel2 = fuckPanel:getChildByName("Panel_2")
	panel2:setPosition(self.totalHornLab:getPositionX() + self.totalHornLab:getContentSize().width ,panel2:getPositionY())

	if self.totalHornNum <= 0 then
		self.totalHornLab:setColor(cc.c3b(255,0,0))
	else
		self.totalHornLab:setColor(cc.c3b(255,255,255))
	end


	-------对齐
	
	local xiaohao = fuckPanel:getChildByName("Text_13")
	local horn = fuckPanel:getChildByName("Image_22")

	local width = 136 + 98 + self.usedHornLab:getContentSize().width + self.totalHornLab:getContentSize().width
				print(width)
	fuckPanel:setContentSize(width - 40,fuckPanel:getContentSize().height)
	--fuckPanel:setPosition(self.btnSend:getPositionX(),fuckPanel:getPositionY())

	xiaohao:setString(res.str.HORN_TEXT1) 
	panel2:getChildByName("Text_15"):setString(res.str.HORN_TEXT2)
	self.btnSend:getChildByName("Text_title_12"):setString(res.str.HSUI_DESC41)
	self.inputLab:setString(res.str.HSUI_DESC42)
	
	self:createFacials()
end

function HornView:createFacials(  )
	-- body
	local page = self.faceClone:clone()
	 page:setContentSize(450,(itemSize + 30) * rowNum)
	 self.listView:pushBackCustomItem(page)
	local tag = 1
	for i=1,rowNum do
			for j=1,colNum do
				local item = self.itemClone:clone()
				item:setAnchorPoint(0,1)
				item:setPosition((j-1)*itemSize + (j)*20,page:getContentSize().height - (i - 1)*(itemSize+30))
				page:addChild(item)
				item:setTag(tag+100)
				local name = string.format("%02d", tag)
				item:setName(name)
				item:loadTextureNormal(res.btn.FACIALICONPATH .. name ..".png")
				item:addTouchEventListener(handler(self,self.onFacialSelected))
				tag = tag + 1
				if tag > 32 then
					return
				end
			end
	end

	--self.listView:scrollToBottom(0.1,false)

end

function HornView:editBoxHandler( strEventName,inputBox )
	-- body
	self.inputLab:setString("")
	if strEventName == "began" then
       --self.messageLb:setText(self.inputField:getString())
       self.inputLab:setString("")
    elseif strEventName == "changed" then
        -- 输入框内容发生变化
    elseif strEventName == "ended" then
        -- 输入结束
    elseif strEventName == "return" then
        -- 从输入框返回
       if self.inputBox:getText() == "" then
       	self.inputLab:setString(res.str.HSUI_DESC42)
       end

    end
end

function HornView:addFacial( send,etype )
	-- body
	if etype == ccui.TouchEventType.ended then
		--todo
		if self.isFacialPaneShow then
			--todo
			self.facePanel:setVisible(false)
			self.isFacialPaneShow = false
		else
			self.facePanel:setVisible(true)
			self.isFacialPaneShow = true
		end
		
	end
end

function HornView:onFacialSelected( send,etype)
	if etype == ccui.TouchEventType.ended then
		--todo
		self.facePanel:setVisible(false)
		self.isFacialPaneShow = false

		local eNum = self:calculateEmotionNum(self.inputBox:getText())
		if eNum >= 3 then
			G_TipsOfstr(string.format(res.str.CHAT_TIPS14, 3))
			return
		end

		local str = string.format("[%02d]", send:getTag() - 100)
		self.inputBox:setText(self.inputBox:getText() .. str)
		self.inputLab:setString("")
	end
end

function HornView:sendMsg(send,etype )
	-- body
	if etype == ccui.TouchEventType.ended then

		local eNum = self:calculateEmotionNum(self.inputBox:getText())
		local fNum = string.utf8len(self.inputBox:getText())

		if fNum == 0 then
			G_TipsOfstr(res.str.CHAT_TIPS10)
			return
		end

		if eNum > 3 then
			G_TipsOfstr(string.format(res.str.CHAT_TIPS14, 3))
			return
		end

		if fNum - string.len("[00]") * eNum > 15 then
			G_TipsOfstr(string.format(res.str.CHAT_TIPS11, 15))
			return
		end


		---敏感字符
		if conf.SensitiveWords:isContentSpecialChar(self.inputBox:getText()) then
			G_TipsOfstr(res.str.CHAT_TIPS13)
			return
		end

		--看看喇叭道具或者砖石是否足够
		if self.totalHornNum <= 0 then
			if cache.Fortune:getZs() < 10 then
				local  str  = "";
			    str = res.str.NO_ENOUGH_ZS 
			    local function surecallbcak( ... )
			        -- body
			       G_GoReCharge()
			       self:closeSelfView()
			    end 

			    local function cancelcallbcak()
			        --确定按钮返回
			    end 
			    local data = {};

			    data.richtext = str;
			    data.sure = surecallbcak
			    data.cancel = cancelcallbcak
			    mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
				return 
			end
		end
		--local roleName = "[p=1,t=".. cache.Player:getName() ..":]"
		local msg = self.inputBox:getText()
		proxy.Horn:sendMsg(msg)

	end
end

function HornView:sendMsgSucc()
	local view = mgr.ViewMgr:get(_viewname.HORNTIPS)
		-- if view then
		-- 	local data = {}
		-- 	print(cache.Fortune:getZs())
		-- 	local roleName = "[p=1,t=".. cache.Player:getName() ..":]"
		-- 	data.cType = 6
		-- 	data.contentStr = roleName .. self.inputBox:getText()
		-- 	view:setData(data)
		 	self:onCloseSelfView()
		-- end
end

--------计算字符串中表情的数量
function HornView:calculateEmotionNum( msg )
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



function HornView:onCloseSelfView(  )
	-- body
	
	local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	print(self.mainEnter)
	if view and tolua.isnull(view.btnChat) == false and self.mainEnter then
		view.btnChat:setVisible(true)
	end
	self:closeSelfView()
end

function HornView:setMainEnter(  )
	-- body
	self.mainEnter = true
end




return HornView