--
-- Author: Your Name
-- Date: 2015-07-21 16:15:38
--


local EatChickenView = class("EatChickenView", base.BaseView)


function EatChickenView:init( )
	-- body

	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	-- 获取开餐信息

	self.btnWait = self.view:getChildByName("TimePanel"):getChildByName("Button_Wait")
	self.textTime = self.view:getChildByName("TimePanel"):getChildByName("Text_Time")
	self.timeBg = self.view:getChildByName("TimePanel"):getChildByName("Image_4")
	self.btnWait:addTouchEventListener(handler(self,self.startEat))


	self.x = display.cx
	self.y = display.cy - 70

	self.btnWait:setBright(false)
	self.btnWait:setEnabled(false)
	self.textTime:setString("12:00-14:00")
	self:playHapEft()

	local panel2 = self.view:getChildByName("Panel_2")
	panel2:getChildByName("Text_3"):setString(res.str.ACTIVE_TEXT15)
	panel2:getChildByName("Text_5"):setString(res.str.ACTIVE_TEXT16)
	self.btnWait:setTitleText(res.str.HSUI_DESC10)

	proxy.eatChicken:reqInfo()

end

function EatChickenView:checkTime( dt )
	-- body

	self.timeTick = self.timeTick + 1
	if self.timeTick >= self.data["lastTime"] then
		
		proxy.eatChicken:reqInfo()
		self:stopAction(self.TmSchedule)
	end

end

function EatChickenView:changeUI()
	-- body
	if self.data["isGet"] == 1 then
		self.btnWait:setBright(true)
		self.btnWait:setEnabled(true)
		self.btnWait:setTitleText(res.str.HSUI_DESC9)
		self:stopAction(self.TmSchedule)
		
	else
		--todo
		self.btnWait:setBright(false)
		self.btnWait:setEnabled(false)
		self.btnWait:setTitleText(res.str.HSUI_DESC10)
		self.textTime:setVisible(true)
		self.timeBg:setVisible(true)
	end

	self.textTime:setString(self.data["timeTips"])
	
end

function EatChickenView:setTimeData ( data )
	-- body

	--dump(data)
	
	self.data = data
	self.timeTick = 0
	self.TmSchedule = self:schedule(self.checkTime, 1.0)
	self:changeUI()

end



function EatChickenView:setAwardData( data )


		self.data = data
		self:playEft()
		--G_TipsOfstr("恢复".. data.pointValue .. "点体力")
		G_TipsOfstr(string.format(res.str.EATCHICKEN_TIPS1, data.pointValue))
		self.btnWait:setBright(false)
		self.btnWait:setEnabled(false)
		self.btnWait:setTitleText(res.str.HSUI_DESC10)
		self.textTime:setString(data["timeTips"])
		self:changeUI()
		proxy.eatChicken:reqInfo()
end



function EatChickenView:startEat( sender,eventType )
	-- body

	if eventType == ccui.TouchEventType.ended then
		--todo
		proxy.eatChicken:reqAward()
	end

end

function EatChickenView:updateEft( dt )
	-- body
	if self.eftTimeTick >= 2 then
		self.eatArm:removeFromParent()
		self:playHapEft()
		self:stopAction(self.schedule)
	end

	self.eftTimeTick = self.eftTimeTick + 1

end


--------吃鸡动画
function EatChickenView:playEatEft( )
	-- body
	local x = 1
	local params =  {id=404822, x=self.x,y=self.y,move_time = 1,addTo=self.view, playIndex=4,retain =false,scale=0.8,loadComplete=function( arm)
		-- body

		-- 开启定时器，3 秒后停止播放动画
		self.eatArm = arm
		self.schedule = self:schedule(self.updateEft,1)
		self.eftTimeTick = 0
	end}
		
		mgr.effect:playEffect(params)
end

------平时等待 动画
function EatChickenView:playHapEft( )
	-- body
	local params =  {id=404822, x=self.x,y=self.y,addTo=self.view, playIndex=6,retain =true,scale=0.8,loadComplete=function(arm )
		-- body
		self.normalEft = arm
	end}
		mgr.effect:playEffect(params)
end


function EatChickenView:playEft( )
	-- body
	self.normalEft:removeFromParent()
	local params =  {id=404822, x=self.x,y=self.y,addTo=self.view, playIndex=3,retain =false,scale=0.8,endCallFunc=function( )
		-- body
		self:playEatEft()

	end}
		mgr.effect:playEffect(params)
end


return EatChickenView

