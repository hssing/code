
local AdventureProxy=class("AdventureProxy",base.BaseProxy)

function AdventureProxy:init()
  self:add(512001 ,self.return512001)
  self:add(512002 ,self.return512002)
end

function AdventureProxy:return512001( data_ )
	-- body
	if data_.status ==0 then
		cache.Adventure:KeepBossinfo(data_)
		--每次打开探险 同步到探险信息到玩家信息缓存
		cache.Player:_setAdventCount(data_.lastCount) --玩家可探险次数
		cache.Player:_setAdventMaxCount(data_.maxTxCount)--最大探险次数
		cache.Player:_setAdventresetTime(data_.countTime)--每次回复时间
		cache.Player:_setAdventTime(data_.lastTime)--下一次恢复次数
	else
		debugprint("没有返回探险的boss信息")
	end
end

function AdventureProxy:return512002( data_ )
	-- body
	if data_.status ==21030001 then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	elseif data_.status == 0 or (data_.status == 20010002) then
		local oldboosid = cache.Adventure:getbossId()
		cache.Adventure:Refreshinfo(data_)
		cache.Player:_setAdventCount(data_.lastCount)

		local view = mgr.ViewMgr:get(_viewname.ADVENTUREVIEW)
		if view then 
			local flag = false
			if data_.bossId ~= oldboosid or #data_.items>0 then 
				flag = true
			end
			view:sendcallback("hurt",flag,data_)
		end 

		--[[local oldboosid = cache.Adventure:getbossId()
		
		
		

		local __view = mgr.ViewMgr:get(_viewname.ADVENTUREVIEW)
		if __view then
			local flag = false
			if data_.bossId ~= oldboosid or #data_.items>0 then 
				flag = true
			end

			--物品获得界面
			if #data_.items > 0 then 
				local itemdata = data_.items
				local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
				if not view then
					view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
					view:setData(itemdata,true,true)
					view:setButtonVisible(false)
				else
					view:setData(itemdata,true,true)
					view:setButtonVisible(false)
				end
			end 	
			--debugprint("boss受伤")
			__view:sendcallback("hurt",flag,data_)
		end]]--
	else
		debugprint("探险失败")
	end
end

--请求探险boss 的信息
function AdventureProxy:sendMessage112001()
	-- body
	self:send(112001)
end
--探险boss 
function AdventureProxy:sendMessage112002(times)
	-- body
	local data = {
		atkCount = times
	}
	self:send(112002,data)
end
return AdventureProxy


