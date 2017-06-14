--

--[[	
	跨服战
]]

local CrossConf = class("CrossConf", base.BaseConf) 

function CrossConf:init()
	-- body
	self.sh_conf = require("res.conf.shlm_conf")
	self.dh_conf = require("res.conf.shlm_dh")

	self.reward_conf = require("res.conf.cross_reward")
	self.dw_conf = require("res.conf.cross_duanwei")

	self.cai_conf = require("res.conf.cross_jingcai")
	
end

function CrossConf:getCaiItem( id )
	-- body
	return self.cai_conf[tostring(id)]
end

function CrossConf:getSh_Item( id )
	-- body
	return self.sh_conf[tostring(id)]
end

function CrossConf:getAllItem()
	-- body
	return table.values(self.dh_conf)
end

function CrossConf:getAllItemaward()
	-- body
	return table.values(self.reward_conf)
end
------------段位配置
function CrossConf:getDwItem(id)
	-- body
	return self.dw_conf[tostring(id)]
end

return CrossConf