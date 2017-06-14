--
-- Author: chenlu_y
-- Date: 2015-12-09 11:43:21
--
local ActiveVipShopProxy = class("ActiveVipShopProxy",base.BaseProxy)

function ActiveVipShopProxy:init()
	-- body
	self:add(516140,self.shopInfo)
	self:add(516141 ,self.buyRetuen)
end


--请求VIP商店信息
function ActiveVipShopProxy:sendMessage()
	self:send(116140)
	self:wait(516140)
end

--购买物品
function ActiveVipShopProxy:sendBuyMessage()
	self:send(116141)
	self:wait(516141)
end

--VIP商店
function ActiveVipShopProxy:shopInfo(data_)
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.ACTIVEVIPSHOP)
		if view then 
			view:setData(data_)
		end
	else
		G_TipsError(data_.status)
	end	
end	

--VIP商店购买返回
function ActiveVipShopProxy:buyRetuen(data_)
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.ACTIVEVIPSHOP)
		if view then 
			view:setBuyState(data_.buySign)
		end

		local alertView = mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		if alertView then
			alertView:setData(data_["items"],true,true)
			alertView:setButtonVisible(false)
			alertView:setSureBtnTile(res.str.HSUI_DESC12)
		end
	else
		G_TipsError(data_.status)
	end
end	


return ActiveVipShopProxy