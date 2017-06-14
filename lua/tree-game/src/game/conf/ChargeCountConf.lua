--
-- Author: Your Name
-- Date: 2015-08-27 11:13:57
--
local ChargeCountConf = class("ChargeCountConf", base.BaseConf)

function ChargeCountConf:init( )
	-- body
	self.conf = require("res.conf.charge_count")
	local data = {}
	for i=1,table.nums(self.conf) do
		data[i] = self.conf[(i + 1000)..""]
	end

	self.conf = data
end

function ChargeCountConf:getData(  )
	-- body
	return self.conf
end


function ChargeCountConf:get(  )
	-- body

end

--获得奖励的名称
function ChargeCountConf:getName( mid )
	-- body
	return conf.Item:getName(mid)
end

--获得物品显示的 Icon
function  ChargeCountConf:getIcon( mid )
	-- body

	local path = conf.Item:getItemSrcbymid(mid)

	return path
end

-- 获得物品显示的边框 Icon
function ChargeCountConf:getFrameIcon( mid )
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
function ChargeCountConf:getTextColor(mid)
	-- body
	local  color = conf.Item:getItemQuality(mid)
	return COLOR[color]
end







return ChargeCountConf