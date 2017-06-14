
local CampCache = class("CampCache",base.BaseCache)

function CampCache:init()
	-- body
	self.data = {}
	self.datapage = {}
	self.jb = 0
	self.zs = 0
	self.win = false

	self.allnotic = {}
	self.selfnotic = {}

	self.page = 1
end

function CampCache:keepData(data)
	-- body
	self.data = data
end

function CampCache:getData()
	-- body
	return self.data
end

function CampCache:setautoMatchStatu( value )
	-- body
	self.data.selfUserInfo.autoMatchStatu = value
end

function CampCache:updateData( data )
	-- body
	if not data then 
		return 
	end
	if data.camp ~= 0 then
		--self.data.isJion = 1
		self.data.selfUserInfo.camp = data.camp
		self.data.campPlayerCount = data.campPlayerCount 
		self.data.campScore = data.campScore 

		self.data.dfCampPlayerCount = data.dfCampPlayerCount 
		self.data.dfCampScore = data.dfCampScore 
	end 
	if self.data.timeStatu == 0 then 
		self.data.leftTime = 60*30
	end
end

function CampCache:updateSelfrewrd(data_ )
	-- body
	self.data.jb_count = data_.jb_count
	self.data.hz_count = data_.hz_count

	if self:getSelfcamp() == 1 then 
		self.data.campPlayerCount = data_.campPlayerCount
		self.data.campScore = data_.campScore

		self.data.dfCampPlayerCount = data_.dfCampPlayerCount
		self.data.dfCampScore = data_.dfCampScore
	else
		self.data.campPlayerCount = data_.dfCampPlayerCount
		self.data.campScore = data_.dfCampScore

		self.data.dfCampPlayerCount = data_.campPlayerCount
		self.data.dfCampScore =  data_.campScore
	end	
	---这里有点坑吧 哈哈
	self.data.topWinner = data_.topWinner
end

function CampCache:updateMainInfo( data )
	-- body
	for k , v in pairs(data.vsUserInfo) do 
		if v.camp == self:getSelfcamp() then 
			self.data.selfUserInfo.maxConWinCount = v.maxConWinCount
			self.data.selfUserInfo.curConWinCount = v.curConWinCount
			
			self.data.selfUserInfo.winCount = v.winCount
			self.data.selfUserInfo.loseCount = v.loseCount
		end
	end

	--判断自己输赢
	if data.isWin > 0 then  --正义方 胜利
		if self:getSelfcamp() == 1 then 
			self.win = true
		else
			self.win = false
		end 
	else
		if self:getSelfcamp() == 2 then 
			self.win = true
		else
			self.win = false
		end 
	end 
	--如果自己胜利 --计算获得
	--if self.win then 
		local selfdata = {}
		local otherdata = {}
		for k ,v in pairs(data.vsUserInfo) do 
			if v.camp==self:getSelfcamp() then 
				selfdata = v
			else
				otherdata =v 
			end
		end

		if not selfdata.curConWinCount or not otherdata.curConWinCount then 
			return 
		end

		if selfdata.curConWinCount > 0 then 
			local win = selfdata.curConWinCount
			if win > 90 then
				win = 90 
			end
			local reward = conf.Camp:getReward(win)
			
			local jb = reward.lq_awards[1]
			local zs = reward.lq_awards[2]

			if otherdata.curConWinCount > 0 then 
				win = otherdata.curConWinCount
				if win > 90 then
					win = 90 
				end
				local reward_0 = conf.Camp:getReward(win)
				jb = jb + reward.zq_awards[1]	
				zs = zs + reward.zq_awards[2]
			end

			self.jb = jb
			self.zs = zs


		end

		self.selfwin = selfdata.curConWinCount
		self.otherwin = otherdata.curConWinCount
	--end
end

function CampCache:getSelfWin()
	-- body
	return self.win
end

function CampCache:getWinReward()
	-- body
	return self.jb,self.zs,self.selfwin,self.otherwin
end

function CampCache:getDataBycamp(camp)
	-- body
	local data = {}
	if self:getSelfcamp() == 1 then 
		if camp == 1 then 
			data.campScore = self.data.campScore
			data.campPlayerCount = self.data.campPlayerCount
		else
			data.campScore = self.data.dfCampScore
			data.campPlayerCount = self.data.dfCampPlayerCount
		end
	else
		if camp == 2 then 
			data.campScore = self.data.campScore
			data.campPlayerCount = self.data.campPlayerCount
		else
			data.campScore = self.data.dfCampScore
			data.campPlayerCount = self.data.dfCampPlayerCount
		end
	end
	return data
end

function CampCache:getSelfcamp()
	-- body
	if self.data.selfUserInfo and self.data.selfUserInfo.camp then 
		return self.data.selfUserInfo.camp
	end
	return 0
end

function CampCache:getMaxpageByType( type )
	-- body
	if type == 1 then 
		return self.datapage.jusMaxPage or 1
	else
		return self.datapage.eviMaxPage or 1
	end
	return 
end

function CampCache:keepZhengYing( data , request )
	-- body
	if not request or not data then 
		return 
	end

	local t = {}
	t.roleName = self.data.selfUserInfo.roleName
	t.power = self.data.selfUserInfo.power
	t.camp = self.data.selfUserInfo.camp
	t.roleId = self.data.selfUserInfo.roleId
	t.roleIcon = self.data.selfUserInfo.roleIcon
	t.vipLevel = self.data.selfUserInfo.vipLevel

	if tonumber(request.type) == 0 then 
		self.datapage = {}
		self.datapage.jusMaxPage = data.jusMaxPage
		self.datapage.eviMaxPage = data.eviMaxPage

		self.datapage.jusList ={}
		self.datapage.eviList = {}

		if self:getSelfcamp() == 1 then 
			table.insert(self.datapage.jusList,t)
			for k ,v in pairs(data.jusList) do 
				if v.roleId.key ~= t.roleId.key then 
					table.insert(self.datapage.jusList,v)
				end
			end
			self.datapage.eviList = data.eviList
		else
			table.insert(self.datapage.eviList,t)
			for k ,v in pairs(data.eviList) do 
				if v.roleId.key ~= t.roleId.key then 
					table.insert(self.datapage.eviList,v)
				end
			end
			self.datapage.jusList = data.jusList
		end 
		return 
	end
	
	if not self.datapage.jusList then 
		self.datapage.jusList = {}
	end

	if not self.datapage.eviList then 
		self.datapage.eviList = {}
	end

	for k ,v in pairs(data.jusList) do 
		if self:getSelfcamp() == 1 then 
			if v.roleId.key == t.roleId.key then 
			else
				table.insert(self.datapage.jusList,v)
			end 
		else
			table.insert(self.datapage.jusList,v)
		end
	end

	for k ,v in pairs(data.eviList) do 
		if self:getSelfcamp() == 2 then 
			if v.roleId.key == t.roleId.key then 
			else
				table.insert(self.datapage.eviList,v)
			end 
		else
			table.insert(self.datapage.eviList,v)
		end
	end
end
--缓存一下最近的全副信息
function CampCache:keepNoticeAll(data )
	-- body
	self.allnotic = data
end
function CampCache:getNoticeAll()
	-- body
	return self.allnotic
end
--缓存一下最近的个人信息
function CampCache:keepNoticeSelf(data )
	-- body
	for k ,v in pairs(data) do
		if self:getSelfcamp() == v.camp then
			if #self.selfnotic > 20 then 
				table.remove(self.selfnotic,1)
			end 
			table.insert(self.selfnotic,v.events)
			return v.events
		end 
	end
end

function CampCache:getNoticeSelf()
	-- body
	return self.selfnotic
end

function CampCache:getInfoData()
	-- body
	return self.datapage
end


function CampCache:keepPage( value )
	-- body
	self.page = value
end

function CampCache:getPage()
	-- body
	return self.page 
end

return CampCache