--ActiveZhaocaiView
local ActiveZhaocaiView=class("ActiveZhaocaiView",base.BaseView)

function ActiveZhaocaiView:init()
	-- body
	proxy.zhaocai:sendMessage()

	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	
	--次数
	self.currCount = self.view:getChildByName("Panel_4"):getChildByName("Text_15_0")  
	self.maxCount  = self.view:getChildByName("Panel_4"):getChildByName("Text_15_0_0") 
	-- --招财一次按钮
	local btn_zhao = self.view:getChildByName("Button_7")
	btn_zhao:addTouchEventListener(handler(self, self.onbtnReq))

	self.btn = btn_zhao
	
	local img = self.view:getChildByName("Image_6") 
	--默认消耗2个砖石
	self.lab_cost = img:getChildByName("Image_7"):getChildByName("Text_1_0")
	--self.lab_cost:setString("2")
	--获得金币
	self.lab_jb = img:getChildByName("Image_7_0"):getChildByName("Text_1_0_6")
	--复选框
	--checkBox
	self._checkbox = img:getChildByName("CheckBox_1")
	self._checkbox:setSelected(false)
	self._checkbox:addEventListener(handler(self, self.checkBoxCallback))
	----一键招财次数
	self._chenk_count = img:getChildByName("Text_7_0")
	self.dec = img:getChildByName("Text_7_1")--对齐用的
	--printt(cache.Zhaocai:getData())
	self:setData(cache.Zhaocai:getData())

	--self.count = 1 --默认招财一次
	local times=MyUserDefault.getIntegerForKey(user_default_keys.GAME_ZHAICAI_DAY)
	if times then --今日是否勾选了 不在提示
		if os.date("%x", os.time()) == os.date("%x",times) then 
			self.cancelSecond = false 
		else
			self.cancelSecond = true
		end
	end	

	self.bg = self.view:getChildByName("Image_1")
	G_FitScreen(self,"Image_1")

	self.tenzhao = false-- 默认10次连续招财没有

	self:performWithDelay(function()
			--[[local effConfig = conf.Effect:getInfoById(404818)
			mgr.BoneLoad:addLoad(effConfig.effect_id,function()
			end)]]--
			self:palyForever()
	end, 0.01)

	self:checkSecond()
	self:initDec()
end

function ActiveZhaocaiView:checkSecond( ... )
	-- body
		self.cancelSecond = false 
		self:savedaycancel()
end

function ActiveZhaocaiView:initDec( ... )
	-- body
	self.view:getChildByName("Panel_4"):getChildByName("Text_15"):setString(res.str.ACTIVE_DEC2)

	self.view:getChildByName("Image_7_1"):getChildByName("Text_1_11"):setString(res.str.ACTIVE_DEC3)
	self.view:getChildByName("Image_7_1"):getChildByName("Text_1_0_13"):setString(res.str.ACTIVE_DEC4)
	self.view:getChildByName("Image_7_1"):getChildByName("Text_1_11_0"):setString(res.str.ACTIVE_DEC5)

	local img = self.view:getChildByName("Image_6")
	img:getChildByName("Image_7"):getChildByName("Text_1"):setString(res.str.ACTIVE_DEC6)
	img:getChildByName("Image_7_0"):getChildByName("Text_1_4"):setString(res.str.ACTIVE_DEC7)
	
	img:getChildByName("Text_7"):setString(res.str.ACTIVE_DEC8)
	img:getChildByName("Text_7_1"):setString(res.str.ACTIVE_DEC9)
end

function ActiveZhaocaiView:palyForever()
		local params = {id=404828, x=display.cx,y=display.cy,addTo=self.bg,playIndex=0,
		addName = "effofnamebg",depth = 0}
		mgr.effect:playEffect(params)
		local params = {id=404828, x=self.btn:getContentSize().width/2,y=self.btn:getContentSize().height/2+20,addTo=self.btn,playIndex=2,
		addName = "effofnamebg",depth = 0}
		mgr.effect:playEffect(params)
end

--设置今天是否取消2次确认界面
function ActiveZhaocaiView:savedaycancel( )
	-- body
	self.cancelSecond = false
	MyUserDefault.setIntegerForKey(user_default_keys.GAME_ZHAICAI_DAY,os.time())
end

function ActiveZhaocaiView:setCount()
	-- body
	if self.data.zCount == 0 then 
		self._checkbox:setTouchEnabled(false)
		self._checkbox:setBright(false)
		self._checkbox:setSelected(false)
	else
		self._checkbox:setTouchEnabled(true)
		self._checkbox:setBright(true)
	end 
	self.currCount:setString(self.data.zCount)
	self.maxCount:setString("/"..self.data.maxCount)
	self.maxCount:setPositionX(self.currCount:getContentSize().width+self.currCount:getPositionX())

	self._chenk_count:setString(self:getMax())
	self.dec:setPositionX(self._chenk_count:getContentSize().width+self._chenk_count:getPositionX())
end
--最大能招财几次
function ActiveZhaocaiView:getMax()
	-- body
	local max = math.min(self.data.zCount,10)
	return max
end

function ActiveZhaocaiView:setPrice( )
	-- body
	local _count = self.data.maxCount-self.data.zCount
	local price = conf.buyprice:getZhaocai(_count+1)
	if not price then 
		price = conf.buyprice:getZhaocaiMax()
	end 
	self.lab_cost:setString(price)
end

function ActiveZhaocaiView:setData(data)
	-- body
	self.data = data
	--次数
	self:setCount()
	--金币
	local jb = conf.zhaocai:getJb(cache.Player:getLevel())
	self.lab_jb:setString(jb)
	
	self:setPrice()
	--
end


----暴击的时候屏幕 屏幕抖动
function ActiveZhaocaiView:_BaojiSence(  )
	-- body
	--左右上下移动
	local m1 = cc.MoveBy:create(0.08,cc.p(6, -11))
	local m2 = cc.MoveBy:create(0.04,cc.p(-9, 10))
	local m3 = cc.MoveBy:create(0.04,cc.p(3, 1))
	local m4 = cc.MoveBy:create(0.04,cc.p(6, -11))
	local m5 = cc.MoveBy:create(0.04,cc.p(-9, 10))
	local m6 = cc.MoveBy:create(0.04,cc.p(5, -9))
	local m6 = cc.MoveBy:create(0.04,cc.p(5, -9))
	local m7 = cc.MoveTo:create(0.04,cc.p(0, 0))
	local Sequence = cc.Sequence:create(m1, m2,m3,m4,m5,m6,m7)
	mgr.SceneMgr:getNowShowScene():runAction(Sequence)
	--放大缩小
	local s1 = 	cc.ScaleTo:create(0.16,1.03)
	local s2 = 	cc.ScaleTo:create(0.08,1.00)
	local s3 = 	cc.ScaleTo:create(0.04,1.03)
	local s4 = 	cc.ScaleTo:create(0.18,1.03)
	local s4 = 	cc.ScaleTo:create(0.04,1.0)
	local Sequence1 = cc.Sequence:create(s1, s2,s3,s4)
	self.bg:runAction(Sequence1)
end

function ActiveZhaocaiView:updateData( data)
	-- body
	self.data.zCount = data.zCount
	self:setCount()
	self:setPrice()
	mgr.Sound:playViewZhaoCai()

	for k , v in pairs(data.moneyJbCrit) do 
		local function donghua( ... )
			-- body
			local jb =  v.value
	
			--金币飘字
			local spr = display.newSprite(res.other.TISHI)
		    local _img = display.newScale9Sprite(res.other.TISHI,display.cx,display.cy
		        ,cc.size(500, 60),spr:getContentSize())
		    _img:setName("tips")
		    _img:setPosition(display.cx, display.cy+200)
		    _img:addTo(self.view)

		    local label = display.newTTFLabel({
			    text = string.format(res.str.ACTIVE_ZHAOCAI,jb),
			    size = 30,
			    align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
			    x = 500/2,
			    y = 60/2,
			    font = res.ttf[1],
			})
			label:addTo(_img)

			local sequence = transition.sequence({
		    cc.Spawn:create(cc.FadeIn:create(0.5),cc.MoveTo:create(1.0,cc.p(display.cx,display.cy+300))),
		    cc.DelayTime:create(0.5),
		    })

		    local  _fun_action=cc.CallFunc:create(
		        function (  )
		            _img:removeFromParent()
		        end)
		    local _aciton=cc.Sequence:create(sequence,_fun_action)
		    _img:runAction(_aciton)
		end
		

	    self:performWithDelay(donghua, (k-1)*0.5)
	end 
	
	for k ,v in pairs(data.moneyJbCrit) do 
		--获得的金币 飘字显示吧
		local function donghua()
			-- body
			local function moveandScale(spr) --这个是倍数飘字
				-- body
				local a1 = cc.ScaleTo:create(0.5,1.8)
				local a3 = cc.MoveTo:create(0.5,cc.p(spr:getPositionX(),spr:getPositionY()+200) )
				local a2 = cc.CallFunc:create(function( ... )
					-- body
					spr:removeFromParent()
				end)
				local a4 = cc.Spawn:create(a1,a3)
				local sequence =  cc.Sequence:create(a4,a2)
				spr:runAction(sequence)
			end
			--倍数
			local critRate = v.type
			local posx = self.view:getContentSize().width*0.7
			local posy --= self.view:getContentSize().height*0.35 --暴击
			if critRate > 1 and critRate <5  then 
				local spr = display.newSprite(res.font.EQUIPQH[critRate])
				spr:setPosition(self.view:getContentSize().width/3*2
				,self.view:getContentSize().height/2
				)
				spr:addTo(self.view,200)
				moveandScale(spr)
            	posy =self.view:getContentSize().height*0.38
				if not self.bg:getChildByName("effcrit") then 
					local params =  {id=404828, x=posx,y=posy,addTo=self.bg,playIndex=1,
						addName = "effcrit",depth = 200
					}
					mgr.effect:playEffect(params)
				end 
				self:_BaojiSence()

				local palytimes = 4 --暴击金币播放几次
				local delay = 0.25 --每次播放间隔
				for i = 1 ,palytimes do 
					self:performWithDelay(function()
						-- body
						posy =self.view:getContentSize().height*0.4 --金币涌出位置 Y 方向
						local params =  {id=404818, x=posx,y=posy,addTo=self.bg,playIndex=0,
						addName = "effofname",depth = 100
						}
						mgr.effect:playEffect(params)
					end, (i-1)*delay)	
				end 
			else
				posy =self.view:getContentSize().height*0.4 --金币涌出
				local params =  {id=404818, x=posx,y=posy,addTo=self.bg,playIndex=0,
				addName = "effofname",depth = 100
				}
				mgr.effect:playEffect(params)

			end	
		end
		self:performWithDelay(donghua, (k-1)*0.1)
	end 
end

function ActiveZhaocaiView:onbtnReq( sender,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		
		if self.data.zCount == 0 then 
			if res.banshu  then --or g_recharge
				G_TipsOfstr(res.str.TIPS_ZAOCAIOVER)
				return 
			else
				if conf.Recharge:getVipLimit(cache.Player:getVip(),40323) == self.data.maxCount then 
					local data = {}
					data.sure = function( ... )
						-- body
					end
					data.surestr = res.str.SURE
					data.richtext =res.str.ACTIVE_DEC1
					mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
					return 
				end 
				local data = {}
				data.vip = res.str.TIPS_ZAOCAIOVER
				data.sure = function()
					-- body
					 mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
					  G_GoReCharge()
				end
				data.cancel = function()
					-- body
				end
				data.surestr= res.str.RECHARGE
				local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
				view:setData(data)
				return 
			end 
		end 

		if self.tenzhao then 
			local max = self:getMax()
			local totalPrice = 0
			local _count = self.data.maxCount-self.data.zCount +1 
			for i = _count  , _count + max -1   do 
				local price = conf.buyprice:getZhaocai(i)
				if not price then 
					price = conf.buyprice:getZhaocaiMax()
				end 
				totalPrice = totalPrice + price
			end 
			--debugprint("最后的价格 "..totalPrice)
			if not G_BuyAnything(2,totalPrice) then 
				G_TipsForNoEnough(2)
				return 
			end 
			proxy.zhaocai:send116012(max)
		else
			local price = tonumber(self.lab_cost:getString()) 
			if not G_BuyAnything(2,price) then 
				G_TipsForNoEnough(2)
				return 
			end 
			proxy.zhaocai:send116012(1)
		end 
		
	end 
end

function ActiveZhaocaiView:checkBoxCallback(sender,eventtype )
	-- body
	if eventtype == ccui.CheckBoxEventType.selected then--选中
		if not self.tenzhao then
			self.tenzhao = true
		end 

		if self.cancelSecond then 
			local data ={}
			local function sure(f)
				-- body
				mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
				if f then 
					self:savedaycancel()
				end	
			end
			local function cancel()
				-- body
			end
			local count = self:getMax()
			data.adv = string.format(res.str.ZHAOCAI10CI,count,count)
			data.sure = sure
			data.cancel = cancel
			local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
			view:setData(data)
		else
		end
	else
		self.tenzhao = false
	end 
end

return ActiveZhaocaiView