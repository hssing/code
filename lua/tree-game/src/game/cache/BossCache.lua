--[[
	BossCache 世界boss
]]

local BossCache = class("BossCache",base.BaseCache)

function BossCache:init()
	-- body
	self.data = {}
end

function BossCache:setData(data)
	-- body
	self.data = data 
end

function BossCache:getData()
	-- body
	return self.data
end
--是 制动参战
function BossCache:setAutoBattle( value )
	-- body
	if self.data.isAutoBattle then
		self.data.isAutoBattle = value
	end
end
--血量百分比 ， 复活时间
function BossCache:setBossValue( data )
	-- body
	if data.curHpPercent then
		self.data.curHpPercent = data.curHpPercent
	end

	if data.rebornTime then
		self.data.rebornTime = data.rebornTime
	end
end
--血量百分比 
function BossCache:getCurHpPercent()
	-- body
	return self.data.curHpPercent
end
--鼓舞
function BossCache:setInspireValue( value )
	-- body
	if not self.data.inspireValue then
		return
	end
	self.data.inspireValue = value
end


function BossCache:getInspirePercent( ... )
	-- body
	return self.data.inspirePercent
end

--复活时间
function BossCache:getRebornTime()
	-- body
	return checkint(self.data.rebornTime)
end
--活动开始时间
function BossCache:getRemainTime()
	-- body
	return checkint(self.data.remainTime)
end

return BossCache