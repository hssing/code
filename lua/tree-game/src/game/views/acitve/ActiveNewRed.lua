--[[
	ActiveNewRed --登陆红包
]]

local ActiveNewRed = class("ActiveNewRed", base.BaseView)

function ActiveNewRed:ctor()
	-- body
	self.scrolltime = 2.0 --左右停止
end

function ActiveNewRed:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.mianview = mgr.ViewMgr:get(_viewname.RANKENTY)
	self:schedule(self.changeTimes,1.0,"changeTimes")
	self.cloneitem = self.view:getChildByName("Panel_5_1_0")
	self:initDec()
end


function ActiveNewRed:initDec()
	-- body
	local img = self.view:getChildByName("Image_96")
	img:getChildByName("Text_40"):setString(res.str.ACT_DEC_6)

	local panle = self.view:getChildByName("Panel_2")
	btn = panle:getChildByName("Button_1")
	btn:setTitleText("")
	btn:addTouchEventListener(handler(self,self.onbtngetOnce))
	self.btn = btn

	self.img = btn:getChildByName("Image_2")
	self.img:loadTexture(res.font.NEWRED[1])

	self.panlelist = {}
	for i = 1 , 3 do 
		table.insert(self.panlelist,panle:getChildByName("Panel_5_"..i))
	end
end

function ActiveNewRed:runSpr(movespr,run_panle,speed,flag,number)
	-- body
	if flag then
		for k , v in pairs(movespr) do 
			v:stopAllActions()
		end
	end
	local function callback(i)
		-- body
		local spr = movespr[i]
		if not spr then
			return 
		end
		spr:setVisible(true)
		
		local distance =  run_panle:getContentSize().height - spr:getPositionY() 
		local time = distance / speed

		local a1 = cc.MoveTo:create(time,cc.p(0,run_panle:getContentSize().height))
		local a2 = cc.CallFunc:create(function( ... )
			-- body
			if i == 1 then
				spr:setPositionY(movespr[2]:getPositionY()-movespr[2]:getContentSize().height)
			else
				spr:setPositionY(movespr[1]:getPositionY()-movespr[1]:getContentSize().height)
			end
		end)
		local a3 = cc.CallFunc:create(function( ... )
			-- body
			local star = 0
			if i == 1 then
				star = movespr[2].txt:getString()+1
				if star > 9 then
					star = 0
				end
			else
				star = movespr[1].txt:getString()+1
				if star > 9 then
					star = 0
				end
			end
			spr.txt:setString(star)

			if number == star   then
				movespr[1]:stopAllActions()
				movespr[2]:stopAllActions()

				if movespr[1].txt:getString() == ""..number then
					movespr[1]:moveTo(0.8, 0,0)
					movespr[2]:moveTo(0.8, 0,run_panle:getContentSize().height)
				else
					movespr[2]:moveTo(0.8, 0,0)
					movespr[1]:moveTo(0.8, 0,run_panle:getContentSize().height)
				end

				
				if movespr == self.movespr[1] then
					self:performWithDelay(function( ... )
						-- body
						--G_TipsOfstr(string.format(res.str.ACT_DEC_10,self.data.diamond))
						local t = { {mId = 221051002 , amount = self.data.diamond,propertys = {}} }
						--弹出获得界面
						local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
						if not view and #t > 0 then

							view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
							view:setData(t,false,true,true)
							view:setButtonVisible(false)
						end

					end, 0.8)
				end 
			else
				callback(i)
			end
		end)
		local sequence = cc.Sequence:create(a1,a2,a3)
		spr:runAction(sequence)
	end

	for i = 1 , 2 do 
		callback(i)
	end
end

function ActiveNewRed:setRunPanle()
	-- body
	self.movespr = {}
	for k , v in pairs(self.panlelist) do 
		local panle_in = v
		panle_in:removeAllChildren()
		local movespr = {}
		for i = 1 , 2 do
			local panle_move =  self.cloneitem:clone()
			panle_move:setVisible(true)
			panle_move:setContentSize(panle_in:getContentSize())
		   	panle_move:setPositionX(0)
		   	if i == 1 then
		   		panle_move:setPositionY(0)
		   	else
		   		panle_move:setPositionY(-panle_in:getContentSize().height)
		   	end
			panle_move:addTo(panle_in)

			local txt = panle_move:getChildByName("AtlasLabel_3")
			txt:setString(0)

			if i == 1 then
				if k == 1 then
					txt:setString(self.b or 0)
				elseif k == 2 then 
					txt:setString(self.s or 0)
				elseif k == 3 then
					txt:setString(self.g or 0)
				end
			elseif i==2 then
				local c = 9
				if k == 1 then
					c =(self.b or 0) +1
					if c > 9 then
						c = 0
					end
				elseif k == 2 then 
					c =(self.s or 0) +1
					if c > 9 then
						c = 0
					end
				elseif k == 3 then
					c =(self.g or 0) +1
					if c > 9 then
						c = 0
					end
				end
				txt:setString(c)
			end
			panle_move.pos = i - 1
			panle_move.txt = txt
			table.insert(movespr,panle_move)
		end
		table.insert(self.movespr,movespr)
	end

end

function ActiveNewRed:Startrun()
	-- body
	--self.movespr = {}
	for k , v in pairs(self.panlelist) do 
		local panle_in = v
		self:runSpr(self.movespr[k],v,1200)
	end
end

function ActiveNewRed:StopAction()
	-- body
	if not self.movespr then 
		return
	end

	for k ,v in pairs(self.movespr) do 
		if k == 1 then 
			self:performWithDelay(function( ... )
				-- body
				self:runSpr(v,self.panlelist[k],800,true)
			end, 3.0)

			self:performWithDelay(function( ... )
				-- body
				self:runSpr(v,self.panlelist[k],500,true,self.b or 0)
			end, 3.3)
		elseif k == 2 then 
			self:performWithDelay(function( ... )
				-- body
				self:runSpr(v,self.panlelist[k],800,true)
			end, 1.2)

			self:performWithDelay(function( ... )
				-- body
				self:runSpr(v,self.panlelist[k],500,true,self.s or 0)
			end, 1.8)
		else
			self:performWithDelay(function( ... )
				-- body
				self:runSpr(v,self.panlelist[k],800,true)
			end, 0.1)

			self:performWithDelay(function( ... )
				-- body
				self:runSpr(v,self.panlelist[k],500,true,self.g or 0)
			end, 0.8)

		end
	end
end

function ActiveNewRed:setbtn( ... )
	-- body
	self.curcount = (self.conf.value - self.data.count ) or 0
	if self.curcount > 0 then 
		self.btn:setTouchEnabled(true)
		self.btn:setBright(true)
		--self.btn:setTitleText(res.str.MAILVIEW_GET)
		self.img:loadTexture(res.font.NEWRED[1])
	else
		self.btn:setTouchEnabled(false)
		self.btn:setBright(false)
		--self.btn:setTitleText(res.str.MAILVIEW_GET_OVER)
		self.img:loadTexture(res.font.NEWRED[2])
	end
end

function ActiveNewRed:setSvrData(data)
	-- body
	self.data.diamond = data.diamond

	self.b = math.floor(data.diamond/100)
	self.s = math.floor(data.diamond%100/10)
	self.g = data.diamond%10
	self:StopAction()

	self.data.count = data.count
	self:setbtn()
end

function ActiveNewRed:changeTimes( ... )
	-- body
	if not self.data then
		if self.mianview then
			self.mianview:updateData("")
		end
		return 
	end

	self.data.remainTime = self.data.remainTime - 1
	if self.data.remainTime < 0 then 
		G_mainView()
		return
	end

	self.mianview:updateData(G_getTimeStr(self.data.remainTime))
end

function ActiveNewRed:setData(data)
	-- body
	self.conf = conf.active:getItem(2)

	self.data = data
	self.b = math.floor(data.diamond/100)
	self.s = math.floor(data.diamond%100/10)
	self.g = data.diamond%10

	self:setRunPanle()
	self:setbtn()
	self:changeTimes()
end

function ActiveNewRed:onbtngetOnce( send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--按钮按一下
		proxy.Active:send_116160()
		self:Startrun()
	end
end

return ActiveNewRed
