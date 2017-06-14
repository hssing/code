--
-- Author: Your Name
-- Date: 2015-08-03 12:04:46
--

local InvitationProxy = class("InvitationProxy", base.BaseProxy)

function InvitationProxy:init(  )
	-- body
	--请求邀请码信息返回
	self:add(516052,self.reqInvitationinfoCallback)

	------邀请好友返回
	self:add(516053,self.invitateCallback)

	------请求已邀请的好友返回
	self:add(516054,self.invitatedFriendCallback)


	--分享返回
	self:add(513003,self.reqShareCallbacl)

end

--请求邀请码信息
function InvitationProxy:reqInvitationInfo(  )

	self:send(116052)
	self:wait(516052)
end

--请求邀请码信息返回
function InvitationProxy:reqInvitationinfoCallback( data )
	--dump(data)

	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.INVITATEFRIEND)
		if view then
			view:reqInfoSucc(data)

		end
	end
end




---请求输入邀请码
function InvitationProxy:invitate( key )
	-- body、
	self:send(116053,{tarRoleKey = key})
end

---请求输入邀请码返回
function InvitationProxy:invitateCallback( data )
	-- body
	print("============invitateCallback==============")
	--dump(data)
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.INVITATEFRIEND)
		if view then
			view:reqInvitateSucc(data)
		end
		G_TipsOfstr(res.str.INVITATE_TIPS4)
		cache.Player:setCode(nil)
	elseif data.status == -1 then
		if cache.Player:getCode() and cache.Player:getCode() ~= ""  then
			G_TipsOfstr(res.str.INVITATE_TIPS3)
			cache.Player:setCode(nil)
			return
		end

		G_TipsOfstr(res.str.INVITATE_TIPS2)
	end

end

-----请求已邀请的好友
function InvitationProxy:invitatedFriend(  )
	-- body
	self:send(116054)
end

----请求已邀请的好友返回
function InvitationProxy:invitatedFriendCallback( data )
	-- body
	print("============invitatedFriendCallback==============")
	--dump(data)

	if data.status == 0 then
		local view = mgr.ViewMgr:showView(_viewname.INVITATEDFRIENDLIST)
		if view then
			view:setData(data)
		end
	
	end
end


---请求分享任务
function InvitationProxy:reqShare( task )
	-- body
	self:send(113003,{taskId = task})
end

---请求分享返回
function InvitationProxy:reqShareCallbacl( data )

end






return InvitationProxy