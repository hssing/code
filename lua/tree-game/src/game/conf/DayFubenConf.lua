
local DayFubenConf = class("DayFubenConf",base.BaseConf)

function DayFubenConf:init()
	-- body
	self.conf = require("res.conf.daily_fb_conf")
	self.conf_reward = require("res.conf.daily_fuben")
end

function DayFubenConf:getListAll()
	-- body
	return table.values(self.conf ) 
end

function DayFubenConf:getMap(id)
	-- body
	print(id)
	return self.conf[tostring(id)].mapid
end

function DayFubenConf:getRewad(id)
	-- body
	return self.conf_reward[tostring(id)]
end

return DayFubenConf