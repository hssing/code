--[[
	中奖名单
]]

local MainLotteryView = class("MainLotteryView", base.BaseView)

function MainLotteryView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.bg_panle = self.view:getChildByName("Panel_3")
	self.listView = self.bg_panle:getChildByName("ListView_1_2")
	self.decclone = self.view:getChildByName("Panel_1")
	self.itemclone = self.view:getChildByName("Panel_2")
	--第几期
	self.lab_qi = self.bg_panle:getChildByName("AtlasLabel_6_2")

	local btn = self.bg_panle:getChildByName("Button_6_2")
	btn:addTouchEventListener(handler(self,self.onBtnClose))

	self:initlistView()
end

function MainLotteryView:inititem()
	-- body
	local widget = self.itemclone:clone()

	local img = widget:getChildByName("Image_6_0")
	img:getChildByName("Text_2_1_36"):setString(res.str.ACT2_AWARD_RANK_DESC12)
	img:getChildByName("Text_2_32"):setString(res.str.ACT2_AWARD_RANK_DESC13)

	widget.img = img

	widget.lab_num = img:getChildByName("Text_2_2_38") --号码
	widget.lab_num:setString("")

	widget.lab_player = img:getChildByName("Text_2_0_34")
	widget.lab_player:setString("")
	widget.lab_player:setFontName(display.DEFAULT_TTF_FONT)
	widget.lab_player:setFontSize(20)

	self.listView:pushBackCustomItem(widget)
	table.insert(self.item,widget)
	return widget

end

function MainLotteryView:initlistView()
	-- body

	self.item = {} --各个条目
	local widget = self.decclone:clone()

	--特等奖
	widget:getChildByName("Text_18_0_2"):setString(res.str.ACT2_AWARD_RANK_DESC10)
	widget:getChildByName("Image_16_0"):getChildByName("Text_16_25_12"):setString(res.str.ACT2_AWARD_RANK_DESC11)
	self.lab_1 =  widget:getChildByName("Image_16_0"):getChildByName("Text_16_0_27_14")
	self.lab_1:setString("")
	self.listView:pushBackCustomItem(widget)

	self:inititem()


	--一等奖
	local widget = self.decclone:clone()
	widget:getChildByName("Text_18_0_2"):setString(res.str.ACT2_AWARD_RANK_DESC14)
	widget:getChildByName("Image_16_0"):getChildByName("Text_16_25_12"):setString(res.str.ACT2_AWARD_RANK_DESC11)
	self.lab_2 =  widget:getChildByName("Image_16_0"):getChildByName("Text_16_0_27_14")
	self.lab_2:setString("")
	self.listView:pushBackCustomItem(widget)

	self:inititem()
	

	--二等奖
	local widget = self.decclone:clone()
	widget:getChildByName("Text_18_0_2"):setString(res.str.ACT2_AWARD_RANK_DESC15)
	widget:getChildByName("Image_16_0"):getChildByName("Text_16_25_12"):setString(res.str.ACT2_AWARD_RANK_DESC11)
	self.lab_3 =  widget:getChildByName("Image_16_0"):getChildByName("Text_16_0_27_14")
	self.lab_3:setString("")
	self.listView:pushBackCustomItem(widget)

	for i = 1 , 2 do 
		self:inititem()	
	end

	--3等奖
	local widget = self.decclone:clone()
	widget:getChildByName("Text_18_0_2"):setString(res.str.ACT2_AWARD_RANK_DESC16)
	widget:getChildByName("Image_16_0"):getChildByName("Text_16_25_12"):setString(res.str.ACT2_AWARD_RANK_DESC11)
	self.lab_4 =  widget:getChildByName("Image_16_0"):getChildByName("Text_16_0_27_14")
	self.lab_4:setString("")
	self.listView:pushBackCustomItem(widget)

	for i = 1 , 3 do 
		self:inititem()
	end

	--参与等奖
	local widget = self.decclone:clone()
	widget:getChildByName("Text_18_0_2"):setString(res.str.ACT2_AWARD_RANK_DESC17)
	widget:getChildByName("Image_16_0"):getChildByName("Text_16_25_12"):setString(res.str.ACT2_AWARD_RANK_DESC11)
	self.lab_5 =  widget:getChildByName("Image_16_0"):getChildByName("Text_16_0_27_14")
	self.lab_5:setString("")
	self.listView:pushBackCustomItem(widget)

	for i = 1 , 10 do 
		self:inititem()
	end
end

function MainLotteryView:setData(data)
	-- body
	self.data = data
	self.lab_qi:setString(data.peiod)

	table.sort( data.awardUsers, function( a,b)
		-- body
		return a.rank<b.rank
	end )

	if #data.awardUsers > 0 then 
		for k  ,v in pairs(data.awardUsers) do 
			if k == 1 then 
				self.lab_1:setString(v.gotZs)
			elseif k == 2 then
				self.lab_2:setString(v.gotZs)
			elseif k == 3 then
				self.lab_3:setString(v.gotZs)
			elseif k == 5 then
				self.lab_4:setString(v.gotZs)
			elseif k == 8 then
				self.lab_5:setString(v.gotZs)
			end
			if self.item[k] then
				self.item[k].lab_num:setString(v.tickey)
				self.item[k].lab_player:setString(v.roleName)
			end
		end

		for i = #data.awardUsers + 1 , 17 do
			if self.item[i] then
				local t = self.item[i].img:getChildren()
				for k ,v in pairs(t) do 
					if v:getName()=="Text_2_1_36" then
						v:setVisible(true)
						v:setString(res.str.ACT2_AWARD_RANK_DESC21)
						v:setAnchorPoint(cc.p(0.5,0.5))
						v:setPosition(self.item[i].img:getContentSize().width/2,self.item[i].img:getContentSize().height/2)
					else
						v:setVisible(false)
					end
				end
			end
		end
	end
end

function MainLotteryView:onBtnClose(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end
end

function MainLotteryView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return MainLotteryView