--[[--
  抽奖信息
]]
local LuckydrawCache = class("LuckydrawCache",base.BaseCache)


function LuckydrawCache:init(  )
	-- body
	self.DataInfo={}
	self._recordTime = os.time()
end

function LuckydrawCache:setDatainfo(data_ )
	-- body
	self.DataInfo = data_
	self._recordTime = os.time()
end

function LuckydrawCache:getRecordTime(  )
	-- body
	return self._recordTime
end

function LuckydrawCache:getlastTime(  )
	-- body
	return self.DataInfo.lastTime
end

function LuckydrawCache:getDataInfo( ... )
	-- body
	return self.DataInfo;
end


return LuckydrawCache



