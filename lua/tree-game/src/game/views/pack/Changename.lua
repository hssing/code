--Changename
--[[
	Changename  改名卡 
]]

--[[
	--发布公告
]]

local Changename = class("Changename", base.BaseView)

function Changename:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local bg = self.view:getChildByName("Image_bg")
	local _code_di =  bg:getChildByName("Image_43_5_0")
	self.LableAccount=cc.ui.UIInput.new({
	    image = res.image.TRANSPARENT,
	    x = _code_di:getContentSize().width/2 + 10 ,
	    y = _code_di:getContentSize().height/2,
	    size = cc.size(_code_di:getContentSize().width,_code_di:getContentSize().height*0.6)
	})
	
	self.LableAccount:addTo(_code_di)
	

	local btnsure =  bg:getChildByName("Button_buy_more_2")
	btnsure:addTouchEventListener(handler(self, self.onbtnsend))

	self.title = bg:getChildByName("bg_title1_2"):getChildByName("Image_28_3")
	self.title:ignoreContentAdaptWithSize(true)

	self.oldname = bg:getChildByName("Text_1_2") 
	self.oldname:setString("")
	--界面文本
	btnsure:getChildByName("Text_1_2_4"):setString(res.str.GUILD_TEXT32)
	bg:getChildByName("Text_1_1"):setString(res.str.RES_GG_32) 
	bg:getChildByName("Text_1_3"):setString(res.str.RES_GG_33) 
	bg:getChildByName("Text_1_4"):setString(res.str.RES_GG_34) 
	bg:getChildByName("Text_1_2_0"):setString(res.str.RES_GG_35) 
end

function Changename:setData(data)
	-- body
	self.data = data 

	if self.data.mId == 221015011 then
		self.oldname:setString(cache.Player:getName())
		self.title:loadTexture(res.font.CAHNGE_NAME[1])
		self.reqType = 0
		self.LableAccount:setMaxLength(5)
		self.LableAccount:setPlaceHolder(res.str.LOGIN_DEC_06)
	else
		self.title:loadTexture(res.font.CAHNGE_NAME[2])
		self.oldname:setString(cache.Player:getguildName())	
		self.reqType = 1
		self.LableAccount:setMaxLength(7)
		self.LableAccount:setPlaceHolder(res.str.GUILD_DEC2)
	end
end

function Changename:setData1(str)
	-- body
	self.title:loadTexture(res.font.CAHNGE_NAME[2])
	self.oldname:setString(str)	
	self.reqType = 3
	self.LableAccount:setMaxLength(7)
	self.LableAccount:setPlaceHolder(res.str.GUILD_DEC2)
end

function Changename:onbtnsend(sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local str = string.trim(self.LableAccount:getText())  
		if self.reqType < 3 then
			
			local param = {reqType = self.reqType, name = str , index = self.data.index }
			proxy.pack:send_103005(param)
		else
			debugprint("公会改名")
			proxy.guild:send_117401({name = str})
		end
	end 
end

function Changename:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return Changename