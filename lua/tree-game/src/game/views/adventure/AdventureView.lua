
--[[
	探险
]]
local AdventureView=class("AdventureView",base.BaseView)

function AdventureView:ctor()
	-- body
	--一键探险
	self.cancelSecond = true
	--掉落物品清理
	self.rubbish = {}
	----每5秒清理一次
	self.countdowntime = 5
	--boss 说的话
	self.word = {
		normal = {},
		hurt ={},
		dead = {}
	}
	self.wordtime = 2

	self.oldhp = 0
	self.maxHp = 0
	--倒计时回复体力时间
	self.retime = 0
	--
	self.addtime = 0

	self.handle = true  
	self.last  = 0

	self.booddead = false

end

function AdventureView:init()
	-- body
	proxy.adventure:sendMessage112001()

	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	--
	self.bg =  self.view:getChildByName("Image_1")

   
	--名字
	self._name = self.view:getChildByName("Image_name_di"):getChildByName("Text_2")
	--形象
	self._spr = self.view:getChildByName("Image_10")
	self._spr:ignoreContentAdaptWithSize(true)
	--self._spr:setPositionY(self._spr:getPositionY() - (display.height/2-480) )

	local xx = self._spr:getPositionY()

	self.oldposy = xx
	xx = self._spr:getPositionX()
	self.oldposx = xx
	--xuetiao
	self._loadbar_hp = self.view:getChildByName("LoadingBar_1")
	self._txt_hp = self.view:getChildByName("txt_xuetiao")
	--点击 请求战斗
	self._clickPanle = self.view:getChildByName("Panel_2")
	self._clickPanle:addTouchEventListener(handler(self, self.onPanleCallback))

	--冒泡文字
	self.panel_3 = self._clickPanle:getChildByName("Panel_1_0")
	self.panel_3:setPositionY(self.panel_3:getPositionY() - (display.height/2-480) )
	--self.img= panel_3:getChildByName("Image_3") 
	self._word = self.panel_3:getChildByName("Text_2_24_27")
	self._word:setFontSize(18)

	
	--探险剩余次数
	local img_count_di = self.view:getChildByName("img_count_di")
	self._count = img_count_di:getChildByName("Text_3_0")
	self._maxCount = img_count_di:getChildByName("Text_3")
	--回复时间
	local Panel_1 =  self.view:getChildByName("Panel_1")
	self._times = Panel_1:getChildByName("Text_3_0_0_0")

	--checkBox
	self._checkbox = Panel_1:getChildByName("CheckBox_1")
	self._checkbox:setSelected(false)
	self._checkbox:addEventListener(handler(self, self.checkBoxCallback))

	self.user = g_var.debug_accountId

	local times= MyUserDefault.getIntegerForKey(self.user..user_default_keys.GAME_ADVENTTURE_DAY)
	if times then --今日是否勾选了 不在提示
		if os.date("%x", os.time()) == os.date("%x",times) then 
			self.cancelSecond = false 
			self._checkbox:setSelected(true)
		else
			self.cancelSecond = true
		end
	end	

	---gulu 
	local image_4 = self.view:getChildByName("Image_4")
	if res.banshu then 
		image_4:setVisible(false)
	end 

	self:checkSecond()
	self:setData()
	--开始循环5秒
	self:Rubbishaction()
	self:Bossword("normal")
	self:schedule(self.changeTimes,1.0,"changeTimes")

	self.first = MyUserDefault.getStringForKey(user_default_keys.FIRST_ADV)
	--print(self.first)
	if self.first ~= "false"  then 
		self:performWithDelay(function()
				self:setOnlyFirger() --地板上的永恒动画
		end, 0.2)
    end 
	
	self:performWithDelay(function()
			self:setOnlyOnce() --地板上的永恒动画
	end, 0.1)


	----界面固定文本初始化
	Panel_1:getChildByName("Text_3_0_0"):setString(res.str.ADVENTURE_DEC4)
	Panel_1:getChildByName("Text_3_0_0_1"):setString(res.str.ADVENTURE_DEC5)
	Panel_1:getChildByName("Text_3_0_0_0_0"):setString(res.str.ADVENTURE_DEC6)
end

function AdventureView:checkSecond( ... )
	-- body
	if cache.Player:getLevel()<50 and cache.Player:getVip()<3  then 
	else
		self.cancelSecond = false 
		self._checkbox:setSelected(true)
		self:savedaycancel()
	end
end


function AdventureView:setOnlyFirger( ... )
	-- body
	   --动画播放期间 不给点击
    local layer = ccui.Layout:create()
    layer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    layer:setBackGroundColor(cc.c3b(0, 0, 0))
    layer:setBackGroundColorOpacity(0)
    layer:setContentSize(cc.size(display.width,display.height))
    layer:setTouchEnabled(true)
    layer:setTouchSwallowEnabled(true)
    --addto:addChild(layer,100) 
    mgr.SceneMgr:getNowShowScene():addChild(layer)

    self.layer = layer


	local params =  {id=404816, x=self._clickPanle:getContentSize().width/2,
	y=self._clickPanle:getContentSize().height/2,addTo=self._spr, playIndex=0
	,loadComplete = function ( var  )
		-- body
		self.armature = var
	end}
	mgr.effect:playEffect(params)

	local panle = self._clickPanle:clone()
	panle:removeAllChildren()
	panle:setPosition(self._clickPanle:getWorldPosition())
	panle:addTo(layer)
	panle:addTouchEventListener(handler(self,self.onPanleCallback))
end

--设置今天是否取消2次确认界面
function AdventureView:savedaycancel( )
	-- body
	self.cancelSecond = false

	MyUserDefault.setIntegerForKey(self.user..user_default_keys.GAME_ADVENTTURE_DAY,os.time())
end

--设置boss的名字
function AdventureView:setbossName(name)
	-- body
	self._name:setString(name)
end
--设置boss的形象
function AdventureView:setbossSpr( imgpath )
	-- body
	self._spr:loadTexture(imgpath)
end
--设置boss的血量
function AdventureView:setLoadbarHp(hp,maxhp)
	-- body
	self.oldhp = hp
	self.maxHp = maxhp
	self._txt_hp:setString(hp.."/"..maxhp)
	self._loadbar_hp:setPercent(hp*100/maxhp)
end
--设置剩余次数
function AdventureView:setCount( count,maxCount )
	-- body
	self._count:setString(count)
	self._maxCount:setString("/"..maxCount)
	self._maxCount:setPositionX(self._count:getContentSize().width/2+self._count:getPositionX()
		+self._maxCount:getContentSize().width/2)
end
--回复时间
function AdventureView:setUpdateTime(times)
	-- body
	local text = string.format("%02d"..":".."%02d",math.floor(times/60),times%60)
	self._times:setString(text)
end

function AdventureView:setWorddata( id )
	-- body
	self.word.normal=conf.Adventure:getnormalSay(id) 
	self.word.hurt=conf.Adventure:getHurtSay(id) 
	self.word.die=conf.Adventure:getdieSay(id) 
	--printt(self.word)
end

function AdventureView:Bossword(status)
	-- body
	--debugprint("boss 说话了")
	self.panel_3:stopAllActions()

	--local a1 = cc.DelayTime:create(self.wordtime)

	local scale = cc.ScaleTo:create(0.8,1)
    local act = cc.EaseElasticOut:create(scale)


	local a2 = cc.CallFunc:create(function()
		-- body
		if status ~="normal" then 
			status = "normal"
		end
	end)
	local a1 = cc.DelayTime:create(self.wordtime)
	local a_fistr = cc.CallFunc:create(function()
		-- body
		--printt(self.word[status])
		--print(math.random(#self.word[status]))
		local str = self.word[status][math.random(#self.word[status])]
		self._word:setString(str)
		self.panel_3:setScale(0)
	end)

	local sequence = cc.Sequence:create(a_fistr,act,a2,a1)
	local action = cc.RepeatForever:create(sequence)
	self.panel_3:runAction(action) 
end

--boss上下浮动动画
function AdventureView:_sprAction()
	-- body
    --避免受到攻击后位置变动
  	 --self._spr:stopAllActions()
	--self._spr:setPosition(self.oldposx,self.oldposy)

	--local movre111 = cc.MoveTo:create(0.01, cc.p(self.oldposx,self.oldposy))
	local move11 = cc.MoveBy:create(0.5,cc.p(0, 8))
 	local move12 = cc.MoveBy:create(0.5,cc.p(0, -8))

  	local Sequence1 = cc.Sequence:create(movre111,move11, move12 )
  	local actionssss = cc.RepeatForever:create(Sequence1)
	self._spr:runAction(actionssss) 
end
----待机动画
function AdventureView:setOnlyOnce(  )
	-- body
	--地板动画
	--self.oldposy = self._spr:getPositionY()
	self:_sprAction()

	local posx = self._clickPanle:getContentSize().width/2
	local posy = 121
	
	local params =  {id=404838, x=self.bg:getContentSize().width/2,y=self.bg:getContentSize().height/2,addTo=self.bg}
	mgr.effect:playEffect(params)

	G_FitScreen(self,"Image_1")
	--[[local posx = self._clickPanle:getContentSize().width/2
	local posy = 121

	posx = self._clickPanle:getPositionX() + posx
	posy = self._clickPanle:getContentSize().height/2 + self._clickPanle:getPositionY() - 45

	local params =  {id=404082, x=posx,y=posy,addTo=self.bg, playIndex=0}
	mgr.effect:playEffect(params)

	local params =  {id=404082, x=posx,y=posy,addTo=self.bg, playIndex=1}
	mgr.effect:playEffect(params)]]--
end
--倒计时
function AdventureView:changeTimes( )
	-- body
	local lasttime = cache.Adventure:getLastTime() --下一次恢复 剩余时间
	self:setUpdateTime(lasttime)

	local count = cache.Adventure:getlastCount()
	local max = cache.Player:getAdventMaxCount()
	self:setCount(count,max)
end

function AdventureView:setData(flag)
	-- body
	--print("********************************")

	self._spr:setVisible(true)

	--设置名字
	local boosid = cache.Adventure:getbossId()
	local name = conf.Adventure:getbossName(boosid) 
	self:setbossName(name)
	--设置BOSS 的形象
	--print(boosid)
	local src = conf.Adventure:getbossSrc(boosid)
	local path = mgr.PathMgr.getItemImagePath(src)
	self:setbossSpr(path)
	--设置血量
	local hp = cache.Adventure:getBossCurrHP()
	local maxhp = conf.Adventure:getbossmaxHp(boosid) 
	self:setLoadbarHp(hp,maxhp)
	--剩余次数
	local maxcout = cache.Player:getAdventMaxCount() 
	if not  maxcout then maxcout = 0 end 
	--print(" dd ="..cache.Adventure:getlastCount())
	self:setCount(cache.Adventure:getlastCount(),maxcout)
	--每次回复时间
	self.retime = cache.Adventure:getCountTime()
	--print("lasttime "..cache.Adventure:getLastTime())
	--print("setData =  self.retime  ="..self.retime)
	----可购买次数
	--self.canBuyCount = cache.Adventure:getCanBuyCount()


	--获取boss说的话
	self:setWorddata(boosid)
end
--垃圾清理动作
function AdventureView:Rubbishaction()
	-- body
	if self._spr:getChildByName("name") then 
		self._spr:getChildByName("name"):removeFromParent()
	end
	local posx = self._spr:getContentSize().width/2
	local posy = self._spr:getContentSize().height/2

	local spr = display.newSprite(res.other.TISHI)
	local _img = display.newScale9Sprite(res.other.TISHI,posx,posy,cc.size(300, 40),spr:getContentSize())
	_img:setName("name")
	_img:addTo(self._spr)


	local label = display.newTTFLabel({
    text = "",
    font = res.ttf[1],
    size = 28,
    color = COLOR[2], --绿
    align = cc.TEXT_ALIGNMENT_CENTER ,-- 文字内部居中对齐
    x = _img:getContentSize().width/2,
    y = _img:getContentSize().height/2
    })
    :addTo(_img)
	_img:setVisible(false)
	--self._spr:addChild(_img)

	local a1 = cc.DelayTime:create(self.countdowntime)
	local a2 = cc.CallFunc:create(function()
		-- body
		--释放清理 累计计算
		local exp = 0
		local jb = 0
		for k ,v in pairs(self.rubbish) do 
			if v.money_jb then 
				jb = jb + v.money_jb
			end
			if v.exp then 
				exp = exp + v.exp
			end
			v:removeFromParent()
		end
		self.rubbish = {}
		if jb>0 or exp>0 then 
			label:setString("exp +"..exp.." "..res.str.MONEY_JB.." +"..jb)
		else
			label:setString("")
		end
		
		local a3 = cc.CallFunc:create(function() 
			if jb>0 or exp>0 then 
		 		 _img:setVisible(true) 
		 	end
		  end) 
        local a4 = cc.MoveTo:create(1.0,cc.p(posx,posy+100))
        local a5 = cc.CallFunc:create(function()  
        	_img:setVisible(false)  
        	_img:setPosition(posx, posy)
        	end) 
        _img:runAction(cc.Sequence:create(a3,a4,a5))
	end)
	local sequence = cc.Sequence:create(a1,a2)
	local action = cc.RepeatForever:create(sequence)
	_img:runAction(action) 
end
--死亡
function AdventureView:dead(data_)
	-- body
	--播放死亡动画\

	self:Bossword("die")
	local strDieBoosName = self._name:getString()
	local layer = ccui.Layout:create()
	layer:setContentSize(cc.size(display.width,display.height))
	layer:setTouchEnabled(true)
	layer:setTouchSwallowEnabled(true)
    self:addChild(layer,1000) 
 	
 	self._spr:setVisible(false)
 	--死亡特效
 	local posx = self._clickPanle:getContentSize().width/2
  	local posy = self._clickPanle:getContentSize().height/2

  	posx = self._clickPanle:getPositionX() + posx - 20
	posy = self._clickPanle:getContentSize().height/2 + self._clickPanle:getPositionY()-80

	local params =  {id=404080, x=posx,y=posy,addTo=self.view,endCallFunc=function ()
		-- body
		if layer then 
    		layer:removeFromParent()
    	end
	 	
        self._spr:setVisible(true)
		self._clickPanle:setTouchEnabled(true)
		--重新设置boss 
        self:setData()

        if #data_.items > 0 then 
			local itemdata = data_.items
			local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
			if not view then
				view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
				view:setData(itemdata,true,true)
				view:setButtonVisible(false)
			else
				view:setData(itemdata,true,true)
				view:setButtonVisible(false)
			end
		end 	

	end, playIndex=0}
	mgr.effect:playEffect(params)

	


end
----暴击的时候屏幕 屏幕抖动
function AdventureView:_BaojiSence(  )
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
--物品掉落动画
function AdventureView:playItem(param_str)
	-- body
	local img = ccui.ImageView:create()
	if param_str == "exp" then 
		img:loadTexture(res.image.EXP)
	else
		img:loadTexture(res.image.GOLD)
	end

	local posx,posy = self._spr:getPosition()
	local ccsize = self._spr:getContentSize()

	img:setPosition(posx-30,posy+self._spr:getContentSize().height/2-50)
	self.view:addChild(img,10000)

	local x = math.random(-200,200)
	x = math.ceil(x/50)*50 

	local j1 = cc.JumpBy:create(0.5,cc.p(x,-self._spr:getContentSize().height), 
		200, 1)
	--local j2 = cc.MoveTo:create(0.2,cc.p(posx,posy-self._spr:getContentSize().height/2+100 ))
	x = x < 0 and -60 or 60
	local j2 = cc.JumpBy:create(0.2,cc.p(x,0), 60, 1)
	local j3 = cc.JumpBy:create(0.2,cc.p(x/2,-20), 20, 1)

	local Sequence = cc.Sequence:create(j1,j2,j3)
	img:runAction(Sequence)

	return img
end

--受到攻击
function AdventureView:hurt(flag,data_)
	-- body
	--抖动动画
	self.playing = true

    mgr.Sound:playTanxian()
	self._spr:stopAllActions()
		--受伤说一句
  	--local count  =table.nums(data_.isCrits) -1 
  	local t = {}
  	for k ,v in pairs(data_.isCrits) do 
  		if tostring(k)~="_size" then 
  			table.insert(t,v)
  		end 
  	end 

  	local speed = 1
	if self._checkbox:isSelected() then --改变播放速度
		speed = 8
	end 

  	self:Bossword("hurt")
	
	local move = cc.MoveBy:create(0.03/speed,cc.p(-3, 8))
 	local move1 = cc.MoveBy:create(0.05/speed,cc.p(6, -3))
  	local move2 = cc.MoveBy:create(0.08/speed,cc.p(-3, -5))
  	local Sequence = cc.Sequence:create(move, move1, move2)

 
  	local a1 =cc.CallFunc:create(function()
  		-- body
  		local function callback( value ,key )
  			-- body

  			self:setLoadbarHp(self.oldhp - value >= 0 and self.oldhp - value or 0 ,self.maxHp)

  			self._spr:setPosition(self.oldposx,self.oldposy)

  			local posx = self._spr:getContentSize().width/2 - 20
        	local posy = self._spr:getContentSize().height/2+100

        	local spr = display.newSprite(res.font.REDUCE)
	        local mTxt = cc.LabelAtlas:_create(value.."",res.font.FLOAT_NUM[1],30,41,string.byte("."))
	        mTxt:setAnchorPoint(cc.p(0,0))

	        local sprsizew =  spr:getContentSize().width
	        local mTxtsizew = mTxt:getContentSize().width

	        posx =  posx-(sprsizew+mTxtsizew)/2 + sprsizew/2
	        spr:setPosition(posx, posy)
	        spr:addTo(self._spr)

	        posx =  mTxtsizew/2 + spr:getContentSize().width/2
	        mTxt:setPosition(posx, 0)
	        mTxt:addTo(spr)

			local  _fun_action=cc.CallFunc:create(
	        function ( )
	        	
	            spr:removeFromParent()
	        end)
	        local a3 = cc.MoveTo:create(1.0/speed,cc.p(spr:getPositionX(),self._spr:getContentSize().height/2+150))
	        spr:runAction(cc.Sequence:create(Sequence,a3,_fun_action))

	        if data_.exp>0 then 
	        	local img  = self:playItem("exp")
	        	img.exp = checkint(data_.exp/#t)
	        	if img then 
	        		table.insert(self.rubbish,img)
	       		end
	        end

	        if data_.money_jb>0 then
	        	local img = self:playItem("jb")
	        	img.money_jb = checkint(data_.money_jb/#t)
	        	if img then 
	        		table.insert(self.rubbish,img)
	       		end
	        end  


	        local posx = self._clickPanle:getContentSize().width/2
		  	local posy = self._clickPanle:getContentSize().height/2

		  	posx = self._clickPanle:getPositionX() + posx - 20
			posy = self._clickPanle:getContentSize().height/2 + self._clickPanle:getPositionY()-80

			local pp = 0 --普通一下
			local jiaodu  = 0

			local isCrit = value
			if isCrit > 1 then 
				self:_BaojiSence()--暴击抖动屏幕
				--加一个 X2 *X4 X8动画
				if isCrit == 8 then
					pp = 3 --暴击一下
				elseif isCrit == 4 then 
					pp = 2 --暴击一下
				else
					pp = 1 --暴击一下
				end  
			else
				--随机旋转角度
				local t = math.random(4)
				if t<1 then 
					jiaodu = 30 
					posx = posx - 50 
				elseif t<2 then 
					jiaodu = 80 
					posy = posy + 50
					posx = posx - 40
				elseif t <3 then 
					jiaodu = 130
					posy = posy + 80
					posx = posx - 20
				else
					jiaodu = 0
				end
			end

			local index = 0
			if isCrit >  1 then 
				index = 1 
			end

			local params =  {id=404082, x=posx,y=posy+50,addTo=self.view
			, playIndex=index,Rotation = jiaodu
			,addName = "adv"}
			mgr.effect:playEffect(params)

			----暴击放大
			local spr = display.newSprite(res.font.ADV_BAOJI[pp])
			spr:setPosition(posx,posy+50)
			spr:setScale(0) -- 最初大小
			spr:addTo(self.view)
			local a1 = cc.ScaleTo:create(0.3,1.2,1.2) ---0.3秒到1.2倍
			local a2 = cc.ScaleTo:create(0.1,1.0,1.0) --
			local a3 = cc.DelayTime:create(0.5) --停留0.5
			local a4 = cc.FadeTo:create(0.3, 0) --谈出
			local a5 = cc.CallFunc:create(function( ... )
				-- body
				spr:removeSelf()
			end)

			local sequence = cc.Sequence:create(a1,a2,a3,a4,a5)
			spr:runAction(sequence)

			if #t == key then 
				self._spr:setPosition(self.oldposx,self.oldposy)
		  		self:_sprAction()
		  		self.playing = false
		  		if flag then 
		        	self:dead(data_)
		        else
		        	self:setData()
		        end
			end 
	  	end 

  		for k ,v  in pairs(t) do 
  			if tostring(k) ~= "_size" then 
	  			self:performWithDelay(function()
	  				-- body
	  				callback(v,k)
	  			end,(k -1 ) * (1.0/speed))
	  		end 
  		end 
  	end)

  	self:runAction(a1)
end

function AdventureView:sendcallback(str,flag,data)
	-- body
	self:hurt(flag,data)
end

function AdventureView:cancel()
	-- body

end

--buy 
function AdventureView:Tobuy()
	-- body
	mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
	local ff = cache.Player:getAdventBuy() --每天可够没的次数
	local d =  cache.Player:getDoneBuy() --已经购买的次数
	
	if ff>0  then 
		
		local ttpr = conf.buyprice:getPriceADV(d+1)
		if not ttpr then 
			ttpr = conf.buyprice:getPriceMax()
		end 

		if not G_BuyAnything(2,ttpr) then 
			return 
		end 
		
		local data ={stype = 40421,count = conf.Item:getExp(PRO_USE_TM[1]) }
		proxy.Radio:send101005(data)
	else
		if res.banshu  then --or g_recharge
			 G_TipsOfstr(res.str.TIPS_BUYOVER)
		else
			local function toChongzhi()
			-- body
			   mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
			   
			   G_GoReCharge()
			end

			local function cancel( ... )
				-- body
			end

			local data = {}
			data.vip = res.str.TIPS_BUYOVER
			data.sure = toChongzhi
			data.cancel = cancel
			data.surestr= res.str.RECHARGE
			local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
			view:setData(data)
		end 
	end 
	---不能购买提示充值 
end


--check 游戏次数不足 
function AdventureView:CountOver()
	-- body
	local iddata = nil 
	for k ,v in pairs(PRO_USE_TM) do 
		local count = cache.Pack:getIteminfoByMid(pack_type.PRO,v)
		if count  then 
			iddata = count
			break
		end 
	end 

	if iddata  then
		local view = mgr.ViewMgr:showView(_viewname.ROLE_BUY_TILI)
		view:setUseMessage(iddata)
	else
		proxy.Radio:send101006(40421)
	end 
end
--游戏次数不足 请求购买次数返回
function AdventureView:SeverCallbackCountOver(count)
	-- body
	if count > 0 then 

		local data ={}
		local d =  cache.Player:getDoneBuy() --已经购买的次数
		print("d = "..d )
		local ttpr = conf.buyprice:getPriceADV(d+1)
		if not ttpr then 
			ttpr = conf.buyprice:getPriceMax()
		end 
		data.amount = ttpr
		data.sure = self.Tobuy
		data.cancel = self.cancel
		local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
		view:setData(data)
	else
		local function toChongzhi()
		-- body
		   mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
		   
		   G_GoReCharge()
		end

		local function cancel( ... )
			-- body
		end

		local data = {}
		data.vip = res.str.TIPS_BUYOVER
		data.sure = toChongzhi
		data.cancel = cancel
		data.surestr= res.str.RECHARGE
		local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
		view:setData(data)
	end 
end

function AdventureView:checkBoxCallback(sender,eventtype)
	-- body
	if cache.Player:getLevel()<50 and cache.Player:getVip()<3  then 
		--if cache.Player:getLevel()<50 then 
			--G_TipsOfstr(res.str.ADV_TANXIAN)
		--else
		if not res.banshu  then --or not g_recharge

			if cache.Player:getVip()<3 and cache.Player:getLevel()<50 then 
				local data = {};
		    	data.richtext = res.str.ADVENTURE_VIP3;
		    	data.sure = function( ... )
		    		-- body
		    		  G_GoReCharge()
		    	end
		    	data.cancel = function ( ... )
		    		-- body
		    	end
		   		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)

			end 
		else
			G_TipsOfstr(res.str.ADVENTURE_VIP3)
		end 

		self._checkbox:setSelected(false)
		return
	end 

	if eventtype == ccui.CheckBoxEventType.selected then
		--debugprint("一键探险按下")
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
			data.adv = res.str.ADVDEC1
			data.sure = sure
			data.cancel = cancel
			local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
			view:setData(data)
		else

		end
	else
		--debugprint("一键探险取消")
	end
end

function AdventureView:playLocal( ... )
	-- body
	--随机旋转角度
	--self:_sprAction()

	local posx = self._clickPanle:getContentSize().width/2
  	local posy = self._clickPanle:getContentSize().height/2

  	posx = self._clickPanle:getPositionX() + posx - 20
	posy = self._clickPanle:getContentSize().height/2 + self._clickPanle:getPositionY()-80


	local jiaodu = 0

	local t = math.random(4)
	if t<1 then 
		jiaodu = 30 
		posx = posx - 50 
	elseif t<2 then 
		jiaodu = 80 
		posy = posy + 50
		posx = posx - 40
	elseif t <3 then 
		jiaodu = 130
		posy = posy + 80
		posx = posx - 20
	else
		jiaodu = 0
	end

	local params =  {id=404082, x=posx,y=posy+50,addTo=self.view
	, playIndex=0,Rotation = jiaodu
	,addName = "adv"}
	mgr.effect:playEffect(params)

	local move = cc.MoveBy:create(0.03,cc.p(-3, 8))
 	local move1 = cc.MoveBy:create(0.05,cc.p(6, -3))
  	local move2 = cc.MoveBy:create(0.08,cc.p(-3, -5))
  	local Sequence = cc.Sequence:create(move, move1, move2)

  	self._spr:runAction(Sequence)
end

function AdventureView:onPanleCallback(send,eventtype)
	-- body
	if ccui.TouchEventType.ended  == eventtype then
		if self.first == "" then 
			self.first = "false"
			MyUserDefault.setStringForKey(user_default_keys.FIRST_ADV,self.first)
			if self.armature then 
				self.armature:removeFromParent()
			end 
		end 

		if self.layer then 
			self.layer:removeFromParent()
			self.layer = nil 
		end 

		if cache.Adventure:getlastCount()<=0 then 
			self:CountOver()
			return
		end
		--动画播放期间
		if self.playing then 
			return 
		end 

		local view = mgr.ViewMgr:get(_viewname.LOADING_VIEW)
		if view then 
			self:playLocal()
			return 
		end 
		self._spr:setPosition(self.oldposx,self.oldposy)
		local tiems = 1
		if self._checkbox:isSelected() then 
			tiems = math.min(cache.Adventure:getBossCurrHP(),cache.Adventure:getlastCount())			
		end
		proxy.adventure:sendMessage112002(tiems)
		mgr.NetMgr:wait(512002)
	end
end

function AdventureView:onCloseSelfView()
	-- body
	--[[mgr.BoneLoad:removeArmatureFileInfo(404082)
	mgr.BoneLoad:removeArmatureFileInfo(404080)
	mgr.BoneLoad:removeArmatureFileInfo(404816)]]--
	local _view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	if _view then 
		_view:setPageButtonIndex(1)
	end
end

return AdventureView