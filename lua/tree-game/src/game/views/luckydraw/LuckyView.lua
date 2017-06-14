--[[
	抽奖 道具抽奖  钻石抽奖1次 钻石抽奖10次
]]--

local LuckyView=class("LuckyView",base.BaseView)
local pet= require("game.things.PetUi")

function LuckyView:ctor()
	-- body
	self.scale = 1 --凡达
end

function LuckyView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self._panlechou = self.view:getChildByName("Panel_1")

	--self._panlechou:setPositionX(display.cx-self.)
	--self._panlechou:setPositionY(display.cy)

	self._btnrecharge = self._panlechou:getChildByName("btn_recharge")
	self._btnrecharge:addTouchEventListener(handler(self,self.onBtnRechargeCallBack))

	self._btnChou = self._panlechou:getChildByName("btn_chou")
	self._btnChou:setTouchEnabled(false)
	--self._btnChou:addTouchEventListener(handler(self,self.onBtnChouJiangCallBack))
	--
	
	--抽奖用的道具个数
	self._djcount =self._panlechou:getChildByName("btn_chou_1"):getChildByName("txt_num") 
	self.btndjcount =self._panlechou:getChildByName("btn_chou_0") 
	self.btndjcount:setTag(4)
	self.btndjcount:addTouchEventListener(handler(self,self.onBtnChoucallbcak))
	--再抽多少次
	self._choucount = self._panlechou:getChildByName("btn_chou_2"):getChildByName("txt_num_3") 
	--进度条

	--免费倒计时狂
	self._kuang = self._panlechou:getChildByName("btn_chou_2"):getChildByName("Image_18")

	self._times = self._kuang:getChildByName("Text_23_0")

	--txt self._mianfei self._zsIcon self._price
	self._mianfei =  self._panlechou:getChildByName("txt_mianf")
	self._zsIcon = self._panlechou:getChildByName("img_Kuang_2"):getChildByName("icon_9")
	self._price = self._panlechou:getChildByName("img_Kuang_2"):getChildByName("txt_dec_0_11")
	local pn = self._panlechou:getChildByName("img_Kuang_2"):getChildByName("icon_12_0_0")
	--单次抽取 折扣 
	pn:setVisible(false)
	pn:loadTexture(res.icon.CONTEST_SHOP_ZHE[1])
	pn:setScale(self.scale)


	self.ListButton1 = {}
	local size =3
	for i=1,size do
		local btn=self._panlechou:getChildByName("btn_chou_"..i)
		btn:setTag(i)
		--btn:setPressedActionEnabled(false)
		btn:setZoomScale(0)
		--self.ListButton1[#self.ListButton1+1] = gui.GUIButton.new(btn,handler(self,self.onBtnChoucallbcak))
		btn:addTouchEventListener(handler(self,self.onBtnChoucallbcak))
	end
	--self.times = 5;

	local btn =  self._panlechou:getChildByName("Button_close")
	btn:addTouchEventListener(handler(self,self.onbtnclose))

	self:setData(cache.Lucky:getDataInfo())
	
    G_FitScreen(self, "Image_1")

    local Image_13 = self._panlechou:getChildByName("Image_13")
    if cache.Player:getDoubleRecharge()>0 then 
		Image_13:setVisible(true)
	else
		Image_13:setVisible(false)
	end

    self:performWithDelay(function()
		-- body
		local effConfig = conf.Effect:getInfoById(404823)
		mgr.BoneLoad:addLoad(effConfig.effect_id,function()
			-- body
		end)

	end, 0.1)
   
    --[[local effConfig = conf.Effect:getInfoById(404086)
	mgr.BoneLoad:addLoad(effConfig.effect_id,function()
		-- body
	end)
	local effConfig = conf.Effect:getInfoById(404816)
	mgr.BoneLoad:addLoad(effConfig.effect_id,function()
		-- body
	end)]]--

	self:initDec()
end

function LuckyView:initDec()
	-- body
	self._btnrecharge:setTitleText(res.str.LUCKY_DEC_01)
	self._btnChou:setTitleText(res.str.LUCKY_DEC_02)

	self._panlechou:getChildByName("img_Kuang_1"):getChildByName("txt_dec"):setString(res.str.LUCKY_DEC_03)
	self._panlechou:getChildByName("img_Kuang_2"):getChildByName("txt_dec_9"):setString(res.str.LUCKY_DEC_03)
	self._panlechou:getChildByName("img_Kuang_3"):getChildByName("txt_dec_13"):setString(res.str.LUCKY_DEC_03)
	local pa = self._panlechou:getChildByName("img_Kuang_3"):getChildByName("icon_12_0")
	pa:setScale(self.scale)
	--单次抽取 10次收取
	pa:loadTexture(res.icon.CONTEST_SHOP_ZHE[5])
	self._panlechou:getChildByName("txt_mianf"):setString(res.str.LUCKY_DEC_04)

	local dec_de1 = self._panlechou:getChildByName("txt_mianf_0")
	dec_de1:setAnchorPoint(cc.p(0,0.5))
	dec_de1:setString(res.str.RES_GG_84)

	local dec_de2 = self._panlechou:getChildByName("txt_mianf_0_0")
	dec_de2:setAnchorPoint(cc.p(0,0.5))
	dec_de2:setString(res.str.RES_GG_85)

	local w = dec_de1:getContentSize().width + dec_de2:getContentSize().width
	local sx = ( display.width - w ) / 2
	dec_de1:setPositionX(sx)
	dec_de2:setPositionX(sx + dec_de1:getContentSize().width)

	self._kuang:getChildByName("Text_23"):setString(res.str.LUCKY_DEC_05)

	self._panlechou:getChildByName("img_Kuang_2"):getChildByName("txt_dec_0_11"):setString(conf.Sys:getValue("lucky_zs1_money"))
	self._panlechou:getChildByName("img_Kuang_3"):getChildByName("txt_dec_0_15"):setString(conf.Sys:getValue("lucky_zs10_money"))
	
end

function LuckyView:onBtnRechargeCallBack( send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		mgr.SceneMgr:getMainScene():changeView(4,_viewname.SHOP)
		--self:onCloseSelfView()
	end
end

function LuckyView:onbtnclose(  send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end
end

--[[function LuckyView:onBtnChouJiangCallBack( send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		--debugprint("抽奖界面")
		--self._panlechou:setVisible(true)
	end
end]]--


function LuckyView:onBtnChoucallbcak( send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		--debugprint("抽 "..send:getTag())
		if self.delay then 
			if os.time()- self.delay < 1 then
				G_TipsOfstr(res.str.COM_DEC)
				return 
			end  
		end 

		self.delay = os.time()
		--print("self.delay = "..self.delay)
		local tag = send:getTag()
		proxy.lucky:sendMessage(tag,true)
	end
end
--设置道具个数
function LuckyView:setItemNum( count_ )
	-- body
	count_ = count_ and count_ or 0
	self._djcount:setString(count_)
	if count_<= 0 then
		self.btndjcount:setVisible(false)
	else
		local min = math.min(10,count_)
		self.btndjcount:setTitleText(string.format(res.str.RES_RES_55,min))
	end
end
--设置钻石抽奖还差多少次
function LuckyView:setMoretimes( count_ )
	-- body
	self._choucount:setString(count_)
end

--设置倒计时
function LuckyView:setTimes( times_ )
	-- body
	if times_>0  then 
		self._kuang:setVisible(true)
		self._times:setString(string.formatNumberToTimeString(times_))

		self._zsIcon:setVisible(true) 
		self._price:setVisible(true) 
		self._mianfei:setVisible(false) 
	else
		self._kuang:setVisible(false)
		
		self._zsIcon:setVisible(false) 
		self._price:setVisible(false) 
		self._mianfei:setVisible(true) 
	end
end

function LuckyView:update( dt )
	-- body
	if  cache.Lucky:getRecordTime() and  self.data and self.data.lastTime  then 
		local time = self.data.lastTime-(os.time()- cache.Lucky:getRecordTime())
		self:setTimes(time)
	end
end

function LuckyView:setData( data_ )
	-- body
	self.data = data_
	--self.times = self.data.lastTime

	self:setMoretimes(self.data.bdCount)

	self:setItemNum(cache.Pack:getItemAmountByMid(pack_type.PRO,221015001))

	local listener = function (dt)
		self:update(dt)
    end
	self:scheduleUpdateWithPriorityLua(listener, 1.0) 
end


function LuckyView:severCallBack(data_)
	-- body
	--先播放一个动画 播放期间不给点击
	local layer = ccui.Layout:create()
    layer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    layer:setBackGroundColor(cc.c3b(0, 0, 0))
    layer:setBackGroundColorOpacity(200)
    layer:setContentSize(cc.size(display.width,display.height))
    layer:setTouchEnabled(true)
    layer:setTouchSwallowEnabled(true)

   
    local colorbailayer = ccui.Layout:create()
	colorbailayer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	colorbailayer:setBackGroundColor(cc.c3b(255, 255, 255))
	colorbailayer:setBackGroundColorOpacity(0)
	colorbailayer:setContentSize(cc.size(display.width,display.height))
	colorbailayer:addTo(layer)
    --self.view:addChild(layer,1000) 
    mgr.SceneMgr:getNowShowScene():addChild(layer, 10000)
    local function onFunction( event ) --触发
    	if event == "UP" then 
    		local i = 1
    		local a1 = cc.CallFunc:create(function()
    			-- body
    			i = i + 10
    			colorbailayer:setBackGroundColorOpacity(i)
    		end)
    		local a2 = cc.DelayTime:create(0.009)
    		local sequence = cc.Sequence:create(a1,a2)
    		colorbailayer:runAction(cc.RepeatForever:create(sequence))
    	end 
    end 


    local params =  {id=404823, x=layer:getContentSize().width/2,y=layer:getContentSize().height/2,
    addTo=layer,playIndex=0,addName = "effofname1",depth = 3,triggerFun = onFunction,retain = true
    ,endCallFunc = function( ... )
    	-- body
    	layer:removeFromParent()
    	local view = mgr.ViewMgr:get(_viewname.PACKGETITEM)
		if view == nil  then 
			view = mgr.ViewMgr:showView(_viewname.PACKGETITEM)	
		end	
		view:setData(data_,true)
    end
	}
    mgr.effect:playEffect(params)
end

function LuckyView:onCloseSelfView()
	G_mainView()
end

return LuckyView