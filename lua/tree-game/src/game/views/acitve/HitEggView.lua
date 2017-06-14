--
-- Author: Your Name
-- Date: 2015-11-11 17:12:46
--

local HitEggView = class("HitEggView", base.BaseView)

function HitEggView:init(  )
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	--mgr.SceneMgr:getMainScene():closeHeadView()

	self.panel = self.view:getChildByName("Panel_1")
	self.cloneItem1 = self.view:getChildByName("Image_7")
	self.cloneItem2 = self.view:getChildByName("Panel_21")

	self.headPanel = self.panel:getChildByName("Panel_head")
	self.eggPanel = self.panel:getChildByName("Panel_egg")


	--规则按钮
	local gz = self.headPanel:getChildByName("Button_3")
	gz:addTouchEventListener(handler(self,self.gzCallbacl))

	--底部
	self.footPanel = self.panel:getChildByName("Panel_foot") 

	self.listView1 = self.panel:getChildByName("ListView_7")
	self.listView2 = self.footPanel:getChildByName("Image_2"):getChildByName("ListView_1")
	self.oneTimeBtn = self.footPanel:getChildByName("Button_7_0")
	self.tenTimeBtn = self.footPanel:getChildByName("Button_7")

	self.oneTimeBtn.count = 1
	self.tenTimeBtn.count = 10
	self.tenTimeBtn:addTouchEventListener(handler(self,self.hitEggCallback))
	self.oneTimeBtn:addTouchEventListener(handler(self,self.hitEggCallback))

	--木槌
	self.moodHitCount = self.footPanel:getChildByName("Image_3"):getChildByName("Text_2") 
	self.moodHitBtn = self.footPanel:getChildByName("Image_3"):getChildByName("Button_1") 
	self.moodHitBtn:addTouchEventListener(handler(self,self.getBitBtnCallback))



	--界面文本
	self.headPanel:getChildByName("Image_19"):getChildByName("Text_22_7"):setString(res.str.RICH_RANK_DESC34)
	self.oneTimeBtn:getChildByName("Text_26_28"):setString(res.str.RICH_RANK_DESC14)
	self.tenTimeBtn:getChildByName("Text_26"):setString(res.str.RICH_RANK_DESC13)
	self.footPanel:getChildByName("Image_2"):getChildByName("Text_1"):setString(res.str.RICH_RANK_DESC15)
	self.footPanel:getChildByName("Image_3"):getChildByName("Text_3"):setString(res.str.RICH_RANK_DESC16)


	self.cloneItem1:getChildByName("Image_8"):setVisible(false)


	local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	if view then
		view:bottomBtnsState(false)
	end

	local data = {}
	data.lastTime = os.time()
	data.zdCount = 0
	data.sumMoneyZs = 10000
	data.awards = {}
	data.awards["30"] = 1
	data.awards["50"] = 1
	data.awards["20"] = 1

	self:playNormalEff()
	--self:setData(data)
	proxy.RichRank:reqHitEgginfo()
end

--[[
	
int32_t
变量名：lastTime	说明：活动剩余时间(秒)
2	
int32_t
变量名：zdCount	说明：砸蛋数量
3	
int32_t
变量名：sumMoneyZs	说明：累积充值
4	
vector<map>
变量名：awards	说明：累充金额[id]->大于0为已领取
--]]

function HitEggView:setData( data )
	-- body
	self.czCount = data.zdCount
	self.moodHitCount:setString(string.format(res.str.RICH_RANK_DESC18, data.zdCount))
	self.leftTime = data.lastTime

	local zsStr = string.format(res.str.RICH_RANK_DESC5, data.sumMoneyZs / 10)

	--如果是从活动进入
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		view:updateData(self:getTimeStr(data.lastTime),zsStr)
	end

	local moneyData = conf.HitEgg:getMoneyData()
	local awardData = conf.ActiveVar:getValueByName("zadan")

---充值金额
	for i=1,#moneyData do
		local moneyItem = self.cloneItem1:clone()
		local getIcon = moneyItem:getChildByName("Image_8")
		local moneyLab = moneyItem:getChildByName("Text_4")
		local contLab = moneyItem:getChildByName("Text_5")

		contLab:setString("x" .. (moneyData[i]["hammer"]))
		moneyLab:setString(string.format(res.str.RICH_RANK_DESC17,moneyData[i]["money"] ))
		local award = data.awards
		if award[moneyData[i].id .. ""] and  award[moneyData[i].id .. ""] > 0 then
			getIcon:setVisible(true)
		end

		self.listView1:pushBackCustomItem(moneyItem)
	end

---奖励

	for i=1,#awardData do
		local awardItem = self.cloneItem2:clone()
		local frame = awardItem:getChildByName("Button_19")
		local icon = awardItem:getChildByName("Image_50")

		local  color = conf.Item:getItemQuality(awardData[i][1])
		local iconPath = res.btn["FRAME"][color]

		icon:loadTexture(conf.Item:getItemSrcbymid(awardData[i][1]) )
		frame:loadTextureNormal(iconPath)
		frame:addTouchEventListener(handler(self,self.openItem))
		frame.mId = awardData[i][1]

		self.listView2:pushBackCustomItem(awardItem)
	end


	--开始倒计时
	self.timeSchedual  = self:schedule(self.timeTick, 1)

end


--砸蛋成功返回
function HitEggView:hitEggSucc( data )
	self.moodHitCount:setString(string.format(res.str.RICH_RANK_DESC18, data.zdCount))
	
	

	for i=1,#data.awards do
		data.awards[i]["bj"] = data.bjs[i]
	end

	cache.Player:_setRichRankNumber(cache.Player:getRichRankNumber() - (self.czCount - data.zdCount ))
	local view = mgr.ViewMgr:get(_viewname.MAIN)
	if view then
		view:setRedPoint()
	end

	local view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
	if view then
		view:setData(data.awards,true,true,false)
		view:setButtonVisible(false)
		view:setSureBtnTile(res.str.HSUI_DESC12)
	end

	 self.czCount = data.zdCount
end


--规则
function HitEggView:gzCallbacl( send,etype )
	-- body
	if etype == ccui.TouchEventType.ended then
		local view = mgr.ViewMgr:showView(_viewname.GUIZE)
		view:showByName(13)
	end
end

--砸蛋
function HitEggView:hitEggCallback( send,etype )
	-- body

	if etype == ccui.TouchEventType.ended then
		if self.czCount <= 0 then
			G_TipsOfstr(res.str.RICH_RANK_DESC31)
			return
		end
		self.count = send.count
		self:HitEff()
		
	end
end

--获得木槌
function HitEggView:getBitBtnCallback( send,etype )
	-- body
	if etype == ccui.TouchEventType.ended then
		G_GoReCharge()
	end
end


function HitEggView:openItem( send,eventType  )
	-- body
	if eventType == ccui.TouchEventType.ended then

		local data = {}
			data.mId = send.mId
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
function HitEggView:timeTick( )
	self.leftTime = self.leftTime - 1
	local timeStr = self:getTimeStr(self.leftTime)
	if self.leftTime == 0 then
		self:stopAction(self.timeSchedual)
		timeStr = res.str.RICH_RANK_DESC37
	end
	--如果是从活动进入
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		view:updateData(timeStr)
	end

end



function HitEggView:getTimeStr( leftTime )
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

------平时等待 动画
function HitEggView:playNormalEff( )
	-- body
	if self.hitEft then
		 self.hitEft:removeFromParent()
		 self.hitEft = nil
	end

	if self.halfEft then
		self.halfEft:removeFromParent()
		self.halfEft = nil
	end
	self.oneTimeBtn:setEnabled(true)
	self.tenTimeBtn:setEnabled(true)

	--鸡蛋
	local params =  {id=404857, x=self.eggPanel:getPositionX(),y=self.eggPanel:getPositionY() + 100,addTo=self.panel, playIndex=2,retain =false,loadComplete=function(arm )
		-- body
		self.eggEft = arm
		self.eggEft:setLocalZOrder(10)
	end}
		mgr.effect:playEffect(params)
	--锤子
	local params =  {id=404857, x=self.eggPanel:getPositionX() + 50,y=self.eggPanel:getPositionY() + 200,addTo=self.panel, playIndex=0,retain =false,loadComplete=function(arm )
		-- body
		self.normalEft = arm
	end}

	mgr.effect:playEffect(params)

end

--砸蛋动画
function  HitEggView:HitEff(  )
	if self.normalEft then
		 self.normalEft:removeFromParent()
		 self.normalEft = nil
	end

	self.oneTimeBtn:setEnabled(false)
	self.tenTimeBtn:setEnabled(false)

	local params =  {id=404857, x=self.eggPanel:getPositionX() + 50,y=self.eggPanel:getPositionY() + 200,addTo=self.panel, playIndex=1,retain =false,loadComplete=function(arm )
		-- body
		self.hitEft = arm
		self.hitEft:setLocalZOrder(1000)
	end,endCallFunc=function( )
			self.hitEft:removeFromParent()
			self:playNormalEff()
			proxy.RichRank:reqHitEgg(self.count)
	    end,triggerFun = function(trg, to, effConfig )
	    	local params =  {id=404857, x=self.eggPanel:getPositionX(),y=self.eggPanel:getPositionY() + 100,addTo=self.panel, playIndex=3,retain =false,loadComplete=function(arm )
				self.halfEft = arm
				self.halfEft:setLocalZOrder(10)
			end}
			if self.eggEft then
				self.eggEft:removeFromParent()
				self.eggEft = nil
			end
			mgr.effect:playEffect(params)

	    end}
		mgr.effect:playEffect(params)
end


function HitEggView:closeSelfView(  )
	local view = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	if view then
		view:bottomBtnsState(true)
	end
	mgr.ViewMgr:closeView(_viewname.HITEGG)
end


return HitEggView