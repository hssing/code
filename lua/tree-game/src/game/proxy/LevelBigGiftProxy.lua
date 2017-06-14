--
-- Author: Your Name
-- Date: 2015-08-03 20:17:30
--


local LevelBigGiftProxy = class("LevelBigGiftProxy", base.BaseProxy)

function LevelBigGiftProxy:init(  )
	-- body
	---请求等级奖励信息返回
	self:add(516041,self.reqGiftInfoCallback)
	---请求领取奖励
	self:add(516042,self.reqreqGetAwardCallback)
end



function LevelBigGiftProxy:reqTimeTickCallback( data )
	-- body

end

-------请求礼包信息
function LevelBigGiftProxy:reqGiftInfo(  )
	-- body
	self:send(116041)
	self:wait(516041)
	--G_Loading(true)
end

function LevelBigGiftProxy:reqGiftInfoCallback( data )
	-- body
	print("==============reqGiftInfoCallback====================")
	--G_Loading(false)
	if data.status == 0 then
		--todo
			------更新红点
		cache.Player:_setDengJJLNumber(data.awards._size)
		local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
		if view then
			view:setRedPoint()
		end
		local view = mgr.ViewMgr:get(_viewname.LEVELBIGIFT)
		if view then
			view:setData(data)
		else
			mgr.ViewMgr:showView(_viewname.LEVELBIGIFT):setData(data)
		end
	end
end



-------请求领取等级奖励
function LevelBigGiftProxy:reqGetAward( lv )
	-- body
	self:send(116042,{level = lv})
end

-----领取成功
function LevelBigGiftProxy:reqreqGetAwardCallback( data )
	-- body
	debugprint("==============reqreqGetAwardCallback====================")
	if data.status == 0 then
		--todo
		local view = mgr.ViewMgr:get(_viewname.ACTIVITY)
		if view then
			view:setRedPoint()
		end
		local view = mgr.ViewMgr:get(_viewname.LEVELBIGIFT)
		if view then
			view:getAwardSucc(data)
		else
			mgr.ViewMgr:showView(_viewname.LEVELBIGIFT):getAwardSucc(data)
		end

	elseif data.status == 21070011 then
		G_TipsOfstr(res.str.LEVELGIFT_TIP2)

	elseif data.status == 21070012 then
		G_TipsOfstr(res.str.LEVELGIFT_TIP1)
	end

end






return LevelBigGiftProxy