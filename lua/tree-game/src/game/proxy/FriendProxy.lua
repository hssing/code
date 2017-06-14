--
-- Author: Your Name
-- Date: 2015-07-27 20:02:11
--

local FriendProxy = class("FriendProxy", base.BaseProxy)

function FriendProxy:init(  )
	-- body
	--好友列表返回
	self:add(518001,self.reqFriendListCallback)
	--请求系统推荐好友列表返回
	self:add(518002,self.reqSysCommandFriendCallback)
	--请求领取体力列表返回
	self:add(518003,self.reqGetMenualListCallback)
	--请求赠送体力返回
	self:add(518004,self.reqGiveMenualCallback)
	--请求邀请好友返回
	self:add(518005,self.reqInvitationFriendCallback)
	--请求领取体力返回518003
	self:add(518006,self.reqGetMenualCallbacl)
	--请求删除好友返回
	self:add(518007,self.reqDelFriendCallback)
	self.data = nil
end

-- 请求好友列表
function FriendProxy:reqFriendList(  )
	-- body
	print("reqFriend")
	--G_Loading(true)
	self:send(118001)
	self:wait(518001)
end

function FriendProxy:reqFriendListCallback( data )
	-- body
	--G_Loading(false)
	print("+++++++++++++++好友列表++++++++++++++++")
	--dump(data)
	if data.status == 0 then
		----体力红点
		cache.Player:_setHaoYNumber(data.tlCount)
		self.data = data
		local friendList = data.friendList
		if friendList then
			local view = mgr.ViewMgr:get(_viewname.FRIEND)
			if view then
				view:setListData(self:sortItems(friendList),data.tlCount)
			end
		end	
	end

end




--请求系统推荐的好友
function FriendProxy:reqSysRecommandFriend( rName )
	-- body
	print("ppppp")
	--G_Loading(true)
	self:send(118002,{roleName=rName})
	self:wait(518002)
	--self:send(118004,{roleName=34})
end

function FriendProxy:reqSysCommandFriendCallback( data )
	-- body
	--dump(data)
	--G_Loading(false)
	if data.status == 0 then
		--todo
		self.data = data
		local friendList = data.friendList
		if #friendList <= 0 then
			--todo没有对应的角色信息
			G_TipsOfstr(res.str.FRIEND_TIPS2)
		end
		local view = mgr.ViewMgr:get(_viewname.FRIEND)
		if view then
			view:setListData(self:sortItems(friendList))
		end

		--local view =  mgr.ViewMgr:get(_viewname.FRIEND)
		--mgr.ViewMgr:get(_viewname.FRIEND):setListData(self.data)
	end
end


--请求领取体力列表
function FriendProxy:reqGetMenualList( )
	-- body
	--G_Loading(true)
	self:send(118003)
	self:wait(518003)
end

function FriendProxy:reqGetMenualListCallback( data )
	-- body
	print("++++++++++++++reqGetMenualListCallback+++++++++++++++++")
	--dump(data)
	--G_Loading(false)
	if data.status == 0 then
		--todo
		self.data = data
		local friendList = data.friendList
		----------更新主界面红点
		cache.Player:_setHaoYNumber(#friendList)
		local view = mgr.ViewMgr:get(_viewname.MAIN)
		if view then
			view:setRedPoint()
		end

		local view = mgr.ViewMgr:get(_viewname.FRIEND)
		if view then
			view:setListData(self:sortItems(friendList),data.canLingTl)
		end

		
	end

end


--请求赠送体力
function FriendProxy:reqGiveMenual( rId )
	-- body
	self:send(118004,{roleId=rId})
end

function FriendProxy:reqGiveMenualCallback( data )
	-- body
	print("+++++++++++++reqGiveMenualCallback++++++++++++++++++")
	--dump(data)
	if data.status == 0 then
		--todo
		string.format(res.str.FRIEND_TIPS3, 1)
		G_TipsOfstr(string.format(res.str.FRIEND_TIPS3, 1))
		local view = mgr.ViewMgr:get(_viewname.FRIEND)
		if view then
			view:reqGiveMenualSucc(data)
		end

	elseif data.status == 20010217 then
		G_TipsOfstr(res.str.FRINED_TIPS4)
	elseif data.status == 20010215 then
		G_TipsOfstr(res.str.FRIEND_TIPS5)
	end
end

--请求邀请好友
function FriendProxy:reqInvitationFriend( rId )
	-- body

	self:send(118005,{roleId=rId})

end

function FriendProxy:reqInvitationFriendCallback( data )
	-- body
	print("+++++++++++++reqInvitationFriendCallback++++++++++++++++++")
	--dump(data)
	if data.status == 0 then
		--todo
		G_TipsOfstr(res.str.FRIEND_TIPS6)
		-- local  view = mgr.ViewMgr:get(_viewname.FRIEND)
		-- view:invitationSucc(data)
	elseif data.status == 20010218 then
		G_TipsOfstr(res.str.FRIEND_TIPS7)
	elseif data.status == 20010202 then
		G_TipsOfstr(res.str.FRIEND_TIPS8)
	elseif data.status == 20010219 then
		G_TipsOfstr(res.str.FRIEND_TIPS9)
	elseif data.status == 20010221 then
		G_TipsOfstr(res.str.FRIEND_TIPS14)
	end
end

--请求领取体力
function FriendProxy:reqGetMenual( rId )
	-- body
	self:send(118006,{roleId=rId})
	self:wait(518006)
end
--请求领取体力返回
function FriendProxy:reqGetMenualCallbacl( data )
	-- body

	print("+++++++++++++reqGetMenualCallbacl++++++++++++++++++")
	--dump(data)
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.FRIEND)
		if view then
			view:getMenualSucc(data)
		end
	elseif data.status == 20010211 then
		G_TipsOfstr(res.str.FRIEND_TIPS10)
	elseif data.status == 20010201 then
		G_TipsOfstr(res.str.FRIEND_TIPS11)
	end

end

------请求删除好友
function FriendProxy:reqDelFriend( rid )
	-- body
	self:send(118007,{roleId = rid})
end

function FriendProxy:reqDelFriendCallback( data )
	-- body
	print("++++++++++++++del+++++++++++++++++")
	--dump(data)
	if data.status == 0 then
		--todo
		local view = mgr.ViewMgr:get(_viewname.FRIEND)
		if view then
			--todo
			view:delFriendSucc(data)

		else
			local view = mgr.ViewMgr:get(_viewname.CHATTING)
			if view then
			--todo
			view:delFriendSucc(data)
			end
		end

		
	end
end





function FriendProxy:sortItems( data )
	-- body

	local sortedData =self: sortByStatus(data)
return sortedData
end


----战斗力排序
function FriendProxy:sortByStatus( data )
	-- body
	
	local online = {}
	local offline = {}
	--根据在线状态分组，在排序
	for i=1,#data do
		
		if data[i].listTime == 0 then
			--todo
			online[#online + 1] = data[i]
		else
				--todo
			offline[#offline + 1] = data[i]
		end
	end
	
	online =self:sortByPower(online)

	local sortedData = {}
	----对不同状态分开排序
	for i=1,#online do
		sortedData[#sortedData + 1] = online[i]
	end

	--按离线时间排
	--dump(offline)
	self:sortByPower(offline)
	---self:sortByTime(offline)
	for i=1,#offline do
		sortedData[#sortedData + 1] = offline[i]
	end


return sortedData

end

----战斗力排序
function FriendProxy:sortByPower( data )

	for i=1,#data - 1 do
		for j=i + 1,#data do
			repeat
				 --离线，按离线时间排
					if data[i].listTime > data[j].listTime then
						--todo
						local tmp = data[i]
						data[i] =  data[j]
						data[j] = tmp
						break

					elseif data[i].listTime == 0 or data[i].listTime == data[j].listTime then
						if data[i].power < data[j].power then --按玩家战斗力排
							local tmp = data[i]
							data[i] =  data[j]
							data[j] = tmp
						elseif data[i].power == data[j].power then---按是否赠送来拍
							--0未赠送1已赠送
							if data[i].isTl > data[j].isTl then
								--todo
								local tmp = data[i]
								data[i] =  data[j]
								data[j] = tmp
							elseif data[i].isTl == data[j].isTl then--按玩家等级
								if data[i].roleId["key"] > data[j].roleId["key"] then --按ID排
									--todo
									local tmp = data[i]
									data[i] =  data[j]
									data[j] = tmp
								end
							end
						end
					end
				
				break
			until true

				--print(i.."--------"..j)
		end
	end

	return data
end




return FriendProxy