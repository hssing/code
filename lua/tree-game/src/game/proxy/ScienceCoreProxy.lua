--
-- Author: chenlu_y
-- Date: 2015-12-12 16:05:37
--
local ScienceCoreProxy = class("ScienceCoreProxy",base.BaseProxy)

function ScienceCoreProxy:init()
	self:add(527001,self.add_527001)--请求数码兽魔书
	self:add(527002,self.add_527002)
	self:add(527003,self.add_527003)
	self:add(527004,self.add_527004)
	self:add(527005,self.add_527005)
end

function ScienceCoreProxy:send_127001()
	-- body
	self:send(127001)
	self:wait(527001)
end

function ScienceCoreProxy:send_127002(param)
	-- body
	printt(param)
	self:send(127002,param)
	self:wait(527002)
end

function ScienceCoreProxy:send_127003(param)
	-- body
	printt(param)
	self:send(127003,param)
	self:wait(527003)
end

function ScienceCoreProxy:send_127004(param)
	-- body
	printt(param)
	self:send(127004,param)
	self:wait(527004)
end

function ScienceCoreProxy:send_127005(param)
	-- body
	printt(param)
	self:send(127005,param)
	self:wait(527005)
end

--请求数码兽魔书
function ScienceCoreProxy:add_527001(data_)
	-- body
	if data_.status == 0 then 
		
		cache.Science:setDataMsg(data_)
		local view = mgr.ViewMgr:get(_viewname.SCIENCECORE)
		if view then
			view:setData(data_)
		else
			local view1 = mgr.ViewMgr:showView(_viewname.SCIENCECORE)
			view1:setData(data_)
		end
	else
		G_TipsError( data_.status)
	end
end
--请求数码兽魔书收藏
function ScienceCoreProxy:add_527002(data_)
	-- body
	if data_.status == 0 then 
		cache.Science:setCardinfo(data_)
		local view = mgr.ViewMgr:get(_viewname.DEVOUR)
		if view then
			view:updateCurrshow(data_)
		end
		
	else
		G_TipsError( data_.status)
	end
end

--吞噬
function ScienceCoreProxy:add_527003(data_)
	-- body
	if data_.status == 0 then 
		--获得道具
		local view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		view:setData(self:getItem(data_.items),nil,true)
		view:setButtonVisible(false)
		--吞噬界面
		cache.Science:setinfoData(data_)
		local view = mgr.ViewMgr:get(_viewname.DEVOUR)
		if view then
			view:updateCurrshow(data_)
		end
		--刷新科技入口界面
		local view1 = mgr.ViewMgr:get(_viewname.SCIENCECORE) 
		if view1 then
			view1:setData(cache.Science:getData())
		end
	else
		G_TipsError( data_.status)
	end
end

--请求数码兽魔书取出
function ScienceCoreProxy:add_527004(data_)
	-- body
	if data_.status == 0 then 
		cache.Science:setCardinfo(data_)
		--获得道具
		local view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		view:setData(self:getItem(data_.items),nil,true)
		view:setButtonVisible(false)
		
		local view = mgr.ViewMgr:get(_viewname.DEVOUR)
		if view then
			view:updateCurrshow(data_)
		end
	else
		G_TipsError( data_.status)
	end
end
--请求数码兽魔书星级奖励
function ScienceCoreProxy:add_527005(data_)
	-- body
	if data_.status == 0 then 
		--获得道具
		local view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		view:setData(self:getItem(data_.items),nil,true)
		view:setButtonVisible(false)
		
		cache.Science:setDatainfo(data_)
		local view = mgr.ViewMgr:get(_viewname.SCIENCECORE)
		if view then
			view:setData(cache.Science:getData())
		end
	else
		G_TipsError( data_.status)
	end
end


function ScienceCoreProxy:getItem( data )
	-- body
	local t = {}
	for k , v in pairs(data) do 
		if conf.Item:getType(v.mId) == pack_type.SPRITE then
			local tt = cache.Pack:getTypePackInfo(pack_type.SPRITE)[v.index]
			if tt then 
				table.insert(t,tt)
			end
		else
		 	table.insert(t,v)
		end 
		
	end
	return t
end


return ScienceCoreProxy