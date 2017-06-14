--
-- Author: Your Name
-- Date: 2015-07-22 14:22:10
--


local EatChickenProxy = class("EatChickenProxy", base.BaseProxy)

function EatChickenProxy:init(  )
	-- body

	self:add(516031,self.reqInfoCallback)
	self:add(516032,self.reqAwardCallback)


end


function EatChickenProxy:reqInfo(  )
	-- body
	self:send(116031)

end

function EatChickenProxy:reqAward(  )
	-- body
	self:send(116032)
end

function EatChickenProxy:reqInfoCallback( data )
	-- body
	--dump(data)
	if data.status == 0 then
		if data["isGet"] == 1 then------添加吃鸡红点
			--todo
			cache.Player:_setChiJnumber(1)

			--活动界面红点
			local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
			if view then
				view:setRedPoint()
			end

			--吃鸡红点
			local view = mgr.ViewMgr:get(_viewname.ACTIVITY)
			if view then
				view:setRedPoint()
			end

		else----------清除吃鸡红点
			cache.Player:_setChiJnumber(0)

			--活动界面红点
			local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
			if view then
				view:setRedPoint()
			end

			--吃鸡红点
			local view = mgr.ViewMgr:get(_viewname.ACTIVITY)
			if view then
				view:setRedPoint()
			end
				
		end
		local view = mgr.ViewMgr:get(_viewname.EATCHICKEN)
		if view then
			view:setTimeData(data)
		end
	end
end

function EatChickenProxy:reqAwardCallback( data )
	-- body
	if data.status == 0 then
		--todo
		local view = mgr.ViewMgr:get(_viewname.EATCHICKEN)
		if view then
			view:setAwardData(data)
		end
		cache.Player:_setChiJnumber(0)

		--活动界面红点
		local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
		if view then
			view:setRedPoint()
		end

		--吃鸡红点
		local view = mgr.ViewMgr:get(_viewname.ACTIVITY)
		if view then
			view:setRedPoint()
		end
	end
end

function EatChickenProxy:reqTimeZoneCallback( params )
	-- body

	dump(params)
	local  view = mgr.ViewMgr:get(_viewname.EATCHICKEN)
	if view then
		--todo
		local data = {}
		data.timeZone = 1
		data.canEat = 1
		view:setData(data)
	end
end





return EatChickenProxy