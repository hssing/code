

local CrossMoBaiView = class("CrossMoBaiView",base.BaseView)

function CrossMoBaiView:init()
	-- body
	self.ShowAll = true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	local bg = self.view:getChildByName("Image_1")
	self.bg = bg
	self.boy = bg:getChildByName("Image_b")
	self.gril =bg:getChildByName("Image_g")
	self.bg:reorderChild(self.boy, 100)
	self.bg:reorderChild(self.gril, 100)

	self.clickpanle = bg:getChildByName("Panel_3")
	self.clickpanle:addTouchEventListener(handler(self,self.compareCallBack))

	self:initDec()
	
	self.scale = G_FitScreen(self, "Image_1")
	self:palyForever()
end

function CrossMoBaiView:palyForever()
	-- body
	local armature = mgr.BoneLoad:loadArmature(404826,4)
    armature:setPosition(display.cx,display.cy)
	--armature:setScale(self.scale)
	armature:addTo(self.view)
end

function CrossMoBaiView:initDec()
	-- body
	self.boy:setVisible(true)
	self.gril:setVisible(false)

	local panel = self.view:getChildByName("Panel_1")
	self.lab_name = panel:getChildByName("Text_1")
	self.lab_name:setString("")

	local panle2 = self.view:getChildByName("Panel_2")
	panle2:getChildByName("Text_2"):setString(res.str.RES_RES_30)
	self.lab_count = panle2:getChildByName("Text_2_0") 
	self.lab_count:setString("0")

	panle2:getChildByName("Text_2_1"):setString(res.str.RES_RES_31)
	self.lab_reward = panle2:getChildByName("Text_2_0_0") 
	local var = conf.Sys:getValue("cross_today_mb_sh")
	self.lab_reward:setString(var)

	self.btn = panle2:getChildByName("Button_1")
	self.btn:addTouchEventListener(handler(self,self.onbtnSetCallBack))
end

function CrossMoBaiView:setData(data)
	-- body
	self.data = data
	if not data.zqwzName or data.zqwzName == "" then 
		G_TipsOfstr(res.str.RES_RES_53)
	end

	self.lab_name:setString(data.zqwzName or "")
	self.lab_count:setString(data.mbrs or 0)
	--self.lab_reward:setString(data.mbzs or 0)

	
	if data.sex == 2 then 
		self.boy:setVisible(false)
		self.gril:setVisible(true)
	else
		self.boy:setVisible(true)
		self.gril:setVisible(false)
	end

	self:setbtn(data.todayMb)
end


function CrossMoBaiView:setbtn(var)
	-- body
	if var == 0 then 
		self.btn:setTouchEnabled(true)
		self.btn:setBright(true) 
	else
		self.btn:setTouchEnabled(false)
		self.btn:setBright(false) 
	end
end

function CrossMoBaiView:setserverData( data )
	-- body
	G_TipsOfstr(string.format(string.format(res.str.RES_RES_63,data.mbzs)))

	self.data.mbrs = data.mbrs
	--self.data.mbzs = data.mbzs
	self.data.todayMb = data.todayMb
	self:setbtn(data.todayMb)

	self.lab_count:setString(data.mbrs or 0)
	--self.lab_reward:setString(data.mbzs or 0)
end

--[[function CrossMoBaiView:comPareCalllBack( data_ )
	-- body
	cache.Friend:setOnlyClose(true)
	local view = mgr.ViewMgr:createView(_viewname.ATHLETICS_COMPARE)
	local data = {}

	--右边
	local data1 = {}
	data1.tarName = data_.tarBName
	data1.tarLvl = data_.tarBLvl
	data1.tarPower = data_.tarBPower
	data1.tarCards = data_.tarBCards

	if data1.tarName == cache.Player:getName() then 
		data1.roleId = cache.Player:getRoleId()
	else
		data1.roleId = self.otherid
	end 


	--左边
	local data = {}
	data.tarName = data_.tarAName
	data.tarLvl = data_.tarALvl
	data.tarPower = data_.tarAPower
	data.tarCards = data_.tarACards

	if data.tarName == cache.Player:getName() then 
		data.roleId = cache.Player:getRoleId()
	else
		data.roleId = self.otherid
	end 

	if data.tarName == cache.Player:getName() then
		view:setData(data1,data)
	else
		view:setData(data,data1)
	end 

	mgr.ViewMgr:showView(_viewname.ATHLETICS_COMPARE)
end]]--

function CrossMoBaiView:compareCallBack( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("阵容对比")
	end
end

function CrossMoBaiView:onbtnSetCallBack(  sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("是魔鬼莫迈")
		proxy.Cross:send_123008()
	end 
end

function CrossMoBaiView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CrossMoBaiView