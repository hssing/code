--activeConf
local activeConf=class("activeConf",base.BaseConf)

function activeConf:init()
	-- body
	self.conf=require("res.conf.active")
	self.conf_fuben=require("res.conf.fuben_active")
	self.tthlConf = require("res.conf.act_tthl") --天天豪礼
	self.xfhlConf = require("res.conf.act_xfhl") --消费豪礼
	self.seven_cz = require("res.conf.seven_cz") --7星好礼
	self.act_diamond = require("res.conf.act_diamond")
	self.active_limit = require("res.conf.active_limit")

	self.act_red_packet = require("res.conf.act_red_packet")
end

function activeConf:getItem(id)
	-- body
	return self.act_red_packet[id..""]
end

function activeConf:getDayItem(day)
	-- body
	return self.act_diamond[day..""]
end

function activeConf:getItemByid_7x(id)
	-- body
	return self.seven_cz[tostring(id)]
end

function activeConf:getConfItem(id)
	-- body
	return self.conf[tostring(id)]
end

function activeConf:getConfLimitAcitive()
	-- body
	local t = {}
	for k ,v in pairs(self.active_limit) do 
		table.insert(t,v)
	end

	table.sort(t,function( a,b )
		-- body
		return a.sort<b.sort
	end)
	--dump(self.conf)
	return t
end

--活动 ---招财等
function activeConf:getallactive()
	-- body
	local t = {}
	for k ,v in pairs(self.conf) do 
		table.insert(t,v)
	end

	table.sort(t,function( a,b )
		-- body
		return a.sort<b.sort
	end)
	--dump(self.conf)
	return t
end

-- 竞技场等
function activeConf:getallFuben()
	-- body
	local t = {}
	for k ,v in pairs(self.conf_fuben) do 
		table.insert(t,v)
	end

	table.sort(t,function( a,b )
		-- body
		return a.sort<b.sort
	end)

	--debugprint(self.conf_fuben)
	return t
end

function activeConf:getFBOpenLevel()
	return 15
end

--获取消费豪礼
function activeConf:getXfhl()
	local data = {}
	local len = table.nums(self.xfhlConf)
	for i=1, len do
		data[i] = self.xfhlConf[i..""]
	end
	return data
end

return activeConf