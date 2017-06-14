--[[
	Active_100_recharge 100元充值活动
]]

local Active_100_recharge_1 = class("Active_100_recharge_1",base.BaseView)

function Active_100_recharge_1:ctor()
	-- body
end

function Active_100_recharge_1:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	--self:initDec()
	self:schedule(self.changeTimes,1.0,"changeTimes")

	--如果是主界面进入
	self.mianview = mgr.ViewMgr:get(_viewname.RANKENTY)
	
	G_FitScreen(self,"Image_1")

	--proxy.Active:send_116151({actId = 3009})
end

function Active_100_recharge_1:send_116151(id)
	-- body
	print(id,"self.id")
	self.id = id
	self:initDec()
end

function Active_100_recharge_1:initDec()
	-- body
	local top = self.view:getChildByName("Panel_2")
	local lab_1 = top:getChildByName("Text_1")
	local lab_2 = top:getChildByName("Text_1_0")
	local lab_3 = top:getChildByName("Text_1_1")
	local lab_4 = top:getChildByName("Text_1_0_0")
	local lab_5 = top:getChildByName("Text_1_1_0")
	lab_4:setString(res.str.RES_GG_04)
	if self.id == 3010 then
		top:getChildByName("Image_19"):loadTexture(res.font._100RMB_E)

		self.view:getChildByName("Image_1"):getChildByName("Image_100_0"):loadTexture(res.font._100RMB_E_1) 

		lab_4:setString(res.str.RES_GG_38)
	end
	
	top:getChildByName("Text_1_5"):setString(res.str.RES_GG_06)
	lab_1:setString(res.str.RES_GG_01)
	lab_2:setString(res.str.RES_GG_02)
	lab_3:setString(res.str.RES_GG_03)
	
	lab_5:setString(res.str.RES_GG_05)
	local img = top:getChildByName("Image_4")
	img:setVisible(false)
	--img:setPositionX(lab_1:getPositionX()+lab_1:getContentSize().width)
	lab_2:setPositionX(lab_1:getPositionX()+lab_1:getContentSize().width)
	lab_3:setPositionX(lab_2:getPositionX()+lab_2:getContentSize().width)
	lab_4:setPositionX(lab_3:getPositionX()+lab_3:getContentSize().width)
	lab_5:setPositionX(lab_4:getPositionX()+lab_4:getContentSize().width)

	local bg = self.view:getChildByName("Image_1")

	self.frame = bg:getChildByName("Image_97_0")
	self.spr = self.frame:getChildByName("Image_97_0_0") 
	self.spr:ignoreContentAdaptWithSize(true)

	self.btn = bg:getChildByName("Button_1")
	self.btn:setTitleText(res.str.RECHARGE)
	self.btn:addTouchEventListener(handler(self,self.onbtnClooseCallBack))

	local conf_data = conf.active:getItemByid_7x(self.id)
	local mId = conf_data.gifts[1][1]
	if checkint(mId) > 0 then
		local colorlv = conf.Item:getItemQuality(mId)
		self.frame:loadTexture(res.btn.FRAME[colorlv])
		self.spr:loadTexture(conf.Item:getItemSrcbymid(mId))
		self.frame.mId = mId
		self.frame:addTouchEventListener(handler(self,self.onBtnSee))
		self.frame:setTouchEnabled(true)
	end
end

function Active_100_recharge_1:changeTimes()
	-- body
	if not self.data or not self.data.todayLeftTime then 
		if self.mianview then
			self.mianview:updateData("")
		end
		return 
	end

	self.data.todayLeftTime = self.data.todayLeftTime - 1
	if self.data.todayLeftTime <= 0 then 
		self.data.todayLeftTime = 0
		G_mainView()
		return
	end

	self.mianview:updateData(self:getTimeStr(self.data.todayLeftTime))
end

function Active_100_recharge_1:getTimeStr( leftTime )
	--self.leftTime = self.leftTime - 1
	local left = 0
	local day = math.floor(leftTime / (60 * 60 * 24))--天
	left = leftTime - day * 60 * 60 * 24

	local hour = math.floor(left / (60 * 60))--时
	left = left - hour * 60 * 60

	local minute = math.floor(left / 60)--分
	left = left - minute * 60 --秒
	local timeStr

	if day == 0 and hour == 0 and minute == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC9,left)
	elseif day == 0 and hour == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC10, minute,left)
	elseif day == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC11, hour,minute,left)
	else
		timeStr = string.format(res.str.RICH_RANK_DESC12, day,hour,minute,left)
	end

	return timeStr
end

function Active_100_recharge_1:update(data)
	-- body
	local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
	view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
	view:setData(data.items,true,true)
	view:setButtonVisible(false)

	self.data.awardSign =  data.awardSign
	self.data.todayLeftTime = data.leftTime 
	if self.data.awardSign > 0 then --领取了
		self.btn:setTouchEnabled(false)
		self.btn:setBright(false)

		self.btn:setTitleText(res.str.MAILVIEW_GET_OVER)
	else
		self.btn:setTouchEnabled(true)
		self.btn:setBright(true)
	end
end

function Active_100_recharge_1:setData(data)
	-- body
	self.data = data

	if data.activeSign > 0 then --已经充值了
		self.btn.tag = 1
		self.btn:setTitleText(res.str.RES_RES_93)

		if data.awardSign > 0 then --领取了
			self.btn:setTouchEnabled(false)
			self.btn:setBright(false)

			self.btn:setTitleText(res.str.MAILVIEW_GET_OVER)
		else
			self.btn:setTouchEnabled(true)
			self.btn:setBright(true)
		end
	else
		self.btn.tag = 2
		self.btn:setTitleText(res.str.RECHARGE)
	end
end

function Active_100_recharge_1:onBtnSee(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		G_openItem(sender_.mId)
	end
end

function Active_100_recharge_1:onbtnClooseCallBack(send_,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		if self.btn.tag == 2 then 
			G_GoReCharge(1000)
		else
			proxy.Active:send_116152({actId = self.id})
		end
	end
end

return Active_100_recharge_1
