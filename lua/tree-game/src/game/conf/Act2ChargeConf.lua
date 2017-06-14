--
-- Author: Your Name
-- Date: 2015-11-20 22:20:38
--

local Act2ChargeConf = class("Act2ChargeConf", base.BaseConf)


function Act2ChargeConf:init( )
	-- body
	self.conf1 = require("res.conf.act2_mrdb_conf")
	local data = {}
	for i=1,table.nums(self.conf1) do
		data[i] = self.conf1[(i + 2000)..""]
	end

	self.conf1 = data
	self.conf2 = {}
	local data = require("res.conf.act2_mrlc_conf")
	for i=1,table.nums(data) do
		self.conf2[i] = data[(i + 1000)..""]
	end

	self.conf_month = require("res.conf.month_card")
end

---月卡
function Act2ChargeConf:getMonthItem( id )
	-- body
	return self.conf_month[tostring(id)]
end


function Act2ChargeConf:getDataMRLC(  )
	
	local data = {}
	for i,v in ipairs(self.conf2) do
		if type(v) == "table" then
			local tmp = {}
			for j,v2 in pairs(v) do
				tmp[j] = v2
			end
			data[i] = tmp
		else
			data[i] = v
		end
	end

	return data
end

function Act2ChargeConf:getDataMRDB(  )
	local data = {}
	for i,v in ipairs(self.conf1) do
		if type(v) == "table" then
			local tmp = {}
			for j,v2 in pairs(v) do
				tmp[j] = v2
			end
			data[i] = tmp
		else
			data[i] = v
		end
	end

	return data
end


function Act2ChargeConf:get(  )
	-- body

end

--获得奖励的名称
function Act2ChargeConf:getName( mid )
	-- body
	return conf.Item:getName(mid)
end

--获得物品显示的 Icon
function  Act2ChargeConf:getIcon( mid )
	-- body

	local path = conf.Item:getItemSrcbymid(mid)

	return path
end

-- 获得物品显示的边框 Icon
function Act2ChargeConf:getFrameIcon( mid )
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
function Act2ChargeConf:getTextColor(mid)
	-- body
	local  color = conf.Item:getItemQuality(mid)
	return COLOR[color]
end










return Act2ChargeConf