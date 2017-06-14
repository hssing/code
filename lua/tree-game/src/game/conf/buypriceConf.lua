
local buypriceConf=class("buypriceConf",base.BaseConf)

function buypriceConf:init()
	-- body
	self.conf=require("res.conf.buy_count_price")
end
--跨服战
function buypriceConf:getPriceCross(id)
    -- body
    local price=self.conf[tostring(id)]

    if not price then 
        self:Error(id)
        return nil
    end
   -- printt(price)
    return price.buy_cross
end

--日常副本
function buypriceConf:getPriceDayFuben(id)
    -- body
    local price=self.conf[tostring(id)]

    if not price then 
        self:Error(id)
        return nil
    end
   -- printt(price)
    return price.buy_dayfb
end

function buypriceConf:getPrice(id)
	-- body
	local price=self.conf[tostring(id)]

	if not price then 
		self:Error(id)
		return nil
	end
	return price.buy_tl

end

---竞技场次数消耗
function buypriceConf:getAthleticsPrice(id)
    -- body
    local price=self.conf[tostring(id)]
    if not price then 
        --self:Error(id)
        local p  = 0
        for k , v in pairs(self.conf) do 
            if checkint(v.buy_jjc) > p then
                p = checkint(v.buy_jjc)
            end 
        end
        return p
    end
    return price.buy_jjc
end

---获取爬塔次数消耗
function buypriceConf:getTowerPrice(id)
    local price=self.conf[tostring(id)]
    if not price then 
        local p  = 0
        for k , v in pairs(self.conf) do 
            if checkint(v.buy_pata_rest) > p then
                p = checkint(v.buy_pata_rest)
            end 
        end
        return p
    end
    return price.buy_pata_rest
end

---获取爬塔次数消耗
function buypriceConf:getGuildFBPrice(id)
    local price=self.conf[tostring(id)]
    if not price then 
        local p  = 0
        for k , v in pairs(self.conf) do 
            if checkint(v.buy_guild_fb_count) > p then
                p = checkint(v.buy_guild_fb_count)
            end 
        end
        return p
    end
    return price.buy_guild_fb_count
end

function buypriceConf:getPriceADV(id)
	-- body
	local price=self.conf[tostring(id)]

	if not price then 
		self:Error(id)
		return nil
	end
	return price.buy_tx
end

function buypriceConf:getPriceMax()
	-- body
	local price  = 0  
	for k , v in pairs(self.conf) do 
		if checkint(v.buy_tl) > price then
			price = checkint(v.buy_tl)
		end 
	end 
	return price
end
--招财价格
function buypriceConf:getZhaocai( id )
    -- body
    local price=self.conf[tostring(id)]

    if not price then 
        self:Error(id)
        return nil
    end
    return price.buy_zhaocai
end

function buypriceConf:getZhaocaiMax()
    -- body
    local price  = 0  
    for k , v in pairs(self.conf) do 
        if checkint(v.buy_zhaocai) > price then
            price = checkint(v.buy_zhaocai)
        end 
    end 
    return price
end

return buypriceConf