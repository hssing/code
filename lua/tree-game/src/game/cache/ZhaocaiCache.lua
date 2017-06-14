--ZhaocaiCache
--[[
	招财信息
]]

local ZhaocaiCache = class("ZhaocaiCache",base.BaseCache)

function ZhaocaiCache:init()
	-- body
	self.data = {} 

	self.data.zCount =0-- 剩余次数
	self.data.maxCount =0-- 最大次数
end

function ZhaocaiCache:keepInfo(data)
	-- body
	self.data = data
end
--更新剩余次数
function ZhaocaiCache:updatezCount( data )
	-- body
	self.data.zCount = data

end

function ZhaocaiCache:getData()
	-- body
	return self.data
end


return ZhaocaiCache