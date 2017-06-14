--[[
	跨服战 竞猜
]]

local CrossCompareView = class("CrossCompareView",base.BaseView)

function CrossCompareView:ctor()
	-- body
	self.index = nil --猜谁赢
	self.atype = nil --猜的那个那价格
end

function CrossCompareView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local toppanle = self.view:getChildByName("Panel_1")
	--local btnclose = panel:getChildByName("Button_close")
	--btnclose:addTouchEventListener(handler(self, self.onbtnclose))
	self.middle_panle = self.view:getChildByName("Panel_8")
	self:initDec()

	self:vis(false)
end

function CrossCompareView:initDec()
	-- body
	--已投注
	

	self._dec_1 = self.middle_panle:getChildByName("Text_33")
	--self._dec_1:setString(res.str.RES_RES_56)
	self._dec_1:setString("")
	self._img_sh = self.middle_panle:getChildByName("Image_53")
	self._img_sh:setVisible(false)
	self.lab_sh_count = self.middle_panle:getChildByName("Text_33_0")
	self.lab_sh_count:setString("")
	--
	self.leftframe = self.middle_panle:getChildByName("Button_23")
	self.leftspr = self.middle_panle:getChildByName("Image_42"):getChildByName("Image_43") 
	self.leftspr:ignoreContentAdaptWithSize(true)
	self.leftspr:setScale(0.8)

	self._leftimg = self.leftframe:getChildByName("Image_67")
	self._leftimg:loadTexture(res.font.YAZHU)
	self.leftname = self.middle_panle:getChildByName("Image_54"):getChildByName("Text_35")
	self.leftname:setString("")
	self.btn_leftan = self.middle_panle:getChildByName("Button_23")
	self.btn_leftan:addTouchEventListener(handler(self, self.onbtnleftCallBack))

	self.rightframe = self.middle_panle:getChildByName("Button_23_0")
	self.rightspr = self.middle_panle:getChildByName("Image_42_0"):getChildByName("Image_43_46") 
	self.rightspr:ignoreContentAdaptWithSize(true)
	self.rightspr:setScale(0.8)

	self._rightimg = self.rightframe:getChildByName("Image_67_69")
	self._rightimg:loadTexture(res.font.YAZHU)
	self.rightname = self.middle_panle:getChildByName("Image_54_0"):getChildByName("Text_35_37")
	self.rightname:setString("")
	self.btn_right = self.middle_panle:getChildByName("Button_23_0")
	self.btn_right:addTouchEventListener(handler(self, self.onbtnrightCallBack))
	--猜
	local btn_cai = self.middle_panle:getChildByName("Button_19_0")
	btn_cai:addTouchEventListener(handler(self, self.onBtnCaiCallBack))
	btn_cai:setTitleText(res.str.CONTEST_TEXT7)
	self.btn_cai = btn_cai
	--对比
	local btn_compare = self.middle_panle:getChildByName("Button_19")
	btn_compare:addTouchEventListener(handler(self, self.onBtnCompare))

	--猜那个
	self.vistable = {}
	self.pagebutton=gui.PageButton.new()
	self.pagebutton:setBtnCallBack(handler(self,self.onpagebuttonCallBack))
	local img_di = self.middle_panle:getChildByName("Image_48")
	self.pagebutton:addButton(img_di:getChildByName("Button_16"))
	self.pagebutton:addButton(img_di:getChildByName("Button_16_0"))
	self.pagebutton:addButton(img_di:getChildByName("Button_16_1"))

	self.lab_jb1 = img_di:getChildByName("Text_28")
	self.lab_jb2 = img_di:getChildByName("Text_28_30")
	self.lab_jb3 = img_di:getChildByName("Text_28_32")

	self.lab_prv_get = self.middle_panle:getChildByName("Text_33_0_0")
	table.insert(self.vistable,img_di)
	table.insert(self.vistable,self.middle_panle:getChildByName("Text_33_1")) --文字
	table.insert(self.vistable,self.middle_panle:getChildByName("Image_57")) --
	table.insert(self.vistable,self.middle_panle:getChildByName("Text_33_1_0"))
	table.insert(self.vistable,self.middle_panle:getChildByName("Image_53_0"))
	table.insert(self.vistable,self.lab_prv_get)

	self.middle_panle:getChildByName("Text_33_1"):setString(res.str.CONTEST_TEXT5)
	self.middle_panle:getChildByName("Text_33_1_0"):setString(res.str.CONTEST_TEXT6)
	self.lab_prv_get:setString("")
	--身价 留言
	local img = self.middle_panle:getChildByName("Image_57_0")
	self.lab_value_left = img:getChildByName("Text_1")
	self.lab_value_left:setString("")
	self.lab_world_left = img:getChildByName("Text_1_0")
	self.lab_world_left:setString(res.str.RES_RES_71)
	self.btn_left_word = img:getChildByName("Button_1")
	self.btn_left_word.tag = 1 

	self.lab_value_right = img:getChildByName("Text_1_1")
	self.lab_value_right:setString("")
	self.lab_world_right = img:getChildByName("Text_1_0_0")
	self.lab_world_right:setString(res.str.RES_RES_71)
	self.btn_right_word = img:getChildByName("Button_1_0")
	self.btn_right_word.tag = 2

	img:getChildByName("Text_1_2"):setString(res.str.RES_RES_70)
	img:getChildByName("Text_1_2_0"):setString(res.str.RES_RES_70)

	self.btn_left_word:addTouchEventListener(handler(self,self.onbtnWordCallBack))
	self.btn_right_word:addTouchEventListener(handler(self,self.onbtnWordCallBack))
end
--人物头像 名字
function CrossCompareView:initRole( param , data )
	-- body
	local temp = G_Split_Back(data.roleIcon)
	param.spr:setVisible(true)
	param.spr:ignoreContentAdaptWithSize(true)
	param.spr:loadTexture(temp.icon_img)
	param.spr:setScale(0.8)
	param.name:setString(data.namePre .."." ..data.roleName)
	param.spr:getParent():loadTexture(temp.frame_img)
end

function CrossCompareView:sortdata(data)
	-- body
	local t = data
	local r_t = { {},{} }
	if t[1].win == 16 then -- 
		for k ,v in pairs(t) do 
			if v.index == 1 or v.index == 9 or v.index == 12 or v.index == 13 
				or v.index ==2 or v.index == 10 or v.index == 11 or v.index == 14 then 

				r_t[1] = v 
			else
				r_t[2] = v 
			end
		end
	elseif t[1].win == 8 then 
		for k ,v in pairs(t) do 
			if v.index == 1 or v.index == 16 or v.index == 12 or v.index == 5 
			   or v.index == 2 or v.index == 15 or v.index == 11 or v.index == 6 then
				r_t[1] = v 
			else
				r_t[2] = v 
			end
		end
	elseif t[1].win == 4 then
		for k ,v in pairs(t) do 
			if v.index == 1 or v.index == 16 or v.index == 8 or v.index == 9
				or  v.index == 2 or v.index == 15 or v.index == 10 or v.index == 7 then

				r_t[1] = v 
			else
				r_t[2] = v 
			end
		end
	else
		for k ,v in pairs(t) do 
			if v.index == 1 or v.index == 16 or v.index == 8 or v.index == 9
				or v.index == 12 or v.index == 5 or v.index == 13 or v.index == 4 then
				r_t[1] = v 
			else
				r_t[2] = v 
			end
		end
	end
	return r_t
end

function CrossCompareView:setData(data )
	-- body
	local _t = self:sortdata(data)
	self.data = _t
	--[[table.sort(self.data,function( a,b )
		-- body
		return a.index < b.index
	end)]]--
	--printt(self.data)
	--设置左边玩家
	local param = {}
	param.spr = self.leftspr
	param.name = self.leftname
	param.frame = self.leftframe
	self:initRole(param,self.data[1])

	--设置右边玩家
	local param = {}
	param.spr = self.rightspr
	param.name = self.rightname
	param.frame = self.rightframe
	self:initRole(param,self.data[2])

	self.confdata = conf.Cross:getCaiItem(self.data[1].win)
	for k ,v in pairs(self.confdata.moneys) do 
		self["lab_jb"..k]:setString(v)
	end


	local param = {tarA = self.data[1].index,tarB = self.data[2].index }
	proxy.Cross:send_123009(param)
end

function CrossCompareView:setCaiValue(val)
	-- body

	for k ,v in pairs(self.pagebutton.ListButton) do 
		v:setTouchEnabled(true)
	end 

	self.btn_leftan:setTouchEnabled(true)
	self.btn_right:setTouchEnabled(true)
	self.btn_cai:setTouchEnabled(true)
	self.btn_cai:setTitleText(res.str.CONTEST_DEC10)

	if val == 0 then 
		self._dec_1:setString("")
		self._img_sh:setVisible(false)
		self.lab_sh_count:setString("")
	else
		self._dec_1:setString(res.str.RES_RES_56)
		self._img_sh:setVisible(true)
		self.lab_sh_count:setString(self.s_data.moneyJb)

		self.btn_right:setVisible(false)
		self.btn_leftan:setVisible(false)
		self.btn_cai:setTitleText(res.str.CONTEST_DEC11)

		local _img_ya = display.newSprite(res.font.YIDOUZHU)
		if tonumber(val) == self.data[2].index then 
			_img_ya:addTo(self.rightspr:getParent())
		else
			_img_ya:addTo(self.leftspr:getParent())
		end 
		_img_ya:setPositionX(25)
		_img_ya:setPositionY(80)
	end
end

function CrossCompareView:setSJ()
	-- body

	local power = self.s_data.tarAsj
	if power > 10000 then
		power = string.format("%.1f",self.s_data.tarAsj/10000)..res.str.SYS_DEC7
	end 
	self.lab_value_left:setString(power)

	local power = self.s_data.tarBsj
	if power > 10000 then
		power = string.format("%.1f",self.s_data.tarBsj/10000)..res.str.SYS_DEC7
	end 
	self.lab_value_right:setString(power)
end

function CrossCompareView:setServerData(data)
	-- body
	self.s_data = data
	--设置左边玩家
	--战力
	
	if data.tarAstr ~= "" then 
 		self.lab_world_left:setString(data.tarAstr)
 	end

	if data.tarBstr ~="" then 
 		self.lab_world_right:setString(data.tarBstr)
 	end 

 	self:setSJ()
 	self:setCaiValue(data.jcAb)
 	--
 	self.btn_left_word:setVisible(false)
 	self.btn_right_word:setVisible(false)
 	if self.s_data.selfAb == 1 then 
 		self.btn_left_word:setVisible(true)
 	elseif self.s_data.selfAb == 2 then 
 		self.btn_right_word:setVisible(true)
 	end
end

function CrossCompareView:updateSelfab(data)
	-- body
	G_TipsOfstr(res.str.RES_RES_73)

	self.s_data.jcAb = data.aorb
	if data.aorb == self.data[1].index then
		self.s_data.tarAsj = self.s_data.tarAsj + data.moneyJb
	elseif data.aorb == self.data[2].index then 
		self.s_data.tarBsj = self.s_data.tarBsj + data.moneyJb
	end

	self:setSJ()
	self.s_data.moneyJb = data.moneyJb
	self:setCaiValue(self.s_data.jcAb)
end

function CrossCompareView:vis( flag )
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
--self.str 记录按下的是什么
function CrossCompareView:Setbtnimg(str,btn)
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
			--self.index = self.data[1].roleId
			self._leftimg:loadTexture(res.other.JIANTOU)
			self._rightimg:getParent():setVisible(false)
		else
			--self.index = self.data[2].roleId
			self._rightimg:loadTexture(res.other.JIANTOU)
			self._leftimg:getParent():setVisible(false)
		end

		self.str = str
	end 
end

function CrossCompareView:updateWold(str)
	-- body
	if self.s_data.selfAb == 1 then 
		self.lab_world_left:setString(str)
	elseif self.s_data.selfAb == 2 then 
		self.lab_world_right:setString(str)
	end
end

function CrossCompareView:onpagebuttonCallBack( index,eventtype )
	-- body
	self.atype = index
	self.lab_prv_get:setString(tonumber(self["lab_jb"..self.atype]:getString())*2)
	return self
end

function CrossCompareView:onbtnWordCallBack( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local tag = sender.tag 
		if tag == 1 then 
			if tonumber(self.s_data.selfAb) == 1 then 
			else
				G_TipsOfstr(res.str.RES_RES_68)
				return 
			end
			
		else
			if tonumber(self.s_data.selfAb) == 2 then 
			else
				G_TipsOfstr(res.str.RES_RES_68)
				return 
			end
		end
		local view = mgr.ViewMgr:showView(_viewname.CROSS_WIN_WORD) 
	end
end

-----
function CrossCompareView:onBtnCaiCallBack( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		if not self.s_data then 
			return 
		end
		if self.s_data.jcAb > 0 then 
			G_TipsOfstr(res.str.RES_RES_60)
			return 
		end

		if not self.aorb then 
			return 
		end

		if not self.atype then 
			return 
		end

		local param = {aorb = self.data[self.aorb].index ,jbIndex =self.atype }
		proxy.Cross:send_123010(param)

	end
end

function CrossCompareView:onbtnleftCallBack( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:Setbtnimg("left",sender_)
		self.aorb = 1
	end 
end

function CrossCompareView:onbtnrightCallBack( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:Setbtnimg("right",sender_)
		self.aorb = 2
	end 
end

function CrossCompareView:comPareCalllBack( data_ )
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
	data1.roleId = self.data[2].index

	--左边
	local data = {}
	data.tarName = data_.tarAName
	data.tarLvl = data_.tarALvl
	data.tarPower = data_.tarAPower
	data.tarCards = data_.tarACards
	data.roleId = self.data[1].index

	local name = string.split(data.tarName, ".")
	--data.roleName
	if name[2] == self.data[1].roleName then
		view:setData(data1,data,2)
	else
		view:setData(data,data1,2)
	end 

	mgr.ViewMgr:showView(_viewname.ATHLETICS_COMPARE)
end

function CrossCompareView:onBtnCompare( sender,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local param = {tarAId =  self.data[1].index, tarBId =  self.data[2].index,tarType = 2 }
		proxy.Cross:send_123005(param)
	end
end

function CrossCompareView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CrossCompareView