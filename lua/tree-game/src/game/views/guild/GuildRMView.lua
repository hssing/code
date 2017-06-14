--[[
	--任命

	--会长 -- 任命会长 副会长 ，成员
]]

local GuildRMView = class("GuildRMView",base.BaseView)

function GuildRMView:init()
	-- body
	self.showtype=view_show_type.TOP
    self.view=self:addSelfView()

    local img = self.view:getChildByName("Image_bg")

    self.img = img
    local btn = img:getChildByName("Button_buy_more_4")
    btn:setTag(1)
    btn:addTouchEventListener(handler(self, self.onbtnRMCallback))

    btn = img:getChildByName("Button_buy_more_4_0")
    btn:setTag(2)
    btn:addTouchEventListener(handler(self, self.onbtnRMCallback))

    btn = img:getChildByName("Button_buy_more_4_1")
    btn:setTag(3)
    btn:addTouchEventListener(handler(self, self.onbtnRMCallback))

    local panle =  self.view:getChildByName("Panel_1")
    panle:addTouchEventListener(handler(self, self.closeview))

    self:initDec()

end

function GuildRMView:initDec()
	-- body
	self.img:getChildByName("Button_buy_more_4"):getChildByName("Text_1_2_7"):setString(res.str.GUILD_DEC_46)
	self.img:getChildByName("Button_buy_more_4_0"):getChildByName("Text_1_2_7_9"):setString(res.str.GUILD_DEC_47)
	self.img:getChildByName("Button_buy_more_4_1"):getChildByName("Text_1_2_7_11"):setString(res.str.GUILD_DEC_48)
end

function GuildRMView:closeview( send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end 
end

function GuildRMView:onCloseSelfView( ... )
	-- body
	self:closeSelfView()
end

function GuildRMView:onbtnRMCallback(send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		local tag = send:getTag()
		local data = {}
		if tag == 1 then 
			data.richtext = string.format(res.str.GUILD_DEC14,self.data.roleName)
		elseif tag == 2 then 
			data.richtext = string.format(res.str.GUILD_DEC15,self.data.roleName)
		else
			data.richtext = string.format(res.str.GUILD_DEC16,self.data.roleName)
		end 
		data.surestr = res.str.SURE
		data.sure = function ()
			-- body
			if tag == 2 then 
				local memberdata = cache.Guild:getMemberInfo()
				for k ,v in pairs(memberdata) do 
					if v.job == 2  then 
						G_TipsOfstr(res.str.GUILD_DEC17)
						self:onCloseSelfView()
						return 
					end 
				end 
			end 

			local params = {roleId = self.data.roleId, career = tag }

			proxy.guild:sendAppoint(params)
		end
		data.cancel = function( ... )
			-- body
		end
		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)		

		--debugprint("任命")
	end 
end

function GuildRMView:setData( data_,name  )
	-- body
	self.data = data_
end

return GuildRMView
