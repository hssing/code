
local MsgClass=require("game.views.friends.MessageItem")

local MailItemview = class("MailItemview",function(  )
	return ccui.Widget:create()
end)

function MailItemview:ctor( ... )
	-- body
end

function MailItemview:init(Parent,type)
	-- body
	self.Parent=Parent
	self.type=type
	self.view=Parent:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	--self.
	--多久之前的消息
	self._t_time =self.view:getChildByName("txt_name_0")
	--何种类型的消息
	self._t_title = self.view:getChildByName("Image_bg_title"):getChildByName("txt_name")
	--包含了有奖励的容器
	self._p_reward = self.view:getChildByName("Panel_2")
	--无奖励的文本容器
	self._p_txt = self.view:getChildByName("Panel_3_4")

	--私信文本<带表情>
	self._p_txt2 = self.view:getChildByName("Panel_3_4_0")
	--se
	self._b_btnLeft = self.view:getChildByName("btn_left")
	self._b_btnLeft:addTouchEventListener(handler(self,self.onleftCallBack))
	self._b_btnright = self.view:getChildByName("btn_right")
	self._b_btnright:addTouchEventListener(handler(self,self.onRigthCallBack))

	self.img_new  = self.view:getChildByName("Image_1")
end


function MailItemview:setDectime(time)


	local distime =   time
	local str = res.str.MAILVIEW_MSG_NOLONG
	if distime > 3600*24 then 
		str = string.format(res.str.MAILVIEW_MSG_Day,math.floor(distime/(3600*24)))
	elseif distime > 3600 then 
		str = string.format(res.str.MAILVIEW_MSG,math.floor(distime/3600))
	end	
	self._t_time:setString(str)
end
function MailItemview:onleftCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		if self.data.mtype == 301 or self.data.mtype == 303 then 
			local mState = 7
			local mailId = self.data.mailId
			proxy.Mail:sendGet(mailId,mState)
			--debugprint("拒绝加好友")
		end 
	end
end	

function MailItemview:onRigthCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		local mailId = self.data.mailId
		if self.data.mtype == 101 then 
			local mState = 1
			proxy.Mail:sendGet(mailId,mState)
			--debugprint("领取按下")
		elseif self.data.mtype == 201 then
			
	  		mgr.SceneMgr:getMainScene():changeView(5)
	  		local  _view =mgr.ViewMgr:get(_viewname.FUNBENVIEW)
	  		if _view then 
	  			_view:nextStep(1)
	  	    end 
	         --self.Parent:onCloseHandler()
			--debugprint("去竞技场")
		elseif self.data.mtype == 301 or self.data.mtype == 303 then
			local mState = 6
			proxy.Mail:sendGet(mailId,mState)
			--debugprint("同意加好友") 
		elseif self.data.mtype == 102 then 
			debugprint("后台邮件")
			if self.data.mState == 1 then 
				
			else
				local mState = 1
				if #self.data.items  == 0 then 
					proxy.Mail:sendGet(mailId,mState,true,true)
				else
					proxy.Mail:sendGet(mailId,mState,true)
				end 
			end 

			local view = mgr.ViewMgr:showView(_viewname.MAILVIEWBACK)
			view:setData(self.data)
		elseif self.data.mtype == 103 then 
			if self.data.mState == 0 then 
				local mState = 1
				proxy.Mail:sendGet(mailId,mState,true)
			end 

			proxy.Contest:sendWinnerMsg()
			mgr.NetMgr:wait(519101)
		elseif self.data.mtype == 202 then 
			if self.data.mState == 0 then 
				local mState = 1
				proxy.Mail:sendGet(mailId,mState)
			end 
			
			local t = {"FUNBENVIEW",0}
			G_GoToView(t)

			local data = {roleId = mailId,type = 4}
			proxy.Dig:sendDigMainMsg(data)
			mgr.NetMgr:wait(520002)

		elseif self.data.mtype == 304 then 	
			local dxName = self.data.titleStr
			dxName = string.sub(dxName, 1, string.len(dxName)-string.len(res.str.RES_GG_91))
			local sxView = mgr.ViewMgr:showView(_viewname.PRIVATEEMAIL)
			sxView:setMailid(mailId)
			sxView:setTargetRid(self.data.sendRoleId, dxName)
			--proxy.Mail:sendGet(mailId,6)
		end 
	end
end	

function MailItemview:onOpenItem( send,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then

		--local tag = send:getTag()
		--mgr.ViewMgr:showView(_viewname.PRO_TIPS):setData(self.data)
	end
end

function MailItemview:setData(data_ )
	-- body
	self.data = data_
	if not data_ then 
		return 
	end 

	if self.msgItemList then
		for i,msgItem in ipairs(self.msgItemList) do
			msgItem:removeFromParent()
		end
		self.msgItemList = nil
	end
	self.msgItemList = {}

	--邮件标题
	local titlename = data_.titleStr
	self._t_title:setString(titlename..":")
	--邮件时间
	self:setDectime(data_.lastTime)
	--
	self._p_reward:setVisible(false)
	self._p_txt:setVisible(false)

	self._b_btnLeft:setVisible(false)
	self._b_btnright:setVisible(false)

	self._b_btnright:setBright(true)
	self._b_btnright:setTouchEnabled(true)

	self._b_btnLeft:setBright(true)
	self._b_btnLeft:setTouchEnabled(true)

	self._p_txt2:setVisible(false)
	self.img_new:setVisible(false)
	if data_.mState == 0 then 
		self.img_new:setVisible(true)
	end 

	if #data_.items>0 then
		--printt(data_.items)
		
		local lab = self._p_reward:getChildByName("txt_zai") 
		lab:setString(data_.contentStr)

		if data_.mtype == 102 then 
			local s = string.gsub(data_.contentStr, "%c", "") 
			s = string.gsub(s, " ", "") 
			if string.utf8len(s) > 20 then 
				lab:setString(string.sub(s,1,3*20).."...")
			end 
		end 

		local list = {}
		for i = 1 , 3 do 
			local reward = self._p_reward:getChildByName("btn_reward"..i)
			reward:setTag(i)
			reward:setVisible(false)

			local txt_name = self._p_reward:getChildByName("txt_reward_"..i)
			txt_name:setVisible(false)
			reward.name =txt_name 
			table.insert(list,reward)
		end	



		for k ,v in pairs(data_.items) do 
			if k > 3 then  --221023124
				break;
			end	
			local function  onOpenItem()
				-- body
				
				--mgr.ViewMgr:showView(_viewname.PRO_TIPS):setData(v)
			end
			local lv=conf.Item:getItemQuality(v.mId)
			local framePath=res.btn.FRAME[lv]
			list[k]:loadTextureNormal(framePath)
			list[k]:addTouchEventListener(onOpenItem)
			local path=conf.Item:getItemSrcbymid(v.mId, v,propertys)
			list[k]:getChildByName("img_icon"..k):loadTexture(path)
			list[k]:setVisible(true)

			local name = conf.Item:getName(v.mId,v.propertys)
			list[k].name:setString(name.."x"..v.amount)
			list[k].name:setColor(COLOR[lv])
			list[k].name:setVisible(true)

		end
		if data_.mtype == 101  then 
			self._b_btnright:setVisible(true)
			self._b_btnright:setBright(true)
			self._b_btnright:setTouchEnabled(true)
			self._b_btnright:setTitleText(res.str.MAILVIEW_GET)
			if data_.mState == 1 then 
				self._b_btnLeft:setVisible(false)
				self._b_btnright:setBright(false)
				self._b_btnright:setTouchEnabled(false)

				self._b_btnright:setTitleText(res.str.MAILVIEW_GET_OVER)
			end 
		end 
		self._p_reward:setVisible(true)
	else
		self._p_txt:setVisible(true)
		local lab =self._p_txt:getChildByName("Text_17") 
		lab:ignoreContentAdaptWithSize(false)
		lab:setString(data_.contentStr)

		if data_.mtype == 102 then 
			local s = string.gsub(data_.contentStr, "%c", "") 
			s = string.gsub(s, " ", "") 
			if string.utf8len(s) > 50 then 
				lab:setString(string.sub(s,1,3*50).."...")
			else
				--print(s)
				lab:setString(s)
			end 
		end 

		if data_.mtype == 301 or data_.mtype == 303 then 
			self._b_btnLeft:setVisible(true)
			self._b_btnright:setVisible(true)
			self._b_btnright:setBright(true)
			self._b_btnright:setTouchEnabled(true)

			self._b_btnLeft:setTitleText(res.str.MAILVIEW_REF)
			self._b_btnright:setTitleText(res.str.MAILVIEW_ARGEE)
			if data_.mState > 0 then 
				self._b_btnLeft:setVisible(false)
				self._b_btnright:setBright(false)
				self._b_btnright:setTouchEnabled(false)
				if data_.mState == 6 then 
					self._b_btnright:setTitleText(res.str.MAILVIEW_ARGEE)
				else
					self._b_btnright:setTitleText(res.str.MAILVIEW_REF)
				end 
			end 
			
		elseif data_.mtype == 201 then 
			self._b_btnright:setBright(true)
			self._b_btnright:setTouchEnabled(true)
			self._b_btnright:setVisible(true)
			self._b_btnright:setTitleText(res.str.MAILVIEW_QJJ)
		elseif data_.mtype == 101 then 
			self._b_btnright:setVisible(true)
			self._b_btnright:setBright(true)
			self._b_btnright:setTouchEnabled(true)
			self._b_btnright:setTitleText(res.str.MAILVIEW_DEC2)
			if data_.mState == 1 then 
				self._b_btnright:setBright(false)
				self._b_btnright:setTouchEnabled(false)

				self._b_btnright:setTitleText(res.str.MAILVIEW_DEC3)
			end 
		elseif data_.mtype == 304 then 
			self._b_btnright:setBright(true)
			self._b_btnright:setTouchEnabled(true)
			self._b_btnright:setVisible(true)
			if data_.mState == 0 then 
				self._b_btnright:setTitleText(res.str.MAILVIEW_DEC6)
			elseif data_.mState == 6 then --已回复
				self._b_btnright:setTitleText(res.str.MAILVIEW_DEC7)
			elseif data_.mState == 7 then  --已查看
				self._b_btnright:setTitleText(res.str.MAILVIEW_DEC8)
			end	

			self._p_txt:setVisible(false)
			self._p_txt2:setVisible(true)
			local txtBgSzie = self._p_txt2:getContentSize()
			local newW = txtBgSzie.width
			local newH = txtBgSzie.height
			local msg = MsgClass.new()
			msg:initWithStr(data_.contentStr, newW, newW, newH)
			self._p_txt2:addChild(msg, 99)
			msg:setPosition(newW/2, newH/2)

			table.insert(self.msgItemList, msg)
		end 
	end 

	if data_.mtype == 102 then 
		self._b_btnright:setVisible(true)
		self._b_btnright:setBright(true)
		self._b_btnright:setTouchEnabled(true)
		self._b_btnright:setTitleText(res.str.MAILVIEW_DEC2)

		if data_.mState == 1 then 
			--self._b_btnLeft:setVisible(false)
			--self._b_btnright:setBright(false)
			--self._b_btnright:setTouchEnabled(false)

			if #data_.items > 0 then 
				self._b_btnright:setTitleText(res.str.MAILVIEW_GET_OVER)
			else
				self._b_btnright:setTitleText(res.str.MAILVIEW_DEC3)
			end
		end 
	end 


	if data_.mtype == 103 then 
		self._b_btnright:setVisible(true)
		self._b_btnright:setBright(true)
		self._b_btnright:setTouchEnabled(true)
		self._b_btnright:setTitleText(res.str.MAILVIEW_DEC5)
	end 

	if data_.mtype == 202 then 
		self._b_btnright:setVisible(true)
		self._b_btnright:setBright(true)
		self._b_btnright:setTouchEnabled(true)
		self._b_btnright:setTitleText(res.str.DEC_ERR_06)
		--[[if data_.mState == 1 then 
			self._b_btnright:setBright(false)
			self._b_btnright:setTouchEnabled(false)
			self._b_btnright:setTitleText(res.str.MAILVIEW_DEC3)
		end ]]--
	end

	--文件岛 请求助阵
	--[[if data_.mtype == 303 then 
		self._b_btnLeft:setVisible(true)
		self._b_btnright:setVisible(true)
		self._b_btnright:setBright(true)
		self._b_btnright:setTouchEnabled(true)

		self._b_btnLeft:setTitleText(res.str.MAILVIEW_REF)
		self._b_btnright:setTitleText(res.str.MAILVIEW_ARGEE)

		if data_.mState > 0 then 
			self._b_btnLeft:setVisible(false)
			self._b_btnright:setBright(false)
			self._b_btnright:setTouchEnabled(false)
			if data_.mState == 6 then 
				self._b_btnright:setTitleText(res.str.MAILVIEW_ARGEE)
			else
				self._b_btnright:setTitleText(res.str.MAILVIEW_REF)
			end 
		end 
	end]]--
end

return MailItemview

