
local Award_pageView = class("Award_pageView",base.BaseView)

function Award_pageView:ctor()
	-- body
end

function Award_pageView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.bg_panle = self.view:getChildByName("Panel_2")

	self.panle = self.bg_panle:getChildByName("Panel_4")
	self.cloneitem = self.bg_panle:getChildByName("Image_20_20")

	local btn = self.bg_panle:getChildByName("Button_close_6") 
	btn:addTouchEventListener(handler(self, self.onBtnClose))

	local btn_pre = self.bg_panle:getChildByName("Button_pre_2")
	btn_pre:addTouchEventListener(handler(self,self.pre))

	local btn_next = self.bg_panle:getChildByName("Button_next_4")
	btn_next:addTouchEventListener(handler(self,self.next))
	self:initDec()
end

function Award_pageView:initDec()
	-- body
	--本期 上期
	self.img_title = self.bg_panle:getChildByName("Image_12_8")
	self.img_title:ignoreContentAdaptWithSize(true)
	self.img_title_1 = self.bg_panle:getChildByName("Image_7_10")
	self.img_title_1:ignoreContentAdaptWithSize(true)
	-- 我的奖券 活着上期
	self.lab_dec = self.bg_panle:getChildByName("Text_1_4")
	self.lab_dec:setString("")
	-- 1 / 5 
	self.lab_page = self.bg_panle:getChildByName("Text_5_2")
	self.lab_page:setString("1/1")

	self.list = {}
	for i = 1 , 7 do 
		local item = self.cloneitem:clone()
		item:setPosition(self.panle:getContentSize().width/2,
			self.panle:getContentSize().height - (item:getContentSize().height + 8 ) * (i -1 ) - 
			item:getContentSize().height/2 )

		item:addTo(self.panle)
		for j = 1 , 4 do 
			local txt = item:getChildByName("Text_4_"..j)
			txt:setString("")
			table.insert(self.list,txt)
		end
	end
end

function Award_pageView:setData(data,page)
	-- body
	self.data = data
	local allpage = math.ceil(data.tickeyNum/#self.list)
	if allpage <= 0 then
		allpage = 1
	end

	self.page = page

	self.curpage = data.pageNum
	self.allpage = allpage
	self.lab_page:setString(data.pageNum.."/"..allpage)
	if page == 0 then 
		self.img_title:loadTexture(res.font.CAIPIAO[1])
		self.img_title_1:loadTexture(res.font.CAIPIAO[3])
		self.lab_dec:setString(string.format(res.str.ACT2_AWARD_RANK_DESC18,data.tickeyNum))
	else
		self.img_title:loadTexture(res.font.CAIPIAO[2])
		self.img_title_1:loadTexture(res.font.CAIPIAO[4])
		self.lab_dec:setString(string.format(res.str.ACT2_AWARD_RANK_DESC19,data.tickeyNum))
	end

	for k ,v in pairs(self.list) do 
		v:setString("")
	end
	for k , v  in pairs(data.tickeyList) do 
		if self.list[k] then 
			self.list[k]:setString(v)
		end
	end
end


function Award_pageView:pre( send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--请求上一页
		if self.curpage - 1 < 1 then 
			return 
		end
		if self.page == 0 then
			proxy.LuckyLottery:onRequestMyLottery(self.curpage - 1)
		else
			proxy.LuckyLottery:send_116159({pageNum = self.curpage - 1})
		end
		--proxy.LuckyLottery:onRequestMyLottery(self.curpage - 1)
	end
end

function Award_pageView:next( send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--请求下一页
		if self.curpage + 1 > self.allpage then 
			return 
		end
		if self.page == 0 then
			proxy.LuckyLottery:onRequestMyLottery(self.curpage + 1)
		else
			proxy.LuckyLottery:send_116159({pageNum = self.curpage + 1})
		end
	end
end

function Award_pageView:onBtnClose(send, eventtype) 
	-- body
	if eventtype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end
end

function Award_pageView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return Award_pageView