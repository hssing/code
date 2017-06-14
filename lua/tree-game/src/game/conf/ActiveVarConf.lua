--
-- Author: Your Name
-- Date: 2015-11-13 11:45:38
--
local ActiveVarConf = class("ActiveVarConf", base.BaseConf)

function ActiveVarConf:init( )

	local data = require("res.conf.special_active_var")
	self.conf = {}
	for k,v in pairs(data) do
		self.conf[v.name] = v
	end
	
end


function ActiveVarConf:getValueByName( name )
	if self.conf[name] == nil then
		debugprint("限时活动表没有【" .. name .. "】的配置")
		return
	end

	return self.conf[name]["value"]
end

function ActiveVarConf:getAllDatabyName( name )
	if self.conf[name] == nil then
		debugprint("限时活动表没有【" .. name .. "】的配置")
		return
	end

	return self.conf[name]
end





return ActiveVarConf