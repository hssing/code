

local AdventureConf=class("AdventureConf",base.BaseConf)

function AdventureConf:init()
	-- body
	self.conf=require("res.conf.adventure")
end

--boss 的名字
function AdventureConf:getbossName( id)
	-- body
	local Adventure=self.conf[tostring(id)]
	if not Adventure then 
		self:Error(id)
		return nil
	end
	return Adventure.boosname
end
--boss 最大气血
function AdventureConf:getbossmaxHp( id )
	-- body
	local Adventure=self.conf[tostring(id)]

	if not Adventure then 
		self:Error(id)
		return nil
	end
	return Adventure.maxHp
end
--形象
function AdventureConf:getbossSrc( id )
	-- body
	local Adventure=self.conf[tostring(id)]

	if not Adventure then 
		self:Error(id)
		return nil
	end
	return Adventure.src
end
--受伤说话
function AdventureConf:getHurtSay(id)
	-- body
	local Adventure=self.conf[tostring(id)]

	if not Adventure then 
		self:Error(id)
		return nil
	end
	return Adventure.hurt
end
--死亡说话
function AdventureConf:getdieSay(id)
	-- body
	local Adventure=self.conf[tostring(id)]

	if not Adventure then 
		self:Error(id)
		return nil
	end
	return Adventure.die
end
--平常状态说话
function AdventureConf:getnormalSay( id )
	-- body
	local Adventure=self.conf[tostring(id)]

	if not Adventure then 
		self:Error(id)
		return nil
	end
	return Adventure.normal
end
return AdventureConf 