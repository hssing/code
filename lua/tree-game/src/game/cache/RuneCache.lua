--[[
	符文信息
]]

local RuneCache = class("RuneCache", base.BaseCache)

function RuneCache:init()
	-- body
	--
	self.useinfo = {} --穿戴信息
	self.packdata = {}  --背包信息
end
--存储信息
function RuneCache:setInfo(data_)
	-- body
	for k ,v in pairs(data_.fwUsedInfo) do 
		--v.propertys = vector2table(v.propertys,"type")
		--local dd = clone(v)
		v.propertys = vector2table(v.propertys, "type")
		table.insert(self.useinfo,v)
	end
	for k ,v in pairs(data_.fwPackInfo) do 
		v.propertys = vector2table(v.propertys, "type")
		table.insert(self.packdata,v)
	end
	--printt(self.packdata)
	--self.packdata = data_.fwPackInfo
end

function RuneCache:getUseinfoVec()
	-- body
	local data = self:getUseinfo()
	local wearRune = {}

	for k ,v in pairs(data) do 
		local card_pos = tonumber(string.sub(v.index,3,3))--数码兽 上阵位置 
		local part = tonumber(string.sub(v.index,-1,-1)) --符文的放置位置
		if not wearRune[card_pos] then
			wearRune[card_pos] ={}
		end
		if wearRune[card_pos][part] then
			wearRune[card_pos][part] = {}
		end
		wearRune[card_pos][part] = v 
	end 
	
	return wearRune
end

--获取穿戴信息
function RuneCache:getUseinfo()
	-- body
	return self.useinfo
end

function RuneCache:removeUseInfo( data )
	-- body
	if not data or not self.useinfo then
		return 
	end

	for k,v in pairs(self.useinfo) do 
		if v.index == data.index then
			table.remove(self.useinfo,k)
			return 
		end
	end
end

function RuneCache:addUseInfo( data )
	-- body
	if not data  then
		return 
	end

	data.propertys = vector2table(data.propertys,"type")
	if not self.useinfo then 
		self.useinfo = {}
	end

	local f = true
	for k ,v in pairs(self.useinfo) do 
		if v.index == data.index then
			self.useinfo[k] = data
			f = false
			break
		end 
	end



	if f then 
		table.insert(self.useinfo,data)
	end
end


--获取背包信息
function RuneCache:getPackinfo()
	-- body
	return self.packdata 
end

function RuneCache:removepackInfo( data )
	-- body
	if not data or not self.packdata then
		return 
	end

	for k,v in pairs(self.packdata) do 
		if v.index == data.index then
			table.remove(self.packdata,k)
			return 
		end
	end
end

function RuneCache:addpackInfo( data )
	-- body
	if not data  then
		return 
	end
	data.propertys = vector2table(data.propertys,"type")
	if not self.packdata then 
		self.packdata = {}
	end

	local f = true
	for k ,v in pairs(self.packdata) do 
		if v.index == data.index then
			self.packdata[k] = data
			f = false
			break
		end 
	end

	if f then 
		--print("符文调价")
		table.insert(self.packdata,data)
	end
end



return RuneCache