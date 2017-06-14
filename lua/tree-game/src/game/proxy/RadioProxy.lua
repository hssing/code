local RadioProxy=class("RadioProxy",base.BaseProxy)



function RadioProxy:init()
	self:add(803001,self.returnPack)--更新背包
	self:add(801001,self.returnRoleProperty)
	self:add(801002,self.returnMoney)
	self:add(803002,self.returnChest)

	self:add(501005,self.returnCall)
	self:add(501006,self.returnCallbuyCout)
	self:add(501009,self.callback501009)

	--请求背包分页数据
	self:add(503006,self.reqMaterialInfoCallbacl)


	self.buystype = nil 
	self.levelup = nil --为了成就提示特别是用
end

function RadioProxy:getLevelup( ... )
	-- body
	return self.levelup
end

function RadioProxy:setLevelup(  )
	-- body
	self.levelup = nil
end

--购买 请求购买体力|竞技场|探险(返回)
function RadioProxy:send101005( data )
	-- body
	self:send(101005,data)
end

function RadioProxy:returnCall( data_ )
	-- body
	if data_.status ==0 then 
		debugprint("购买成功")
		--探险
		view = mgr.ViewMgr:get(_viewname.ADVENTUREVIEW)
		if view then
			view:setData()
		end

		if data_.stype == property_index.ATHLETICS_COUT then
            local view2 = mgr.ViewMgr:get(_viewname.ATHLETICS)
            if view2 then
                view2:updateGMTimes(data_)
            end
        elseif data_.stype == 40360 then
        	cache.Cross:reduceBuy()
        	--local count = cache.Cross:getFigthCount()
        	local view2 = mgr.ViewMgr:get(_viewname.CROSS_WAR_MAIN)
            if view2 then
                view2:updateBuyCount()
           	end
        end

	elseif data_.status ==  20010001 then-- 21050003 then 
		--debugprint("确定按钮返回")
		G_TipsForNoEnough(2)
	else
		G_TipsError(data_.status)
	end 
end

--请求已经购买的次数
function RadioProxy:send101006(stype)
	-- body
	self.buystype = stype
	 local data = {
        stype = stype,
    }
    self:send(101006,data)
end

--请求玩家信息
function RadioProxy:send101009()
	-- body
	self:send(101009)
end
--请求玩家信息(返回)
function RadioProxy:callback501009( data_ )
	-- body
	if data_.status ==0 then 
		cache.Player:setRoleInfo(data_)
		local view = mgr.ViewMgr:get(_viewname.ROLE)
		if view then 
			view:updateUi()
		end 
	end 
end

function RadioProxy:returnCallbuyCout(data_ )
	-- body
	if data_.status == 0 then 
		if self.buystype == 40411 then 
			cache.Player:_setTliBuy(data_.count/conf.Item:getExp(PRO_USE_TL[1]))
			cache.Player:setBuycount(data_.buyCount/conf.Item:getExp(PRO_USE_TL[1]))
			local view =   mgr.ViewMgr:get(_viewname.ROLE_BUY_TILI)
			if view then 
				view:chooseshow()
			else
				local view =  mgr.ViewMgr:showView(_viewname.ROLE_BUY_TILI)
				view:chooseshow()
			end 
		elseif self.buystype == 40421 then
			--todo
			cache.Player:_setAdventBuy(data_.count/conf.Item:getExp(PRO_USE_TM[1]))
			cache.Player:setDoneBuy(data_.buyCount/conf.Item:getExp(PRO_USE_TM[1]))
			local view = mgr.ViewMgr:get(_viewname.NOENOUGHTVIEW)
			if view  then 
				local times  = cache.Player:getDoneBuy() --已经购买的次数
				local ttpr = conf.buyprice:getPriceADV(times+1)
				if not ttpr then 
					ttpr = conf.buyprice:getPriceMax()
				end 

				view:send101006Callback(ttpr)
			end 

			view = mgr.ViewMgr:get(_viewname.ADVENTUREVIEW)
			if view then 
				view:SeverCallbackCountOver(data_.count)
			end 

		elseif self.buystype == 40431 then --竞技厂购买次数
			--cache.Player:_setTliBuy(data_.count)
		end 


	else
		debugprint("101006 请求 501006 没有返回 ")
	end 
end


function RadioProxy:returnPack( data_ )--更新背包
	if data_.status == 0 then
		debugprint("背包更新成功！！！！！！")
		--printt(data_)
		--G_ShowAchi()
		local battle_data={} --存放出战更新数据
		local battle_data_to={} --存放更换宠物界面数据
		local amount=0
		--装备数据
		local equipment_data=data_.equipInfo



		local data=data_.packInfo.itemBaseInfo

		local flagequip = false --标示  是上阵  还是只是换可装备
		local flagrune = false
		for k,v in pairs(data) do
			--v.propertys = vector2table(v.propertys,"type")
			if v.index >= 700000 then--果实合成材料
				if v.amount == 0 then --移除
					cache.Material:removeData(v)
				elseif data_.packInfo.opType == 0 then --添加
					v.new = true
					cache.Material:addData(v)
					local type_= conf.Item:getType(v.mId)
					NEW_ITEM_APCK_AMOUNT[type_] = NEW_ITEM_APCK_AMOUNT[type_] + v.amount
				elseif data_.packInfo.opType == 1 then --减少
					cache.Material:reduceData(v)
				end


			elseif v.index >= 600000 then 
				flagrune = true
				if v.amount == 0 then --移除
					cache.Rune:removeUseInfo(v)
				else
					cache.Rune:addUseInfo(v)
				end

			elseif v.index >= 500000 then --在背包--符文更新
				flagrune = true
				if v.amount == 0 then --移除
					cache.Rune:removepackInfo(v)
				else --添加
					v.new = true
					cache.Rune:addpackInfo(v)
					local type_= conf.Item:getType(v.mId)	
					NEW_ITEM_APCK_AMOUNT[type_] = NEW_ITEM_APCK_AMOUNT[type_] + v.amount
				end
			elseif v.index >= 400000 then
				flagequip = true
				local data_v=cache.Equipment:isKey(v.index)
				if not data_v then
					cache.Equipment:addEquitpment(v)
				else
					if v.amount <= 0  then
						--print("")
						cache.Equipment:removeEquipmentData(v.index)
					else
						v.propertys = vector2table(v.propertys,"type")
						cache.Equipment:updatePackData(v)
					end

					local view=mgr.ViewMgr:get(_viewname.EQUIPMENT_MESSAGE)
					 if view then
					 	view:onCloseSelfView()
					 	--view:updateData(v)
					 end
					view=mgr.ViewMgr:get(_viewname.PACK)
					if view then
						view:setData(cache.Pack:getPackInfo())
						view:updateUi()
					end 

					--[[local view1=mgr.ViewMgr:get(_viewname.FORMATION)
					if view1 then
						view1:setData()
						--view1:update()
					end]]--
				end
				
			
			--end
			else
				local type_= conf.Item:getType(v.mId)	
				--print("v.index = "..v.index)
				local pack_data_k,pack_data_v=cache.Pack:isKey(type_,v.index)
				--print(pack_data_k)

				if not pack_data_v and v.amount > 0  then
					--print("lai daol e zhe li ")
					v.new = true
					NEW_ITEM_APCK_AMOUNT[type_]=NEW_ITEM_APCK_AMOUNT[type_]+v.amount
					cache.Pack:addItem(v)
				else

					if v.amount > 0  then
						--print(v.mId)
						--print("///***"..v.mId)
						local poor = pack_data_v.amount-v.amount
						if poor < 0 then
							v.new = true
							NEW_ITEM_APCK_AMOUNT[type_]=NEW_ITEM_APCK_AMOUNT[type_]+(-poor)
						end
						v.propertys = vector2table(v.propertys,"type")
						cache.Pack:updatePackData(type_,v)
						
						if type_ == pack_type.SPRITE then 
							local index=conf.Item:getBattleProperty(v)
							local index1 =conf.Item:getBattlePropertyTo(v)
							if  index and index > 0 then
								battle_data[index]=v
							end	
							if index1 and index1 > 0 then
								battle_data_to[index1]=v
							end
						end 


								-----出战数据更新---------------
					else
						--print("我就草了")
						--printt(v)
						cache.Pack:removeData(type_,pack_data_k,v)
					end
					
				end
			end 
		end
		-- for k,v in pairs(remove_data) do
		-- 	cache.Pack:removeData()
		-- end

		--更新出战界面
		-- local view=mgr.ViewMgr:get(_viewname.BATTLE_LIST) 
		-- if view then
		-- 	view:updateBattleData(data)
		-- end

		--更新背包数据
		cache.Pack:update()
		--出战界面
		local view=mgr.ViewMgr:get(_viewname.CHANGE_FORMATION)
		if view then
			for k,v in pairs(battle_data_to) do 
				local widget=view:updateWidget(k,v)
				view:addPet(widget)
				view:updatePower()
			end
		end
		local view1=mgr.ViewMgr:get(_viewname.FORMATION)
		if view1 then

			local pos = proxy.card:returnToindx()
			proxy.card:setToindx(-1)
			debugprint("......"..pos)
			--view1:update(pos)
			--debugprint("dddddd")
			if not flagequip and not flagrune then 
				view1:setData(pos)
			else
				view1:setData()
			end 
			printt(battle_data)
		end
		--信息
		 view=mgr.ViewMgr:get(_viewname.PETDETAIL)
		 if view then
		 	--[[for k,v in pairs(battle_data) do 
				view:updateData(v)
			end]]
			local  alldata  = cache.Pack:getTypePackInfo(pack_type.SPRITE)
			local onbattle = {}
			for k,v in pairs(alldata) do
				if conf.Item:getBattleProperty(v) > 0 then
					table.insert(onbattle,v) --所有上阵的人
				end
			end

			table.sort( onbattle, function ( a,b )
				local in1=conf.Item:getBattleProperty(a)
				local in2=conf.Item:getBattleProperty(b)
				return in1 < in2
			end )
			view:setData(onbattle)
			view:updateDataSelect()
		 end

		--更新 数量提示 
		view=mgr.ViewMgr:get(_viewname.MAIN) 
		if view then
			view:setRedPoint(NEW_ITEM_APCK_AMOUNT)
		end

		view= nil 
		view=mgr.ViewMgr:get(_viewname.PACK)
		if view then
			--print("wo cao le ")
			view:setData(cache.Pack:getPackInfo())
			view:updateUi()
		end 

		view=mgr.ViewMgr:get(_viewname.HEAD)
		if view then
			view:updateUi()
		end

		
	elseif data_.status == 21030001 then 
  		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	else
		debugprint("背包更新失败！！！！！！")
	end
end


function RadioProxy:returnRoleProperty( data_ )--人物属性更新
	if data_.status == 0 then
		debugprint("人物更新成功！！！！！！")

		--记录之前的信息 主要来对比
		local tt = {}
		tt.tili_befor = cache.Player:getTili()
		tt.oldadv = cache.Player:getAdventCount()
		tt.arencout = cache.Player:getAthleticsCout()


		tt.oldmaxtil = cache.Player:getMaxtli()
		tt.oldmaxadv = cache.Player:getAdventMaxCount()
		tt.oldmaxaream = cache.Player:getMaxAthleticsMax()
		tt.vip = cache.Player:getVip()
		local data=data_.property
		data=vector2table(data,"type")
		--因为 时间恢复不是每次都发
		--比较恶心 如果是探险的次数更新 要在这里去多更新一次
		if data[40421] then 
			cache.Adventure:setlastCount(data[40421].value)
		end 

		if data[40202] then
			--G_TipsOfstr(data[40202].value)
			cache.Player:setHead(data[40202].value)
		end

		if data[40724] and data[40724].value < 1 then
			local view = mgr.ViewMgr:get(_viewname.RANKENTY)
			if view then
				view:onCloseSelfView()
			end
		end
		--刷新跨服战次数
		if data[40360] then
			cache.Cross:setFigthCount(data[40360].value)
		end


		cache.Player:updateAllProperty(data)

		if data[314] then  --更新公会等级
			cache.Guild:setGuildLevel(data[314].value)
			local view = mgr.ViewMgr:get(_viewname.GUILD_VIEW)
			if view then 
				view:setData(cache.Guild:getGuildBaseInfo())
			end 
		end 

		tt.newTili = cache.Player:getTili()
		tt.newadv = cache.Player:getAdventCount()
		tt.newarean= cache.Player:getAthleticsCout()
		tt.newvip = cache.Player:getVip()

		if tt.newvip ~= tt.vip then
			--debugprint("")
			local view = mgr.ViewMgr:showView(_viewname.VIP_TIPS)
			view:setData(tt.newvip)
		end


		--[[if tt.newTili <  cache.Player:getMaxtli() and tt.tili_befor == tt.oldmaxtil then 
			cache.Player:setreTili() --记录 倒数时间点
		end 

		if tt.newadv < cache.Player:getAdventMaxCount() and tt.oldadv == tt.oldmaxadv then 
			cache.Player:setAdvrecordTime()
		end 

		if tt.newarean < cache.Player:getMaxAthleticsMax() and tt.arencout == tt.oldmaxaream then 
			cache.Player:setAdvrecordTime()
		end ]]--

		--printt(cache.Player:getRoleInfo())
		if data[304] then
				--SDK提交额外信息
				sdk:extendInfoSubmit(3003)
				
		   self.levelup = true
		   print("cache.Fight.fightState = "..cache.Fight.fightState)
	       if cache.Fight.fightState>0 then
               cache.Fight.fightLevelUp = cache.Fight.fightState
	           cache.Fight.fightLevelParams = tt
	       else
	       		print("funck")
	       	
                local view=mgr.ViewMgr:get(_viewname.LEVEL_UP)
                if not view then
                	print("funck view")
                    mgr.ViewMgr:showView(_viewname.LEVEL_UP,1000):updateUi(tt)
                end
	       end
		end
		local view=mgr.ViewMgr:get(_viewname.ROLE)
		if view then
			view:updateUi()
		end
		--[[view=mgr.ViewMgr:get(_viewname.FORMATION)
		if view then
			view:updateFrame()
		end]]--
		view=mgr.ViewMgr:get(_viewname.HEAD)
		if view then
			view:updateUi()
		end
		--刷新红点
		local view = mgr.ViewMgr:get(_viewname.MAIN)
		if view then 
			view:setRedPoint()
			view:hidbtn() --双11活动开关
		end 

		local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
		if view then 
			view:setRedPoint()
		end 
		
		--G_ShowAchi()

	else
		debugprint("人物更新失败！！！！！！")
	end
end

function RadioProxy:returnChest( data_ )--人物属性更新
	if data_.status == 0 then
		--G_ShowAchi()
		local data=data_.itemInfo
		debugprint("宝箱更新成功！！！！！！")
		--printt(data)

		local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
		if not view then
			view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
			view:setData(data,true,true)
			view:setButtonVisible(false)
		end
        --使用了道具
        local ids = {1036}
        mgr.Guide:continueGuide__(ids)
    elseif data_.status == 21030001 then 
  		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	else
		debugprint("宝箱更新失败！！！！！！")
	end
end
function RadioProxy:returnMoney( data_ )--人物属性更新
	if data_.status == 0 then
		debugprint("资源更新成功！！！！！！")
		--G_ShowAchi()
		--printt(data_)
		local data=data_.money

		cache.Fortune:updateFortuneInfo(data)
		if data.moneyGx then 


			cache.Guild:setGuildPoint(data.moneyGx)
			local view = mgr.ViewMgr:get(_viewname.GUILD_VIEW)
			if view then 
				view:setData(cache.Guild:getGuildBaseInfo())
			end 
		end 
		if data.moneySh then
			local view = mgr.ViewMgr:get(_viewname.CROSS_WAR_MAIN)
			if view then
				view:updateSh(data.moneySh)
			end
		end

		local view=mgr.ViewMgr:get(_viewname.ROLE)
		if view then
			view:updateUi()
		end
		view=mgr.ViewMgr:get(_viewname.HEAD)
		if view then
			view:updateUi()
		end
	else
		debugprint("资源更新失败！！！！！！")
	end
end


--请求背包分页
function RadioProxy:reqMaterialInfo( page)
	-- body
	local realPage = {5}
	self.pageIdx = realPage[page]
	self:send(103006,{pageType = page})
	self:wait(503006)
end

function RadioProxy:reqMaterialInfoCallbacl( data )
	if data.status == 0 then

		--dump(data)
		cache.Material:savaData(data)--果实合成材料
		-- cache.Pack:setPackInfo(data)
		local view = mgr.ViewMgr:get(_viewname.PACK)
		if view then
			view:initPageData(self.pageIdx)
			view:initAllPanle(self.pageIdx)
		end

	    local view = mgr.ViewMgr:get(_viewname.MAIN)
	    if view then 
	      view:setRedPoint()
	    end 
  else
    debugprint("请求背包信息失败")
  end
	
end






return RadioProxy