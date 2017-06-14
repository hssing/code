--
-- Author: Your Name
-- Date: 2015-08-27 20:52:05
--

local ActiveProxy = class("ActiveProxy", base.BaseProxy)

function ActiveProxy:init(  )
	-- body
	self:add(516071,self.reqSwitchStateCallback)

	self:add(516136,self.add_516136) --月卡活动信息
	self:add(516137,self.add_516137) --月卡领取
	self:add(516146,self.add_516146) --天降钻石

	self:add(516151,self.add_516151) --7星充值 100元那个
	self:add(516152,self.add_516152)

	--福袋
	self:add(516155,self.add_516155) --请求福袋活动的状态(返回)
	self:add(516154,self.add_516154) --请求刷新福袋
	self:add(516153,self.add_516153) --请求福袋抽奖
	--登录红包
	self:add(516161,self.add_516161) --请求登录红包状态(返回)
	self:add(516160,self.add_516160) --抽取一次

	self.jumpId = nil 
	self.actType = 1
end

function ActiveProxy:send_116136()
	-- body
	self:send(116136)
	self:wait(516136)
end

function ActiveProxy:send_116137(param)
	-- body
	printt(param)
	self:send(116137,param)
	self:wait(516137)
end

function ActiveProxy:add_516136(data_)
	-- body
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.ACTIVEMONTH)
		if view then
			view:setData(data_)
		end

		--限时活动内月卡显示
		local view = mgr.ViewMgr:get(_viewname.ACT2MONTHCARD)
		if view then
			view:setData(data_)
		end

	else
		G_TipsError(data_.status)
	end
end

function ActiveProxy:add_516137(data_)
	-- body
	if data_.status == 0 then
		G_TipsOfzs(res.str.DUI_DEC_81,data_.gotZs)
		if cache.Player:getMonth()~=3 then
			local count = cache.Player:getMonth() - 1
			if count < 0 then
				cache.Player:_setMonth(0)
			else
				cache.Player:_setMonth(count)
			end
		end
		local _view = mgr.ViewMgr:get(_viewname.ACTIVITY)
		if _view then
			_view:setRedPoint()
		end

		local view = mgr.ViewMgr:get(_viewname.ACTIVEMONTH)
		if view then
			view:update(data_)
		end
	else
		G_TipsError(data_.status)
	end
end



-------请求活动开关转态信息
function ActiveProxy:reqSwitchState( jumpId,actType )
	-- body
	print("==========reqSwitchState============")
	if not actType then 
		actType = 1
	end

	local data = {actType = actType}
	self.actType = actType
	self.jumpId = jumpId
	self:send(116071,data)
	self:wait(516071)
end

-------请求活动开关转态信息返回
function ActiveProxy:reqSwitchStateCallback( data )
	-- body
	debugprint("======reqSwitchStateCallback==========")
	--dump(data)
	if data.status == 0 then
		if self.actType == 1 then  --
			if self.jumpId then 
				if data[self.jumpId] == 2 then
					G_TipsOfstr("系统未开放")
					return
				end

				local view = mgr.SceneMgr:getMainScene():changeView(6)
				if view then
					view:setSwitch(data)
					view:nextStep(self.jumpId)
					local maintoplayerview = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
					if maintoplayerview then
					   maintoplayerview.PageButton:initClick(6)
					end
				end
			end
		elseif self.actType == 2 then --双11活动
			cache.Active:keepData(data)
			--
			if not cache.Active:isKey(2001) and not cache.Active:isKey(2002) and not cache.Active:isKey(2003) then 
				debugprint("活动没开")
			end

		elseif self.actType == 3 then --豪礼大放送
			local view = mgr.SceneMgr:getMainScene():changeView(20)
			if self.jumpId then
				if view then
					view:setSwitch(data,true)
				end
				view:nextStep(self.jumpId)
			else
				if view then
					view:setSwitch(data,false)
				end
			end
		end
	end
end

function ActiveProxy:send_116146()
	-- body
	self:send(116146)
	self:wait(516146)
end

function ActiveProxy:add_516146( data )
	-- body
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.ACTIVETIANZS)
		if view then 
			view:setData(data)
		end
	else
		G_TipsError(data.status)
	end
end

function ActiveProxy:send_116147()
	-- body
	self:send(116147)
	self:wait(516146)
end

---
function ActiveProxy:send_116151(param)
	-- body
	self._7r100 = param.actId
	self:send(116151,param)
	self:wait(516151)
end

function ActiveProxy:send_116152(param)
	-- body
	self._7r100_get = param.actId
	self:send(116152,param)
	self:wait(516152)
end

function ActiveProxy:add_516151( data )
	-- body
	if data.status == 0 then
		if self._7r100 == 1018 then 
			local view = mgr.ViewMgr:get(_viewname.ACTIVE100)
			if view then 
				view:setData(data)
			end
		end

		if self._7r100 == 3009 or self._7r100 == 3010 then
			local view = mgr.ViewMgr:get(_viewname.ACTIVE100_1)
			if view then 
				view:setData(data)
			end
		end
	else
		G_TipsError(data.status)
	end
end

function ActiveProxy:add_516152(data )
	-- body
	if data.status == 0 then
		if self._7r100_get == 1018 then 
			local view = mgr.ViewMgr:get(_viewname.ACTIVE100)
			if view then 
				view:update(data)
			end

			cache.Player:_set100(3)
			local _view = mgr.ViewMgr:get(_viewname.ACTIVITY)
			if _view then
				_view:setRedPoint()
			end

		end

		--设置活动2 红点
		cache.Player:_setRichRankNumber(cache.Player:getRichRankNumber() - 1)

		if self._7r100_get == 3009 or self._7r100_get == 3010 then 
			local view = mgr.ViewMgr:get(_viewname.ACTIVE100_1)
			if view then 
				view:update(data)
			end
		end
	else
		G_TipsError(data.status)
	end
end


---------------福袋
function ActiveProxy:send_116155( param )
	-- body
	self:send(116155,param)
	self:wait(516155)
end

function ActiveProxy:add_516155(data)
	-- body
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.ACTIVENEWABAG)
		if view then 
			view:setData(data)
		else
			view = mgr.ViewMgr:showView(_viewname.ACTIVENEWABAG)
			view:setData(data)
		end
	else
		G_TipsError(data.status)
	end
end
--抽一次
function ActiveProxy:send_116153( param )
	-- body
	self:send(116153,param)
	self:wait(516153)
end

function ActiveProxy:add_516153(data)
	-- body
	if data.status == 0 then
		local count = cache.Player:getRichRankNumber()
		if count > 0 then
			count = count - 1 
			if count <=0 then 
				count = 0
			end
			cache.Player:_setRichRankNumber(count)

			local view = mgr.ViewMgr:get(_viewname.MAIN) 
			if view then
				view:setHaoLi()
			end
		end

		local view = mgr.ViewMgr:get(_viewname.ACTIVENEWABAG)
		if view then 
			view:setChouData(data)
		end
	else
		G_TipsError(data.status)
	end
end
--刷新一次
function ActiveProxy:send_116154()
	-- body
	self:send(116154,param)
	self:wait(516154)
end

function ActiveProxy:add_516154(data)
	-- body
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.ACTIVENEWABAG)
		if view then 
			view:setrefData(data)
		end
	else
		G_TipsError(data.status)
	end
end
--------------------hongbao
function ActiveProxy:send_116161()
	-- body
	self:send(116161)
	self:wait(516161)
end

function ActiveProxy:add_516161(data)
	-- body
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.ACTIVENEWARED)
		if view then 
			local count = cache.Player:getRichRankNumber()
			if count >0 then
				count = count - 1
				cache.Player:_setRichRankNumber(count)

				local view = mgr.ViewMgr:get(_viewname.MAIN) 
				if view then
					view:setHaoLi()
				end
			end
			view:setData(data)
		end
	else
		G_TipsError(data.status)
	end
end

function ActiveProxy:send_116160()
	-- body
	self:send(116160)
	self:wait(516160)
end

function ActiveProxy:add_516160(data)
	-- body
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.ACTIVENEWARED)
		if view then 
			view:setSvrData(data)
		end
	else
		G_TipsError(data.status)
	end
end


return ActiveProxy