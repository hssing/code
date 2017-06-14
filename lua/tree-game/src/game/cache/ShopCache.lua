
--[[--
  商店数据， 1 神秘  2 道具 3 vip
]]
local ShopCache = class("ShopCache",base.BaseCache)

function ShopCache:init()
	self.DataInfo={
	{},--神秘
	{},--道具
	{},--Vip礼包
	}
	self.gifts = {} --Vip等级礼包

	self.recharge = {}
end


function ShopCache:check( ... )
	-- body
	local falg = false
	for k, v in pairs(self.recharge.czList) do 
		if v.isFirst == 0 then 
			falg = true 
			break
		end  
	end 
	if  not falg then 
		cache.Player:_setDoubleRecharge(0)
	end 
end
function ShopCache:keepRechargeList(data_ )
	-- body
	self.recharge = data_

	self:check()
end

function ShopCache:updateListinfo( price )
	-- body
	--print(price)
	for k ,v in pairs(self.recharge.czList) do 
		if tonumber(v.moneyRmb) == tonumber(price) then 
			v.isFirst = 1
			break
		end 
	end 

	--[[self.recharge.isFirst = 1
	for k , v in pairs(self.recharge.czList) do
		if v.isFirst == 0 then 
			self.recharge.isFirst = 0
			break
		end 
	end ]]--
	self:check()
	--测试使用
	--debugprint("一键探险取消")
	local view = mgr.ViewMgr:get(_viewname.SHOP)
	if view then 
		view:updateChongzhi(price)
	end
end

function ShopCache:getIsRechargeFirst( ... )
	-- body
	if self.recharge.isFirst == 1 then 
		return true
	else
		return false
	end 
end

function ShopCache:getRechargeList()
	-- body
	return self.recharge.czList
end

--vip等级礼包
function ShopCache:keepgifts(data_ )
	-- body
	self.gifts = data_.gifts
end

function ShopCache:removekeepgifts( viplv )
	-- body
	for k ,v in pairs(self.gifts) do 
		if v == viplv  then 
			table.remove(self.gifts,k)
			break
		end 
	end 
	
end

function ShopCache:getgifts( ... )
	-- body
	return self.gifts
end

function  ShopCache:getlastTime()
	-- body
	return self._lastTime
end

function ShopCache:updateShopInfo( data_ )
	-- body
	if data_.stype~=nil then 
		for k , v in pairs(self.DataInfo[data_.stype]) do 
			if v.index ==data_. index and v.mId == data_.mId then 
				--print("购买成功后减少可购买物品的数量")
				v.amount = v.amount-data_.amount
				for type ,value in pairs(v.propertys) do 
					if value.type == 40105 and (v.amount and v.amount == 0) then 
						value.value = 2
						--print("---------")
						break
					end 
				end 
				break;
			end	
		end	

		if data_.stype == 3 then --vip礼包重新排序
			self:_SortVip(self.DataInfo[3])
		end--vip	
	end
end

function ShopCache:_SortVip( data_ )
	-- body
	table.sort( data_, function ( a,b )
		-- body
		local a_buy = vector2table(a.propertys,"type")[40105].value 
		local b_buy = vector2table(b.propertys,"type")[40105].value 

		a_buy = a_buy == 2 and  -1 or a_buy
		b_buy = b_buy == 2 and  -1 or b_buy


		if a_buy == b_buy then 
			return a.index<b.index
		else
			return a_buy>b_buy
		end
	end)
end

function ShopCache:_SortbyType( data_ )
	-- body
	table.sort(data_,function( a,b )
		-- body
		if conf.Item:getType(a.mId) == conf.Item:getType(b.mId) then 
			return a.index<b.index
		else	
			return conf.Item:getType(a.mId)>conf.Item:getType(b.mId)
		end
	end) 
end

function ShopCache:addLocalMsg()
	-- body
	local minid = 0
	local maxid = 0

	local have ={}
	for k ,v in pairs(self.DataInfo[3]) do 
		have[v.index]=1
	end 
	print("minid ="..minid .. " maxid = "..maxid )

	local data = conf.Recharge:getAllVipItem()
	
	table.sort(data,function( a,b )
		-- body
		return a.id<b.id
	end)
	
	for k , v in pairs(data) do 
		local t = {}
		t.index = v.id 
		t.seq = 0
		t.mId = v.mid
		t.amount = 1
		t.propertys = {}

		local p = {}
		p._length = 3
		p.type = 40101
		p.value = 2
		table.insert(t.propertys,p) 

		local p = {}
		p._length = 3
		p.type = 40102
		p.value = 1
		table.insert(t.propertys,p) 


		if not have[v.id] then 
			print("v.id = "..v.id)
			local p = {}
			p._length = 3
			p.type = 40105
			if v.vip <= cache.Player:getVip() then
				print("v.vip"..v.vip)
				p.value = 2
			else
				p.value = 0
			end 
			table.insert(t.propertys,p) 

			--printt(t)
			table.insert(self.DataInfo[3],t)
		else
			--221023040self.DataInfo[3][k].mId = v.mid
		end 

		--[[if tonumber(v.id) < tonumber(minid)  then 
			local p = {}
			p._length = 3
			p.type = 40105
			p.value = 2
			table.insert(t.propertys,p) 

			table.insert(self.DataInfo[3],t)
		elseif tonumber(v.id) > tonumber(maxid) then 
			local p = {}
			p._length = 3
			p.type = 40105
			if v.vip <= cache.Player:getVip() then
				p.value = 2
			else
				p.value = 0
			end 
			table.insert(t.propertys,p) 

			table.insert(self.DataInfo[3],t)
		else

		end ]]--
	end 
	--printt(self.DataInfo[3])
end


function ShopCache:setShopInfo(data_)
	-- body
	self.DataInfo[1] =data_.smItems 
	self.DataInfo[2] =data_.items 
	self.DataInfo[3] =data_.vipItems 
	self._lastTime = data_.lastTime
	self._todayCount = data_.todayCount
	self._recordTime = os.time();
	self:_SortbyType(self.DataInfo[1])
	table.sort(self.DataInfo[2],function ( a,b )
		-- body
		return a.index<b.index
	end)
	print("---------------------------------------*************----------------")
	printt(self.DataInfo[2])

	self:addLocalMsg()
	self:_SortVip(self.DataInfo[3])
end
function ShopCache:resetShopInfo(data_,type)
	
	if type == 1 then 
		self.DataInfo[1] = data_.smItems
		self._lastTime = data_.lastTime
		self._todayCount = data_.todayCount
		self._recordTime = os.time();
		self:_SortbyType(self.DataInfo[1])
	elseif 2 == type then 
		self.DataInfo[2] = data_.items
		table.sort(self.DataInfo[2],function ( a,b )
			-- body
			return a.index<b.index
		end)	
	else
		self.DataInfo[3] = data_.vipItems

		self:addLocalMsg()
		self:_SortVip(self.DataInfo[3])
	end 
end 


function ShopCache:setlastTime(time )
	-- body
	self._lastTime = time
end

function ShopCache:getTypeShopInfo(intdex )
	-- body
	return self.DataInfo[intdex]
end

function ShopCache:gettodayCount( ... )
	-- body
	return self._todayCount
end

function ShopCache:getShopInfo(  )
	-- body
	return self.DataInfo
end

function  ShopCache:getRecordTime()
	-- body
	return self._recordTime
end
--获取某一商品
function ShopCache:getTypeandmidShopInfo( index,mId )
	-- body
	for k , v in pairs(self:getTypeShopInfo(index)) do 
		if 	v.mId == mId then 
			return v;
		end	
	end
	return
end

function ShopCache:RefreshShopsmItem( data_ )
	-- body
	self.DataInfo[1]={};
	self.DataInfo[1] =data_.smItems 
	self._lastTime = data_.lastTime
	self._todayCount = data_.todayCount
	self._recordTime = os.time();
	self:_SortbyType(self.DataInfo[1])
end

--[[function ShopCache:setLastTime( data_ )
	-- body
	self._lastTime = data_.lastTime
end]]--

return ShopCache
