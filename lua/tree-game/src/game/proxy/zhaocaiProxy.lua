--zhaocaiProxy
--[[
	活动招财
]]

local zhaocaiProxy = class("taskProxy",base.BaseProxy)

function zhaocaiProxy:init()
	-- body
	self:add(516011,self.zhaocaicallback)
	self:add(516012,self.zhaocaiback)
end

--招财信息返回
function zhaocaiProxy:zhaocaicallback(data_)
	-- body
	if data_.status == 0 then 
		cache.Zhaocai:keepInfo(data_)
		local view = mgr.ViewMgr:get(_viewname.ACTIVITYZHAOCAI)
		if view then 
			view:setData(cache.Zhaocai:getData())
		end

	else
		debugprint("问志平 招财信息返回失败 错误号"..data_.status
		.." 错误号不是-1 跟王显说")
	end 
end
--请求招财信息
function zhaocaiProxy:sendMessage()
	-- body
	self:send(116011)
end

--招财按钮按一次返回

--招财信息返回
function zhaocaiProxy:zhaocaiback(data_)
	-- body
	if data_.status == 0 then 
		cache.Zhaocai:updatezCount(data_.zCount)
		local view = mgr.ViewMgr:get(_viewname.ACTIVITYZHAOCAI)
		if view then 
			view:updateData(data_)--需要弹出做动画
		end

		--红点
		cache.Player:_setZCnumber(data_.zCount)
		local view = mgr.ViewMgr:get(_viewname.ACTIVITY)
		if view then
			view:setRedPoint()
		end

	else
		debugprint("问志平 招财信息返回失败 错误号"..data_.status
		.." 错误号不是-1 跟王显说")
	end 
end

function zhaocaiProxy:send116012(count_)
	-- body
	local data = {count = count_}
	self:send(116012,data)
end

return zhaocaiProxy