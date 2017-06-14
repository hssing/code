--[[
	符文升级
]]
local RuneConf = class("RuneConf",base.BaseConf)

function RuneConf:init( )
	-- body
	self.conf=require("res.conf.fuwen_up")
end

function RuneConf:getItem(id)
	-- body
	return self.conf[tostring(id)]
end

return RuneConf