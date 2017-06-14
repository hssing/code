local DigConf = class("DigConf",base.BaseConf)

function DigConf:init( ... )
	-- body
	self.conf = require("res.conf.wakuang_events")
end

function DigConf:getItem(id)
	-- body
	return self.conf[tostring(id)]
end

function DigConf:getContentstr( id )
	-- body
	return self.conf[tostring(id)].content_str
end

return DigConf