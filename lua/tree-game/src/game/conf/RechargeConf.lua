--充值  配置
local RechargeConf=class("RechargeConf",base.BaseConf)

function RechargeConf:init(  )
	self.conf = require("res.conf.shop_recharge")

	self.first = require("res.conf.shop_first_reward")

	self.vip = require("res.conf.shop_vip_item")

	self.exp = require("res.conf.vip_exp")	
end
-- viplv  ... id --对应ID命名规则  40442 招财上限
function RechargeConf:getVipLimit(viplv,id)
	-- body
	local count = 0
	for k ,v in pairs(self.exp[tostring(viplv)].vip_affect) do 
		--print("v[1] = "..v[1])
		if id == v[1] then
			count =  v[2]
			break;
		end 
	end 
	--print(count)
	return count
end

function RechargeConf:getAllVipItem()
	-- body
	return table.values(self.vip)
end

--获取所有充值商品
function RechargeConf:getconf(  )
	-- body
	local t = {}
	for k ,v in pairs(self.conf) do 
		table.insert(t,v)
	end 

	table.sort(t,function(a,b )
		-- body
		return a.rmb>b.rmb
	end)

	--[[for i = 1 ,  6 do 
		local t1 = self.conf[tostring(i)]
		if t1 then table.insert(t,t1) end 
	end	]]--

	return t
end
--获取价值多少RMB
function RechargeConf:getRbm( id )
	-- body
	local item  = self.conf[tostring(id)]
	if item then 
		return item.rmb 
	else
		self:Error(id)
		return nil
	end	
end
--对应钻石
function RechargeConf:getZS( id )
	-- body
	local item  = self.conf[tostring(id)]
	if item then 
		return item.money_price 
	else
		self:Error(id)
		return nil
	end	
end
function RechargeConf:getMid(  id)
	-- body
	local item  = self.conf[tostring(id)]
	if item then 
		return item.mid 
	else
		self:Error(id)
		return nil
	end	
end

--获取首次充值赠送
function RechargeConf:getFirstreward()
	-- body
	local t = {}
	for i = 1 ,  4 do 
		local t1 = self.conf[tostring(i)]
		if t1 then table.insert(t,t1) end 
	end	
	return t
end
--获取商品的原价
function RechargeConf:getOldPrice( id )
	-- body
	local item  = self.vip[tostring(id)]
	if item then 
		return item.old_price 
	else
		self:Error(id)
		return nil
	end	
end
--获取VIP 下一等级需要的exp
function RechargeConf:getNextExp( lv )
	-- body
	local item  = self.exp[tostring(lv)]
	if item then 
		return item.exp  
	else
		self:Error(lv)
		return nil
	end	
end
--vip 描述
function RechargeConf:getDec( lv )
	-- body
	local item  = self.exp[tostring(lv)]
	if item then 
		return item.dec   
	else
		self:Error(lv)
		return nil
	end	
end
--vip 描述
function RechargeConf:getDec_2( lv )
	-- body
	local item  = self.exp[tostring(lv)]
	if item then 
		return item.dec_2   
	else
		self:Error(lv)
		return nil
	end	
end
--
function RechargeConf:getReward( lv )
	-- body
	local item  = self.exp[tostring(lv)]
	if item then 
		return item.reward   
	else
		self:Error(lv)
		return nil
	end	
end

--获取有几个VIP 等级等级
function RechargeConf:getVipcount( )
	-- body
	local count = 0
	for i = 1 , 100 do 
		if self.exp[tostring(i)] then 
			count = count + 1
		else
			break
		end	
	end	
	return count
end

return RechargeConf