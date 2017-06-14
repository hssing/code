--[[
	神魂猎命 -- 芯片 -- 符文 -- 命格 鬼知道是什么
]]
local CrossXinView = class("CrossXinView", base.BaseView)

function CrossXinView:ctor()
	-- body
	self.backlist = {} --临时背包
end

function CrossXinView:init()
	-- body
	self.ShowAll = true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	--随机的龙珠位置层
	self.bg_panle = self.view:getChildByName("Image_1"):getChildByName("Panel_9")
	--self.bg_panle:setVisible(false)
	--
	local panel_1 = self.view:getChildByName("Panel_1")
	--规则
	local btn_guize =  panel_1:getChildByName("Button_1")
	btn_guize:addTouchEventListener(handler(self, self.onbtnGuize))
	--关闭界面
	local btn =  panel_1:getChildByName("Button_1_0")
	btn:addTouchEventListener(handler(self, self.onbtnclose))
	--背包
	self.pack_pack = panel_1:getChildByName("Image_5"):getChildByName("Panel_2")
	self.clonitem = self.view:getChildByName("Panel_3")
	--领取奖励
	local btn_get = panel_1:getChildByName("Image_5"):getChildByName("Button_3")
	btn_get:addTouchEventListener(handler(self, self.onbtnGetReward))
	self.btn_get = btn_get
	--卖出
	local btn_sell = panel_1:getChildByName("Image_5"):getChildByName("Button_3_0")
	btn_sell:addTouchEventListener(handler(self, self.onbtnSellCallBack))
	self.btn_sell = btn_sell
	--
	local panle5 = self.view:getChildByName("Panel_5")
	local btn_equip =  panle5:getChildByName("Button_12")
	btn_equip:addTouchEventListener(handler(self, self.onBtnEquipCallback))
	--召唤能量
	local btn_zaohuan =  panle5:getChildByName("Button_12_0")
	btn_zaohuan:addTouchEventListener(handler(self, self.onBtnZaohuanCallback))

	local btn_start = panle5:getChildByName("Button_12_1")
	btn_start:addTouchEventListener(handler(self, self.onBtnStartCallback))

	self._img_5 = panle5:getChildByName("Image_15")
	local btn_check = self._img_5:getChildByName("CheckBox_1")
	btn_check:setSelected(false)
	btn_check:addEventListener(handler(self, self.checkBoxCallback))
	self._checkbox = btn_check

	---
	self.lab_zh = panle5:getChildByName("Text_1")

	self.img_sh = panle5:getChildByName("Image_12_0")
	self.lab_need = panle5:getChildByName("Text_1_0_0")--panle5:getChildByName("Text_1_0")
	self.lab_cur = panle5:getChildByName("Text_1_0")-- panle5:getChildByName("Text_1_0_0")
	self.lab_need:setString("")

	self.lab_longzhu = self.view:getChildByName("Image_1"):getChildByName("Image_4_0"):getChildByName("Text_3")
	self.lab_longzhu:setString("")

	local times= MyUserDefault.getIntegerForKey(user_default_keys.CROSS_SH)
	if times then --今日是否勾选了 不在提示
		if os.date("%x", os.time()) == os.date("%x",times) then 
			btn_check:setSelected(true)
			self.cancelSecond = false 
		else
			self.cancelSecond = true
		end
	end	

	self:initDec()
	self:initPacklist()
	self:setFivePos()
	self:forever()

	G_FitScreen(self, "Image_1")
end

--设置今天是否取消2次确认界面
function CrossXinView:savedaycancel( )
	-- body
	self.cancelSecond = false
	MyUserDefault.setIntegerForKey(user_default_keys.CROSS_SH,os.time())
end

function CrossXinView:forever( ... )
	-- body
	local armature = mgr.BoneLoad:loadArmature(404826,4)
    armature:setPosition(display.cx,display.cy)
    armature:addTo(self.view)
end

function CrossXinView:adjustpos()
	--self.lab_longzhu:setString(res.str.RES_RES_34[self.data.lzId])
	--[[self.lab_need:setPositionX(320-self.lab_need:getContentSize().width/2+10)
	self.img_sh:setPositionX(self.lab_need:getPositionX()-10)

	self.lab_cur:setPositionX(self.lab_need:getPositionX()+self.lab_need:getContentSize().width)]]--
	--self.lab_need:setPositionX(self.lab_cur:getPositionX()+self.lab_cur:getContentSize().width)

	self.img_sh:setPositionX(self.lab_cur:getPositionX()-10)
	self.lab_need:setPositionX(self.lab_cur:getPositionX()+self.lab_cur:getContentSize().width)
end

function CrossXinView:initDec()
	-- body
	self.btn_get:setTitleText(res.str.DEC_NEW_48)
	self.btn_sell:setTitleText(res.str.DEC_NEW_49)

	self._img_5:getChildByName("Text_4"):setString(res.str.DEC_NEW_50)
	self._img_5:getChildByName("Text_4_0"):setString(res.str.DEC_NEW_51)
	self._img_5:getChildByName("Text_4_0_0"):setString(10)

	local var = conf.Sys:getValue("shlm_lz_call")
	self.lab_zh:setString(var[2])


end
--初始  背包格子
function CrossXinView:initPacklist()
	-- body
	self.clonitem:setScale(0.8)
	local ccsize = self.clonitem:getContentSize()
	for i = 3 , 1,-1 do 
		local posy = (ccsize.height + 10)  * (i - 1) * self.clonitem:getScaleY() 
		for j = 1 , 7 do 
			if i == 1 and j >= 5 then
				break
			end
			local posx = (ccsize.width + 24 ) * (j - 1) * self.clonitem:getScaleX()

			local widget = self.clonitem:clone()
			local spr = widget:getChildByName("Image_7"):getChildByName("Image_8")
			spr:ignoreContentAdaptWithSize(true)
			spr:setScale(0.8)
			spr:setVisible(false)

			local lab_name = widget:getChildByName("Image_6"):getChildByName("Text_2") 
			lab_name:setString("")

			widget.lab_name = lab_name

			widget.spr = spr
			widget.spr:setTouchEnabled(true)
			widget.spr:addTouchEventListener(handler(self, self.onbtnSee))
			widget:setPosition(posx,posy)
			widget:addTo(self.pack_pack)

			table.insert(self.backlist,widget)
		end
	end 
end

function CrossXinView:setbacKItem( k,v  )
	-- body
	local widget = self.backlist[k]
	if not widget then
		return 
	end

	widget.data = v 
	if not v then
		widget.spr:setVisible(false)
		widget.lab_name:getParent():setVisible(false)
		return 
	end

	widget.spr:loadTexture(conf.Item:getItemSrcbymid(v.mId))
	widget.spr:setVisible(true)
	widget.spr.mId = v.mId

	widget.lab_name:getParent():setVisible(true)
	widget.lab_name:setString(conf.Item:getName(v.mId))
end

function CrossXinView:playbom( spr,mId ,islast)
	-- body

	local pom = mgr.BoneLoad:loadArmature(404804,0)
	pom:setScale(0.7) 
	pom:setPositionX(self.bg_panle:getContentSize().width/2)
	pom:setPositionY(self.bg_panle:getContentSize().height/2)
	pom:addTo(spr)

    pom:getAnimation():setMovementEventCallFunc(function(armature,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
     		pom:removeSelf()
        	spr.spr:loadTexture(conf.Item:getItemSrcbymid(mId))
        	spr.spr:setVisible(true)
        	spr.spr.mId = mId

        	spr.lab_name:getParent():setVisible(true)
			spr.lab_name:setString(conf.Item:getName(mId))
        	
        	if islast then
        		self:setLZ(self.data.lzId)
        	end
        end
    end)

end

function CrossXinView:addItem( data )
	-- body
	if data then
		local delaytime = 0.3 --间隔时间
		for k , v in pairs(data) do 
			self:performWithDelay(function()
				-- body
				for i ,j in pairs(self.backlist) do 
					if not j.data then
						j.data = v

						local islast = false
						if k == #data then
							islast = true
						end
						self:playbom(j,v.mId,islast) --爆炸特效
						break
					end
				end
			end, delaytime*(k-1))
		end
	end
end

function CrossXinView:removeItem( data )
	-- body
	if not data then
		return 
	end

	self.data = cache.Cross:getSh_Data() 

	local function callback(_data)
		for k ,v in pairs(self.backlist) do 
			if v.data and v.data.index == _data.index then
				v.spr:setVisible(false)
				v.data = nil 

				v.lab_name:getParent():setVisible(false)
				v.lab_name:setString("")
				break
			end
		end
	end

	for k ,v in pairs(data.changeList) do 
		callback(v)
	end
end

function CrossXinView:setFivePos()
	-- body
	self.pos = {}
	for i = 1 , 5 do 
		local widget = self.bg_panle:clone()
		widget:setVisible(true)
		
		local x ,y ,s 
		if i == 1 then
			s = 1.0
			x = 0 
			y = 0
		elseif i == 2 then
			s = 0.8
			x =  150
			y =  20
		elseif i == 3 then
			s = 0.6
			x =  75
			y =  80
		elseif i == 4 then
			s = 0.6
			x = -75
			y = 80
		elseif i == 5 then
			s = 0.8
			x = -150
			y = 20
		end

		local armature =mgr.BoneLoad:loadArmature(404855,i-1)
		armature:setPosition(widget:getContentSize().width/2
			,widget:getContentSize().height/2)
		armature:setScale(s)
		armature:addTo(widget)

		widget:setPosition(x,y)
		widget:addTo(self.bg_panle)
		widget.pos = i
		widget.spr = armature

		self["widget"..i] = widget

		self.pos[i] = {}
		self.pos[i].x = x
		self.pos[i].y = y
		self.pos[i].s = s  
	end
	local armature = mgr.BoneLoad:loadArmature(404854,0) 
	local bg = self.view:getChildByName("Image_1"):getChildByName("Image_4")
	armature:setPositionX(bg:getContentSize().width/2 )
	armature:setPositionY(0)
	armature:addTo(bg)
end

function CrossXinView:setShowLz(id)
	-- body
	if not self.layer then
		if not self.layer_lz then
			local layer = ccui.Layout:create()
		    layer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
		    layer:setBackGroundColor(cc.c3b(0, 0, 0))
		    layer:setBackGroundColorOpacity(0)
		    layer:setContentSize(cc.size(display.width,display.height))
		    layer:setTouchEnabled(true)
		    layer:setTouchSwallowEnabled(true)
		    --addto:addChild(layer,100) 
		    self.view:addChild(layer)

		    self.layer_lz = layer
		end
	end

	local function callback(time,dir)
		-- body
		for i = 1 , 5 do 
			local widget = self["widget"..i]
			local pos = widget.pos + dir
			if  pos > 5 then
				pos = 1
				--curid = i
			elseif pos < 1 then
				pos = 5
			end
			local a1 = cc.MoveTo:create(time, cc.p(self.pos[pos].x,self.pos[pos].y))
			local a2 = cc.CallFunc:create(function( ... )
				-- body
				widget.pos = pos
				widget.spr:setScale(self.pos[pos].s) 
			end)

			widget:runAction(cc.Sequence:create(a1,a2))
		end
	end

	local pos = self["widget"..id].pos --即将移动到位置1

	local c_1 = 1
	for i = 1 , 5 do
		if self["widget"..i].pos == 1 then
			c_1 = i 
		end
	end
	local dir = 1
	local _q =   5-pos+1 --旋转几次
	if id >= c_1 then
		dir = -1
		_q=pos-1
	end 

	
	
	if _q == 5 then
		_q = 0
	end

	local delay = 0.15
	for i = 1 ,_q do 

		self:performWithDelay(function( ... )
			-- body
			callback(delay/2,dir)
		end, delay*(i-1))
	end

	self:performWithDelay(function( ... )
		-- body
		if self.layer and not tolua.isnull(self.layer) then
			self.layer:removeSelf()
			self.layer = nil 
		end

		if self.layer_lz and not tolua.isnull(self.layer_lz) then
			self.layer_lz:removeSelf()
			self.layer_lz = nil 
		end
		self.lab_longzhu:setString(res.str.RES_RES_34[self.data.lzId])
		self.lab_need:setString("/"..self.cost)
		--self.lab_cur:setPositionX(self.lab_need:getPositionX()+self.lab_need:getContentSize().width)
		--self.lab_need:setPositionX(self.lab_cur:getPositionX()+self.lab_cur:getContentSize().width)
		self:adjustpos()

	end, delay*(_q+1))
end

function CrossXinView:setData(data)
	-- body
	self.data = data
	if not data then
		return 
	end

	for k , v in pairs(self.data.items) do 
		self:setbacKItem(k,v)
	end  

	self:setSh(self.data.resNum)
	self:setLZ(self.data.lzId,true)
end
--设置当前圣魂值
function CrossXinView:setSh( value )
	-- body
	self.data.resNum = value
	self.lab_cur:setString(value)
	--self.lab_cur:setPositionX(self.lab_need:getPositionX()+self.lab_need:getContentSize().width)
	--self.lab_need:setPositionX(self.lab_cur:getPositionX()+self.lab_cur:getContentSize().width)
	self:adjustpos()
end

function CrossXinView:setLzCallBack( data_ )
	-- body
	self:addItem(data_.gots)
	self:setLZ(data_.lzId)
end

function CrossXinView:setLZ(id,falg)
	-- body
	self.data.lzId = id
	local confdata = conf.Cross:getSh_Item(id)
	self.cost = confdata.cost
	if not falg then
		self:setShowLz(id)
	else
		--直接定位置
		local d = id - 1
		for i = 1 ,  5 do 

			local pos =    i - d 
			if pos <= 0 then
				pos = 	5 + pos
			end
			--print(i,pos)
			local widget = self["widget"..i]
			widget:setPositionX(self.pos[pos].x)
			widget:setPositionY(self.pos[pos].y)
			widget.spr:setScale(self.pos[pos].s)
		end
		print("self.cost",self.cost)
		self.lab_longzhu:setString(res.str.RES_RES_34[self.data.lzId])
		self.lab_need:setString("/"..self.cost)
		--self.lab_cur:setPositionX(self.lab_need:getPositionX()+self.lab_need:getContentSize().width)
		--self.lab_need:setPositionX(self.lab_cur:getPositionX()+self.lab_cur:getContentSize().width)
		self:adjustpos()
	end
end

--抽奖返回 ，动画未做
function CrossXinView:serverChouCall( data_ )
	-- body
	local layer = ccui.Layout:create()
    layer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    layer:setBackGroundColor(cc.c3b(0, 0, 0))
    layer:setBackGroundColorOpacity(0)
    layer:setContentSize(cc.size(display.width,display.height))
    layer:setTouchEnabled(true)
    layer:setTouchSwallowEnabled(true)
    --addto:addChild(layer,100) 
    self.view:addChild(layer)

    self.layer = layer

	if not self.armature_dian then
		self.armature_dian = mgr.BoneLoad:createArmature(404854) 
		self.armature_dian:setPositionX(self.bg_panle:getContentSize().width/2)
		self.armature_dian:setPositionY(self.bg_panle:getContentSize().height/2)
		self.armature_dian:addTo(self.bg_panle)	
	end

	if not self.pom then
		self.pom = mgr.BoneLoad:createArmature(404804) 
		self.pom:setPositionX(self.bg_panle:getContentSize().width/2)
		self.pom:setPositionY(self.bg_panle:getContentSize().height/2)
		self.pom:addTo(self.bg_panle)
		self.pom:setVisible(false)	
	end
	
	self.armature_dian:getAnimation():setFrameEventCallFunc(function(bone,event,originFrameIndex,intcurrentFrameIndex)
	    if event == "a1" then 
	    	self.pom:setVisible(true)
			self.pom:getAnimation():playWithIndex(0) --爆炸特效
	    end
	end)

	self.armature_dian:getAnimation():setMovementEventCallFunc(function(armature,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            self.img = display.newSprite(conf.Item:getItemSrcbymid(data_.gots[1].mId))
            local pos  = self.bg_panle:getWorldPosition()
			pos.x = pos.x + self.bg_panle:getContentSize().width/2
			pos.y = pos.y + self.bg_panle:getContentSize().height/2
            self.img:setPosition(pos)
            self.img:addTo(self.view,1000)

            local key = 0
            for i ,j in pairs(self.backlist) do 
				if not j.data then
					key = i
					break
				end
			end

			if key > 0 then --移动效果
				local img = self.backlist[key]
				local pos  = img:getWorldPosition()
				pos.x = pos.x + img:getContentSize().width/2
				pos.y = pos.y + img:getContentSize().height/2

				local a1 = cc.MoveTo:create(0.4, pos)
				local a2 = cc.CallFunc:create(function()
					-- body
					self.img:removeSelf()
					self:addItem(data_.gots)
				end)
				self.img:runAction(cc.Sequence:create(a1,a2))
			end
        end
    end)
	self.armature_dian:getAnimation():playWithIndex(1) 
	self:setSh(data_.resNum)
end

--复选框
function CrossXinView:checkBoxCallback(sender,eventtype)
	if cache.Player:getVip()< 3 then
		--G_TipsOfstr(res.str.ADV_TANXIAN)
		local data  = {}
		data.richtext = res.str.DEC_NEW_61
		data.sure = function( ... )
			-- body
			G_GoReCharge()
		end
		data.surestr = res.str.SURE
		data.cancel = function( ... )
			-- body
		end
		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
		self._checkbox:setSelected(false)
		return 
	end
	if eventtype == ccui.CheckBoxEventType.selected then
	else
	end
end

--招呼芯片
function CrossXinView:onBtnStartCallback( sender,eventtype  )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		if self.data.resNum < self.cost then
			G_TipsOfstr(res.str.DEC_NEW_52)
		else
			local data = {opType = 0}
			if self._checkbox:isSelected() then
				data.opType = 1
			end
			proxy.Cross:send_122002(data)
			mgr.NetMgr:wait(522002)
		end
	end 
end

--召唤能量
function CrossXinView:onBtnZaohuanCallback( sender,eventtype  )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		if self.data.lzId > 4 then
			G_TipsOfstr(res.str.DEC_NEW_53)
		elseif  self.data.lzId == 4 then
			G_TipsOfstr(res.str.DEC_NEW_54)
		else
			if self.cancelSecond then  
				local data ={}
				local function sure(var)
					-- body
					mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
					if var then
						self.cancelSecond = false
						self:savedaycancel()
					end

					if G_BuyAnything(2, tonumber(self.lab_zh:getString())) then
						proxy.Cross:send_122003()
						mgr.NetMgr:wait(522003)
					end
				end
				local function cancel()
					-- body
				end
				data.cross = self.lab_zh:getString()
				data.sure = sure
				data.cancel = cancel
				local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
				view:setData(data)


				--[[local data = {}
				data.richtext = {
					{text=res.str.DEC_NEW_55,fontSize=24,color=cc.c3b(255,255,255)},
					{img=res.image.ZS},
					{text=self.lab_zh:getString(),fontSize=24,color==cc.c3b(255,255,255)},
					{text=","..res.str.DEC_NEW_56,fontSize=24,color=cc.c3b(255,255,255)},
				}

				data.checktext = res.str.RES_RES_76
				data.sure = function(var)
					-- body
					if var then
						self.cancelSecond = false
						self:savedaycancel()
					end

					if G_BuyAnything(2, tonumber(self.lab_zh:getString())) then
						proxy.Cross:send_122003()
						mgr.NetMgr:wait(522003)
					end
				end

				data.cancel = function()
					-- body
				end

				data.surestr = res.str.DEC_NEW_60
				mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,nil,true)]]--
			else
				if G_BuyAnything(2, tonumber(self.lab_zh:getString())) then
					proxy.Cross:send_122003()
					mgr.NetMgr:wait(522003)
				end
			end
		end 
	end 
end

function CrossXinView:onbtnSee(sender,eventtype)
	if eventtype == ccui.TouchEventType.ended then 
		G_openItem(sender.mId)
	end
end

--装备安南
function CrossXinView:onBtnEquipCallback( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		--G_setMaintopinit()
		--mgr.SceneMgr:getMainScene():changePageView(2)
		--打开兑换
		local view = mgr.ViewMgr:showView(_viewname.CROSS_XIN_DUIHUAN)
		view:setData()
	end 
end
--卖出
function CrossXinView:onbtnSellCallBack( sender,eventtype  )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local data  = {}
		data.richtext = res.str.DEC_NEW_57
		data.sure = function( ... )
			-- body
			proxy.Cross:send_122004()
			mgr.NetMgr:wait(522004)
		end
		data.surestr = res.str.DEC_NEW_59
		data.cancel = function( ... )
			-- body
		end
		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
	end
end
--领取奖励
function CrossXinView:onbtnGetReward( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		if self.data and #self.data.items > 0 then
			proxy.Cross:send_122005()
			mgr.NetMgr:wait(522005)
		else
			G_TipsOfstr(res.str.DEC_NEW_58)
		end
	end 
end

function CrossXinView:onbtnGuize(sender,eventtype)
	if eventtype == ccui.TouchEventType.ended then 
		local view = mgr.ViewMgr:showView(_viewname.GUIZE)
		view:showByName(16)
	end 
end

function CrossXinView:onbtnclose( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end

function CrossXinView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CrossXinView

