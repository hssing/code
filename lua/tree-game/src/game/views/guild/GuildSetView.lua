--[[
	GuildSetView 申请入会设置
]]

local GuildSetView = class("GuildSetView", base.BaseView)

function GuildSetView:init( ... )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	local _power_di =  self.view:getChildByName("Image_bg"):getChildByName("Image_18")
	self._input_power = cc.ui.UIInput.new({
	    image = res.image.TRANSPARENT,
	    x = _power_di:getContentSize().width/2+15,
	    y = _power_di:getContentSize().height/2,
	    size = cc.size(_power_di:getContentSize().width,_power_di:getContentSize().height*0.6)
	})
	self._input_power:setPlaceHolder(res.str.GUILD_DEC53)
	--self._input_power:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
	self._input_power:addTo(_power_di)
	self._input_power:setMaxLength(30)
	self._input_power:registerScriptEditBoxHandler(handler(self, self.editboxEventHandler))
	

	local btn = self.view:getChildByName("Image_bg"):getChildByName("Button_buy_more_7")
	btn:addTouchEventListener(handler(self, self.onBtnSureCallBack))

	--界面文本
	self.view:getChildByName("Image_bg"):getChildByName("Text_1_2_0_10"):setString(res.str.GUILD_TEXT31) 
	self.view:getChildByName("Image_bg"):getChildByName("Button_buy_more_7"):getChildByName("Text_1_2_12") :setString(res.str.GUILD_TEXT32) 


	proxy.guild:sendSQmsg()
end

function GuildSetView:editboxEventHandler( eventType )
	-- body
	if eventType == "began" then
	elseif eventType == "ended" then
	elseif eventType == "changed" then
	elseif eventType == "return" then
		local str = checkint(self._input_power:getText())
		self._input_power:setText(str)
	end 
end

function GuildSetView:setData(data)
	-- body
	if data.lastPower > 0 then 
		self._input_power:setPlaceHolder(data.lastPower)
	end 

end

function GuildSetView:onBtnSureCallBack(send, eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then 
		debugprint("向服务器发送数据")
		if self._input_power:getText() == "" then 
			self:onCloseSelfView()
			return 
		end 
		local data = { lastPower = self._input_power:getText(),lastLevel = 0 }
		printt(data)
		proxy.guild:sendSQset(data)
	end 
end

function GuildSetView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return GuildSetView