local MailProxy=class("MailProxy",base.BaseProxy)

function MailProxy:init()
  self:add(509001 ,self.returnback)
  self:add(509002 ,self.returngetback)

  self.first = {}
  self.type0page = 1 
  self.type1page = 1 
  self.type2page = 1 
  self.type3page = 1
  --当前请求类型
  self.type = 0
  --当前请求领取邮件ID
  self.mailId  = {}
end

function MailProxy:returngetback( data_ )
	-- body
	if data_.status == 0 then 	
		if self.mailId~= -1 then
			local data = cache.Mail:update(data_,self.mailId,self.mState)
			local view = mgr.ViewMgr:get(_viewname.MAILVIEW)
			if view then 
				view:setData(cache.Mail:getAllDataInfo())
				--view:Toclick()
				view:updateinfo(self.mailId)
			end 

			--弹出获得界面
			local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
			if (not view and self.mState == 1 and not self.flag ) and #data>0 then
				view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
				view:setData(data,true,true)
				view:setButtonVisible(false)
			elseif self.flag then 
				self.flag = nil 
				if not self.flag1 then 
					G_TipsOfstr(res.str.MAILVIEW_DEC4)
				end 
				self.flag1 = false
			end
		else
			cache.Mail:update(data_,self.mailId,self.mState)
			if self.mState == 997 then
				G_TipsOfstr(res.str.DEC_NEW_18)
			elseif self.mState == 998 then
				G_TipsOfstr(res.str.DEC_NEW_19)
			else
				G_TipsOfstr(res.str.DEC_NEW_20)
			end
			local view = mgr.ViewMgr:get(_viewname.MAILVIEW)
			if view then
				view:setData(cache.Mail:getAllDataInfo())
				view:updateData()
				view:setRedPoint()
			end
		end
	elseif 20010202 == 	data_.status then 
		G_TipsOfstr(res.str.FRIEND_TIPS8)
	elseif 20010221 == data_.status then
		G_TipsOfstr(res.str.FRIEND_TIPS14)
	elseif 21030001 == data_.status then 
		G_TipsOfstr(res.str.NO_ENOUGH_PACK)
	elseif 21200012 == data_.status then 
		G_TipsOfstr(res.str.DEC_ERR_01)
		local data = cache.Mail:update(data_,self.mailId,self.mState)
		local view = mgr.ViewMgr:get(_viewname.MAILVIEW)
		if view then 
			view:setData(cache.Mail:getAllDataInfo())
			view:Toclick()
		end 
	elseif 21200014 == data_.status then 
		G_TipsOfstr(res.str.DEC_ERR_12)
	else
		debugprint("邮件失败")
	end 

end

function MailProxy:returnback( data_ )
  -- body
	if data_.status ==0 then 
		--print("self.type = "..self.type)
		local page = self["type"..self.type.."page"]

		self["type"..self.type.."page"] = self["type"..self.type.."page"]+1
		
		--printt(data_)
		cache.Mail:setDataInfo(data_,page,self.type)
		local view = mgr.ViewMgr:get(_viewname.MAILVIEW)
		if view then 
			
			if self.first[self.type] then 
				--print("-----------")
				view:setData(cache.Mail:getAllDataInfo())
				view:Toclick()
			else
				--print("88888888888888")
				view:setData(cache.Mail:getAllDataInfo())
				view:updateData(data_.mailInfos)
			end 
			view:setRedPoint()
		end 
	else
		debugprint("邮件信息返回失败")
	end 
end

function MailProxy:sendMessage( types , first )
	-- body
	self.first[types] = first and true or false
	if self.first[types] then 
		self["type"..types.."page"] = 1
	end 

	self.type = types
	local  data = {
		stype = types,
		pageIndex = self["type"..types.."page"],
		pateCount = 10,
	}
	debugprint("pageIndex ="..self["type"..types.."page"])
	if not self.first[types] then 
		if cache.Mail:getMaxpagebYtype(types) and cache.Mail:getMaxpagebYtype(types)<self["type"..types.."page"] then 
			if cache.Mail:getMaxpagebYtype(types)>1 then 
				G_TipsOfstr(res.str.MAIL_NOMOREMESSAGE)
			end 
			return
		end 
	end 

	self:send(109001,data)
end

function MailProxy:sendGet(pmailId,pmState,flag,flag1)
	-- body
	self.flag1 = flag1
	self.flag = flag
	self.mailId = pmailId
	self.mState = pmState
	local data = {
		mailId = pmailId,
		mState = pmState,
	}
	self:send(109002,data)
end

return MailProxy
