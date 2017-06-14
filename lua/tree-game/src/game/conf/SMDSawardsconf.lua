--[[
	数码大赛
]]
local SMDSawardsconf = class("SMDSawardsconf", base.BaseConf)

function SMDSawardsconf:init()
	-- body
	self.award = require("res.conf.smds_awards")
	self.winner = require("res.conf.smds_winner")
	self.shop = require("res.conf.smds_shop")
	self.shopitem = require("res.conf.smds_shopitem")
end

function SMDSawardsconf:getShoplist()
	-- body
	return table.values( self.shop)
end

function SMDSawardsconf:getShopItemByShopID( ID )
	-- body
	local t = {}
	for k ,v in pairs(self.shopitem) do 
		if v.shopid == ID then 
			table.insert(t,v)
		end 
	end 
	return t 
end

function SMDSawardsconf:getShopItemById( id )
	-- body
	return self.shopitem[tostring(id)]
end

function SMDSawardsconf:getAllItemaward()
	-- body
	return table.values( self.award)
end

function SMDSawardsconf:getItemByIndex(index)
	-- body
	if not self.winner then 
		self:Error(index)
	end 
	return self.winner[tostring(index)]
end

return SMDSawardsconf