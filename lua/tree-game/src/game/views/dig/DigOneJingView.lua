--[[
	DigOneJingView -- 选晶体
]]

local DigOneJingView = class("DigOneJingView",base.BaseView)


function DigOneJingView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local bg = self.view:getChildByName("Panel_1"):getChildByName("Image_1")
	self.bg= bg

	self.title = bg:getChildByName("Image_2_1")
	self.title:ignoreContentAdaptWithSize(true)

	local btn_close = bg:getChildByName("Button_1")
	btn_close:addTouchEventListener(handler(self, self.onBtnClose))
	
	self.lab_dec1 = bg:getChildByName("Text_1")
	self.lab_dec1:setVisible(false)
	--self.lab_dec2 = bg:getChildByName("Text_1_0")

	self.list = {}
	local t = {}
	t.lab_up = bg:getChildByName("Text_1_1")
	t.btnframe = bg:getChildByName("Button_frame_18_31")
	t.spr =t.btnframe:getChildByName("Image_22_23_51_4")
	t.lab_down =  bg:getChildByName("Text_1_1_0")
	table.insert(self.list,t)
	--2
	t = {}
	t.lab_up = bg:getChildByName("Text_1_1_1")
	t.btnframe = bg:getChildByName("Button_frame_18_31_0")
	t.spr =t.btnframe:getChildByName("Image_22_23_51_4_9")
	t.lab_down =  bg:getChildByName("Text_1_1_0_0")
	table.insert(self.list,t)
	--3
	t = {}
	t.lab_up = bg:getChildByName("Text_1_1_1_0")
	t.btnframe = bg:getChildByName("Button_frame_18_31_1")
	t.spr =t.btnframe:getChildByName("Image_22_23_51_4_12")
	t.lab_down =  bg:getChildByName("Text_1_1_0_1")
	table.insert(self.list,t)
	--4
	t = {}
	t.lab_up = bg:getChildByName("Text_1_1_1_0_0")
	t.btnframe = bg:getChildByName("Button_frame_18_31_0_0")
	t.spr =t.btnframe:getChildByName("Image_22_23_51_4_9_14")
	t.lab_down =  bg:getChildByName("Text_1_1_0_2")
	table.insert(self.list,t)
	--5
	t = {}
	t.lab_up = bg:getChildByName("Text_1_1_1_0_0_0")
	t.btnframe = bg:getChildByName("Button_frame_18_31_2")
	t.spr =t.btnframe:getChildByName("Image_22_23_51_4_16")
	t.lab_down =  bg:getChildByName("Text_1_1_0_3")
	table.insert(self.list,t)

	self.btn =self.list[5].btnframe


	--界面文本
	bg:getChildByName("Text_1_0"):setString(string.format(res.str.DIG_DEC45, 6))
	bg:getChildByName("Text_1_0_0"):setString(res.str.DIG_DEC46)
	bg:getChildByName("Text_1_1_2"):setString(res.str.DIG_DEC47)
	bg:getChildByName("Text_1_1_1_1"):setString(res.str.DIG_DEC48)
	bg:getChildByName("Text_1_1_1_0_1"):setString(res.str.DIG_DEC49)
	bg:getChildByName("Text_1_1_1_0_0_1"):setString(res.str.DIG_DEC50)
	bg:getChildByName("Text_1_1_1_0_0_0_0"):setString(res.str.DIG_DEC51)







end

function DigOneJingView:setOnlyFirger( ... )
	-- body
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

    local pos = self.btn:getWorldPosition()
	local params =  {id=404816, x=pos.x ,
	y=pos.y,addTo=self.layer, playIndex=0
	,loadComplete = function ( var  )
		-- body
		self.firget_armature = var
	end}
	mgr.effect:playEffect(params)

	local panle = self.btn:clone()
	--panle:removeAllChildren()
	panle:setOpacity(0)
	panle:setPosition(pos)
	panle:addTo(layer)
	panle:setTag(221015059)
	panle.mId = 221015059
	self.type = 2
	panle:addTouchEventListener(handler(self,self.onbtnJingtiCallBack))
end

function DigOneJingView:onbtncancel( ... )
	-- body
end

function DigOneJingView:updateinfo( data )
	-- body
	self.callfunc(data.mId,self.type)
	self:onCloseSelfView()
end

function DigOneJingView:onbtnZeroCallBack(sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local data = {}
		data.sure = function( ... )
			-- body
			debugprint("前往公会")


			proxy.guild:sendGuilmsg()
			mgr.NetMgr:wait(517009)
			
			G_mainView()

			self:onCloseSelfView()
		end
		data.cancel = function( ... )
			-- body
		end
		data.surestr = res.str.ACHIEVEME_GOTO
		data.richtext = {
			{title= true},
			{text=res.str.DIG_DEC32,fontSize=24,color=cc.c3b(255,255,255)},
			{text=" \n" ,fontSize=18,color=cc.c3b(255,255,255)},
			{text=" \n" ,fontSize=18,color=cc.c3b(255,255,255)},

			{text=res.str.DIG_DEC33,fontSize=24,color=cc.c3b(127,48,10)},	
		}
		local view = mgr.ViewMgr:showView(_viewname.TIPS)
		view:setData(data,nil,true)

	end 
end

function DigOneJingView:setData(data,yidao)
	-- body
	self.data = {
		{221015050,221015051,221015052,221015053,221015054},
		{221015055,221015056,221015057,221015058,221015059},
		{221015060,221015061,221015062,221015063,221015064},
	}
	self.callfunc = data.sure
	self.title:loadTexture(res.font.DIG_TYPE[data.type])

	if data.type == 1 then --金币
		self.lab_dec1:setString(string.format(res.str.DIG_DEC14,res.str.MONEY_JB))
	elseif data.type == 2 then --zs
		self.lab_dec1:setString(string.format(res.str.DIG_DEC14,res.str.MONEY_ZS))
	else
		self.lab_dec1:setString(string.format(res.str.DIG_DEC14,res.str.MONEY_HZ))
	end 
	--self.lab_dec2:setString(res.str.DIG_DEC15)

	self.type = data.type
	for k ,v in pairs(self.data[data.type]) do 
		local widget = self.list[k]
		local arg = conf.Item:getArg1(v)
		widget.lab_up:setString(string.format(res.str.DIG_DEC16,arg.arg1))
		local colorlv = conf.Item:getItemQuality(v)
		widget.btnframe:loadTextureNormal(res.btn.FRAME[colorlv])
		widget.spr:loadTexture(conf.Item:getItemSrcbymid(v))
		widget.lab_down:setString(res.str.DIG_DEC17)
		widget.btnframe:setTag(v)
		widget.mId = v 
		widget.btnframe:addTouchEventListener(handler(self, self.onbtnJingtiCallBack))
		if k ~= 1 then 
			local value = cache.Pack:getItemAmountByMid(pack_type.PRO,v)
			if value>0 then 
				widget.lab_down:setString(string.format(res.str.DIG_DEC18,value))
			else
				if data.type == 2 then 
					widget.lab_down:setString(string.format(res.str.DIG_DEC18,value))
					widget.btnframe:addTouchEventListener(handler(self, self.onbtnZeroCallBack))
				else
					local spr = display.newSprite(res.image.GOLD)
					local buy_type = conf.Item:getBuyType(v)
					self.buytype = buy_type
					if buy_type == 2 then 
						spr = display.newSprite(res.image.ZS)
					elseif buy_type == 3 then 
						spr = display.newSprite(res.image.BADGE)
					end 
					--spr:setPositionX(widget.lab_down:getcon)
					local price = conf.Item:getBuyPrice(v)
					widget.btnframe.price = price

					widget.lab_down:setString(price)
					spr:setScale(0.5)
					spr:setPositionX(widget.lab_down:getPositionX()-
						spr:getContentSize().width*0.5)
					spr:setPositionY(widget.lab_down:getPositionY())
					spr:addTo(self.bg)
				end
				
				--在这里计算价格 
			end 
		end 
	end 

	if yidao then 
		self:setOnlyFirger()
	end 
end

function DigOneJingView:onbtnJingtiCallBack( sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then

		self.callfunc(sender_:getTag(),self.type)
		self:onCloseSelfView()

		--[[if not sender_.price then 
			--self:updateinfo()
			self.callfunc(sender_:getTag(),self.type)
			self:onCloseSelfView()
		elseif G_BuyAnything(self.buytype, sender_.price, 1) then 
			local param = {mId = sender_:getTag(),amount = 1}
			proxy.pack:requestBuy(param)
			mgr.NetMgr:wait(504006)
		end ]]--
		--self.callfunc(sender_:getTag())
		--self:onCloseSelfView()
	end 
end

function DigOneJingView:onBtnClose(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end 
end

function DigOneJingView:onCloseSelfView()
	-- body
	if self.layer then 
		self.layer:removeFromParent()
		self.layer = nil 
	end 
	self:closeSelfView()
end

return DigOneJingView