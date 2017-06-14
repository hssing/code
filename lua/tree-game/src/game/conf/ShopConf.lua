
local ShopConf = class("ShopConf",base.BaseConf)

function ShopConf:init()
	-- body
	self.conf = require("res.conf.shop_global")

	self.conf_shp_hy = require("res.conf.shop_hy_item")
	
end

function ShopConf:getValue(id)
	-- body
	return self.conf[id..""]
end

function ShopConf:getHyShopItem(id)
	-- body
	return self.conf_shp_hy[id..""]
end

return ShopConf