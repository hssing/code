--
-- Author: Your Name
-- Date: 2015-09-11 15:03:11
--

local path = "res/views/ui_res/imagefont/"

local TitleConf = class("TitleConf", base.BaseConf)

function TitleConf:init( )
	-- body
	self.conf = {}
	local data = require("res.conf.title_config")
	for k,v in pairs(data) do
		self.conf[#self.conf + 1] = v
		v.isGet = 3
	end

	--dump(self.conf)

	--排序
	for i = 1,#self.conf - 1 do
		for j = i + 1,#self.conf do
			if self.conf[i]["sort"] > self.conf[j]["sort"] then
				local tmp = self.conf[i]
				self.conf[i] = self.conf[j]
				self.conf[j] = tmp
			end
		end
	end

end


function TitleConf:getData(  )
	return self.conf
end

function TitleConf:getIcon( id )
	for k,v in pairs(self.conf) do
		if v.id == id then
			return path .. v.icon .. ".png"
		end
	end
end


-- function TitleConf:getDesc( id )
-- 	if type(id) == "number" then
-- 		return self.conf[tostring(id)]["desc"]
-- 	end

-- 	return self.conf[id]["desc"]
	
-- end




return TitleConf