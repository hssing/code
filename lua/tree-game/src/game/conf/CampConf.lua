

local CampConf = class("CampConf", base.BaseConf)

function CampConf:init()
	-- body
	self.conf= require("res.conf.camp_events")
	self.camp_awards = require("res.conf.camp_awards")
end

function CampConf:getItem( id )
	-- body
	return self.conf[tostring(id)].content_str
end

function CampConf:getReward( id )
	-- body
	return self.camp_awards[tostring(id)] 
end

return CampConf