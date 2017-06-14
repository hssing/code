--
-- Author: Your Name
-- Date: 2015-10-24 15:57:53
--
local InvitateConf = class("InvitateConf", base.BaseConf)

function InvitateConf:init(  )
	-- body
	local data = require("res.conf.mail_template")
	self.conf = {}
	for i=100203,100206 do
		table.insert(self.conf, data[i..""])
	end
end

function InvitateConf:getData(  )
	return self.conf
end


return InvitateConf