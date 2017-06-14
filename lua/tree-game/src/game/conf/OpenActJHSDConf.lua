--
-- Author: Your Name
-- Date: 2015-11-20 21:34:21
--
local OpenActJHSDConf = class("OpenActJHSDConf", base.BaseConf)

function OpenActJHSDConf:init( ... )
	-- body
	local data = require("res.conf.open_act_jhsd")
	self.conf = {}
	for k,v in pairs(data) do
		table.insert(self.conf,v)
	end

	for i=1,#self.conf - 1 do
		for j=i + 1,#self.conf do
			if self.conf[i].id > self.conf[j].id then
				self.conf[i] , self.conf[j] = self.conf[j] , self.conf[i]
			end
		end
	end
	
end

function OpenActJHSDConf:getData( ... )
	-- body
	local data = {}
	for i,v in ipairs(self.conf) do
		if type(v) == "table" then
			local tmp = {}
			for j,v2 in pairs(v) do
				tmp[j] = v2
			end
			data[i] = tmp
		else
			data[i] = v
		end
	end


	return data
end










return OpenActJHSDConf