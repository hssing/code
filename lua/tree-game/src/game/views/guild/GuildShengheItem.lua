--GuildShengheItem
--[[
	审核item 
]]

local GuildShengheItem = class("GuildShengheItem",function(  )
	return ccui.Widget:create()
end)

function GuildShengheItem:init(param)
	-- body
	self.Parent=param
	self.view=param:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)
	--人物边框
	self.frame = self.view:getChildByName("Image_6_29") 
	self.spr = self.frame:getChildByName("Image_7_28") 
	self.spr:setScale(0.8)

	-- 
	local img = self.view:getChildByName("Image_8_31")
	self.lab_name = self.view:getChildByName("Text_1_25") 
	self.lab_lv = img:getChildByName("Text_1_0_1_31") 
	self.lab_power = img:getChildByName("Text_1_0_0_0_33") 

	--
	local btnsure = self.view:getChildByName("Button_2_0_20") 
	btnsure:addTouchEventListener(handler(self, self.onSureCallBack))

	local btncancel = self.view:getChildByName("Button_2_18") 
	btncancel:addTouchEventListener(handler(self, self.onCancelCallBack))

	self.vip = self.view:getChildByName("Image_9")

end

function GuildShengheItem:onSureCallBack(sender_,eventype)
	-- body
	
	
	if eventype == ccui.TouchEventType.ended then
		local flag = self.Parent:ishitTest(sender_:getTouchEndPosition())
		if not flag then 
			return 
		end 
		if self.selfPosition == 3 then
			G_TipsOfstr(res.str.GUILD_DEC9)
			return 
		elseif self.cur_member>=self.maxlimlit then 
			G_TipsOfstr(res.str.GUILD_DEC26)
			return 
		end  
		--debugprint("同意加入")
		local params = {roleId = self.data.roleId,isOk = 1 }
		--printt(params)
		proxy.guild:sendShenghe(params)
	end 
end

function GuildShengheItem:onCancelCallBack( sender_,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		local flag = self.Parent:ishitTest(sender_:getTouchEndPosition())
		if not flag then 
			return 
		end 
		--debugprint("拒绝加入")
		if self.selfPosition == 3 then
			G_TipsOfstr(res.str.GUILD_DEC9)
			return 
		end  
		local params = {roleId = self.data.roleId,isOk = 0 }
		--printt(params)
		proxy.guild:sendShenghe(params)
	end 
end

function GuildShengheItem:setData(data,idx)
	-- body
	self.data = data
	--self.memberdata = cache.Guild:getMemberInfo()
	self.cur_member = cache.Guild:getGuildCount() --公会当前人数
	self.maxlimlit = conf.guild:getLimitCount(cache.Guild:getGuildLevel()) --上限人数

	--[[local t = cache.Guild:getGuildSelfData()
	if t then 
		self.selfPosition = t.job
	else
		self.selfPosition = 3--普通成员
	end ]]--
	self.selfPosition = cache.Guild:getSelfJob()
	--debugprint("来到了这里哦")
	--local path = 
	--self.frame:loadTexture(path)
	
	local temp = G_Split_Back(data.roleIcon)
	if data.roleIcon<200000 then
		temp.icon_img = "res/head/200.png"
	elseif data.roleIcon<300000 then
		temp.icon_img = "res/head/100.png"
	end
	--local role_icon = res.icon.ROLE_ICON[data.roleIcon]
	--local icon = G_GetRoleFrameByPower(data.power)
	self.frame:ignoreContentAdaptWithSize(true)
	-- self.frame:loadTexture(temp.frame_img)

	if temp.dw~=nil and temp.dw > temp.min_dw then 
		--[[local spr = display.newSprite(res.icon.DW_ICON[temp.dw])
		spr:setPosition(temp.dw_pos)
		spr:addTo(self.frame)]]--

		if self.frame:getChildByName("dw") then 
			self.frame:getChildByName("dw"):removeSelf()
		end
		if temp.dw > temp.min_dw then 
			local spr = display.newSprite(res.icon.DW_ICON[temp.dw])
			spr:setName("dw")
			spr:setPosition(temp.dw_pos)
			spr:addTo(self.frame)
		end
	end






	--local sex = data.roleIcon == 1 and "BOY" or "GRIL"
	--local role_icon = G_GetHeadIcon(data.roleIcon)
	self.spr:ignoreContentAdaptWithSize(true)
	-- if(temp.icon_img ~= nil) then 
	self.spr:loadTexture(temp.icon_img)
	-- end
	--self.frame:setPosition(self.spr:getContentSize().width/2,self.spr:getContentSize().height/2)

	self.lab_name:setString(data.roleName)
	self.lab_lv:setString(data.roleLevel)
	self.lab_power:setString(data.power)

	self.vip:ignoreContentAdaptWithSize(true)
	self.vip:loadTexture(res.icon.VIP_LV[data.vipLevel])

end

return GuildShengheItem
