--
-- Author: chenlu_y
-- Date: 2015-12-10 21:28:35
--
local PrivateEmailView = class("PrivateEmailView", base.BaseView)

local rowNum = 6
local colNum = 6
local itemSize = 50

function PrivateEmailView:init(  )
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.isFacialPaneShow = false
	
	self.faceClone = self.view:getChildByName("Panel_clone")
	self.itemClone = self.view:getChildByName("Button_face")

	local panel1 = self.view:getChildByName("Panel_1")
	self.facePanel = panel1:getChildByName("Panel_face")------表情面板
	self.facePanel:setSwallowTouches(false)
	self.facePanel:setVisible(false)
	self.listView =self.facePanel:getChildByName("ListView")----表情滑动层

	local panel7 = panel1:getChildByName("Panel_7")
	self.inputLab = panel7:getChildByName("Text_input")
	self.btnSend = panel7:getChildByName("Button_send")--发送按钮
	self.btnSend:getChildByName("Text_title_12"):setString(res.str.HSUI_DESC41)
	self.btnSend:addTouchEventListener(handler(self,self.sendMsg))

	self.dxNameTxt = panel7:getChildByName("Text_1_0")
	panel7:getChildByName("Text_1"):setString(res.str.HSUI_DESC44)
	
	self.btnAdd = panel7:getChildByName("Button_add")----添加表情按钮
	self.btnAdd:addTouchEventListener(handler(self,self.addFacial))

	self.inputBox = cc.ui.UIInput.new({--------输入框
			UIInputType == 2,
		    image = res.image.TRANSPARENT,
		    x = self.inputLab:getPositionX(),
		    y = self.inputLab:getPositionY(),
		   -- listener = self.editBoxHandler,
		    size = cc.size(self.inputLab:getContentSize().width,self.inputLab:getContentSize().height)
		})
	panel7:addChild(self.inputBox)
	self.inputBox:setFontSize(30)
	self.inputLab:setString(res.str.HSUI_DESC42)
	self.inputBox:setFontName(self.inputLab:getFontName())
	self.inputBox:registerScriptEditBoxHandler(handler(self, self.editBoxHandler))
	
	self:createFacials()
end

function PrivateEmailView:createFacials(  )
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
end

function PrivateEmailView:editBoxHandler( strEventName,inputBox )
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

function PrivateEmailView:addFacial( send,etype )
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

function PrivateEmailView:onFacialSelected( send,etype)
	if etype == ccui.TouchEventType.ended then
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

function PrivateEmailView:sendMsg(send,etype )
	if etype == ccui.TouchEventType.ended then
		local eNum = self:calculateEmotionNum(self.inputBox:getText())
		local fNum = string.utf8len(self.inputBox:getText())
		if fNum == 0 then
			G_TipsOfstr(res.str.CHAT_TIPS10)
			return
		elseif fNum > 50 then
			G_TipsOfstr(string.format(res.str.CHAT_TIPS18, 50))
			return
		end
		if eNum > 3 then
			G_TipsOfstr(string.format(res.str.CHAT_TIPS14, 3))
			return
		end
		-- if fNum - string.len("[00]") * eNum > 15 then
		-- 	G_TipsOfstr(string.format(res.str.CHAT_TIPS11, 15))
		-- 	return
		-- end

		---敏感字符
		if conf.SensitiveWords:isContentSpecialChar(self.inputBox:getText()) then
			G_TipsOfstr(res.str.CHAT_TIPS13)
			return
		end

		if self.mailId then
			proxy.Mail:sendGet(self.mailId,6)
		end	
		local msg = self.inputBox:getText()
		proxy.PrivateEmail:sendMsg(self.dxRid, msg)

	end
end

--------计算字符串中表情的数量
function PrivateEmailView:calculateEmotionNum( msg )
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

function PrivateEmailView:onCloseSelfView()  
	if self.mailId then --直接关闭表示没回复，认为是已查看
		proxy.Mail:sendGet(self.mailId, 7)
	end
	self:closeSelfView()  
end

function PrivateEmailView:setTargetRid(rid_, rName_)
	self.dxRid = rid_
	if rName_ then
		self.dxNameTxt:setString(rName_)
	end
end

function PrivateEmailView:setMailid(mailId_)
	self.mailId = mailId_
end	

return PrivateEmailView