
local OpenConf=class("OpenConf",base.BaseConf)

function OpenConf:init(  )
    self.conf=require("res.conf.g_open")
end



function OpenConf:getLockLv( id)
	local open=self.conf[tostring(id)]
	if open then
		return open.lock_lv
	else
		self:Error(id)
	end
	return 5000
end

return OpenConf
