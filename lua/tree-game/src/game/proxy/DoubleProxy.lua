--[[
	--双11 活动
]]

local DoubleProxy = class("DoubleProxy",base.BaseProxy)

function DoubleProxy:init()
	-- body
	self:add(516067,self.RechargeMsgCallBack) --累计充值信息
	self:add(516068,self.RechargeMsgGetCallBack) --累计充值领去

	self:add(516069,self.SignCallBack) --签到信息
	self:add(516070,self.SingGetCallBack)--签到奖励领取

	self:add(516072,self.ChouMsgCallBack)
	self:add(516073,self.ChouRewardCallBack)
end
---累计充值信息
function DoubleProxy:RechargeMsgCallBack(data_)
	-- body
	if data_.status == 0 then 
		local view  = mgr.ViewMgr:get(_viewname.DOUBLE)
		if view then 
			view:severRechage(data_)
		end
	else
		debugprint("充值信息未返回")
	end
end
--累计充值信息 请求
function DoubleProxy:send116067(param)
	-- body
	self:send(116067,param)
end
--累计充值 领取
function DoubleProxy:RechargeMsgGetCallBack(data_)
	-- body
	if data_.status == 0 then 
		local count =   cache.Player:get11Redpoint()-1
		if count < 0 then 
			count = 0
		end
		cache.Player:_set11Redpoint(count)

		local _view = mgr.ViewMgr:get(_viewname.MAIN)
		if _view then
			_view:setRedPoint()
		end


		local view  = mgr.ViewMgr:get(_viewname.DOUBLE)
		if view then 
			view:updateSeverRechage(data_)
		end
	elseif data_.status ==21030001 then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	else
		debugprint("领取失败")
	end
end

function DoubleProxy:send116068(param)
	-- body
	self:send(116068,param)
end
------
function DoubleProxy:send116069()
	-- body
	self:send(116069)
end

function DoubleProxy:SignCallBack( data_ )
	-- body
	if data_.status == 0 then 
		
		
		local view  = mgr.ViewMgr:get(_viewname.DOUBLE)
		if view then 
			view:serverSign(data_)
		end
	
	else
		debugprint("签到信息")
	end
end

function DoubleProxy:send116070()
	-- body
	self:send(116070)
end

function DoubleProxy:SingGetCallBack(data_ )
	-- body
	if data_.status == 0 then 
		local count =   cache.Player:get11Redpoint()-1
		if count < 0 then 
			count = 0
		end
		cache.Player:_set11Redpoint(count)

		local _view = mgr.ViewMgr:get(_viewname.MAIN)
		if _view then
			_view:setRedPoint()
		end

		
		local view  = mgr.ViewMgr:get(_viewname.DOUBLE)
		if view then 
			view:serverUpdateSign(data_)
		end
	elseif data_.status ==21030001 then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	else
		debugprint("签到信息刷新")
	end
end
--------------------------------------------------抽奖信息

function DoubleProxy:send116072()
	-- body
	self:send(116072)
end

function DoubleProxy:ChouMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		local view  = mgr.ViewMgr:get(_viewname.DOUBLE)
		if view then 
			view:severChouCallBack(data_)
		end
	else
		debugprint("抽奖信息")
	end
end


function DoubleProxy:send116073( param)
	-- body
	self:send(116073,param)
end

function DoubleProxy:ChouRewardCallBack( data_ )
	-- body
	if data_.status == 0 then 
		local view  = mgr.ViewMgr:get(_viewname.DOUBLE)
		if view then 
			view:updateChouInfo(data_)
		end
	elseif data_.status ==21030001 then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	else
		debugprint("抽奖信息")
	end
end

return DoubleProxy


