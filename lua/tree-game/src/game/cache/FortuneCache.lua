--[[--
  背包数据(包括仓库、装备、等使用背包存储的数据)
]]
local FortuneCache = class("FortuneCache",base.BaseCache)

function FortuneCache:init()
	self.DataInfo=nil
	self.Gonggao = {}
end


function FortuneCache:setGonggao(data)
	-- body
	self.Gonggao = data
end

function FortuneCache:getGonggao()
	-- body
	return self.Gonggao
end

function FortuneCache:setFortuneInfo(data_)
	self.DataInfo=data_.money
end
function FortuneCache:updateFortuneInfo(data_)
	if data_.moneyZs then
		self.DataInfo.moneyZs=data_.moneyZs
	end
	if data_.moneyJb then
		self.DataInfo.moneyJb=data_.moneyJb
	end
	if data_.moneyHz then
		self.DataInfo.moneyHz=data_.moneyHz
	end
	if data_.moneySh then
		self.DataInfo.moneySh = data_.moneySh
	end
	if data_.moneyHy then
		self.DataInfo.moneyHy = data_.moneyHy
	end
end

function FortuneCache:getMoneyHy( ... )
	-- body
	return self.DataInfo.moneyHy
end

function FortuneCache:getZs()
	return self.DataInfo.moneyZs
end
function FortuneCache:getJb()
	return self.DataInfo.moneyJb
end
function FortuneCache:getHz()
	return self.DataInfo.moneyHz
end
function FortuneCache:getSh()
	-- body
	if not self.DataInfo.moneySh then
		return 0
	else
		return self.DataInfo.moneySh
	end
	
end
-- function FortuneCache:getHz()
-- 	return self.DataInfo.moneyHz
-- end

function FortuneCache:getFortuneInfo()
	return self.DataInfo
end


return FortuneCache