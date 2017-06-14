--GuildMemberItem
local head_path = "res/views/ui_res/icon/"
local end_type = ".png"


local GuildMemberItem = class("GuildMemberItem",function(  )
	return ccui.Widget:create()
end)

function GuildMemberItem:init( widget)
	-- body
	self.Parent=widget
	self.view=widget:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	--图像框
	self.bt_frame = self.view:getChildByName("Image_5")
	self.spr = self.bt_frame:getChildByName("Image_12")

	self.bt_frame:setTouchEnabled(true)
	self.bt_frame:addTouchEventListener(handler(self, self.seeMember))

	--self.spr = self.view:getChildByName("Image_5")
	--self.bt_frame  =self.spr:getChildByName("Image_12") 

	--self.spr:reorderChild(self.bt_frame, -1)
	--等级
	self.lab_lv = self.view:getChildByName("Image_7"):getChildByName("Text_6")

	self.lab_name = self.view:getChildByName("Text_7")
	self.lab_position = self.view:getChildByName("Text_7_0")
	self.lab_power = self.view:getChildByName("Text_7_1")

	self.lab_gongxian_day = self.view:getChildByName("Text_7_2")
	self.lab_gongxian_all = self.view:getChildByName("Text_7_2_0")

	self.online = self.view:getChildByName("Text_7_2_0_0") 
	self.btn_up =  self.view:getChildByName("Button_Using_26_7_84") 
	self.btn_down =  self.view:getChildByName("Button_Using_26_7_84_0") 

	self.vip = self.view:getChildByName("Image_8_2")
end

function GuildMemberItem:setData(data,idx)
	-- body
	self.data = data
	self.idx = idx

	self.selfPosition =  cache.Guild:getSelfJob()

	local temp = G_Split_Back(data.roleIcon)
	--local path = G_GetRoleFrameByPower(data.power)
	self.bt_frame:ignoreContentAdaptWithSize(true)
	self.bt_frame:loadTexture(temp.frame_img)


	if self.bt_frame:getChildByName("dw") then 
		self.bt_frame:getChildByName("dw"):removeSelf()
	end
	if temp.dw > temp.min_dw then 
		local spr = display.newSprite(res.icon.DW_ICON[temp.dw])
		spr:setName("dw")
		spr:setPosition(temp.dw_pos)
		spr:addTo(self.bt_frame)
	end
	

	self.spr:ignoreContentAdaptWithSize(true)
	self.spr:setScale(0.8)
	self.spr:loadTexture(temp.icon_img)

	--self.bt_frame:setPosition(self.spr:getContentSize().width/2,self.spr:getContentSize().height/2)

	self.lab_lv:setString(data.roleLevel)
	self.lab_name:setString(data.roleName)
	self.lab_position:setString(res.str["GUILD_DEC_POSTION_"..data.job])
	self.lab_power:setString(data.power)	

	self.lab_gongxian_day:setString(data.todayPoint)
	self.lab_gongxian_all:setString(data.totalPoint)

	if data.lastTime == 0 then 
		self.online:setString(res.str.GUILD_DEC_ONLINE_1)
	else
		if data.lastTime < 3600 then 
			local min = math.ceil(data.lastTime/60)
			self.online:setString(string.format(res.str.HSUI_DESC23,min))
		elseif data.lastTime < 3600 * 24 then
			local min = math.round(data.lastTime/(3600))
			self.online:setString(string.format(res.str.HSUI_DESC24,min))
		else
			local min =  math.round(data.lastTime/(3600*24)) 
			self.online:setString(string.format(res.str.HSUI_DESC25,min))
		end
	end 

	self.btn_up:setVisible(false)
	self.btn_down:setVisible(false)

	if self.selfPosition > 1   then 
		if data.job == 1 then 
			self.btn_up:setVisible(true)
			self.btn_up:setTitleText(res.str.GUILD_DEC8)
			self.btn_up:addTouchEventListener(handler(self, self.onbtnTanhe))
		end 

		if self.selfPosition == 2 and data.job ~= 1 then 
			self.btn_down:setVisible(true)
			self.btn_down:setTitleText(res.str.GUILD_DEC7)
			self.btn_down:addTouchEventListener(handler(self, self.onbtnTichu))
		end 
	else
		self.btn_up:setVisible(true)
		self.btn_down:setVisible(true)

		self.btn_up:setTitleText(res.str.GUILD_DEC6)
		self.btn_up:addTouchEventListener(handler(self, self.onbtnRenming))

		self.btn_down:setTitleText(res.str.GUILD_DEC7)
		self.btn_down:addTouchEventListener(handler(self, self.onbtnTichu))
	end 
	--如果该条目是自己 
	local key_self = cache.Player:getRoleInfo()
	if self.data.roleId.key == key_self.roleId.key then 
		self.btn_up:setVisible(false)
		self.btn_down:setVisible(false)
	end 

	self.vip:ignoreContentAdaptWithSize(true)
	self.vip:loadTexture(res.icon.VIP_LV[data.vipLevel])
	
	--[[if data.job < 3 then  --会长 会长有任命能力 提出能力
		self.btn_up:setVisible(true)
		self.btn_down:setVisible(true)

		self.btn_up:setTitleText(res.str.GUILD_DEC6)
		self.btn_up:addTouchEventListener(handler(self, self.onbtnRenming))

		self.btn_down:setTitleText(res.str.GUILD_DEC7)
		self.btn_up:addTouchEventListener(handler(self, self.onbtnTichu))
	else
		self.btn_up:setVisible(true)
		self.btn_up:setTitleText(res.str.GUILD_DEC8)
		self.btn_up:addTouchEventListener(handler(self, self.onbtnTanhe))
	end ]]--
end

function GuildMemberItem:seeMember( sender_, eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		if self.data.roleId.key == cache.Player:getRoleInfo().roleId.key then 
			return 
		end 
		proxy.Chat:reqFriendInfo(self.data.roleId)
	end 
end

--任命按钮
function GuildMemberItem:onbtnRenming(sender_, eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		--debugprint("任命")
		mgr.ViewMgr:showView(_viewname.GUILD_RENMING):setData(self.data)
	end 
end

function GuildMemberItem:onbtnTichu( sender_, eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		debugprint("踢出")
		if self.selfPosition == 3 then 
			G_TipsOfstr(res.str.GUILD_DEC9)
			return 
		elseif self.selfPosition == 2 and self.data.job < 3 then 
			G_TipsOfstr(res.str.GUILD_DEC9)
			return 
		end 
		--debugprint("你要T出 = "..self.lab_name:getString())

		local data = {}
		data.richtext = string.format(res.str.GUILD_DEC10,self.lab_name:getString())
		data.surestr = res.str.SURE
		data.sure = function ()
			-- body
			local params = {roleId = self.data.roleId}
			proxy.guild:sendTuichu(params)
		end
		data.cancel = function( ... )
			-- body
		end
		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)		
	end 
end

function GuildMemberItem:onbtnTanhe( sender_, eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		--debugprint("弹劾")
		if self.data.lastTime < 7*24*3600 then 
			G_TipsOfstr(res.str.GUILD_DEC30)
			return 
		end 
		local data = {}

		data.richtext = {
			{text=res.str.GUILD_DEC13,fontSize=24,color=cc.c3b(255,255,255)},
			{text=string.gsub(res.str["GUILD_DEC_POSTION_"..self.data.job]," ",""),fontSize=24,color=cc.c3b(255,0,0)},
			--{text=res.str.PROMOTEN_DEC5,fontSize=24,color=cc.c3b(255,255,255)},
		}

		--data.richtext = string.format(res.str.GUILD_DEC13,res.str["GUILD_DEC_POSTION_"..self.data.job])
		data.surestr = res.str.SURE
		data.sure = function ()
			-- body
			local params = {roleId = self.data.roleId,career = 9 }
			proxy.guild:sendAppoint(params)
		end
		data.cancel = function( ... )
			-- body
		end
		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,true)		

	end 
end

return GuildMemberItem