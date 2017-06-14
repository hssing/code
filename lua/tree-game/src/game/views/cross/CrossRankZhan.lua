
local CrossRankZhan = class("CrossRankZhan",base.BaseView)

function CrossRankZhan:init( ... )
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local btn = self.view:getChildByName("Button_24")
	self.btn1 = btn

	local imgdi = self.view:getChildByName("Image_2")
	self.imgdi = imgdi

	--排位显示
	local imgpaiwei = imgdi:getChildByName("Image_212_0")
	self.imgpaiwei = imgpaiwei

	self.listview = imgdi:getChildByName("ListView_2")
	self.clone_video = self.view:getChildByName("Panel_7_0")
	self.clone_rank = self.view:getChildByName("Panel_79")

	self:initDec()
	proxy.Cross:send_123003()
	G_FitScreen(self,"Image_1")
end

function CrossRankZhan:initDec()
	self.btn1:setTitleText(res.str.RES_RES_18)

	--个人战绩
	self.imgpaiwei:getChildByName("Text_1"):setString(res.str.RES_RES_24)
	self.lab_rank =  self.imgpaiwei:getChildByName("Text_1_0")
	self.lab_rank:setString("")
end 


---排行
function CrossRankZhan:initRank()
	-- body
	self.lab_rank:setString(self.data.selfRank)
	if self.data.selfRank > 20 then
		self.lab_rank:setString(res.str.RES_RES_51)
	end

	table.sort(self.data.rankList,function(a,b)
		-- body
		return a.index < b.index
	end)

	for k,v in pairs(self.data.rankList) do 
		local widget = self.clone_rank:clone()
		self.listview:pushBackCustomItem(widget)

		local imgRank = widget:getChildByName("Image_221_0")
		local lab_rank = widget:getChildByName("AtlasLabel_1")

		imgRank:setVisible(false)
		lab_rank:setVisible(false)
		if v.index <= 3 then 
			imgRank:setVisible(true)
			imgRank:loadTexture(res.icon.RANK[v.index])
		else
			lab_rank:setVisible(true)
			lab_rank:setString(v.index)
		end 
		local temp = G_Split_Back(v.roleIcon)

		local frame =  widget:getChildByName("Image_42")
		--frame:loadTexture(G_getChatPlayerFrameIcon(v.power))
		frame:loadTexture(frame.frame_img)

		local spr =frame:getChildByName("Image_43_29")
		spr:setScale(0.8)
		spr:ignoreContentAdaptWithSize(true)
		local role_icon = G_GetHeadIcon(v.roleIcon)
		spr:loadTexture(temp.icon_img)
		--vipLevel
		local img_vip = widget:getChildByName("Image_221_0_1")
		img_vip:loadTexture(res.icon.VIP_LV[v.vipLevel])

		local str = string.split(v.roleName, ".")

		local s_name =  widget:getChildByName("Text_186")
		s_name:setString(str[1] or "")

		local p_name =  widget:getChildByName("Text_186_1")
		p_name:setFontName(display.DEFAULT_TTF_FONT)
		p_name:setFontSize(20)
		p_name:setString(str[2] or "")


		local weizhi = widget:getChildByName("Text_186_0") 
		local conf_data =conf.Cross:getDwItem(v.roleDw)
		weizhi:setString(conf_data.name)

		local lab_power = widget:getChildByName("Text_186_0_0")
		lab_power:setString(v.power)

		local btn = widget:getChildByName("Button_2_0_20")
		btn.roleId = v.roleId
		btn:addTouchEventListener(handler(self,self.onbtnSee))

		--盛典
		local lab_sd = widget:getChildByName("Text_186_0_0_0")
		lab_sd:setString(v.pointShu)
		--btn:setVisible(false)
	end
end


function CrossRankZhan:setData(data_)
	-- body
	self.data = data_
	self:initRank()
end

function CrossRankZhan:comPareCalllBack( data_ )
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

	local name = string.split(data1.tarName, ".")

	if name[2] == cache.Player:getName() then 
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

	local name = string.split(data.tarName, ".")
	if name[2] == cache.Player:getName() then 
		data.roleId = cache.Player:getRoleId()
	else
		data.roleId = self.otherid
	end 

	if name[2] == cache.Player:getName() then
		view:setData(data1,data,1)
	else
		view:setData(data,data1,1)
	end 

	mgr.ViewMgr:showView(_viewname.ATHLETICS_COMPARE)
end

function CrossRankZhan:onbtnSee( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		if cache.Player:getRoleId().key == send.roleId.key then 
			G_TipsOfstr(res.str.CONTEST_DEC27)
			return 
		end 
		self.otherid = send.roleId
		local param = {tarAId =  cache.Player:getRoleId(), tarBId =  self.otherid,tarType = 1 }
		proxy.Cross:send_123005(param)
		--proxy.Contest:sendCompare(param)
		--mgr.NetMgr:wait(501201)
	end
end
function CrossRankZhan:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CrossRankZhan

