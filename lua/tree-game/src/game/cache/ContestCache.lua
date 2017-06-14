
local ContestCache = class("ContestCache", base.BaseCache)

function ContestCache:init()
	-- body
	self.Contestdata = {} --数码大赛信息
	self.gropdata = {}--小组信息
	self.caiInfo = {} --竞猜信息
	self.video_ = {} --录像信息
	self.currankpage = 1

	self.winnerMsg = {}
	self.winnerSetMsg = {}

	self.ShopMsg = {}

	self.iswinnernull = false
end
--
function ContestCache:keepShop(data)
	-- body
	self.ShopMsg = data
end

function ContestCache:updateBuy(id)
	-- body
	for k , v in pairs(self.ShopMsg.shopList) do 
		if tonumber(k) == tonumber(id) then 
			v = 1
		end 
	end 
end

---
function ContestCache:keepWinnerNullMsg()
	-- body
	self.iswinnernull = true
end

function ContestCache:getIswinnernull( ... )
	-- body
	return self.iswinnernull
end

----驯兽师之王
function ContestCache:keepWinnerMsg( data_ )
	-- body
	self.winnerMsg = data_

end

function ContestCache:resetWinnerMsg( data_ )
	-- body
	self.winnerMsg.isZan = data_.isZan
	self.winnerMsg.zanCount = data_.zanCount
	self.winnerMsg.zanType = data_.zanType
end

function ContestCache:getWinnerMsg()
	-- body
	return self.winnerMsg
end

function ContestCache:getIsWinner()
	-- body
	return self.winnerMsg.flag
end

--设置信息
function ContestCache:keepSetMsg( data_ )
	-- body
	self.winnerSetMsg = data_
	for k , v in pairs(data_.awards) do 
		if tostring(k) ~= "_size" then 
			if tonumber(k) <  tonumber(self.winnerSetMsg.currDay) then 
				if tonumber(v) == 0 then 
					print("gaibia ")
					data_.awards[k] = 1
				end 
			end 
		end 
	end 
	--printt(data_.awards)
	--if self.winnerSetMsg.currDay
end

function ContestCache:resetSetMsg( data_ )
	-- body
	self.winnerSetMsg.currDay = data_.today
	self.winnerSetMsg.awards[data_.today] = {}
	self.winnerSetMsg.awards[data_.today] = data_.zanType
end

function ContestCache:getDay( ... )
	-- body
	return self.winnerSetMsg.currDay
end

function ContestCache:getSetMsg()
	-- body
	return self.winnerSetMsg
end





--数码大赛信息
function ContestCache:keepContest( data_ )
	-- body
	self.Contestdata = data_ --519001
end

function ContestCache:updateInfo()
	-- body
	self.Contestdata.dsState = 2
end

function ContestCache:getContest()
	-- body
	return self.Contestdata
end

function ContestCache:updatedsState()
	-- body
	self.Contestdata.dsState = 1
end

---小组信息
function ContestCache:keepGroup(data_,page)
	-- body
	self.currankpage = page 
	if page == 1 then 
		self.gropdata = data_
	else
		self.gropdata.maxPage = data_.maxPage
		self.gropdata.selfRank = data_.selfRank
		for k ,v in pairs(data_.smdsArrays) do 
			local flag = false

			for i ,j in pairs(self.gropdata.smdsArrays) do 
				if j.roleId.key == v.roleId.key then 
					flag = true 
					break
				end
			end 

			if not flag then 
				table.insert(self.gropdata.smdsArrays,v)
			end 
		end 
	end 
	
end

function ContestCache:getCurpage()
	-- body
	return self.currankpage
end

function ContestCache:getMaxPage()
	-- body
	return self.gropdata.maxPage
end

function ContestCache:getGroupInfo()
	-- body
	return self.gropdata
end

--竞猜信息

function ContestCache:keepCaiInfo( data_ )
	-- body
	self.caiInfo = data_
end

function ContestCache:getCaiInfo( ... )
	-- body
	return self.caiInfo
end

function ContestCache:keepVideo( data_ )
	-- body
	self.video_ = data_
end

function ContestCache:getVideo( ... )
	-- body
	return self.video_
end

return ContestCache