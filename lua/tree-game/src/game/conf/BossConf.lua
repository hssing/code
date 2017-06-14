--BossConf

local BossConf = class("BossConf",base.BaseConf)

function BossConf:init()
	-- body
	self.conf = require("res.conf.worldboss_rank")
	self.conf_other = require("res.conf.worldboss_common")

	
end

function BossConf:getOtherItem( id )
	-- body
	return self.conf_other[id..""]
end

function BossConf:getRankitem(id)
	-- body
	return self.conf[id..""]
end

return BossConf