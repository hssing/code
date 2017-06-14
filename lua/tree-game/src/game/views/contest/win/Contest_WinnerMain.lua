--[[
	Contest_WinnerMain 驯兽尸王 主界面
]]

local Contest_WinnerMain = class("Contest_WinnerMain", base.BaseView)

function Contest_WinnerMain:init()
	-- body
	self.ShowAll = true
	--self.ShowBottom = true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	

	local panle_top = self.view:getChildByName("Panel_1")
	local btn_paihang = panle_top:getChildByName("Button_3")
	btn_paihang:addTouchEventListener(handler(self, self.onbtnRankCallBack))

	local btn_set =  panle_top:getChildByName("Button_2")
	btn_set:addTouchEventListener(handler(self, self.onbtnSetCallBack))
	self.btn_set = btn_set

	local btn_shop = panle_top:getChildByName("Button_2_0")
	btn_shop:addTouchEventListener(handler(self, self.onimgRewardCallBack))
	--点赞人数
	self.lab_renshu = self.view:getChildByName("Image_10_0_0"):getChildByName("Text_66")
	--点赞类型
	local panle_down = self.view:getChildByName("Panel_6")
	self.lab_today_type = panle_down:getChildByName("Text_13_0")
	--点赞按钮
	self.btn_dianzhan = panle_down:getChildByName("Button_9")
	self.btn_dianzhan:addTouchEventListener(handler(self, self.onbtndianzhanCallBack))
	self.img_dianzhen =  panle_down:getChildByName("Image_13_0")
	--点赞奖励
	self.img_money_type = panle_down:getChildByName("Image_13") 
	self.lab_reward = panle_down:getChildByName("Text_13_0_0")
	--
	self.img_reward_call = self.view:getChildByName("Panel_14")
	self.img_reward_call:setTouchEnabled(false)
	--self.img_reward_call:addTouchEventListener(handler(self, self.onimgRewardCallBack))
	--男女形象
	self._img_role = self.view:getChildByName("Image_1"):getChildByName("Image_9")

	
	local panel =self.view:getChildByName("Panel_2") 
	panel:setTouchEnabled(true) 
	panel:addTouchEventListener(handler(self,self.onimgCallBack))
	self.lab_name = self.view:getChildByName("Image_1"):getChildByName("Panel_10"):getChildByName("Text_14")
	self._imb_di =self.view:getChildByName("Image_1"):getChildByName("Panel_10"):getChildByName("Image_9_0_0_0")  

	self:clear()
    --self:resetPostion()


    --界面文本
    panle_down:getChildByName("Text_13"):setString(res.str.CONTEST_TEXT17) 
    panle_down:getChildByName("Text_13_0"):setString(res.str.CONTEST_TEXT18) 
    panle_down:getChildByName("Text_13_1"):setString(res.str.CONTEST_TEXT19) 


	G_FitScreen(self, "Image_1")

	self:setRedPoint()
	proxy.Contest:sendSetMsg()

	self:performWithDelay(function( ... )
		-- body
		self:forever()
	end, 0.01)

	
end

function Contest_WinnerMain:setRedPoint()
	-- body
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
			debugprint("来到了这里")
			spr:addTo(ppa.panle)			
		end 
	end


	--[[if cache.Player:getWangNumber() > 0 then 
		local params = {}
		params.num = -1 
		params.x = 40
		params.y = 20
		params.panle = self.btn_dianzhan
		setRedPointPanle(params)
	end ]]--

	if cache.Player:getWangSetNumber()>0 then 
		local params = {}
		params.num = -1 
		params.x = 40
		params.y = 10
		params.panle = self.btn_set
		setRedPointPanle(params)
	end 
end

function Contest_WinnerMain:forever()
	-- body
	local params =  {id=404837, x=self.view:getContentSize().width/2,
	y=self.view:getContentSize().height/2,addTo=self.view, playIndex=0}
	mgr.effect:playEffect(params)

	local params =  {id=404837, x=self.img_reward_call:getContentSize().width/2,
	y=self.img_reward_call:getContentSize().height/2,addTo=self.img_reward_call, playIndex=1,depth = 2}
	mgr.effect:playEffect(params)
end

function Contest_WinnerMain:clear()
	-- body
	self.lab_renshu:setString("")
	self.lab_today_type:setString("")
	self.lab_reward:setString("")
	self.lab_name:setString("")
end
--设置点赞
function Contest_WinnerMain:initbtn( statue )
	-- body
	if statue == 1 then 
		self.btn_dianzhan:setTouchEnabled(false)
		self.img_dianzhen:loadTexture(res.font.DIANZHAN[2])
	else
		self.btn_dianzhan:setTouchEnabled(true)
		self.img_dianzhen:loadTexture(res.font.DIANZHAN[1])
	end 	
end

function Contest_WinnerMain:setData()
	-- body
	self._imb_di:setVisible(false)
	if self:checkWang(true) then 
		return 
	end 

	self.data = cache.Contest:getWinnerMsg()
	if not self.data then 
		return 
	end 
	local temp = G_Split_Back(self.data.roleIcon)

	self._imb_di:setVisible(true)
	--printt(self.data)
	--设置形象
	self._img_role:ignoreContentAdaptWithSize(true)
	self._img_role:loadTexture(res.icon.CONTEST_WIN_ROLE[temp.sex])
	if temp.sex == 2 then --女人移动位置 X 方向
		self._img_role:setPositionX(self._img_role:getPositionX() - 15 )
	end 

	self.lab_name:setString(self.data.roleName)
	--设置点赞人数
	self.lab_renshu:setString(string.format(res.str.CONTEST_DEC37,self.data.zanCount))
	--设置个人点赞信息
	local statue = self.data.zanType 
	if statue == 0 then 
		statue = 1 
	end 
	local conf = conf.Contest:getItemByIndex(statue)
	self.lab_today_type:setString(res.str["CONTEST_DEC_"..statue])
	self.lab_reward:setString(conf.zan_jb)

	--是否点赞
	self:initbtn(self.data.isZan)

end

--点赞成功后改变
function Contest_WinnerMain:updateinfo(data_)
	-- body
	--G_TipsOfstr(string.format(res.str.CONTEST_DEC35,100))
	--金币
	mgr.Sound:playViewZhaoCai()
	
	local params =  {id=404818, x=self.img_reward_call:getContentSize().width/2,y=self.img_reward_call:getContentSize().height/2
	,addTo=self.img_reward_call,playIndex=0,depth = 1 }
	mgr.effect:playEffect(params)
	--暴击
	--[[local params =  {id=404828, x=self.img_reward_call:getContentSize().width/2,y=self.img_reward_call:getContentSize().height/2
	,addTo=self.img_reward_call,playIndex=1,depth = 3 }
	mgr.effect:playEffect(params)]]--
	--强化
	local params =  {id=404804, x=self.img_reward_call:getContentSize().width/2,
	y=self.img_reward_call:getContentSize().height/2 + 20 
	,addTo=self.img_reward_call, playIndex=0,depth = 4 }
	mgr.effect:playEffect(params)
	--
	local params =  {id=404837, x=self.view:getContentSize().width/2,
	y=self.view:getContentSize().height/2,addTo=self.view, playIndex=2,depth = 2,
	endCallFunc= function( ... )
		-- body
		G_TipsOfstr(string.format(res.str.CONTEST_DEC35,tonumber(self.lab_reward:getString())))
	end}
	mgr.effect:playEffect(params)

	self:initbtn(data_.isZan)
	self.lab_renshu:setString(string.format(res.str.CONTEST_DEC37,data_.zanCount))

end

function Contest_WinnerMain:checkWang(paramsflag)
	-- body
	local falg = cache.Contest:getIswinnernull()
	print(" falg "..tostring(falg))
	if falg then 
		if not paramsflag then 
			G_TipsOfstr(res.str.CONTEST_DEC42)
		end 
	end 
	return falg
	
end

function Contest_WinnerMain:onimgRewardCallBack(  sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("奖励显示")
		local view = mgr.ViewMgr:showView(_viewname.CONTEST_SHOP)
	end 
end

function Contest_WinnerMain:onbtndianzhanCallBack( sender_,eventtype  )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		if self:checkWang() then 
			return 
		end 
		debugprint("点赞返回")
		proxy.Contest:sendDianzhan()
		mgr.NetMgr:wait(519104)
		----代码测试
		--self:updateinfo()
	end 
end

function Contest_WinnerMain:onbtnRankCallBack( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("排行被点击")
		if self:checkWang() then 
			return 
		end 
		proxy.Contest:sendrank()
		mgr.NetMgr:wait(519007) 
		--local view = mgr.ViewMgr:showView(_viewname.CONTEST_WIN_RANK)
		--view:setData()
	end 
end

function Contest_WinnerMain:onbtnSetCallBack(  sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("设置点击")
		--[[if self:checkWang() then 
			return 
		end ]]--
		local view = mgr.ViewMgr:showView(_viewname.CONTEST_WIN_SET)
		view:setData()
	end 
end

function Contest_WinnerMain:comPareCalllBack( data_ )
	-- body
	cache.Friend:setOnlyClose(true)
	local view = mgr.ViewMgr:createView(_viewname.ATHLETICS_COMPARE)
	local data = {}



	--右边
	local data1 = {}
	data1.tarName = data_.tarBName
	data1.tarLvl = data_.tarBLvl
	data1.tarPower = data_.tarBPower
	data1.tarCards = data_.tarBCards
	data1.huoban = data_.tarBXhbs
	if data1.tarName == cache.Player:getName() then 
		data1.roleId = cache.Player:getRoleId()
	else
		data1.roleId = self.data.roleId
	end 


	--左边
	local data = {}
	data.tarName = data_.tarAName
	data.tarLvl = data_.tarALvl
	data.tarPower = data_.tarAPower
	data.tarCards = data_.tarACards
	data.huoban = data_.tarAXhbs
	if data.tarName == cache.Player:getName() then 
		data.roleId = cache.Player:getRoleId()
	else
		data.roleId = self.data.roleId
	end 

	if data.tarName == cache.Player:getName() then
		view:setData(data1,data)
	else
		view:setData(data,data1)
	end 

	mgr.ViewMgr:showView(_viewname.ATHLETICS_COMPARE)
end

function Contest_WinnerMain:onimgCallBack( sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		if self:checkWang() then 
			return 
		end  
		debugprint("阵容对比")
		if cache.Player:getRoleId().key == self.data.roleId.key then 
			G_TipsOfstr(res.str.CONTEST_DEC27)
			return 
		end 

		local param = {tarAId =  cache.Player:getRoleId(), tarBId =  self.data.roleId }
		--printt(param)
		proxy.Contest:sendCompare(param)
		mgr.NetMgr:wait(501201)
	end 
end

function Contest_WinnerMain:onCloseSelfView()
	-- body
	--self:closeSelfView()
	G_mainView()
end

return Contest_WinnerMain

