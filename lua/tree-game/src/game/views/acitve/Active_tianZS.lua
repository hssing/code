--[[
	Active_tianZS 天降钻石
]]

local Active_tianZS = class("Active_tianZS",base.BaseView)

function Active_tianZS:ctor()
	-- body
end

function Active_tianZS:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self:initDec()
	self:schedule(self.changeTimes,1.0,"changeTimes")
	G_FitScreen(self,"Image_1")

	proxy.Active:send_116146()
end

function Active_tianZS:initDec()
	-- body
	local panle = self.view:getChildByName("Panel_1")
	self.panle = panle

	local dec1 = panle:getChildByName("Text_1")
	dec1:setString(res.str.RES_RES_85)

	

	local dec2 = panle:getChildByName("Text_1_0")
	dec2:setString(res.str.RES_RES_86)

	self.today_img = panle:getChildByName("Image_3_0")
	self.today_img:setPositionX(dec2:getPositionX()+dec2:getContentSize().width)

	self.lab_today = panle:getChildByName("Text_1_0_0")
	self.lab_today:setString("")

	self.dec1 = panle:getChildByName("Text_1_0_1")
	self.dec1:setString(res.str.RES_RES_87)
	self.lab_tomorrow = panle:getChildByName("Text_1_0_0_0")
	self.lab_tomorrow:setString("")
	self.img_1 = panle:getChildByName("Image_3_0_0")
	self.img_1:setPositionX(self.dec1:getPositionX()+self.dec1:getContentSize().width)

	self.lab_today_1 = 	panle:getChildByName("Image_8"):getChildByName("AtlasLabel_1")
	self.lab_tomorrow_1 = 	panle:getChildByName("Image_8_0"):getChildByName("AtlasLabel_1_3")

	self.btn = panle:getChildByName("Button_1")
	self.btn:setTitleText(res.str.RES_RES_88)
	self.btn:addTouchEventListener(handler(self,self.onbtnDuihuanCallBack))

	--到时间及时
	self.lab_dec = panle:getChildByName("Text_1_0_2")
	self.lab_count = panle:getChildByName("Text_1_1")

	self.lab_dec:setString("")
	self.lab_count:setString("")
end

function Active_tianZS:setReward()
	-- body
	if not self.data then
		return
	end
	local conf_data_today = conf.active:getDayItem(self.data.day)
	local conf_data_tomorrow = conf.active:getDayItem(self.data.day+1)

	local all_get = 0
	for k ,v in pairs(conf_data_today.costStatus) do
		all_get = all_get + v[2]
	end
	self.lab_today:setString(all_get)
	self.lab_today:setPositionX(self.today_img:getPositionX()
		+self.today_img:getContentSize().width*self.today_img:getScale())

	if conf_data_tomorrow then--如果明天还有
		self.dec1:setVisible(true)
		self.img_1:setVisible(true)
		local all_get2 = 0
		for k ,v in pairs(conf_data_tomorrow.costStatus) do
			all_get2 = all_get2 + v[2]
		end--self.img_1
		self.lab_tomorrow:setString(all_get2.."!")
		self.lab_tomorrow:setPositionX(self.img_1:getPositionX()
		+self.img_1:getContentSize().width*self.img_1:getScale())

		if conf_data_today.costStatus[self.data.count+1] then  --如果今天是不是最后一次
			self.lab_today_1:setString(conf_data_today.costStatus[self.data.count+1][1]) 
			self.lab_tomorrow_1:setString(conf_data_today.costStatus[self.data.count+1][2])
		else
			self.lab_today_1:setString(conf_data_tomorrow.costStatus[1][1]) 
			self.lab_tomorrow_1:setString(conf_data_tomorrow.costStatus[1][2])
		end
	else
		self.dec1:setVisible(false)
		self.img_1:setVisible(false)
		self.lab_tomorrow:setString("")

		if conf_data_today.costStatus[self.data.count+1] then  --如果今天是不是最后一次
			self.lab_today_1:setString(conf_data_today.costStatus[self.data.count+1][1]) 
			self.lab_tomorrow_1:setString(conf_data_today.costStatus[self.data.count+1][2])
		else
			self.panle:getChildByName("Image_8"):setVisible(false)
			self.panle:getChildByName("Image_8_0"):setVisible(false)
			self.panle:getChildByName("Image_20"):setVisible(false)
			self.btn:setVisible(false)
			self.lab_dec:setString("")
			self.lab_count:setString("")

			local label = display.newTTFLabel({
			    text = res.str.RES_RES_90,
			    font = res.ttf[1],
			    size = 30,
			    align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
			})
			label:setPosition(self.panle:getChildByName("Image_20"):getPosition())
			label:addTo(self.panle)
		end
	end
end

function Active_tianZS:getJange(var,var2)
	-- body
	-- body
	local temp_cur = os.date("*t", var2)
	temp_cur.hour = 0
	temp_cur.min  = 0
	temp_cur.sec  = 0
	local t2 = os.time(temp_cur)

	local temp_buy = os.date("*t", var)
	temp_buy.hour = 0
	temp_buy.min  = 0
	temp_buy.sec  = 0
	local t1 = os.time(temp_buy)


	local day=math.abs(os.difftime(t2,t1)/(24*3600)) 
	return day
end

function Active_tianZS:changeTimes()
	-- body
	if not self.data then 
		return
	end

	self.time2 = cache.Player:getSeverTime()
	if self:getJange(self.time2,self.time1) > 0 then --看看间隔是不是一天
		proxy.Active:send_116146()
		print("hahah")
		return
	end


	self.data.remainTime = self.data.remainTime - 1
	if self.data.remainTime < 0 then
		--proxy.Active:send_116146()

		self.data.remainTime = 0
		self.lab_dec:setString("")
		self.lab_count:setString("")

		self.btn:setTouchEnabled(true)
		self.btn:setBright(true)
		return 
	end

	self.btn:setTouchEnabled(false)
	self.btn:setBright(false)
	self.lab_dec:setString(res.str.RES_RES_89)

	local h = 0 
	local m = 0
	local s = 0


	h = math.floor(self.data.remainTime/3600)
	m = math.floor(self.data.remainTime%3600/60)
	s = math.floor(self.data.remainTime%3600%60)

	if h > 0 then
		self.lab_count:setString(string.format(res.str.DOUBLE_DEC2,h,m,s))
	elseif m > 0 then 
		self.lab_count:setString(string.format(res.str.DOUBLE_DEC5,m,s))
	elseif s > 0 then 
		self.lab_count:setString(string.format(res.str.DOUBLE_DEC6,s))
	else
		self.lab_count:setString("")
	end
end

function Active_tianZS:setData(data)
	-- body
	if data.type == 2 then
		G_TipsOfstr(string.format(res.str.RES_RES_91,checkint(self.lab_tomorrow_1:getString())))
	end

	self.time1 = cache.Player:getSeverTime()

	

	self.data = data 
	self:setReward()

	self:changeTimes()
end


function Active_tianZS:onbtnDuihuanCallBack( send_,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		proxy.Active:send_116147()
	end
end

return Active_tianZS