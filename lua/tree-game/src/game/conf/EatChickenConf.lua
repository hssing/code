--
-- Author: Your Name
-- Date: 2015-07-21 16:41:22
--

local EatChickenConf = class("EatChickenConf", base.BaseConf)

function EatChickenConf:init(  )
	-- body

	self.conf = require("res.conf.eatChicken_conf")

end




--获取活动开始时间
function EatChickenConf:getActTimeStart( id )
	-- body

	return self.conf[id .. ""]["actTime"][1]

end

--获取活动 结束时间
function EatChickenConf:getActTimeEnd( id )
	-- body

	return self.conf[id .. ""]["actTime"][2]

end

-- 获得 时间段 开始时间
function EatChickenConf:getTimeAreaStart( id )
	-- body
	return self.conf[id .. ""]["timeArea"][1]
end

-- 获得 时间段 结束时间
function EatChickenConf:getTimeAreaEnd( id )
	-- body
	return self.conf[id .. ""]["timeArea"][2]
end

function EatChickenConf:get(  )
	-- body
end







return EatChickenConf