

local GuizeConf = class("GuizeConf",base.BaseConf)

function GuizeConf:init( ... )
	-- body
	self.conf = require("res.conf.guize")
end

function GuizeConf:getTextById(id)
	-- body
	local conf = self.conf[tostring(id)]

	if not conf then 
		debugprint("需要配置规则")
		return 
	end 
	return conf.text
end


return GuizeConf