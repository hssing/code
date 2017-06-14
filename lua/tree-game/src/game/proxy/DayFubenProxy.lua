--[[
	日常副本
]]

local DayFubenProxy = class("DayFubenProxy",base.BaseProxy)

function DayFubenProxy:init()
	-- body
	self:add(521001,self.msgCallBack)

	self:add(521002,self.BuymsgCallBack)
end

function DayFubenProxy:msgCallBack( data_ )
	-- body
	if data_.status == 0 then
		cache.DayFuben:keepData(data_)
		local view = mgr.ViewMgr:get(_viewname.FUBEN_DAY)
		if view then
			if #data_.openFuben<1 then
				view:onCloseSelfView()
			else
				view:setData(data_)
			end
		else
			if #data_.openFuben>0 then
				view = mgr.ViewMgr:showView(_viewname.FUBEN_DAY)
				view:setData(data_)
			end
		end
	else

	end
end

function DayFubenProxy:send121001()
	-- body
	self:send(121001)
end


function DayFubenProxy:BuymsgCallBack(data_)
	-- body
	if data_.status == 0 then
		local count  = cache.Player:getDayFubenNumber()
        count = count + 1
        if count < 0 then
            count = 0
        end
        cache.Player:_setDayFubenNumber(count)

        local view_1 = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
        if view_1 then
        	view_1:setRedPoint()
        end

		cache.DayFuben:setVipBuyCount(self.fbType,data_.vipBuyCount)
		local view = mgr.ViewMgr:get(_viewname.FUBEN_DAY)
		if view then
			view:updateinfo(self.fbType,data_.vipBuyCount)
		end
	else

	end
end

function DayFubenProxy:send121002(param)
	-- body
	self.fbType = param.fbType
	self:send(121002,param)
	self:wait(521002)
end
return DayFubenProxy