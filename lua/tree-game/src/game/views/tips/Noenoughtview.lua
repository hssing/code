--[[
 	--Noenoughtview  挑战次数不足 ， 或者提示升级vip购买次数 , 探险今日不在提示2次界面
]]
local Noenoughtview=class("Noenoughtview",base.BaseView)
function Noenoughtview:ctor()

end
function Noenoughtview:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self._panle = self.view:getChildByName("Panel_25")--次数不足的框
	self._panle:setVisible(false)
	self._bigpanle = self.view:getChildByName("Panel_26") -- vip提示
	self._bigpanle:setVisible(false)
	self._secPanle = self.view:getChildByName("Panel_27") -- 探险2次选择
	self._secPanle:setVisible(false)

	local p = self.view:getChildByName("Panel_1")
	self.button_sure = p:getChildByName("Button_2")
	gui.GUIButton.new(self.button_sure,handler(self,self.onCallBack))

	self.btn_cancel =  p:getChildByName("Button_close")
	gui.GUIButton.new(self.btn_cancel,handler(self,self.oncancelCallBack))

	self:initDec()
end

function Noenoughtview:initDec()
	-- body
	self.button_sure:getChildByName("Text_1_68"):setString(res.str.SURE)
	self.btn_cancel:getChildByName("Text_1_0_70"):setString(res.str.CANCEL)

	self._panle:getChildByName("dec1"):setString(res.str.ACTIVE_TEXT39)
	self._panle:getChildByName("dec1_0"):setString(res.str.ACTIVE_TEXT40)
	self._bigpanle:getChildByName("Text_1"):setString(res.str.ACTIVE_TEXT41)
	self._bigpanle:getChildByName("Text_1_0"):setString(res.str.ACTIVE_TEXT42)
	self._secPanle:getChildByName("Text_72"):setString(res.str.ACTIVE_TEXT43)
	self._secPanle:getChildByName("Text_72"):setString(res.str.ACTIVE_TEXT44)

	self._bigpanle:getChildByName("Text_1_0_0"):setString(res.str.RES_VIP_VIP)
end

function Noenoughtview:setData(data)
	-- body
	self.data = data
	if self.data.surestr~=nil then 
		self.button_sure:getChildByName("Text_1_68"):setString(self.data.surestr)
	end	

	if not self.data.cancel  then 
		self.btn_cancel:setVisible(false)
		local y = self.button_sure:getPositionPercent().y;
		local x = 0.5
		self.button_sure:setPositionPercent(cc.p(x,y))
	else
		if self.data.cancelstr then 
			self.btn_cancel:getChildByName("Text_1_0_70"):setString(self.data.cancelstr)
		end	
	end	

	self._panle:setVisible(false)
	self._bigpanle:setVisible(false)
	self._secPanle:setVisible(false)
	if self.data.vip then 
		self._bigpanle:setVisible(true)
		local text = self._bigpanle:getChildByName("Text_1")
		text:setString(self.data.vip)

		local text2= self._bigpanle:getChildByName("Text_1_0_0")
		text2:setPositionX(text:getContentSize().width+text:getPositionX())

		local text3 = self._bigpanle:getChildByName("Text_1_0")
		text3:setPositionX(text:getPositionX())

		--text:ignoreContentAdaptWithSize(false)
		--text:setString(self.data.vip)
	else
		if self.data.adv then --探险2次界面 一键探险
			self._checkbox = self._secPanle:getChildByName("CheckBox_1")
			local lab = self._secPanle:getChildByName("Text_72")
			lab:setString(self.data.adv)

			self._checkbox:setSelected(false)
			self._secPanle:setVisible(true)
		elseif self.data.cross then 
			self._checkbox = self._secPanle:getChildByName("CheckBox_1")
			local lab = self._secPanle:getChildByName("Text_72")
			lab:setString("")

			self._checkbox:setSelected(false)
			self._secPanle:setVisible(true)

			local pos = 0

			lab:setString(res.str.DEC_NEW_55)
			--pos = pos + lab:getContentSize().width

			local img = display.newSprite(res.image.ZS)
			img:setScale(0.6)
			img:setAnchorPoint(cc.p(0,0.5))
			img:setPosition(lab:getPositionX()+lab:getContentSize().width/2, lab:getPositionY())
			img:addTo(self._secPanle)

			pos = pos + img:getContentSize().width*img:getScale()

			local lab_1 = lab:clone()
			lab_1:setAnchorPoint(cc.p(0,0.5))
			lab_1:setString(self.data.cross)
			lab_1:setPosition(img:getPositionX()+img:getContentSize().width*img:getScale(),
				lab:getPositionY())
			lab_1:addTo(self._secPanle)
			pos = pos + lab_1:getContentSize().width

			local lab_2 = lab_1:clone()
			lab_2:setString(","..res.str.DEC_NEW_56)
			lab_2:setAnchorPoint(cc.p(0,0.5))
			--lab_2:setString(self.data.cross)
			lab_2:setPosition(lab_1:getPositionX()+lab_1:getContentSize().width,
				lab_1:getPositionY())
			lab_2:addTo(self._secPanle)
			pos = pos + lab_2:getContentSize().width

			lab:setPositionX(lab:getPositionX()-pos/2)
			img:setPositionX(img:getPositionX()-pos/2)
			lab_1:setPositionX(lab_1:getPositionX()-pos/2)
			lab_2:setPositionX(lab_2:getPositionX()-pos/2)
		else
			--proxy.Radio:send101006(40421)
			local money = self.data.amount
			local text = self._panle:getChildByName("dec1_0_0")
			self._panle:setVisible(true)
			text:setString(money)
		end
	end	
end

function Noenoughtview:send101006Callback(amount)
	if  not self.data.vip and not self.data.adv then 
		self._panle:getChildByName("dec1_0_0"):setString(amount)
	end 
end 


--确定返回
function Noenoughtview:onCallBack(sender,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		if self.data.sure then 
			local ff 
			if self._checkbox then 
				ff=  self._checkbox:isSelected()
			end
			self.data.sure(ff)
		end	 
		--self:closeSelfView()
		--mgr.ViewMgr:closeView(self:getPathName())
	end
end
--取消返回
function Noenoughtview:oncancelCallBack( sender ,event_type  )
	-- body
	if event_type == ccui.TouchEventType.ended then
		if self.data.cancel then 
			self.data.cancel()
		end
		self:closeSelfView()
		--mgr.ViewMgr:closeView(self:getPathName())	
	end
end

return Noenoughtview
