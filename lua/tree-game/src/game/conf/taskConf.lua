--[[
--日常任务
]]
local taskConf=class("taskConf",base.BaseConf)

function taskConf:init()
	-- body
	self.conf = require("res.conf.task_daily")

	self.confreward = require("res.conf.task_daily_award")
end
--每日活跃度获取
function taskConf:getDayHy( id )
	-- body
	local task=self.conf[tostring(id)]

	if not task then 
		self:Error(id)
		return nil
	end
	return task.day_hy
end

--任务描述
function taskConf:getdec(id)
	-- body
	local task=self.conf[tostring(id)]

	if not task then 
		self:Error(id)
		return nil
	end
	return task.des
end
--任务上限
function taskConf:gettotal_count( id )
	-- body
	local task=self.conf[tostring(id)]

	if not task then 
		self:Error(id)
		return nil
	end
	return task.total_count
end
--任务图标
function taskConf:getSrc( id )
	-- body
	local task=self.conf[tostring(id)]

	if not task then 
		self:Error(id)
		return nil
	end
	return task.src
end
--奖励
function taskConf:getReward( id,lv )
	-- body
	local task=self.confreward[tostring(id*1000+lv)]

	if not task then 
		self:Error(id)
		return nil
	end
	return task.awards
end

--奖励
function taskConf:getRewardExp( id,lv )
	-- body
	local task=self.confreward[tostring(id*1000+lv)]

	if not task then 
		self:Error(id)
		return nil
	end
	return task.exp
end
--任务类型
function taskConf:gettyoe(id)
	-- body
	local task=self.conf[tostring(id)]

	if not task then 
		self:Error(id)
		return nil
	end
	return task.type
end
--f品级
function taskConf:getcolor(id)
	-- body
	local task=self.conf[tostring(id)]

	if not task then 
		self:Error(id)
		return nil
	end
	return task.color
end

--跳转界面
function taskConf:getToview(id)
	-- body
	local task=self.conf[tostring(id)]
	if not task or not task.viewid then 
		self:Error(id)
		return nil
	end
	return task.viewid
end




return taskConf

