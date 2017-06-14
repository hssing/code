
local Active_11MianView = class("Active_11MianView",base.BaseView)

function Active_11MianView:init(page)
	-- body
	self.ShowAll= true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	---
	local panle_top = self.view:getChildByName("Panel_1")
	
	self.lab_dec1 = panle_top:getChildByName("Text_1") --本次活动
	self.lab_time = panle_top:getChildByName("Text_1_0") --倒数计时
	self.lab_money = panle_top:getChildByName("Text_1_0_1") --累计充值

	self.lab_dec2 = panle_top:getChildByName("Text_1_0_0") --
	self.lab_dec3 = panle_top:getChildByName("Text_1_0_0_0") --

	self.topitem = self.view:getChildByName("Button_40")
	self.toplv = panle_top:getChildByName("ListView_2") --

	
	--
	self.re_item = self.view:getChildByName("Panel_13")
	self.relv = self.view:getChildByName("ListView_6") --累计充值滚动
	--
	self.middlepanle = self.view:getChildByName("Panel_11") --只是拿来定位置
	--self.middlepanle:setVisible(false)
	--签到
	self.panle_sign = self.view:getChildByName("Panel_11_0")
	--抽奖 
	self.panle_chou = self.view:getChildByName("Panel_11_1")

	self:schedule(self.changeTimes,1.0,"changeTimes")

	

	self.maintopview = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	if self.maintopview then 
		self.maintopview:initActive11()
	end

	self.page = 1
	--print("page "..page)
	if page then 
		self.page = page
	end
	self:initTopPanle()

	G_FitScreen(self,"Image_1")
end

function Active_11MianView:getCloneRe_item()
	-- body
	return self.re_item:clone()
end

function Active_11MianView:changeTimes()
	-- body
	if not self.data or not self.data.leftTime then 
		return 
	end

	local h = 0 
	local m = 0
	local s = 0
	if self.data.leftTime then 
		if self.data.leftTime <= 0 then 
			self:onCloseSelfView()
			return 
		else
			self.data.leftTime = self.data.leftTime -1 
		end

		if self.data.leftTime < 0 then 
			self.data.leftTime = 0
		end

		h = math.floor(self.data.leftTime/3600)
		m = math.floor(self.data.leftTime%3600/60)
		s = math.floor(self.data.leftTime%3600%60)
	end 

	if h > 0 then
		self.lab_time:setString(string.format(res.str.DOUBLE_DEC2,h,m,s))
	elseif m > 0 then 
		self.lab_time:setString(string.format(res.str.DOUBLE_DEC5,m,s))
	elseif s > 0 then 
		self.lab_time:setString(string.format(res.str.DOUBLE_DEC6,s))
	else
		self.lab_time:setString("")
	end
end

function Active_11MianView:initTopPanle()
	-- bod	
	self.btnList = {}
	for k , v in pairs(res.font.DOUBLE_11) do 
		local flag = cache.Active:isKey(2000+k)
		
		if flag then 
			--print("k = "..k)
			local item = self.topitem:clone()
			--item:loadTextureNormal(v)
			local spr = display.newSprite(v)
			spr:setPosition(item:getContentSize().width/2,item:getContentSize().height/2)
			spr:addTo(item)

			item:setTag(k)
			item:addTouchEventListener(handler(self, self.onbtnClooseCallBack))

			self.toplv:pushBackCustomItem(item)
			table.insert(self.btnList,item)
		end
	end

	self.lab_dec1:setString(res.str.DOUBLE_DEC1)
	self.lab_time:setString("")
	self.lab_money:setString("")
	self.lab_dec2:setString("")
	self.lab_dec3:setString("")

	

	if #self.btnList > 0 then 
		--print("self.page btnList"..self.page)
		--print(#self.page)
		if self.btnList[tonumber(self.page)] then 

			self:onbtnClooseCallBack(self.btnList[tonumber(self.page)],ccui.TouchEventType.ended)
		else
			self:onbtnClooseCallBack(self.btnList[1],ccui.TouchEventType.ended)
		end
		--self:onbtnClooseCallBack(self.btnList[1],ccui.TouchEventType.ended)
	end
end


function Active_11MianView:getKeySataue(id )
	-- body
	local state 
	for k , v in pairs(self.data.awardSigns) do 
		if checknumber(k)~=0 then 
			if tonumber(k) == tonumber(id) then 
				return v
			end
		end
	end
	return state
end

--累计充值
function Active_11MianView:initListView()
	-- body
	

	self.relv:removeAllItems()

	local confdata = conf.Double:getDoubleRecharge()
	for k , v in pairs(confdata) do 
		local state = self:getKeySataue(v.id)
		if not state then --未达成
			v.sort = 2
		elseif state == 0 then --领取了
			--todo
			v.sort = 3
		else
			v.sort = 1
		end

	end

	table.sort(confdata,function(a,b)
		-- body
		if a.sort == b.sort then 
			return a.id < b.id
		else
			return a.sort < b.sort
		end
	end)

	self.itme = {}
	for k , v in pairs(confdata) do 
		local item = CreateClass("views.acitve.active_recharge")
		item:init(self)
		item:setData(v)
		item.id = v.id

		local state = self:getKeySataue(v.id)
		item:setBtnStatue(state)

		self.relv:pushBackCustomItem(item)

		table.insert(self.itme,item)
	end
end


function Active_11MianView:severRechage(data_)
	-- body
	self.lab_dec2:setString(res.str.DOUBLE_DEC14)
	self.lab_dec3:setString(res.str.DOUBLE_DEC15)
	self.data = data_
	self.lab_money:setString(string.format(res.str.HSUI_DESC7,math.floor(data_.sumMoney/10)))
	self:initListView()
end

function Active_11MianView:updateSeverRechage(data_ )
	-- body
	--debugprint("购买成功")
	local t = data_.items
	local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
	if not view then
		view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		view:setData(t,false,true,true)
		view:setButtonVisible(false)
	end



	local key ,var
	for k , v in pairs(data_.awardSigns) do 
		if checknumber(k)~=0 then 
			key = k 
			var = v
			break
		end
	end

	if not key then 
		return 
	end

	for k , v in pairs(self.data.awardSigns) do 
		if checknumber(k)~=0 then 
			if key == k then 
				--v = var
				self.data.awardSigns[k] = var
				--print(v)
				break
			end
		end
	end

	self:initListView()
end

--签到信息
function Active_11MianView:serverSign( data_ )
	-- body
	self.lab_dec2:setString(res.str.DOUBLE_DEC16)
	self.lab_dec3:setString(res.str.DOUBLE_DEC17)
	self.data = data_
	local item = CreateClass("views.acitve.active_sign")
	item:init(self)
	item:setData(data_)
	item:addTo(self.middlepanle)
	item:setPosition(self.middlepanle:getContentSize().width/2,self.middlepanle:getContentSize().height/2)
	self.middlepanle:setVisible(true)

	self.sign = item
end

function Active_11MianView:serverUpdateSign( data_ )
	-- body
	self.sign:updateinfo(data_)
end

function Active_11MianView:getCloneSign()
	-- body
	return self.panle_sign:clone()
end

--------------------------抽奖信息
function Active_11MianView:severChouCallBack(data_)
	-- body
	self.lab_dec2:setString(res.str.DOUBLE_DEC18)
	self.lab_dec3:setString(res.str.DOUBLE_DEC19)
	self.data = data_
	local item = CreateClass("views.acitve.active_chou")
	item:init(self)
	item:setData(data_)
	
	--item:setPosition(0,0)
	item:setPosition(self.middlepanle:getContentSize().width/2,self.middlepanle:getContentSize().height/2)
	item:addTo(self.middlepanle)
	self.middlepanle:setVisible(true)

	self.sign = item
end

function Active_11MianView:updateChouInfo(data_)
	-- body
	self.sign:updateinfo(data_)
end

function Active_11MianView:getCloneChou()
	-- body
	return self.panle_chou:clone()
end



function Active_11MianView:openPanleByTag()
	-- body
	self.relv:removeAllItems()
	self.middlepanle:removeAllChildren()
	self.sign = nil 

	self.lab_money:setString("")
	self.lab_time:setString("")

	self.relv:setVisible(false)
	self.middlepanle:setVisible(false)

	if self.tag == 1 then --累计充值
		proxy.Double:send116067()
		mgr.NetMgr:wait(516067)
		self.relv:setVisible(true)
	elseif self.tag == 2  then --签到
		--todo
		proxy.Double:send116069()
		mgr.NetMgr:wait(516069)
	else
		proxy.Double:send116072()
		mgr.NetMgr:wait(516072)
		--self:severChouCallBack()
	end
end

function Active_11MianView:onbtnClooseCallBack( send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		for k ,v in pairs(self.btnList) do 
			v:setTouchEnabled(true)
			v:setBright(true)
		end 
		send:setTouchEnabled(false)
		send:setBright(false)

		self.tag = send:getTag()

		self:openPanleByTag()
	end
end

function Active_11MianView:setData()
	-- body
end

function Active_11MianView:onCloseSelfView()
	-- body
	if self.maintopview then 
		self.maintopview:clearAcitve11()
	end 

	G_mainView()
end

return Active_11MianView