--
-- Author: Your Name
-- Date: 2015-08-27 15:22:28
--

local CrazyFeedBackProxy = class("CrazyFeedBackProxy", base.BaseProxy)

function CrazyFeedBackProxy:init(  )

	--请求当前奖励信息返回
	self:add(516062,self.reqGiftInfoCallback)

	--请求领取奖励返回
	self:add(516064,self.reqGetAwardCallback)

end


--请求当前奖励信息
function CrazyFeedBackProxy:reqGiftInfo(  )
	self:send(116062)
	self:wait(516062)
end

--请求当前奖励信息返回
function CrazyFeedBackProxy:reqGiftInfoCallback(data)
	debugprint("============reqGiftInfoCallback=============")
	--dump(data)
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.CRAZYFEEDBACK)
		if view then
			view:setGiftInfo(data)
		end
	end
end



------该方法为充值活动共用

--请求领取奖励
function CrazyFeedBackProxy:reqGetAward( type,index )
	local data = {}
	data.atype = type
	data.index = index
	self:send(116064,data)
end

--请求领取奖励返回
function CrazyFeedBackProxy:reqGetAwardCallback( data )
	debugprint("============reqGetAwardCallback=============")
	--dump(data)
	if data.status == 0 then
		--显示获得
		local alertView = mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		if alertView then
			alertView:setData(data["items"],true,true)
			alertView:setButtonVisible(false)
			alertView:setSureBtnTile(res.str.HSUI_DESC12)
		end


		--1每日首充,2单笔充值,3每日累充)
		if data.atype == 1 then
			local view = mgr.ViewMgr:get(_viewname.CHARGEPERDAY)
			if view then
				view:getAwardSucc(data)
				debugprint("领取每日充值奖励成功")
			end
			cache.Player:_setMeiRiNumber(cache.Player:getMeiRiNumber() - 1)

		elseif data.atype == 2 then
			local view = mgr.ViewMgr:get(_viewname.CRAZYFEEDBACK)
			if view then
				view:getAwardSucc(data)
				debugprint("领取充值反馈奖励成功")
			end
			cache.Player:_setDanCNumber(cache.Player:getDanCNumber() - 1)
		elseif data.atype == 3 then
			local view = mgr.ViewMgr:get(_viewname.CHARGECOUNT)
			if view then
				view:getAwardSucc(data)
				debugprint("领取累计充值奖励成功")
			end
			cache.Player:_setLeiCNumber(cache.Player:getLeiCNumber() - 1)
		end

		---设置红点
		local actView = mgr.ViewMgr:get(_viewname.ACTIVITY)
		if actView then
			actView:setRedPoint()
		end

		local mainTopView = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
		if mainTopView then
			mainTopView:setRedPoint()
		end

		
	end
end











return CrazyFeedBackProxy