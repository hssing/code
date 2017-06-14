--
-- Author: chenlu_y
-- Date: 2015-12-09 11:43:21
--
local ConsumeGiftProxy = class("ConsumeGiftProxy",base.BaseProxy)

function ConsumeGiftProxy:init()
	-- body
	self:add(516144,self.giftInfo)
	self:add(516145 ,self.getRetuen)
end


--请求消费豪礼显示
function ConsumeGiftProxy:sendMessage()
	self:send(116144)
	self:wait(516144)
end

--消费豪礼领取
function ConsumeGiftProxy:sendBuyMessage(value_)
	print(value_," ***")
	self:send(116145, {gotType=value_})
	self:wait(516145)
end

--消费豪礼信息显示
function ConsumeGiftProxy:giftInfo(data_)
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.CONSUMEGIFT)
		if view then 
			view:setData(data_)
		end
	else
		G_TipsError(data_.status)
	end	
end	

--领取返回
function ConsumeGiftProxy:getRetuen(data_)
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.CONSUMEGIFT)
		if view then 
			view:setGetState(data_)
		end

		--设置红点数量
		cache.Player:_setXfhlRedpoint(cache.Player:getXfhlRedpoint()-1)
		local view = mgr.ViewMgr:get(_viewname.ACTIVITY)
		if view then
			view:setRedPoint()
		end

		local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
		if view then
			view:setRedPoint()
		end

		local alertView = mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		if alertView then
			alertView:setData(data_["items"],true,true)
			alertView:setButtonVisible(false)
			alertView:setSureBtnTile(res.str.HSUI_DESC12)
		end
	else
		print(data_.status," ***********")
		G_TipsError(data_.status)
	end
end	


return ConsumeGiftProxy