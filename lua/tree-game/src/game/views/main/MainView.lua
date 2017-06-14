local MainView=class("MainView",base.BaseView)

function MainView:ctor(  )
	self.super.ctor(self)
	self.ListButton1 = nil  --按钮容器1
	self.ListButton2 = nil  --按钮容器2
end

function MainView:init()
		self.showtype=view_show_type.UI
		self.view=self:addSelfView()
   		self.viewSave = true

   		self:setNodeEventEnabled(true)

		self.ListButton1={}  -- 充值   vip礼包  登陆奖励 任务  成就
		self.ListButton2={}
		local buttonSize=6
		for i=1,buttonSize do 
			local  btn=self.view:getChildByTag(1):getChildByTag(i)--按钮实例
			self.view:getChildByTag(1):reorderChild(btn, 6-i)

			self.ListButton1[#self.ListButton1+1]=gui.GUIButton.new(btn,handler(self,self.onListCallBack1),{x=19,y=0,ImagePath=res.image.RED_PONT})

		end
--


		local btn=self.view:getChildByTag(2) --背包按钮
		self.PackBtn=gui.GUIButton.new(btn,handler(self,self.onPackCallBack),{x=2,y=2,ImagePath=res.image.RED_PONT})
		btn=nil
		btn=self.view:getChildByTag(3)--好友
		self.PackBtn1=gui.GUIButton.new(btn,handler(self,self.onActivityCallBack),{x=15,y=15,ImagePath=res.image.RED_PONT})
		self.PackBtn1.numBg:setFlippedX(true)

		--------小喇叭
		self.btnHorn = self.view:getChildByName("Button_horn")
		self.btnHorn:setScale(0.8)
		self.btnHorn:addTouchEventListener(handler(self,self.onBtnHornClick))
		--self.btnHorn:setVisible(false)


    G_FitScreen(self, "Image_1")
    local centerPanel = self.view:getChildByName("Panel_4")
    self.p_yj = centerPanel:getChildByName("Panel_youxiang")
		self.p_yj:addTouchEventListener(handler(self,self._panleCallback))

		self.p_cj = centerPanel:getChildByName("Panel_choujiang")
		self.p_cj:addTouchEventListener(handler(self,self._panleCallback))
		

		local p_hc = centerPanel:getChildByName("Panel_hecheng")
		p_hc:addTouchEventListener(handler(self,self._panleCallback))

		self.p_hc = p_hc

		self.p_gh = centerPanel:getChildByName("Panel_gonghui")
		self.p_gh:addTouchEventListener(handler(self,self._panleCallback))

		local p_xs = centerPanel:getChildByName("Panel_xunshou")
		p_xs:addTouchEventListener(handler(self,self._panleCallback))

		self.p_xs = p_xs

		local p_sd = centerPanel:getChildByName("Panel_shangdian")
		p_sd:addTouchEventListener(handler(self,self._panleCallback))

    local params = {id=404814,x=315,y=345,addTo=centerPanel:getChildByName("Panel_5"),depth=10}
    mgr.effect:playEffect(params)
    
    local params = {id=404815,x=315,y=355,addTo=centerPanel,depth=-200}
    mgr.effect:playEffect(params)
    
    --local yy = centerPanel:getPositionY()*(display.height/960)
    --centerPanel:setPositionY(yy)

    ---主城装饰
    local delay = cc.DelayTime:create(1)
    local callfunc = cc.CallFunc:create(function()
    		local params = {id=404824,x=315,y=385,playIndex=2,addTo=centerPanel,depth=5,loadComplete=function(arm)
    				local tar = arm
    				local move1 = cc.MoveBy:create(0.7, cc.p(-120, 0))
    				local callFunc1 = cc.CallFunc:create(function()
    						tar:setScaleX(1)
    				end)
    				local delay1 = cc.DelayTime:create(0.5)
    				local move2 = cc.MoveBy:create(0.7, cc.p(120,0))
    				local callFunc2 = cc.CallFunc:create(function()
    						tar:setScaleX(-1)
    				end)
    				local delay2 = cc.DelayTime:create(0.5)
    				tar:runAction(cc.RepeatForever:create(cc.Sequence:create(callFunc1,move1,delay1,callFunc2,move2,delay2)))
    		end}
    		mgr.effect:playEffect(params)

    		local params = {id=404824,x=415,y=385,playIndex=3,addTo=centerPanel,depth=5,loadComplete=function(arm)
    				local tar = arm
    				local move1 = cc.MoveBy:create(0.7, cc.p(-205, 0))
    				local callFunc1 = cc.CallFunc:create(function()
    						tar:setScaleX(1)
    				end)
    				local delay1 = cc.DelayTime:create(0.5)
    				local move2 = cc.MoveBy:create(0.7, cc.p(205,0))
    				local callFunc2 = cc.CallFunc:create(function()
    						tar:setScaleX(-1)
    				end)
    				local delay2 = cc.DelayTime:create(0.5)
    				tar:runAction(cc.RepeatForever:create(cc.Sequence:create(callFunc1,move1,delay1,callFunc2,move2,delay2)))
    		end}
    		mgr.effect:playEffect(params)

        local params = {id=404824,x=250,y=275,playIndex=0,addTo=centerPanel,depth=5}
        mgr.effect:playEffect(params)

        local params = {id=404824,x=400,y=300,playIndex=1,addTo=centerPanel,depth=5}
        mgr.effect:playEffect(params)
    end)
    self:runAction(cc.Sequence:create(delay, callfunc))


    self:setRedPoint()

    self:hidbtn()--隐藏按钮

    if res.banshu then 
    	self.p_cj:setVisible(false)
    	p_xs:setVisible(false)
    	p_gh:setVisible(false)

    	self.ListButton1[1]:getInstance():setVisible(false)


    	centerPanel:getChildByName("Image_11_0"):setVisible(false)
    	centerPanel:getChildByName("Image_12_0"):setVisible(false)

    	centerPanel:getChildByName("Image_11_4"):setVisible(false)
    	centerPanel:getChildByName("Image_12_4"):setVisible(false)

    	centerPanel:getChildByName("Image_11_3"):setVisible(false)
    	centerPanel:getChildByName("Image_12_3"):setVisible(false)

    	self.view:getChildByTag(3):setVisible(false)
    	self.view:getChildByTag(1):getChildByTag(5):setVisible(false)
	end

	self:schedule(self.changeTimes,1.0)

end


function MainView:_set5ze()
	-- body
	local png = display.newSprite(res.icon.CONTEST_SHOP_ZHE[1])
	png:setScale(1.2)
	png:setPosition(self.p_cj:getContentSize().width/2-45,self.p_cj:getContentSize().height/2-48)
	png:addTo(self.p_cj,1000)
end




--小恶魔兽 ---一个限时道具 11-3日更新版本 
function MainView:setEmosou()
	-- body
	if self.img_camp then 
		self.img_camp:removeSelf()
		self.img_camp = nil 
	end

	if self._txt then 
		self._txt:removeSelf()
		self._txt = nil 
	end

	if self.img_em then 
		self.img_em:removeSelf()
		self.img_em = nil 
	end


	local data = cache.Pack:getIteminfoByMid(pack_type.PRO,221015065) 
	if not data then 
		return 
	end

	local panle = self.view:getChildByTag(1)
	local btn = self.ListButton1[5]:getInstance()

	self.img_em = ccui.ImageView:create()
	self.img_em:setTouchEnabled(true)
	self.img_em:loadTexture("res/views/ui_res/bg/bg_11_2.png")
	self.img_em:setPosition(btn:getPositionX(),btn:getPositionY() - self.img_em:getContentSize().height)
	self.img_em:addTo(panle)

	local time = 0
	if data.propertys[40108] then 
		time = 10800 - data.propertys[40108].value
	end

	if time < 0 then 
		time = 0
	end

	local _txt = ccui.Text:create() 
	if time == 0 then 
		_txt:setString(res.str.MAILVIEW_GET)
	else
		_txt:setString(string.formatNumberToTimeString(time))
	end
	_txt:setFontSize(20)
	_txt:setFontName(res.ttf[1])
	_txt:setPosition(self.img_em:getContentSize().width/2,_txt:getContentSize().height/2)
	_txt:addTo(self.img_em)

	self._txt = _txt

	self.img_em.data = data
	self.img_em:addTouchEventListener(handler(self, self.onBtnGet))
end

function MainView:onBtnOpen( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.began then
		sender_:setScale(0.8)
	elseif eventtype == ccui.TouchEventType.ended then 
		sender_:setScale(1.0)

		local lv = 0
		local str_tis = ""
		self.listActive = conf.active:getallFuben()
		for k ,v in pairs(self.listActive) do 
			if v.id == 5 then
				lv = v.lv
				str = v.tips
				break
			end
		end 

		if lv > cache.Player:getLevel() then 
			local str = string.format(res.str.SYS_OPNE_LV, lv)
			if str_tis ~= "" then 
				str = str_tis
			end
			G_TipsOfstr(str)
			return 
		end

		mgr.SceneMgr:getMainScene():changePageView(5)
		proxy.Camp:send120101()
		mgr.NetMgr:wait(520101)

	end
end

function MainView:setCamp()
	-- body
	if self.img_camp then 
		self.img_camp:removeSelf()
		self.img_camp = nil 
	end

	local count = cache.Player:getCamp()
	if count < 1 then
		return 
	end

	local btn = self.ListButton1[5]:getInstance()
	local pos = {}
	pos.x = btn:getPositionX()
	pos.y = btn:getPositionY()
	if self.img_em then 
		pos.y = self.img_em:getPositionY()
	end

	local panle = self.view:getChildByTag(1)
	self.img_camp = ccui.ImageView:create()
	self.img_camp:setTouchEnabled(true)
	self.img_camp:loadTexture(res.icon.CAMP_MIAN)
	self.img_camp:setPosition(btn:getPositionX(),pos.y - self.img_camp:getContentSize().height)
	self.img_camp:addTo(panle)
	self.img_camp:addTouchEventListener(handler(self, self.onBtnOpen))
end

function MainView:onBtnOpenBoss( sender_,eventtype  )
	-- body
	if eventtype == ccui.TouchEventType.began then
		sender_:setScale(0.8)
	elseif eventtype == ccui.TouchEventType.ended then 
		sender_:setScale(1.0)

		local lv = 0
		local str_tis = ""
		self.listActive = conf.active:getallFuben()
		for k ,v in pairs(self.listActive) do 
			if v.id == 8 then
				lv = v.lv
				str = v.tips
				break
			end
		end 

		if lv > cache.Player:getLevel() then 
			local str = string.format(res.str.SYS_OPNE_LV, lv)
			if str_tis ~= "" then 
				str = str_tis
			end
			G_TipsOfstr(str)
			return 
		end

		--mgr.SceneMgr:getMainScene():changePageView(5)
		proxy.Boss:send_126005()

	end
end

function MainView:setBoss()
	-- body
	if self.boss and not tolua.isnull(self.boss) then 
		self.boss:removeSelf()
		self.boss = nil
	end
	local count = cache.Player:getBoss()
	if count < 1 then
		
		return 
	end

	local btn = self.ListButton1[5]:getInstance()
	local pos = {}
	pos.x = btn:getPositionX()
	pos.y = btn:getPositionY()
	if self.img_camp then 
		pos.y = self.img_camp:getPositionY()
	elseif self.img_em then
		pos.y = self.img_em:getPositionY()
	end

	local panle = self.view:getChildByTag(1)
	self.boss = ccui.ImageView:create()
	self.boss:setTouchEnabled(true)
	self.boss:loadTexture(res.icon.BOSSMAIN)
	self.boss:setPosition(btn:getPositionX(),pos.y - self.boss:getContentSize().height)
	self.boss:addTo(panle)
	self.boss:addTouchEventListener(handler(self, self.onBtnOpenBoss))

end

function MainView:changeTimes( ... )
	-- body
	local data = cache.Pack:getIteminfoByMid(pack_type.PRO,221015065) 
	if not data then 
		return 
	end
	if self._txt then 
		local time = 0
		if data.propertys[40108] then 
			time = data.propertys[40108].value
		end

		time = 10800-time

		if time <0  then
			time = 0
		end
		if time == 0 then 
			self._txt:setString(res.str.MAILVIEW_GET)
		else

			self._txt:setString(string.formatNumberToTimeString(time))
		end
	end
end

function MainView:onBtnGet(sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.began then
		sender_:setScale(0.8)
	elseif eventtype == ccui.TouchEventType.ended then 
		--debugprint("物品可领取")
		sender_:setScale(1.0)
		local view = mgr.ViewMgr:showView(_viewname.OPEN_FUNC)
		view:setTool()
	end
end

function MainView:onEnter(  )
	local code = cache.Player:getCode()
	if code == nil or code == "" then
		return
	end
	proxy.Invatate:invitate(code)
end




function MainView:hidbtn()
	-- body
	if cache.Player:get11OpenFunc() > 0 then 
		self.ListButton1[6]:getInstance():setVisible(true)
	else
		self.ListButton1[6]:getInstance():setVisible(false)
	end

	if g_var.platform~="win32" and res.stop then 
		if res.stop then 
       		for k ,v in pairs(self.ListButton1) do
			--print(v:getInstance():getName())
				local name = v:getInstance():getName();
				if  name and "Button_9_3" == name   or "Button_activity"== name then 
					v:getInstance():setVisible(false)
				end 
			end 
			
			self.PackBtn1:getInstance():setVisible(false)
   		end 
	end 
end

function MainView:NextStep( objstr )
	-- body
	self:_panleCallback(self[tostring(objstr)], ccui.TouchEventType.ended)
end

function MainView:_panleCallback(sender,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		if sender:getName()=="Panel_gonghui"  and   cache.Player:getLevel()<1 then 
			G_TipsOfstr(string.format(res.str.GUILD_DEC42,1))
			return 
		end
		G_setMaintopinit()
		if sender:getName() == "Panel_youxiang" then --邮箱
			mgr.SceneMgr:getMainScene():changeView(10)
			
			--
		elseif sender:getName()=="Panel_choujiang" then --抽奖
			--todo
			mgr.SceneMgr:getMainScene():changeView(9)
            local ids = {1005}
            mgr.Guide:continueGuide__(ids)
            mgr.Sound:playViewBLJ()
		elseif sender:getName()=="Panel_hecheng" then --合成
			mgr.SceneMgr:getMainScene():changeView(11)
            mgr.Sound:playViewHC()
		elseif sender:getName()=="Panel_gonghui" then --公会

      	  proxy.guild:sendGuilmsg()
        --mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_VIEW)
		    --G_TipsOfstr(res.str.MAIN_VIEW_MESS)
		elseif sender:getName()=="Panel_xunshou" then --驯兽师
			proxy.Contest:sendWinnerMsg()
			mgr.NetMgr:wait(519101)
		elseif sender:getName()=="Panel_shangdian" then --神秘商店
			mgr.SceneMgr:getMainScene():changeView(1,_viewname.SHOP)
		end 
	end
end


--更新红点数量
function MainView:setRedPoint()
	local num=0
	tablenum = NEW_ITEM_APCK_AMOUNT --背包
	for i=1,#tablenum do
		num=num+tablenum[i]
	end
	local count = cache.Pack:getSptypeCount()
	self.PackBtn:setNumber(num+count)
	--任务
	local numrewu = cache.Player:getRWnumber() + cache.Player:getGetTaskHy()

	self.ListButton1[4]:setNumber(numrewu)
	--成就 
	self.ListButton1[5]:setNumber(cache.Player:getCJnumber())
	--vip礼包 可购买数量
	self.ListButton1[2]:setNumber(cache.Player:getVIPLBnumber())
	--签到
	self.ListButton1[3]:setNumber(cache.Player:getQDnumber())
	--好友
	self.PackBtn1:setNumber(cache.Player:getHaoYNumber())
	--双11活动
	self.ListButton1[6]:setNumber(cache.Player:get11Redpoint())


	--首次充值
	if cache.Player:getFirst40303() == 1 then --有
		self.ListButton1[1]:setNumber(-1)
	else
		self.ListButton1[1]:setNumber(0)
	end 
	--self.guiBtnChat:setNumber(3)


	local function setRedPointPanle( ppa )
		-- body
		--printt(ppa)
		local count = ppa.num--cache.Player:getYJnumber()
		ppa.panle:removeAllChildren()
		local spr = display.newSprite(res.image.RED_PONT)
		spr:setPosition(ppa.panle:getContentSize().width/2+ppa.x,ppa.panle:getContentSize().height/2+ppa.y)
		
		if count > 0 then 
			spr:addTo(ppa.panle)
			local label = display.newTTFLabel({
			    text = count,
			    size = 20,
			    align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
			})
			label:setPosition(spr:getContentSize().width/2,spr:getContentSize().height/2)
			label:addTo(spr)
		elseif count == -1 then 
			spr:addTo(ppa.panle)			
		end 
		--是否显示折扣标示
		--self:_set5ze()
	end

	--邮件
	local params = {}
	params.num = cache.Player:getYJnumber() > 0 and -1 or 0
	params.x = 45
	params.y = -41
	params.panle = self.p_yj

	setRedPointPanle(params)
	--暴龙机
	local params = {}
	local lasttime  = cache.Lucky:getlastTime()
	params.num = cache.Pack:getItemAmountByMid(pack_type.PRO,221015001)
	--print(lasttime)
	if not lasttime or lasttime == 0 then 
		params.num = params.num + 1
	end 
	params.x = 44
	params.y = -52
	params.panle = self.p_cj
	setRedPointPanle(params)
	--公会
	self.p_gh:removeAllChildren()
	local params = {}
	params.x = 50
	params.y = -38
	params.panle = self.p_gh
	if cache.Player:getGongHJLNumber() > 0 
		or (cache.Player:getGongHFuBJLNumber() > 0 and cache.Player:getLevel()>=30)
		or cache.Player:getGongHTongGJLNumber() > 0 
		or  cache.Player:getShenHeNumber()>0 then 
		params.num = -1 
	else
		params.num = 0
	end 

	if cache.Player:getGuildId().key~="0_0" then 
		--debugprint("公会红点")
		setRedPointPanle(params)
	end 

	--驯兽师王
	if  (cache.Player:getWangNumber() > 0 or cache.Player:getWangSetNumber()>0) then 
		--暴龙机
		local params = {}
		local lasttime  = cache.Lucky:getlastTime()
		params.num = -1
		params.x = 64
		params.y = -48
		params.panle = self.p_xs
		setRedPointPanle(params)
	end 
	--合成
	if G_IsCompose() then 
		local params = {}
		params.num = -1
		params.x = 44
		params.y = -43
		params.panle = self.p_hc
		setRedPointPanle(params)
	end

	self:setEmosou() 
	self:setCamp()
	--self:setBoss()

	--是否开启 豪礼大放送
	self:setHaoLi()
	--设置豪礼大放送红点
end

function MainView:setHaoLi(  )
	if self.haoLiBtn then
		self.haoLiBtn:removeFromParent()
		self.haoLiBtn = nil
		self.guiHaoLiBtn = nil
	end

	if cache.Player:getRichRank() < 1 then
		return
	end
	

	local btn = self.ListButton1[6]:getInstance()
	local posx,posy = btn:getPosition()
	local panle = self.view:getChildByTag(1)

	self.haoLiBtn = ccui.Button:create("res/views/ui_res/icon/haoli_main.png")
	panle:addChild(self.haoLiBtn)
	panle:reorderChild(self.haoLiBtn ,1000)
	self.haoLiBtn:setPosition(posx,posy)

	--红点实例BTN
	self.guiHaoLiBtn=gui.GUIButton.new(self.haoLiBtn,handler(self,self.onListCallBack1),{x=5,y=52,ImagePath=res.image.RED_PONT})
	
	--设置红点
	local num = cache.Player:getRichRankNumber()
	num = num + cache.Player:getXfhlRedpoint()
	print(num,num)
	--num = num + cache.Player:getRednewBag()
	--num = num + cache.Player:getNewRed()
	
	
	--G_TipsOfstr(num)
	if num and num > 0 then
		self.guiHaoLiBtn:setNumber(-1)
	else
		self.guiHaoLiBtn:setNumber(0)
	end

	--self.guiHaoLiBtn:setNumber(0)

	if cache.Player:get11OpenFunc() > 0 then
		self.haoLiBtn:setPositionY(posy-self.haoLiBtn:getContentSize().height)
	end
	self.haoLiBtn:addTouchEventListener(handler(self,self.haoliBtnCallback))

end

function MainView:haoliBtnCallback( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		--mgr.SceneMgr:getMainScene():changeView(19)
		G_setMaintopinit()
		proxy.Active:reqSwitchState(nil,3)
	end
end






function MainView:dataChanged( data )
	-- body
	if data.awardState == 1 then
		local count = conf.qiandao:getReWardKindsByDayOffset(0)
		self.ListButton1[3]:setNumber(count)
	end

end

--背包按钮回调
function MainView:onPackCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		--mgr.ViewMgr:showView(_viewname.SYS_GONGGAO):setData()
		--检测背包是否有数据
		if not G_CheckData() then 
			return 
		end 

		G_setMaintopinit()
		mgr.SceneMgr:getMainScene():changeView(7)
        --点击背包
        local ids = {1035}
        mgr.Guide:continueGuide__(ids)
	end
end
--好友
function MainView:onActivityCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		if res.stop then 
			G_TipsOfstr(res.str.ROLE_GONGHUI)
			return 
   		end 

		G_setMaintopinit()
        mgr.Sound:playViewHY()
       	mgr.SceneMgr:getMainScene():changeView(15)
	    	
	end
end

---小喇叭按钮回调

function MainView:onBtnHornClick( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		if cache.Player:getLevel() < res.kai.horn then
			G_TipsOfstr(string.format(res.str.SYS_OPNE_LV, res.kai.horn))
			return
		end
		mgr.ViewMgr:showView(_viewname.HORN):setMainEnter()
		--mgr.SceneMgr:getMainScene():changeView(17)
	end
end


function MainView:onListCallBack1(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		local btnId=send:getTag()

		if res.stop then 
       		local name = send:getName();
			if  name and "Button_9_3" == name   then 
				G_TipsOfstr(res.str.ROLE_GONGHUI)
				return 
			end 
			--self.PackBtn1:getInstance():setVisible(false)
   		end 

   		--[[if g_recharge then 
			if  btnId ==1   then 
				G_TipsOfstr(res.str.ROLE_GONGHUI)
				return 
			end 
   		end ]]--

   		--[[if res.banshu then 
   			if btnId == 1 then 
   				G_TipsOfstr(res.str.ROLE_GONGHUI)
   				return 
   			end 
   		end ]]--

		G_setMaintopinit()
		if btnId == 1 then  -- 充值
			mgr.SceneMgr:getMainScene():changeView(4,_viewname.SHOP)
            mgr.Sound:playViewCZ()
		elseif btnId == 2 then -- vip礼包
			mgr.SceneMgr:getMainScene():changeView(3,_viewname.SHOP)
            local ids = {1016,1030}
            mgr.Guide:continueGuide__(ids)
            mgr.Sound:playViewVip()
		elseif btnId == 3 then -- 登陆奖励
			----请求签到信息
			proxy.signIn:reqSignInfo()
            mgr.Sound:playViewDL()
		elseif btnId == 4 then -- 任务
			mgr.SceneMgr:getMainScene():changeView(13)
            mgr.Sound:playViewRW()
		elseif btnId == 5 then -- 成就
			if cache.Player:getLevel()<res.kai.achi then 
				G_TipsOfstr(string.format(res.str.SYS_OPNE_LV, res.kai.achi))
				return 
			end 
			local view = mgr.SceneMgr:getMainScene():changeView(12)
     		mgr.Sound:playViewChengjiu()
     		if cache.Player:getCJnumber()>0 then 
     			view:pageClick(2)
     		end 
     	elseif btnId == 6 then 
     		mgr.SceneMgr:getMainScene():changeView(19)
		end
	  
	end

end
function MainView:updateLsitButton1(index,boolean)
	local btn_path=nil 
	local Num= 0
	if boolean then 
		btn_path=res.btn.MAIN_UNIVERSALLY_DARK		 --灰色按钮
	else
		btn_path=res.btn.MAIN_UNIVERSALLY_BRIGHT   --亮按钮
	end
	self.ListButton1[index]:setNumber(Num) --设置右上角数字
	self.ListButton1[index]:getInstance():loadTextures(btn_path,btn_path) --切换纹理贴图
end

function MainView:updateLsitButton2(  )

end

function MainView:btnCallBack(sender_, eventType_ )
	-- if eventType_ == ccui.TouchEventType.ended then
	-- 	mgr.SceneMgr:LoadingScene(_scenename.GAME)
	-- end
end



return MainView