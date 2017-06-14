--
-- Author: Your Name
-- Date: 2015-08-21 11:29:48
--

local HornProxy = class("HornProxy", base.BaseProxy)

function HornProxy:init(  )
	-- body
	--发送喇叭广播返回
	self:add(518201,self.sendMsgCallBack)

	--接收喇叭广播消息
	self:add(818002,self.receiveMsgCallback)
	

end





--发送小喇叭广播
function HornProxy:sendMsg( str )
	-- body
	print("=============",str)
	self:send(118201,{contentStr = str})
end

---发送广播成功
function HornProxy:sendMsgCallBack( data )
	-- body
	debugprint("=========sendMsgCallBack============")
	printt(data)

	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.HORN)
		if view then
			view:sendMsgSucc()
		end
	elseif data.status == 20010111 then
		G_TipsOfstr(res.str.SYS_OPNE_LV)
	elseif data.status == 20010115 then
		G_TipsOfstr(res.str.CHAT_TIPS15)
	elseif data.status == 20010116 then
		G_TipsOfstr(res.str.CHAT_TIPS16)
	elseif data.status == 20010117 then
		G_TipsOfstr(res.str.CHAT_TIPS13)
	elseif data.status == 20010119 then
		G_TipsOfstr(res.str.CHAT_TIPS20)
	elseif data.status == 20010120 then
		G_TipsOfstr(res.str.CHAT_TIPS21)
	end
end





---接收消息
function HornProxy:receiveMsgCallback( data )
	-- body
	debugprint("===========receiveMsgCallback============")
	printt(data)
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.HORNTIPS)
		if view then
			view:setData(data)
		end
	end
end

-----解析字符串数据
--明天[XX]点有[XX]活动，请驯兽师们注意”




return HornProxy