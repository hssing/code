--
-- Author: Your Name
-- Date: 2015-11-11 00:59:34
--

local RichRankProxy = class("RichRankProxy", base.BaseProxy)

function RichRankProxy:init( ... )
	--全民土豪
	self:add(516081,self.reqRankInfoCallback)
	self:add(516082,self.reqPraiseCallback)

	--砸金蛋
	self:add(516091,self.reqHitEgginfoCallback)
	self:add(516092,self.reqHitEggCallback)


	--进化神殿
	self:add(516101,self.reqJHSDInfoCallback)
	self:add(516102,self.reqJHSDBuyCallback)


	--公会挣榜
	self:add(516103,self.reqGuildRankCallback)


	--累计充值
	self:add(516132,self.reqOpenChargeCountInfoCallback)

	--单笔充值
	self:add(516131,self.reqChareSingleInfoCallback)

	--领取充值奖励
	self:add(516133,self.reqGetChargeAwardCallback)

	---运营活动签到
	self:add(516134,self.SignCallBack)
	self:add(516135,self.SingGetCallBack)

	--转盘抽奖
	self:add(516138,self.ChouMsgCallBack)
	self:add(516139,self.ChouRewardCallBack)


	
end






--请求排名信息
function RichRankProxy:reqRankInfo( )
	-- body
	self:send(116081)
	self:wait(516081)
end

function RichRankProxy:reqRankInfoCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.RICHRANK)
		if view then
			view:setData(data)
		end
	end
end



--请求点赞
function RichRankProxy:reqPraise( idx )
	self:send(116082,{index = idx})
end


function RichRankProxy:reqPraiseCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.RICHRANK)
		if view then
			view:praiseSucc(data)
		end
	elseif data.status == 21070025 then
		G_TipsOfstr(res.str.RICH_RANK_DESC30)
	elseif data.status == 21070028 then
		G_TipsOfstr(res.str.RICH_RANK_DESC41)
	else
		G_TipsError(data.status)
	end
end








---请求砸金蛋信息
function RichRankProxy:reqHitEgginfo( )
	-- body
	self:send(116091)
	self:wait(516091)
end

function RichRankProxy:reqHitEgginfoCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.HITEGG)
		if view then
			view:setData(data)
		end
	end
end



---请求砸金蛋
function RichRankProxy:reqHitEgg( atype )
	-- body
	self:send(116092,{dztype = atype})
end

function RichRankProxy:reqHitEggCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.HITEGG)
		if view then
			view:hitEggSucc(data)
		end

	elseif data.status == -1 then
		G_TipsOfstr(res.str.RICH_RANK_DESC35)
	elseif data.status == 21070026 then
		G_TipsOfstr(res.str.RICH_RANK_DESC31)
	end
end







---请求进化神殿信息
function RichRankProxy:reqJHSDInfo( )
	-- body
	self:send(116101)
	self:wait(516101)
end

function RichRankProxy:reqJHSDInfoCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.PALACE)
		if view then
			view:setGiftInfo(data)
		end
	end
end

--请求进化神殿购买
function RichRankProxy:reqJHSDBuy( bId,count )
	-- body
	self:send(116102,{buyId = bId,buyCount = count})
	self:wait(516102)
end

function RichRankProxy:reqJHSDBuyCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.PALACE)
		if view then
			view:buySucc(data)
		end
	elseif data.status == 21070027 then
		G_TipsOfstr(res.str.RICH_RANK_DESC33)
	elseif data.status == -1 then
		G_TipsOfstr(res.str.RICH_RANK_DESC35)
	end
end








--请求公会争榜
function RichRankProxy:reqGuildRank(  )
	-- body
	self:send(116103)
	self:wait(516103)
end

function RichRankProxy:reqGuildRankCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.CMPRANK)
		if view then
			view:setGiftInfo(data)
		end
	end
end



--活动2 累计充值
function RichRankProxy:reqOpenChargeCountInfo(  )
	self:send(116132)
	self:wait(516132)
end

function RichRankProxy:reqOpenChargeCountInfoCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.ACT2CHARGECOUNT)
		if view then
			view:setGiftInfo(data)
		end
	end
end

--活动2 充值领取奖励
function RichRankProxy:reqGetChargeAward( atype, index)
	local data = {}
	data.atype = atype
	data.index = index
	self:send(116133,data)
	self:wait(516133)
end

function RichRankProxy:reqGetChargeAwardCallback( data )
	if data.status == 0 then
		local alertView = mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		if alertView then
			alertView:setData(data["items"],true,true)
			alertView:setButtonVisible(false)
			alertView:setSureBtnTile(res.str.HSUI_DESC12)
		end

		--1每日单笔,2累计充值,)
		if data.atype == 2 then
			local view = mgr.ViewMgr:get(_viewname.ACT2CHARGESINGLE)
			if view then
				view:getAwardSucc(data)
				debugprint("领取每日充值奖励成功")
			end
			--cache.Player:_setMeiRiNumber(cache.Player:getMeiRiNumber() - 1)

		elseif data.atype == 3 then
			local view = mgr.ViewMgr:get(_viewname.ACT2CHARGECOUNT)
			if view then
				view:getAwardSucc(data)
				debugprint("领取充值反馈奖励成功")
			end
			--cache.Player:_setDanCNumber(cache.Player:getDanCNumber() - 1)
	
		end

		--设置活动2 红点
		cache.Player:_setRichRankNumber(cache.Player:getRichRankNumber() - 1)
	end
end




--活动2 单笔充值
function RichRankProxy:reqChareSingleInfo(  )
	self:send(116131)
	self:wait(516131)
end

function RichRankProxy:reqChareSingleInfoCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.ACT2CHARGESINGLE)
		if view then
			view:setGiftInfo(data)
		end
	end
end


---活动2 运营签到
--签到信息
function RichRankProxy:send116134()
	-- body
	self:send(116134)
	self:wait(516134)
end

function RichRankProxy:SignCallBack( data_ )
	-- body
	if data_.status == 0 then 
		
		local view  = mgr.ViewMgr:get(_viewname.ACT2SIGN)
		if view then 
			view:setData(data_)
		end
	
	else
		debugprint("签到信息")
	end
end

--请求签到
function RichRankProxy:send116135()
	-- body
	self:send(116135)
	self:wait(516135)
end

function RichRankProxy:SingGetCallBack(data_ )
	-- body
	if data_.status == 0 then 
		local count =   cache.Player:get11Redpoint()-1
		if count < 0 then 
			count = 0
		end
		cache.Player:_setRichRankNumber(cache.Player:getRichRankNumber() - 1)

		local _view = mgr.ViewMgr:get(_viewname.MAIN)
		if _view then
			_view:setRedPoint()
		end

		
		local view  = mgr.ViewMgr:get(_viewname.ACT2SIGN)
		if view then 
			view:updateinfo(data_)
		end
	elseif data_.status ==21030001 then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	elseif data_.status == -1 then
		G_TipsOfstr(res.str.ACT2_SIGN_DESC3)
	end
end



--转盘抽奖
function RichRankProxy:send116138()
	-- body
	self:send(116138)
	self:wait(516138)
end

function RichRankProxy:ChouMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		local view  = mgr.ViewMgr:get(_viewname.ACT2LUCKY)
		if view then 
			view:setData(data_)
		end
	else
		debugprint("抽奖信息")
	end
end


function RichRankProxy:send116139( playType)
	-- body
	self:send(116139,{playType = playType })
	self:wait(516139)
end

function RichRankProxy:ChouRewardCallBack( data_ )
	-- body
	if data_.status == 0 then 
		local view  = mgr.ViewMgr:get(_viewname.ACT2LUCKY)
		if view then 
			view:updateinfo(data_)
		end
	elseif data_.status ==21030001 then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	else
		debugprint("抽奖信息")
	end
end



return RichRankProxy