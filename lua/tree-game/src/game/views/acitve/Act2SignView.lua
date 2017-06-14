--
-- Author: Your Name
-- Date: 2015-11-25 15:44:07
--
local Act2SignView = class("Act2SignView", base.BaseView)


function Act2SignView:init(  )
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.panel= self.view:getChildByName("Panel_11_0")
	self.btn = self.panel:getChildByName("Button_13_2")
	self.btn:addTouchEventListener(handler(self,self.onSignCallBack))
	self.view:getChildByName("Panel_11_1"):setVisible(false)

	self.frame = {}
	for i = 1 , 7 do 
		local img = self.panel:getChildByName("img_"..i)
		local t = {}
		t.img = img
		t.frame =  img:getChildByTag(100)
		t.spr = t.frame:getChildByTag(100)
		t.spr:ignoreContentAdaptWithSize(true)
		t.name = img:getChildByTag(101)
		t.vis = img:getChildByTag(1000)
	
		--[[if i == 7 then 
			table.insert(self.frame,self.frame[3])
			table.insert(self.frame,t)
		else
			table.insert(self.frame,t)
		end]]--

		table.insert(self.frame,t)
	end

	self:initData()
	proxy.RichRank:send116134()

	--界面文本
	self.view:getChildByName("Panel_1"):getChildByName("Text_5_23"):setString(res.str.ACT2_SIGN_DESC1)

end

function Act2SignView:CallBackAction(data_)
	-- body

	self.btn:setTouchEnabled(false)

	local armature = mgr.BoneLoad:loadArmature(404847)
	armature:setPosition(0,0)
	armature:setVisible(false)
	armature:addTo(self.panel,10000)

	local t = {}
	local lastimg 
	local max = 20
	if #data_.gotGoods == 7 then 
		max = 1
	end

	for i = 1 , max do --随机10个位置
		local a = cc.CallFunc:create(function()
			-- body

			local rand = i % #self.ids  --math.random(1,#self.item)
			if rand == 0 then 
				rand = #self.ids
			end
			rand = self.ids[rand]

			if max == i then 
				rand = data_.gotGoods[#data_.gotGoods]+1
			end
			print(rand)
			local pos = {x = self.frame[rand].img:getPositionX(),y = self.frame[rand].img:getPositionY() }
			armature:setVisible(true)
			armature:setPosition(pos)

			if not lastimg then
				lastimg = self.frame[rand].vis
				lastimg:setVisible(false)
			else
				lastimg:setVisible(true)
				lastimg = self.frame[rand].vis
				lastimg:setVisible(false)
			end


		end)
		table.insert(t, a )
		if i <= 5 then 
			table.insert(t,cc.DelayTime:create(0.2-(5-i)*0.05))
		elseif i <= 15 then 
			table.insert(t,cc.DelayTime:create(0.15))
		else
			table.insert(t,cc.DelayTime:create(0.1+(i-15)*0.05))
		end
		if i == max then 
			local a2 = cc.CallFunc:create(function()
				-- body
				local key  
				self.data.gotGoods = data_.gotGoods
				for k ,v in pairs(data_.gotGoods) do 
					local widget = self.frame[v+1]
					if widget then 
						if not widget.img:getChildByName("lingqu") then 
							local spr = display.newSprite(res.font.GETDONE)
							spr:setName("lingqu")
							spr:setPosition(widget.img:getContentSize().width/2,widget.img:getContentSize().height/2)
							spr:addTo(widget.img)

							widget.vis:setVisible(false)
						end
					end
				end

				self.data.awardSign = data_.awardSign
				if data_.awardSign == 1 then 
					self.btn:setTouchEnabled(false)
					self.btn:setBright(false)
				else
					self.btn:setTouchEnabled(true)
					self.btn:setBright(true)
				end

				local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
				if not view then
					view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
					view:setData(data_.items,false,true,true)
					view:setButtonVisible(false)
				end
			end)
			table.insert(t, a2 )
		end
	end
	local sequence = transition.sequence(t)
	armature:runAction(sequence)


end

function Act2SignView:onSignCallBack(send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		proxy.RichRank:send116135()
		--mgr.NetMgr:wait(516070)
	end
end

function Act2SignView:initData()
	-- body
	local sysdata = conf.ActiveVar:getValueByName("yunyingqiandao")
	--printt(sysdata)
	self.item = {}
	for k, v in pairs(sysdata) do
		local mId = v[1]
		local count = v[2]

		local cololv = conf.Item:getItemQuality(mId)

		local widget = self.frame[k]
		--if k == 7 then 
		--	widget = self.frame[8]
		--end

		widget.frame:loadTextureNormal(res.btn.FRAME[colorlv])
		widget.spr:loadTexture(conf.Item:getItemSrcbymid(mId))
		widget.name:setString(conf.Item:getName(mId).."x"..count)
		widget.name:setColor(COLOR[cololv])
		widget.mId = tonumber(k)

		self.item[k] = widget
	end
end

function Act2SignView:updateinfo(data_)
	-- body
	self:CallBackAction(data_)
end

function Act2SignView:setData(data_)
	-- body
	self.data = data_
	--dump(data_)
	self.ids = {} --抽奖循环
	local id_table = {}
	for k ,v in pairs(data_.gotGoods) do
		local widget = self.item[v+1]

		--[[if v + 1 < 7 then 
			table.insert(id_table,v+1)
		else
			table.insert(id_table,8)
		end]]--
		table.insert(id_table,v+1)
		
		
		if  widget then 
			local spr = display.newSprite(res.font.GETDONE)
			spr:setPosition(widget.img:getContentSize().width/2,widget.img:getContentSize().height/2)
			spr:addTo(widget.img)
			widget.vis:setVisible(false)
		end
	end


	local function isValue( id  )
		-- body
		--[[if id == 7 then 
			id = 3
 		end]]--

 		for k,v in pairs(id_table) do 
 			if v == id then 
 				return true
 			end
 		end

 		return false
	end

	for i = 1 , 7 do 
		if not isValue(i) then
			table.insert(self.ids,i)
		end
	end
	print("--------------------------")
	printt(self.ids)
	print("--------------------------")

	self.btn:setTouchEnabled(true)
	self.btn:setBright(true)
	if data_.awardSign == 1 then 
		self.btn:setTouchEnabled(false)
		self.btn:setBright(false)
	end

	--倒计时
	self.leftTime = self.data["leftTime"]
	self.dayTime = self.data["dayLeft"]
	local timeStr = self:getTimeStr(self.leftTime)
	if self.leftTime <= 0 then
		timeStr = res.str.RICH_RANK_DESC37
	end

	--local day = self.data["dayCount"] > 0 and self.data["dayCount"] - 1 or 0
	--如果是主界面进入
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		view:updateData(timeStr,"")--,string.format(res.str.ACT2_SIGN_DESC2, self.data["dayCount"]))
	end

	self.timeSchedual = self:schedule(self.timeTick, 1)

end


-----活动倒计时
function Act2SignView:timeTick( )
	self.leftTime = self.leftTime - 1
	self.dayTime = self.dayTime - 1
	--self.todayTime = self.todayTime - 1
	if self.leftTime <= 0 then
		self:stopAction(self.timeSchedual)
		--如果是主界面进入
		local view = mgr.ViewMgr:get(_viewname.RANKENTY)
		if view then
			view:updateData(res.str.RICH_RANK_DESC37)
		end

		self.btn:setBright(false)
		self.btn:setEnabled(false)
		G_mainView()

		return
	end

	if self.dayTime <= 0 then
		self:stopAllActions()
		proxy.RichRank:send116134()
		return
	end

	-- if self.todayTime <= 0 then
	-- 	self:stopAllActions()
	-- 	proxy.RichRank:reqOpenChargeCountInfo()
	-- 	return
	-- end

	--如果是主界面进入
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		view:updateData(self:getTimeStr(self.leftTime))
	end

end


function Act2SignView:getTimeStr( leftTime )
	--self.leftTime = self.leftTime - 1
	local left = 0
	local day = math.floor(leftTime / (60 * 60 * 24))--天
	left = leftTime - day * 60 * 60 * 24

	local hour = math.floor(left / (60 * 60))--时
	left = left - hour * 60 * 60

	local minute = math.floor(left / 60)--分
	left = left - minute * 60 --秒
	local timeStr

	if day == 0 and hour == 0 and minute == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC9,left)
	elseif day == 0 and hour == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC10, minute,left)
	elseif day == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC11, hour,minute,left)
	else
		timeStr = string.format(res.str.RICH_RANK_DESC12, day,hour,minute,left)
	end

	return timeStr
end







return Act2SignView