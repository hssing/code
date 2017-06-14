--[[
	Contest_WinnerRank --排行
]]

local Contest_WinnerRank = class("Contest_WinnerRank", base.BaseView)

function Contest_WinnerRank:init()
	-- body
	self.ShowAll = true
	--self.ShowBottom = true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.listview = self.view:getChildByName("ListView_2")
	self.item = self.view:getChildByName("Panel_79")

	G_FitScreen(self, "Image_1")
	local btn = self.view:getChildByName("Button_24")
	--btn:addTouchEventListener(handler(self,self.onbtnGuize))

	--界面文本
	btn:setTitleText(res.str.CONTEST_TEXT10)
	self.item:getChildByName("Button_2_0_20"):setTitleText(res.str.CONTEST_TEXT9) 

end

function Contest_WinnerRank:clear()
	-- body
end

function Contest_WinnerRank:initListView()
	-- body
	self.listview:removeAllItems()
	for k,v in pairs(self.data) do 
		local widget = self.item:clone()

		local imgrank = widget:getChildByName("Image_221_0")
		local lab_rank = widget:getChildByName("AtlasLabel_1")

		local lab_gh = widget:getChildByName("Text_186_0")
		lab_gh:setString(string.format(res.str.GUILD_DEC57,res.str.GUILD_DEC58))
		if  v.guildName ~="" then 
			lab_gh:setString(string.format(res.str.GUILD_DEC57,v.guildName))
		end 

		imgrank:setVisible(false)
		lab_rank:setVisible(false)

		if v.rank < 4 then 
			imgrank:setVisible(true)
			imgrank:loadTexture(res.icon.RANK[v.rank])
		else
			lab_rank:setVisible(true)
			lab_rank:setString(v.rank)
		end 
		local temp = G_Split_Back(v.sex)

		local frame = widget:getChildByName("Image_42")
		frame:loadTexture(temp.frame_img)

		if frame:getChildByName("dw") then 
			frame:getChildByName("dw"):removeSelf()
		end
		if temp.dw > temp.min_dw then 
			local spr = display.newSprite(res.icon.DW_ICON[temp.dw])
			spr:setName("dw")
			spr:setPosition(temp.dw_pos)
			spr:addTo(frame)
		end

		local spr = widget:getChildByName("Image_42"):getChildByName("Image_43_29")
		spr:ignoreContentAdaptWithSize(true)
		spr:setScale(0.8)

		

		--local json = v.sex == 1 and "BOY" or "GRIL"
		spr:loadTexture(temp.icon_img)

		local lab_name = widget:getChildByName("Text_186")
		lab_name:setString(v.roleName)

		local btn = widget:getChildByName("Button_2_0_20")
		btn:setTag(k)
		btn.roleId = v.roleId
		btn:setTouchEnabled(true)
		btn:addTouchEventListener(handler(self, self.onBtnSee))

		self.listview:pushBackCustomItem(widget)
	end 
end

function Contest_WinnerRank:setData(data)
	-- body
	self.data = data

	table.sort(self.data,function( a,b )
		-- body
		return a.rank<b.rank
	end)

	self:initListView()
end

function Contest_WinnerRank:onbtnGuize( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("规则")
		local view = mgr.ViewMgr:showView(_viewname.GUIZE)
		view:showByName(4)
	end 
end

function Contest_WinnerRank:comPareCalllBack( data_ )
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
	if data1.tarName == cache.Player:getName() then 
		data1.roleId = cache.Player:getRoleId()
	else
		--print("右边是别人")
		--printt(self.otherroleId)
		--print("**********************")
		data1.roleId = self.otherroleId
	end 


	--左边
	local data = {}
	data.tarName = data_.tarAName
	data.tarLvl = data_.tarALvl
	data.tarPower = data_.tarAPower
	data.tarCards = data_.tarACards
	data.huoban = data_.tarAXhbs

	if data.tarName == cache.Player:getName() then 
		data.roleId = cache.Player:getRoleId()
	else
		--print("左边是别人")
		data.roleId = self.otherroleId
	end 

	if data.tarName == cache.Player:getName() then
		view:setData(data1,data)
	else
		view:setData(data,data1)
	end 

	mgr.ViewMgr:showView(_viewname.ATHLETICS_COMPARE)
end

function Contest_WinnerRank:onBtnSee(sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("查看别人的阵容")
		self.otherroleId = sender_.roleId

		if cache.Player:getRoleId().key == self.otherroleId.key then 
			G_TipsOfstr(res.str.CONTEST_DEC27)
			return
		end 

		local param = {tarAId =  cache.Player:getRoleId() , tarBId =  self.otherroleId }
		proxy.Contest:sendCompare(param)
		mgr.NetMgr:wait(501201)
	end 
end

function Contest_WinnerRank:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return Contest_WinnerRank
