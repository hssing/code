--
-- Author: Your Name
-- Date: 2015-08-27 11:19:07
--
local CrazyFeedBackConf = class("CrazyFeedBackConf", base.BaseConf)


function CrazyFeedBackConf:init( )
	-- body
	self.conf = require("res.conf.crazy_feed_back")
	local data = {}
	for i=1,table.nums(self.conf) do
		data[i] = self.conf[(i + 2000)..""]
	end

	self.conf = data
end

function CrazyFeedBackConf:getData(  )
	-- body
	return self.conf
end


function CrazyFeedBackConf:get(  )
	-- body

end

--获得奖励的名称
function CrazyFeedBackConf:getName( mid )
	-- body
	return conf.Item:getName(mid)
end

--获得物品显示的 Icon
function  CrazyFeedBackConf:getIcon( mid )
	-- body

	local path = conf.Item:getItemSrcbymid(mid)

	return path
end

-- 获得物品显示的边框 Icon
function CrazyFeedBackConf:getFrameIcon( mid )
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
function CrazyFeedBackConf:getTextColor(mid)
	-- body
	local  color = conf.Item:getItemQuality(mid)
	return COLOR[color]
end






return CrazyFeedBackConf