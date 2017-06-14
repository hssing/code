
local active_month = class("active_month",base.BaseView)

function active_month:init()
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self:initDec()

	proxy.Active:send_116136()

	--self:schedule(self.changeTimes,1.0,"changeTimes")

	G_FitScreen(self,"Image_1")
end

function active_month:getJange(var)
	-- body
	-- body
	local temp_cur = os.date("*t", self.data.curTime)
	temp_cur.hour = 0
	temp_cur.min  = 0
	temp_cur.sec  = 0
	local t2 = os.time(temp_cur)

	local temp_buy = os.date("*t", var)
	temp_buy.hour = 0
	temp_buy.min  = 0
	temp_buy.sec  = 0
	local t1 = os.time(temp_buy)


	local day=checkint(os.difftime(t2,t1)/(24*3600)) 
	return day
end

function active_month:initDec()


	local panle = self.view:getChildByName("Panel_4")
	local topimg = panle:getChildByName("Image_11")
	--描述
	local dec1 =  topimg:getChildByName("Text_26")
	dec1:setString(res.str.DUI_DEC_68)
	dec1:setPosition(dec1:getPositionX(), dec1:getPositionY() - 10)

	local dec2 =  topimg:getChildByName("Text_26_0")
	dec2:setString(res.str.DUI_DEC_69)
	dec2:setPosition(dec2:getPositionX(), dec2:getPositionY() - 10)


	
	self.dec3_1 =  topimg:getChildByName("Text_26_0_0")
	self.dec3_2 =  topimg:getChildByName("Text_26_0_0_0")
	self.dec3_3 =  topimg:getChildByName("Text_26_0_0_0_0")
	self.dec3_1:setString("")
	self.dec3_2:setString("")
	--self.lab_dec_day = dec3_2
	self.dec3_3:setString("")

	self.dec3_1:setVisible(false)
	self.dec3_2:setVisible(false)
	--self.lab_dec_day = dec3_2
	self.dec3_3:setVisible(false)
	--self.dec3_3:setVisible(false)
	--self.dec3_2:setPositionX(self.dec3_1:getPositionX()+self.dec3_1:getContentSize().width)
	--self.dec3_3:setPositionX(self.dec3_2:getPositionX()+self.dec3_2:getContentSize().width)
	
	--月卡
	local conf_data = conf.Act2Charge:getMonthItem(1)
	local img_left = panle:getChildByName("Image_9")
	self.img_yue = img_left:getChildByName("Image_11_0_0_1") --剩余天数底图
	self.lab_yue = self.img_yue:getChildByName("Text_3_1")
	self.img_yue:setVisible(false)
	self.lab_yue:setString("")

	local dec = img_left:getChildByName("Text_3")
	dec:setString(res.str.DUI_DEC_73)

	local dec_1 = img_left:getChildByName("Text_3_0")
	dec_1:setString(conf_data.award_gold)

	self.btn_month = img_left:getChildByName("Button_2")
	self.btn_month:setTitleText(string.format(res.str.DUI_DEC_76,conf_data.con_gold/10))
	self.btn_month.con_gold = conf_data.con_gold
	self.btn_month:addTouchEventListener(handler(self,self.onbtnCall))
	
	--终生卡
	local conf_data_all = conf.Act2Charge:getMonthItem(2)
	local img_right = panle:getChildByName("Image_9_0")
	self.img_all = img_right:getChildByName("Image_11_0_0_1_0") --剩余天数底图
	self.lab_all = self.img_all:getChildByName("Text_3_1_25")
	self.img_all:setVisible(false)
	self.lab_all:setString("")

	local dec = img_right:getChildByName("Text_5")
	dec:setString(res.str.DUI_DEC_73)

	local dec_1 = img_right:getChildByName("Text_5_0")
	dec_1:setString(conf_data_all.award_gold)

	self.btn_all = img_right:getChildByName("Button_2_0")
	self.btn_all:setTitleText(string.format(res.str.DUI_DEC_76,conf_data_all.con_gold/10))
	self.btn_all.con_gold = conf_data_all.con_gold
	self.btn_all:addTouchEventListener(handler(self,self.onbtnCall))
	--底部
	panle:getChildByName("Image_8"):getChildByName("Text_1"):setString(res.str.DUI_DEC_74) 
end
--当前是否领取
function active_month:isGetDay(times)
	-- body
	local temp_cur = os.date("*t", self.data.curTime)
	temp_cur.hour = 0
	temp_cur.min  = 0
	temp_cur.sec  = 0

	if times >= os.time(temp_cur) then
		return true 
	end
	return false
end
--相对服务器时间过去了几天
function active_month:getDay()
	-- body
	local temp_cur = os.date("*t", self.data.curTime)
	temp_cur.hour = 0
	temp_cur.min  = 0
	temp_cur.sec  = 0
	local t2 = os.time(temp_cur)

	local temp_buy = os.date("*t", self.data.mcBuyTime)
	temp_buy.hour = 0
	temp_buy.min  = 0
	temp_buy.sec  = 0
	local t1 = os.time(temp_buy)


	local day=checkint(os.difftime(t2,t1)/(24*3600)) 
	return day
end
--设置月卡 * @return 0:购买过已过期||从来每购买过;  1:购买过没领取完;  2:可续费状态;  3:已经续费状态
function active_month:setBtn()
	-- body
	self.btn_month.reqType = 0
	self.btn_all.reqType = 1
	if self.data.mcBuySign>0 then
		self.img_yue:setVisible(true)
		local day = self.data.mcCurDay --self:getDay()
		local last_day = 30 - day
		if self:isGetDay(self.data.mcLastGotTime) then 
			self.btn_month:setTouchEnabled(false)
			self.btn_month:setBright(false)
			self.btn_month:setTitleText(res.str.DUI_DEC_79)
			self.btn_month.isget = 1
			last_day = last_day - 1
			if last_day <= 0 then
				self.lab_yue:setString(res.str.DUI_DEC_78)
			else
				self.lab_yue:setString(string.format(res.str.DUI_DEC_75,last_day))
			end
		else
			if last_day<=0 then
				self.btn_month:setTouchEnabled(false)
				self.btn_month:setBright(false)
				self.lab_yue:setString(res.str.DUI_DEC_78)
			else
				self.btn_month:setTouchEnabled(true)
				self.btn_month:setBright(true)
				self.lab_yue:setString(string.format(res.str.DUI_DEC_75,last_day))
			end
			self.btn_month:setTitleText(res.str.DUI_DEC_80)
			self.btn_month.isget = 0
		end
	
		if self.data.mcBuySign == 2 or last_day == 0 then 
			self.btn_month.isget = 2
			self.btn_month:setTouchEnabled(true)
			self.btn_month:setBright(true)
			self.btn_month:setTitleText(res.str.RES_GG_87)
		elseif self.data.mcBuySign == 3 then
			self.btn_month.isget = 1
			self.btn_month:setTouchEnabled(false)
			self.btn_month:setBright(false)
			self.btn_month:setTitleText(res.str.RES_GG_88)

			self.lab_yue:setString(string.format(res.str.DUI_DEC_75,30))
		end
	else
		self.btn_month.isget = 2 --去充值
		self.img_yue:setVisible(false)
		self.lab_yue:setString("")
	end

	if self.data.zsBuySign>0 then
		if self:isGetDay(self.data.zsLastGotTime) then 
			self.btn_all:setTouchEnabled(false)
			self.btn_all:setBright(false)
			self.btn_all:setTitleText(res.str.DUI_DEC_79)
			self.btn_all.isget = 1
		else
			self.btn_all:setTouchEnabled(true)
			self.btn_all:setBright(true)
			self.btn_all:setTitleText(res.str.DUI_DEC_80)
			self.btn_all.isget = 0
		end
	else
		self.btn_all.isget = 2 --去充值
	end
end

function active_month:changeTimes( ... )
	-- body
	if not self.data then
		return 
	end
	self.data.leftTime = self.data.leftTime - 1 

	if self.data.leftTime <= 0 then
		self.dec3_1:setString(res.str.DUI_DEC_89)
		self.dec3_2:setString("")
		self.dec3_3:setString("")
		if self.data.mcBuySign<=0 then
			self.btn_month:setTouchEnabled(false)
			self.btn_month:setBright(false)
		end

		if  self.data.zsBuySign<=0 then 
			self.btn_all:setTouchEnabled(false)
			self.btn_all:setBright(false)
		end

	else
		local d = 0
		local h = 0 
		local m = 0
		local s = 0

		d = math.floor(self.data.leftTime/(3600*24))
		h = math.floor(self.data.leftTime%(3600*24)/3600)
		m = math.floor(self.data.leftTime%3600/60)
		s = math.floor(self.data.leftTime%3600%60)

		local str = ""
		if d > 0 then
			str = str..string.format(res.str.DUI_DEC_71,d)
		end
		
		str = str..string.format(res.str.DUI_DEC_90,h)
		str = str..string.format(res.str.DUI_DEC_91,m)
		str = str..string.format(res.str.DUI_DEC_92,s)
	
		self.dec3_1:setString(res.str.DUI_DEC_70)
		self.dec3_2:setString(str)
		self.dec3_3:setString(res.str.DUI_DEC_72)

		self.dec3_2:setPositionX(self.dec3_1:getPositionX()+self.dec3_1:getContentSize().width)
		self.dec3_3:setPositionX(self.dec3_2:getPositionX()+self.dec3_2:getContentSize().width)


	end

	self.data.curTime = self.data.curTime  + 1
	self:setBtn()

end

function active_month:setData(data_)
	-- body
	self.data = data_
	self:setBtn()
	self:changeTimes()
end

function active_month:update( data_ )
	-- body
	if data_.reqType == 1 then
		self.data.zsLastGotTime = data_.zsLastGotTime
	else
		self.data.mcLastGotTime = data_.mcLastGotTime
	end

	self.data.curTime = data_.curTime

	self:setBtn()
end

function active_month:onbtnCall(send,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		if send.isget == 2 then
			G_GoReCharge(send.con_gold)
			--[[local view = mgr.ViewMgr:get(_viewname.SHOP)
			if view then
				view:toConfGold(send.con_gold) 
			end]]--
		elseif send.isget == 0 then
			local data = {reqType = send.reqType}
			proxy.Active:send_116137(data)
		end
	end
end


return active_month