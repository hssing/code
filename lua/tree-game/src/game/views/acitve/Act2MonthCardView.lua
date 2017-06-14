--
-- Author: Your Name
-- Date: 2015-12-04 22:42:41
--
local Act2MonthCardView = class("Act2MonthCardView", base.BaseView)

function Act2MonthCardView:init(  )
	self.showtype=view_show_type.UI
	self.ShowAll= true
	self.view=self:addSelfView()

	self.panel = self.view:getChildByName("Panel_1")

	self.lookBtn1 = self.panel:getChildByName("Button_2")
	self.lookBtn2 = self.panel:getChildByName("Button_2_0")

	self.lookBtn1.id = 1
	self.lookBtn2.id = 2
	self.lookBtn1:addTouchEventListener(handler(self,self.onLookCallbacl))
	self.lookBtn2:addTouchEventListener(handler(self,self.onLookCallbacl))


	--界面文本
	self.lookBtn1:getChildByName("Text_8"):setString(res.str.ACT2_MONTH_CARD_DESC1)
	self.lookBtn2:getChildByName("Text_8_0"):setString(res.str.ACT2_MONTH_CARD_DESC1)

	self.panel:getChildByName("Image_1"):getChildByName("Text_17"):setString(res.str.ACT2_MONTH_CARD_DESC2)
	self.panel:getChildByName("Image_8"):getChildByName("Text_17_1"):setString(res.str.ACT2_MONTH_CARD_DESC2)


	--proxy.RichRank:reqMothinfo()
	proxy.Active:send_116136()

end


function Act2MonthCardView:setData(data )
	self.leftTime = data.leftTime
	if self.leftTime <= 0 then
		G_mainView()
		return
	end

	local timeStr = self:getTimeStr(self.leftTime)

	--local day = self.data["dayCount"] > 0 and self.data["dayCount"] - 1 or 0
	--如果是主界面进入
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		view:updateData(timeStr,"")
	end

	self.timeSchedual = self:schedule(self.timeTick, 1)



end



function Act2MonthCardView:onLookCallbacl( senb,etype )
	if etype == ccui.TouchEventType.ended then
		proxy.Active:reqSwitchState(1013)
	end
end

-----活动倒计时
function Act2MonthCardView:timeTick( )
	self.leftTime = self.leftTime - 1
	--self.todayTime = self.todayTime - 1
	if self.leftTime <= 0 then
		self:stopAction(self.timeSchedual)
		--如果是主界面进入
		local view = mgr.ViewMgr:get(_viewname.RANKENTY)
		if view then
			view:updateData(res.str.RICH_RANK_DESC37)
		end

		self.lookBtn1:setEnabled(false)
		self.lookBtn2:setEnabled(false)
		G_mainView()

		return
	end

	-- if self.dayTime <= 0 then
	-- 	self:stopAllActions()
	-- 	proxy.RichRank:send116134()
	-- 	return
	-- end

	-- if self.todayTime <= 0 then
	-- 	self:stopAllActions()
	-- 	proxy.RichRank:reqOpenChargeCountInfo()
	-- 	return
	-- end

	--如果是主界面进入
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		view:updateData(self:getTimeStr(self.leftTime))
	end

end


function Act2MonthCardView:getTimeStr( leftTime )
	--self.leftTime = self.leftTime - 1
	local left = 0
	local day = math.floor(leftTime / (60 * 60 * 24))--天
	left = leftTime - day * 60 * 60 * 24

	local hour = math.floor(left / (60 * 60))--时
	left = left - hour * 60 * 60

	local minute = math.floor(left / 60)--分
	left = left - minute * 60 --秒
	local timeStr

	if day == 0 and hour == 0 and minute == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC9,left)
	elseif day == 0 and hour == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC10, minute,left)
	elseif day == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC11, hour,minute,left)
	else
		timeStr = string.format(res.str.RICH_RANK_DESC12, day,hour,minute,left)
	end

	return timeStr
end





return Act2MonthCardView