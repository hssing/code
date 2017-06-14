--[[
	排位战绩
]]
local CrossRankView = class("CrossRankView",base.BaseView)

function CrossRankView:ctor()
	-- body
end

function CrossRankView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.PageButton=gui.PageButton.new()--创建分页按钮管理器
	self.PageButton:setBtnCallBack(handler(self,self.onPageButtonCallBack))

	local btn = self.view:getChildByName("Button_24")
	self.PageButton:addButton(btn)
	self.btn1 = btn

	local btn1 = self.view:getChildByName("Button_24_0")
	btn1:setVisible(false)
	self.PageButton:addButton(btn1)
	self.btn2 = btn1

	local imgdi = self.view:getChildByName("Image_2")
	self.imgdi = imgdi
	---跨服现实
	local imgkuafu = imgdi:getChildByName("Image_212_1")
	self.imgkuafu = imgkuafu
	--排位显示
	local imgpaiwei = imgdi:getChildByName("Image_212_0")
	self.imgpaiwei = imgpaiwei

	self.listview = imgdi:getChildByName("ListView_2")
	self.clone_video = self.view:getChildByName("Panel_7_0")
	self.clone_rank = self.view:getChildByName("Panel_79")

	self:initDec()
	self.PageButton:initClick(1)

	G_FitScreen(self,"Image_1")

	
end

function CrossRankView:initDec()
	-- body
	self.imgpaiwei:setVisible(false)
	self.btn1:setTitleText(res.str.RES_RES_17)
	self.btn2:setTitleText(res.str.RES_RES_18)

	self.imgkuafu:getChildByName("Text_2"):setString(res.str.RES_RES_19)
	self.imgkuafu:getChildByName("Text_2_1"):setString(res.str.RES_RES_20)
	self.imgkuafu:getChildByName("Text_2_0"):setString(res.str.RES_RES_21)
	self.imgkuafu:getChildByName("Text_2_1_0"):setString(res.str.RES_RES_22)

	self.lab_cur = self.imgkuafu:getChildByName("Text_2_2")
	self.lab_cur:setString("")

	self.lab_next = self.imgkuafu:getChildByName("Text_2_2_1")
	self.lab_next:setString("")

	self.lab_shang = self.imgkuafu:getChildByName("Text_2_2_0")
	self.lab_shang:setString("")

	self.lab_reward = self.imgkuafu:getChildByName("Text_2_2_1_0")
	self.lab_reward:setString("")
	--个人战绩
	self.imgpaiwei:getChildByName("Text_1"):setString(res.str.RES_RES_24)
	self.lab_rank =  self.imgpaiwei:getChildByName("Text_1_0")
	self.lab_rank:setString("")
end
-----录像
function CrossRankView:initVideo()
	-- body
	local conf_data =conf.Cross:getDwItem(self.data.roleDw)
	if conf_data then
		self.lab_cur:setString(conf_data.name)
	else
		self.lab_cur:setString("")
	end
	
	local conf_data_next =conf.Cross:getDwItem(self.data.roleDw+1)
	if conf_data_next then
		self.lab_next:setString(conf_data_next.name)
		self.lab_reward:setString(conf_data_next.award_zs)
	else
		self.lab_next:setString("")
		self.lab_reward:setString("")
	end

	local conf_data_shang =conf.Cross:getDwItem(self.data.preDw)
	if conf_data_shang then
		self.lab_shang:setString(conf_data_shang.name)
	else
		self.lab_shang:setString("")
	end

	table.sort(self.data.logList,function(a,b )
		-- body
		return a.createTime > b.createTime
	end)
	
	for k,v in pairs(self.data.logList) do 
		local widget = self.clone_video:clone()
		self.listview:pushBackCustomItem(widget)

		local img_left = widget:getChildByName("Image_60_29") 
		local lab_name_1 = widget:getChildByName("Text_22_24_17")
		lab_name_1:setFontName(display.DEFAULT_TTF_FONT)
		lab_name_1:setFontSize(20)
		lab_name_1:setString(v.selfName)

		local img_right = widget:getChildByName("Image_60_1_33") 
		local lab_name_2 = widget:getChildByName("Text_22_24_0_19")
		lab_name_2:setFontName(display.DEFAULT_TTF_FONT)
		lab_name_2:setFontSize(20)
		lab_name_2:setString(v.tarName)

		local lab_dec = widget:getChildByName("Text_22_24_1_21")
		lab_dec:setString(res.str.RES_RES_33) 
		local lab_win =  widget:getChildByName("Text_22_24_1_21_0")

		if v.selfWin == 1 then
			img_left:loadTexture(res.font.WIN)
			img_right:loadTexture(res.font.LOSE)

			lab_win:setColor(COLOR[2])
			lab_win:setString("+"..v.selfPoint)
		else
			img_left:loadTexture(res.font.LOSE)
			img_right:loadTexture(res.font.WIN)

			lab_win:setColor(COLOR[6])
			lab_win:setString(v.selfPoint)
		end

		if v.selfPoint == -1 then --定级赛
			lab_win:setString("")
			local str = string.gsub(res.str.RES_RES_05," ","")
			lab_dec:setString(str)
		elseif v.selfPoint == -2 then --晋级赛
			lab_win:setString("")
			local str = string.gsub(res.str.RES_RES_42," ","")
			lab_dec:setString(str)
		end
	end
end
---排行
function CrossRankView:initRank()
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
		--btn:setVisible(false)
	end
end
---
function CrossRankView:initListView()
	-- body --self.ListView:pushBackCustomItem(widget)
	self.listview:removeAllChildren()
	self.imgpaiwei:setVisible(false)
	self.imgkuafu:setVisible(false)
	--
	if self.pageindex == 1 then
		--显示录像
		self.imgkuafu:setVisible(true)
		self:initVideo()
	else
		--显示排位
		self.imgpaiwei:setVisible(true)
		self:initRank()
	end
end

function CrossRankView:setData(data_)
	-- body
	self.data = data_
	self:initListView()
end


function CrossRankView:comPareCalllBack( data_ )
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
	data1.huoban = data_.tarBXhbs
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
	data.huoban = data_.tarAXhbs
	if data.tarName == cache.Player:getName() then 
		data.roleId = cache.Player:getRoleId()
	else
		data.roleId = self.otherid
	end 

	if data.tarName == cache.Player:getName() then
		view:setData(data1,data,1)
	else
		view:setData(data,data1,1)
	end 

	mgr.ViewMgr:showView(_viewname.ATHLETICS_COMPARE)
end

function CrossRankView:onbtnSee( send,eventtype )
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

function CrossRankView:onPageButtonCallBack(index,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		self.pageindex = index
		if index == 1 then
			proxy.Cross:send_123002()
		elseif index == 2 then
			proxy.Cross:send_123003()
		end
		--self:initListView()
		return self
	end
end

function CrossRankView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CrossRankView