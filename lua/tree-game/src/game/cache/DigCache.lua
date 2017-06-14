
local DigCache = class("DigCache",base.BaseCache)
function DigCache:init()
	-- body
	self.maindata = {}  --个人文件岛信息
	self.othermaindata = {}
end
--文件岛xinxi
function DigCache:keepMainMsg( data_ )
	-- body
	self.maindata = data_
end
function DigCache:getMainData( )
	-- body
	return self.maindata
end

function DigCache:updateInfoCheer(data)
	-- body
	local daoId = self:getCurDaoId()
	for k, v in pairs(self.maindata.wkList) do 
		if v.daoId == daoId then 
			v.cheerName = data.roleName
			v.cheerScore = data.score
			return v
			--break
		end
	end
	return nil
end

--是否被抢过
function DigCache:isBqd()
	-- body
	for k ,v in pairs(self.maindata.wkList) do 
		if v.bqc and v.bqc > 0 then 
			return true
		end
	end
	return false
end

function DigCache:getOneMsg(daoId)
	-- body
	for k , v in pairs(self.maindata.wkList) do 
		if v.daoId == daoId then 
			return v 
		end 
	end
end
--数码兽已经
function DigCache:isMid(mId)
	-- body
	for k , v in pairs(self.maindata.wkList) do 
		if tonumber(v.cardId) == tonumber(mId) then 
			return true
		end 
	end 
	return false
end

--[[function DigCache:clearCardId(daoId)
	-- body
	for k , v in pairs(self.maindata.wkList) do 
		if v.daoId == daoId then 
			v.cardId = 0
		end 
	end
end]]--

--自己的可镇压次数
function DigCache:getHelpCount()
	-- body
	return self.maindata.helpCount
end
--自己可助阵
function DigCache:getCheerCount()
	-- body
	return self.maindata.cheerCount
end

function DigCache:setHelpCount()
	-- body
	self.maindata.helpCount = self.maindata.helpCount - 1 
	if self.maindata.helpCount <0 then
		self.maindata.helpCount = 0
	end 
end
--自己可抢夺的次数
function DigCache:getQdCount()
	-- body
	return self.maindata.qdCount
end

function DigCache:setQdCount()
	-- body
	if not  self.maindata.qdCount then 
		return 
	end 

	self.maindata.qdCount = self.maindata.qdCount + 1 
	if self.maindata.qdCount <0 then
		self.maindata.qdCount = 0
	end 
	--return self.maindata.cheerCount
end

--挑战胜利之后 加一个岛信息
function DigCache:insertDao(daoId)
	-- body
	local t = {}
	t.daoId = daoId
	t.mId = 0
	t.lastTime = 0
	t.state = 0
	t.awardState = 0
	t.helpName = ""
	t.atkAward = 0
	t.loseCount = 0
	t.bqdCount = 0
	t.bqc = 0

	table.insert(self.maindata.wkList,t)
end

--更新某一个岛的状态 设置完成后
function DigCache:updateDaoId( data_ )
	-- body
	if not self.maindata then 
		return 
	end

	for k , v in pairs(self.maindata.wkList) do 
		if v.daoId == data_.daoId then 
			v.state = data_.state
			v.mId = data_.mId
			v.lastTime = 0
			--v.cardId = 0
			if data_.cardId then 
				v.cardId = data_.cardId
			end 

			if data_.lastTime then 
				v.lastTime = data_.lastTime
			elseif data_.totalLastTime then 
				v.lastTime = data_.totalLastTime
			end 

			if data_.awardState then 
				v.awardState = data_.awardState
			end

			if data_.loseCount then 
				v.loseCount = data_.loseCount
			end

			if data_.cheerName then 
				v.cheerName = data_.cheerName
			end

			if v.state == 0 then
				v.cardId = 0
			end 
			return v
		end 
	end 
end

--是否有矿在运行
function DigCache:isRunKuang()
	-- body
	for k ,v in pairs(self.maindata.wkList) do
		if v.state > 0 then 
			return true
		end 
	end 
	return false
end
--当前打开的是哪个岛
function DigCache:keepCurDaoId( id)
	-- body
	self.daoId = id
end

function DigCache:getCurDaoId( ... )
	-- body
	return self.daoId
end

--好友的岛信息------------------------------------------------------
function DigCache:keepOtherMainMsg(data_)
	-- body
	self.othermaindata = data_
end

function DigCache:getOtherMsg()
	-- body
	return self.othermaindata
end

function DigCache:updateOtherInfo(data_)
	-- body
	for k , v in pairs(self.othermaindata.wkList) do 
		if v.daoId == data_.daoId then 
			v.state = data_.state
			v.mId = data_.mId
			v.lastTime = 0
			if data_.lastTime then 
				v.lastTime = data_.lastTime
			elseif data_.totalLastTime then 
				v.lastTime = data_.totalLastTime
			end 
			return v
		end 
	end 
end

function DigCache:getOtherOnsMsg()
	-- body
	for k , v in pairs(self.othermaindata.wkList) do 
		if v.daoId == self:getCurDaoId() then 
			return v 
		end 
	end
end

function DigCache:updateHelpStatue()
	-- body
	for k , v in pairs(self.othermaindata.wkList) do 
		if v.daoId == self:getCurDaoId() then 
			v.state = 3
			return v 
		end 
	end 
end





return DigCache