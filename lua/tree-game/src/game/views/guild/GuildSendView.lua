--[[
	--发布公告
]]

local GuildSendView = class("GuildSendView", base.BaseView)

function GuildSendView:init()
	-- body
	self.showtype=view_show_type.UI
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
	--self.LableAccount:setMaxLength(60)

	local btnsure =  self.view:getChildByName("Image_bg"):getChildByName("Button_buy_more_2")
	btnsure:addTouchEventListener(handler(self, self.onbtnsend))

	--界面文本
	btnsure:getChildByName("Text_1_2_4"):setString(res.str.GUILD_TEXT32)

end

function GuildSendView:onbtnsend(sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local str = string.trim(self.LableAccount:getText())
		if string.utf8len(str)>50 then 
			G_TipsOfstr(res.str.GUILD_DEC41)
			return 
		end 
		local param = {gonggaoStr = str}
		proxy.guild:sendChange(param)
		self:onCloseSelfView()
	end 
end

function GuildSendView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return GuildSendView