
local CardGift=class("CardGift",base.BaseConf)

function CardGift:init(  )
    self.conf=require("res.conf.card_tianfu")
end



function CardGift:getGiftName(id)
	local gift=self.conf[tostring(id)]
	if gift then
		return gift.name
	else
		self:Error(id)
	end
	return 0
end
function CardGift:getDescription(id)
	local gift=self.conf[tostring(id)]
	if gift then
		return gift.des
	else
		self:Error(id)
	end
	return 0
end

function CardGift:getProadd( id )
	-- body
	--
	local gift=self.conf[tostring(id)]
	if gift and gift.prop_affect then
		return gift.prop_affect[1]
	else
		self:Error(id)
	end
	return 0
end

return CardGift
