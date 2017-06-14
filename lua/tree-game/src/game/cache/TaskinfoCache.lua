--[[
	成就 任务
]]


local TaskinfoCache = class("TaskinfoCache",base.BaseCache)

function TaskinfoCache:init ()
	-- body
	self.achievement = {}--成就
	self.task ={}--日常任务

	self.currdone = {} --当前完成的任务 显示之后要及时删除
end

function TaskinfoCache:getCurDoneAchi()
	-- body
	return self.currdone
end

function TaskinfoCache:setCurDoneAchi( data_ )
	-- body
	if data_ then 
		self.currdone = data_
	else
		self.currdone = {}
	end 
end

function TaskinfoCache:clearTask( id )
	-- body
	for k , v  in pairs(self.currdone.taskInfos) do 
		if tonumber(v.taskId) == tonumber(id) then 
			--debugprint("removeid = "..id)
			table.remove(self.currdone.taskInfos,k)
			return 
		end 
	end 
end

--日常任务
function TaskinfoCache:keepTask(data_)
	-- body
	self.task = data_.taskInfos
	self.hy = data_.hy
	self.hySign = data_.hySign
end

function TaskinfoCache:updateHy( value )
	-- body
	self.hy = (checkint(self.hy) or 0) + value
end

function TaskinfoCache:getHy()
	-- body
	return self.hy 
end

function TaskinfoCache:sethySign( value )
	-- body
	self.hySign = value or 0
end

function TaskinfoCache:getHySign( ... )
	-- body
	return self.hySign
end


function TaskinfoCache:updateTask( data_ )
	-- body
	--printt(data_)
	for k ,v in pairs (self.task) do 
		if v.taskId == data_.taskId then 
			self.task[k] = data_
		end 
	end 
end

function TaskinfoCache:getTask()
	-- body
	return self.task 
end

--可领取奖励有多少条
function TaskinfoCache:getCout()
	-- body
	local count = 0
	for k ,v in pairs(self.task) do 
		if v.is_get == 1 then 
			count = count+ 1
		end
	end 
	return count
end


--成就

function TaskinfoCache:keeptaskAchievement(data_ )
	-- body
	self.achievement = data_.taskInfos
	--添加所有已经完成的任务
	local typerecord = {} --同类型的任务就获取完成度最高的，相同ID小的
	for k ,v in pairs(self.achievement) do 
		local type = conf.achieve:getType(v.taskId)
		if not typerecord[type] then 
			typerecord[type] = {}
		end 

		if typerecord[type].taskId then 
			if v.taskId<typerecord[type].taskId then 
				typerecord[type].taskId = v.taskId
			end 
		else
			typerecord[type].taskId = v.taskId
		end 
		 ---就取一个最小的ID
		--table.insert(typerecord[type],v)
	end 
	--printt(typerecord)


	local listAchi = conf.achieve:getListAchi()--所有成就
	for k , v in pairs (listAchi) do 
		local t = {}
		t.taskId = v.id 
		t.pass = v.total_count 
		t.is_get = 2 
		t.tmpInt = v.lvl 
		if v.type then 
			if typerecord[v.type] then
				if v.id < typerecord[v.type].taskId then 
					table.insert(self.achievement,t)
				end  
			else
				table.insert(self.achievement,t)
			end 
		else
		 	--todo 
		 	debugprint("成就必须配置类型 type 区分是何种成就")
		end 
	end 

end

function TaskinfoCache:getAchievement()
	-- body
	return self.achievement
end
--可领取成就
function TaskinfoCache:getAchiCout( data_ )
	-- body
	local count = 0
	for k ,v in pairs(self.achievement) do 
		if v.is_get == 1 then 
			count = count+ 1
		end
	end 
	return count
end

function TaskinfoCache:updateAchi( data_ )
	-- body
	--printt(data_)
	for k ,v in pairs (self.achievement) do 
		if v.taskId == data_.taskId then 
			self.achievement[k] = data_
		end 
	end 
end



return TaskinfoCache