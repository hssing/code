--[[
	--发布公告
]]

local CrossSendView = class("CrossSendView", base.BaseView)

function CrossSendView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local _code_di =  self.view:getChildByName("Image_bg"):getChildByName("Panel_4")
	self.LableAccount=cc.ui.UIInput.new({
	    image = res.image.TRANSPARENT,
	    x = _code_di:getContentSize().width/2,
	    y = _code_di:getContentSize().height/2,
	    size = cc.size(_code_di:getContentSize().width,_code_di:getContentSize().height)
	})
	self.LableAccount:setPlaceHolder(res.str.GUILD_TEXT33)
	self.LableAccount:addTo(_code_di)
	self.LableAccount:setMaxLength(21)

	local btnsure =  self.view:getChildByName("Image_bg"):getChildByName("Button_buy_more_2")
	btnsure:addTouchEventListener(handler(self, self.onbtnsend))

	--界面文本
	btnsure:getChildByName("Text_1_2_4"):setString(res.str.GUILD_TEXT32)

end

function CrossSendView:onbtnsend(sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local str = string.trim(self.LableAccount:getText())
		if string.utf8len(str)>50 then 
			G_TipsOfstr(res.str.GUILD_DEC41)
			return 
		end 
		local param = {bbStr = str}
		proxy.Cross:send_123011(param)
		self:onCloseSelfView()
	end 
end

function CrossSendView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CrossSendView