--[[
	DigProxy 挖矿系统
]]
local DigProxy = class("DigProxy",base.BaseProxy)

function DigProxy:init()
	-- body
	self:add(520001,self.DigoneMsg)--个人某一个文件岛的信息
	self:add(520002,self.DigMainMsgCallBack)--请求岛列表
	self:add(520003,self.DigChallenge) -- 请求岛挖矿
	self:add(520004,self.DighelpCallBack)--请求岛救援
	self:add(520005,self.DigFriendCallBack)--请求挖矿好友列表
	self:add(520006,self.DigJianse) --求挖矿加速
	self:add(520007,self.DigGetCallBack) --领取
	self:add(520008,self.JiasuMsgCallBack) --加速信息

	self:add(520009,self.DigEnemylistCallBack) -- 复仇列表
	self:add(520010,self.YaoqingCallBack) -- 好友助阵列表
	self:add(520011,self.YaoqingBangCallBack) --暴动要求好友

	self.isself = true
	self.daoId = 0
	self.onedata = {}
	self.roleId= {}

	self.type = 1 -- 1 自己或好友 》2 抢夺
end

--请求个人文件岛列表的信息
function DigProxy:sendDigMainMsg(param)
	-- body
	--if param.roleId.key == cache.Player:getRo then
	self.isself = true
	if param.roleId.key ~= cache.Player:getRoleInfo().roleId.key then --如果不是自己
		self.isself = false
	end 

	local data = { }
	data.roleId = param.roleId.key

	if not param.roleName then 
		data.roleName = ""
	else
		data.roleName = param.roleName
	end


	if not param.type then 
		data.type = 1
	else
		data.type = param.type
	end
	self.type =  data.type

	self:send(120002,data)
end

function DigProxy:DigMainMsgCallBack(data_)
	-- body
	if data_.status == 0 then 
		if self.isself then  --是自己的岛 缓存一下
			cache.Dig:keepMainMsg(data_) 
		else
			cache.Dig:keepOtherMainMsg(data_)
		end 
		--如果好友界面打开
		local view = mgr.ViewMgr:get(_viewname.DIG_FRIEND)
		if view then 
			view:onCloseSelfView()
		end 
		--print("self.type = "..self.type)
		local view = mgr.ViewMgr:get(_viewname.DIG_MIAN)
		if view then 
			if not self.isself then 
				view:playActionCallBack()
			end 
			view:setData(data_,self.type)
		else
			view = mgr.ViewMgr:showView(_viewname.DIG_MIAN)
			view:setData(data_,self.type)
		end 
	else
		self.isself = true
		G_TipsError(data_.status)
	end 
end

--个人某一个文件岛的信息
function DigProxy:DigoneMsg( data_ )
	-- body
	if data_.status == 0 then
		if self.isself then  --自己
			local data = cache.Dig:updateDaoId(data_)
			local _view = mgr.ViewMgr:get(_viewname.DIG_MIAN)
			if _view then
				_view:initItem(data)
			end 
		else--
			local data = cache.Dig:updateOtherInfo(data_)
			local _view = mgr.ViewMgr:get(_viewname.DIG_MIAN)
			if _view then
				_view:initItem(data)
			end 
		end 

		local view = mgr.ViewMgr:showView(_viewname.DIG_INNER_MAIN)
		view:setData(data_,self.isself,self.roleId)
	else
		debugprint("岛详细信息失败")
	end
end

function DigProxy:sendOneMsg(param,data_)
	-- body
	self.roleId = param.roleId
	self.isself = true
	if param.roleId.key ~= cache.Player:getRoleInfo().roleId.key then --如果不是自己
		self.isself = false
	end 
	print(self.isself,"self.isself")
	self:send(120001,param)
end

--请求岛挖矿
function DigProxy:sendChallenge(param)
	-- body
	self:send(120003,param) 
end

function DigProxy:DigChallenge( data_ )
	-- body
	if data_.status == 0 then
		local count = cache.Player:getDigNumber()
		count = count -1 
		if count < 0 then 
			count = 0
		end 
		cache.Player:_setDigNumber(count)

		-- if count == 0 then
            local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
            if view then 
                view:setFbRed()
            end
        --end

	elseif 21200003 == data_.status then
		G_TipsOfstr(res.str.DIG_DEC26)
	elseif 21200002 == data_.status then 
		G_TipsOfstr(res.str.DIG_DEC27)
		--debugprint("挖矿信息失败")
	elseif 20010008 == data_.status then
		G_TipsOfstr(res.str.NO_ENOUGH_ITEM)
	else
		G_TipsError(data_.status)
		debugprint("挖矿信息失败")
	end
end
--救援
function DigProxy:sendHelp(param)
	-- body
	--[[printt(param)
	if param.roleId.key ~= cache.Player:getRoleInfo().roleId.key then --如果不是自己
		print("发送的不是自己")
	end ]]--
	self:send(120004,param)
end
function DigProxy:DighelpCallBack( data_ )
	-- body
	if data_.status == 0 then
		local view = mgr.ViewMgr:showView(_viewname.DIG_HELPVIEW)
		view:setData(data_)--data_.state 1是救援成功

		cache.Dig:setHelpCount()

		--红点-1
		local count = cache.Player:getDigNumber()
		count = count - 1 
		if count < 0 then 
			count = 0
		end 
		cache.Player:_setDigNumber(count)
        local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
        if view then 
            view:setFbRed()
        end


		local data = cache.Dig:updateHelpStatue()
		local _view = mgr.ViewMgr:get(_viewname.DIG_PROGRESS)
		if _view then 
			_view:updateinfo(data_.state)
		end 
		
		local _view1 = mgr.ViewMgr:get(_viewname.DIG_MIAN)
		if _view1 then
			_view1:initItem(data)
			_view1:updateCount()
		end 
	elseif 21200004 == data_.status then 
		G_TipsOfstr(res.str.DIG_DEC29)
	else
		G_TipsOfstr(res.str.DIG_DEC31)
		debugprint("救援无返回")
	end 
end
--好友
function DigProxy:sendfriend( param )
	-- body
	self.enemy  =nil 
	if param.enemy  then 
		self.enemy  = true
	end
	self.daoId = -1 
	if param.daoId then 
		self.daoId = param.daoId
	end
	local pflag = 0
	if param.flag then 
		pflag = param.flag
	end
	local data = {flag = pflag,daoId = self.daoId }
	self:send(120005,data)
end

function DigProxy:DigFriendCallBack(data_ )
	-- body
	if data_.status == 0 then 
		if #data_.wkFriendList == 0 then 
			if not self.enemy then 
				G_TipsOfstr(res.str.DIG_DEC10)
			else
				G_TipsOfstr(res.str.DEC_ERR_08)
			end
		else
			local view = mgr.ViewMgr:showView(_viewname.DIG_FRIEND)
			if view then 
				if not self.enemy then 
					view:setData(data_.wkFriendList)
				else
					for k , v in pairs(data_.wkFriendList) do 
						if v.hasInvite > 1 then 
							local _data = cache.Dig:updateInfoCheer(v) --更新助阵者
							if _data then 
								local view = mgr.ViewMgr:get(_viewname.DIG_MIAN)
								view:initItem(_data)
							end

							local view2 = mgr.ViewMgr:get(_viewname.DIG_PROGRESS)
							view2:updateName(v)
							break;
						end
					end
					if self.daoId > 0 then
						view:setData3(data_.wkFriendList,self.daoId)
					else
						view:setData3(data_.wkFriendList)
					end
				end
			end
		end 
	else
		debugprint("好友信息失败")
	end 
end
--请求加速信息
function DigProxy:sendJiasu(param)
	-- body
	self.daoId = param.daoId
	self:send(120006,param)
end

function DigProxy:DigJianse( data_ )
	-- body
	if data_.status == 0 then 

		local data =cache.Dig:updateDaoId(data_)
		local view = mgr.ViewMgr:get(_viewname.DIG_INNER_MAIN)
		if view then 
			view:setData(data,true)
		end 

		local _view = mgr.ViewMgr:get(_viewname.DIG_MIAN)
		if _view then
			_view:initItem(data)
		end 

		local count = cache.Player:getDigNumber()
		count = count +1 
		if count < 0 then 
			count = 0
		end 
		cache.Player:_setDigNumber(count)

		--if count == 0 then
            local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
            if view then 
                view:setFbRed()
            end
        --end
	else
		debugprint("加速信息失败")
	end 
end
--请求领取
function DigProxy:sendGet(param)
	-- body
	self:send(120007,param)
end

function DigProxy:DigGetCallBack( data_ )
	-- body
	if data_.status == 0 then 
		local view = mgr.ViewMgr:get(_viewname.DIG_PROGRESS)
		view:getCallBack()

		local data =cache.Dig:updateDaoId(data_)
		local param = {roleId = cache.Player:getRoleInfo().roleId,daoId  = data_.daoId}
		self:sendOneMsg(param)

		local _view = mgr.ViewMgr:get(_viewname.DIG_MIAN)
		if _view then
			_view:initItem(data)
		end 

		local count = cache.Player:getDigNumber()
		if data_.state == 0 then 
			--count = count 
		else
			count = count - 1 
			if count < 0 then 
				count = 0
			end 
		end
		cache.Player:_setDigNumber(count)

		--if count == 0 then
            local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
            if view then 
                view:setFbRed()
            end
       -- end
	else
		debugprint("领取失败")
	end 
end
--请求加速信息
function DigProxy:sendJiasuMsg(param)
	-- body
	self:send(120008,param)
end

function DigProxy:JiasuMsgCallBack( data_ )
	-- body
	if data_.status == 0 then 
		local view = mgr.ViewMgr:showView(_viewname.DIG_JIASU_SECOND)
		view:setData(data_)
	elseif data_.status == 21200001 then 
		local function getMaxCout()
			-- body
			local count = 0
			for i = 17 , 1 , -1 do 
				count = conf.Recharge:getVipLimit(i,40351)
				if count > 0 then 
					return count
				end 
			end 

			return 0
		end

		if conf.Recharge:getVipLimit(cache.Player:getVip(),40351) == getMaxCout() then 
			local data = {}
			data.sure = function( ... )
				-- body
			end
			data.surestr = res.str.SURE
			data.richtext =res.str.DIG_DEC28
			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
			return 
		end 
		local data = {}
		data.vip = res.str.DIG_DEC30
		data.sure = function()
			-- body
			 mgr.ViewMgr:closeView(_viewname.NOENOUGHTVIEW)
			 G_GoReCharge()
		end
		data.cancel = function()
			-- body
		end
		data.surestr= res.str.RECHARGE
		local view = mgr.ViewMgr:showTipsView(_viewname.NOENOUGHTVIEW)
		view:setData(data)

	else
		debugprint("加速xinxi")
	end 
end

function DigProxy:sendEnemy( )
	-- body
	self:send(120009)
end
function DigProxy:DigEnemylistCallBack (data_)
	-- body
	if data_.status == 0 then 
		if #data_.enemyList == 0 then 
			G_TipsOfstr(res.str.DIG_DEC70)
			return 		 	
		end 

		local view = mgr.ViewMgr:showView(_viewname.DIG_FRIEND)
		if view then 
			view:setData2(data_.enemyList)
		end
	else

	end
end

-------------邀请助阵
function DigProxy:sendYaoqing( param )
	-- body
	self.idx = param.idx

	local data = {roleId = param.roleId,daoId =param.daoId  }
	printt(data)

	self:send(120010,data)
end

function DigProxy:YaoqingCallBack( data_ )
	-- body
	if data_.status == 0 then 
		G_TipsOfstr(res.str.DEC_ERR_05)
		if self.idx then 
			local view = mgr.ViewMgr:get(_viewname.DIG_FRIEND)
			if view then 
				view:updateDataByidx(self.idx)
			end 
		end 
	elseif 21200011 == data_.status then 
		G_TipsOfstr(res.str.DIG_DEC76)
	elseif 21200012 == data_.status then 
		G_TipsOfstr(res.str.DEC_ERR_01)
	elseif 21200014 == data_.status then 
		G_TipsOfstr(res.str.DEC_ERR_04)
	elseif 21200015 == data_.status then 
		G_TipsOfstr(res.str.DEC_ERR_07)
	else
		debugprint("data_.status = "..data_.status)
	end
end

--
function DigProxy:send120011( param )
	-- body
	self:send(120011,param)
end

function DigProxy:YaoqingBangCallBack( data_)
	-- body
	if data_.status == 0 then 
		G_TipsOfstr(res.str.DIG_DEC78)
	end
end


return DigProxy




