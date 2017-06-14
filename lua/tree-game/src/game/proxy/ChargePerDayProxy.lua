--
-- Author: Your Name
-- Date: 2015-08-27 15:37:58
--

local ChargePerDayProxy = class("ChargePerDayProxy", base.BaseProxy)

function ChargePerDayProxy:init(  )

	--请求当前奖励信息返回
	self:add(516061,self.reqDateInfoCallback)

	-- --请求领取奖励返回
	-- self:add(516064,self.reqGetAwardCallback)

end




---请求每日首充的日期
function ChargePerDayProxy:reqDateInfo(  )
	self:send(116061)
	self:wait(516061)
end

---请求每日首充的日期返回
function ChargePerDayProxy:reqDateInfoCallback( data )
	debugprint("============reqDateInfoCallback=============")
	--dump(data)
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.CHARGEPERDAY)
		if view then
			view:setGiftInfo(data)
		end
	end
end




return ChargePerDayProxy