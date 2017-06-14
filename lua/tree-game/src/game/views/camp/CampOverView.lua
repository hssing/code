
local CampOverView = class("CampOverView",base.BaseView)

function CampOverView:init()
	-- body
	self.showtype=view_show_type.TOP
    self.view=self:addSelfView()

    self.panle = self.view:getChildByName("Panel_1")

    local btn = self.panle:getChildByName("Button_1")
    btn:addTouchEventListener(handler(self,self.onbtnSeeWar))
    btn:setTitleText(res.str.DEC_ERR_81)

    local bg = self.view:getChildByName("Image_1")
    bg:addTouchEventListener(handler(self,self.onbtnClose))
    --胜利 失败
    self.img_win = self.panle:getChildByName("Image_12_0")
    --连胜次数
    self.win_count = self.panle:getChildByName("AtlasLabel_1")
    self.win_count:setString(0)
    --连胜描述
    self.dec_count = self.panle:getChildByName("Text_1_1_3")
    self.dec_count:setString("")
    --
    self.lab_jb = self.panle:getChildByName("Text_16_1")
    self.lab_hz = self.panle:getChildByName("Text_16_1_0")
    self.lab_jb:setString("")
    self.lab_hz:setString("")

    --
    self.img_1 =  self.panle:getChildByName("Image_12_0_0")
    self.img_2 =  self.panle:getChildByName("Image_12_0_0_0")
    self.img_3 =  self.panle:getChildByName("Image_12_0_0_1")

    self.lab_over = self.view:getChildByName("AtlasLabel_1")

    self:schedule(self.changeTimes,1.0,"changeTimes")

	self:initDec()
	G_FitScreen(self,"Image_1")
end

function CampOverView:changeTimes()
	-- body
	self.lab_count = self.lab_count - 1 
	if self.lab_count < 0 then
		self.lab_count = 0
		self.lab_over:setString(self.lab_count)
		self:onCloseSelfView()
		return 
	end
	self.lab_over:setString(self.lab_count)

end

function CampOverView:initDec()
	-- body
	self.player = {}
	
	local t = {} --正义
	local panle_2 = self.panle:getChildByName("Panel_2") 
	t.name =  panle_2:getChildByName("Text_1") 
	t.power = panle_2:getChildByName("Text_1_1_1")
	t.wincount = panle_2:getChildByName("Text_1_1_0_1")
	t.hpper = panle_2:getChildByName("Text_1_1_0_0_0")
	t.frame = panle_2:getChildByName("Image_6")
	t.spr = panle_2:getChildByName("Image_6"):getChildByName("Image_6_1")
	t.spr:setScale(0.8)
	t.spr:ignoreContentAdaptWithSize(true)
	table.insert(self.player,t)
	local t = {} --邪恶
	local panle_3 = self.panle:getChildByName("Panel_2_0") 
	t.name = panle_3:getChildByName("Text_1_0")
	t.power = panle_3:getChildByName("Text_1_1_1_0")
	t.wincount = panle_3:getChildByName("Text_1_1_0_1_0")
	t.hpper = panle_3:getChildByName("Text_1_1_0_0_0_0")
	t.frame = panle_3:getChildByName("Image_6_0")
	t.spr = panle_3:getChildByName("Image_6_0"):getChildByName("Image_6_0_11")
	t.spr:ignoreContentAdaptWithSize(true)
	t.spr:setScale(0.8)

	table.insert(self.player,t)

	panle_2:getChildByName("Text_1_1"):setString(res.str.DEC_ERR_50)
	panle_3:getChildByName("Text_1_1_2"):setString(res.str.DEC_ERR_50)

	panle_2:getChildByName("Text_1_1_0"):setString(res.str.DEC_ERR_51)
	panle_3:getChildByName("Text_1_1_0_2"):setString(res.str.DEC_ERR_51)

	panle_2:getChildByName("Text_1_1_0_0"):setString(res.str.DEC_ERR_52)
	panle_3:getChildByName("Text_1_1_0_0_1"):setString(res.str.DEC_ERR_52)

	self.img_4 =  self.panle:getChildByName("Text_16")
	self.img_4:setString(res.str.MONEY_JB..":")
	self.img_5 =  self.panle:getChildByName("Text_16_0")
	self.img_5:setString(res.str.MONEY_HZ..":")
end

function CampOverView:setvis()
	-- body
	self.img_1:setVisible(self.win)
	self.img_2:setVisible(self.win)
	self.img_3:setVisible(self.win)

	self.img_4:setVisible(self.win)
	self.img_5:setVisible(self.win)
	self.win_count:setVisible(self.win)


	self.lab_jb:setString("")
    self.lab_hz:setString("")
end

function CampOverView:setData(data)
	-- body
	self.lab_count = 5
	self.lab_over:setString(self.lab_count)
	self.data = data

	self.win = false
	if self.data.isWin > 0 then 
		--self.img_win:loadTexture(res.font.CAMP7)
		if cache.Camp:getSelfcamp() == 1 then
			self.win = true 
			self.img_win:loadTexture(res.font.CAMP7)
		else
			self.img_win:loadTexture(res.font.CAMP8)
		end
		
	else
		--self.img_win:loadTexture(res.font.CAMP8)
		if cache.Camp:getSelfcamp() == 1 then 
			self.img_win:loadTexture(res.font.CAMP8)
		else
			self.win = true 
			self.img_win:loadTexture(res.font.CAMP7)
		end
	end

	local pos = {} 
	local selfdata = {}
	local otherdata = {}
	for k ,v in pairs(data.vsUserInfo) do 
		local widget = self.player[v.camp] 

		local path = G_GetRoleFrameByPower(v.power)
		widget.frame:loadTexture(path)

		if v.camp == cache.Camp:getSelfcamp() then 
			widget.name:setString(v.roleName..res.str.DEC_ERR_79)
			pos.x = widget.frame:getPositionX()
			pos.y = widget.frame:getPositionY()
		else
			widget.name:setString(v.roleName)
		end 

		local role_icon = G_GetHeadIcon(v.roleIcon)
		widget.spr:loadTexture(role_icon)

		widget.power:setString(v.power)
		widget.wincount:setString(v.curConWinCount)

		widget.hpper:setString(v.hpRate.."%")

		if v.camp==cache.Camp:getSelfcamp() then 
			selfdata = v
			self.rid = v.rId

			if not self.win then
				widget.hpper:setString("0%")
			end

		else
			otherdata = v 
			cache.Fight.curFightName = v.roleName
			cache.Fight.curFightPower = v.power
			if self.win then
				widget.hpper:setString("0%")
			end
		end
	end
	self.dec_count:setVisible(false)
	self.win_count:setString(selfdata.curConWinCount)

	--self:setvis()

	if self.win  then 
		if otherdata.curConWinCount > 0 then 
			self.dec_count:setVisible(true)
			self.dec_count:setString(string.format(res.str.DEC_ERR_59,otherdata.curConWinCount))
		end

		if selfdata.curConWinCount > 0 then 
			local win = selfdata.curConWinCount
			if win > 90 then
				win = 90 
			end
			local reward = conf.Camp:getReward(win)
			
			local jb = reward.lq_awards[1]
			local zs = reward.lq_awards[2]

			if otherdata.curConWinCount > 0 then 
				win = otherdata.curConWinCount
				if win > 90 then
					win = 90 
				end
				local reward_0 = conf.Camp:getReward(win)
				jb = jb + reward_0.zq_awards[1]	
				zs = zs + reward_0.zq_awards[2]
			end

			self.lab_jb:setString(jb)
    		self.lab_hz:setString(zs)
    	end
    else
    	self.dec_count:setVisible(true)
    	self.dec_count:setString(res.str.DEC_ERR_82)
    	local reward = conf.Camp:getReward(1)
    	local jb = reward.lose_awards[1]
    	local zs =  reward.lose_awards[2]

	    self.lab_jb:setString(jb)
	    self.lab_hz:setString(zs)
	end


	if self._imgwin then 
		self._imgwin:removeSelf()
		self._imgwin = nil 
	end
	

	local panle_2 = self.panle:getChildByName("Panel_2") 
	local panle_3 = self.panle:getChildByName("Panel_2_0") 

	local time = 0.5

	transition.execute(panle_2, cc.MoveTo:create(time, cc.p(0, panle_2:getPositionY())), {
	    delay = 0,
	    easing = "backout",
	})

	transition.execute(panle_3, cc.MoveTo:create(time, cc.p(display.width, panle_3:getPositionY())), {
	    delay = 0,
	    easing = "backout",
	})

	self:performWithDelay(function()
		-- body
		if not self.armature then 
			self.armature =mgr.BoneLoad:createArmature(404850)
			self.armature:setPosition(display.cx, self.panle:getPositionY() )
			self.armature:addTo(self.view)
		end
		self.armature:getAnimation():playWithIndex(0)
	end, time)

	self:performWithDelay(function( ... )
		-- body

		local str = res.font.CAMP14
		local spr 
		local x = 0
		if self.win  then 
			if cache.Camp:getSelfcamp() == 1 then 
				spr = panle_2
				x = 150
			else
				spr = panle_3
				x = -120
			end 
		else
			str =  res.font.CAMP15
			--spr = panle_3
			if cache.Camp:getSelfcamp() == 2 then 
				spr = panle_3
				x = -120
			else
				spr = panle_2
				x = 150
			end 
		end
		self._imgwin = display.newSprite(str)
		self._imgwin:setScale(3.0)
		self._imgwin:setPositionX(pos.x+x)
		self._imgwin:setPositionY(pos.y+50)

		


		self._imgwin:addTo(spr)

		transition.execute(self._imgwin, cc.ScaleTo:create(0.5,1.0,1.0), {
	    delay = 0,
	    easing = "backout",
	    onComplete = function()
	        print("move completed")
	    end,
	})
		

		--self._imgwin:runAction(cc.ScaleTo:create(0.25,1.0,1.0))
	end, time + 1.0)
end

function CampOverView:onbtnClose( sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end
end

function CampOverView:onbtnSeeWar( sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("观战")
		--printt(self.data.fId)
		proxy.copy:onSFight(120106,{rId = self.rid})
	end
end

function CampOverView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CampOverView