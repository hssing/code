--GulildCache
--[[--
	公会信息
]]
local GulildCache = class("GulildCache",base.BaseCache)
function GulildCache:init()
	self._guildBaseInfo = nil  --公会基础信息
	self._guildFbInfo = nil  --公会副本信息
	self.searchData = {} --搜索公会列表
	self.addData = {} --申请加入那些公会
	self.curpage = 1 --当前请求了第几页
	self.shenhedata = {}--审核信息
	self._memberBaseInfo = {} --公会成员信息
	self._qfmsg = {} --祈福信息
	self.shopdata = {} --商店
	self.addData = {} --申请了那些公会

	self.currankpage = 1 --当前请求了第几页 --公会排行
	self.guildRankData = {}

	self._dongtaiMsg = {}
	self._rewardMsg = {} --副本奖励信息
end




---已经有的公会列表中是否存在
function GulildCache:_isExist( guildid )
	-- body
	for k , v in pairs(self.searchData.guildList) do 
		if v.guildId.key == guildid.key then 
			debugprint("到了这里")
			return true 
		end 
	end 
	return false
end

--搜索公会列表
function GulildCache:KeepSearch( data_,flag )
	-- body
	if flag then 
		self.addData = {} 
		self.searchData = data_
		self.curpage = 1 
	else
		self.curpage = self.curpage + 1
		self.searchData.maxPage = data_.maxPage
		for k ,v  in pairs (data_.guildList) do 
			if not self:_isExist(v.guildId) then 
				table.insert(self.searchData.guildList,v)
			end 
		end 
	end 
end

function GulildCache:getCurpage()
	-- body
	return self.curpage
end

function GulildCache:getSearchData()
	-- body
	return self.searchData.guildList
end
--公会列表最大页数
function GulildCache:getMaxPage()
	-- body
	if self.searchData.maxPage then 
		return self.searchData.maxPage
	end 
	return 0
end
--保存请求加入那些 公会的操作 1 是加入 其他 应该是取消吧
function GulildCache:keepAdd( data_ )
	-- body
	if self.addData[data_.guildId] then 
		self.addData[data_.guildId] = {}
	end 
	self.addData[data_.guildId.key] = data_
end

function GulildCache:getAdd(guildId)
	-- body
	return self.addData[guildId.key]
end
--公会审核列表
function GulildCache:keepShenhe( data_ )
	-- body
	self.shenhedata = {}
	self.shenhedata = data_
end
--从列表里面删除 请求信息
function GulildCache:delShenHe( data_ , flag)
	-- body
	if flag and flag == 2 then 
		self.shenhedata = {}
		return 
	end

	for k , v in pairs(self.shenhedata) do 
		if v.roleId.key == data_.roleId.key then 
			table.remove(self.shenhedata,k)
			break;
		end 
	end 
end

function GulildCache:getShenhe()
	-- body
	return self.shenhedata
end

function GulildCache:setChangeName( data )
	-- body
	self._guildBaseInfo.guildName = data.name
	self._guildBaseInfo.changeNameSign = data.changeNameSign  
end

---公会基础信息
function GulildCache:setGuildBaseInfo(data_)
		self._guildBaseInfo = data_
end
function GulildCache:getGuildBaseInfo()
		return self._guildBaseInfo
end
--审核通过之后 新加成员数量
function GulildCache:setGuildBaseGuildCount(num)
	-- body
	local count = num
	if not count then 
		count = 1 
	end 
	self._guildBaseInfo.guildCount = self._guildBaseInfo.guildCount + count 
end
--祈福之后改变一下信息
function GulildCache:updateBaseinfo( data_ )
	-- body

	if data_.guildExp then 
		self:setGuildExp(data_.guildExp)
	end 

	if data_.guildPoint then 
		self:setGuildPoint(data_.guildPoint)
	end 

	if data_.guildLevel then 
		self:setGuildLevel(data_.guildLevel)
	end 

	if data_.guildPower then 
		self:setGuildPower(data_.guildPower)
	end 

	if data_.guildCount then 
		self:setGuildCount(data_.guildCount)
	end 

	if data_.guildGonggao then 
		self:setGuildGonggao(data_.guildGonggao)
	end 
end

function GulildCache:setGuildGonggao( value )
	-- body
	self._guildBaseInfo.guildGonggao = value
end

function GulildCache:setGuildCount( value )
	-- body
	self._guildBaseInfo.guildCount = value
end

--设置公会战力
function GulildCache:setGuildPower( value )
	-- body
	self._guildBaseInfo.guildPower = value
end

--设置公会经验
function GulildCache:setGuildExp( value )
	-- body
	self._guildBaseInfo.guildExp = value
end
--设置公会贡献
function GulildCache:setGuildPoint( value )
	-- body
	if not  self._guildBaseInfo then 
		return 
	end 

	self._guildBaseInfo.guildPoint = value
end

function GulildCache:getGuildPoint()
	-- body
	if self._guildBaseInfo then 
		return self._guildBaseInfo.guildPoint
	else
		return 0
	end 
end

--设置公会等级
function GulildCache:setGuildLevel( value )
	-- body
	if self._guildBaseInfo then
		self._guildBaseInfo.guildLevel = value
	end
end
--公会人数 
function GulildCache:getGuildCount()
	-- body
	return self._guildBaseInfo.guildCount
end
--公会等级
function GulildCache:getGuildLevel()
	-- body
	return self._guildBaseInfo.guildLevel
end

---公会副本信息
function GulildCache:setGuildFbInfo( data_ )
		self._guildFbInfo = data_
end
function GulildCache:getGuildFbInfo(id_)
		return self._guildFbInfo
end

function GulildCache:getGuilidfbid( )
	-- body
	return self._guildFbInfo.fbId
end
--公会成员信息
function GulildCache:KeepMemberInfo(data_)
	-- body
	self._memberBaseInfo = data_

	--这个要去改变一下 自己的职位信息
	local t = self:getGuildSelfData()
	self:setSelfJob(t.job)
end

function GulildCache:getMemberInfo()
	-- body
	return self._memberBaseInfo
end
--自己的职位
function GulildCache:getSelfJob()
	-- body
	return self._guildBaseInfo.job
end

function GulildCache:setSelfJob( value )
	-- body
	self._guildBaseInfo.job = value
end

--找到自己
function GulildCache:getGuildSelfData()
	-- body
	local data = cache.Player:getRoleInfo()
	--printt(data)
	for k , v in pairs(self._memberBaseInfo) do 
		if v.roleId.key == data.roleId.key then 
			--debugprint("找到了自己的成员的信息")
			--printt(v)
			return v 
		end 
	end 
end
--踢出了某个成员
function GulildCache:removeMember(roleId)
	-- body
	for k , v in pairs(self._memberBaseInfo) do 
		if v.roleId.key ==roleId.key then 
			debugprint("有这个成员并且T出")
			table.remove(self._memberBaseInfo,k)
			self:setGuildBaseGuildCount(-1)
			return 
		end 
	end  
end

--祈福信息
function GulildCache:keepQFmsg( data_  )
	-- body
	self._qfmsg = data_
end

function GulildCache:getQFmsg()
	-- body
	return self._qfmsg
end

--[[function GulildCache:decReward(value )
	-- body
	for k , v in pairs(self._qfmsg.qfAwards) do 
		if tonumber(v) == tonumber(value) then 
			table.remove(self._qfmsg.qfAwards,k)
			break
		end 
	end 
end

function GulildCache:getReward( )
	-- body
	printt(self._qfmsg.qfAwards)
	return self._qfmsg.qfAwards
end]]--



--缓存商店信息
function GulildCache:keepShopMsg( data_ )
	-- body
	self.shopdata = data_.itemInfos
	self:setGuildPoint(data_.money_gx)--请求商店的时候刷新一下帮贡
end

--获取商店列表
function GulildCache:getShopList()
	-- body
	return self.shopdata
end
--购买之后刷新 该道具可购买的次数
function GulildCache:setShopitemInfo(data_)
	-- body
	for k ,v in pairs(self.shopdata) do 
		if data_.index == v.index then 
			for i , j in pairs(v.propertys) do 
				if j.type == 40103 then 
					j.value = data_.buyCount
					break
				end 
			end 
			break	
			--v.amount = data_.buyCount
		end 
	end 
end
--公会排行信息
function GulildCache:KeepRankInfo( data_ ,pageindex)
	-- body
	self.currankpage = pageindex  
	if pageindex == 1  then 
		self.guildRankData = data_
  
	else
		self.guildRankData.pageMax = data_.pageMax
		for k ,v  in pairs (data_.rankInfos) do 
			--if not self:_isExistIn(v.guildId) then 
			--	table.insert(self.guildRankData.rankInfos,v)
			--end 
			local flag = false 
			for i ,j in pairs(self.guildRankData.rankInfos) do 
				if j.guildId.key == v.guildId.key then 
					flag = true 
					break
				end
			end 

			if not flag then 
				table.insert(self.guildRankData.rankInfos,v)
			end 
		end 
	end 
end

function GulildCache:getCurRankpage()
	-- body
	return self.currankpage
end

function GulildCache:getRankInfoData()
	-- body
	return self.guildRankData.rankInfos
end

function GulildCache:getRankmyself()
	-- body
	return self.guildRankData.selfRank
end
--公会列表最大页数
function GulildCache:getRankMaxPage()
	-- body
	if self.guildRankData.pageMax then 
		return self.guildRankData.pageMax
	end 
	return 0
end


---动态
function GulildCache:keepDongtaiMsg( data_ )
	-- body
	self._dongtaiMsg = data_
end


function GulildCache:getDongtaiMsg()
	-- body
	return self._dongtaiMsg
end


--成员战绩
function GulildCache:keepZhanji(data_)
	-- body
	self.zhanjidata = data_
end

function GulildCache:getZhanji()
	-- body
	return self.zhanjidata 
end
--副本奖励信息
function GulildCache:KeepFBReward( data_ )
	-- body
	self._rewardMsg = data_
end

function GulildCache:updateFBReward( data_ )
	-- body
	for k , v in pairs(self._rewardMsg) do 
		if tonumber(k) == tonumber(data_.cId) then 
			debugprint("在这里更新")
			self._rewardMsg[k] = 2
		end 
	end 
end

function GulildCache:getFBreward()
	-- body
	return self._rewardMsg
end

return GulildCache