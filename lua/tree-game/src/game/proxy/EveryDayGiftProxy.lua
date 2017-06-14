--
-- Author: chenlu_y
-- Date: 2015-12-09 11:43:21
--
local EveryDayGiftProxy = class("EveryDayGiftProxy",base.BaseProxy)

function EveryDayGiftProxy:init()
	-- body
	self:add(516142,self.giftInfo)
	self:add(516143 ,self.getRetuen)
end


--请求天天豪礼显示
function EveryDayGiftProxy:sendMessage()
	self:send(116142)
	self:wait(516142)
end

--天天豪礼领取
function EveryDayGiftProxy:sendBuyMessage()
	self:send(116143)
	self:wait(516143)
end

--天天豪礼信息显示
function EveryDayGiftProxy:giftInfo(data_)
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.EVERYDAYGIFT)
		if view then 
			view:setData(data_)
		end
	else
		G_TipsError(data_.status)
	end	
end	

--领取返回
function EveryDayGiftProxy:getRetuen(data_)
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.EVERYDAYGIFT)
		if view then 
			view:setGetState(data_.lastAwardTime)
		end

		--设置红点数量
		cache.Player:_setTthlRedpoint(cache.Player:getTthlRedpoint()-1)
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
		G_TipsError(data_.status)
	end
end	


return EveryDayGiftProxy