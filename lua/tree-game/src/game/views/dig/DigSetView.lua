--[[
	DigSetView  设置界面
]]
local pet= require("game.things.PetUi")
local DigSetView = class("DigSetView",base.BaseView)

function DigSetView:ctor()
	-- body
	self.data = {}
	self.btntable = {}
	self.cardsadd = 5

	self.yidao = false
end

function DigSetView:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	local panle_di = self.view:getChildByName("Panel_1")
	local btn_start = panle_di:getChildByName("Button_2")
	btn_start:addTouchEventListener(handler(self,self.onBtnTanxianCallBack))
	self.btn_start = btn_start

	--数码兽选着
	self.img_card = panle_di:getChildByName("Image_4")
	self.img_card:setOpacity(0)
	self.img_card:addTouchEventListener(handler(self, self.onimgCardCallBack))
	self.lab_dec = panle_di:getChildByName("Text_2")

	--3个晶体选择
	self.btntable = {}
	local btn1 = panle_di:getChildByName("btn_01")
	--btn1.spr = btn1:getChildByName("Image_3")
	table.insert(self.btntable,btn1)

	local btn2 = panle_di:getChildByName("btn_02")
	--btn2.spr = btn2:getChildByName("Image_3_5")
	table.insert(self.btntable,btn2)

	self.btn2 = btn2

	local btn3 = panle_di:getChildByName("btn_03")
	--btn3.spr = btn3:getChildByName("Image_3_5_7")
	table.insert(self.btntable,btn3)

	self.btn_tool = panle_di:getChildByName("btn_03_0")

	--奖励
	self.btnreward = panle_di:getChildByName("btn_01_0")
	self.rewardspr = self.btnreward:getChildByName("Image_3_10")
	self.lab_reward = panle_di:getChildByName("Text_1_0") 

	self.costdec = panle_di:getChildByName("Text_1_0_0_1") 
	self.carddec = panle_di:getChildByName("Text_1_0_0_1_0") 
	self.panxinxin =  panle_di:getChildByName("Panel_17")


	self.btn_reset =  panle_di:getChildByName("Button_9") 
	self.btn_reset:addTouchEventListener(handler(self, self.onbtnReset))

	self:initData()

	self.first = MyUserDefault.getStringForKey(user_default_keys.DIG_FRIST)
	if self.first ~= "false"  then 
		self.yidao = true
		self.first = "false"
		MyUserDefault.setStringForKey(user_default_keys.DIG_FRIST,self.first)

		self:performWithDelay(function()
				self:setOnlyFirger() --手指动画
		end, 0.1)
	end 

	--界面文本
	panle_di:getChildByName("Text_2"):setString (res.str.DIG_DEC57)
	panle_di:getChildByName("Text_1"):setString(res.str.DIG_DEC58)
	panle_di:getChildByName("Text_1_0_0"):setString(res.str.DIG_DEC53)
	panle_di:getChildByName("Text_1_0_0_0"):setString(res.str.DIG_DEC54)
	btn_start:getChildByName("Text_1_17_31"):setString(res.str.DIG_DEC59)

end

function DigSetView:setOnlyFirger()
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

    self.layer1 = layer

    local pos = self.img_card:getWorldPosition()
	local params =  {id=404816, x=pos.x ,
	y=pos.y ,addTo=self.layer1, playIndex=0
	,loadComplete = function ( var  )
		-- body
		self.firget_armature = var
	end}
	mgr.effect:playEffect(params)

	local data = {state = 0}
	local panle = self.img_card:clone()
	--panle:removeAllChildren()
	panle:setOpacity(0)
	panle:setPosition(pos)
	panle:addTo(layer)
	panle:addTouchEventListener(handler(self,self.onimgCardCallBack))
end

function DigSetView:setOnlyFirger1()
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

    self.layer2 = layer

    local pos = self.btn2:getWorldPosition()
	local params =  {id=404816, x=pos.x ,
	y=pos.y ,addTo=layer, playIndex=0
	,loadComplete = function ( var  )
		-- body
		self.firget_armature = var
	end}
	mgr.effect:playEffect(params)

	local panle = self.btn2:clone()
	panle:setTag(2)
	panle.mId = 221051002
	panle:setTouchEnabled(true)
	panle:addTouchEventListener(handler(self, self.onbtnMoneyCallBack))
	panle:setOpacity(0)
	panle:setPosition(pos)
	panle:addTo(layer)
end

function DigSetView:setOnlyFirger2( ... )
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

    self.layer3 = layer

    local pos = self.btn_start:getWorldPosition()
	local params =  {id=404816, x=pos.x ,
	y=pos.y ,addTo=layer, playIndex=0
	,loadComplete = function ( var  )
		-- body
		self.firget_armature = var
	end}
	mgr.effect:playEffect(params)

	local panle = self.btn_start:clone()
	panle:setTouchEnabled(true)
	panle:addTouchEventListener(handler(self, self.onBtnTanxianCallBack))
	panle:setOpacity(0)
	panle:setPosition(pos)
	panle:addTo(layer)
end

function DigSetView:onbtnReset(sender_,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local t = { 221051001,221051002,221051003 }
		for i = 1 , 3 do 
			local widget = self.btntable[i]
			local mId = t[i]
			widget:setVisible(true)

			local colorlv = conf.Item:getItemQuality(mId)
			--local json = conf.Item:getItemSrcbymid(mId) 
			

			widget:loadTextureNormal(res.icon.DIG_ZIYUAN[i])
			--widget:loadTextureNormal(res.btn.FRAME[colorlv])
			--widget.spr:loadTexture(json)
			widget:setTag(i)
			widget.mId = mId
			widget:setTouchEnabled(true)
			widget:addTouchEventListener(handler(self, self.onbtnMoneyCallBack))
		end 

		self.mId = nil 
		self.jishu = nil 
		self.lab_reward:setString("")
		self.btnreward:setVisible(false)
		self.rewardspr:setVisible(false)
		self.lab_reward:setVisible(false)
		self.costdec:setVisible(false)
		--self.carddec:setVisible(false)
		self.btn_reset:setVisible(false)

		self.btn_tool:setVisible(false)
	end 
end

function DigSetView:initData()
	-- body
	local t = { 221051001,221051002,221051003 }
	for i = 1 , 3 do 
		local widget = self.btntable[i]
		widget:setVisible(true)
		local mId = t[i]

		local colorlv = conf.Item:getItemQuality(mId)
		local json = conf.Item:getItemSrcbymid(mId) 

		widget:loadTextureNormal(res.icon.DIG_ZIYUAN[i])
		--widget:loadTextureNormal(res.btn.FRAME[colorlv])
		--widget.spr:loadTexture(json)
		widget:setTag(i)
		widget.mId = mId
		widget:addTouchEventListener(handler(self, self.onbtnMoneyCallBack))
	end 
	self.btnreward:setVisible(false)
	self.rewardspr:setVisible(false)
	self.lab_reward:setVisible(false)
	self.costdec:setVisible(false)
	self.carddec:setVisible(false)
	self.btn_reset:setVisible(false)
	self.panxinxin:setVisible(true)
	self.btn_tool:setVisible(false)


	self["jia"] =  mgr.BoneLoad:loadArmature(404808,0)
	local pos = self.img_card:getWorldPosition()
	self["jia"]:setPosition(pos)
	self["jia"]:addTo(self.view)
end

function DigSetView:setData(data )
	-- body
	self.data = data
	self.sys_xishu = conf.Sys:getValue("dig_card_add")
	self.cardsadd  = self.sys_xishu[2] --最低
	self.carddec:setString(math.floor(self.cardsadd).."%")
end

--设置金币奖励
function DigSetView:setReward()
	-- body
	if not self.jishu then 
		return 
	end 
	local value = self.jishu * ( 1 + self.cardsadd/100  )
	self.reward_jb = value
	if self.awardid then 
		self.lab_reward:setString(conf.Item:getName(self.awardid).."x"..checkint(self.reward_jb))
	end 
end

--确定回调
function DigSetView:sureCallBack(value,type)
	-- body
	local arg = conf.Item:getArg1(value)
	self.mId = value

	local colorlv = conf.Item:getItemQuality(self.mId)
	local json = conf.Item:getItemSrcbymid(self.mId) 

	self.btn_tool:setVisible(true)
	self.btn_tool:loadTextureNormal(res.btn.FRAME[colorlv])
	local spr = self.btn_tool:getChildByName("Image_3_5_7_7")
	spr:loadTexture(json)

	--何种奖励
	local mId =  arg.arg5
	self.awardid = mId
	local colorlv = conf.Item:getItemQuality(mId)
	local json = conf.Item:getItemSrcbymid(mId) 

	self.btnreward:loadTextureNormal(res.btn.FRAME[colorlv])
	self.rewardspr:loadTexture(json)

	for k ,v in pairs(self.btntable) do 
		v:setVisible(false)
	end 

	--[[for k ,v in pairs(self.btntable) do 
		if k > 1 then
			v:setVisible(false)
		else
			--什么晶体
			local widget = self.btn_tool--self.btntable[1]
			local colorlv = conf.Item:getItemQuality(self.mId)
			local json = conf.Item:getItemSrcbymid(self.mId) 

			widget:loadTextureNormal(res.btn.FRAME[colorlv])

			widget:setTouchEnabled(false)
			--widget.spr:loadTexture(json)
			
		end
	end ]]--

	self.jishu = arg.arg1
	self.costdec:setString(self.jishu)

	self.btnreward:setVisible(true)
	self.rewardspr:setVisible(true)
	self.lab_reward:setVisible(true)
	self.costdec:setVisible(true)
	--self.carddec:setVisible(true)


	self:setReward(arg.arg5)

	self.btn_reset:setVisible(true)

	if self.yidao  then 
		self:setOnlyFirger2()
	end
end

function DigSetView:onbtnMoneyCallBack( sender_, eventtype )
	-- body
	if eventtype ==  ccui.TouchEventType.ended then
		if self.layer2 then 
			self.layer2:removeFromParent()
			self.layer2 = nil 
		end 
		self.btntag = sender_:getTag()
		debugprint("self.btntag "..self.btntag)

		local data = {}
		data.sure = handler(self, self.sureCallBack)
		data.type = sender_:getTag()
		local view = mgr.ViewMgr:showView(_viewname.DIG_CHOOSE)
		view:setData(data,self.yidao)
	end 
end

function DigSetView:updateinfo()
	-- body
	local data = {
		daoId = self.data.daoId,
		mId = self.mId ,
		cardIndex = self.carddata.index
	}
	proxy.Dig:sendChallenge(data)
	mgr.NetMgr:wait(520003)
end

function DigSetView:onBtnTanxianCallBack( sender_,eventtype )
	-- body
	if eventtype ==  ccui.TouchEventType.ended then
		debugprint("开始探险")
		if self.layer3 then 
			self.layer3:removeSelf()
			self.layer3 = nil
		end 
		if not self.mId  then 
			debugprint("没有道具")
			G_TipsOfstr(res.str.DIG_DEC13)
			return 
		elseif not self.carddata then
			debugprint("没有数码兽") 
			G_TipsOfstr(res.str.DIG_DEC12)
			return 
		end  	

		
		if self.btntag == 2 then --钻石类型直接发
			self:updateinfo()
			--[[local param = {mId = self.mId,amount = 1}
			proxy.pack:requestBuy(param)
			mgr.NetMgr:wait(504006)]]--
			return 
		end

		local buy_type = conf.Item:getBuyType(self.mId)
		local value = cache.Pack:getItemAmountByMid(pack_type.PRO,self.mId)
		local price = conf.Item:getBuyPrice(self.mId)
		if not price or price == 0 then 
			debugprint("没有价格")   
			self:updateinfo()
			return 
		end
		if not value or value <= 0 then
			debugprint("购买d") 
			
			--local price = conf.Item:getBuyPrice(self.mId)
			local dataRich = {}
			dataRich.sure = function()
				-- body
				local view = mgr.ViewMgr:get(_viewname.TIPS)
				if view then 
					view:closeSelfView()
				end 

				if G_BuyAnything(buy_type,price, 1) then 
					local param = {mId = self.mId,amount = 1}
					proxy.pack:requestBuy(param)
					mgr.NetMgr:wait(504006)
				end 
			end
			dataRich.cancel = function()
				-- body
			end
			local str = ""
			local buy_price = 0
			if buy_type == 1  then
				str = res.image.GOLD
				buy_price =price
			elseif buy_type == 2 then 
				str = res.image.ZS
				buy_price =price
				--str = res.str.MONEY_ZS..price
			else
				str = res.image.BADGE
				buy_price =price
				--str = res.str.MONEY_HZ..price
			end 

			dataRich.surestr = res.str.SURE
			dataRich.close = true
			--dataRich.richtext = string.format(res.str.DIG_DEC25,str,conf.Item:getName(self.mId))

			dataRich.richtext = {
				--{title=true},
				{text=res.str.GUILD_DEC24,fontSize=24,color=cc.c3b(255,255,255)},
				{img=str},
				{text=tostring(buy_price),fontSize=24,color=cc.c3b(255,255,255)},
				{text=string.gsub(res.str.BUY," ","").."\n"..conf.Item:getName(self.mId),fontSize=24,color=cc.c3b(255,255,255)},
				
			}

			local view = mgr.ViewMgr:showView(_viewname.TIPS)
			if view then
				view:setData(dataRich,nil,true)
			else
				debugprint("我就是的叫声的集散")
			end
			

			return 
		end 
		debugprint("直接发送")   
		self:updateinfo()
		--printt(data)
		--
	end 
end


--添加星星
function DigSetView:addStar( num )
	local starpath=res.image.STAR
	local size=num 
	local iconheight=self.panxinxin:getContentSize().height
	local iconwidth=self.panxinxin:getContentSize().width

	--local 
	local sprite=display.newSprite(starpath)
	local w = (sprite:getContentSize().width-5)*size
	local strposX = (iconwidth -w)/2 + sprite:getContentSize().width/2

	for i=1,size do
		local sprite=display.newSprite(starpath)
		sprite:setScale(0.8)
		sprite:setPosition(strposX+(sprite:getContentSize().width- 5)*(i-1),iconheight/2)
		self.panxinxin:addChild(sprite)
	end
end

--选中的数码兽信息
function DigSetView:CardCallBack(data_)
	-- body
	if not data_ then return end  
	if self["jia"] then 
		self["jia"]:removeSelf()
		self["jia"] = nil 
	end

	self.carddata = data_

	if self.pet then 
		self.pet:removeFromParent()
		self.pet = nil 
	end 

	local pet = pet.new(data_.mId,data_.propertys)
	pet:setAnchorPoint(0.5,0.5)
	local Quality=conf.Item:getItemQuality(data_.mId)

	self.pet = pet

	local jie =  data_.propertys[307] and data_.propertys[307].value or 0
	pet:setScale(res.card.digScale[tostring(Quality)][jie+1])

	local pos  = self.img_card:getWorldPosition()
	pos.x = pos.x + 0 
	pos.y = pos.y +0
	pet:setPosition(pos)
	pet:addTo(self.view) 

	self.lab_dec:setVisible(false)
	local value = data_.propertys[305].value*100/(data_.propertys[305].value+self.sys_xishu[1])+self.sys_xishu[2]
	if value > self.sys_xishu[3] then 
		value = self.sys_xishu[3]
	end 

	for k ,v in pairs(self.panxinxin:getChildren()) do 
		if v:getName()~="Image_5" then 
			v:removeFromParent()
		end  
	end 
	--self.panxinxin:setPositionX(pos.x-self.panxinxin:getContentSize().width/2)
	---self.panxinxin:setPositionY(pos.y - 150 - pet:getContentSize().height*pet:getScale()/2 )
	--self:addStar(Quality)


	value = string.format("%.2f",value)

	self.carddec:setString(value.."%")
	self.carddec:setVisible(true)
	self.panxinxin:setVisible(false)

	self.cardsadd = value
	self:setReward()

	if self.yidao  then 
		self:setOnlyFirger1()
	end
end

function DigSetView:onimgCardCallBack( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--debugprint("数码兽选中")
		if self.layer1 then 
			self.layer1:removeFromParent()
			self.layer1 = nil 
		end 

		local view = mgr.ViewMgr:showView(_viewname.DIG_SET_CARD)
		view:setData()

		self:performWithDelay(function(  )
			-- body
			view:setOnlyFirger(self.yidao)
		end , 0.1)
	end 
end

function DigSetView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return DigSetView