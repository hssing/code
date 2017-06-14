
local CardExp=class("CardExp",base.BaseConf)

function CardExp:init(  )
    self.conf=require("res.conf.card_up_level_exp")
end



function CardExp:getExp( Quality ,lv)
	local exp_id=Quality + lv
	local c_exp=self.conf[tostring(exp_id)]
	if c_exp then
		return c_exp.att_101
	else
		self:Error(exp_id)
	end
	return 0
end
function CardExp:getAtk( Quality ,lv )
	local exp_id=Quality + lv
	local c_exp=self.conf[tostring(exp_id)]

	if not c_exp then 
		self:Error(id)
		return nil
	end
	return c_exp.att_102
end
function CardExp:getHp( Quality ,lv )
	local exp_id=Quality + lv
	local c_exp=self.conf[tostring(exp_id)]

	if not c_exp then 
		self:Error(id)
		return nil
	end
	return c_exp.att_105
end
function CardExp:getPower( Quality ,lv )
	local exp_id=Quality + lv
	print("id"..exp_id)
	local c_exp=self.conf[tostring(exp_id)]

	if not c_exp then 
		self:Error(id)
		return nil
	end
	return c_exp.att_305
end

return CardExp
