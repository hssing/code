local AwardRankView=class("AwardRankView", base.BaseView)

function AwardRankView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	--主面板
	self.Panel1 = self.view:getChildByName("Panel_1") 

	local ImagePlat = self.Panel1:getChildByName("Image_plat")
	self.QText = self.Panel1:getChildByName("AtlasLabel_1") --第几期

	self.qImage = self.Panel1:getChildByName("Image_q")

	self.PNunmberText = self.Panel1:getChildByName("AtlasLabel_2") --上一次特等奖彩票号

	self.PNameText = self.Panel1:getChildByName("Text_23") --上一次特等奖彩票号玩家名

	self.AwardNumText = self.Panel1:getChildByName("Image_3"):getChildByName("AtlasLabel_3") --奖励池钻石数

	self.SpecAwardNumText = self.Panel1:getChildByName("Image_3"):getChildByName("Text_3")

	--界面文本
	self.Panel1:getChildByName("Image_70"):getChildByName("Text_32"):setString(res.str.ACT2_AWARD_RANK_DESC9)

	self.PTipText = self.Panel1:getChildByName("Text_tip")
	self.PTipText:setString(string.format(res.str.ACT2_AWARD_RANK_DESC5))

	--上期奖券
	local btn_preAward = self.Panel1:getChildByName("Button_1_0")
	btn_preAward:addTouchEventListener(handler(self, self.onbtnPreAward))

	btn_preAward:getChildByName("Text_11_58"):setString(res.str.ACT2_AWARD_RANK_DESC20)

	--我的奖券
	local btn_mycard = self.Panel1:getChildByName("Button_1")
	btn_mycard:addTouchEventListener(handler(self, self.onbtnOpenMyCard))

	btn_mycard:getChildByName("Text_11"):setString(string.format(res.str.ACT2_AWARD_RANK_DESC6))

	--奖励列表
	local btn_awardlist = self.Panel1:getChildByName("Button_2")
	btn_awardlist:addTouchEventListener(handler(self, self.onbtnReq1))

	btn_awardlist:getChildByName("Text_12"):setString(string.format(res.str.ACT2_AWARD_RANK_DESC7))

	--奖金说明
	local btn_awarddetail = self.Panel1:getChildByName("Button_2_0")
	btn_awarddetail:addTouchEventListener(handler(self, self.onDetailButtonClicked))

	btn_awarddetail:getChildByName("Text_12_22"):setString(string.format(res.str.ACT2_AWARD_RANK_DESC1))

	self.PTimeText = self.Panel1:getChildByName("Text_time")

	self:schedule(self.changeTimes,1.0)
end

function AwardRankView:setData(  )
	-- body
	local baseData = cache.LuckyLottery:getDataInfo()
	--dump(baseData)
	self.refreshTime=baseData.awardDownTime
	self.leftTime=baseData.actLeftTime

	self.lotteryNum=baseData.tickyNum

	if baseData.peiod == -1 then
		baseData.awardDownTime=-1
		self.refreshTime=baseData.awardDownTime
		baseData.peiod=conf.active:getConfItem(3011).endDay

		baseData.specGotZs=0
		baseData.zsPool=0
	end

	self:onRefreshTime()
	self.QText:setString(baseData.peiod)

	if baseData.lastSpecialTickey == 0 then
		self.PNunmberText:setVisible(false)
		self.qImage:setVisible(true)
	else
		self.PNunmberText:setVisible(true)
		self.qImage:setVisible(false)
	end
	self.PNunmberText:setString(baseData.lastSpecialTickey)
	self.PNameText:setString(baseData.lastSpecialName)
	self.AwardNumText:setString(baseData.specGotZs)
	self.SpecAwardNumText:setString(baseData.zsPool)
	

	self.PageNum = 1
	self.totalPageNum = 1
	self.currAwardRankFlag = 1	
	
end
--我的奖券
function AwardRankView:set_516157(data)
	-- body
	self.openview = mgr.ViewMgr:showView(_viewname.MYLOTTERY)

	self.openview:setData(  )
	--self:onRefreshPage()
end

--响应中奖榜单请求
function AwardRankView:set_516159(data)
	-- body
	print("中奖榜单")
	self.openview = mgr.ViewMgr:showView(_viewname.MAINLOTTERY)

	self.openview:setData()
end
-- 幸运彩票我的上期彩票
function AwardRankView:set_516158(data)
	-- body
	self.openview = mgr.ViewMgr:showView(_viewname.MAINLOTTERY)

	self.openview:setData()
	self.lotteryRank = cache.LuckyLottery:getPreLotteryRankData()
end


function AwardRankView:onDetailButtonClicked( sender,eventype )
	if eventype == ccui.TouchEventType.ended then
		mgr.ViewMgr:showView(_viewname.GUIZE):showByName(22)
	end
end

function AwardRankView:changeTimes(  )
	-- body
	self.refreshTime = self.refreshTime-1
	self:onRefreshTime()
	if self.refreshTime == 0 then
		proxy.LuckyLottery:sendMessage()
	end

	self.leftTime = self.leftTime - 1
	if self.leftTime <= 0 then 
		self.leftTime = 0
		G_mainView()
		return
	end

	--如果是主界面进入
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		view:updateData(G_getTimeStr(self.leftTime),string.format(res.str.ACT2_AWARD_RANK_DESC8,self.lotteryNum))
	end

end

function AwardRankView:onRefreshTime(  )
	-- body
	local hour=math.floor(self.refreshTime/3600)
	local minu=math.floor(self.refreshTime%3600/60)
	local second=self.refreshTime%60

	self.PTimeText:setString(string.format(res.str.ACT2_AWARD_RANK_DESC2,hour,minu,second))

	if self.refreshTime <= 0 then
		self.PTimeText:setString(string.format(res.str.ACT2_AWARD_RANK_DESC40))
	end
end

function AwardRankView:onbtnPreAward( sender,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		proxy.LuckyLottery:send_116159({pageNum = 1})
		
	end 
end

function AwardRankView:onbtnOpenMyCard( sender,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		proxy.LuckyLottery:onRequestMyLottery(1)
	end 
end

function AwardRankView:onbtnReq1( sender,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		proxy.LuckyLottery:onRequestLotteryRank()
		--mgr.ViewMgr:showView(_viewname.MAINLOTTERY)
	end 
end


function AwardRankView:onbtnClose2( sender,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		self.Panel1:setVisible(true)
		self.Panel2:setVisible(false)
	end 
end

function AwardRankView:onbtnClose3( sender,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		self.Panel1:setVisible(true)
		self.Panel3:setVisible(false)
	end 
end

function AwardRankView:onbtnPrePage( sender,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		if self.PageNum == 1 then
			return
		end
		self.PageNum = self.PageNum - 1

		self.PageNumText:setString(string.format("%d/%d", self.PageNum,self.totalPageNum))

		self.myLottery = cache.LuckyLottery:getMyLotteryData(self.PageNum)
		self:onRefreshPage(  )
	end 
end

function AwardRankView:onbtnNextPage( sender,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		if self.PageNum == self.totalPageNum then
			return
		end
	
		self.PageNum = self.PageNum + 1

		self.PageNumText:setString(string.format("%d/%d", self.PageNum,self.totalPageNum))
		
		proxy.LuckyLottery:onRequestMyLottery(self.PageNum)
	end
end

function AwardRankView:onPreAwardRank(  sender,eventype )
	if eventype == ccui.TouchEventType.ended then
		
		if self.currAwardRankFlag == 2 then
			return
		end
		self.currAwardRankFlag = 2

		self:onRefreshAwardRank()
	end
end

function AwardRankView:onNextAwardRank(  sender,eventype )
	if eventype == ccui.TouchEventType.ended then
		
		if self.currAwardRankFlag == 1 then
			return
		end
		self.currAwardRankFlag = 1

		self:onRefreshAwardRank()
	end
end

return AwardRankView