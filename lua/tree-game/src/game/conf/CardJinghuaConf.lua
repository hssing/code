local CardJinghuaConf=class("ItemConf",base.BaseConf)

function CardJinghuaConf:init(  )
	self.conf = require("res.conf.card_jinhua")
end

function CardJinghuaConf:getAtt( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return nil
	end
	return Card.att_102
end

function CardJinghuaConf:getHp( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return nil
	end
	return Card.att_105
end

function CardJinghuaConf:getPower( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return nil
	end
	return Card.att_305
end

--消耗
function CardJinghuaConf:getcost(id)
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return nil
	end
	return Card.money_jb
end

return CardJinghuaConf