local HeadConf = class("HeadConf",base.BaseConf)
local path = "res/views/ui_res/icon/"


function HeadConf:init( )
	-- body
	self.conf = {}
	local data = require("res.conf.head")
	for k,v in pairs(data) do
		self.conf[#self.conf + 1] = v
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


	self.data = data
end

function HeadConf:getData()
	return self.conf
end


function HeadConf:getDataBySex( sex )
	local data = {}
	for k,v in pairs(self.conf) do
		if v.sex == sex then
			table.insert(data, v)
		end
	end

	return data
end

function HeadConf:getIcon( id )
	for k,v in pairs(self.conf) do
		if v.id == id then
			return path .. v.src .. ".png"
		end
	end
end

function HeadConf:getItem(id)
	-- body
	return self.data[tostring(id)]
end


return HeadConf


















-- function headConf:init()
-- 	-- body
-- 	self.conf=require("res.conf.head")
-- end

-- --返回能选择的所有头像
-- function headConf:getItems(sex)
-- 	-- body
-- 	local t = {}
-- 	for k , v in pairs(self.conf) do 
-- 		if v.sex == sex  then 
-- 			table.insert(t,v)
-- 		end 
-- 	end 
-- 	return t 
-- end

-- --获得默认头像
-- function headConf:getHeadIcon( sex )
-- 	local t = self:getItems(sex)
-- 	for k,v in pairs(t) do
-- 		if v.isGet == 1 then
-- 			return v.src
-- 		end
-- 	end

-- 	print("没有默认头像，选择第一个")
-- 	return t[1].src
-- end

-- --根据 id 来获取头像
-- function headConf:getHeadIconById( id )
-- 	local item = self.conf[id .. ""]
-- 	if item then
-- 		return item.src
-- 	else
-- 		print("没有ID为%d头像",id)	
-- 	end
-- end



-- return headConf