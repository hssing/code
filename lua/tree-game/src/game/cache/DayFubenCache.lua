
local DayFubenCache = class("DayFubenCache", base.BaseCache)

function DayFubenCache:init()
	-- body
	self.data = {}
end

function DayFubenCache:keepData(data)
	-- body
	self.data = data
end

function DayFubenCache:setplayCount(id, value )
	-- body
	for k ,v in pairs(self.data.openFuben) do 
		if v.fbType == id then
			v.playCount = value
		end
	end
end

function DayFubenCache:setVipBuyCount(fid,value)
	-- body
	for k ,v in pairs(self.data.openFuben) do 
		if v.fbType == fid then
			v.vipBuyCount = value
		end
	end
end

function DayFubenCache:getData()
	-- body
	return self.data
end

--当前打开那个
function DayFubenCache:getCurPage()
	-- body
	return self.page 
end

function DayFubenCache:keepPage(value)
	-- body
	self.page = value
end

return DayFubenCache