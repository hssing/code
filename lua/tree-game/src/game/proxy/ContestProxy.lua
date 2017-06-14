
local ContestProxy = class("ContestProxy", base.BaseProxy)

function ContestProxy:init()
	-- body
	self:add(519001,self.ContestCallBack)--请求数码大赛信息(返回)
	self:add(519002,self.MyGroupCallBack)--请求小组信息列表(返回)
	self:add(519003,self.VideoCallBack)--数码大赛录像列表(返回)
	self:add(519004,self.BaomingCallBack)--数码大赛报名(返回)
	self:add(519005,self.CaiCallBack)--请求数码大赛竞猜(返回)
	self:add(519006,self.caiMsgCallBack) --
	self:add(501201,self.compareMsgCallBack)--对比
	-----------------------驯兽师之王
	self:add(519101,self.winnerMsg) --请求数码兽之王的信息
	self:add(519102,self.winnerSetMsg)--设置信息
	self:add(519103,self.setMsgCallBack)--设置返回
	self:add(519104,self.dianzhanCallBack)--点赞返回
	self:add(519007,self.RankCallBack)
	---驯兽师商店
	self:add(519201,self.shopMsgaCallBack)
	self:add(519202,self.buyCallBack)
	self.rolename = nil 
end
---驯兽师商店
function ContestProxy:shopMsgaCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Contest:keepShop(data_)
		local view = mgr.ViewMgr:showView(_viewname.CONTEST_SHOP)
		view:setData(data_)
	else
		debugprint("没有返回 519201")
	end
end

function ContestProxy:sendShopMsg(param)
	-- body
	debugprint("驯兽师商店")
	printt(param)
	self.shopid = param.shopId
	self:send(119201,param)
end

function ContestProxy:buyCallBack(data_)
	-- body
	if data_.status == 0 then  
		cache.Contest:updateBuy(data_.shop_index)
		local view = mgr.ViewMgr:showView(_viewname.CONTEST_SHOP)
		view:buySuccess(data_.shop_index)
	elseif 21080001 == data_.status then 
		G_TipsOfstr(res.str.DEC_ERR_13)
	elseif 20010006 == data_.status then
		G_TipsOfstr(res.str.NO_ENOUGH_HZ)
	else
		debugprint("没有返回 519201")
		G_TipsOfstr(res.str["CONTEST_DEC"..(43+self.shopid)])
		
		--G_TipsOfstr(res.str.)
	end 
end

function ContestProxy:sendBuy(params)
	-- body
	printt(params)
	self:send(119202,params)
end

--------------------驯兽师之王
function ContestProxy:sendWinnerMsg()
	-- body
	self:send(119101)
end
function ContestProxy:winnerMsg( data_ )
	-- body
	if data_.status == 0 then 
		G_mainView()
		cache.Contest:keepWinnerMsg(data_)
		mgr.Sound:playViewXunshoushizhiwang()
		local view = mgr.SceneMgr:getMainScene():changeView(0,_viewname.CONTEST_WIN_MIAN)
		view:setData()
	elseif 21080001 == data_.status then
		G_mainView()
		cache.Contest:keepWinnerNullMsg()
		mgr.Sound:playViewXunshoushizhiwang()
		local view = mgr.SceneMgr:getMainScene():changeView(0,_viewname.CONTEST_WIN_MIAN)
		view:setData()
	else
		debugprint("返回失败 519101")
	end 
end

function ContestProxy:sendSetMsg()
	-- body
	self:send(119102)
end

function ContestProxy:winnerSetMsg(data_ )
	-- body
	if data_.status == 0 then 
		cache.Contest:keepSetMsg(data_)
	else
	end 
end

function ContestProxy:sendToset( param )
	-- body
	debugprint("设置点赞")
	printt(param)
	self:send(119103,param)
end

function ContestProxy:setMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Contest:resetSetMsg(data_)

		if data_.today >= 5  then --设置红点清除
			cache.Player:_setWangSetNumber(0)
		end 

		G_TipsOfstr(res.str.CONTEST_DEC39)

		local view = mgr.ViewMgr:get(_viewname.CONTEST_WIN_SET_SECOND)
		if view then 
			view:onCloseSelfView()
		end 

		local view = mgr.ViewMgr:get(_viewname.CONTEST_WIN_SET)
		if view then  
			view:setData(data_.zanType)
		end

		local view = mgr.ViewMgr:get(_viewname.CONTEST_WIN_MIAN)
		if view then 
			view:setRedPoint()
		end 
	else
	end 
end

function ContestProxy:sendDianzhan()
	-- body
	self:send(119104)
end

function ContestProxy:dianzhanCallBack(data_)
	-- body
	if data_.status == 0 then 
		cache.Player:_setWangNumber(0)

		cache.Contest:resetWinnerMsg(data_)
		local view = mgr.ViewMgr:get(_viewname.CONTEST_WIN_MIAN)
		if view then 
			view:updateinfo(data_)
			view:setRedPoint()
		end 	
	else
	end  
end

function ContestProxy:sendrank()
	-- body
	self:send(119007)
end

function ContestProxy:RankCallBack(data_)
	-- body
	if data_.status == 0 then 
		local view = mgr.ViewMgr:get(_viewname.CONTEST_WIN_RANK)
		if not view then 
			view = mgr.ViewMgr:showView(_viewname.CONTEST_WIN_RANK)
			view:setData(data_.ranks)
		else
			view:setData(data_.ranks)
		end 
	end 
end


--------------------数码大赛

function ContestProxy:getrolename()
	-- body
	return self.rolename
end

--请求数码大赛信息
function ContestProxy:sendContest(param)
	-- body
	self:send(119001)
end

function ContestProxy:ContestCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Contest:keepContest(data_)
		local view = mgr.ViewMgr:get(_viewname.CONTEST_MAIN)
		if view then 
			view:setData()
		else
			mgr.Sound:playViewXunshoushidasai()
			view = mgr.SceneMgr:getMainScene():changeView(0,_viewname.CONTEST_MAIN)
			view:setData()
		end 
	else
		debugprint("数码大赛信息返回失败 协议 519001")
	end 
end

--请求小组信息
function ContestProxy:sendMyGroup(param)
	-- body
	--param = {arrayType = 0 } 小组类型(0:自己小组)
	self.page =param.pageIndex -- 当前第几页
	local maxpage = cache.Contest:getMaxPage()
	if maxpage and maxpage == 1 and self.page>maxpage then 
		debugprint("只有一页")
		return 
	elseif maxpage and  maxpage > 0 and self.page > maxpage then 
		G_TipsOfstr(res.str.MAIL_NOMOREMESSAGE)
		return 
	end 
	self:send(119002,param)
	mgr.NetMgr:wait(519002)
end

function ContestProxy:MyGroupCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Contest:keepGroup(data_,self.page)
		local view = mgr.ViewMgr:get(_viewname.CONTEST_GROUP)
		if view then 
			view:setData()
		else
			view = mgr.ViewMgr:showView(_viewname.CONTEST_GROUP)
			view:setData()
		end 
	else
		debugprint("小组信息返回失败 协议 519002")
	end 
end

--录像
function ContestProxy:sendVideo(param)
	-- body
	--param = {roleId= }
	debugprint("录像信息")
	self.rolename  = param.name
	local data = {roleId = param.roleId }
	self:send(119003,data)
end

function ContestProxy:VideoCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Contest:keepVideo(data_)
		local view = mgr.ViewMgr:showView(_viewname.CONTEST_VIDEO)
		view:setData(data_)
		if self.rolename  ~= cache.Player:getName() then 
			view:setOther(self.rolename)
		end 
	else
		debugprint("录像信息返回失败 协议 519003")
	end 
end
--报名
function ContestProxy:sendBaoming( param )
	-- body
	self:send(119004)
end

function ContestProxy:BaomingCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Player:_setBaoMingNumber(0)

		cache.Contest:updateInfo()
		local view = mgr.ViewMgr:get(_viewname.CONTEST_MAIN)
		if view then 
			view:update()
		end 
	else
		debugprint("报名返回失败 协议 519004")
	end 
end
---竞猜
function ContestProxy:sendMsg( param )
	-- body
	debugprint("请求两人的竞猜信息")
	printt(param)
	self:send(119006,param)
end

function ContestProxy:caiMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Contest:keepCaiInfo(data_)
		local view = mgr.ViewMgr:get(_viewname.CONTEST_COMPARE)
		if view then 
			view:updateinfo(data_)
		end 
	else
		debugprint("没有返回竞猜信息")
	end 
end


function ContestProxy:sendCai( param )
	-- body
	--param = { index , atype }
	debugprint("竞猜")
	self.caiparam =  param
	self:send(119005,param)
end


function ContestProxy:CaiCallBack( data_ )
	-- body
	if data_.status == 0 then 
		local view = mgr.ViewMgr:get(_viewname.CONTEST_COMPARE)
		if view then 
			view:onCloseSelfView()
		end 
		G_TipsOfstr(res.str.CONTEST_DEC32)
	elseif data_.status == 20010001 then
		--todo
		G_TipsOfstr(res.str.NO_ENOUGH_JB)
	else
		debugprint("竞猜返回失败 协议 519005")
	end 
end

--阵容对比

function ContestProxy:sendCompare( param )
	-- body
	self:send(101201,param)
end

function ContestProxy:compareMsgCallBack(data_)
	-- body
	if data_.status == 0 then 

		local view = mgr.ViewMgr:get(_viewname.CONTEST_COMPARE)
		if view then 
			view:comPareCalllBack(data_)
		end 

		local view =  mgr.ViewMgr:get(_viewname.CONTEST_GROUP)
		if view then 
			view:comPareCalllBack(data_)
		end

		--好友信息
		local view = mgr.ViewMgr:get(_viewname.FRIENDINFO)
		if view then
			view:comPareCalllBack(data_)
		end
		--驯兽师之王
		local view =  mgr.ViewMgr:get(_viewname.CONTEST_WIN_RANK)
		if view then 
			view:comPareCalllBack(data_)
		else
			local view = mgr.ViewMgr:get(_viewname.CONTEST_WIN_MIAN)
			if view  then 
				view:comPareCalllBack(data_)
			end 
		end
		--挖矿
		local view =  mgr.ViewMgr:get(_viewname.DIG_MIAN)
		if view then 
			view:comPareCalllBack(data_)
		end

		local view = mgr.ViewMgr:get(_viewname.CROSS_RANK)
		if view then 
			view:comPareCalllBack(data_)
		end
	else
		debugprint("对比阵容无返回")
	end 
end


return ContestProxy