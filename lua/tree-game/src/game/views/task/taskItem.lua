

local taskItem = class("taskItem",function(  )
	return ccui.Widget:create()
end)


function taskItem:ctor( ... )
	-- body
	self.RewardList = {}
end	

function taskItem:init( Parent  )
	-- body
	self.Parent=Parent
	self.view=Parent:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	--品质框 按钮
	self._Button_frame = self.view:getChildByName("Button_frame")
	--self._Button_frame:addTouchEventListener(handler(self, self.onBtnFrameCallback))
	--任务icon 
	self._spr = self._Button_frame:getChildByName("Image")
	--任务描述
	self.dec = self.view:getChildByName("Image_zb_bg"):getChildByName("Text_dec")
	--任务进度
	self._txt_loadbar = self.view:getChildByName("Text_jingdu")
	self._max_text = self.view:getChildByName("Text_reward_1_2_0")
	--领取 按钮
	self._btn_get =  self.view:getChildByName("Button_Using_26_5")
	
	
	--已完成的图片
	self._img_over = self.view:getChildByName("Image_over")

	self.lab_dayhy = self.view:getChildByName("Text_reward_3_0")
	self.lab_dayhy:setString("")

	local size = 3 
	for i = 1 , size do   
		local img = self.view:getChildByName("img_icon_"..i)
		local text = self.view:getChildByName("Text_reward_"..i)
		img:ignoreContentAdaptWithSize(true)
		self.RewardList[i] = {}
		self.RewardList[i].img = img
		self.RewardList[i].text = text
	end

	self:initDec()
end

function taskItem:initDec()
	-- body
	self.view:getChildByName("Text_dec_0"):setString(res.str.TASK_DEC_03)
	self.view:getChildByName("Text_reward_1_2"):setString(res.str.TASK_DEC_04)
end

--设置图像
function taskItem:setBImage(imgpath)
	self._spr:loadTexture(imgpath)
end
--设置成就icon
function taskItem:setImgoframe( lv )
	-- body
	local framePath=res.btn.FRAME[lv]
	self._Button_frame:loadTextureNormal(framePath)
end
--设置成就描述
function taskItem:setDec( value )
	-- body
	self.dec:setString(value)
end
--进度
function taskItem:setLoadbar(value,max)
	self._txt_loadbar:setString(value)
	self._max_text:setString("/"..max)
end
--设置奖励
function taskItem:setListrewad(id,lv)
	-- body
	for i = 1 ,#self.RewardList do 
		self.RewardList[i].img:setVisible(false)
		self.RewardList[i].text:setVisible(false)
	end
	--根据ID 获取奖励table 
	local reward = {}
	local localreward = conf.task:getReward(id,lv)
	for k ,v in pairs (localreward) do 
		table.insert(reward,v )
	end 
	
	local exp = conf.task:getRewardExp(id,lv)
	if exp then 
		local t = {}
		t[1] = "exp"
		t[2] = exp
		table.insert(reward,t)
	end 

	local path 
	if reward then 
		for i = 1 , #reward do
			if i > 3 then 
				debugprint("只能是3个")
				return 
			end  
			local v = reward[i]

			local scale = 0.8
			self.RewardList[i].img:setScale(scale)
			if tonumber(v[1]) == 221051003 then 
				path =  res.image.BADGE; --徽章
			elseif tonumber(v[1]) == 221051002 then 
				--todo
				path = res.image.ZS; --钻石
			elseif tonumber(v[1]) == 221051001 then 
				path = res.image.GOLD;
			elseif tostring(v[1]) == "exp" then 
				path = res.image.EXP;
				scale = 0.5
				self.RewardList[i].img:setScale(scale)
			end
			self.RewardList[i].img:setVisible(true)
			self.RewardList[i].text:setVisible(true)
			self.RewardList[i].img:loadTexture(path)
			self.RewardList[i].text:setString(v[2])


			--[[if i > 1 then 
				self.RewardList[i].img:setPositionX(self.RewardList[i-1].text:getPositionX()+
						self.RewardList[i-1].text:getContentSize().width+5)
			end 
			self.RewardList[i].text:setPositionX(self.RewardList[i].img:getPositionX()+
					self.RewardList[i].img:getContentSize().width*scale)]]--
		end
	end 



end

--奖励按钮 或者已完成图片 0 前往 1 领取 2 完成  --type 是什么类型的成就  跳转界面
function taskItem:setBtnStatue(status)
	-- body
	self._btn_get:setVisible(false)
	self._img_over:setVisible(false)

	if status == 0 then 
		self._btn_get:setVisible(true)
		self._btn_get:setTitleText(res.str.ACHIEVEME_GOTO)
		self._btn_get:setTitleColor(cc.c3b(33, 46, 111))
		self._btn_get:loadTextureNormal(res.btn.BLUE_BIG)
		self._btn_get:addTouchEventListener(handler(self, self.onBtnGoToCallBack))
	elseif status == 1 then 
		self._btn_get:setVisible(true)
		self._btn_get:setTitleText(res.str.MAILVIEW_GET)
		self._btn_get:setTitleColor(cc.c3b(127, 48, 10))
		self._btn_get:loadTextureNormal(res.btn.YELLOW)
		self._btn_get:addTouchEventListener(handler(self, self.onBtnGetCallBack))
	else
		--todo
		self._img_over:setVisible(true)
	end
end

function taskItem:setData( data )
	-- body
	--任务
	self.data = data
	local id = data.taskId

	local day_hy = conf.task:getDayHy(id)
	self.lab_dayhy:setString(string.format(res.str.RES_GG_75,tonumber(day_hy)))

	local itemSrc = conf.task:getSrc(id)
	local imgpath =  mgr.PathMgr.getItemImagePath(itemSrc)

	self:setBImage(imgpath)

	local lv = conf.task:getcolor(id)
	self:setImgoframe(lv)
	
	local dec = conf.task:getdec(id)
	self:setDec(dec)
	self:setListrewad(id,data.tmpInt)

	local max = conf.task:gettotal_count(id)
	local cur = data.pass
	self:setLoadbar(cur,max)

	self:setBtnStatue(data.is_get)
end

function taskItem:onBtnGetCallBack( send,eventtype )
	-- body
	if ccui.TouchEventType.ended  == eventtype then
		debugprint("领取按钮按下")
		proxy.task:sendMessageGet(self.data.taskId)
	end
end

function taskItem:onBtnGoToCallBack( send,eventtype )
	-- body
	if ccui.TouchEventType.ended  == eventtype then
		debugprint("界面跳转")
		local params = conf.task:getToview(self.data.taskId) 
		if  params then --如果支持跳转就
			G_GoToView(params)
			return 
		else
			debugprint("让刘波配表")
     	end 

	end
end

return taskItem