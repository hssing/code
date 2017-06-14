
--[[
	阵营战
]]

local CampProxy = class("CampProxy",base.BaseProxy)

function CampProxy:init()
	-- body
	self:add(520101,self.MainMsgCallBack)--阵营战活动信息
	self:add(520102,self.addMsgCallBack)--阵营战参战(返回)
	self:add(520103,self.pageMsgCallBack)--查看阵营
	self:add(520104,self.playerMsgCallBack)--求匹配对手(返回)
	self:add(520105,self.buffMsgCallBack)--阵营战鼓舞
	--self:add(520106 ,self.warMsgCallBack)--观看阵营战战报
	self:add(520107,self.closeMsgCallBack) --请求关闭阵营战界面(返回)

	--匹配信息返回
	self:add(818005,self.MsgCallBack)
	--动态信息
	self:add(818004,self.noticeMsgCallBack)
	--个人动态信息
	self:add(520108,self.noticeSelfMsgCallBack)
	--轮空
	self:add(818006,self.NUllMsgCallBack)
end
--阵营战活动信息
function CampProxy:MainMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Camp:keepData(data_)
		--print("data_.selfUserInfo.camp = "..data_.selfUserInfo.camp)
		if data_.selfUserInfo.camp == 0 or data_.timeStatu == 0  then --报名
			local view = mgr.ViewMgr:get(_viewname.CAMP_MIAN)
			if view then 
				view:onCloseSelfView()
			end 	
			local view = mgr.ViewMgr:get(_viewname.CAMP_FIRSTR)
			if view then 
				view:setData()
			else
				view = mgr.ViewMgr:showView(_viewname.CAMP_FIRSTR)
				view:setData()
			end
		else
			local view = mgr.ViewMgr:get(_viewname.CAMP_MIAN)
			if view then 
				view:setData()
			else
				view = mgr.ViewMgr:showView(_viewname.CAMP_MIAN)
				view:setData()
			end
		end
	elseif 21210002 == data_.status then
		G_TipsOfstr(res.str.DEC_ERR_63)
	end
end
function CampProxy:send120101( param )
	-- body
	self:send(120101,param)
end
--阵营战参战
function CampProxy:addMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Camp:updateData(data_)
		local view = mgr.ViewMgr:showView(_viewname.CAMP_SECOND)
		view:setData(data_)
	elseif data_.status == 21210008 then 
		G_TipsOfstr(res.str.DEC_ERR_78)
	elseif 21210002 == data_.status then
		G_TipsOfstr(res.str.DEC_ERR_63)
	end
end
function CampProxy:send120102( param )
	-- body
	self:send(120102,param)
end
--查看阵营
function CampProxy:pageMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		if not self.request then 
			return 
		end
		cache.Camp:keepZhengYing(data_,self.request)
		local view = mgr.ViewMgr:get(_viewname.CAMP_COMPARE)
		if view then 
			view:setData()
		else
			view = mgr.ViewMgr:showView(_viewname.CAMP_COMPARE)
			view:setData()
		end
	elseif data_.status == 21210002 then
		G_TipsOfstr(res.str.DEC_ERR_63)
	end
end
function CampProxy:send120103( param )
	-- body
	if not param.type then
		return 
	end 
	if not param.page then 
		param.page = 1 
	end 
	self.request = param

	local maxpage = cache.Camp:getMaxpageByType(param.type)
	if maxpage and maxpage~=0 and maxpage < param.page then 
		return
	end 
	printt(param)
	self:send(120103,param)
	self:wait(520103)
end
--匹配对手(返回)
function CampProxy:playerMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		if self.param.isMatch == 0 then --取消匹配
			local view = mgr.ViewMgr:get(_viewname.CAMP_MIAN)
			if view then
				view:cancelCall(true)
				view:setWarStatue(true)
			end
		end 
	elseif 21210005 == data_.status then
		local view = mgr.ViewMgr:get(_viewname.CAMP_MIAN)
		if view then 
			view:cancelCall()
			if data_.dieTime > 0 then 
				view:runDead(data_.dieTime)
			end 
			G_TipsOfstr(res.str.DEC_ERR_64)
		end
	elseif 21210006 == data_.status then
		local view = mgr.ViewMgr:get(_viewname.CAMP_MIAN)
		if view then 
			view:cancelCall()
			G_TipsOfstr(res.str.DEC_ERR_65)
		end
	elseif 21210007 == data_.status then
		local view = mgr.ViewMgr:get(_viewname.CAMP_MIAN)
		if view then 
			view:cancelCall()
			G_TipsOfstr(res.str.DEC_ERR_66)
		end
	elseif 21210002 ==  data_.status then 
		local view = mgr.ViewMgr:get(_viewname.CAMP_MIAN)
		if view then 
			view:cancelCall()
			G_TipsOfstr(res.str.DEC_ERR_63)
		end 
	end
end
function CampProxy:send120104( param )
	-- body
	if param and param.matchType == 1 then 
		cache.Camp:setautoMatchStatu(1)
	end
	self.param = param
	self:send(120104,param)
end
--战斗信息返回
function CampProxy:MsgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Camp:updateMainInfo(data_)
		local evet =  cache.Camp:keepNoticeSelf(data_.vsUserInfo)
		local view = mgr.ViewMgr:get(_viewname.CAMP_MIAN)
		if view then 
			view:stopSomething(data_)
			view:addEvent(evet)
		end
		
	elseif data_.status == 21210003 then --轮空
		
		local view = mgr.ViewMgr:get(_viewname.CAMP_MIAN)
		if view then 
			G_TipsOfstr(res.str.DEC_ERR_61)
			--view:stopSomething(nil,true)
			view:setWarStatue(false)
			view:run()
		end
	end
end

function CampProxy:NUllMsgCallBack( data_ )
	-- body
	if data_.status == 21210003 then 
		local view = mgr.ViewMgr:get(_viewname.CAMP_MIAN)
		if view then 
			G_TipsOfstr(res.str.DEC_ERR_61)
			view:run()

			view:addEvent(data_.events)
		end
	end
end

--阵营战鼓舞
function CampProxy:buffMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		--鼓舞成功，全体增加30%属性
		G_TipsOfstr(string.format(res.str.DEC_ERR_54,data_.atk,data_.hp))
		local view = mgr.ViewMgr:get(_viewname.CAMP_MIAN)
		if view then 
			view:setGuwu(data_)
		end
	elseif 21210004 == data_.status then
		G_TipsOfstr(res.str.DEC_ERR_62)
	elseif 21210005 == data_.status then 
		G_TipsOfstr(res.str.DEC_ERR_74)
	elseif 20010005 == data_.status then 
		G_TipsOfstr(res.str.NO_ENOUGH_ZS)
	elseif 21210002 ==  data_.status  then 
		G_TipsOfstr(res.str.DEC_ERR_63)
	end
end
function CampProxy:send120105( param )
	-- body
	self:send(120105,param)
end

function CampProxy:noticeMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Camp:updateSelfrewrd(data_)
		cache.Camp:keepNoticeAll(data_)
		local view = mgr.ViewMgr:get(_viewname.CAMP_MIAN)
		if view then 
			view:keepAllnotice(data_)
			view:setReward()
			view:setinfo()
			view:initrank(data_.topWinner)
		end	
	end
end

function CampProxy:closeMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 

	end
end

function CampProxy:sendMsg120107()
	-- body
	self:send(120107)
end

function CampProxy:sendMsg120108()
	-- body
	self:send(120108)
end

function CampProxy:noticeSelfMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		local view = mgr.ViewMgr:get(_viewname.CAMP_MIAN)
		if view then 
			view:keepSelfNotice(data_)
		end	
	end
end

--观看阵营战战报
--[[function CampProxy:warMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 

	end
end
function CampProxy:send120106( param )
	-- body
	self:send(120106,param)
end]]--

return CampProxy