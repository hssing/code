local GuildProxy=class("GuildProxy",base.BaseProxy)

function GuildProxy:init()
	-- body
	self:add(517001,self.returnCallBack)
	self:add(517002,self.searchCallBack) --公会搜素
	self:add(517003,self.AddCallBack) --
	self:add(517004,self.CallMemberBack) --成员
	self:add(517005,self.AppointCallBack) --任命
	self:add(517006,self.shengheListCallBcak) --审核列表
	self:add(517007,self.shengheCallBack) --审核返回
	self:add(517008,self.TuichuCallBcak) --退出公会
	self:add(517009,self.guildMsgCallBcak) --公会基本信息
	self:add(517012,self.rGuildFBAward)  --领取公会副本奖励返回
	self:add(517013,self.buyFightTimes) 
	self:add(517101,self.qifuMsgCallBcak) --祈福信息
	self:add(517102,self.qifuCallBcak) --祈福一次
	self:add(517103,self.getQFrewaradBack) --祈福奖励领取
	self:add(517301,self.guildEnterCopy) 
	self:add(517201,self.shopMsgaCallBack) --商店
	self:add(517202,self.shopMsgaBuyCallBack)--商店购买
	
	self:add(517306,self.guildRankCallBack) --副本排行
	self:add(517304,self.guildBenQuCallBack) --公会本区排行
	self:add(517011,self.dongTaiCallback) --动态
	self:add(517303,self.zhanjiCallBack) --成员战绩
	self:add(517302,self.guildFBRewardMgCallBack)--副本通关奖励
	self:add(517305,self.getRewardCallBack) --领取
	self:add(517010,self.GonggaoBack)

	self:add(817001,self.guildIDchange)

	self:add(517014,self.guildShenqingSet)
	self:add(517015,self.guildShenqingSetCallBack)

	self:add(517401,self.add_517401)

	self.isok_sh ={} ;--是同意加好友还是拒绝好友 
	self.roleId = {}
	self.isshengqing = -1 --是申请加入 还是取消加入
	self.bugindex = -1 --购买的是哪个
	self.qifuget = 0 --祈福领取的是哪个进度 奖励
	self.rankpage = 1 --请求的是第几页 排行信息
	self.getidx = 0 --领取奖励时候是按的第几条
end

function GuildProxy:send_117401( param )
	-- body
	self:send(117401,param)
	self:wait(517401)
end

function GuildProxy:add_517401( data_ )
	-- body
	if data_.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.CAHNGENAME)
	    if view then 
	    	view:onCloseSelfView()
	    end

		cache.Guild:setChangeName(data_)
		local view = mgr.ViewMgr:get(_viewname.GUILD_VIEW)
		if view then
			view:updateName(data_)
		end
	else
		G_TipsError(data_.status)
	end
end

function GuildProxy:sendSQmsg( )
	-- body
	self:send(117014)
end

function GuildProxy:guildShenqingSet( data_ )
	-- body
	if data_.status == 0 then 
		local view = mgr.ViewMgr:get(_viewname.GUILD_JOB)
		if view then 
			view:setData(data_)
		end 
	end 
end

function GuildProxy:sendSQset( param )
	-- body
	self:send(117015,param)
end

function GuildProxy:guildShenqingSetCallBack( data_ )
	-- body
	if data_.status == 0 then 
		local view = mgr.ViewMgr:get(_viewname.GUILD_JOB)
		if view then 
			view:onCloseSelfView()
		end 
	end 
end

function GuildProxy:guildIDchange( data_ )--要主动更新 player 里面的公会ID
	-- body
	if data_.status == 0 then 
		cache.Player:setGuildId(data_.guildId)
		if data_.guildId.key == "0_0" then --这个是退出公会
			if mgr.SceneMgr:getMainScene()  == mgr.SceneMgr:getNowShowScene() then
				G_mainView()
				G_TipsOfstr(res.str.GUILD_DEC31)

				local view = mgr.ViewMgr:get(_viewname.GUIILD_REWARAD)
				if view then
					view:closeSelfView()
				end
				local view = mgr.ViewMgr:get(_viewname.GUILD_RENMING)
				if view then
					view:closeSelfView()
				end
				local view = mgr.ViewMgr:get(_viewname.GUILD_FB_REWARD)
				if view then
					view:closeSelfView()
				end
			end
		else --被人同意加入会
			local view = mgr.ViewMgr:get(_viewname.GUILD_LIST)
			if view then --如果当时是在找公会
				self:sendGuilmsg()
				view:onCloseSelfView()
			end 
			local view = mgr.ViewMgr:get(_viewname.GUILD_CREATE)
			if view then 
				view:onCloseSelfView()
			end
			
		end 
	end 
end

--创建公会
function GuildProxy:sendCreate(params)
	-- body
	self:send(117001,params)
end
--创建公会返回
function GuildProxy:returnCallBack( data_ )
	-- body
	if data_.status ==0 then
		--在这里要退出创建公会界面 直接跳刀公会主界面
		local view = mgr.ViewMgr:get(_viewname.GUILD_LIST)
		if view then 
			view:onCloseSelfView()
		end 
		local view = mgr.ViewMgr:get(_viewname.GUILD_CREATE)
		if view then 
			view:onCloseSelfView()
		end 
		---
		--debugprint("有公会了  但是主界面没有")
		self:sendGuilmsg()


	elseif  data_.status == 20010001 then 
		G_TipsOfstr(res.str.NO_ENOUGH_JB)
	elseif data_.status == 21010002 then 
		G_TipsOfstr(res.str.GUILD_DEC11)
	elseif data_.status == 21010003 then 
		G_TipsOfstr(res.str.GUILD_DEC12)
	else
		print("返回失败")
	end 
end

--查找公会
function GuildProxy:sendSearch(params)
	-- body
	--当前请求第几页
	self.page =cache.Guild:getCurpage() -- 当前第几页  
	self.first = false
	if params.first then 
		self.first = true
	end 

	if params.page == 1 then 
		print("params.page = "..params.page)
		self.page = 1 
	end
	if not self.first then --第一次请求看页数 
		local maxpage = cache.Guild:getMaxPage()
		if maxpage == 1 then 
			debugprint("其实只有一页")
			return 
		elseif self.page > maxpage  then
			 G_TipsOfstr(res.str.MAIL_NOMOREMESSAGE)
			return 
		end 
	end 
	local data = {pageIndex = self.page, guildName =params.guildName }
	debugprint("查询信息 "  )
	printt(data)

	self:send(117002,data)
end

function GuildProxy:searchCallBack( data_ )
	-- body
	if data_.status ==0 then 
		local flag = true
		if not self.first  then
			flag = false
		end

		cache.Guild:KeepSearch(data_,flag)
		local view = mgr.ViewMgr:get(_viewname.GUILD_LIST)
		if view then 
			view:setData()
		else
			local _view = mgr.ViewMgr:createView(_viewname.GUILD_LIST)
			_view:setData()
			mgr.ViewMgr:showView(_viewname.GUILD_LIST)
			
		end 

		if #data_.guildList == 0 then 
			G_TipsOfstr(res.str.GUILD_DEC22)
		end 
	elseif  20010223 == data_.status then --每人创建公会
		G_TipsOfstr(res.str.GUILD_DEC56)
		local view = mgr.ViewMgr:get(_viewname.GUILD_LIST)
		if not view then 
			local _view = mgr.ViewMgr:createView(_viewname.GUILD_LIST)
			mgr.ViewMgr:showView(_viewname.GUILD_LIST)
		end 
	else
		debugprint("查询失败")
	end 
end

--请求加入公会
function GuildProxy:sendaddGuild(param,idx)
	-- body
	--param = {guildId = ,isOk = }
	self.idx = idx
	self.isshengqing = param.isOk
	self:send(117003,param)
end

--
function GuildProxy:AddCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Guild:keepAdd(data_,false)
		if self.idx then 
			local view = mgr.ViewMgr:get(_viewname.GUILD_LIST)
			if view then 
				view:updateDataByidx(self.idx)
			end 

			if self.isshengqing == 1 then 
				G_TipsOfstr(res.str.GUILD_DEC23)
			end 
		end 
		---这里做一些更新？
	elseif 20010107 == data_.status then
		G_TipsOfstr(res.str.GUILD_DEC18)
	elseif 20010225 == data_.status then
		G_TipsOfstr(res.str.DEC_ERR_14)
	elseif 20010226 == data_.status then
		G_TipsOfstr(res.str.DEC_ERR_15)
	else 
		debugprint("请求公会失败")
	end 
end
-----------------------------------------------------------------------------------
--***********************************************************************************
--加入了公会后

--请求公会成员
function GuildProxy:sendCallMember()
	-- body
	self:send(117004)
end

function GuildProxy:CallMemberBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Guild:KeepMemberInfo(data_.userList)
		local view = mgr.ViewMgr:get(_viewname.GUILD_MEMBER)
		if view then 
			view:setData1()
			view:pagebtninit(1)
		end 
	else
		debugprint("请求公会=成员失败")
	end 
end

---请求任命公会权限
function GuildProxy:sendAppoint( param )
	-- body
	--param = {roleId,career} 玩家Id 职业(1会长,2副会长,3弹劾)
	printt(param)
	self:send(117005,param)
end

function GuildProxy:AppointCallBack(data_ )
	-- body
	if data_.status == 0 then 
		--debugprint("任命成功了之后")
		local view = mgr.ViewMgr:get(_viewname.GUILD_RENMING)
		if view then 
			view:onCloseSelfView()
		end 
		self:sendCallMember()--任命成功后重新请求一次成员信息，刷新数据
	else
		debugprint("任命公会权限失败")
	end 
end

--请求公会审核列表
function GuildProxy:sendShengheList()
	-- body
	self:send(117006)
end

function GuildProxy:shengheListCallBcak( data_ )
	-- body
	if data_.status == 0 then
		cache.Guild:keepShenhe(data_.userList)
		local view = mgr.ViewMgr:get(_viewname.GUILD_MEMBER)
		if view then 
			--debugprint("testst ")
			view:setData2()
			view:pagebtninit(2)
		end 
	else
		debugprint("公会审核列表返回失败")
	end 
end

--请求公会审核
function GuildProxy:sendShenghe(params)
	-- body
	-- params = {roleId,isOk}
	self.isok_sh = params
	self:send(117007,params)
end

function GuildProxy:shengheCallBack( data_ )
	-- body
	if data_.status == 0 then 
		if self.isok_sh.isOk == 1 then 
			debugprint("同意加入")
			cache.Guild:setGuildBaseGuildCount()
		elseif self.isok_sh.isOk == 0 then 
			--debugprint("拒绝加入")
		elseif self.isok_sh.isOk == 2 then 
			--全部清除

		else
			self.isok_sh = {}
		end 
		cache.Guild:delShenHe(data_,self.isok_sh.isOk)

		--[[local t = {}
		t.guildPower = data_.guildPower
		t.guildCount = data_.guildCount]]--
		cache.Guild:updateBaseinfo(data_)
		local view = mgr.ViewMgr:get(_viewname.GUILD_MEMBER)
		if view then 
			--debugprint("testst ")
			view:delItembyData(data_,self.isok_sh.isOk)
		end 

		if #cache.Guild:getShenhe()==0 then 
			cache.Player:_setShenHeNumber(0)
		end 

	elseif 20010207 == data_.status then --满了
		G_TipsOfstr(res.str.GUILD_DEC26)
	elseif 20010210==data_.status then --已经是公会的成员
		G_TipsOfstr(res.str.GUILD_DEC34)

		self.isok_sh.isOk = 0
		self:sendShenghe(self.isok_sh)
	elseif 20010225 == data_.status then
		--todo
		G_TipsOfstr(res.str.DEC_ERR_16)
	else
		debugprint("公会审核失败")
	end 
end

--请求退出公会
function GuildProxy:sendTuichu(params)
	-- body
	-- params = {roleId,isOk}
	self.roleId = params.roleId
	self:send(117008 ,params)
end

function GuildProxy:TuichuCallBcak( data_ )
	-- body
	if data_.status == 0 then 
		if self.roleId.key == cache.Player:getRoleInfo().roleId.key then --如果退出的是自己
			cache.Player:setGuildId({key="0_0",hight=0,low=0})
			G_mainView()
		else
			cache.Guild:removeMember(self.roleId)
			cache.Guild:updateBaseinfo(data_)

			local view = mgr.ViewMgr:get(_viewname.GUILD_MEMBER)
			if view then 
				--debugprint("testst ")
				view:delItembyRoleId(self.roleId)
			end 
		end 
	elseif 20010208 == data_.status  then 
		G_TipsOfstr(res.str.GUILD_DEC28)
	elseif 20010209 == data_.status then 
		G_TipsOfstr(res.str.GUILD_DEC29)
	else
		debugprint("退出公会失败")
	end 
end

--请求公会信息

function GuildProxy:sendGuilmsg()
	-- body
	-- params = {roleId,isOk}
	self:send(117009)
end

function GuildProxy:guildMsgCallBcak( data_ )
	-- body
	if data_.status == 0 then
		mgr.Sound:playViewGonghui()
		cache.Guild:setGuildBaseInfo(data_)
		mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_VIEW)
		local view = mgr.ViewMgr:get(_viewname.GUILD_VIEW)
		if view then
			view:setData(data_)
		end
	elseif data_.status == 20010203 then 
		local params = {guildName = "" , first = true ,page = 1}
		self:sendSearch(params)
		self:waitFor(517002)
		--mgr.ViewMgr:showView(_viewname.GUILD_LIST)--公会列表 --找工会
	else
		debugprint("公会信息失败")
	end 
end

function GuildProxy:rGuildFBAward(data_)
	if data_.status == 0 then
		local data = cache.Guild:getGuildFbInfo()

		if #data.gkAwards == 0 and data.fbCount ==0  then --清除红点
			cache.Player:_setGongHFuBJLNumber(0)
		end 

		data.gkAwards[data_.fbId..""] = nil
		local view = mgr.ViewMgr:get(_viewname.GUILD_FB)
		if view then
				view:rGetAwardBox(data_)
		end
	elseif data_.status == 21030001 then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	elseif 20010228 == data_.status then
		G_TipsOfstr(res.str.DEC_NEW_40)
	elseif 20010229 == data_.status then
		G_TipsOfstr(res.str.DEC_NEW_47)
	end
end

---购买挑战次数
function GuildProxy:buyFightTimes(data_)
		if data_.status == 0 then
				local data = cache.Guild:getGuildFbInfo()
				data.canBuyCount = data_.canBuyCount
				data.fbCount = data_.fbCount
				local view1 = mgr.ViewMgr:get(_viewname.GUILD_FB_ENTER)
				if view1 then
						view1:updateFBCount()
				end
				local view2 = mgr.ViewMgr:get(_viewname.GUILD_FB)
				if view2 then
						view2:updateFBCount()
				end
		end
end

--请求祈福信息
function GuildProxy:sendQifumsg()
	-- body
	self:send(117101  )
end

function GuildProxy:qifuMsgCallBcak( data_ )
	-- body
	if data_.status == 0 then 
		cache.Guild:keepQFmsg(data_)
		local view = mgr.ViewMgr:get(_viewname.GUIILD_QIFU)
		if view then 
			view:setData()
		else
			mgr.ViewMgr:showView(_viewname.GUIILD_QIFU):setData()
		end 
	else
		debugprint("祈福信息失败")
	end 
end

--请求祈福

function GuildProxy:sendQifu(param)
	-- body
	-- param = {qf = } -- 1金币,2钻石,2金钻
	printt(param)
	self:send(117102,param )
end

function GuildProxy:qifuCallBcak( data_ )
	-- body
	if data_.status == 0 then 
		cache.Player:_setGongHJLNumber(0)

		cache.Guild:keepQFmsg(data_)
		cache.Guild:updateBaseinfo(data_) --更新一下 经验 等级 贡献

		debugprint("祈福完成之后")
		local view = mgr.ViewMgr:get(_viewname.GUIILD_QIFU)
		if view then 
			view:severCallBack()
		end 
		--debugprint("祈福成果")
	elseif data_.status == 20010204 then 
		G_TipsOfstr(res.str.GUILD_DEC27)
	elseif data_.status == 21200006 then
		G_TipsOfstr(res.str.GUILD_DEC60)
	else
		debugprint("祈福信息失败")
	end 
end

--
--请求祈福奖励
function GuildProxy:sendgetQifureward(param)
	-- body
	-- param = {qf = } -- 1金币,2钻石,2金钻
	printt(param)
	self.qifuget =param.qfKey 
	self:send(117103,param)
end

function GuildProxy:getQFrewaradBack( data_ )
	-- body
	if data_.status == 0 then 
		--cache.Guild:decReward(self.qifuget)

		local view = mgr.ViewMgr:get(_viewname.GUIILD_QIFU)
		if view then 
			view:setRwardData(self.qifuget)
		end 

		local view = mgr.ViewMgr:get(_viewname.GUIILD_REWARAD)
		if view then
			view:onCloseSelfView()
		end
	elseif 20010227 == data_.status then
		G_TipsOfstr(res.str.DEC_NEW_39)
	elseif data_.status == 21030001 then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	else
		debugprint("祈福奖励失败")
	end 
end

function GuildProxy:guildEnterCopy(data_)
		if data_.status == 0 then
				cache.Guild:setGuildFbInfo(data_)
				local fbView = mgr.ViewMgr:get(_viewname.GUILD_FB)
				if fbView then
						--由错误号返回处理：更新当前副本进度情况
						fbView:setData({cId=cache.Guild.guildFBID})
				else
						mgr.Sound:playViewGonghuiFuben()
						mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_FB_ENTER)
		        local view = mgr.ViewMgr:get(_viewname.GUILD_FB_ENTER)
		        if view then
		            view:setData()
		        end
				end
				
		end
end
--请求公会商店
function GuildProxy:sendShopMsg()
	-- body
	self:send(117201)
end


function GuildProxy:shopMsgaCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Guild:keepShopMsg(data_)
		local view = mgr.ViewMgr:get(_viewname.GUILD_SHOP)
		if not view then 
			mgr.Sound:playViewGonghuiShangdian()
			mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_SHOP)
			local view = mgr.ViewMgr:get(_viewname.GUILD_SHOP)
			if view then 
				view:setData() 
				view:inittableView() 
			end 
		end 
	else
		--todo
		debugprint("没有商店信息返回")
	end 
end

function GuildProxy:sendBuy( params )
	-- body
	--print("商店购买信息")
	printt(params)
	self.bugindex = params.index
	self:send(117202,params)
end

function GuildProxy:shopMsgaBuyCallBack(data_)
	-- body
	if data_.status == 0 then 
		G_TipsOfstr(res.str.BUY_SUCCESS)

		cache.Guild:setShopitemInfo(data_)
		cache.Guild:updateBaseinfo(data_)
		local view = mgr.ViewMgr:get(_viewname.GUILD_SHOP)
		if view then
			--view:setData() 
			view:updateData(self.bugindex,data_)
		end 

		local view = mgr.ViewMgr:get(_viewname.SHOP_BUY)
		if view then 
			view:onCloseSelfView()
		end 
	elseif 21050003 == data_.status then 
		G_GoReCharge()
	elseif 20010007 == data_.status then 
		G_TipsOfstr(res.str.GUILD_DEC39)
	elseif 21030001==data_.status then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	else
		debugprint("商店购买失败")
	end 
end


function GuildProxy:sendBenQuguildRank(pageindex)
	-- body
	self.rankpage =pageindex -- 当前第几页  

	local maxpage = cache.Guild:getRankMaxPage()
	if maxpage == 1 and self.rankpage~=1 then 
		debugprint("其实只有一页")
		--G_TipsOfstr(res.str.MAIL_NOMOREMESSAGE)
		return 
	elseif  maxpage and  maxpage > 0 and self.rankpage > maxpage  then
		G_TipsOfstr(res.str.MAIL_NOMOREMESSAGE)
		return 
	end 
	
	local data = {pageIndex = self.rankpage}
	debugprint("查询信息 "  )
	printt(data)

	self:send(117304,data)
end
--本区排行
function GuildProxy:guildBenQuCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Guild:KeepRankInfo(data_,self.rankpage)
		local view = mgr.ViewMgr:get(_viewname.GUILD_TWO_RABK)
		if view then 
			view:setData1()
		end 


		--[[local view = mgr.ViewMgr:get(_viewname.GUILD_BENQU_RANK)
		if view then 
			view:setData()
		else
			local _view = mgr.ViewMgr:showView(_viewname.GUILD_BENQU_RANK)
			_view:setData()
		end ]]--

	else
		debugprint("本区排行没有返回")
	end 
end


function GuildProxy:sendguildRank()
	-- body
	self:send(117306)
end

function GuildProxy:guildRankCallBack( data_ )
	-- body
	if data_.status == 0 then 
		--cache.Guild:KeepRankInfo(data_,self.rankpage)
		local view = mgr.ViewMgr:get(_viewname.GUILD_TWO_RABK)
		if view then 
			view:setData2(data_)
		else
			local _view = mgr.ViewMgr:showView(_viewname.GUILD_TWO_RABK)
			_view:setData2(data_)
		end 
		--[[local view = mgr.ViewMgr:get(_viewname.GUILD_GUILD_RANK)
		if view then 
			view:setData(data_)
		else
			local _view = mgr.ViewMgr:showView(_viewname.GUILD_GUILD_RANK)
			_view:setData(data_)
		end ]]--
	else
		debugprint("没有返回排行信息")
	end 
end
--请求动态信息
function GuildProxy:sendDongtai()
	-- body
	self:send(117011)
end

function GuildProxy:dongTaiCallback( data_ )
	-- body
	if data_.status ==0 then 
		cache.Guild:keepDongtaiMsg(data_.dtList)
		printt(data_.dtList)
		local view = mgr.ViewMgr:get(_viewname.GUILD_DT)
		if view then 
			view:setData()
		end 
	else
		debugprint("没有返回动态信息")
	end 
end

--成员战绩

function GuildProxy:sendZhanji()
	-- body
	self:send(117303)
end


function GuildProxy:zhanjiCallBack(data_ )
	-- body
	if data_.status == 0 then
		cache.Guild:keepZhanji(data_.hitRankList)
		local view = mgr.ViewMgr:get(_viewname.GUILD_ZHANJI)
		if view then 
			view:setData()
		end 
	end 
end

--副本通关奖励

function GuildProxy:sendRewadrMsg()
	-- body
	self:send(117302)
end
function GuildProxy:guildFBRewardMgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		cache.Guild:KeepFBReward(data_.fbAwards)
		--[[if #data_.fbAwards == 0 then 
			cache.Player:_setGongHTongGJLNumber(0)
		end ]]--
		local view = mgr.ViewMgr:get(_viewname.GUILD_FB_REWARD)
		if view then 
			view:setData()
		end 
	elseif 20010228 == data_.status then
		G_TipsOfstr(res.str.DEC_NEW_40)
	elseif 21030001==data_.status then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	else
		debugprint("没有返回通关奖励信息")
	end 
end

function GuildProxy:sendGetReward(id,idx)
	local param = {cId = id}
	self.getidx = idx
	--printt(param)
	self:send(117305,param)
	self:wait(517305)
end 

function GuildProxy:getRewardCallBack(data_)
	-- body
	if data_.status == 0 then
		--G_TipsOfstr(res.str.MAILVIEW_DEC4)
		local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
		if not view then
			view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
			view:setData(data_.items,false,true,true)
			view:setButtonVisible(false)
		end


		cache.Guild:updateFBReward(data_)
		local  tt = cache.Guild:getFBreward() 
		local flag = true
		for k ,v in pairs(tt) do 
			if k~="_size" then 
				if tonumber(v) ~= 2 then 
					flag = false
					break
				end 
			end 
		end 
		if flag then 
			cache.Player:_setGongHTongGJLNumber(0)
			local view = mgr.ViewMgr:get(_viewname.GUILD_FB)
			if view then 
				view:setRedPoint()
			end 
			local view = mgr.ViewMgr:get(_viewname.GUILD_FB_ENTER)
			if view then 
				view:setRedPoint()
			end 
		end 

		local view = mgr.ViewMgr:get(_viewname.GUILD_FB_REWARD)
		if view then 
			view:setData()
			view:setDataByidx(self.getidx)
		end 
	elseif data_.status == 21030001 then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	elseif data_.status == 20010228 then 
		G_TipsOfstr(res.str.DEC_NEW_40)
	else
		debugprint("领取副本奖励信息失败")
	end 
end
--发布公告啊
function GuildProxy:sendChange(param)
	-- body
	self:send(117010,param)
	self.gonggao = param.gonggaoStr
end

--发布结束
function GuildProxy:GonggaoBack( data_)
	-- body
	if data_.status == 0 then 
		local data = {guildGonggao = self.gonggao }
		cache.Guild:updateBaseinfo(data)

		local view = mgr.ViewMgr:get(_viewname.GUILD_VIEW)
		if view then 
			view:setData(cache.Guild:getGuildBaseInfo())
		end 
	elseif 21010003 ==  data_.status then
		G_TipsOfstr(res.str.CHAT_TIPS13)
	else
		debugprint("发布结束")
	end  
end


function GuildProxy:waitFor( msgid )
	-- body
	self:wait(msgid)
end




return GuildProxy