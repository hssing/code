local achieveItem = class("achieveItem",function(  )
	return ccui.Widget:create()
end)

function achieveItem:ctor( ... )
	-- body
end

function achieveItem:init( Parent  )
	-- body
	self.Parent=Parent
	self.view=Parent:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	--品质框 按钮
	self._button_frame = self.view:getChildByName("Button_frame")
	--self._Button_frame:addTouchEventListener(handler(self, self.onBtnFrameCallback))
	--成就icon 
	self._spr = self._button_frame:getChildByName("Image")
	--成就描述
	self.dec = self.view:getChildByName("Image_zb_bg"):getChildByName("Text_dec")

	--进度
	self._loadbar = self.view:getChildByName("LoadingBar_1") 
	self._txt_loadbar = self.view:getChildByName("Text_18")

	--奖励
	self.reward_di = self.view:getChildByName("Image_reward")
	self._txt_reward = self.reward_di:getChildByName("txt_count")
	self._img_moneyIcon = self.reward_di:getChildByName("Image_21")
	--领取 按钮
	self._btn_get =  self.view:getChildByName("Button_Using_26_5")
	--已完成的图片
	self._img_over = self.view:getChildByName("Image_over")

	self:initDec()

end

function achieveItem:initDec()
	-- body
	self.view:getChildByName("Image_reward"):getChildByName("Text_18_0"):setString(res.str.ACHI_DEC7) 
end

--设置图像
function achieveItem:setBImage(imgpath)
	self._spr:loadTexture(imgpath)
end
--设置成就icon
function achieveItem:setImgoframe( imgpath )
	-- body
	self._button_frame:loadTextureNormal(framePath)
end
--设置成就描述
function achieveItem:setDec( value )
	-- body
	self.dec:setString(value)
end
--进度
function achieveItem:setLoadbar(value,max)
	self._txt_loadbar:setString(value.."/"..max)
	self._loadbar:setPercent(value*100/max)
end
--奖励类型 数量
function achieveItem:setMoney(value,type )
	-- body
	self._txt_reward:setString(value)
	local path = res.image.GOLD;
	if type == 3 then 
		path =  res.image.BADGE;
	elseif 	type == 2 then 
		path =  res.image.ZS;
	end	
	self._img_moneyIcon:loadTexture(path)
end
--奖励按钮 或者已完成图片 0 前往 1 领取 2 完成  --type 是什么类型的成就  跳转界面
function achieveItem:setBtnStatue(status)
	-- body
	self._btn_get:setVisible(false)
	self._img_over:setVisible(false)
	--local params = conf.achieve:getToview(self.data.taskId) 
	if status == 0 then 
		self._btn_get:setVisible(false)
		self._btn_get:setTitleText(res.str.ACHIEVEME_GOTO)
		self._btn_get:setTitleColor(cc.c3b(33, 46, 111))
		self._btn_get:loadTextureNormal(res.btn.YELLOW)
		--self._button_frame:loadTextureNormal(res.btn.BLUE)
		--[[if params then 
			self._btn_get:addTouchEventListener(handler(self, self.onBtnGoToCallBack))
		end ]]--
	elseif status == 1 then 
		self._btn_get:setVisible(true)
		self._btn_get:setTitleText(res.str.MAILVIEW_GET)
		self._btn_get:setTitleColor(cc.c3b(127, 48, 10))
		self._btn_get:loadTextureNormal(res.btn.YELLOW)
		--self._button_frame:loadTextureNormal(res.btn.YELLOW)
		self._btn_get:addTouchEventListener(handler(self, self.onBtnGetCallBack))
	else
		--todo
		self._img_over:setVisible(true)
	end
end


function achieveItem:setData(data_)
	-- body
	self.data = data_
	local id = data_.taskId
	local itemSrc = conf.achieve:getSrc(id)
	local imgpath =  mgr.PathMgr.getItemImagePath(itemSrc)
	self:setBImage(imgpath)

	local lv = conf.achieve:getcolor(id)
	self:setImgoframe(lv)

	local dec = conf.achieve:getdec(id)
	self:setDec(dec)

	local max = conf.achieve:gettotal_count(id)
	local cur = data_.pass
	self:setLoadbar(cur,max)

	

	
	self.reward_di:setVisible(false)
	local reward = conf.achieve:getReward(id)
	if reward then 
		--printt(reward)
		self.reward_di:setVisible(true)
		if reward[1] == 221051002 then --钻石
			self:setMoney(reward[2],2)
		elseif reward[1] == 221051003 then 
			self:setMoney(reward[2],3)
		else
			self:setMoney(reward[2],1)
		end
	end

	self:setBtnStatue(data_.is_get)

	local is_sum = conf.achieve:getIsSum(id)
	if is_sum ~= 1 then  --不累计 只做 0/1 或者 1/1
		if data_.is_get == 0 then 
			self:setLoadbar(0,1)
		else
			self:setLoadbar(1,1)
		end
	end  
end

function achieveItem:onBtnGetCallBack( send,eventtype )
	-- body
	if ccui.TouchEventType.ended  == eventtype then
		debugprint("领取按钮按下")
		proxy.task:sendMessageGet(self.data.taskId)
	end
end

function achieveItem:onBtnGoToCallBack( send,eventtype )
	-- body
	if ccui.TouchEventType.ended  == eventtype then
		debugprint("界面跳转")
		local params = conf.achieve:getToview(self.data.taskId) 
		if  params then --如果支持跳转就
			G_GoToView(params)
			return 
		else
			debugprint("让刘波配表")
     	end 
	end
end


return achieveItem
