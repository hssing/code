--[[[
	竞猜界面
]]

local  ContestCompareView = class("ContestCompareView", base.BaseView)

function ContestCompareView:ctor()
	-- body
	self.index = nil --猜谁赢
	self.atype = nil --猜的内省
end

function ContestCompareView:init()
	-- body
	self.ShowAll = true
	--self.ShowBottom = true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	--G_FitScreen(self, "Image_40")

	local panle = self.view:getChildByName("Panel_8")
	self.panle = panle
	self.lab_yitou =panle:getChildByName("Text_33_0") --已投注

	self.param = {}
	self.leftframe = panle:getChildByName("Image_42")
	self.leftspr = self.leftframe:getChildByName("Image_43")
	self.leftname = panle:getChildByName("Image_54"):getChildByName("Text_35")
	self.btn_leftan = panle:getChildByName("Button_23")
	self._leftimg = self.btn_leftan:getChildByName("Image_67") 
	self._leftimg:loadTexture(res.font.YAZHU)
	self.btn_leftan:addTouchEventListener(handler(self, self.onbtnleftCallBack))

	local t = {}
	t.spr = self.leftspr
	t.name = self.leftname
	table.insert(self.param,t)

	self.rightframe = panle:getChildByName("Image_42_0")
	self.rightspr = self.rightframe:getChildByName("Image_43_46")
	self.rightname =  panle:getChildByName("Image_54_0"):getChildByName("Text_35_37")
	self.btn_right = panle:getChildByName("Button_23_0")
	self._rightimg = self.btn_right:getChildByName("Image_67_69") 
	self._rightimg:loadTexture(res.font.YAZHU)
	self.btn_right:addTouchEventListener(handler(self, self.onbtnrightCallBack))

	local t = {}
	t.spr = self.rightspr
	t.name = self.rightname
	table.insert(self.param,t)


	local btn_compare = panle:getChildByName("Button_19")
	btn_compare:addTouchEventListener(handler(self, self.onbtnCompare))

	self.pagebutton=gui.PageButton.new()
	self.pagebutton:setBtnCallBack(handler(self,self.onpagebuttonCallBack))

	self.vistable = {}
	local img_di = panle:getChildByName("Image_48")
	self.pagebutton:addButton(img_di:getChildByName("Button_16"))
	self.pagebutton:addButton(img_di:getChildByName("Button_16_0"))
	self.pagebutton:addButton(img_di:getChildByName("Button_16_1"))

	self.lab_jb1 = img_di:getChildByName("Text_28")
	self.lab_jb2 = img_di:getChildByName("Text_28_30")
	self.lab_jb3 = img_di:getChildByName("Text_28_32")


	table.insert(self.vistable,img_di)
	table.insert(self.vistable,panle:getChildByName("Text_33_1"))
	table.insert(self.vistable,panle:getChildByName("Image_57"))
	table.insert(self.vistable,panle:getChildByName("Text_33_1_0"))
	table.insert(self.vistable,panle:getChildByName("Image_53_0"))
	table.insert(self.vistable,panle:getChildByName("Text_33_0_0"))


	self.lab_prv_get = panle:getChildByName("Text_33_0_0")


	self.lan_done_get = panle:getChildByName("Text_33_0")
	self.lan_done_dec = panle:getChildByName("Text_33")
	self.img_done = panle:getChildByName("Image_53")

	local btn_cai = panle:getChildByName("Button_19_0")
	btn_cai:addTouchEventListener(handler(self, self.onBtnCaiCallBack))

	self.btn_cai = btn_cai


	--界面固定文本
	self.lan_done_dec:setString(res.str.CONTEST_TEXT3)
	btn_compare:setTitleText(res.str.CONTEST_TEXT4)
	panle:getChildByName("Text_33_1"):setString(res.str.CONTEST_TEXT5)
	panle:getChildByName("Text_33_1_0"):setString(res.str.CONTEST_TEXT6)
	btn_cai:setTitleText(res.str.CONTEST_TEXT7)


	self:clear()
	self:vis(false)
end

function ContestCompareView:tomiddle()
	-- body
	local offy = 100 


	self.panle:getChildByName("Image_64"):setPositionY(
		self.panle:getChildByName("Image_64"):getPositionY() - offy )

	self.panle:getChildByName("Image_64_0"):setPositionY(
		self.panle:getChildByName("Image_64_0"):getPositionY() - offy )

	self.panle:getChildByName("Image_42"):setPositionY(
		self.panle:getChildByName("Image_42"):getPositionY() - offy )

	self.panle:getChildByName("Image_42_0"):setPositionY(
		self.panle:getChildByName("Image_42_0"):getPositionY() - offy )

	self.panle:getChildByName("Image_53"):setPositionY(
		self.panle:getChildByName("Image_53"):getPositionY() - offy )

	self.panle:getChildByName("Text_33"):setPositionY(
		self.panle:getChildByName("Text_33"):getPositionY() - offy )

	self.panle:getChildByName("Text_33_0"):setPositionY(
		self.panle:getChildByName("Text_33_0"):getPositionY() - offy )

	self.panle:getChildByName("Image_54"):setPositionY(
		self.panle:getChildByName("Image_54"):getPositionY() - offy )

	self.panle:getChildByName("Image_54_0"):setPositionY(
		self.panle:getChildByName("Image_54_0"):getPositionY() - offy )

	self.panle:getChildByName("Button_19"):setPositionY(
		self.panle:getChildByName("Button_19"):getPositionY() - offy )

	self.panle:getChildByName("Button_23"):setPositionY(
		self.panle:getChildByName("Button_23"):getPositionY() - offy )

	self.panle:getChildByName("Button_23_0"):setPositionY(
		self.panle:getChildByName("Button_23_0"):getPositionY() - offy )

	self.panle:getChildByName("Image_64_0_0_0"):setPositionY(
		self.panle:getChildByName("Image_64_0_0_0"):getPositionY() - offy )

	self.panle:getChildByName("Image_64_0_0"):setPositionY(
		self.panle:getChildByName("Image_64_0_0"):getPositionY() - offy )



end

function ContestCompareView:clear( ... )
	-- body

	self.lan_done_get:setString("")
	self.lan_done_dec:setVisible(false)
	self.img_done:setVisible(false)



	self.lab_prv_get:setString("")
	for k , v in pairs(self.param ) do 
		v.spr:setVisible(false)
		v.name:setString("")
	end 

	for i = 1 , 3 do 
		self["lab_jb"..i]:setString("")
	end 

	self.lab_prv_get:setString("")
end



function ContestCompareView:initRole( param , data )
	-- body
	local sex = data.sex == 1 and "BOY" or "GRIL"
	local role_icon = res.icon.ROLE_ICON[sex]
	param.spr:setVisible(true)
	param.spr:ignoreContentAdaptWithSize(true)
	param.spr:loadTexture(role_icon)
	param.spr:setScale(0.8)
	param.name:setString(data.roleName)
end

function ContestCompareView:updateinfo( data_ )
	-- body
	

	self.winIndex = tonumber(data_.winIndex)

	for k ,v in pairs(self.pagebutton.ListButton) do 
		v:setTouchEnabled(true)
	end 

	self.btn_leftan:setTouchEnabled(true)
	self.btn_right:setTouchEnabled(true)
	self.btn_cai:setTouchEnabled(true)
	self.btn_cai:setTitleText(res.str.CONTEST_DEC10)
	for k, v in pairs(data_.awards) do 
		if checkint(k) ~= 0 then 
			self["lab_jb"..k]:setString(v)
		end 
	end 
	if tonumber(data_.winIndex) ~= 0 then
		for k ,v in pairs(self.pagebutton.ListButton) do 
			v:setTouchEnabled(false)
		end 

		self:tomiddle()

		self.btn_right:setVisible(false)
		self.btn_leftan:setVisible(false)

		--self.btn_cai:setTouchEnabled(false)
		self.btn_cai:setTitleText(res.str.CONTEST_DEC11)

		local _img_ya = display.newSprite(res.font.YIDOUZHU)
		if tonumber(data_.winIndex) == tonumber(self.data[1].index) then 
			_img_ya:addTo(self.leftframe)
			--self.btn_right:setVisible(false)
		else
			_img_ya:addTo(self.rightframe)
			--self.btn_leftan:setVisible(false)
		end 
		_img_ya:setPositionX(25)
		_img_ya:setPositionY(80)

		self.btn_leftan:setVisible(false)

		for k, v in pairs(data_.awards) do 
			if tonumber(k) == tonumber(data_.atype) then 
				self.pagebutton:initClick(tonumber(k))
				self.lan_done_get:setString(tonumber(self["lab_jb"..k]:getString()))
				self.lan_done_dec:setVisible(true)
				self.img_done:setVisible(true)
			end 
		end 

		for k ,v in pairs(self.vistable) do 
			v:setVisible(false)
		end 


	end  

end

function ContestCompareView:setData(data)
	-- body
	self.data = data
	--printt(self.data)
	table.sort(self.data,function( a,b)
		-- body
		return  a.index<b.index
	end)

	for k,v in pairs(self.param) do 
		self:initRole(v,self.data[k])
	end 

	local data = {indexA = self.data[1].index,indexB =self.data[2].index  }
	proxy.Contest:sendMsg(data)
end

function ContestCompareView:onpagebuttonCallBack( index,eventtype )
	-- body
	
	self.atype = index
	self.lab_prv_get:setString(tonumber(self["lab_jb"..self.atype]:getString())*2)
	return self
end

function ContestCompareView:comPareCalllBack( data_ )
	-- body
	cache.Friend:setOnlyClose(true)
	local view = mgr.ViewMgr:createView(_viewname.ATHLETICS_COMPARE)
	local data = {}

	--右边
	local data1 = {}
	data1.tarName = data_.tarBName
	data1.tarLvl = data_.tarBLvl
	data1.tarPower = data_.tarBPower
	data1.tarCards = data_.tarBCards
	data1.huoban = data_.tarBXhbs

	if data1.tarName == self.data[1].roleName then 
		data1.roleId = self.data[1].roleId
	else
		data1.roleId = self.data[2].roleId
	end 


	--左边
	local data = {}
	data.tarName = data_.tarAName
	data.tarLvl = data_.tarALvl
	data.tarPower = data_.tarAPower
	data.tarCards = data_.tarACards
	data.huoban = data_.tarAXhbs

	if data.tarName == self.data[2].roleName then 
		data.roleId = self.data[2].roleId
	else
		data.roleId = self.data[1].roleId
	end 


	view:setData(data1,data)

	mgr.ViewMgr:showView(_viewname.ATHLETICS_COMPARE)
end

function ContestCompareView:onbtnCompare( sender_,eventtype  )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("阵容对比")
		local param = {tarAId =  self.data[1].roleId, tarBId =  self.data[2].roleId }
		printt(param)
		proxy.Contest:sendCompare(param)
		mgr.NetMgr:wait(501201)
		--view:setData({},{})		
	end 
end

function ContestCompareView:vis( flag )
	-- body
	for k , v in pairs(self.vistable) do 
		v:setVisible(flag)
	end

	if flag then 
		for k ,v in pairs(self.pagebutton.ListButton) do 
			v:setTouchEnabled(true)
			v:setHighlighted(false)
		end 

		self.pagebutton.prvButton = nil 
		self.atype = nil 
	end 
end

function ContestCompareView:Setbtnimg(str)
	-- body
	self._leftimg:loadTexture(res.font.YAZHU)
	self._rightimg:loadTexture(res.font.YAZHU)

	if str == self.str then  --如果是第2次点击
		self.index = nil 
		self._leftimg:getParent():setVisible(true)
		self._rightimg:getParent():setVisible(true)
		self.str = nil 
		self:vis(false)
	else
		self:vis(true)
		if str == "left" then 
			self.index = self.data[1].roleId
			self._leftimg:loadTexture(res.other.JIANTOU)
			self._rightimg:getParent():setVisible(false)
		else
			self.index = self.data[2].roleId
			self._rightimg:loadTexture(res.other.JIANTOU)
			self._leftimg:getParent():setVisible(false)
		end

		self.str = str
	end 



	--[[self.btn_leftan:setTouchEnabled(true)
	self.btn_right:setTouchEnabled(true)

	self._rightimg:loadTexture(res.font.YAZHU)
	self._leftimg:loadTexture(res.font.YAZHU)

	--sender_:setTouchEnabled(false)
	if str == "left" then 
		self.index = self.data[1].roleId
		self._leftimg:loadTexture(res.other.JIANTOU)
	else
		self.index = self.data[2].roleId
		self._rightimg:loadTexture(res.other.JIANTOU)
	end ]]--

end

function ContestCompareView:onbtnleftCallBack( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("左边的按钮被按下")
		
		self:Setbtnimg("left",sender_)
	end 
end

function ContestCompareView:onbtnrightCallBack( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("右边的按钮被按下")
		--self.index = self.data[2].index
		self:Setbtnimg("right",sender_)
	end 
end

function ContestCompareView:onBtnCaiCallBack( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		if self.winIndex and self.winIndex ~= 0 then 
			self:onCloseSelfView()
			return 
		end 

		local view = mgr.ViewMgr:get(_viewname.CONTEST_MAIN)
		if not view:checkVideo() then 
			return 
		end 

		if not  self.index  then 
			G_TipsOfstr(res.str.CONTEST_DEC4)
			return 
		elseif  not self.atype then 
			G_TipsOfstr(res.str.CONTEST_DEC5)
			return 
		end 

		debugprint("猜个数字")
		local param = { atype =  self.atype , tarId = self.index }
		printt(param)
		proxy.Contest:sendCai(param)
		mgr.NetMgr:wait(519005)
	end 
end

function ContestCompareView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return ContestCompareView