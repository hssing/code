

local LuckyLotteryProxy = class("LuckyLotteryProxy",base.BaseProxy)

function LuckyLotteryProxy:init()
	self:add(516156 ,self.keepDataInfo)
	self:add(516157 ,self.onResponseMyLottery)
	self:add(516158 ,self.onResponseLotteryRank)
	self:add(516159 ,self.add_516159)
end


function LuckyLotteryProxy:keepDataInfo(data_)
	-- body
	if data_.status == 0  then
		cache.LuckyLottery:keepData(data_)
		local view = mgr.ViewMgr:get(_viewname.AWARDRANK)
		if view then
			view:setData()
		else
			view= mgr.ViewMgr:showView(_viewname.AWARDRANK)
			view:setData(data_)
		end
	else
		G_TipsError(data_.status)
	end
end


function LuckyLotteryProxy:sendMessage()
	-- body
    self:send(116156)
    self:wait(516156)
end

function LuckyLotteryProxy:onRequestMyLottery(PageNum)
	-- 请求我的彩票
    local __reqdata = {}
    if PageNum == nil or PageNum == 0 then
    	__reqdata.pageNum = 1
    else
    	__reqdata.pageNum = PageNum
    end
    self.page = __reqdata
    self:send(116157,__reqdata)
end


function LuckyLotteryProxy:onResponseMyLottery(data_)
	-- 响应我的彩票请求
	if data_.status == 0  then
		--[[cache.LuckyLottery:setMyLotteryData(data_)
		local view = mgr.ViewMgr:get(_viewname.AWARDRANK)
		if view then 
			view:set_516157(data_)
		end]]--
		local view = mgr.ViewMgr:get(_viewname.AWARD_PAGE)
		if view then 
			view:setData(data_,0)
		else
			view = mgr.ViewMgr:showView(_viewname.AWARD_PAGE)
			view:setData(data_,0)
		end
	else
		G_TipsError(data_.status)
	end
end

function LuckyLotteryProxy:onRequestLotteryRank()
	-- 请求中奖榜单
    self:send(116158)
    self:wait(516158)
end

function LuckyLotteryProxy:onResponseLotteryRank(data_)
	-- 响应中奖榜单请求
	if data_.status == 0  then
		local view = mgr.ViewMgr:get(_viewname.MAINLOTTERY)
		if view then 
			view:setData(data_)
		else
			view = mgr.ViewMgr:showView(_viewname.MAINLOTTERY)
			view:setData(data_)
		end
		--[[cache.LuckyLottery:setLotteryRankData(data_)
		local view = mgr.ViewMgr:get(_viewname.AWARDRANK)
		if view then
			view:set_516158(data_)
		end]]--
	else
		G_TipsError(data_.status)
	end
end

--[[function LuckyLotteryProxy:onRequestPreLotteryRank()
	-- 请求中奖榜单
	local __reqdata = {
    	pageNum = 1,
    }
    self:send(116159,__reqdata)
end

function LuckyLotteryProxy:onResponsePreLotteryRank(data_)
	-- 幸运彩票我的上期彩票
	if data_.status == 0  then
		cache.LuckyLottery:setPreLotteryRankData(data_)
		local view = mgr.ViewMgr:get(_viewname.AWARDRANK)
		if view then 
			view:set_516159(data_)
		end
	else
		G_TipsError(data_.status)
	end
end]]--

function LuckyLotteryProxy:send_116159(param)
	-- body
	printt(param)
	self.page = param
	self:send(116159,param)
end

function LuckyLotteryProxy:add_516159( data_ )
	-- body
	if data_.status == 0  then
		local view = mgr.ViewMgr:get(_viewname.AWARD_PAGE)
		if view then 
			view:setData(data_,1)
		else
			view = mgr.ViewMgr:showView(_viewname.AWARD_PAGE)
			view:setData(data_,1)
		end
	else
		G_TipsError(data_.status)
	end
end

return LuckyLotteryProxy