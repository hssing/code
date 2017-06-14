--
-- Author: chenlu_y
-- Date: 2015-12-10 21:42:52
--
local PrivateEmailProxy = class("PrivateEmailProxy", base.BaseProxy)

function PrivateEmailProxy:init(  )
	--发送私信返回
	self:add(509003, self.sendMsgCallBack)
end

--发送私信
function PrivateEmailProxy:sendMsg(rid, str)
	self:send(109003, {roleId = rid, content = str})
end

---发送私信返回
function PrivateEmailProxy:sendMsgCallBack( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.PRIVATEEMAIL)
		if view then
			view:closeSelfView()
		end
		G_TipsOfstr(res.str.CHAT_TIPS17)
	elseif data.status == 20010115 then
		G_TipsOfstr(res.str.CHAT_TIPS15)
	elseif data.status == 20010117 then
		G_TipsOfstr(res.str.CHAT_TIPS13)
	elseif data.status == 20010118 then
		G_TipsOfstr(res.str.CHAT_TIPS19)
	elseif data.status == 20010119 then
		G_TipsOfstr(res.str.CHAT_TIPS20)
	elseif data.status == 20010120 then
		G_TipsOfstr(res.str.CHAT_TIPS21)
	else
		G_TipsError(data.status)
	end
end


return PrivateEmailProxy