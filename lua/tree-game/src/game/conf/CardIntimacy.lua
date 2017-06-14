
local CardIntimacy=class("CardIntimacy",base.BaseConf)

function CardIntimacy:init(  )
    self.conf=require("res.conf.card_qinmi")
end

--获得整个列表属性
function CardIntimacy:getIntimacy(id)
	local intimacy=self.conf[tostring(id)]
	if intimacy then
		return intimacy
	else
		self:Error(id)
	end
	return 0
end
--获得所有能触发的列表
function CardIntimacy:getPetList(id)
	local intimacy=self.conf[tostring(id)]
	if intimacy then
		return intimacy.effect_ids
	else
		self:Error(id)
	end
	return 0
end
--获得所有技能名称列表
function CardIntimacy:getSkillName(id)
	local intimacy=self.conf[tostring(id)]
	if intimacy then
		return intimacy.effect_names
	else
		self:Error(id)
	end
	return 0
end
--获得所有属性加成列表
function CardIntimacy:getProperyPlus(id)
	local intimacy=self.conf[tostring(id)]
	if intimacy then
		return intimacy.plus
	else
		self:Error(id)
	end
	return 0
end


return CardIntimacy
