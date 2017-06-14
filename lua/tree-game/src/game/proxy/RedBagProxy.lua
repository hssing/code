--
-- Author: Your Name
-- Date: 2015-08-26 14:57:11
--


local RedBagProxy = class("RedBagProxy", base.BaseProxy)


function RedBagProxy:init(  )
	-- body

	--请求发送红包返回
	self:add(518301,self.sendRedBagCallback)

	--请求领取红包返回
	self:add(518302,self.reqGetRedbagCallback)

	--请求查看红包领取信息返回
	self:add(1313,self.reqRedbagDetailCallback)

	--接收红包
	self:add(1313,self.receiveRedbags)
	


end




--请求发送红包
function RedBagProxy:sendRedBag( data )
	-- body
	self:send(118301,data)
end

--请求发送红包返回
function RedBagProxy:sendRedBagCallback( data )
	-- body
	print("============sendRedBagCallback=============")
	printt(data)
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.SEND_REDBAG)
		if view then
			view:sendRedBagSucc(data)
		end

		local view = mgr.ViewMgr:get(_viewname.PACK)
	    if view then
	    	view:scrolltoindex()
	    end
	elseif data.status == 20010203 then
		G_TipsOfstr(res.str.CHAT_TIPS6)
	else
		debugprint("请求发送红包返回错误")
	end
end




--请求领取红包
function RedBagProxy:reqGetRedbag( data )
	-- body
	self:send(118302,data)
	--self:wait(518302)
	--self:reqGetRedbagCallback()
end

--请求领取红包返回
function RedBagProxy:reqGetRedbagCallback( data )

	print("============reqGetRedbagCallback=============")
	

	if data.status == 0 then
		local  cachedData = cache.Redbag:getDataById(data.hbId)
		
		if cachedData then
			for k,v in pairs(data) do
			cachedData[k] = v
			end
		else
			--dump(cache.Redbag:getData())
			--dump(data)
			G_TipsOfstr(res.str.REDBAG_TIPS1)
			local view = mgr.ViewMgr:get(_viewname.HORNTIPS)
			if view then
				view:showNextRedBag(data.hbId)
			end
			print("==============","获取本地红包信息出错")
			return
		end
		--dump(cachedData)
		--红包领取，显示下一个
		local view = mgr.ViewMgr:get(_viewname.HORNTIPS)
		if view then
			view:showNextRedBag(data.hbId)
		end

		if data.flag == 3 then
			G_TipsOfstr(res.str.REDBAG_TIPS1)
			return
		elseif data.flag == 2 then
			mgr.ViewMgr:showView(_viewname.REDBAG_DETAIL,8):setData(cachedData)
		elseif data.flag == 4 then
			mgr.ViewMgr:showView(_viewname.RECEIVE_REDBAG,8):setData(cachedData)
		elseif data.flag == 1 then
			mgr.ViewMgr:showView(_viewname.REDBAG_DETAIL,8):setData(cachedData)
		end
		

			--领取成功，删除该红包信息
		cache.Redbag:pushBackData(data.hbId)
	elseif data.status == 20010114 then
		G_TipsOfstr(res.str.REDBAG_TIPS2)
		--红包领取，显示下一个
		local view = mgr.ViewMgr:get(_viewname.HORNTIPS)
		if view then
			view:showNextRedBag(data.hbId)
		end
	else
		debugprint("请求领取红包返回错误")
	end
end




--请求查看红包领取信息
function RedBagProxy:reqRedbagDetail( data )
	-- body
	self:send()
end

--请求查看红包领取信息返回
function RedBagProxy:reqRedbagDetailCallback( data )
	print("============reqRedbagDetailCallback=============")
	printt(data)
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.REDBAG_DETAIL)
		if view then
			view:setData(data)
		end
	else
		debugprint("查看红包领取信息返回错误")
	end

end




----接收别人发送的 红包，用于显示在 顶层UI
---- 这里与 小喇叭提示层 在同一层上。
function RedBagProxy:receiveRedbags( data )
	-- body
	print("============receiveRedbags=============")
	printt(data)
	if data.status == 0 then
		data.msgType = "redBag"
		data.chatType = 1
		--如果当前在聊天界面，则
		--将消息加入到 聊天面板,否则，加入到聊天记录中
		local chatView =  mgr.ViewMgr:get(_viewname.CHATTING)
		if chatView then
			proxy.Chat:receiveMsg(data)
		else
			cache.Chat:addData(data)
		end

		local view = mgr.ViewMgr:get(_viewname.HORNTIPS)
		if view then
			view:addRedbagData(data)
		end

	else
		debugprint("接收红包信息错误")
	end
end









return RedBagProxy