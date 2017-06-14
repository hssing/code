--[[
	祈福
]]
local head_path = "res/views/ui_res/icon/"
local end_type = ".png"
local GuildQifu=class("GuildQifu",base.BaseView)

--[[local word = {
	normal = { --什么都不做说的话
		{"黑色18号字体#0,0,0#18","红色20号字体#255,0,0#20"},
		{"绿18号字体#0,255,0#18","蓝色20号字体#0,0,255#20"},
	},
	yanfa ={ --研发后说的话
		{"黑色18号字体#0,0,0#18","红色20号字体#255,0,0#20"},
		{"绿18号字体#0,255,0#18","蓝色20号字体#0,0,255#20"},
	}
}]]--

function GuildQifu:init()
	-- body
	--消除红点
	

	proxy.guild:sendQifumsg()

	self.bottomType = 2
	self.ShowAll=true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	local panel_up = self.view:getChildByName("Panel_16") 
	--公会名字
	self.lab_name = panel_up:getChildByName("Text_1")
	--vip icon
	self.vip = panel_up:getChildByName("Image_117_7_0_0")
	--self.vip:ignoreContentAdaptWithSize(true)
	--self.vip:loadTexture(res.icon.GUILD_LV_DI)
	self.lab_lv = self.vip:getChildByName("AtlasLabel_1")
	--[[self.lab_lv = cc.LabelAtlas:_create("10",res.font.FLOAT_NUM[4],20,21,string.byte("0"))
	self.lab_lv:setAnchorPoint(0.5,0.5)
	self.lab_lv:setPosition(self.vip:getContentSize().width/2,self.vip:getContentSize().height/2)
	self.lab_lv:addTo(self.vip)]]--
	--loadbar lv 
	self.loadbar_lv = panel_up:getChildByName("LoadingBar_1")
	self.loadbar_exp = panel_up:getChildByName("Text_1_1")
	--徽章
	self.lab_hz = panel_up:getChildByName("Text_1_0")
	--规则
	local btnguize = panel_up:getChildByName("Button_23_2")
	btnguize:addTouchEventListener(handler(self, self.onBtnGuize))
	--祈福进度
	self.loadbar_qi = panel_up:getChildByName("LoadingBar_3")
	--4个箱子
	self.img_xiang = {}
	local img1 =  self.loadbar_qi:getChildByName("Image_117_7_0_0_0")
	img1:setTouchEnabled(true)
	table.insert(self.img_xiang,img1)

	local img2 =  self.loadbar_qi:getChildByName("Image_117_7_0_0_0_0")
	img2:setTouchEnabled(true)
	table.insert(self.img_xiang,img2)

	local img3 =  self.loadbar_qi:getChildByName("Image_117_7_0_0_0_1")
	img3:setTouchEnabled(true)
	table.insert(self.img_xiang,img3)

	local img4 =  self.loadbar_qi:getChildByName("Image_117_7_0_0_0_2")
	img4:setTouchEnabled(true)
	table.insert(self.img_xiang,img4)

	--当前祈福进度
	self.loadbar_qi_count =   panel_up:getChildByName("Text_1_0_0_0")
	--self.qifujingdu =  panel_up:getChildByName("Text_1_0_0_0")
	
	--祈福人数
	self.qf_count =  panel_up:getChildByName("Text_1_0_0_0_0")
	self.lab_qf_count =  self.qf_count:clone()
	self.lab_qf_count:setString("")
	self.lab_qf_count:addTo(panel_up)
	--------------------------------------------------------------------
	--3种类型的祈福
	self.img_qf_type = {}
	local panel_3 = self.view:getChildByName("Panel_3") 

	--self.btnqifu =panel_3:getChildByName("Button_1")
	--self.btnqifu:addTouchEventListener(handler(self, self.onbtnqifu))

	local img = panel_3:getChildByName("Image_18")
	local t = {}
	t.img = img
	t.jingdu =img:getChildByName("Text_8_0") --进度
	t.exp = img:getChildByName("Text_8_0_0") --经验
	t.gongxian = img:getChildByName("Text_8_0_1") --贡献

	t.costtype = img:getChildByName("Image_21") --消耗货币类型
	t.cost = img:getChildByName("Text_8_0_1_0") --消耗多少
	t.donecost = img:getChildByName("Image_21_0_0") --完成图片
	--t.yuan = img:getChildByName("Image_21_0") --打个勾的底图
	table.insert(self.img_qf_type,t)

	local img = panel_3:getChildByName("Image_18_0")
	local t = {}
	t.img = img
	t.jingdu =img:getChildByName("Text_8_0_5") --进度
	t.exp = img:getChildByName("Text_8_0_0_10") --经验
	t.gongxian = img:getChildByName("Text_8_0_1_14") --贡献

	t.costtype = img:getChildByName("Image_21_8") --消耗货币类型
	t.cost = img:getChildByName("Text_8_0_1_0_16") --消耗多少
	t.donecost = img:getChildByName("Image_21_0_0_12") --完成图片
	--t.yuan = img:getChildByName("Image_21_0_10") --打个勾的底图
	table.insert(self.img_qf_type,t)

	local img = panel_3:getChildByName("Image_18_1")
	local t = {}
	t.img = img
	t.jingdu =img:getChildByName("Text_8_0_20") --进度
	t.exp = img:getChildByName("Text_8_0_0_24") --经验
	t.gongxian = img:getChildByName("Text_8_0_1_28") --贡献

	t.costtype = img:getChildByName("Image_21_23") --消耗货币类型
	t.cost = img:getChildByName("Text_8_0_1_0_30") --消耗多少
	t.donecost = img:getChildByName("Image_21_0_0_27") --完成图片
	--t.yuan = img:getChildByName("Image_21_0_25") --打个勾的底图
	table.insert(self.img_qf_type,t)

	-- self.wordimgd  self.lab_words self.imgtiannv
	self.wordimgd = self.view:getChildByName("Image_3")
	self.lab_words = self.wordimgd:getChildByName("Text_2")
	self.lab_words:setFontSize(12)
	self.imgtiannv = self.view:getChildByName("Image_2")

	self:initData()

	G_FitScreen(self,"Image_1")
	self:performWithDelay(function()
			self:palyForever()
			local effConfig = conf.Effect:getInfoById(404831)
			mgr.BoneLoad:addLoad(effConfig.effect_id,function()
			end)
	end, 0.1)

	self:initDec()
end

function GuildQifu:initDec()
	-- body
	local Panel_16 = self.view:getChildByName("Panel_16")
	Panel_16:getChildByName("Button_23_2"):setTitleText(res.str.GUILD_DEC_36)
	Panel_16:getChildByName("Text_1_0_0"):setString(res.str.GUILD_DEC_37)
	Panel_16:getChildByName("Text_1_0_0_1"):setString(res.str.GUILD_DEC_38)

	local Panel_3 = self.view:getChildByName("Panel_3") 
	local Image_18 = Panel_3:getChildByName("Image_18")
	Image_18:getChildByName("Text_8"):setString(res.str.GUILD_DEC_39)
	Image_18:getChildByName("Text_8_1"):setString(res.str.GUILD_DEC_40)
	Image_18:getChildByName("Text_8_2"):setString(res.str.GUILD_DEC_41)

	local Image_18_0 = Panel_3:getChildByName("Image_18_0")
	Image_18_0:getChildByName("Text_8_3"):setString(res.str.GUILD_DEC_39)
	Image_18_0:getChildByName("Text_8_1_7"):setString(res.str.GUILD_DEC_40)
	Image_18_0:getChildByName("Text_8_2_12"):setString(res.str.GUILD_DEC_41)

	local Image_18_1 = Panel_3:getChildByName("Image_18_1")
	Image_18_1:getChildByName("Text_8_18"):setString(res.str.GUILD_DEC_39)
	Image_18_1:getChildByName("Text_8_1_22"):setString(res.str.GUILD_DEC_40)
	Image_18_1:getChildByName("Text_8_2_26"):setString(res.str.GUILD_DEC_41)

	

end

function GuildQifu:palyForever( ... )
	-- body
	local params =  {id=404833, x=display.cx,y = display.cy,addTo=self.view,endCallFunc=nil,
	playIndex = 0} 
	mgr.effect:playEffect(params)
end

function GuildQifu:say( status )
	-- body
	self.wordimgd:stopAllActions()
	local ccsize = self.lab_words:getContentSize() 

	local a1 = cc.DelayTime:create(3)

	local scale = cc.ScaleTo:create(0.8,1)
    local act = cc.EaseElasticOut:create(scale)


	local a2 = cc.CallFunc:create(function()
		-- body
		if status ~="normal" then 
			status = "normal"
		end
	end)

	local a_fistr = cc.CallFunc:create(function()
		-- body
		--printt(self.word[status])
		--print(math.random(#self.word[status]))
		self.lab_words:removeAllChildren()
		--[[local str = word[status][math.random(#word[status])]
		local params_ = {}
		params_.width = ccsize.width
		height=0
		for k ,v in pairs(str) do 
			local t = string.split(v, "#")
			if not params_.text then 
				params_.text = {}
			end 


			local t2 =   string.split(t[2], ",")
			
			local data = {}
			data[1] =t[1]
			data[2] = { t2[1],t2[2],t2[3] }
			data[3] = t[3]

			table.insert(params_.text,data)
		end 

	

		local richtext = G_RichText(params_)
		richtext:setPosition(-ccsize.width/2,ccsize.height)
		richtext:addTo(self.lab_words)]]--
		self.wordimgd:setVisible(true)
		self.lab_words:setVisible(true)


		if self.data and self.data.qfInfos and  #self.data.qfInfos>0 then 
			self.lab_words:setString(self.data.qfInfos[math.random(#self.data.qfInfos)])
			self.lab_words:setFontSize(12)
		else
			self.lab_words:setString(res.str.GUILD_DEC43)
			self.lab_words:setFontSize(20)
		end 
		--self.lab_words:setString(str)
		self.wordimgd:setScale(0)
	end)

	local sequence = cc.Sequence:create(a_fistr,act,a2,a1)
	local action = cc.RepeatForever:create(sequence)
	self.wordimgd:runAction(action) 
end

--查看规则
function GuildQifu:onBtnGuize( sender_,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		mgr.ViewMgr:showView(_viewname.GUIZE):showByName(9)
	end 
end
--祈福类型被选中
function GuildQifu:onimgChoose( sender_,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		self.choose = sender_:getTag()

		if not  G_BuyAnything(sender_.type,sender_.cost) then 
			return 
		end 


		local str = sender_.type == 1 and res.image.GOLD or res.image.ZS

		local data = {}
		data.richtext = {
			{text=res.str.GUILD_DEC24,fontSize=24,color=cc.c3b(255,255,255)},
			{img=str},
			{text=tostring(sender_.cost),fontSize=24,color=self.img_qf_type[self.choose].cost:getColor()},
			--{text= str,fontSize=24,color=cc.c3b(255,0,0)},
			{text=","..res.str.GUILD_DEC25,fontSize=24,color=cc.c3b(255,255,255)},
			--{text=res.str.PROMOTEN_DEC5,fontSize=24,color=cc.c3b(255,255,255)},
		}

		---res.str.COMPOSE_CARD;
		data.sure = function( ... )
			-- body
			if self.data.isQf and self.data.isQf>0 then 
				G_TipsOfstr(res.str.GUILD_DEC27)
				return
			end 

			
			--debugprint("self.choose = "..self.choose)
			local params = {qf = self.choose}
			proxy.guild:sendQifu(params)
			
			
		end
		data.cancel = function( ... )
			-- body
		end
		data.surestr =  res.str.SURE
		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,nil,true)

	end 
end

function GuildQifu:onXiangziCall(sender_,eventype  )
	-- body
	if eventype == ccui.TouchEventType.ended then

		local tag = sender_:getTag()
		--debugprint("有个箱子被点击了 "..tag.." jingd = "..sender_.jidu)

		local data = { reward = sender_.data , tag = tag }
		local needji = sender_.jidu
		data.jidu = needji

		if self.data.qfJindu >= sender_.jidu then 
			data.status = 2 -- 已经领取了
			for k ,v in pairs(self.data.qfAwards) do 
				--print("v ="..v)
				if tonumber(sender_.jidu) == tonumber(v) then 
					data.status = 1 --可以领取
					break;
				end 
			end 
		else
			data.status = 0 --没达到基本要求
		end 


		mgr.ViewMgr:showView(_viewname.GUIILD_REWARAD):setData(data)
	end 
end

---做一些本地能做的
function GuildQifu:initData()
	-- body
	--3种祈福

	self:say("normal")
	self.wordimgd:setVisible(false)
	self.lab_words:setVisible(false)

	for i = 1 , 3 do 
		local v = self.img_qf_type[i]
		local data = conf.guild:getQifuitem(i)

		v.jingdu:setString("+"..data.add_jingdu)
		v.exp:setString("+"..data.add_exp)
		v.gongxian:setString("+"..data.add_gongxian)

		local path = res.image.GOLD
		if data.type == 2 then 
			path = res.image.ZS
		end  
		v.costtype:loadTexture(path)
		v.cost:setString(data.cost)
		v.donecost:setVisible(false)

		v.img:setTouchEnabled(true)
		v.img:setTag(i)
		v.img.cost = data.cost
		v.img.type = data.type
		v.img:addTouchEventListener(handler(self, self.onimgChoose))
		--v.yuan:setTouchEnabled(true)
		--v.yuan:setTag(i)
		--v.yuan:addTouchEventListener(handler(self, self.onimgChoose))
	end 

	for  i = 1 , 4 do 
		local v = self.img_xiang[i]
		v:setTouchEnabled(true)
		v:setTag(i)
		v:addTouchEventListener(handler(self, self.onXiangziCall))
	end 
end

function GuildQifu:initreward()
	-- body
	local day_max = conf.guild:getMaxjingdu(self.data.qfAwardId)
	local t = conf.guild:getReward(self.data.qfAwardId)

	local k_key = table.keys(t)
	table.sort(k_key,function(a,b)
		-- body
		return a < b 
	end)
	--print(self.loadbar_qi:getContentSize().width)
	for k ,v in pairs(k_key) do 
		if k > 4 then 
			debugprint("只有4个箱子吧")
			break 
		end 
		self.img_xiang[k]:removeAllChildren()
		self.img_xiang[k]:setPositionX(v/day_max*self.loadbar_qi:getContentSize().width)

		--print("v="..v)
		

		self.img_xiang[k].jidu= v
		self.img_xiang[k].data = t[v]

		self.img_xiang[k]:removeAllChildren()

		local _txt = ccui.Text:create()
		_txt:setFontSize(20)
		_txt:setString("("..v..")")
		--_txt:setColor(COLOR[6])
		_txt:setPositionX(self.img_xiang[k]:getContentSize().width/2)
		_txt:setPositionY(-_txt:getContentSize().height/2)
		self.img_xiang[k]:addChild(_txt, 100)
		
		local ccsize = self.img_xiang[k]:getContentSize()

		if self.data.qfJindu >= v then 
			local flag = true -- 已经领取了
			for i ,j in pairs(self.data.qfAwards) do 
				--print("v ="..v)
				if tonumber(v) == tonumber(j) then 
					local params =  {id=404831, x=ccsize.width/2,y = ccsize.height/2,addTo=self.img_xiang[k],
					playIndex=2,addName = "effofname",depth = -1 }
					flag = false
					mgr.effect:playEffect(params)
					break;
				end 
			end 

			if flag then 
				self.img_xiang[k]:loadTexture(res.icon.OPENXIANGZI[k])
			end 
		end 

	end 
end

function GuildQifu:setRwardData(value)
	-- body
	--self.data.qfAwards = cache.Guild:getReward()
	for k , v in pairs(self.data.qfAwards) do 
		if v == value then 
			self.data.qfAwards[k] = nil 
			break
		end 
	end 
	self:initreward()
	--printt(self.data.qfAwards)
end

function GuildQifu:setData()
	-- body

	self.data = cache.Guild:getQFmsg()
	--printt(self.data)
	--printt(self.data)
	if self.data.guildName then 
		self.lab_name:setString(self.data.guildName)--这个没有名字
	end

	--[[local icon_lv = conf.guild:getSrc(self.data.guildLevel) --公会等级图片
	if icon_lv then 
		icon_lv = head_path..icon_lv..end_type
		self.vip:loadTexture(icon_lv)
	end ]]--

	self.lab_lv:setString(self.data.guildLevel)

	local next_exp = conf.guild:getExp(self.data.guildLevel)
	if not next_exp or next_exp <=0 then 
		if not next_exp then 
			debugprint("配表有问题 ， 不能不配经验的")
		elseif next_exp<=0 then 
			debugprint("没有下一个等级了")
		end 
		next_exp = self.data.guildExp
	end 

	self.loadbar_exp:setString(self.data.guildExp.."/"..next_exp)
	self.loadbar_lv:setPercent(self.data.guildExp*100/next_exp)
	--徽章
	--local hz = cache.Fortune:getHz()
	self.lab_hz:setString(self.data.guildPoint)

	--祈福进度条

	--self.loadbar_qi:setString()
	self.loadbar_qi_count:setString(self.data.qfJindu)
	local day_max = conf.guild:getMaxjingdu(self.data.qfAwardId)
	self.loadbar_qi:setPercent(self.data.qfJindu*100/day_max)

	local guildmember = cache.Guild:getGuildCount()
	self.lab_qf_count:setString("/"..guildmember) --总数
	--调整一下位置
	self.qf_count:setString(self.data.qfRenshu)
	self.lab_qf_count:setPositionX(self.qf_count:getPositionX()+
		self.qf_count:getContentSize().width)

	if self.data.isQf > 0 then 
		self.img_qf_type[self.data.isQf].donecost:setVisible(true)
		self.img_qf_type[self.data.isQf].costtype:setVisible(false)
		self.img_qf_type[self.data.isQf].cost:setVisible(false)
		--self:onimgChoose(self.img_qf_type[self.data.isQf].img,ccui.TouchEventType.ended)


		for i = 1 ,3 do 
			self.img_qf_type[i].img:setTouchEnabled(false)
		end 
	end 

	--4个箱子
	self:initreward()
end

--[[function GuildQifu:onbtnqifu( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		debugprint("祈福前判一下")
		if self.data.isQf>0 then 
			G_TipsOfstr("今天已经祈福过了哦")
			return
		elseif not self.choose then 
			G_TipsOfstr("选择一个祈福的方式")
			return 
		end 
		debugprint("self.choose = "..self.choose)
		local params = {qf = self.choose}
		proxy.guild:sendQifu(params)
	end 
end]]--

--服务器返回祈福  来放个动画
function GuildQifu:severCallBack()
	-- body
	self.wordimgd:setVisible(false)  
	self.lab_words:setVisible(false) 
	self.imgtiannv:setVisible(false)


	self:setData()

	local params =  {id=404833, x=display.cx,y = display.cy,addTo=self.view,endCallFunc=function( ... )
		-- body
		self.wordimgd:setVisible(true)  
		self.lab_words:setVisible(true) 
		self.imgtiannv:setVisible(true)
		self:say("yanfa")

		--飘个字 看看
		local jingdu = string.sub(self.img_qf_type[self.choose].jingdu:getString(),2)
		local exp = string.sub(self.img_qf_type[self.choose].exp:getString(),2)
		local gongxian = string.sub(self.img_qf_type[self.choose].gongxian:getString(),2)
		--print(jingdu .. " , ".. exp .. ", "..gongxian)
		local str1 = string.format(res.str.GUILD_DEC36,tonumber(jingdu))
		local str2 = string.format(res.str.GUILD_DEC37,tonumber(exp)*self.data.isCrit)
		local str3 = string.format(res.str.GUILD_DEC38,tonumber(gongxian)*self.data.isCrit)

		G_TipsOfstr(str1.." "..str2.." "..str3)
			
	end,
	playIndex = self.choose} 
	mgr.effect:playEffect(params)

	if  self.data.isCrit > 1 then --策划 bug 2倍以上才飘
		local function moveandScale(spr) --这个是倍数飘字
			-- body
			local a1 = cc.ScaleTo:create(0.5,2.0)
			local a3 = cc.MoveTo:create(1.5,cc.p(spr:getPositionX(),spr:getPositionY()+200) )
			local a2 = cc.CallFunc:create(function( ... )
				-- body
				spr:removeFromParent()
			end)
			local a4 = cc.Spawn:create(a1,a3)
			local sequence =  cc.Sequence:create(a4,a2)
			spr:runAction(sequence)
		end

		local spr = display.newSprite(res.font.EQUIPQH[self.data.isCrit])
		spr:setPosition(self.view:getContentSize().width/3*2
		,self.view:getContentSize().height/2
		)
		spr:addTo(self.view,200)
		moveandScale(spr)
	end 
	
	
end

function GuildQifu:onCloseSelfView()
	-- body
	G_MainGuild()
	--mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_VIEW)
end



return GuildQifu