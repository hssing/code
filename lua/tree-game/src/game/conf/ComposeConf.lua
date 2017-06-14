
--[[
--合成
]]
local ComposeConf=class("ComposeConf",base.BaseConf)

function ComposeConf:init()
	-- body
	self.conf = require("res.conf.card_equip_jiangxing")
end

function ComposeConf:getItemUse(id)
	-- body
	return self.conf[tostring(id)].money_zs
end

return ComposeConf