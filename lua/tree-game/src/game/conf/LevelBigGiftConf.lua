--
-- Author: Your Name
-- Date: 2015-08-03 19:29:24
--


local LevelBigGiftConf = class("LevelBigGiftConf", base.BaseConf)

function LevelBigGiftConf:init( )
	-- body
	self.conf = require("res.conf.level_gift")
	local data = {}
	for i=1,table.nums(self.conf) do
		data[i] = self.conf[i..""]
	end

	self.conf = data
end

function LevelBigGiftConf:getData(  )
	-- body

	return self.conf
end


function LevelBigGiftConf:get(  )
	-- body

end

--获得奖励的名称
function LevelBigGiftConf:getName( mid )
	-- body
	return conf.Item:getName(mid)
end

--获得物品显示的 Icon
function  LevelBigGiftConf:getIcon( mid )
	-- body

	local path = conf.Item:getItemSrcbymid(mid)

	return path
end

-- 获得物品显示的边框 Icon
function LevelBigGiftConf:getFrameIcon( mid )
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
function LevelBigGiftConf:getTextColor(mid)
	-- body
	local  color = conf.Item:getItemQuality(mid)
	return COLOR[color]
end




return LevelBigGiftConf