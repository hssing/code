local MyLotteryView = class("MyLotteryView", base.BaseView)


function MyLotteryView:init(  )
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.Panel2 = self.view:getChildByName("Panel_2")

	local btn_closePanel2 = self.Panel2:getChildByName("Button_close")
	btn_closePanel2:addTouchEventListener(handler(self, self.onbtnClose2))

	local btn_pre = self.Panel2:getChildByName("Button_pre")
	btn_pre:addTouchEventListener(handler(self, self.onbtnPrePage))

	local btn_next = self.Panel2:getChildByName("Button_next")
	btn_next:addTouchEventListener(handler(self, self.onbtnNextPage))

	self.PageNumText = self.Panel2:getChildByName("Text_5_2")

	self.PageNum = 1
end

function MyLotteryView:setData(  )

	self.myLottery = cache.LuckyLottery:getMyLotteryData(self.PageNum)
	self:onRefreshMyLotteryView(  )
end

function MyLotteryView:onRefreshMyLotteryView(  )
	-- body
	self.lotteryNum=self.myLottery.tickeyNum

	local numText = self.Panel2:getChildByName("Text_1_4")

	numText:setString(string.format(res.str.ACT2_AWARD_RANK_DESC8, self.lotteryNum))

	if self.lotteryNum > 0 and (self.lotteryNum%28) == 0 then
		self.totalPageNum = self.lotteryNum/28
	else
		self.totalPageNum = math.floor(self.lotteryNum/28)+1
	end

	local index = (self.PageNum-1)*28

	for i = 1,7 do
		local widget = self.Panel2:getChildByName("Image_20_20"):clone()
		widget:setPositionY(widget:getPositionY()-(widget:getContentSize().height)*(i-1))
		
		for j = 1,4 do
			index = index + 1

			local numberText = widget:getChildByName(string.format("Text_4_%d",j-1))

			if self.myLottery.tickeyList[index] == nil then
				numberText:setVisible(false)
			else
				numberText:setVisible(true)
				numberText:setString(string.format("%d", (self.myLottery.tickeyList[index])))
			end
		end
		
		widget:setTag(i)
		self.Panel2:addChild(widget)
	end

	self.Panel2:getChildByName("Image_20_20"):setVisible(false)

	self.PageNumText:setString(string.format("%d/%d", self.PageNum,self.totalPageNum))
end


function MyLotteryView:onbtnClose2( sender,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		self:closeSelfView()
	end 
end


function MyLotteryView:onbtnNextPage( sender,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		if self.PageNum == self.totalPageNum then
			return
		end
	
		self.PageNum = self.PageNum + 1

		self.PageNumText:setString(string.format("%d/%d", self.PageNum,self.totalPageNum))

		--proxy.LuckyLottery:onRequestMyLottery(self.PageNum)
		
		proxy.LuckyLottery:onRequestMyLottery(self.PageNum)
	end
end

function MyLotteryView:onRefreshPage(  )
 	-- body

 	local flag = 0

	for i = 1,7 do
		local widget = self.Panel2:getChildByTag(i)
		for j = 1,4 do
			flag = flag + 1
			local numberText = widget:getChildByName(string.format("Text_4_%d",j-1))
			if flag>#self.myLottery.tickeyList then
				numberText:setVisible(false)
			else
				numberText:setVisible(true)
				numberText:setString(string.format("%d", (self.myLottery.tickeyList[flag])))
			end
		end 
	end
 end

return MyLotteryView