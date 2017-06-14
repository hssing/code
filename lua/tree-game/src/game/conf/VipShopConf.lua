--
-- Author: chenlu_y
-- Date: 2015-12-08 21:50:06
--

local VipShopConf=class("VipShopConf",base.BaseConf)

function VipShopConf:init()
	self.conf=require("res.conf.vip_shop")
end

function VipShopConf:getConfig()
	return self.conf
end

function VipShopConf:getInfo(lv , day )
	if day < 10 then
		day = "0"..day
	end
	local newKey = lv .. ""..day
	local info=self.conf[newKey]

	if info then 
		return info
	else
		self:Error(newKey)
	end 
	return nil
end

return VipShopConf

