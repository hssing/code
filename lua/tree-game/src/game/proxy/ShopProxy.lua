local ShopProxy = class("ShopProxy",base.BaseProxy)



function ShopProxy:init()
	-- self:add(503001,self.returnPack)
	self.buydata = {};
	self.senvip = 0
	self:add(505001 ,self.keepCacheShop)--获取商店
	self:add(505002 ,self.RefreshCacheShop)--购买返回
	self:add(505003 ,self.RefreshCacheShopsmItem)--神秘商店刷新返回 

	self:add(511002 ,self.callBackgetReward)--领取首冲奖励
	self:add(511001 ,self.callBackRecharge)--充值返回
	self:add(511003 ,self.VipgetRewardCallBack)
	self:add(511004 ,self.keepWhichCallget)

	self:add(511201,self.RechargeListCallBack)


	self.sendmType = 1 --神秘商店刷新类型
	self.sendshoptype = 0 

	self.idx = 0 
	self.money = 0
end

function ShopProxy:setmoney(var )
	-- body
	self.money = var
end

function ShopProxy:sendRechargeList(index)
	-- body
	self.idx = index or 0
	self:send(111201)
end

function ShopProxy:RechargeListCallBack(data_)
	-- body
	if data_.status == 0 then 
		cache.Shop:keepRechargeList(data_)
		local __view = mgr.ViewMgr:get(_viewname.SHOP)
		if __view then 
			__view:initRechargeData()
			__view:initAllPanle(4,self.idx)
			if checkint(self.money) > 0 then
				__view:toConfGold(self.money)
				self:setmoney(0)
			else
				self.money = 0
			end
		end 
	else
		debugprint("没有返回充值列表")
	end
end
function ShopProxy:updateShopUI(index)
	-- body
	local __view = mgr.ViewMgr:get(_viewname.SHOP)
   	if __view ~= nil then
   		if index~=nil then 
   			if self.sendshoptype == 3 then 
   				if __view.packindex ==3 then 
   					__view:updateShop(index,self.buydata)
   				end 
   			else
	   			if __view.packindex == index then
					__view:updateShop(index,self.buydata)
				end
			end 
   		else
   			__view:updateShop()
   		end	
     	
    else
    	--mgr.SceneMgr:getMainScene():changeView(8)
    end
end

function ShopProxy:RefreshCacheShop(data_)
	-- body
	if data_.status==0 then
		G_TipsOfstr(res.str.BUY_SUCCESS)
		if self.buydata.stype == 4 then 
			local view = mgr.ViewMgr:get(_viewname.TASK)
			view:updatebuy(self.buydata)
			return
		end

		cache.Shop:updateShopInfo(self.buydata)
		local __view = mgr.ViewMgr:get(_viewname.SHOP_BUY)
		if __view~=nil then 
			__view:onCloseSelfView()--购买成功 关闭2次购买界面
		end	
		self:updateShopUI(self.buydata.stype)
		
        --确认购买
        local ids = {1019, 1033, 1055}
        mgr.Guide:continueGuide__(ids)
        
	elseif 21050003 ==  data_.status then 
		G_TipsOfstr(res.str.NO_ENOUGH_ZS)
	elseif 21030001 == data_.status then
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	else
		G_TipsError(data_.status)
	end
end

function ShopProxy:RefreshCacheShopsmItem( data_ )
	-- body
	if data_.status == 0 then
		if self.sendmType ~=1 then 
			G_TipsOfstr(res.str.SHOP_SUCCESS)
		end 

		cache.Shop:RefreshShopsmItem(data_)
		self:updateShopUI(1)
	elseif data_.status == 21050001 then --时间还没到不能刷新
		 G_TipsOfstr(res.str.SHOP_TIME_NEED)
		 cache.Shop:RefreshShopsmItem(data_)
		 self:updateShopUI()
	elseif 21050002 == data_.status then --木有可用道具
		 G_TipsOfstr(res.str.SHOP_ITEM_NEED)
	elseif 21050003 ==  data_.status then --钻石不足
		 G_TipsOfstr(res.str.NO_ENOUGH_ZS)
	elseif 21050004 == data_.status then --道具数量不足
		 G_TipsOfstr(res.str.NO_ENOUGH_ITEM)
	elseif 21050005 ==  data_.status then --今日刷新次数已经用完
		 G_TipsOfstr(res.str.SHOP_TIME_OUT)
	else	
		debugprint("神秘商店刷新失败")
	end	
end
---刷新神秘商店
function ShopProxy:send105003( sendmType )
	-- body
	self.sendmType = sendmType
	local __reqdata = {
		mType = sendmType,
	}
	self:send(105003,__reqdata)
	
end

function  ShopProxy:keepCacheShop( data_ )
	-- body
	if data_.status == 0 then 
		if self.sendshoptype == 4 then 
			local view = mgr.ViewMgr:get(_viewname.TASK)
			if view then
				view:setData1(data_)
			end
			return
		end
		if self.sendshoptype == 0 then 
			cache.Shop:setShopInfo(data_)
		else
			cache.Shop:resetShopInfo(data_,self.sendshoptype)
		end 
		self:updateShopUI()
	else
		G_TipsError(data_.status)
	end	
end
--请求商店信息
function ShopProxy:sendMessage( types )
	-- body
	local __reqdata = {
		stype = types,
	}
	self.sendshoptype = types
	self:send(105001,__reqdata)
	self:wait(505001)
end

function ShopProxy:buySend( data_ )
	-- body
	self.buydata = data_;
	self:send(105002,data_)
end
--vip礼包
function ShopProxy:sengVipget( viplv )
	-- body
	local data = {
		vipLvl = viplv
	}
	self.senvip = viplv
	self:send(111003,data)
end

--求情那些VIp礼包可以领取
function ShopProxy:send111004()
	-- body
	self:send(111004)
end

function ShopProxy:keepWhichCallget( data_ )
	-- body
	if data_.status == 0 then
		cache.Shop:keepgifts(data_)
		local __view = mgr.ViewMgr:get(_viewname.VIP)
		if __view then 
			__view:updateCurrPage()
		end
	else
		--todo
		debugprint("请求vip可领取礼包返回失败")
	end 
end

function ShopProxy:VipgetRewardCallBack(data_ )
	-- body
	if data_.status == 0 then 
		--cache.Shop:keepgifts(data_)
		cache.Shop:removekeepgifts(self.senvip)
		local __view = mgr.ViewMgr:get(_viewname.VIP)
		if __view then 
			debugprint("vip 领取更新")
			__view:updateCurrPage()
		end
	--elseif data_.status then vip等级不对
	 	--todo 

	else
		debugprint("领取失败")
	end
end


--首充 礼包
function ShopProxy:callBackgetReward( data_ )
	-- body
	if data_.status ==0 then 
		--debugprint("领取成工")
		cache.Player:_setFirt(2)
		local view = mgr.ViewMgr:get(_viewname.SHOP)
		if view then 
			view:initAllPanle(4)
		end 

		--self:updateShopUI()
	elseif data_.status == 21030001 then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	else
		local function cancelcallbcak( ... )
			-- body
		end

		local data = {};
   		data.richtext = res.str.RECHARGE_PLEASE;
	    data.sure = function()
	    	-- body
	    	G_GoReCharge()
	    end
	    data.surestr =res.str.SURE
	    data.cancel = cancelcallbcak
	    mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
		--debugprint("领取失败")
	end
end

function ShopProxy:sendGetfirst()
	-- body
	self:send(111002)
end

function ShopProxy:callBackRecharge( data_ )
	-- body
	if data_.status == 0 then 
		debugprint("充值成功")
		--重新请求 vip商店
		--self:sendMessage(0)

		
		
	else
		debugprint("充值失败")
	end	

end
---请求充值
function ShopProxy:sendRecharge(money)
	-- body
	--111002
	--self.zs = money
	local __reqdata = {
		money_zs = money,
	}
	self:send(111001,__reqdata)
	--假设成功
	--cache.Shop:updateListinfo(money)
end

return ShopProxy