--
-- Author: Your Name
-- Date: 2015-08-04 15:45:12
--


local ChattingProxy = class("ChattingProxy", base.BaseProxy)


function ChattingProxy:init(  )
	-- body
	--------接收消息
	--接收广播消息
	self:add(818001,self.receiveMsg)
	--请求发送聊天内容返回
	self:add(518101,self.sendMessageStateCallback)
	--请求聊天玩家信息返回
	self:add(518102 ,self.reqFriendInfoCallback)

	self.chatData = {}
	self.maxItemCount = 20
	self.index = 0

end

-----请求聊天玩家信息
function ChattingProxy:reqFriendInfo( rId )
	-- body
	print("=========请求聊天玩家信息===========")
	self:send(118102,{roleId = rId})
end

-----请求聊天玩家信息返回
function ChattingProxy:reqFriendInfoCallback( data )
	-- body
	if data.status == 0 then
		--todo
		--dump(data)
		local view = mgr.ViewMgr:showView(_viewname.FRIENDINFO,8)
		view:setData(data)
	end
	
end


----发送聊天内容
function ChattingProxy:sendMessage( msg )
	-- body
	self:send(118101,msg)
end

function ChattingProxy:sendMessageStateCallback( data )
	-- body

	--dump(data)
	
	if data.status == 20010108 then
		G_TipsOfstr( res.str.CHAT_TIPS1 )
	--	return
	elseif  data.status == 20010109 then
		--todo
		G_TipsOfstr( res.str.CHAT_TIPS2 )
	elseif data.status == 20010110 then
		G_TipsOfstr(string.format(res.str.CHAT_TIPS3,5) )
	--	return
	elseif data.status == 20010111 then
		G_TipsOfstr(string.format(res.str.CHAT_TIPS4, 15))
		return
	elseif data.status == 20010112 then
		G_TipsOfstr(res.str.CHAT_TIPS5 )
		return
	elseif data.status == 20010203 then
		G_TipsOfstr(res.str.CHAT_TIPS6 )
	elseif data.status == 20010115 then
		G_TipsOfstr(res.str.CHAT_TIPS15)
		local view = mgr.ViewMgr:get(_viewname.CHATTING)
		if view then
			view:sendMsgSucc()
		end
	elseif data.status == 20010117 then
		G_TipsOfstr(res.str.CHAT_TIPS13)
	elseif data.status == 20010119 then
		G_TipsOfstr(res.str.CHAT_TIPS20)
	elseif data.status == 20010120 then
		G_TipsOfstr(res.str.CHAT_TIPS21)
	elseif data.status == -1 then-----失败
		return
	elseif data.status == 0 then
	 	--todo -----成功
		local view = mgr.ViewMgr:get(_viewname.CHATTING)
		if view then
			view:sendMsgSucc()
		end
	end
end


----接收消息
function ChattingProxy:receiveMsg( data )
	-- body
	--dump(data)

	--dump(data)
	--print("jiehsouxiaoxi ")
	if data.status == 0 then
		if data.chatType == 8 then--世界红包
			data.msgType = "redBag"
			data.chatType = 1
			data.hbId = data.ext01
		elseif data.chatType == 9 then --公会红包
			data.msgType = "redBag"
			data.chatType = 2
			data.hbId = data.ext01
		elseif data.chatType == 6 or data.chatType == 7 then--喇叭，都是世界聊天类型
			data.msgType = "horn"
			data.cType = data.chatType
			data.chatType = 1

		else-----普通聊天内容
			data.msgType = "text"
			--	如果包含 敏感 字符
			local flag = conf.SensitiveWords:checkChatWords(data.contentStr)
			if flag then
				return
			end
		end

		--将红包显示到主界面
		if data.msgType == "redBag" then
			--显示红包
			--保存到缓存

			data.index = self.index
			data.isShow = false
			self.index = self.index + 1

			cache.Redbag:addData(data)
			local view = mgr.ViewMgr:get(_viewname.HORNTIPS)
			if view  then
				view:addRedbagData(data)
			end
		--将喇叭显示到主界面
		elseif data.msgType == "horn" then
			local view = mgr.ViewMgr:get(_viewname.HORNTIPS)
			if view  then
				view:setData(data)
			end
		end
		
		self.chatData[#self.chatData + 1] = data
		cache.Player:_setChatNumber(#self.chatData)

		local view = mgr.ViewMgr:get(_viewname.CHATTING)
		
		if view and view:getIsShow() == true then
			view:receiveMsg()
		end
		------------保存20条聊天记录
		for i=1,3 do---------1----3表示世界、公会，私聊
			local len = #self:getRecoedByType(i)
			if len > self.maxItemCount then
				self:romoveRecordByType(i,len - self.maxItemCount)
			end
		end
			
	end

end

function ChattingProxy:getChatData(  )
	-- body
	return self.chatData
end

-------@param mtype 消息类型
-------@param num 删除多少条
------删除指定类型的消息（私聊、世界、公会消息）
function ChattingProxy:romoveRecordByType( mtype,num )
	-- body
	local data = {}
	local j = 0
	for i=1,#self.chatData do
		if self.chatData[i]["chatType"] == mtype and num > j  then
			data[#data + 1] = i
			j = j + 1
		end
	end

	 table.sort(data,function ( a,b )
		return a > b
	end)

	for i=1,#data do
		table.remove(self.chatData,data[i])
	end

	cache.Player:_setChatNumber(#self.chatData)

end

------获得指定类型的消息（私聊、世界、公会消息）
function ChattingProxy:getRecoedByType( mtype )
	-- body
	local data = {}
	for i=1,#self.chatData do
		if self.chatData[i]["chatType"] == mtype then
			data[#data + 1] = self.chatData[i]
		end
	end

	return data
end






return ChattingProxy