--
-- Author: Your Name
-- Date: 2015-07-15 16:11:27
--

local QiandaoConf = class("QiandaoConf", base.BaseConf)


function QiandaoConf:init()
	-- body
	self.conf = require("res.conf.qiandao")

	--默认第一天
	self.date = 1
	self.awardState = 1
	self.cached = false
end

function QiandaoConf:setCached( flag )
	-- body
	self.cached = true
end

function QiandaoConf:isCached(  )
	-- body

	return self.cached
end

---获得 vip 加倍图标
function QiandaoConf:getVip2( day )
	local date = self.date + day
	if date > 30 and date < 100 then
		date = date - 30
	elseif date >130 then
		date = date - 130
	end
	
	local vip = self.conf[date .. ""]["vip_lvl"]
	return vip
end


function QiandaoConf:getName(mid)
	-- body
	return conf.item:getName(mid)
end

--获得第 index 个奖励的 id 数量
function QiandaoConf:getRewardInfoAtIndex( dateOffset,index )
	-- body
	local rewards = self:get1DayData(dateOffset)
	if not rewards then
		--todo
		return 0
	end

	local  i = 1
	for k,v in pairs(rewards) do
		if i == index then
			return v
		end
		i = i+1
	end


end

--获得奖励的名称
function QiandaoConf:getName( mid )
	-- body
	return conf.Item:getName(mid)
end

--获得物品显示的 Icon
function  QiandaoConf:getIcon( mid )
	-- body

	local path = conf.Item:getItemSrcbymid(mid)

	return path
end

-- 获得物品显示的边框 Icon
function QiandaoConf:getFrameIcon( mid )
	-- body
	local  color = conf.Item:getItemQuality(mid)
	local iconPath = res.btn["FRAME"][color]
	if iconPath then
		--todo
		return iconPath
	end

	return nil
end

-- 获得显示字体颜色
function QiandaoConf:getTextColor(mid)
	-- body
	local  color = conf.Item:getItemQuality(mid)
	return COLOR[color]
end




--获得指定物品的奖励数量
function  QiandaoConf:getCount(dateOffset,mid)
	-- body
	local rewards = self.get1DayData(dateOffset)
	if not rewards then
		return 0
	end


	for k,v in pairs(rewards) do
		if type(v) == "table" then
			for k1,v1 in pairs(v) do
				print(k1,v1)
			end
		end
	end
end

--获得 dateOffset 天的奖励类别数
function QiandaoConf:getReWardKindsByDayOffset(dateOffset)

	local data = self:get1DayData(dateOffset)

	if not data then
		--todo
		return 0
	end

	return #data
end

--获得以当前时间为基础向后推移 dateOffset 天的数据
function QiandaoConf:get1DayData(dateOffset)
	-- body
	local date = self.date + dateOffset
	if date  > 30 and date < 100 then
		--todo
		date = date - 30
	elseif date  > 130 then
		date = date - 130
	end

	local data = self.conf[tostring(date)]

	if not data then
		debugprint("数据为空....")
		return nil
	end

	return data["awards"]
	
end

function  QiandaoConf:setDate( date )
	-- body
	self.date = date
end

function QiandaoConf:getDate( )
	-- body
	return self.date
end

function  QiandaoConf:setAwardState( state )
	-- body
	self.awardState = state
end

function QiandaoConf:getWardState(  )
	-- body

	return self.awardState
end


return QiandaoConf