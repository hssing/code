--[[
]]
local zhaocaiConf=class("zhaocaiConf",base.BaseConf)

function zhaocaiConf:init()
	-- body
	self.conf=require("res.conf.zhaocai_count")
end

function zhaocaiConf:getJb( lv )
	-- body
	local zhaocai=self.conf[tostring(lv)]

	if zhaocai and zhaocai.reward_jb then 
		return zhaocai.reward_jb
	else
		self:Error(lv)
	end 
	return 0
end

return zhaocaiConf

