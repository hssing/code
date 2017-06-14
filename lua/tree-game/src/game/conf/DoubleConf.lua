--[[
	--双11活动
]]

local DoubleConf = class("DoubleConf", base.BaseConf)

function DoubleConf:init()
	-- body
	self.conf_recharge = require("res.conf.doubleElevenRecharge")
	self.conf_sign = require("res.conf.double_sign")
	self.conf_chou = require("res.conf.double_chou")
end
---累计充值活动
function DoubleConf:getDoubleRecharge(id)
	-- body
	return table.values(self.conf_recharge)
	--return self.conf_recharge[tostring(id)]
end
--签到奖励
function DoubleConf:getSignReward()
	-- body
	return self.conf_sign["1"].signConf
end
--抽奖活动
function DoubleConf:getChouRewad()
	-- body
	return self.conf_chou["1"].lotteryConf
end

return DoubleConf