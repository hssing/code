--[[
	BossMainView 世界boss
]]

local BossMainView = class("BossMainView",base.BaseView)

function BossMainView:ctor()  
	self.request = 5 --每3秒 请求一次
	self.start_time = 0
end

function BossMainView:init()
	-- body
	self.ShowAll = true
	self.showtype=view_show_type.UI   
    self.view=self:addSelfView()

    local pan_top = self.view:getChildByName("Panel_1")
    self.pan_top = pan_top
    local btn_clsoe = pan_top:getChildByName("Button_1")
    btn_clsoe:addTouchEventListener(handler(self,self.onBtnClose))
    --规则
	local btn_guize = pan_top:getChildByName("Button_1_0")
    btn_guize:addTouchEventListener(handler(self,self.onBtnGuize))
    --奖励
    local btn_reward = pan_top:getChildByName("Button_1_0_0")
    btn_reward:addTouchEventListener(handler(self,self.onbtnReward))

    local pan_mid = self.view:getChildByName("Panel_2")
    self.pan_mid = pan_mid

    local panel_bottom = self.view:getChildByName("Panel_2_0")
    self.panel_bottom = panel_bottom
    --鼓舞
    self.btn_guwu = panel_bottom:getChildByName("Button_12")
    self.btn_guwu:addTouchEventListener(handler(self,self.onbtnGuwuCallBack))
    --匹配
    self.btnwar = panel_bottom:getChildByName("Button_12_0")
    self.btnwar:addTouchEventListener(handler(self,self.onbtnStartCall))

    --制动匹配
    self._checkbox = panel_bottom:getChildByName("CheckBox_1")
    self._checkbox:setSelected(false)
    self._checkbox:addEventListener(handler(self, self.checkBoxCallback))

    self:schedule(self.changeTimes,1.0,"changeTimes")

    self:initDec()
    self:palyForever()
    G_FitScreen(self,"Image_1")
end

function BossMainView:palyForever( ... )
	-- body
	local armature = mgr.BoneLoad:loadArmature(404826,4)
    armature:setPosition(display.cx,display.cy)
	--armature:setScale(self.scale)
	armature:addTo(self.view)

	self.bossarmature = mgr.BoneLoad:createArmature(404861)
	self.bossarmature:setPosition(self.pan_mid:getPosition())
	self.bossarmature:addTo(self.view)
	self.bossarmature:setVisible(false)

	self.view:reorderChild(self.view:getChildByName("Image_5"), 10)
	self.view:reorderChild(self.bossarmature, 9)
	self.view:reorderChild(self.panel_bottom, 10)
end

function BossMainView:initDec()
	-- body
	self.lab_dec = self.pan_top:getChildByName("Image_4"):getChildByName("Text_1")
	self.oldposx = self.lab_dec:getPositionX()
	self.lab_dec:setString("")

	self.lab_time = self.pan_top:getChildByName("Image_4"):getChildByName("Text_1_0")
	self.lab_time:setString("")

	self.loadBar = self.view:getChildByName("Image_5"):getChildByName("LoadingBar_1")
	self.loadBar:setPercent(100)

	self.loadBar_1 = self.view:getChildByName("Image_5"):getChildByName("LoadingBar_1_0")
	self.loadBar_1:setPercent(100)

	self.view:getChildByName("Image_5"):getChildByName("Text_2"):setString(res.str.RES_GG_41)
	self.lab_per = self.view:getChildByName("Image_5"):getChildByName("Text_2_0")
	self.lab_per:setString("")

	self.img_jisha = self.view:getChildByName("Image_5"):getChildByName("Image_29") 
	self.img_jisha:setVisible(false)
	self.panel_bottom:getChildByName("Text_3"):setString(res.str.RES_GG_42)
	--加成百分比
	self.add_value = self.panel_bottom:getChildByName("Text_3_0")
	self.add_value:setString("")
	--复活时间
	self.lab_fuhuo = self.panel_bottom:getChildByName("Text_3_2")
	self.lab_fuhuo:setString("")

	self.panel_bottom:getChildByName("Text_3_1"):setString(res.str.RES_GG_43)
	self.panel_bottom:getChildByName("Text_3_1_0"):setString(res.str.RES_GG_44)
	--战斗结束
	self.img_over = self.pan_top:getChildByName("Image_4_0")
	self.img_over:setVisible(false)
	self.img_over:getChildByName("Text_1_5"):setString(res.str.RES_GG_90)

	self.lab_time_over = self.img_over:getChildByName("Text_1_0_7")
	self.lab_time_over:setString("")
end
--世界战力加成
function BossMainView:setWorldAddValue(value)
	-- body
	self.data.inspirePercent = value
	self.add_value:setString(self.data.inspirePercent .. "%")
end
--设置世界boss血量
function BossMainView:setBossHp()
	-- body
	if not self.data then
		return 
	end

	self.loadBar_1:setVisible(false)
	self.loadBar:setVisible(false)
	if self.data.bossGroupIndex < 1 then --bos 未开始
		self.loadBar:setVisible(true)
		self.lab_per:setString("100%")
		return
	end

	self.loadBar_1:setPercent(self.data.curHpPercent)
	self.loadBar:setPercent(self.data.curHpPercent)

	if self.data.curHpPercent <= 10 then
		self.loadBar_1:setVisible(true)
	else
		self.loadBar:setVisible(true)
	end

	self.lab_per:setString(self.data.curHpPercent.."%")
end

function BossMainView:playWenzi()
	-- body
	if self.data.curHpPercent <= 0 then
		return
	end

	for k ,v in pairs(self.data.recentFightList) do 

		--[[local richText = ccui.RichText:create()
		local size = 24
		--名字
		richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,192,0),255,v.playerName,res.ttf[1],size))
		richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,255,255),255,res.str.RES_GG_71,res.ttf[1],size))
		--伤害
		richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,192,0),255,v.damage,res.ttf[1],size))
		richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,255,255),255,res.str.RES_GG_72,res.ttf[1],size))
		richText:formatText()
		richText:setAnchorPoint(cc.p(0.5,0.5))
		richText:setPosition(display.cx,display.cy)
		richText:addTo(self.view,11)
		richText:setVisible(false)]]

		-- 左对齐，并且多行文字顶部对齐
		local label = display.newTTFLabel({
		    text = v.playerName..res.str.RES_GG_71..v.damage..res.str.RES_GG_72,
		    font = res.ttf[1],
		    size = 24,
		    color = cc.c3b(255, 0, 0), -- 使用纯红色
		    align = cc.TEXT_ALIGNMENT_LEFT,
		    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
		    dimensions = cc.size(200, 0)
		})

		local spr = display.newSprite(res.other.TISHI)
	    local _img = display.newScale9Sprite(res.other.TISHI,display.cx,display.cy
	        ,cc.size(label:getContentSize().width, label:getContentSize().height + 20),spr:getContentSize())
	    _img:setVisible(false)
	    _img:setAnchorPoint(cc.p(0,0))
	    local x = math.random(display.cx - 300 , display.cx + 50 )
        local y = math.random(display.cy - 300 , display.cy + 50 )
        _img:setPosition(x, y)
	    _img:addTo(self.view,11)

		local params_ = {text = {}, width= label:getContentSize().width , height=label:getContentSize().height} 
        params_.text[#params_.text+1] = {v.playerName,{255,192,0},24}
        params_.text[#params_.text+1] = {res.str.RES_GG_71,{255,255,255},24}
        params_.text[#params_.text+1] = {v.damage,{255,192,0},24}
        params_.text[#params_.text+1] = {res.str.RES_GG_72,{255,255,255},24}

        local richText = G_RichText(params_)
        richText:setAnchorPoint(cc.p(0,0.5))
        richText:setPosition(-_img:getContentSize().width/2,_img:getContentSize().height/2)
        richText:addTo(_img)
        --richText:setVisible(false)

		local function callback()
			-- body
			local a1 = cc.CallFunc:create(function( ... )
				-- body
				_img:setVisible(true)
			end)
			local t = {cc.p(0,0),cc.p(210,0),cc.p(210,240),cc.p(0,160),cc.p(0,0)}
			--local a2 = cc.CardinalSplineTo:create(3, t , 0)
			local a2 = cc.MoveTo:create(1.5,cc.p(_img:getPositionX(),_img:getPositionY()+100))



			local a3 = cc.CallFunc:create(function( ... )
				-- body
				_img:removeSelf()
			end )
			local sequence = cc.Sequence:create(a1,a2,a3)
			_img:runAction(sequence)
		end

		self:performWithDelay(callback, 1*k)
	end
end

function BossMainView:setData(data)
	-- body
	self.start_time = 0
	self.data = data 
	self:setBossHp()
	self:setWorldAddValue(self.data.inspirePercent)
	self:setAutoBattle(self.data.isAutoBattle)

	self.pan_mid:setBackGroundImage(res.image.BOSS_IMAGE)
	if data.bossGroupIndex > 0 then --有boss
		self.pan_mid:setVisible(false)
		if data.bossGroupIndex == 3 then 
			self.bossarmature:getAnimation():playWithIndex(0)
		else
			self.bossarmature:getAnimation():playWithIndex(data.bossGroupIndex-1)
		end
		self.bossarmature:performWithDelay(function( ... )
			-- body
			self.bossarmature:setVisible(true)
		end, 0.1)
		
	else
		self.bossarmature:setVisible(false)
		self.pan_mid:setVisible(true)
	end

	self:playWenzi()
	self:changeTimes()
end
--设置是否自动参战 0 不是 1 是
function BossMainView:setAutoBattle(value)
	-- body
	if value == 1 then
		self.btnwar:setTouchEnabled(false)
		self.btnwar:setBright(false)
		self._checkbox:setSelected(true)
	else
		self._checkbox:setSelected(false)
	end
end

function BossMainView:changeTimes()
	-- body
	self.start_time = self.start_time + 1
	print(self.start_time ,self.start_time%self.request)
	if self.start_time%self.request == 0 then
		proxy.Boss:send_126005()
		return
	end
	if not self.data then
		return 
	end


	self.img_jisha:setVisible(false)
	if self.data.curHpPercent <= 0 and self.data.bossGroupIndex >0 then 
		self.lab_fuhuo:setString("")

		self.img_jisha:setVisible(true)

		self.btnwar:setTouchEnabled(false)
		self.btnwar:setBright(false)

		self._checkbox:setTouchEnabled(false)
		self._checkbox:setBright(false)

		self.lab_dec:setString(res.str.RES_GG_73) 
		self.lab_dec:setPositionX(self.lab_dec:getParent():getContentSize().width/2+self.lab_dec:getContentSize().width/2)
		self.lab_time:setString("")

		if self.data.startToEndTime > 0 then 
			self.img_over:setVisible(true)
			self.lab_time_over:setString(string.formatNumberToTimeString(self.data.startToEndTime))
		else
			if self.data.bossGroupIndex >0 then 
				--proxy.Boss:send_126005()
			end
			self.img_over:setVisible(false)
		end
		return 
	end
	self.btnwar:setTouchEnabled(true)
	self.btnwar:setBright(true)

	self._checkbox:setTouchEnabled(true)
	self._checkbox:setBright(true)

	if self.data.remainTime  > 0 then
		self.bossarmature:setVisible(false)
		self.pan_mid:setVisible(true)

		self.btnwar:setTouchEnabled(false)
		self.btnwar:setBright(false)

		self._checkbox:setTouchEnabled(false)
		self._checkbox:setBright(false)
		if self.data.remainTime > 0 then 
			self.lab_dec:setString(res.str.RES_GG_40)
			self.lab_time:setString(string.formatNumberToTimeString(self.data.remainTime))
			self.lab_dec:setPositionX(self.oldposx)
		else
			self.lab_dec:setString("")
			self.lab_time:setString("")
		end
		if self.data.bossGroupIndex <=0 then
			--return 
		end
	else
		if self.data.startToEndTime > 0 then 
			self.img_over:setVisible(true)
			self.lab_time_over:setString(string.formatNumberToTimeString(self.data.startToEndTime))
		else
			if self.data.bossGroupIndex >0 then 
				--proxy.Boss:send_126005()
			end
			self.img_over:setVisible(false)
		end


		self.bossarmature:setVisible(true)
		self.pan_mid:setVisible(false)

		self.lab_dec:setString(res.str.RES_GG_45)
		self.lab_dec:setPositionX(self.lab_dec:getParent():getContentSize().width/2+self.lab_dec:getContentSize().width/2)
		self.lab_time:setString("")

		if self.data.bossGroupIndex <=0 then
			--proxy.Boss:send_126005()
			return 
		else
			
		end
	end

	if self.data.rebornTime > 0 then
		self.btnwar:setTouchEnabled(false)
		self.btnwar:setBright(false)
		local view = mgr.ViewMgr:get(_viewname.LOADING_VIEW) 
		if not view then
			self.lab_fuhuo:setString(string.format(res.str.RES_GG_46,self.data.rebornTime))
		end		
	else
		self.lab_fuhuo:setString("")
		if self.data.isAutoBattle <= 0 then
			self.btnwar:setTouchEnabled(true)
			self.btnwar:setBright(true)
		else
			self.btnwar:setTouchEnabled(false)
			self.btnwar:setBright(false)
		end

		if self.data.remainTime > 0 then --活动未开始
			self.btnwar:setTouchEnabled(false)
			self.btnwar:setBright(false)
		end
	end
end

function BossMainView:onbtnGuwuCallBack(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--打开鼓舞界面
		mgr.ViewMgr:showView(_viewname.BOSS_GUWU)
	end
end
--匹配
function BossMainView:onbtnStartCall(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		---挑战
		proxy.copy:onSFight(126001)
	end
end
--自动匹配
function BossMainView:checkBoxCallback( sender_, eventtype )
	-- body
	if cache.Player:getVip()<2 and cache.Player:getLevel() < tonumber(conf.Sys:getValue("level_worldboss_auto")) then 
		local data = {};
    	data.richtext = {
			--{text=res.str.RES_GG_64,fontSize=24,color=cc.c3b(255,255,255)},
			--{text=res.str.DEC_ERR_80,fontSize=24,color=cc.c3b(255,0,0)}
			{text=res.str.RES_GG_64,fontSize=24,color=cc.c3b(255,255,255)},
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
   		--[[local data = {}
   		data.richtext = {
			{text=res.str.PROMOTEN_DEC1,fontSize=24,color=cc.c3b(255,255,255)},
			{text=res.str.PROMOTEN_DEC2,fontSize=24,color=cc.c3b(255,0,0)},
			{text=res.str.PROMOTEN_DEC3,fontSize=24,color=cc.c3b(255,255,255)},
			{text=res.str.PROMOTEN_DEC4,fontSize=24,color=cc.c3b(255,0,0)},
			{text=res.str.PROMOTEN_DEC5,fontSize=24,color=cc.c3b(255,255,255)},
			}
			data.sure =function( ... ) end 
			data.surestr =  res.str.COMPOSE_CARD_SURE
			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,true)]]--

   		self._checkbox:setSelected(false)
   		return 
	end

	if eventtype == ccui.CheckBoxEventType.selected then
		--按下
		proxy.Boss:send_126002({autoBattle = 1})
	else
		proxy.Boss:send_126002({autoBattle = 0})
	end
end

function BossMainView:onbtnReward(send, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--请求排行 
		proxy.Boss:send_126003()
	end
end

function BossMainView:onBtnGuize(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		---规则
		mgr.ViewMgr:showView(_viewname.GUIZE):showByName(21) 
	end
end

function BossMainView:onBtnClose(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end
end

function BossMainView:onCloseSelfView()
	-- body
	--self:closeSelfView()
	mgr.SceneMgr:getMainScene():changePageView(5)
end

return BossMainView

