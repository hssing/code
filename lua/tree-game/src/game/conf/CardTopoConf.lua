local CardTopo=class("CardConf",base.BaseConf)

function CardTopo:init(  )
	self.conf=require("res.conf.card_jinjie")
	self.confItem = require("res.conf.card_jinjie_item")
end

function CardTopo:getUseitem( id )
	-- body
	local Card=self.confItem[tostring(id)]
	if not Card then 
		self:Error(id)
		return nil
	end 
	return Card.items
end

function CardTopo:getCostJB( id )
	-- body
	local Card=self.confItem[tostring(id)]
	if not Card then 
		self:Error(id)
		return nil
	end 
	return Card.money_jb
end


function CardTopo:getAtt( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return nil
	end
	return Card.att_102
end

function CardTopo:getHp( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return nil
	end
	return Card.att_105
end

function CardTopo:getPower( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return nil
	end
	return Card.att_305
end

return CardTopo