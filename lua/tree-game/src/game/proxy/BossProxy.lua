--[[
	BossProxy
]]--
local BossProxy=class("BossProxy",base.BaseProxy)
--世界boss
function BossProxy:init()
	-- body
	self:add(526002,self.add_526002) -- 请求设置自动参战(返回)
	self:add(526003,self.add_526003)
	self:add(526004,self.add_526004)
	self:add(526005,self.add_526005)
end
--请求设置自动参战
function BossProxy:send_126002(param)
	-- body
	printt(param)
	self:send(126002,param)
	self:wait(526002)
end
--请求世界boss排行榜数据
function BossProxy:send_126003(param)
	-- body
	printt(param)
	self:send(126003,param)
	self:wait(526003)
end
--请求世界boss鼓舞
function BossProxy:send_126004(param)
	-- body
	printt(param)
	self:send(126004,param)
	self:wait(526004)
end
--请求世界boss状态
function BossProxy:send_126005(param)
	-- body
	--printt(param)
	print("我发送消息")
	self:send(126005,param)
	--self:wait(526005)
end

--请求设置自动参战(返回)
function BossProxy:add_526002( data_ )
	-- body
	if data_.status == 0 then
		cache.Boss:setAutoBattle(data_.autoBattle)
		local view = mgr.ViewMgr:get(_viewname.BOSS_MAIN)
		if view then
			view:setAutoBattle(data_.autoBattle)
		end
	else
		G_TipsError(data_.status)
	end
end

--请求世界boss排行榜数据(返回)
function BossProxy:add_526003( data_ )
	-- body
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.BOSS_RANK)
		if view then
			view:setData(data_)
		else
			view = mgr.ViewMgr:showView(_viewname.BOSS_RANK)
			view:setData(data_)
		end
	else
		G_TipsError(data_.status)
	end
end

--请求世界boss鼓舞(返回)
function BossProxy:add_526004( data_ )
	-- body
	if data_.status == 0 then
		cache.Boss:setInspireValue(data_.inspirePercent)

		local view = mgr.ViewMgr:get(_viewname.BOSS_GUWU_REWARD)
		if view then
			view:setData(data_.inspireAwards)
		else
			view = mgr.ViewMgr:showView(_viewname.BOSS_GUWU_REWARD)
			view:setData(data_.inspireAwards)
		end

		local view = mgr.ViewMgr:get(_viewname.BOSS_MAIN)
		if view then
			view:setWorldAddValue(data_.inspirePercent)
		end
	else
		G_TipsError(data_.status)
	end
end

--请求世界boss状态(返回)
function BossProxy:add_526005( data_ )
	-- body
	if data_.status == 0 then
		cache.Boss:setData(data_)
		local view = mgr.ViewMgr:get(_viewname.BOSS_MAIN)
		if view then
			view:setData(data_)
		else
			view = mgr.ViewMgr:showView(_viewname.BOSS_MAIN)
			view:setData(data_)
		end
	else
		G_TipsError(data_.status)
	end
end
return BossProxy
