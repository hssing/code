local EquipmentJhConf=class("EquipmentJhConf",base.BaseConf)

function EquipmentJhConf:init(  )
    self.conf=require("res.conf.card_equip_jinglian")
end

function EquipmentJhConf:isExist(id)
	-- body
	local qh=self.conf[tostring(id)]
	return qh and true or false
end

function EquipmentJhConf:getPower( id)
	local qh=self.conf[tostring(id)]
	if qh then
		local r = qh.att_305 and qh.att_305 or 0
		return r
	else
		self:Error(id)
	end
	return 0
end


function EquipmentJhConf:getAtk( id)
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.att_102  and qh.att_102 or 0
	else
		self:Error(id)
	end
	return 0
end
function EquipmentJhConf:getCrit( id)
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.att_107 and qh.att_107 or 0
	else
		self:Error(id)
	end
	return 0
end
--消耗金币
function EquipmentJhConf:getJb( id)
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.money_jb and qh.money_jb or 0
	else
		self:Error(id)
	end
	return 0
end
function EquipmentJhConf:getHp( id)
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.att_105 and qh.att_105 or 0
	else
		self:Error(id)
	end
	return 0
end
function EquipmentJhConf:getMz( id )
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.att_110 and qh.att_110 or 0
	else
		self:Error(id)
	end
	return 0
end
--暴击伤害
function EquipmentJhConf:getCrithurt( id )
	-- body
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.att_107 and qh.att_107 or 0
	else
		self:Error(id)
	end
	return 0
end

--抗暴率
function EquipmentJhConf:getdefCrit( id )
	-- body
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.att_108 and qh.att_108 or 0
	else
		self:Error(id)
	end
	return 0
end

function EquipmentJhConf:getDodge( id )
	-- body
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.att_109 and qh.att_109 or 0
	else
		self:Error(id)
	end
	return 0
	
end


return EquipmentJhConf