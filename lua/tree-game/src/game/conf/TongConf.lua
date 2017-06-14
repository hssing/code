

local TongConf = class("TongConf",base.BaseConf)

function TongConf:init()
	-- body
	self.conf = require("res.conf.common_fuben")
end

function TongConf:getItemMsg(id)
	-- body

	local achieve=self.conf[tostring(id)]

	if not achieve then 
		self:Error(id)
		return nil
	end
	return achieve

end

return TongConf