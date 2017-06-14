
local CrossProxy = class("CrossProxy", base.BaseProxy)

function CrossProxy:init()
	-- body
	self:add(522001,self.add_522001)
	self:add(522002,self.add_522002)
	self:add(522003,self.add_522003)
	self:add(522004,self.add_522004)
	self:add(522005,self.add_522005)
	self:add(522006,self.add_522006)
	--------------------------------

	self:add(523001,self.add_523001)--请求跨服战信息(返回)
	self:add(523002,self.add_523002)--请求单人排位战绩(返回)
	self:add(523003,self.add_523003)--请求跨服战信息(返回)
	self:add(523005,self.add_523005)--对比
	self:add(523006,self.add_523006)--请求王者排名
	self:add(523007,self.add_523007)--请求最强王者膜拜信息
	self:add(523008,self.add_523008)--请求最强王者膜拜
	self:add(523009,self.add_523009)--请求跨服竞猜信息
	self:add(523010,self.add_523010)--竞猜
	self:add(523011,self.add_523011)--留言返回
	self:add(523012,self.add_523012)--对比数码兽信息
	self:add(523014,self.add_523014) --录像列表
end
function CrossProxy:send_123001()
	-- body
	self:send(123001)
	self:wait(523001)
end

function CrossProxy:send_123002()
	-- body
	self:send(123002)
	self:wait(523002)
end

function CrossProxy:send_123003()
	-- body
	self:send(123003)
	self:wait(523003)
end

function CrossProxy:send_123005(param)
	-- body
	printt(param)
	self:send(123005,param)
	self:wait(523005)
end

function CrossProxy:send_123006()
	-- body
	self:send(123006)
	self:wait(523006)
end

function CrossProxy:send_123007()
	-- body
	self:send(123007)
	self:wait(523007)
end

function CrossProxy:send_123008()
	-- body
	self:send(123008)
	self:wait(523008)
end

function CrossProxy:send_123009(param)
	-- body
	self:send(123009,param)
	self:wait(523009)
end

function CrossProxy:send_123010( param )
	-- body
	printt(param)
	self:send(123010,param)
	self:wait(523010)
end

function CrossProxy:send_123011( param )
	-- body
	printt(param)
	self.bbstr = param.bbStr
	self:send(123011,param)
	self:wait(523011)
end

function CrossProxy:send_123012( param )
	-- body
	printt(param)
	self:send(123012,param)
	self:wait(523012)
end

function CrossProxy:send_123014( param )
	-- body
	printt(param)
	self:send(123014,param)
	self:wait(523014)
end

function CrossProxy:add_523011( data_ )
	-- body
	if data_.status == 0  then
		local view = mgr.ViewMgr:get(_viewname.CROSS_WIN_COMPARE)
		if view then
			view:updateWold(self.bbstr)
		end
	else
		G_TipsError(data_.status)
	end
end

function CrossProxy:add_523010( data_ )
	-- body
	if data_.status == 0  then
		local view = mgr.ViewMgr:get(_viewname.CROSS_WIN_COMPARE)
		if view then
			view:updateSelfab(data_)
		else
			view= mgr.ViewMgr:showView(_viewname.CROSS_WIN_COMPARE)
			view:updateSelfab(data_)
		end
	else
		G_TipsError(data_.status)
	end
end

--请求跨服竞猜信息
function CrossProxy:add_523009(data_ )
	-- body
	if data_.status == 0  then
		local view = mgr.ViewMgr:get(_viewname.CROSS_WIN_COMPARE)
		if view then
			view:setServerData(data_)
		else
			view= mgr.ViewMgr:showView(_viewname.CROSS_WIN_COMPARE)
			view:setServerData(data_)
		end
	else
		G_TipsError(data_.status)
	end
end

--请求跨服战信息(返回)
function CrossProxy:add_523001(data_)
	-- body
	if data_.status == 0 or 21500101 == data_.status then
		cache.Cross:setKFdata(data_)
		local view = mgr.ViewMgr:get(_viewname.CROSS_WAR_MAIN)
		if view then
			view:setData(data_,true)
		else
			view= mgr.ViewMgr:showView(_viewname.CROSS_WAR_MAIN)
			view:setData(data_,true)
		end
	else
		G_TipsError(data_.status)
	end
end
--请求单人排位战绩(返回)
function CrossProxy:add_523002( data_)
	-- body
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.CROSS_RANK) --CROSS_VEDIO
		if view then
			view:setData(data_)
		end
	else
		G_TipsError(data_.status)
	end
end

--请求跨服战信息(返回)
function CrossProxy:add_523003( data_)
	-- body
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.CROSS_VEDIO)
		if view then
			view:setData(data_)
		end
	else
		G_TipsError(data_.status)
	end
end
--请求阵容对比返回
function CrossProxy:add_523005(data_)
	-- body
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.CROSS_VEDIO)
		if view then 
			view:comPareCalllBack(data_)
		end 

		--[[local view = mgr.ViewMgr:get(_viewname.CROSS_WIN_MOBAO)
		if view then 
			view:comPareCalllBack(data_)
		end ]]--

		local view = mgr.ViewMgr:get(_viewname.CROSS_WIN_COMPARE)
		if view then 
			view:comPareCalllBack(data_)
		end 
	else
		G_TipsError(data_.status)
	end
end

--请求王者排名
function CrossProxy:add_523006( data_ )
	-- body
	if data_.status == 0 then
		cache.Cross:setWinData(data_)

		local view = mgr.ViewMgr:get(_viewname.CROSS_WIN_WAR)
		if view then
			view:setData(data_)
		else
			view= mgr.ViewMgr:showView(_viewname.CROSS_WIN_WAR)
			view:setData(data_)
		end
	else
		G_TipsError(data_.status)
	end
end
--膜拜界面
function CrossProxy:add_523007( data_ )
	-- body
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.CROSS_WIN_MOBAO)
		if view then
			view:setData(data_)
		else
			view= mgr.ViewMgr:showView(_viewname.CROSS_WIN_MOBAO)
			view:setData(data_)
		end
	else
		G_TipsError(data_.status)
	end
end
--膜拜信息返回
function CrossProxy:add_523008( data_ )
	-- body
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.CROSS_WIN_MOBAO)
		if view then
			view:setserverData(data_)
		end
	else
		G_TipsError(data_.status)
	end
end

function CrossProxy:add_523012( data_ )
	-- body
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.OTHER_VIEW)
		if data_.cardInfo.mId == 0 then
			if view then 
				view:onCloseSelfView()
			end
			G_TipsOfstr(res.str.RES_RES_75)
			return
		end

		local view = mgr.ViewMgr:get(_viewname.OTHER_VIEW)
	    if view then 
	    	view:setServerBack(data_)
	    end
	else
		G_TipsError(data_.status)
	end
end

function CrossProxy:add_523014( data_ )
	-- body
	if data_.status == 0  then
		local view = mgr.ViewMgr:get(_viewname.CROSS_VIDEO_TRUE)
		if view then
			view:setData(data_)
		end
	else
		G_TipsError(data_.status)
	end
end

---------------------------------神魂猎命
function CrossProxy:send_122001() --请求神魂猎命显示数据
	-- body
	self:send(122001)
end
--opType	说明：操作类型，1表示10连抽，0表示默认
function CrossProxy:send_122002( param ) --请求神魂猎命抽奖
	-- body
	printt(param)
	self:send(122002,param)
end

function CrossProxy:send_122003()--请求神魂猎命召唤龙珠
	-- body
	self:send(122003)
end

function CrossProxy:send_122004()--请求神魂猎命卖出
	-- body
	self:send(122004,param)
end

function CrossProxy:send_122005()--神魂猎命获取
	-- body
	self:send(122005,param)
end

function CrossProxy:send_122006(param)
	-- body
	printt(param)
	self:send(122006,param)
	self:wait(522006)
end

--请求神魂猎命显示数据(返回)
function CrossProxy:add_522001( data_ )
	-- body
	if data_.status == 0 then
		cache.Cross:setSh_Data(data_)
		local view = mgr.ViewMgr:get(_viewname.CROSS_WAR_XIN)
		if view then
			view:setData(data_)
		else
			view= mgr.ViewMgr:showView(_viewname.CROSS_WAR_XIN)
			view:setData(data_)
		end
	else
		G_TipsError(data_.status)
	end
end
--请求神魂猎命抽奖(返回)
function CrossProxy:add_522002( data_ )
	-- body
	if data_.status == 0 then
		cache.Cross:updateSh_data(data_)
		local view = mgr.ViewMgr:get(_viewname.CROSS_WAR_XIN)
		if view then
			view:serverChouCall(data_)
			--[[view:setSh(data_.resNum)
			view:setLZ(data_.lzId)
			view:addItem(data_.gots)]]--
		end 
	else
		G_TipsError(data_.status)
	end
end
--请求神魂猎命召唤龙珠(返回)
function CrossProxy:add_522003( data_ )
	-- body
	if data_.status == 0 then
		cache.Cross:updateSh_data(data_)
		local view = mgr.ViewMgr:get(_viewname.CROSS_WAR_XIN)
		if view then
			view:setLzCallBack(data_)
			--view:setLZ(data_.lzId)
		end
	else
		G_TipsError(data_.status)
	end
end
----请求神魂猎命卖出(返回)
function CrossProxy:add_522004( data_ )
	-- body
	if data_.status == 0 then
		local oldsh = cache.Cross:getShValue()
		
		if checkint(data_.resNum)  > 0 then
			local var =  data_.resNum - oldsh
			if var > 0 then
				G_TipsOfstr(string.format(res.str.RES_RES_25,var))
			end
		end
		cache.Cross:delete_data(data_)
		local view = mgr.ViewMgr:get(_viewname.CROSS_WAR_XIN)
		if view then
			view:setSh(data_.resNum)
			view:removeItem(data_)
		end
	else
		G_TipsError(data_.status)
	end
end
--请求神魂猎命获取(返回)
function CrossProxy:add_522005( data_ )
	-- body
	if data_.status == 0 then
		cache.Cross:delete_data(data_)
		local view = mgr.ViewMgr:get(_viewname.CROSS_WAR_XIN)
		if view then
			view:removeItem(data_)

			G_TipsOfstr(res.str.DUI_DEC_93)
			--弹出获得界面
			--[[local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
			if not view then
				view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
				view:setData(data_.changeList,false,true,true)
				view:setButtonVisible(false)
			end]]--
		end
	else
		G_TipsError(data_.status)
	end
end

function CrossProxy:add_522006(data_)
	-- body
	if data_.status == 0 then
		cache.Cross:update_spNum(data_.spNum)
		local view = mgr.ViewMgr:get(_viewname.CROSS_XIN_DUIHUAN)
		if view then
			view:setData()

			--G_TipsOfstr(res.str.DUI_DEC_93)
			--弹出获得界面
			local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
			if not view then
				view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
				view:setData(data_.gots,false,true,true)
				view:setButtonVisible(false)
			end
		end
	else
		G_TipsError(data_.status)
	end
end
-----------------------------------------------

return CrossProxy