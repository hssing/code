--[[
邮件信息
]]

local MailCache = class("MailCache",base.BaseCache)

function MailCache:init( )
	-- body
	self.DataInfo = {}
	self.typeInfo = {}
	self.maxPage = {}
	self.counts = {}
end

local function iskey_value(key,value,ptab)
	-- body
	for k , v  in pairs(ptab) do 
		if k == key and v ==  value then 
			return true
		end 
	end 
	return false
end

local function isequals(pdata,mailId)
	-- body
	for k ,v in pairs(pdata) do 
		if not iskey_value(k,v,mailId) then 
			return false
		end 
	end 
	return true
end

function MailCache:getMaxpagebYtype(type )
	-- body
	return self.maxPage["type"..type] 
end

function MailCache:_isExist(key,ptype)
	-- body
	for k ,v in pairs(self.typeInfo[tostring(ptype)]) do 
		if isequals(v.mailId,key) then 
			return true
		end 
	end 
	return false
end

function MailCache:setDataInfo(data_,flag,ptype )
	-- body
	self.maxPage["type"..ptype] = data_.maxPage
	self.counts = data_.counts
	if flag == 1 then 
		self.typeInfo[tostring(ptype)] = {}
		self.typeInfo[tostring(ptype)] = data_.mailInfos

		return 
	end 

	print("不是第一次请求")

	for k , v in pairs(data_.mailInfos) do 
		if not self:_isExist(v.mailId,ptype) then 
			table.insert(self.typeInfo[tostring(ptype)],v)
		end 
	end 
end


function MailCache:update(data_,mailId,pmState)
	-- body
	self.counts = data_.counts
	if mailId == -1 then
		if pmState == 997 then
			if self.typeInfo[tostring(1)] then
				for k, v in pairs(self.typeInfo[tostring(1)]) do 
					v.mState = 1 
				end
			end
		elseif pmState == 998 then
			if self.typeInfo[tostring(2)] then
				for k, v in pairs(self.typeInfo[tostring(2)]) do 
					v.mState = 1 
				end
			end
		else
			if self.typeInfo[tostring(3)] then
				for k, v in pairs(self.typeInfo[tostring(3)]) do 
					v.mState = 7
				end
			end
		end


		return 
	end
	local item = {}
	for k ,v in pairs(self.typeInfo) do 
		for i , j  in pairs(v) do 
			if isequals(j.mailId,mailId) then
				--debugprint("原来状态 mState = "..j.mState) 
				j.mState = pmState
				item = j.items
				--debugprint("找到了对应邮件 看看怎么改变状态 ="..pmState)
				break;
			end 
		end 
	end 
	
	return item
end

function MailCache:getAllDataInfo()
	-- body
	return self.typeInfo
end

--获取信息通过类型
function MailCache:getDataByType(mtype)
	-- body
	return self.typeInfo[mtype]  and self.typeInfo[mtype] or {}
end


function MailCache:getCoutbytype(type)
	-- body
	for k ,v in pairs(self.counts) do 
		if tonumber(k) == tonumber(type) then 
			return v
		end 
	end 
	return 0
end

return MailCache