--
-- Author: Your Name
-- Date: 2015-11-20 17:46:52
--
local OpenActProxy = class("OpenActProxy", base.BaseProxy)


function OpenActProxy:init(  )
		--全民土豪
	self:add(516111,self.reqRankInfoCallback)
	self:add(516112,self.reqPraiseCallback)

	--土豪昨日排行
	self:add(516113,self.yesterdayRankCallback)

	--进化神殿
	self:add(516121,self.reqJHSDInfoCallback)
	self:add(516122,self.reqJHSDBuyCallback)

end


--请求排名信息
function OpenActProxy:reqRankInfo( )
	-- body
	self:send(116111)
	self:wait(516111)
end

function OpenActProxy:reqRankInfoCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.OPENACTPRAISE)
		if view then
			view:setData(data)
		end


		cache.Player:_setOpenActPraiseNumber(data.todayZan)
		--设置红点
		local view = mgr.ViewMgr:get(_viewname.ACTIVITY)
		if view then
			view:setRedPoint()
		end

		local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
		if view then
			view:setRedPoint()
		end
	end
end



--请求点赞
function OpenActProxy:reqPraise( idx )
	self:send(116112,{index = idx})
end


function OpenActProxy:reqPraiseCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.OPENACTPRAISE)
		if view then
			view:praiseSucc(data)
		end

		cache.Player:_setOpenActPraiseNumber(data.todayZan)
		--设置红点
		local view = mgr.ViewMgr:get(_viewname.ACTIVITY)
		if view then
			view:setRedPoint()
		end

		local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
		if view then
			view:setRedPoint()
		end

	elseif data.status == 21070025 then
		G_TipsOfstr(res.str.RICH_RANK_DESC30)
	elseif data.status == 21070028 then
		G_TipsOfstr(res.str.RICH_RANK_DESC41)
	elseif data.status == 21070029 then
		G_TipsOfstr(res.str.OPEN_ACT_PRAISE_DESC1)
	end
end


--昨日排行
function OpenActProxy:reqYesterdayRank(  )
	self:send(116113)
	self:wait(516113)
end

function OpenActProxy:yesterdayRankCallback(data)
	if data.status == 0 then

		--如果是开服第一天，昨日排行列表为空
		if table.nums(data.preList) <= 0 then
			G_TipsOfstr(res.str.OPEN_ACT_PRAISE_DESC7)
			return
		end


		local view = mgr.ViewMgr:showView(_viewname.OPEN_YESTERDAY_RANK)
		if view then
			view:setData(data)
		end
	end
end





---请求进化神殿信息
function OpenActProxy:reqJHSDInfo( )
	-- body
	self:send(116121)
	self:wait(516121)
end

function OpenActProxy:reqJHSDInfoCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.OPENACTPALACE)
		if view then
			view:setGiftInfo(data)
		end
	end
end

--请求进化神殿购买
function OpenActProxy:reqJHSDBuy( bId,count )
	-- body
	self:send(116122,{buyId = bId,buyCount = count})
	self:wait(516122)
end

function OpenActProxy:reqJHSDBuyCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.OPENACTPALACE)
		if view then
			view:buySucc(data)
		end
	elseif data.status == 21070027 then
		G_TipsOfstr(res.str.RICH_RANK_DESC33)
	elseif data.status == -1 then
		G_TipsOfstr(res.str.RICH_RANK_DESC35)
	end
end





return OpenActProxy