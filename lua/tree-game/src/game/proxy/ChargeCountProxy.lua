--
-- Author: Your Name
-- Date: 2015-08-27 15:36:10
--

local  ChargeCountProxy = class("ChargeCountProxy", base.BaseProxy)


function ChargeCountProxy:init(  )

	--请求当前奖励信息返回
	self:add(516063,self.reqGiftInfoCallback)

	-- --请求领取奖励返回
	-- self:add(516064,self.reqGetAwardCallback)

end


--请求当前奖励信息
function ChargeCountProxy:reqGiftInfo(  )
	self:send(116063)
	self:wait(516063)
end

--请求当前奖励信息返回
function ChargeCountProxy:reqGiftInfoCallback(data)
	debugprint("============reqGiftInfoCallback=============")
	--dump(data)
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.CHARGECOUNT)
		if view then
			view:setGiftInfo(data)
		end
	end
end




return ChargeCountProxy