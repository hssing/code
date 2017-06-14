--
-- Author: Your Name
-- Date: 2015-08-26 21:45:47
--
local  ChargePerDayView = class("ChargePerDayView", base.BaseView)


function ChargePerDayView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.awardPale = self.view:getChildByName("Panel_5")

	self.listViewPanel = self.awardPale:getChildByName("ListView_2")
	self.itemClone = self.view:getChildByName("item")

	self.itemPanle = self.listViewPanel:getChildByName("Panel_item")
	
	self.btnGet = self.itemPanle:getChildByName("Button_get")
	self.btnGet:setVisible(false)
	self.itemClone = self.view:getChildByName("item")

	self.RuleLab = self.itemPanle:getChildByName("Text_5_14")
	self.RuleLab:ignoreContentAdaptWithSize(false)
	self.RuleLab:setContentSize(600,60)
	self.RuleLab:setPosition(self.RuleLab:getPositionX() - 10,self.RuleLab:getPositionY() - 20)

	self.timeLab = self.itemPanle:getChildByName("Text_7_18")

	self.btnGet:addTouchEventListener(handler(self,self.btnGetClicked))

	local Text_5_14 = self.itemPanle:getChildByName("Text_5_14")
	Text_5_14:setString(res.str.ACTIVE_TEXT4)
	local Text_6_16 = self.itemPanle:getChildByName("Text_6_16")
	Text_6_16:setString(res.str.ACTIVE_TEXT45)

	--self.data = conf.ChargePerDay:getData()

	--self:createitems(1)

	--请求网络数据
	proxy.ChargrPerDay:reqDateInfo()

end

--，创建显示奖励物品
function ChargePerDayView:createitems( data )
	
	--local gifts = self.data[day]["gifts"]
	local gifts = data["items"]
	--self.awardPale:setVisible(true)
	self.btnGet:setVisible(true)
	--按钮
	self:setBtnState(data["isGet"])

	for i=1,#gifts do
		local item = self.itemClone:clone()
		item:setAnchorPoint(0.5,0)

		local iconFrame = item:getChildByName("btn_goods")
		local iconImg = item:getChildByName("img_goods")
		local textLb = item:getChildByName("text_goods")

		local mid = gifts[i]["mId"]
		local num = gifts[i]["amount"]
		local iconFrameSrc = conf.CrazyFeedBack:getFrameIcon(mid)
		local iconImgSrc = conf.CrazyFeedBack:getIcon(mid)
		local textLbName = conf.CrazyFeedBack:getName(mid)
		local textColor = conf.CrazyFeedBack:getTextColor(mid)

		iconFrame:loadTextureNormal(iconFrameSrc)
		iconImg:loadTexture(iconImgSrc)
		textLb:setString(textLbName .. "x" .. num)
		textLb:setColor(textColor)


		iconFrame.mid = mid
		iconFrame:addTouchEventListener(handler(self,self.openItem))

		local y = self.itemPanle:getContentSize().height/2 - 50

		if #gifts == 1 then
			item:setPosition(self.itemPanle:getContentSize().width/2,y)
		elseif #gifts == 2 then
			item:setPosition(self.itemPanle:getContentSize().width*i/3,y)
		elseif #gifts == 3 then
			if i == 1 then
				item:setPosition(self.itemPanle:getContentSize().width*i/4 - 10,y)
			elseif i == 2 then
				item:setPosition(self.itemPanle:getContentSize().width*i/4,y)
			elseif i == 3 then
				item:setPosition(self.itemPanle:getContentSize().width*i/4 + 10,y)
			end
		elseif  #gifts == 4 then
			if i == 1 then
				item:setPosition(self.itemPanle:getContentSize().width*i/5 - 40,y)
			elseif i == 2 then
				item:setPosition(self.itemPanle:getContentSize().width*i/5 - 15,y)
			elseif i == 3 then
				item:setPosition(self.itemPanle:getContentSize().width*i/5 + 15,y)
			elseif i == 4 then
				item:setPosition(self.itemPanle:getContentSize().width*i/5 + 40,y)
			end
		end
		

		--self.listView:pushBackCustomItem(item)
		self.itemPanle:addChild(item)
	end
			

end



-----打开物品

function ChargePerDayView:openItem( send,eventType  )
	-- body
	if eventType == ccui.TouchEventType.ended then

		local data = {}
			data.mId = send.mid
		local itype=conf.Item:getType(data.mId)
		if itype ==  pack_type.PRO then
			G_openItem(data.mId)
		elseif itype  == pack_type.EQUIPMENT then 
			G_OpenEquip(data,true)
		else	
			G_OpenCard(data,true)
		end

	end
end

-----活动倒计时
function ChargePerDayView:timeTick( )
	-- bod
	self.leftTime = self.leftTime - 1
	self.timeLab:setString(self:getTimeStr())
	if self.leftTime == 0 then
		self:stopAction(self.timeSchedual)
		proxy.ChargrPerDay:reqDateInfo()
	end

end

function ChargePerDayView:getTimeStr(  )
	--self.leftTime = self.leftTime - 1
	local left = 0
	local day = math.floor(self.leftTime / (60 * 60 * 24))--天
	left = self.leftTime - day * 60 * 60 * 24

	local hour = math.floor(left / (60 * 60))--时
	left = left - hour * 60 * 60

	local minute = math.floor(left / 60)--分
	left = left - minute * 60 --秒
	
	local timeStr

	if day == 0 and hour == 0 and minute == 0 then
		timeStr = string.format(res.str.HSUI_DESC4,left)
	elseif day == 0 and hour == 0 then
		timeStr = string.format(res.str.HSUI_DESC5, minute,left)
	elseif day == 0 then
		timeStr = string.format(res.str.HSUI_DESC6, hour,minute,left)
	end

	return timeStr
end



--领取按钮回调
function ChargePerDayView:btnGetClicked( send,eventType )
	if eventType == ccui.TouchEventType.ended then
		--proxy.ChargrPerDay:reqGetAward()
		proxy.CrazyFeedBack:reqGetAward(1,1)
	end
end

------网络数据返回

--奖励日期返回
function ChargePerDayView:setGiftInfo( data )
	self:createitems(data)
	self.leftTime = data["lastTime"]
	--显示倒计时
	self.timeLab:setString(self:getTimeStr())

	self.timeSchedual = self:schedule(self.timeTick, 1)
end

--领取奖励返回
function ChargePerDayView:getAwardSucc( data )
	self:setBtnState(1)
end

function ChargePerDayView:setBtnState( flag )
	local label = self.btnGet:getChildByName("Text_title")
	if flag == 0 then
		label:setString(res.str.HSUI_DESC1)
		self.btnGet:setEnabled(true)
		self.btnGet:setBright(true)
	elseif flag == 1 then
		label:setString(res.str.HSUI_DESC2)
		self.btnGet:setEnabled(false)
		self.btnGet:setBright(false)
	else
		label:setString(res.str.HSUI_DESC1)
		self.btnGet:setEnabled(false)
		self.btnGet:setBright(false)	--todo
	end
end










return ChargePerDayView