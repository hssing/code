

local activeCache = class("activeCache",base.BaseCache)

function activeCache:init()
	-- body
	self.data = {}
end

function activeCache:keepData(data_)
	-- body
	self.data = data_
end

function activeCache:isKey(id)
	-- body
	if not id then 
		debugprint("没有id")
		return false
	end
	if tonumber(self.data.acts[tostring(id)]) == 2 then --活动关闭
		return false
	end

	return true
end

return activeCache