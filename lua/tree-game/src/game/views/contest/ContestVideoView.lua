--[[
	ContestVideoView
]]
local ContestVideoView = class("ContestVideoView",base.BaseView)

function ContestVideoView:init()
	-- body
	self.ShowAll = true
	--self.ShowBottom = true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	G_FitScreen(self, "Image_40")

	self.pagebutton=gui.PageButton.new()
	self.pagebutton:setBtnCallBack(handler(self,self.onpagebuttonCallBack))
	self.pagebutton:addButton(self.view:getChildByName("Button_24"))
	self.pagebutton:addButton(self.view:getChildByName("Button_24_0"))
	---listview
	self.listview = self.view:getChildByName("ListView_1")
	--几进几标题
	self.itemtitle = self.view:getChildByName("Panel_7")
	--
	self.item = self.view:getChildByName("Panel_7_0")

	self.lab_other = self.view:getChildByName("Panel_1"):getChildByName("Text_13")
	self.lab_other:setVisible(false)

	--界面文本
	self.view:getChildByName("Button_24"):setTitleText(res.str.CONTEST_TEXT12)
	self.view:getChildByName("Button_24_0"):setTitleText(res.str.CONTEST_TEXT13)

	self.item:getChildByName("Button_23"):setTitleText(res.str.CONTEST_TEXT14)


end

function ContestVideoView:onBtnVidoCallBack( sender_,eventtype  )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local data = {frId = sender_.videoId}
		proxy.copy:sendSmds(data)
		mgr.NetMgr:wait(502005)
	end 
end

function ContestVideoView:initItem(data,curtype)
	-- body
	local item = self.item:clone()
	local img_1 = item:getChildByName("Image_60")
	local lab_l = item:getChildByName("Text_22_24")

	local img_2 = item:getChildByName("Image_60_1")
	local lab_2 = item:getChildByName("Text_22_24_0")

	local lab_next = item:getChildByName("Text_22_24_1") 
	local btn = item:getChildByName("Button_23")
	--btn:setTag(data.videoId)
	btn.videoId = data.videoId
	btn:addTouchEventListener(handler(self, self.onBtnVidoCallBack))

	local str = res.str.CONTEST_DEC14

	--G_TipsOfstr("data.win ="..data.win)

	if curtype < 4 then 
		str = res.str.CONTEST_DEC28
	end 
	if string.trim(tostring(data.win))  == "2" then 
		btn:setVisible(false)

		lab_next:setString(string.format(str,data.roleAName))
		img_1:loadTexture(res.font.WIN)
		img_2:loadTexture(res.font.LOSE)
	elseif tonumber(data.win) == 1 then 
		lab_next:setString(string.format(str,data.roleAName))
		img_1:loadTexture(res.font.WIN)
		img_2:loadTexture(res.font.LOSE)
	else
		lab_next:setString(string.format(str,data.roleBName))
		img_1:loadTexture(res.font.LOSE)
		img_2:loadTexture(res.font.WIN)
	end 
	lab_l:setString(data.roleAName)
	lab_2:setString(data.roleBName)

	self.listview:pushBackCustomItem(item)
end

function ContestVideoView:initTitle(statue)
	-- body
	local item = self.itemtitle:clone() 
	local title = item:getChildByName("Text_22") 
	
	if statue == 16 then 
		title:setString(res.str.CONTEST_DEC6)
	elseif statue == 8  then
		--todo
		title:setString(res.str.CONTEST_DEC7)
	elseif statue == 4  then
		--todo
		title:setString(res.str.CONTEST_DEC8)
	else
		title:setString(res.str.CONTEST_DEC9)
	end 

	self.listview:pushBackCustomItem(item)
end

function ContestVideoView:setOther( name )
	-- body
	self.lab_other:setString(string.format(res.str.CONTEST_DEC31,name) )
	self.lab_other:setVisible(true)

	self.view:getChildByName("Button_24"):setVisible(false)
	self.view:getChildByName("Button_24_0"):setVisible(false)
end

function ContestVideoView:setData(data)
	-- body
	self.data = data

	for k ,v in pairs(self.data.selfVideo) do 
		v.frIndexType = math.floor(v.frIndex/10000) -- 16 8 4 2
		v.frIndexCount = v.frIndex%10000 -- 第几次
	end 

	--printt(self.data)

	table.sort(self.data.selfVideo,function( a,b )
		-- body
		if a.frIndexType == b.frIndexType then 
			return a.frIndexCount>b.frIndexCount
		else
			return a.frIndexType < b.frIndexType
		end 
	end)

	table.sort(self.data.videoArrays,function( a,b )
		-- body
		return a.frIndex< b.frIndex
	end)

	if #data.videoArrays == 0 then 
		self.view:getChildByName("Button_24_0"):setVisible(false)
	end 
	self.pagebutton:initClick(1)
end

function ContestVideoView:onpagebuttonCallBack( index,eventtype )
	-- body
	debugprint("index = "..index)
	self.pageindex = index
	self.listview:removeAllItems()

	local data = self.data.selfVideo
	if self.pageindex == 2 then 
		data = self.data.videoArrays
	end 

	local curtype = 0
	for k , v in pairs(data) do 
		local types = math.floor(v.frIndex/10000)
		if curtype ~= types  then 
			self:initTitle(types)
			curtype = types
		end 
		self:initItem(v,curtype)
	end 
	return self
end
function ContestVideoView:onCloseSelfView()
	-- body
	self:closeSelfView()
end
return ContestVideoView