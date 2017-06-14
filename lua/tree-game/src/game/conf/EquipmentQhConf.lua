local EquipmentQhConf=class("EquipmentQhConf",base.BaseConf)

function EquipmentQhConf:init(  )
    self.conf=require("res.conf.card_equip_qianghua")
end

function EquipmentQhConf:isExist(id)
	-- body
	local qh=self.conf[tostring(id)]
	return qh and true or false
end


function EquipmentQhConf:getAtk( id)
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.att_102 and qh.att_102 or 0
	else
		self:Error(id)
	end
	return 0
end
--消耗金币
function EquipmentQhConf:getJb( id)
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.money_jb and qh.money_jb or 0
	else
		self:Error(id)
	end
	return 0
end
function EquipmentQhConf:getCrit( id)
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.att_107 and qh.att_107 or 0
	else
		self:Error(id)
	end
	return 0
end
function EquipmentQhConf:getDef( id)
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.att_103 and qh.att_103 or 0
	else
		self:Error(id)
	end
	return 0
end
function EquipmentQhConf:getHp( id)
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.att_105 and qh.att_105 or 0
	else
		self:Error(id)
	end
	return 0
end
--战斗力
function EquipmentQhConf:getPower(id)
	-- body
	local qh=self.conf[tostring(id)]
	if qh then
		return qh.power and qh.power or 0
	else
		self:Error(id)
	end
	return 0
end
return EquipmentQhConf