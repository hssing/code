
local CardConf=class("CardConf",base.BaseConf)

function CardConf:init(  )
	self.conf=require("res.conf.card")
	self.hcheng = require("res.conf.card_equip_hecheng")

	self.friendcard = require("res.conf.friend_card")
	
end

function CardConf:getCardFriend(id)
	-- body
	return self.friendcard[tostring(id)]
end

function CardConf:getImageSrc( id )
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return nil
	end
	return Card.img_src
end
function CardConf:getModel( id )
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return nil
	end
	return Card.res_id
end
function CardConf:getSkill(id )
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return nil
	end
	return Card.skills
end
function CardConf:getName( id )
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return nil
	end
	return Card.name
end

function CardConf:getAtt( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return 0
	end
	return Card.att_102
end

function CardConf:getdefence(id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return 0
	end
	return Card.att_103
end

function CardConf:getHp( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return 0
	end
	return Card.att_105
end
--暴击率
function CardConf:getCri( id )
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return 0
	end
	return Card.att_106
end
--抗暴率
function CardConf:getDefCri( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return 0
	end
	return Card.att_108
end
--暴击伤害
function CardConf:getHurtCri( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return 0
	end
	return Card.att_107
end
--命中率
function CardConf:getMingzhong( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return 0
	end
	return Card.att_110
end
--闪避率
function CardConf:getShangBi( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return 0
	end
	return Card.att_109
end
--眩晕
function CardConf:getXuanyun( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return 0
	end
	return Card.att_112
end
--抗晕
function CardConf:getDefXuanyun	( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return 0
	end
	return Card.att_113
end

--战斗力
function CardConf:getPower( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return 0
	end
	return Card.att_114
end

--破甲
function CardConf:getPojia( id )
	-- body
	local Card=self.conf[tostring(id)]

	if not Card then 
		self:Error(id)
		return 0
	end
	return Card.att_115
end


--合成消耗
function CardConf:getCost( id )
	-- body
	local Card=self.hcheng[tostring(id)]

	if not Card then 
		self:Error(id)
		return nil
	end
	return Card.money_jb
end

---说话
function CardConf:getSpeak(id_)
		local card = self.conf[tostring(id_)]
		if not card then 
				self:Error(id)
				return nil
		end
		return card.fight_speak
end

return CardConf