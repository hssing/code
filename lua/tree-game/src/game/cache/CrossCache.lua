
local CrossCache = class("CrossCache",base.BaseCache)

function CrossCache:init()
	-- body
	self.sh_data = {} --神魂猎命

	self.data = {} --跨服信息
	self.isup = 0 --段位变化

	self.windata = {} --王者之战
end
----
function CrossCache:setWinData( data_ )
	-- body
	self.windata = data_
end

function CrossCache:getWinData()
	-- body
	return self.windata
end
----------------------
function CrossCache:setKFdata( data_ )
	-- body
	self.data = data_
end

function CrossCache:getKFdata()
	return self.data
end

function CrossCache:reduceBuy()
	-- body
	self.data.canBuyCount = self.data.canBuyCount -  conf.Item:getExp(221011011)
	if self.data.canBuyCount < 0 then
		self.data.canBuyCount = 0
	end
end

function CrossCache:getcanBuyCount( ... )
	-- body
	return self.data.canBuyCount
end

--战斗次数
function CrossCache:setFigthCount( value )
	-- body
	self.data.figthCount = value or 0
end

function CrossCache:getFigthCount( ... )
	-- body
	return self.data.figthCount
end

--段位是否有上升 1升段位 0 段位不变 -1 降段位
function CrossCache:isDwUp(var)
	if var then
		local d = var - self.data.roleDw
		if d > 0 then
			self.isup = 1
		elseif d == 0 then
			self.isup = 0
		else
			self.isup = -1
		end
	end
end

function CrossCache:getisDwUp()
	-- body
	return self.isup
end

function CrossCache:setisDwUp(value)
	-- body
	self.isup = value or 0
end


--定级赛场次信息
function CrossCache:resetDjs(iswin)
	-- body
	for i = 1 , 5 do 
		if self.data.djs[tostring(i)] == 0 then
			if iswin then
				self.data.djs[tostring(i)] = 1
				break
			else
				self.data.djs[tostring(i)] = 2
				break
			end
		end
	end
end

function CrossCache:getlastDjs()
	-- body
	if not self.data.djs[tostring(1)] then
		return false
	end

	for k ,v in pairs(self.data.djs) do 
		if checkint(k) > 0 then
			if v == 0 then
				return false
			end
		end
	end
	return true
end

--战斗之后刷新自己的信息
function CrossCache:resetself( data_ )
	-- body
	if data_.shVal then
		self.data.shenhuen = self.data.shenhuen + data_.shVal
	end
	if data_.roleDw then
		self.data.roleDw = data_.roleDw
	end
	
	if data_.pwCount then
		self.data.figthCount = data_.pwCount
	end

	if data_.pointShu then
		self.data.pointShu = data_.pointShu
	end

	if data_.winRate then
		self.data.winRate = data_.winRate
	end

end
--------------------------------------------------
function CrossCache:setSh_Data( data_ )
	-- body
	self.sh_data = data_
end

function CrossCache:getSh_Data( ... )
	-- body
	return self.sh_data
end

function CrossCache:updateSh_data( data_ )
	-- body
	if data_.lzId then
		self.sh_data.lzId = data_.lzId
	end

	if data_.resNum then
		self.sh_data.resNum = resNum
	end
	if data_.gots then
		for k ,v in pairs(data_.gots) do 
			table.insert(self.sh_data.items,v)
		end
	end
end

function CrossCache:getSpNum()
	-- body
	if self.sh_data.spNum then
		return self.sh_data.spNum
	end

	return 0
end

function CrossCache:update_spNum( value )
	-- body
	self.sh_data.spNum = value
end

function CrossCache:getShValue( ... )
	-- body
	if self.sh_data.resNum then
		return self.sh_data.resNum
	else
		return 0
	end
end

function CrossCache:delete_data( data_ )
	-- body
	if data_.resNum then
		self.sh_data.resNum = data_.resNum
	end

	if data_.spNum then
		self.sh_data.spNum = data_.spNum
	end

	if data_.changeList then
		for k ,v in pairs(data_.changeList) do 
			for i , j in pairs(self.sh_data.items) do 
				if j.index == v.index then
					table.remove(self.sh_data.items,i)
					break
				end
			end
		end
	end
end

----------为了观看战斗数据返回后
function CrossCache:keepInfobefor( data,hehe )
	-- body
	self.p_data = data
	self.hehe = hehe
end

function CrossCache:getinbefor()
	-- body
	return self.p_data,self.hehe
end


return CrossCache