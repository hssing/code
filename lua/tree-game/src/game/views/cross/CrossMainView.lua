
local CrossMainView = class("CrossMainView",base.BaseView)

function CrossMainView:init()
	self.ShowAll= true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	local panle = self.view:getChildByName("Panel_4")
	local btnClose = panle:getChildByName("Button_8")
	btnClose:addTouchEventListener(handler(self, self.onbtnclose))
	--第几次排位赛
	self.title = panle:getChildByName("AtlasLabel_1")
	--规则
	local btnguize = panle:getChildByName("Button_8_0")
	btnguize:addTouchEventListener(handler(self,self.onbtnGuize))
	--王者之战
	local btnWang = panle:getChildByName("Button_8_0_0")
	btnWang:addTouchEventListener(handler(self,self.onbtnWangWar))
	--zhanji
	local btn = panle:getChildByName("Button_8_10")
	btn:addTouchEventListener(handler(self,self.onbtnZhanji))
	--mobai
	local btn_mobai = panle:getChildByName("Button_8_11")
	btn_mobai:addTouchEventListener(handler(self,self.onbtnMobai))

	--我的战机
	local btnMyself = panle:getChildByName("Button_8_1")
	btnMyself:addTouchEventListener(handler(self,self.onbtnMyselfWar))
	local panel_bottom = self.view:getChildByName("Panel_1")
	self.panel_bottom = panel_bottom

	self.panel_left = panel_bottom:getChildByName("Panel_left")
	self.lspr = self.panel_left:getChildByName("Image_4") 
	self.ls_lab = self.panel_left:getChildByName("Text_1") 
	self.ls_lab_name = self.panel_left:getChildByName("Text_1_0")
	self.ls_lab_power = panel_bottom:getChildByName("Text_52")
	self.ls_lab_win = panel_bottom:getChildByName("Text_52_0")

	self.panel_right = panel_bottom:getChildByName("Panel_left_0")
	self.rspr = self.panel_right:getChildByName("Image_4_11") 
	self.rs_lab = self.panel_right:getChildByName("Text_1_4") 
	self.rs_lab_name = self.panel_right:getChildByName("Text_1_0_6") 
	self.rs_lab_power = panel_bottom:getChildByName("Text_52_1")
	self.rs_lab_win = panel_bottom:getChildByName("Text_52_1_0")
	self.rs_img_win = panel_bottom:getChildByName("Image_64_5")

	self.run_panle = self.panel_right:getChildByName("Panel_2") 
	--匹配按钮
	local btnpipei = panel_bottom:getChildByName("Button_1")
	btnpipei:addTouchEventListener(handler(self, self.onbtnStart))
	self.btnpipei = btnpipei
	self.image = btnpipei:getChildByName("Image_14_0")
	--开始配置文字
	self.img_lab_1 = panel_bottom:getChildByName("Image_72_2")
	self.lab_1 = self.img_lab_1:getChildByName("Text_52_3")

	self.img_lab_2 = panel_bottom:getChildByName("Image_72_3")
	self.lab_2 = self.img_lab_2:getChildByName("Text_52_4")

	self.img_win_di = panel_bottom:getChildByName("Image_72_0_0")
	--
	local img = panel_bottom:getChildByName("Image_2") 
	self.img = img
	self.lab_power = img:getChildByName("Text_41_1") 
	self.lab_count = img:getChildByName("Text_41_1_0") 
	self.lab_reward = img:getChildByName("Text_41_11") 
	self.lab_pos = img:getChildByName("Text_41_12")
	--召唤芯片
	local btn = panel_bottom:getChildByName("Button_16")
	btn:addTouchEventListener(handler(self,self.onBtnCall))

	self:initDec()
	self:initSpr() --滚动图片

	G_FitScreen(self,"Image_1")

	self:schedule(self.changeTimes,1.0)
	--test
	--self:setWintest({"√","x ","- ","- ","- "})
	--self.flag = true
	--self:setTipsView(res.str.RES_RES_38)
end

function CrossMainView:initDec()
	-- body
	self.ls_lab:setString("")
	self.ls_lab_name:setString("")
	self.rs_lab:setString("")
	self.rs_lab_name:setString("")
	self.lab_1:setString("")
	self.lab_2:setString("")
	self.ls_lab_power:setString("")
	self.ls_lab_win:setString("")
	self.rs_lab_power:setString("")
	self.rs_lab_win:setString("")
	self.lab_power:setString("")
	self.lab_pos:setString("")
	self.lab_reward:setString("")
	self.lab_count:setString("")
	self.img_lab_1:setVisible(false)
	self.img_lab_2:setVisible(false)

	self.lab_dec = self.panel_bottom:getChildByName("Image_72_0"):getChildByName("Text_52_1_1")
	self.lab_dec:setString(res.str.RES_RES_05)
	local  str = string.gsub(res.str.RES_RES_05," ","")
	
	self.lab_sai =self.img:getChildByName("Text_41")
	self.lab_sai:setString(str)
	self.img:getChildByName("Text_41_01"):setString(res.str.RES_RES_06)
	self.img:getChildByName("Text_41_0"):setString(res.str.RES_RES_07)
	self.img:getChildByName("Text_41_0_0"):setString(res.str.RES_RES_08)
	self.img:getChildByName("Text_419"):setString(res.str.RES_RES_09)
	self.img:getChildByName("Text_41_10"):setString(res.str.RES_RES_10)
end
--设置赢了几次
function CrossMainView:setWintest(value)
	-- body
	self.img_win_di:removeAllChildren()

	local ccsize = self.img_win_di:getContentSize()
	for k ,v in pairs(value) do 
		local lab = ccui.Text:create()
		lab:setString(v)
		lab:setFontSize(18)
		lab:setFontName(res.ttf[1])
		lab:setPositionX(ccsize.width/2)
		lab:setPositionY(ccsize.height/2)

		if string.find(v,"√") then
			lab:setColor(COLOR[2])
		elseif string.find(v,"x") then
			lab:setColor(COLOR[6])
		end
	
		local px = lab:getContentSize().width
		if k == 1 then
			lab:setPositionX(ccsize.width/2-px*2)
		elseif k == 2 then
			lab:setPositionX(ccsize.width/2-px)
		elseif k == 3 then
		elseif k == 4 then
			lab:setPositionX(ccsize.width/2+px)
		elseif k== 5 then
			lab:setPositionX(ccsize.width/2+px*2)
		end

		lab:addTo(self.img_win_di)
	end
end
--倒计时计算恢复次数
function CrossMainView:changeTimes()
	-- body
	if not self.data then
		return
	end
	--if self.data.nextFightCountTime <= 0 then
		--self.data.figthCount = self.data.figthCount + 1 
		--cache.Cross:setFigthCount(self.data.figthCount)
	--end
	local minute=math.floor((self.data.nextFightCountTime%3600)/60);
    local second=(self.data.nextFightCountTime%3600)%60;
   	local str_time = string.format("%02d:%02d",minute,second)
   	local str =  self.data.figthCount.."/"..self.maxCount
   	if self.data.nextFightCountTime ~= 0 and self.data.figthCount~= self.maxCount then
   		str = str.." ("..str_time..")"
   	end
	self.lab_count:setString(str)	
end

function CrossMainView:setTipsView(str)
	-- body
	if not self.flag then
		return 
	end

	local data  = {}
    data.richtext = str
    data.sure = function( ... )
        -- body
    end
    data.surestr = res.str.SURE
    mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
end

function CrossMainView:showIsup()
	-- body
	if not self.conf_data then
		return 
	end

	local isup = cache.Cross:getisDwUp()
	if isup == 1 then
		local data = {}
		data.richtext = string.format(res.str.RES_RES_40,self.conf_data.name)
		data.sure = function( ... )
			-- body
			cache.Cross:setisDwUp()
		end
		data.dw = self.data.roleDw
		mgr.ViewMgr:showTipsView(_viewname.CROSS_WIN_TIPS):setData(data)
	elseif isup == -1 then
		local data  = {}
	    data.richtext = string.format(res.str.RES_RES_39,self.conf_data.name) 
	    data.sure = function( ... )
	        -- body
	       cache.Cross:setisDwUp()
	    end
	    data.surestr = res.str.SURE
	    mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
	elseif isup == 2 then --进阶失败
		local data  = {}
	    data.richtext = res.str.RES_RES_54--string.format(res.str.RES_RES_54,self.conf_data.name) 
	    data.sure = function( ... )
	        -- body
	       cache.Cross:setisDwUp()
	    end
	    data.surestr = res.str.SURE
	    mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
	end
end

function CrossMainView:updateSh(value)
	-- body
	self.data.shenhuen = value
	self.lab_pos:setString(self.data.shenhuen)
end

function CrossMainView:setSelfMsg()
	-- body
	
	--服务器
	self.ls_lab:setString(self.data.selfRoleName..".")
	--角色名
	local name = cache.Player:getName()
	self.ls_lab_name:setString(name)
	self.ls_lab_name:setFontName(display.DEFAULT_TTF_FONT)
	self.ls_lab_name:setFontSize(20)

	--胜率
	self.ls_lab_win:setString(self.data.winRate.."%")
	--形象
	local str = res.image.ROLE_BOY
	local sex = cache.Player:getRoleSex()
	if sex == 1 then
	else
		str = res.image.ROLE_GRILS
	end
	self.lspr:loadTexture(str)
	--战力
	local power = cache.Player:getPower()
	if power > 10000 then
		power = string.format("%.1f",power/10000)..res.str.SYS_DEC7
	end 
	self.ls_lab_power:setString(tostring(power))
	--段位 千团配置
	self.conf_data = conf.Cross:getDwItem(self.data.roleDw)
	self:showIsup()
	--self:setTipsView(res.str.RES_RES_37)
	self.lab_dec:getParent():setVisible(true)
	self.img_win_di:setVisible(false)
	if self.data.roleDw > 0 and self.conf_data  then
		if self.data.pointShu >= self.conf_data.dw_max then
			if not self.data.djs[tostring(1)] then 
				for i = 1 ,self.conf_data.jjs_count do
					if not self.data.djs then
						self.data.djs = {}
					end
					self.data.djs[tostring(i)] = 0
				end
			end
		else
			self.data.djs = {}
		end
	end

	self.isPipei = true
	if self.data.roleDw > 0 and self.data.djs[tostring(1)] then -- 晋级赛
		self.isPipei = false
		self.lab_sai:setString(self.conf_data.name)
		self:setTipsView(res.str.RES_RES_37)

		local count = 0
		local var = 0
		for i = 1, 5 do
			local v = self.data.djs[tostring(i)]
			if v then
				count = count+1
				if v > 0 then
					var = var +1 
				end
			end
		end
		self.lab_power:setString(var.."/"..count)
		local t = {}
		for i = 1, count do -- in pairs(self.data.djs) do 

			local v = self.data.djs[tostring(i)]
			if v == 1 then
				table.insert(t,"√")
			elseif v == 2 then
				table.insert(t,"x ")
			else
				table.insert(t,"- ")
			end 
		end
		self:setWintest(t)
		self.img_win_di:setVisible(true)
		self.lab_dec:setString(res.str.RES_RES_42)
	elseif self.data.roleDw == 0 and self.data.djs[tostring(1)] then
		self.isPipei = false
		self.lab_dec:setString(res.str.RES_RES_05)
		local var = 0
		for i = 1 , 5 do 
			if self.data.djs[tostring(i)] and  self.data.djs[tostring(i)]>0 then
				var = var + 1
			end
		end
		self.lab_power:setString(var.."/"..5)
		local t = {}
		for i = 1, 5 do -- in pairs(self.data.djs) do 

			local v = self.data.djs[tostring(i)]
			if v == 1 then
				table.insert(t,"√")
			elseif v == 2 then
				table.insert(t,"x ")
			else
				table.insert(t,"- ")
			end 
			
		end
		self.img_win_di:setVisible(true)
		self:setWintest(t)
		--self.lab_reward:setString(0)
		self:setTipsView(res.str.RES_RES_38)
	else
		self.lab_sai:setString(self.conf_data.name)
		self.lab_power:setString(self.data.pointShu.."/"..self.conf_data.dw_max)
		--self.lab_reward:setString(self.conf_data.award_sh)
		if self.data.roleDw >= 26 then
			self.lab_power:setString(self.data.pointShu)
		end

		self.lab_dec:getParent():setVisible(false)
	end

	if self.conf_data  then
		self.lab_reward:setString(self.conf_data.award_zs)
	end

	--拥有
	self.lab_pos:setString(self.data.shenhuen)
	self:changeTimes()
end

function CrossMainView:setData(data_,flag)
	-- body]
	self.flag = flag
	self.data = data_
	--printt(self.data)
	self.title:setString(self.data.currSj)
	self.maxCount = conf.Recharge:getVipLimit(cache.Player:getVip(),40358) --上限排位
	if not self.maxCount or self.maxCount <= 0 then 
		for i = 17 , 1 ,-1 do 
			self.maxCount =  conf.Recharge:getVipLimit(i,40358)
			print(self.maxCount,i)
			if checkint(self.maxCount ) > 0 then
				break
			end
		end
	end

	self:setSelfMsg()

	self.rs_lab:setString("???"..".")
	self.rs_lab_name:setString("???")

	self.rs_lab_power:setString("???")
	self.rs_lab_win:setString("???")
end
--移动动画 随机到人之后
function CrossMainView:runSpr()
	local function callback(i)
		-- body
		local spr = self.movespr[i]
		if not spr then
			return 
		end
		spr:setVisible(true)

		local distance =  self.run_panle:getContentSize().height - spr:getPositionY() 
		local time = distance / 1000

		local a1 = cc.MoveTo:create(time,cc.p(0,self.run_panle:getContentSize().height))
		local a2 = cc.CallFunc:create(function( ... )
			-- body
			if i == 1 then
				spr:setPositionY(self.movespr[2]:getPositionY()-self.movespr[2]:getContentSize().height)
			else
				spr:setPositionY(self.movespr[1]:getPositionY()-self.movespr[1]:getContentSize().height)
			end
		end)
		local a3 = cc.CallFunc:create(function( ... )
			-- body
			callback(i)
		end)
		local sequence = cc.Sequence:create(a1,a2,a3)
		spr:runAction(sequence)
	end

	for i = 1 , 2 do 
		callback(i)
	end
end
--移动形象
function CrossMainView:initSpr()
	-- body
	local panle_in = self.run_panle
	panle_in:removeAllChildren()
	self.movespr = {}
	for i = 1 , 2 do
		local panle_move =  ccui.Layout:create()
		panle_move:setVisible(false)
		panle_move:setContentSize(panle_in:getContentSize())
	   	panle_move:setPosition(0,(i-2)*panle_in:getContentSize().height)
		panle_move:addTo(panle_in)

		local spr = display.newSprite(res.image.ROLE_BOY)
		if i == 2 then
			spr = display.newSprite(res.image.ROLE_GRILS)
		end
		spr:setScale(0.6)
		spr:setPositionX(panle_move:getContentSize().width/2)
		spr:setPositionY(panle_move:getContentSize().height/2)
		spr:addTo(panle_move)

		panle_move.pos = i 
		table.insert(self.movespr,panle_move)
	end
end

--对手信息
function CrossMainView:updateArm(data)
	-- body
	self.movespr = {}
	local spr = display.newSprite(res.image.ROLE_GRILS)
	if data.sex == 1 then
		 spr = display.newSprite(res.image.ROLE_BOY)
	end
	spr:setScale(0.6)
	spr:setPositionX(self.run_panle:getContentSize().width/2)
	spr:setPositionY(self.run_panle:getContentSize().height/2)
	spr:addTo(self.run_panle)

	self.rs_lab:setString(data.sPre..".")
	self.rs_lab_name:setString(data.roleName)
	self.rs_lab_name:setFontName(display.DEFAULT_TTF_FONT)
	self.rs_lab_name:setFontSize(20)

	cache.Fight.curFightName = data.roleName
	cache.Fight.curFightPower = data.power
	--战力
	local power = data.power
	if power > 10000 then
		power = string.format("%.1f",data.power/10000)..res.str.SYS_DEC7
	end 
	self.rs_lab_power:setString(tostring(power))
	
	local conf_data = conf.Cross:getDwItem(data.roleDw)
	self.rs_lab_win:setString(conf_data.name)
	

	--local dun = data.pointShu / 100
	--local pos = G_DuanWei(data.pointShu)
	--self.rs_lab_win:setString(res.str.RES_RES_23[pos])

end

--战斗匹配返回
function CrossMainView:serverCallBack(data_)
	-- body
	self.lab_2:stopAllActions()
	self.run_panle:stopAllActions()
	for k , v in pairs(self.movespr) do 
		v:stopAllActions()
		v:removeSelf()
	end

	--self.data.figthCount = self.data.figthCount - 1 
	--cache.Cross:setFigthCount(self.data.figthCount)
	
	if data_.status == 0 then
		self:updateArm(data_.tarInfo)
		self:performWithDelay(function( ... )
			-- body
			cache.Fight:setData(data_,10)
	        mgr.BoneLoad:loadCache(data_["fightReport"])
		end, 2.0)
	else
		self:initSpr()
	end
end
--开始匹配
function CrossMainView:onStart()
	-- body
	---预计匹配文字动画
	local str = res.str.RES_RES_11..math.random(5,10)
	self.lab_1:setString(str)
	local i = 0
	local function callback()
		-- body
		i = i +1 
		self.lab_2:setString(res.str.RES_RES_12..i)
	end
	callback()
	self.lab_2:schedule(callback,1.0)
	self.img_lab_1:setVisible(true)
	self.img_lab_2:setVisible(true)

	self.btnpipei:setTouchEnabled(false)
	self.btnpipei:setBright(false)
	--右边任务切换人影动画
	self.rspr:setVisible(false)
	self:runSpr()
	---发送请求匹配战斗
	proxy.copy:onSFight(102009)
end

function CrossMainView:updateBuyCount( ... )
	-- body
	self.data.canBuyCount = cache.Cross:getcanBuyCount()
end

function CrossMainView:onbtnStart( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("匹配按钮")
		if not self.data then
			return 
		elseif self.data.figthCount <= 0 and self.isPipei then
			local max = 0 --最大购买次数
			local key = 40359 --购买ID 
			local curbuy = conf.Recharge:getVipLimit(cache.Player:getVip(),key)  --当前VIP可购买次数

			for i = 17 , 1 , -1 do 
				max = conf.Recharge:getVipLimit(i,key)
				if max > 0 then
					break;
				end
			end

			local vipbuy = self.data.canBuyCount --这个是服务器 返回的当前可购买次数
			if vipbuy <= 0 then
				if curbuy == max then 
					local data = {}
					data.sure = function( ... )
						-- body
					end
					data.surestr = res.str.SURE
					data.richtext =res.str.DEC_NEW_31
					mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
					return 
				else
					local data = {}
					data.vip = res.str.DEC_NEW_32
					data.sure = function()
						-- body
						mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
						G_GoReCharge()
					end
					data.cancel = function()
						-- body
					end
					data.surestr= res.str.RECHARGE
					local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
					view:setData(data)
					return 
				end
			elseif vipbuy > 0 then --如果还有可购买次数
				local data_ = {}
				local count_count = conf.Item:getExp(221011011)
				--print(curbuy)
				--print(vipbuy)
				--print(count_count)
				data_.max = curbuy/count_count
				data_.cur = (curbuy-vipbuy)/count_count
				data_.yb = conf.buyprice:getPriceCross(data_.cur+1) 
				printt(data_)

				local view = mgr.ViewMgr:showTipsView(_viewname.ATHLETICS_ALERT)
				view:setCrossData(data_)
				return 
			end
		end
		self:onStart()
		
	end
end

function CrossMainView:onbtnMyselfWar( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("我的战机")
		local view = mgr.ViewMgr:showView(_viewname.CROSS_RANK)
		--view:setData()
		--proxy.Cross:send_123002()
	end
end

function CrossMainView:onbtnWangWar(  sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("王者之战")
		--G_TipsOfstr(res.str.DUI_DEC_12)
		
		proxy.Cross:send_123006()
		--local view = mgr.ViewMgr:showView(_viewname.CROSS_WIN_WAR)
		--view:setData()
	end
end

function CrossMainView:onBtnCall(  sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		proxy.Cross:send_122001()
	end
end

function CrossMainView:onbtnGuize(sender,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local view = mgr.ViewMgr:showView(_viewname.GUIZE)
		view:showByName(18)
	end
end

function CrossMainView:onbtnZhanji( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local view = mgr.ViewMgr:showView(_viewname.CROSS_VEDIO)
	end 
end

function CrossMainView:onbtnMobai( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--local view = mgr.ViewMgr:showView(_viewname.CROSS_WIN_MOBAO)
		--view:setData()
		proxy.Cross:send_123007()
	end
end

function CrossMainView:onbtnclose( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end

function CrossMainView:onCloseSelfView()
	-- body
	self:closeSelfView()
	mgr.SceneMgr:getMainScene():addHeadView()
	mgr.SceneMgr:getMainScene():changePageView(5)
end

return CrossMainView