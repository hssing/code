--[[
	任务 成就
]]

local taskProxy = class("taskProxy",base.BaseProxy)

function taskProxy:init()
	-- body
  self:add(513001,self.allcallback)
  self:add(513002,self.getcallback)
  self:add(814001,self.resetTask)

  self:add(505004,self.add_505004)
  self:add(513004,self.add_513004)

  self.curSendtype = 1 -- 1 日常任务 2 成就 
  self.getType = 1 --领取的是何种奖励
end
--请求
function taskProxy:sendMessagetype(type)
	-- body
	self.curSendtype = type
	local data = {
		ttype = self.curSendtype
	}
	self:send(113001,data)
end

function taskProxy:sendMessageGet( id )
	-- body
	local data = {
		taskId = id
	}
	--410301成就的开始ID
	if id < 400000 then 
		self.getType = 1
	else
		self.getType = 2
	end 

	self:send(113002,data)
end

function taskProxy:allcallback( data_ )
	-- body
	if data_.status == 0 then 
		
		if self.curSendtype == 1 then
			cache.Taskinfo:keepTask(data_)
		else
			cache.Taskinfo:keeptaskAchievement(data_)
		end
		--成就
		local view=mgr.ViewMgr:get(_viewname.ACHIEVEMENTVIEW)
		if view then 
			view:setData()
			view:initAllPanle()
		end
		--日常任务
		local view=mgr.ViewMgr:get(_viewname.TASK)
		if view then 
			view:setData()
			view:initAllPanle(1)
		end

		local view = mgr.ViewMgr:get(_viewname.MAIN)
		if view then 
			view:setRedPoint()
		end 
	else
		debugprint("成就 日常任务 返回失败")
	end
end
--任务领取
function taskProxy:getcallback( data_ )
	-- body
	if data_.status == 0 then
		-- 领取成功
		debugprint("领取成功")
		if self.getType ==1 then 
			cache.Taskinfo:updateTask(data_.taskInfo)
			cache.Taskinfo:updateHy(data_.gotHy) 
			--日常任务
			local view=mgr.ViewMgr:get(_viewname.TASK)
			if view then 
				view:setData()
				view:initAllPanle(1)
			end
		else 
			--todo
			cache.Taskinfo:updateAchi(data_.taskInfo) 
			--成就
			--print("2222")
			local view=mgr.ViewMgr:get(_viewname.ACHIEVEMENTVIEW)
			if view then 
				view:tips(data_.taskInfo.taskId)
				view:setData()
				view:initAllPanle()
			end
		end 

		local view = mgr.ViewMgr:get(_viewname.MAIN)
		if view then 
			view:setRedPoint()
		end 
	else
		debugprint("领取 日常任务 返回失败")
	end 
end
--有任务完成
function taskProxy:resetTask( data_ )
	-- body
	if data_.status == 0 then
		cache.Taskinfo:setCurDoneAchi(data_)
		--print("resetTask shenji")
		--mgr.SceneMgr:getNowShowScene():performWithDelay(G_ShowAchi, 0.2)
		--G_ShowAchi()
		G_TaskShow()
		for k , v in pairs(data_.taskInfos) do 
			cache.Taskinfo:updateTask(v) 
		end 
		--日常任务
		local view=mgr.ViewMgr:get(_viewname.TASK)
		if view then 
			view:setCallBack()
			--view:setData()
			--view:initAllPanle()
		end

		local view = mgr.ViewMgr:get(_viewname.MAIN)
		if view then 
			view:setRedPoint()
		end 
	else
		debugprint("领取 日常任务 返回失败")
	end 
end

function taskProxy:send_105004( param )
	-- body
	self:send(105004,param)
	self:wait(505004)
end

function taskProxy:send_113004( param )
	-- body
	self:send(113004,param)
	self:wait(513004)
end

function function_name( ... )
	-- body
end

function taskProxy:add_505004( data_ )
	-- body
	if data_.status == 0 then
		G_TipsOfstr(res.str.SHOP_SUCCESS)
		local view=mgr.ViewMgr:get(_viewname.TASK)
		if view then
			view:setData1(data_)
		end
	else
		G_TipsError(data_.status)
	end
end

function taskProxy:add_513004( data_ )
	-- body
	if data_.status == 0 then
		local count = cache.Player:getGetTaskHy() - 1
		if  count < 0 then
			count = 0
		end
		cache.Player:_setGetTaskHy(count)
		cache.Taskinfo:sethySign(data_.hySign)
		local view=mgr.ViewMgr:get(_viewname.TASK)
		if view then
			view:update1(data_)
		end

		

		local view = mgr.ViewMgr:get(_viewname.MAIN)
		if view then 
			view:setRedPoint()
		end 
	else
		G_TipsError(data_.status)
	end
end

return taskProxy