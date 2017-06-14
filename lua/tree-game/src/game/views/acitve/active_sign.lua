

local active_sign = class("active_sign",function( ... )
	-- body
	return ccui.Widget:create()
end)

function active_sign:init(Parent)
	self.Parent=Parent
	self.view=Parent:getCloneSign()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self.view:setTouchEnabled(false)
	self:addChild(self.view)

	self.btn = self.view:getChildByName("Button_13")
	self.btn:addTouchEventListener(handler(self,self.onSignCallBack))

	self.frame = {}
	for i = 1 , 7 do 
		local img = self.view:getChildByName("img_"..i)
		local t = {}
		t.img = img
		t.frame =  img:getChildByTag(1)
		t.spr = t.frame:getChildByTag(1)
		t.spr:ignoreContentAdaptWithSize(true)
		t.name = img:getChildByTag(2)
		t.vis = img:getChildByTag(100)
	
		--[[if i == 7 then 
			table.insert(self.frame,self.frame[3])
			table.insert(self.frame,t)
		else
			table.insert(self.frame,t)
		end]]--

		table.insert(self.frame,t)
	end

	self:initData()
end

function active_sign:CallBackAction(data_)
	-- body
	local armature = mgr.BoneLoad:loadArmature(404847)
	armature:setPosition(0,0)
	armature:setVisible(false)
	armature:addTo(self.view,10000)

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


	--[[local t = {}
	math.newrandomseed()
	math.newrandomseed()
	math.newrandomseed()

	local lastimg 
	local max = 20
	if #data_.gotGoods == 6 then 
		max = 1
	end

	for i = 1 , max do --随机10个位置
		local a = cc.CallFunc:create(function()
			-- body

			local rand = math.random(1,#self.item)
			if max == i then 
				rand = data_.gotGoods[#data_.gotGoods]+1
				--local widget = self.item[]
				--pos = {x = widget.img:getPositionX(),y = widget.img:getPositionY() }
			end
			print(rand)
			local pos = {x = self.item[rand].img:getPositionX(),y = self.item[rand].img:getPositionY() }
			armature:setVisible(true)
			armature:setPosition(pos)

			if not lastimg then
				lastimg = self.item[rand].vis
				lastimg:setVisible(false)
			else
				lastimg:setVisible(true)
				lastimg = self.item[rand].vis
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
	armature:runAction(sequence)]]--
end

function active_sign:onSignCallBack(send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		proxy.Double:send116070()
		mgr.NetMgr:wait(516070)
	end
end

function active_sign:initData()
	-- body
	local sysdata = conf.Double:getSignReward()
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

function active_sign:updateinfo(data_)
	-- body
	self:CallBackAction(data_)
end

function active_sign:setData(data_)
	-- body
	self.data = data_

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
end

return active_sign