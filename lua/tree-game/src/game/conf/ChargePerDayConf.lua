--
-- Author: Your Name
-- Date: 2015-08-27 11:34:41
--
local ChargePerDayConf = class("ChargePerDayConf", base.BaseConf)


function ChargePerDayConf:init( )
	-- body
	self.conf = require("res.conf.charge_per_day")
	local data = {}
	for i=1,table.nums(self.conf) do
		data[i] = self.conf[i..""]
	end

	self.conf = data
end

function ChargePerDayConf:getData(  )
	-- body
	return self.conf
end


function ChargePerDayConf:get(  )
	-- body

end

--获得奖励的名称
function ChargePerDayConf:getName( mid )
	-- body
	return conf.Item:getName(mid)
end

--获得物品显示的 Icon
function  ChargePerDayConf:getIcon( mid )
	-- body

	local path = conf.Item:getItemSrcbymid(mid)

	return path
end

-- 获得物品显示的边框 Icon
function ChargePerDayConf:getFrameIcon( mid )
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
function ChargePerDayConf:getTextColor(mid)
	-- body
	local  color = conf.Item:getItemQuality(mid)
	return COLOR[color]
end






return ChargePerDayConf