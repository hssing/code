
local DigFriendItem = class("DigFriendItem", function(  )
	return ccui.Widget:create() 
end 
)


function DigFriendItem:init( param )
	-- body
	self.Parent=param
	self.view=param:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	local btn = self.view:getChildByName("Button_2_1")
	btn:addTouchEventListener(handler(self,self.onBtnSeeFriend))
	self.btn = btn
	self.btn:setTitleText(res.str.DIG_DEC73)

	self.sprframe = self.view:getChildByName("Image_4") --边框图
	self.spr = self.sprframe:getChildByName("img_spr") --精灵
	self.lab_lv = self.sprframe:getChildByName("Image_4_0_0"):getChildByName("Text_1")--等级
	self.lab_name = self.view:getChildByName("Image_7"):getChildByName("Text_2")--名字
	self.img_huo = self.view:getChildByName("Image_9") --着火图标
	self.lab_count = self.view:getChildByName("Text_2_0") --开启文件岛的数量
	self.lab_time = self.view:getChildByName("Text_2_0_0")--离线时间 或者 在线
	self.vip = self.sprframe:getChildByName("img_spr_0")
	self.vip:setVisible(false)
	--复仇
	self.panle = self.view:getChildByName("Panel_3")
	self.panle:setVisible(false)
	--助阵
	self.panle11 = self.view:getChildByName("Panel_4")
	self.panle11:setVisible(false)

end

function DigFriendItem:update3()
	-- body
	self.btn:setTouchEnabled(false)
	self.btn:setBright(false)
	self.btn:setTitleText(res.str.DIG_DEC77)
end

function DigFriendItem:setData3(data,idx,daoId)
	-- body
	self.data = data 
	self.idx = idx
	self.daoId = daoId
	self.lab_count:setVisible(false)
	self.panle11:setVisible(true)
	self.img_huo:setVisible(false)
	self.vip:setVisible(false)

	--local role_icon = G_GetHeadIcon(data.roleIcon)
	local temp = G_Split_Back(data.roleIcon)
	self.sprframe:loadTexture(temp.frame_img)

	if self.sprframe:getChildByName("dw") then 
		self.sprframe:getChildByName("dw"):removeSelf()
	end
	if temp.dw > temp.min_dw then 
		local spr = display.newSprite(res.icon.DW_ICON[temp.dw])
		spr:setName("dw")
		spr:setPosition(temp.dw_pos)
		spr:addTo(self.sprframe)
	end

	self.spr:loadTexture(temp.icon_img)
	self.spr:ignoreContentAdaptWithSize(true)
	self.spr:setScale(0.8)

	self.lab_lv:setString(data.level)
	self.lab_name:setString(data.roleName)
	
	local distime =   data.lastTime
	local str = res.str.MAILVIEW_MSG_NOLONG
	if distime > 3600*24 then 
		str = string.format(res.str.MAILVIEW_MSG_Day,math.floor(distime/(3600*24)))
	elseif distime > 3600 then 
		str = string.format(res.str.MAILVIEW_MSG,math.floor(distime/3600))
	elseif distime > 0 then 
		str = res.str.MAILVIEW_MSG_NOLONG
	else
		str = res.str.GUILD_DEC_ONLINE_1
	end	
	self.lab_time:setString(str)

	self.btn:setTitleText(res.str.DIG_DEC74)
	self.btn:addTouchEventListener(handler(self, self.onBtnYaoqing))

	self.btn:setBright(true)
	self.btn:setTouchEnabled(true)
	if data.hasInvite > 0 then 
		self.btn:setBright(false)
		self.btn:setTouchEnabled(false)
		self.btn:setTitleText(res.str.DIG_DEC77)
	end


	self.panle11:getChildByName("Text_8"):setString(data.score)
	local str = data.guildName~="" and data.guildName or res.str.GUILD_DEC58
	self.panle11:getChildByName("Text_8_0"):setString(str)
	self.panle11:getChildByName("Image_6_1"):loadTexture(res.icon.VIP_LV[data.vipLevel])
end

function DigFriendItem:setData2( data,idx )
	-- body
	self.data = data 
	self.idx = idx
	self.lab_count:setVisible(false)
	self.img_huo:setVisible(false)
	self.panle:setVisible(true)
	self.vip:setVisible(false)

	--local role_icon = G_GetHeadIcon(data.roleIcon)
	local temp = G_Split_Back(data.roleIcon)
	self.sprframe:loadTexture(temp.frame_img)

	if self.sprframe:getChildByName("dw") then 
		self.sprframe:getChildByName("dw"):removeSelf()
	end
	if temp.dw > temp.min_dw then 
		local spr = display.newSprite(res.icon.DW_ICON[temp.dw])
		spr:setName("dw")
		spr:setPosition(temp.dw_pos)
		spr:addTo(self.sprframe)
	end
	
	local spr = display.newSprite(res.icon.VIP_LV[temp.vip])
	spr:setPosition(temp.vip_pos)
	spr:addTo(self.sprframe)

	self.spr:loadTexture(temp.icon_img)
	self.spr:ignoreContentAdaptWithSize(true)
	self.spr:setScale(0.8)

	self.lab_lv:setString(data.level)
	self.lab_name:setString(data.roleName)

	local lab = self.panle:getChildByName("Text_4_1")
	lab:setString(string.format(res.str.DEC_ERR_11,data.txDaoCount))

	local distime =   data.lastTime
	local str = res.str.MAILVIEW_MSG_NOLONG
	if distime > 3600*24 then 
		str = string.format(res.str.MAILVIEW_MSG_Day,math.floor(distime/(3600*24)))
	elseif distime > 3600 then 
		str = string.format(res.str.MAILVIEW_MSG,math.floor(distime/3600))
	elseif distime > 0 then 
		str = res.str.MAILVIEW_MSG_NOLONG
	else
		str = ""--res.str.GUILD_DEC_ONLINE_1
	end	
	self.lab_time:setString(str)

	self.vip:ignoreContentAdaptWithSize(true)
	self.vip:loadTexture(res.icon.VIP_LV[data.vipLevel])

	local lab_dec = self.panle:getChildByName("Text_4")
	lab_dec:setString(res.str.DIG_DEC71)

	local _img = self.panle:getChildByName("Image_1")
	
	local json = res.image.GOLD

	local arg = conf.Item:getArg1(data.qdDaoType)

	if arg.arg5 == 221051001 then
		json = res.image.GOLD
	elseif 221051002 == arg.arg5 then 
		json = res.image.ZS
	else
		json = res.image.BADGE
	end

	--[[if data.qdDaoType == 2 then 
		json = res.image.ZS
	elseif data.qdDaoType == 3 then 
		json = res.image.BADGE
	end]]--
	_img:loadTexture(json)
	_img:setPositionX(lab_dec:getPositionX()+lab_dec:getContentSize().width)

	local lab_va = self.panle:getChildByName("Text_4_0")
	lab_va:setString(string.format(res.str.DIG_DEC72,data.qdResCount))
	lab_va:setPositionX(_img:getPositionX()+_img:getContentSize().width*_img:getScaleX())

	self.panle:getChildByName("Text_4_0_0"):setString(data.score)

	self.btn:addTouchEventListener(handler(self, self.onbtnQdCallBack))
end



function DigFriendItem:setData(data,idx)
	-- body
	self.panle:setVisible(false)
	self.lab_count:setVisible(true)
	self.data = data 
	self.idx = idx


	--local frame = G_GetRoleFrameByPower(data.)

	--local sex = data.roleIcon == 1 and "BOY" or "GRIL"
	--local role_icon = G_GetHeadIcon(data.roleIcon)
	local temp = G_Split_Back(data.roleIcon)
	self.sprframe:loadTexture(temp.frame_img)
	if self.sprframe:getChildByName("dw") then 
		self.sprframe:getChildByName("dw"):removeSelf()
	end
	if temp.dw > temp.min_dw then 
		local spr = display.newSprite(res.icon.DW_ICON[temp.dw])
		spr:setName("dw")
		spr:setPosition(temp.dw_pos)
		spr:addTo(self.sprframe)
	end

	local spr = display.newSprite(res.icon.VIP_LV[temp.vip])
	spr:setPosition(temp.vip_pos)
	spr:addTo(self.sprframe)

	self.spr:loadTexture(temp.icon_img)
	self.spr:ignoreContentAdaptWithSize(true)
	self.spr:setScale(0.8)

	self.lab_lv:setString(data.level)
	self.lab_name:setString(data.roleName)
	if data.helpCount>0 then 
		self.img_huo:setVisible(true)
	else
		self.img_huo:setVisible(false)
	end 
	self.lab_count:setString(string.format(res.str.DIG_DEC24,data.helpCount))
	
	local distime =   data.lastTime
	local str = res.str.MAILVIEW_MSG_NOLONG
	if distime > 3600*24 then 
		str = string.format(res.str.MAILVIEW_MSG_Day,math.floor(distime/(3600*24)))
	elseif distime > 3600 then 
		str = string.format(res.str.MAILVIEW_MSG,math.floor(distime/3600))
	elseif distime > 0 then 
		str = res.str.MAILVIEW_MSG_NOLONG
	else
		str = res.str.GUILD_DEC_ONLINE_1
	end	
	self.lab_time:setString(str)

	--self.vip:ignoreContentAdaptWithSize(true)
	--self.vip:loadTexture(res.icon.VIP_LV[data.vipLevel])
end

function DigFriendItem:onBtnSeeFriend( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		proxy.Dig:sendDigMainMsg({roleId = self.data.roleId})
		mgr.NetMgr:wait(520002 )
	end 
end

function DigFriendItem:onBtnYaoqing( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("yaoqing ")
		local data = {roleId =  self.data.roleId, daoId = self.daoId , idx =  self.idx}
		proxy.Dig:sendYaoqing(data)
	end
end

function DigFriendItem:onbtnQdCallBack( sender_,eventtype  )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		proxy.Dig:sendDigMainMsg({roleId = self.data.roleId,roleName = self.data.roleName,type = 2})
		mgr.NetMgr:wait(520002)
	end 
end

return DigFriendItem