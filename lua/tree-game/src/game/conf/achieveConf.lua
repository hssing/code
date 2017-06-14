--[[
--成就
]]
local achieveConf=class("achieveConf",base.BaseConf)

function achieveConf:init( )
	-- body
	self.conf=require("res.conf.task_honor")
end
--成就描述
function achieveConf:getdec( id )
	-- body
	local achieve=self.conf[tostring(id)]

	if not achieve then 
		self:Error(id)
		return nil
	end
	return achieve.des
end
--是否累计
function achieveConf:getIsSum(id)
	-- body
	local achieve=self.conf[tostring(id)]

	if not achieve then 
		self:Error(id)
		return nil
	end
	return achieve.is_sum
end

--
--任务上限
function achieveConf:gettotal_count( id )
	-- achieve
	local achieve=self.conf[tostring(id)]

	if not achieve then 
		self:Error(id)
		return nil
	end
	return achieve.total_count
end	

--任务图标
function achieveConf:getSrc( id )
	-- body
	local achieve=self.conf[tostring(id)]

	if not achieve then 
		self:Error(id)
		return nil
	end
	return achieve.src
end
--奖励

function achieveConf:getReward( id )
	-- body
	local achieve=self.conf[tostring(id)]

	if not achieve then 
		self:Error(id)
		return nil
	end
	return achieve.award
end
--排序
function achieveConf:getSortid( id )
	-- body
	local achieve=self.conf[tostring(id)]

	if not achieve then 
		self:Error(id)
		return nil
	end
	return achieve.type_seq
end

function achieveConf:getType(id)
	-- body
	local achieve=self.conf[tostring(id)]

	if not achieve then 
		self:Error(id)
		return nil
	end
	return achieve.type
end
--f品级
function achieveConf:getcolor(id)
	-- body
	local achieve=self.conf[tostring(id)]

	if not achieve then 
		self:Error(id)
		return nil
	end
	return achieve.color
end

function achieveConf:getToview(id)
	-- body
	local achieve=self.conf[tostring(id)]
	if not achieve or not achieve.viewid then 
		self:Error(id)
		return nil
	end
	return achieve.viewid
end

function achieveConf:getListAchi()
	-- body
	return self.conf
end

return achieveConf
