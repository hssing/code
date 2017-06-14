--
-- Author: Your Name
-- Date: 2015-07-16 14:38:59
--

local SignInProxy = class("SignInProxy", base.BaseProxy)


function SignInProxy:init( )
	-- body
	self:add(516021,self.reqSignInfoCallback)
	self:add(516022,self.reqAwardItemsCallback)
	--self:add()
end


function SignInProxy:reqSignInfo()
	-- body
	--G_Loading(true)
	self:send(116021)
	self:wait(516021)
	--self:timeTick()
end

function SignInProxy:reqAwardItems( data )
	-- body
	self:send(116022,data)
end

-------请求签到信息返回
function SignInProxy:reqSignInfoCallback( data)
	-- body
	--conf.qiandao:setDate(5)
	-- G_Loading(false)
	-- if self.timer then
	-- 	--todo
	-- 	scheduler.unscheduleGlobal(self.timer)
	-- end

	if data.status ~= 0 then
		return
	end

	
	self.data = data

	conf.qiandao:setDate(data["currDay"])
	conf.qiandao:setCached(true)
	conf.qiandao:setAwardState(data.awardState)
	local scene = mgr.SceneMgr:getMainScene()
	if scene then
		scene:changeView(14):dataChanged(data)
	end
	-- if self.target then
	-- 	self.target:dataChanged(data)
	-- end

end

function SignInProxy:reqAwardItemsCallback( data )
	-- body
	if data and data["status"] == 0 then
		--mgr.ViewMgr:showView("signin.AwardAlertView"):setData(data)
		self.target:getAwardSucc(data)
		conf.qiandao:setAwardState(2)
		-----更新 playerCache
			cache.Player:_setQDnumber(0)
			local view = mgr.ViewMgr:get(_viewname.MAIN)
			if view then
				view:setRedPoint()
			end
	elseif data.status == 21030001 then
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	end
	
end

-------网络请求倒计时
-- function SignInProxy:timeTick(  )
-- 	-- body
-- 	self.timer = scheduler.scheduleGlobal(function( )
-- 		-- body
-- 		print("网络超时")
-- 		G_Loading(false)
-- 		G_TipsOfstr(res.str.NET_LONG_TIME)
-- 		 scheduler.unscheduleGlobal(self.timer)
-- 		 self.timer = nil
		
-- 	end,40)

--end








function SignInProxy:getData( )
	-- body

	return self.data
end

function SignInProxy:setTarget( obj )
	-- body
	self.target = obj
end
return SignInProxy