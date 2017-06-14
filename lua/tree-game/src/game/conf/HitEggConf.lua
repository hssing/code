--
-- Author: Your Name
-- Date: 2015-11-12 10:14:53
--


local HitEggConf = class("HitEggConf", base.BaseConf)

function HitEggConf:init(  )
	-- body
	local data =  require("res.conf.special_hit_egg_conf")
	self.conf = {}
	for k,v in pairs(data) do
		table.insert(self.conf, v)
	end

	--排序
	for i=1,#self.conf - 1 do
		for j= i + 1,#self.conf do
			if self.conf[i].money > self.conf[j].money then
				self.conf[i],self.conf[j] = self.conf[j] , self.conf[i]
			end
		end
	end

	
end


function HitEggConf:getMoneyData(  )
	-- body
	return self.conf
end

function HitEggConf:getAwardData(  )
	-- body
	return self.conf["1"].awards
end










return HitEggConf