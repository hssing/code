--
-- Author: Your Name
-- Date: 2015-11-13 11:45:38
--
local OpenActVarConf = class("OpenActVarConf", base.BaseConf)

function OpenActVarConf:init( )

	local data = require("res.conf.open_act_var")
	self.conf = {}
	for k,v in pairs(data) do
		self.conf[v.name] = v
	end
	
end


function OpenActVarConf:getValueByName( name )
	if self.conf[name] == nil then
		debugprint("开服活动表没有【" .. name .. "】的配置")
		return
	end

	return self.conf[name]["value"]
end

function OpenActVarConf:getAllDatabyName( name )
	if self.conf[name] == nil then
		debugprint("开服活动表没有【" .. name .. "】的配置")
		return
	end

	return self.conf[name]
end





return OpenActVarConf