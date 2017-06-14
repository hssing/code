--[[
	阵营战主界面
]]
local CampMain = class("CampMain",base.BaseView)

function CampMain:ctor()
	-- body
	self.allnoice = {}
	self.allnoice.spcInfo = {}
end

function CampMain:init()
	-- body
	self.ShowAll=true
    self.showtype=view_show_type.TOP   
    self.view=self:addSelfView()

    local panle1 = self.view:getChildByName("Panel_1")
    self.panle1 = panle1
    --时间
    self.imgdi = panle1:getChildByName("Image_15_7")
    self.lab_time = self.imgdi:getChildByName("Text_1_0_4")
    --退出
    local btnclose = panle1:getChildByName("Button_2_2")	
    btnclose:addTouchEventListener(handler(self,self.onBtnClose))
    --个人战绩
    self.btnself = panle1:getChildByName("Button_2_2_0")
    self.btnself:addTouchEventListener(handler(self,self.onbtnSelfMsg))	
    --查看阵营
    self.btnsee = panle1:getChildByName("Button_2_2_1")
    self.btnsee:addTouchEventListener(handler(self,self.onbtnSee))
    --动态列表
    self.listview =  panle1:getChildByName("ListView_2")
    local panle2 = self.view:getChildByName("Panel_2")
    self.panle2 = panle2

    self.allpanl = panle1:getChildByName("Panel_3")
    --匹配
    self.btnwar = panle2:getChildByName("Button_1")
    self.btnwar:addTouchEventListener(handler(self,self.onbtnStartCall))
    --制动匹配
    self._checkbox = self.view:getChildByName("CheckBox_2")
    self._checkbox:setSelected(false)
    self._checkbox:addEventListener(handler(self, self.checkBoxCallback))
    --鼓舞
    self.btnguwu = self.view:getChildByName("Button_18")
    self.btnguwu:addTouchEventListener(handler(self,self.onbtnGuwuCallBack))
    -- 匹配计时
    self.imgtime = panle2:getChildByName("Image_5_0") 
    self.imgtime:ignoreContentAdaptWithSize(true)
    self.imgtime:setVisible(false)

    --领先图片
    self.leftimg = self.view:getChildByName("Image_1"):getChildByName("Image_3")
    self.rightimg = self.view:getChildByName("Image_1"):getChildByName("Image_3_0")
    self.leftimg:setVisible(false)
    self.rightimg:setVisible(false)
    --
    local btn = panle1:getChildByName("Button_2_0")
    btn:addTouchEventListener(handler(self,self.onBtnGuize))

    self:initDec()
    G_FitScreen(self,"Image_1")
    self:schedule(self.changeTimes,1.0,"changeTimes")
end

--规则
function CampMain:onBtnGuize(send, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		mgr.ViewMgr:showView(_viewname.GUIZE):showByName(14)
	end 
end

function CampMain:initDec()
	-- body
	self.lab_over = self.panle1:getChildByName("Image_15_7"):getChildByName("Text_1_2")
	self.lab_over:setString(res.str.DEC_ERR_39)
	self.panle1:getChildByName("Text_17"):setString(res.str.DEC_ERR_40)
	local img3 = self.panle1:getChildByName("Image_13")
	for i = 1 , 3 do 
		self["lab_name"..i] = img3:getChildByName("dec_"..i) 
		self["wincount"..i] = img3:getChildByName("value_"..i) 
	end
	self.btnsee:setTitleText(res.str.DEC_ERR_41)

	self.player = {}
	
	local t = {} --正义
	t.name = self.panle2:getChildByName("Text_1_2")
	t.rank = self.panle2:getChildByName("Text_1_0_0")
	t.power = self.panle2:getChildByName("Text_1_1_0")
	table.insert(self.player,t)
	local t = {} --邪恶
	t.name = self.panle2:getChildByName("Text_1")
	t.rank = self.panle2:getChildByName("Text_1_0")
	t.power = self.panle2:getChildByName("Text_1_1")
	table.insert(self.player,t)

	self.view:getChildByName("Text_15"):setString(res.str.DEC_ERR_42)

	self.view:getChildByName("Text_15_0"):setString(res.str.DEC_ERR_43)
	self.view:getChildByName("Text_15_0_1"):setString(res.str.DEC_ERR_44)

	self.max_sha = self.view:getChildByName("Text_15_0_0")
	self.max_sha:setString(string.format(res.str.DEC_ERR_45,0))

	self.cur_sha = self.view:getChildByName("Text_15_0_0_2")
	self.cur_sha:setString(string.format(res.str.DEC_ERR_45,0))

	self.max_win = self.view:getChildByName("Text_15_0_0_0")
	self.max_win:setString(string.format(res.str.DEC_ERR_46,0))

	self.cur_win = self.view:getChildByName("Text_15_0_0_0_0")
	self.cur_win:setString(string.format(res.str.DEC_ERR_53,0))

	self.reward_up = self.view:getChildByName("Text_15_0_0_1")
	self.reward_up:setString("")
	self.reward_down = self.view:getChildByName("Text_15_0_0_1_0")
	self.reward_down:setString("")

	--self.btnguwu:setTitleText()

	self.zs_lab =self.btnguwu:getChildByName("Text_9") 
	self.zs_lab:setString("")
	self.btnguwu:getChildByName("Text_9_0"):setString(res.str.DEC_ERR_47)
	

	--404848
	local bg = self.view:getChildByName("Image_1")
	self.armature =mgr.BoneLoad:createArmature(404848)
	self.armature:setPosition(bg:getContentSize().width/2,bg:getContentSize().height/2 - 90 )
	self.armature:addTo(bg)
	self.armature:getAnimation():playWithIndex(0)
end
--活动倒计时
function CampMain:changeTimes()
	-- body
	self.data.leftTime = self.data.leftTime - 1 
	if self.data.leftTime <= 0 then 
		self.lab_time:setString(res.str.DEC_ERR_48)
		self.lab_over:setVisible(false)
		self.lab_time:setPositionX(self.imgdi:getContentSize().width/2-self.lab_time:getContentSize().width/2)
		self.imgtime:stopAllActions()
		self.imgtime:setVisible(false)
		if self.data.leftTime  == 0 then  --活动结束飘字 --禁用匹配动画 死亡动画  和 匹配相关功能
			self:cancelCall()
			self:setWarStatue(false)
			G_TipsOfstr(res.str.DEC_ERR_73)
			--关闭主界面的入口
			cache.Player:_setCamp(0)

		end
		return 
	end
	self.lab_time:setString(string.formatNumberToTimeString(self.data.leftTime))	
end
--禁用匹配动画 死亡动画
function CampMain:cancelCall(value)
	-- body
	if value then 
		self.data.selfUserInfo.autoMatchStatu = 0
	end
	self.imgtime:stopAllActions()
	self.imgtime:setVisible(false)
end
--设置匹配按钮状态
function CampMain:setWarStatue(flag)
	-- body
	self.btnwar:setTouchEnabled(flag)
	self.btnwar:setBright(flag)
end
---连胜 刷新
function CampMain:initrank( data )
	-- body
	for k, v in pairs(data) do 
		self["lab_name"..k]:setString(v.roleName)
		self["wincount"..k]:setString(string.format(res.str.DEC_ERR_33,v.rankConCout))
	end
end

function CampMain:setinfo()
	-- body
	self.data = cache.Camp:getData()

	local data = self.data.selfUserInfo
	local widget = self.player[data.camp]
	local otherwidget 
	if  data.camp == 1 then 
		widget.name:setString(res.str.DEC_ERR_56..res.str.DEC_ERR_79)
		otherwidget =  self.player[2]
		otherwidget.name:setString(res.str.DEC_ERR_57)
	else
		widget.name:setString(res.str.DEC_ERR_57..res.str.DEC_ERR_79) 
		otherwidget =  self.player[1]
		otherwidget.name:setString(res.str.DEC_ERR_56)
	end
	self.widget = widget
	self.otherwidget = otherwidget


	--鼓舞消耗
	print(data.inspireCount)
	if not self.confGwu then
		self.confGwu = conf.Sys:getValue("camp_inspire_cost")
	end
	self.cost = self.confGwu[data.inspireCount+1]
	if not self.cost then 
		self.cost = self.confGwu[3]
	end
	self.zs_lab:setString(self.cost)

	self.max_sha:setString(string.format(res.str.DEC_ERR_45,data.maxConWinCount)) --最大连杀
	self.cur_sha:setString(string.format(res.str.DEC_ERR_45,data.curConWinCount)) --当前

	self.max_win:setString(string.format(res.str.DEC_ERR_46,data.winCount)) --连赢次数
	self.cur_win:setString(string.format(res.str.DEC_ERR_53,data.loseCount)) --输几次

	--积分 人数
	self.widget.rank:setString(res.str.DEC_ERR_55..self.data.campScore)
	self.widget.power:setString(res.str.DEC_ERR_58..self.data.campPlayerCount)
	self.otherwidget.rank:setString(res.str.DEC_ERR_55..self.data.dfCampScore)
	self.otherwidget.power:setString(res.str.DEC_ERR_58..self.data.dfCampPlayerCount)

	--谁领先
	self.leftimg:setVisible(false)
	self.rightimg:setVisible(false)
	if self.data.campScore < self.data.dfCampScore then 
		if self.data.selfUserInfo.camp  == 1 then 
			self.leftimg:setVisible(true)
		else
			self.rightimg:setVisible(true)
		end
	elseif self.data.campScore > self.data.dfCampScore then
		if self.data.selfUserInfo.camp  == 1 then 
			self.rightimg:setVisible(true)
		else
			self.leftimg:setVisible(true)
		end
	end
end
--设置奖励
function CampMain:setReward()
	-- body
	self.data = cache.Camp:getData()
	self.reward_up:setString(res.str.MONEY_JB..":"..self.data.jb_count) 
	self.reward_down:setString(res.str.MONEY_HZ..":"..self.data.hz_count) 
end
--死亡期间
function CampMain:runDead(time)
	-- body
	self:setWarStatue(false)
	self:cancelCall()
	local i = time
	local lab_ = self.imgtime:getChildByName("AtlasLabel_1")
	function callback()
		-- body
		lab_:setString(i)
		i = i  - 1  
		self.imgtime:setVisible(true)

		if i <= 0 then
			self:cancelCall() --

			if self.data.selfUserInfo.autoMatchStatu and self.data.selfUserInfo.autoMatchStatu>0 then
				self:setWarStatue(false) 
				self:run()
			else
				self:setWarStatue(true)
			end
		end
	end
	--self:setWarStatue(true)
	self.imgtime:loadTexture(res.font.CAMP13)
	self.imgtime:schedule(callback, 1.0)
end

--动画
function CampMain:run( ... )
	-- body
	self:setWarStatue(false)
	self:cancelCall()
	local i = 1
	local lab_ = self.imgtime:getChildByName("AtlasLabel_1")
	function callback()
		-- body
		lab_:setString(i)
		i = i  + 1  
		self.imgtime:setVisible(true)
	end
	self.imgtime:loadTexture(res.font.CAMP5)
	self.imgtime:schedule(callback, 1.0)
end

--鼓舞信息
function CampMain:setGuwu(data)
	-- body
	self.data.selfUserInfo.inspireCount = data.inspire 
	self.cost = self.confGwu[data.inspire+1]
	if not self.cost then 
		self.cost = self.confGwu[3]
	end
	self.zs_lab:setString(self.cost)
end

function CampMain:stopSomething( data_,	flag )
	-- body
	if not self.data   then
		return 
	end

	if cache.Camp:getSelfWin() then 
		self:setWarStatue(false)
		self:run()
	else
		self:setWarStatue(false)
		self:runDead(20) --死亡倒计时
	end

	if data_ and  #data_.vsUserInfo ~= 2 then
	end 

	if data_ and #data_.vsUserInfo == 2 then 
		local view = mgr.ViewMgr:showView(_viewname.CAMP_OVER)
		view:setData(data_)
		self:setinfo()
	else
		self.btnwar:setTouchEnabled(true)
		self.btnwar:setBright(true)
	end
end

--全副信息
function CampMain:keepAllnotice(data_,flag)
	-- body
	self.allnoice = {}
	self.allnoice.spcInfo  = data_.spcInfo
	--self:setNotice(1)
end
--个人信息
function CampMain:keepSelfNotice( data_ )
	-- body
	self.selfnoice = {}
	self.selfnoice  = data_
	self:setNotice(2)
end
--单条个人信息
function CampMain:addEvent( str )
	-- body
	if self.page == 2 then 
		self:initItem(str)
	end
	self.listview:refreshView()
	self.listview:jumpToBottom()
end

function CampMain:setData()
	-- body
	self.data = cache.Camp:getData()
	self.confGwu = conf.Sys:getValue("camp_inspire_cost") --鼓舞消耗
	self.confGwu_limite = conf.Sys:getValue("camp_inspire") --鼓舞上限


	--连胜 刷新
	self:initrank(self.data.topWinner)
	--计时倒计时
	self:changeTimes()

	--设置正义邪恶的积分 人数
	local data = self.data.selfUserInfo
	local widget = self.player[data.camp]
	local otherwidget 
	if  data.camp == 1 then 
		widget.name:setString(res.str.DEC_ERR_56..res.str.DEC_ERR_79)
		otherwidget =  self.player[2]
		otherwidget.name:setString(res.str.DEC_ERR_57)
	else
		widget.name:setString(res.str.DEC_ERR_57..res.str.DEC_ERR_79) 
		otherwidget =  self.player[1]
		otherwidget.name:setString(res.str.DEC_ERR_56)
	end
	self.widget = widget
	self.otherwidget = otherwidget

	self:setinfo() --设置个人信息
	self:setReward()
	--进入时的状态
	self:cancelCall()
	self:setWarStatue(true)
	if self.data.dieTime > 0 then  --在死亡期间
		self:runDead(self.data.dieTime)
	elseif data.autoMatchStatu and data.autoMatchStatu > 0 then --自动匹配
		self:setWarStatue(false) 
		self:run()
	elseif data.matchStatu > 0 then --在匹配状态
		self:setWarStatue(false) 
		self:run()
	end 
	--设置复选框的状态
	if data.autoMatchStatu and data.autoMatchStatu>0 then
		self._checkbox:setSelected(true)
	else
		self._checkbox:setSelected(false)
	end
	
	--self:setNotice(self.page)
	self:warCallBack()
	self.page = 1
end

function CampMain:warCallBack()
	local page = cache.Camp:getPage()
	if page == 2 then
		
		self:onbtnSelfMsg(self.btnself, ccui.TouchEventType.ended)
	else
		self.listview:setVisible(false)
		self.allpanl:setVisible(true) 
		local c_data =cache.Camp:getNoticeAll()
		if c_data and c_data.spcInfo and  #c_data.spcInfo > 0 then 
			self:keepAllnotice(c_data,true)
		end
		self:repeatWord()
	end 
end

function CampMain:addtoItem(data_)
	-- body
	local richtext = G_RichText(data_)
	richtext:setAnchorPoint(cc.p(0.5,0.5))
	self.listview:pushBackCustomItem(richtext)
end

function CampMain:initItem(v,flag)
	local ccsize = self.listview:getContentSize()
	local c1 = {255,255,255} --白色
	local c2 = {255,95,5}--正义名字
	local c3 = {45,236,253}--邪恶
	local c4 = {18,255,0}--绿色
	local function getColorBy(camp)
		if tonumber(camp) == 1 then 
			return c2
		else
			return c3
		end
	end
	local function getSize(str)
		-- body
		local label = display.newTTFLabel({
		    text = str,
		    font = res.ttf[1],
		    size = 20,
		    align = cc.TEXT_ALIGNMENT_LEFT,
		    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
		    dimensions = cc.size(ccsize.width*0.95, 0)
		})
		return  label:getContentSize().height
	end

	-- body
	local t = string.split(v, "#")
	local id = tonumber(t[1])
	local conf = conf.Camp:getItem(id)
	local str = string.split(conf, "#")
	local params_ = {text = {}, width=ccsize.width*0.95, height=0}
	if id == 50101 then 
		params_.text[#params_.text+1] = {t[2].."  ",c1,20}
		params_.text[#params_.text+1] = {"["..t[3].."]",getColorBy(t[4]),20}
		params_.text[#params_.text+1] = {str[2],c1,20}
		params_.text[#params_.text+1] = {"["..t[5].."]",getColorBy(t[6]),20}
		params_.text[#params_.text+1] = {str[3],c1,20}
		params_.text[#params_.text+1] = {t[7],c4,20}
		params_.text[#params_.text+1] = {str[4],c1,20}
		params_.text[#params_.text+1] = {t[8],c4,20}
		params_.text[#params_.text+1] = {str[5],c1,20}
		params_.text[#params_.text+1] = {t[9],c4,20}
		params_.text[#params_.text+1] = {str[6],c1,20}
	elseif  id == 50102 then 
		params_.text[#params_.text+1] = {t[2].."  ",c1,20}
		params_.text[#params_.text+1] = {"["..t[3].."]",getColorBy(t[4]),20}
		params_.text[#params_.text+1] = {str[2],c1,20}
		params_.text[#params_.text+1] = {"["..t[5].."]",getColorBy(t[6]),20}
		params_.text[#params_.text+1] = {str[3],c1,20}
		params_.text[#params_.text+1] = {t[7],c4,20}
		params_.text[#params_.text+1] = {str[4],c1,20}
		params_.text[#params_.text+1] = {t[8],c4,20}
		params_.text[#params_.text+1] = {str[5],c1,20}
		params_.text[#params_.text+1] = {t[9],c4,20}
		params_.text[#params_.text+1] = {str[6],c1,20}
	elseif id == 50103 then 
		params_.text[#params_.text+1] = {t[2].."  ",c1,20}
		params_.text[#params_.text+1] = {"["..t[3].."]",getColorBy(t[4]),20}
		params_.text[#params_.text+1] = {str[2],c1,20}
		params_.text[#params_.text+1] = {"["..t[5].."]",getColorBy(t[6]),20}
		params_.text[#params_.text+1] = {str[3],c1,20}
		params_.text[#params_.text+1] = {t[7],c4,20}
		params_.text[#params_.text+1] = {str[4],c1,20}
		params_.text[#params_.text+1] = {t[8],c4,20}
		params_.text[#params_.text+1] = {str[5],c1,20}
	elseif id == 50104 then
		params_.text[#params_.text+1] = {t[2].."  ",c1,20}
		params_.text[#params_.text+1] = {"["..t[3].."]",getColorBy(t[4]),20}
		params_.text[#params_.text+1] = {str[2],c1,20}
		params_.text[#params_.text+1] = {"["..t[5].."]",getColorBy(t[6]),20}
		params_.text[#params_.text+1] = {str[3],c1,20}
		params_.text[#params_.text+1] = {t[7],c4,20}
		params_.text[#params_.text+1] = {str[4],c1,20}
		params_.text[#params_.text+1] = {t[8],c4,20}
		params_.text[#params_.text+1] = {str[5],c1,20}
	elseif id == 50105 then
		params_.text[#params_.text+1] = {t[2].."  ",c1,20}
		params_.text[#params_.text+1] = {"["..t[3].."]",getColorBy(t[4]),20}
		params_.text[#params_.text+1] = {str[2],c1,20}
		params_.text[#params_.text+1] = {"["..t[5].."]",c4,20}
		params_.text[#params_.text+1] = {str[3],c1,20}
		params_.text[#params_.text+1] = {"["..t[6].."]",c4,20}
		params_.text[#params_.text+1] = {str[4],c1,20}
	end 
	-- 左对齐，并且多行文字顶部对齐
	local lab_str = ""
	for k ,v in pairs(params_.text) do 
		lab_str = lab_str .. v[1]
	end
	params_.height = getSize(lab_str)
	if not flag then 
		self:addtoItem(params_)
	else
		return params_
	end

end
--flag 战斗场景出来
function CampMain:setNotice(page,flag)
	-- body
	if page then 
		if page ~= self.page and not flag then 
			print("*****")
			return 
		end
	end

	self.listview:removeAllItems()
	local data_  = {}
	data_.spcInfo = {}
	if self.page == 1 then 

		if self.allnoice and self.allnoice.spcInfo then 
			data_ = self.allnoice
		end 
		
	else
		if self.selfnoice then 
			data_.spcInfo = self.selfnoice.events
		end
		
	end
	
	local ccsize = self.listview:getContentSize()
	local c1 = {255,255,255} --白色
	local c2 = {255,95,5}--正义名字
	local c3 = {45,236,253}--邪恶
	local c4 = {18,255,0}--绿色

	local function getColorBy(camp)
		if tonumber(camp) == 1 then 
			return c2
		else
			return c3
		end
	end

	local function getSize(str)
		-- body
		local label = display.newTTFLabel({
		    text = str,
		    font = res.ttf[1],
		    size = 20,
		    align = cc.TEXT_ALIGNMENT_LEFT,
		    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
		    dimensions = cc.size(ccsize.width*0.95, 0)
		})
		return  label:getContentSize().height
	end
	--printt(data_)
	if not data_ or #data_.spcInfo == 0 then
		local params_ = {text = {}, width=ccsize.width*0.99, height=0}
		params_.text[#params_.text+1] = {res.str.DEC_ERR_70,c1,20}
		params_.height = getSize(res.str.DEC_ERR_70)
		self:addtoItem(params_)
		return 
	end
	for k ,v in pairs(data_.spcInfo) do 
		self:initItem(v)
	end

	self.listview:refreshView()
	self.listview:jumpToBottom()
end


--循环的全服动态
function CampMain:repeatWord()
	-- body
	if not self.allnoice or not self.allnoice.spcInfo then
		--return 
	end

	--print("----------------------------------------------------**********-------")
	--printt(self.allnoice)

	local panle_in = self.allpanl
	--panle_in:removeAllChildren()

	local panle_move =  ccui.Layout:create()
	panle_move:setContentSize(panle_in:getContentSize())
	--panle_move:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
   	--panle_move:setBackGroundColor(cc.c3b(0, 0, 0))
   	panle_move:setPosition(0,-panle_in:getContentSize().height)
	panle_move:addTo(panle_in)

	local posx = 0
	local posy = panle_move:getContentSize().height

	if #self.allnoice.spcInfo == 0 then
		local label = display.newTTFLabel({
		    text = res.str.DEC_ERR_70,
		    font = res.ttf[1],
		    size = 20,
		    --color = ,
		    align = cc.TEXT_ALIGNMENT_LEFT,
		    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
		    dimensions = cc.size(panle_move:getContentSize().width*0.9, 0), 
		})
		label:setAnchorPoint(cc.p(0,1))
		label:setPosition(posx,posy)
		
		panle_move:setPositionY(0)
		label:addTo(panle_move)

		posy = posy - label:getContentSize().height

		panle_move:performWithDelay(function( ... )
			-- body
			panle_move:removeSelf()
			self:repeatWord()
		end, 5.0)
		return 
	else
		for i = 1 , #self.allnoice.spcInfo do 
			local data = self:initItem(self.allnoice.spcInfo[i],true)
			local richtext = G_RichText(data)
			richtext:setAnchorPoint(cc.p(0  ,0.5))
			richtext:setPosition(posx - panle_move:getContentSize().width/2 + 15 ,posy)
			richtext:addTo(panle_move)
			posy = posy - data.height - 10
		end
	end

	--if posy < 0 then 
		local distance =  math.abs(posy) + panle_in:getContentSize().height*2
		local time =(distance ) / 30  
		local time2 =  (distance - panle_in:getContentSize().height*0.8)/30
		local a1 = cc.MoveTo:create(time, cc.p(panle_move:getPositionX(),panle_move:getPositionY()+distance
			+panle_in:getContentSize().height/2))
		local a2 = cc.CallFunc:create(function ( ... )
			-- body
			panle_move:removeSelf()
			
		end)


		local sequence = cc.Sequence:create(a1,a2)
		--panle_move:runAction(cc.RepeatForever:create(sequence))
		panle_move:runAction(sequence)

		panle_move:performWithDelay(function( ... )
			-- body
			self:repeatWord()
		end, time2)
	--end 
end

function CampMain:onbtnGuwuCallBack(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		--debugprint("鼓舞")
		if self.data.selfUserInfo.inspireCount == self.confGwu_limite[1] then
			G_TipsOfstr(res.str.DEC_ERR_62)
		elseif G_BuyAnything(2, self.cost) then 
			proxy.Camp:send120105()
			mgr.NetMgr:wait(520105)
		end		
	end
end

--自动匹配复选
function CampMain:checkBoxCallback( sender_, eventtype )
	-- body
	if cache.Player:getVip()<3 and cache.Player:getLevel() < tonumber(conf.Sys:getValue("level_zhenying_auto")) then 
		local data = {};
    	data.richtext = {
			{text=res.str.DEC_ERR_49,fontSize=24,color=cc.c3b(255,255,255)},
			{text=res.str.DEC_ERR_80,fontSize=24,color=cc.c3b(255,0,0)},
		}

    	data.sure = function( ... )
    		-- body
    		self:onCloseSelfView()
    		G_GoReCharge()
    	end
    	data.cancel = function ( ... )
    		-- body
    	end
   		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,true)

   		self._checkbox:setSelected(false)
   		return 
	end

	if eventtype == ccui.CheckBoxEventType.selected then
		--按下
		if self.data.selfUserInfo.autoMatchStatu == 0 then 
			local data = {isMatch = 1,matchType = 1}
			self:run()
			proxy.Camp:send120104(data)
			mgr.NetMgr:wait(520104)
		end 
	else
		if self.data.selfUserInfo.autoMatchStatu > 0 then 
			local data = {isMatch = 0,matchType = 1}
			proxy.Camp:send120104(data)
			mgr.NetMgr:wait(520104)
		end 
	end
end

function CampMain:onbtnStartCall( sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local data = {isMatch = 1}
		if self._checkbox:isSelected() then 
			data.matchType = 1
		else
			data.matchType = 0
		end  
		proxy.Camp:send120104(data)
		self:setWarStatue(false)
		self:run()
	end
end

function CampMain:onbtnSee( sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("查看阵营")
		local data = {type = 0,page = 1}
		proxy.Camp:send120103(data)
		
	end
end

function CampMain:onbtnSelfMsg(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		--debugprint("个人战绩")
		if self.page == 1 then 
			self.page = 2
			proxy.Camp:sendMsg120108()
			mgr.NetMgr:wait(520108)
			self.panle1:getChildByName("Text_17"):setString(res.str.DEC_ERR_71)

			self.listview:setVisible(true)
			self.allpanl:setVisible(false) 
		else
			self.listview:setVisible(false)
			self.allpanl:setVisible(true) 

			self.page = 1 
			self:setNotice(self.page)
			self.panle1:getChildByName("Text_17"):setString(res.str.DEC_ERR_40)
		end
		cache.Camp:keepPage(self.page)
		
	end
end

function CampMain:onBtnClose(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end
function CampMain:onCloseSelfView()
	-- body
	cache.Camp:keepPage(1)
	proxy.Camp:sendMsg120107()
	self:closeSelfView()
	local view = mgr.ViewMgr:get(_viewname.FUNBENVIEW)
	if view then 
		local scene =  mgr.SceneMgr:getMainScene()
	    if scene then 
	        scene:addHeadView()
	    end 
	end 
	mgr.SceneMgr:getMainScene():changePageView(5)
end
return CampMain