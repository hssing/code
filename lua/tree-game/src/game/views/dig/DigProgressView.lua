--[[
	DigProgressView 挖矿过程中
]]
local pet= require("game.things.PetUi")
local DigProgressView = class("DigProgressView",base.BaseView)

function DigProgressView:ctor()
	-- body
	self.data = {}
end

function DigProgressView:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	self.bg = self.view:getChildByName("Image_1")

	local panle_di = self.view:getChildByName("Panel_1")
	--救援
	self.btn_help = panle_di:getChildByName("Button_1")
	self.btn_help:ignoreContentAdaptWithSize(true)
	self.btn_help:addTouchEventListener(handler(self,self.onBtnZhenganCallBack))
	--动态
	self._scrollview = panle_di:getChildByName("ListView_1") 
	--下次收益时间
	self.lab_dec = panle_di:getChildByName("Text_1_1")
	self.lab_time = panle_di:getChildByName("Text_1_2")
	--
	self.img_title = panle_di:getChildByName("Image_21")
	self.img_title:ignoreContentAdaptWithSize(true)

	self.rewardframe = panle_di:getChildByName("btn_01_0")
	self.spr = self.rewardframe:getChildByName("Image_3_10")
	self.lab_name = panle_di:getChildByName("Text_1_0")
	--
	self.lab_cost_dec =  panle_di:getChildByName("Text_1_0_0_2")
	self.lab_cost_value = panle_di:getChildByName("Text_1_0_0_1_1")
	self.lab_card_value = panle_di:getChildByName("Text_1_0_0_1")
	self.lab_help_value = panle_di:getChildByName("Text_1_0_0_1_0")
	--
	self.lab_tanxian_dec =  panle_di:getChildByName("Text_1_0_0_2_0")
	self.lab_tanxian_time = panle_di:getChildByName("Text_1_0_0_2_0_0")
	--领取按钮
	self.btn_get = panle_di:getChildByName("Button_2")
	self.btn_get:addTouchEventListener(handler(self,self.onBtnGetCallBack))
	self.btn_title = self.btn_get:getChildByName("Text_1_17_31")
	--跑来来去
	self.runpanle = self.view:getChildByName("Panel_3")
	self.boopanle = self.runpanle:clone()
	self.boopanle:setPositionX(display.width - self.runpanle:getPositionX() - self.runpanle:getContentSize().width)
	self.boopanle:setPositionY(self.runpanle:getPositionY())
	self.boopanle:addTo( self.view)
	--助阵好有
	self.btnfriend =  panle_di:getChildByName("Button_4")
	self.btnfriend:addTouchEventListener(handler(self, self.onBtnFriendCallBack))

	self.btnspr = self.btnfriend:getChildByName("Image_4")

	self.lab_friendname = panle_di:getChildByName("Text_1")
	self.lab_friendname:setString(res.str.DEC_ERR_21)

	self.lab_qd = panle_di:getChildByName("Text_1_2_0")
	self.lab_img = panle_di:getChildByName("Image_3")
	
	self.lab_qd:setString("")

	--界面文本
	panle_di:getChildByName("Text_1_1"):setString(res.str.DIG_DEC52)
	panle_di:getChildByName("Text_1_0_0_2"):setString(res.str.DIG_DEC53)
	panle_di:getChildByName("Text_1_0_0"):setString(res.str.DIG_DEC54)
	panle_di:getChildByName("Text_1_0_0_0"):setString(res.str.DIG_DEC55)

	self.lab_tanxian_dec:setString(res.str.DIG_DEC56)
	self.btn_get:getChildByName("Text_1_17_31"):setString(res.str.DIG_DEC20)


end
--挖矿后说句话
function DigProgressView:speekWord(str)
	-- body
end
--动态信息
function DigProgressView:setWorld()
	local msg = {}
	--getContentstr
	for k ,v in pairs(self.data.genEvents) do 
		local t = string.split(v, "#")
		local str = conf.Dig:getContentstr(t[1])
		if tonumber(t[1]) == 40101 then 
			str = string.format(str,t[3])
		elseif tonumber(t[1]) == 40102 then 
			local name = conf.Card:getName(tonumber(t[3]))
			local arg = conf.Item:getArg1(tonumber(t[4]))
			local lab =  conf.Item:getName(arg.arg5)
			str = string.format(str,name,lab,tonumber(t[5]))
		elseif tonumber(t[1]) == 40103 then 
			local name = res.str["DIG_DEC_BOSS"..t[3]]
			str = string.format(str,name)
		elseif tonumber(t[1]) == 40104 then 
			local name = t[3]
			local lab = res.str["DIG_DEC_BOSS"..t[4]]
			local value = tonumber(t[5])
			str = string.format(str,name,lab,value)
			str = str.."%"
		elseif tonumber(t[1]) == 40105 then 
			local name = t[3]
			local lab = res.str["DIG_DEC_BOSS"..t[4]]
			local value = tonumber(t[5])
			str = string.format(str,name,lab,value)
			str = str.."%"
		elseif tonumber(t[1]) == 40106 then 
			local name = res.str["DIG_DEC_BOSS"..t[3]]
			local value = tonumber(t[4])
			str = string.format(str,name,value)
			str = str.."%"
		elseif tonumber(t[1]) == 40107 then 
			local name = res.str["DIG_DEC_BOSS"..t[3]]
			local value = tonumber(t[4])
			str = string.format(str,tostring(name),tonumber(value))
			str = str.."%"
		elseif tonumber(t[1]) == 40108 then 
			local name = t[3]
			str = string.format(str,name)
		elseif tonumber(t[1]) == 40109 then 
			local name = t[3]
			local value = tonumber(t[4]) --mid
			local ss = ""
			local arg = conf.Item:getArg1(value)

			if arg.arg5 == 221051001 then
				ss = res.str.MONEY_JB
			elseif 221051002 == arg.arg5 then 
				ss = res.str.MONEY_ZS
			else
				ss = res.str.MONEY_HZ
			end

			local count = t[5]
			str = string.format(str,name,ss,count)
		elseif tonumber(t[1]) == 40110 then 
			local name = t[3]
			local value = t[4]
			str = string.format(str,name,value)
		elseif tonumber(t[1]) == 40111 then 
			local name = t[3]
			str = string.format(str,name)
		end
		local var = {}
		var.timeStr = t[2]
		var.str = str
		table.insert(msg,var)
	end 

	for k , v in pairs(msg) do 
		local item = ccui.Layout:create()
		self._scrollview:pushBackCustomItem(item)

		local timeStr = display.newTTFLabel({
		    text = v.timeStr,
		    font = res.ttf[1],
		    size = 20,
		    color = cc.c3b(255,192,0),
		    align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
		})
		timeStr:setAnchorPoint(cc.p(0,1))
		timeStr:addTo(item)

		local label = display.newTTFLabel({
		    text = v.str,
		    font = res.ttf[1],
		    size = 20,
		    color = cc.c3b(45, 236, 253),
		    align = cc.TEXT_ALIGNMENT_LEFT,
		    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
		    dimensions = cc.size((self._scrollview:getContentSize().width-timeStr:getContentSize().width)*0.95, 0)
		})
		label:setAnchorPoint(cc.p(0,1))
		label:addTo(item)

		item:setContentSize(cc.size(self._scrollview:getContentSize().width,label:getContentSize().height))
		timeStr:setPosition(5,item:getContentSize().height)
		label:setPosition(timeStr:getPositionX()+timeStr:getContentSize().width+5,item:getContentSize().height)
	end 

	self._scrollview:refreshView()
	self._scrollview:jumpToBottom()
end 
--时间
function DigProgressView:changeTimes()
	-- body
	if self.data.nextAwardTime ~= 0 then 
		self.lab_time:setString(string.formatNumberToTimeString(self.data.nextAwardTime))
		self.data.nextAwardTime = self.data.nextAwardTime - 1 
		if self.data.nextAwardTime < 0 then 
			self.data.nextAwardTime = 0
		end 
		--self.btn_title:setString(res.str.DIG_DEC21)
	else
		self.lab_time:setString("")
		self.lab_dec:setString("")
		--self.btn_title:setString(res.str.DIG_DEC20)
	end 
		
	if self.data.totalLastTime ~= 0 then 
		self.lab_tanxian_time:setString(string.formatNumberToTimeString(self.data.totalLastTime))
		self.data.totalLastTime = self.data.totalLastTime - 1 

		if self.data.totalLastTime < 0 then 
			self.data.totalLastTime = 0
		end 
	else
		self.lab_tanxian_time:setString("")
		self.lab_tanxian_dec:setString("")
	end 
end
---跑来跑去的SB
function DigProgressView:palyForever()
	-- body
	self.runpanle:removeAllChildren()
	--local spr = display.newSprite("res/cards/"..self.data.styleId..".png")
	local id = conf.Card:getModel(self.data.styleId)
	
	local spr = display.newSprite("res/cards/"..id..".png")
	spr:setScale(0.65)
	spr:setPosition(self.runpanle:getContentSize().width/2,self.runpanle:getContentSize().height/2)
	spr:addTo(self.runpanle)

	if self.data.awardState < 3 then 
		
		
		--local sx = self.runpanle:getContentSize().width/spr:getContentSize().width
		--local sy = self.runpanle:getContentSize().height/spr:getContentSize().height

		--local maxscale = math.min(sx,sy)
		
		local Armature =  mgr.BoneLoad:loadArmature(404841,0)
		Armature:setPosition(self.runpanle:getContentSize().width/2+5,self.runpanle:getContentSize().height/2-60)
		Armature:setScale(1.5)
		Armature:addTo(self.runpanle)

		local a1 = cc.MoveBy:create(1.5, cc.p(200,30))
		local a2 = cc.MoveBy:create(1.5, cc.p(250,-30))
		local a3 = cc.MoveBy:create(1.5, cc.p(-200,30))
		local a4 = cc.MoveBy:create(1.5, cc.p(-250,-30))
		self.runpanle:runAction(cc.RepeatForever:create(cc.Sequence:create(a1,a2,a3,a4)))
	else
		self.runpanle:setPositionX(display.cx-self.runpanle:getContentSize().width/2)
	end
end
function DigProgressView:playBoos()
	-- body
	self.boopanle:removeAllChildren()

	local b = { ["11"] = 404844,["12"] = 404842,["13"] = 404845,["14"] =  404843}
	local Armature = mgr.BoneLoad:loadArmature(b[tostring(self.data.state)],1)
	Armature:setPosition(self.boopanle:getContentSize().width/2+5,self.boopanle:getContentSize().height/2)
	Armature:addTo(self.boopanle)

	local Armature =  mgr.BoneLoad:loadArmature(404841,0)
	Armature:setPosition(self.boopanle:getContentSize().width/2+5,self.boopanle:getContentSize().height/2-60)
	Armature:addTo(self.boopanle)


	local a1 = cc.MoveBy:create(1.5, cc.p(200,30))
	local a2 = cc.MoveBy:create(1.5, cc.p(250,-30))
	local a3 = cc.MoveBy:create(1.5, cc.p(-200,30))
	local a4 = cc.MoveBy:create(1.5, cc.p(-250,-30))
	self.boopanle:runAction(cc.RepeatForever:create(cc.Sequence:create(a3,a4,a1,a2)))
end


--救援后
function DigProgressView:updateinfo(win)
	-- body
	self.boopanle:removeAllChildren()
	self.huo:removeSelf()
	self.btn_help:setVisible(false)

	local sys = conf.Sys:getValue("dig_help_add")

	local basenumber =  self.lab_cost_value:getString() --基础值
	local add = self.data.awardJb
	if win == 1 then 
		print(" basenumber* tonumber(sys[2])/100 = ".. basenumber* tonumber(sys[2])/100)
		self.lab_help_value:setString(tostring(self.data.helpAdd/100+sys[2]).."%")
		add = add + basenumber* tonumber(sys[2])/100
	else
		print(" basenumber* tonumber(sys[4])/100 = ".. basenumber* tonumber(sys[4])/100)
		self.lab_help_value:setString(tostring(self.data.helpAdd/100+sys[4]).."%")
		add = add + basenumber* tonumber(sys[4])/100
	end
	--[[local add = self.data.awardJb
	if win == 1 then 
		self.lab_help_value:setString(tostring(self.data.helpAdd/100+sys[2]).."%")
		add = add*(1+sys[2]/100)
	else
		self.lab_help_value:setString(tostring(self.data.helpAdd/100+sys[4]).."%")
		add = add*(1+sys[4]/100)
	end]]--
	self.lab_name:setString(conf.Item:getName(self.reward_msg.arg5).."x"..checkint(add))
end

function DigProgressView:setData(isself,data_,paramroleId)
	-- body
	-- 
	self.data = data_
	self.roleId = paramroleId
	self.btn_help:setVisible(true)
	self.btn_get:setVisible(true)
	--该死着火
	if not isself then 

		self.btn_get:setVisible(false)
	end 
	if data_.state == 11 or  data_.state == 12 or data_.state == 13 or data_.state == 14 then --着火
		if not self.huo then 
			self.huo =  mgr.BoneLoad:loadArmature(404839,1)
			self.huo:setPosition(320,600)
			self.huo:addTo(self.bg)
		end 

		--捣乱的Boss
		self:playBoos()
	else
		if self.huo then 
			self.huo:removeSelf()
			self.huo = nil 
		end 
	end 

	--self.lab_friendname:setVisible(true)
	--self.btnfriend:setVis--ible(true)
	--self.lab_img:setVisible(true)

	if isself then 
		self.btn_help:setVisible(false)
		if data_.state == 11 or  data_.state == 12 or data_.state == 13 or data_.state == 14 then --着火
			self.btn_help:loadTextureNormal(res.btn.DIG_JIUYUAN_ASK) 
			self.btn_help:addTouchEventListener(handler(self,self.onBtnAskCallBack))
			self.btn_help:setVisible(true)
		end 
		
	else
		--self.lab_friendname:setVisible(false)
		--self.btnfriend:setVisible(false)
		--self.lab_img:setVisible(false)
		if data_.state == 11 or  data_.state == 12 or data_.state == 13 or data_.state == 14 then --着火
			self.btn_help:loadTextureNormal(res.btn.DIG_JIUYUAN)
			self.btn_help:addTouchEventListener(handler(self, self.onBtnZhenganCallBack))
			self.btn_help:setVisible(true)
		end 
		
	end

	self.btnspr:setVisible(false)
	if data_.cheerName and data_.cheerName ~= "" then  --是否有救援的人
		local role_icon = G_GetHeadIcon(data_.roleIcon)
		self.btnspr:loadTexture(role_icon)
		self.btnspr:ignoreContentAdaptWithSize(true)
		self.btnspr:setScale(0.8)
		self.btnspr:setVisible(true)

		local json = G_GetRoleFrameByPower(data_.score)
		self.btnfriend:loadTextureNormal(json)
		
		self.lab_friendname:setString(data_.cheerName)
		if self.jia then 
			self.jia:removeFromParent()
		end
	else
		self.btnspr:setVisible(false)
		if not self.jia then 
			self.jia =  mgr.BoneLoad:loadArmature(404808,0)
			self.jia:setPosition(self.btnspr:getPosition())
			self.jia:addTo(self.btnfriend)
		end

		if not isself then 
			self.lab_friendname:setVisible(false)
			self.btnfriend:setVisible(false)
			self.lab_img:setVisible(false)
		end
	end

	if data_.loseCount and data_.loseCount > 0 then 
		self.lab_qd:setString(string.format(res.str.DIG_DEC75,data_.loseCount))
	end

	if self.data.awardState == 0 then 
		self.btn_title:setString(res.str.DIG_DEC21)
		self.img_title:loadTexture(res.font.DIG_XIA_JIE)
	else
		self.btn_title:setString(res.str.DIG_DEC20)
		self.img_title:loadTexture(res.font.DIG_LEIJI)
	end

	local arg = conf.Item:getArg1(data_.mId)
	self.lab_cost_value:setString(arg.arg1) 
	self.lab_card_value:setString(tostring(data_.cardAdd/100).."%")
	self.lab_help_value:setString(tostring(data_.helpAdd/100).."%")

	local mId =arg.arg5
	local colorlv = conf.Item:getItemQuality(mId)
	local json = conf.Item:getItemSrcbymid(mId) 

	self.reward_msg = arg

	self.rewardframe:loadTextureNormal(res.btn.FRAME[colorlv])
	self.spr:loadTexture(json)
	print("loseCount = "..data_.loseCount)
	print("awardJb = "..data_.awardJb)

	self.lab_name:setString(conf.Item:getName(arg.arg5).."x"..(data_.awardJb) )
	--跑来跑去的数码兽
	self:palyForever()
	--发生的话
	self:setWorld()

	self:changeTimes()
	self:schedule(self.changeTimes,1.0)
end
--有好友助阵返回
function DigProgressView:updateName(data_)
	-- body
	self.data.cheerName = data_.roleName
	self.data.score = data_.score 

	if self.data.cheerName and self.data.cheerName ~= "" then  --是否有救援的人
		local role_icon = G_GetHeadIcon(data_.roleIcon)
		self.btnspr:loadTexture(role_icon)
		self.btnspr:ignoreContentAdaptWithSize(true)
		self.btnspr:setScale(0.8)
		self.btnspr:setVisible(true)

		local json = G_GetRoleFrameByPower(self.data.score)
		self.btnfriend:loadTextureNormal(json)
		
		self.lab_friendname:setString(self.data.cheerName)
		if self.jia then 
			self.jia:removeFromParent()
		end
	else
		self.btnspr:setVisible(false)
		if not self.jia then 
			self.jia =  mgr.BoneLoad:loadArmature(404808,0)
			self.jia:setPosition(self.btnspr:getPosition())
			self.jia:addTo(self.btnfriend)
		end

		if not isself then 
			self.lab_friendname:setVisible(false)
			self.btnfriend:setVisible(false)
			self.lab_img:setVisible(false)
		end
	end

end

--领取返回
function DigProgressView:getCallBack()
	-- body
	--self.reward_msg

	local t = {}
	local tt = {mId = self.reward_msg.arg5 , amount = self.data.awardJb,propertys = {}}
	table.insert(t,tt)

	--弹出获得界面
	local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
	if not view then
		view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		view:setData(t,false,true)
		view:setButtonVisible(false)
	end

end

function DigProgressView:onBtnGetCallBack(send, eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then 
		local data = { daoId = self.data.daoId}

		if self.data.awardState == 0 then 
			if  self.data.nextAwardTime == 0 then 
				proxy.Dig:sendGet(data)
				mgr.NetMgr:wait(520007)
			else
				proxy.Dig:sendJiasuMsg(data)
				mgr.NetMgr:wait(520008)
			end 
		else
			proxy.Dig:sendGet(data)
			mgr.NetMgr:wait(520007)
		end 
	end 
end

function DigProgressView:onBtnZhenganCallBack(send, eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then 
		local falg = cache.Dig:isRunKuang() --是否有运行 cache.Dig:getData() 
		if falg then 
			local data = {roleId = self.roleId ,daoId = self.data.daoId}
			proxy.Dig:sendHelp(data)
			mgr.NetMgr:wait(520004)
		else
			G_TipsOfstr(res.str.DIG_DEC4)
		end
	end 
end

function DigProgressView:onBtnFriendCallBack( send, eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then 
		if not self.data.cheerName or self.data.cheerName == "" then 
			local data = {flag = 0,enemy = true,daoId = self.data.daoId}
			proxy.Dig:sendfriend(data)
			mgr.NetMgr:wait(520005)
		end
	end
end

function DigProgressView:onBtnAskCallBack( send, eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then 
		local data = { daoId = self.data.daoId }
		proxy.Dig:send120011(data)	

		send:setVisible(false)
	end
end

return DigProgressView