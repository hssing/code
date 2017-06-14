local LuckyLotteryCache = class("LuckyLotteryCache",base.BaseCache)

function LuckyLotteryCache:init()
	-- body
	self.data = {}
	self.MyLotteryData = {}
	self.LotteryRankData = {}
	self.PreLotteryRankData = {}
end

function LuckyLotteryCache:keepData(data_)
	-- body
	self.data = data_
end

function LuckyLotteryCache:setMyLotteryData(data_)
	-- body
	self.MyLotteryData[data_.pageNum] = data_
end

function LuckyLotteryCache:setLotteryRankData(data_)
	-- body
	self.LotteryRankData = data_
end

function LuckyLotteryCache:setPreLotteryRankData(data_)
	-- body
	self.PreLotteryRankData = data_
end

function LuckyLotteryCache:isKey(id)
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

function LuckyLotteryCache:getDataInfo(  )
	-- body
	return self.data
end

function LuckyLotteryCache:getMyLotteryData( PageNum )
	-- body
	return self.MyLotteryData[PageNum]
end

function LuckyLotteryCache:getLotteryRankData(  )
	-- body
	return self.LotteryRankData
end

function LuckyLotteryCache:getPreLotteryRankData(  )
	-- body
	return self.PreLotteryRankData
end


return LuckyLotteryCache