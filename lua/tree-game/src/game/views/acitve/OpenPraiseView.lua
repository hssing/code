--
-- Author: Your Name
-- Date: 2015-11-20 15:44:11
--

local  OpenPraiseView = class("ActivePraiseView", base.BaseView)


function OpenPraiseView:init(  )
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.panel = self.view:getChildByName("Panel_1")
	self.cloneItem = self.view:getChildByName("Panel_2_3")

	self.headPanel = self.panel:getChildByName("Panel_head_0")
	self.panleImg = self.headPanel:getChildByName("Image_14") 
	self.timeLab = self.panleImg:getChildByName("Text_17") 
	self.zsLab = self.panleImg:getChildByName("Text_18") 

	--规则按钮
	local gz = self.headPanel:getChildByName("Button_3_4")
	gz:addTouchEventListener(handler(self,self.gzCallbacl))


	--剩余点赞数
	self.leftPraiseCount = self.headPanel:getChildByName("Text_23")

	--结算倒计时
	self.calcuLab = self.panel:getChildByName("Text_21") 

	self.pos = {}
	local size = 6
	for i=1,size do
		self.pos[#self.pos + 1] = self.panel:getChildByName("Panel_10" .. i)
	end

	--刷新按钮
	local  refresh = self.panel:getChildByName("Button_4")
	refresh:addTouchEventListener(handler(self,self.refreshCallback))
	--充值
	local  charge = self.panel:getChildByName("Button_5")
	charge:addTouchEventListener(handler(self,self.chargeCallback))

	--昨日排行按钮
	local yestBtn =  self.headPanel:getChildByName("Button_1")
	yestBtn:addTouchEventListener(handler(self,self.yesterdayRankCallback))


	--界面文本
	--self.headPanel:getChildByName("Image_19_25"):getChildByName("Text_22_7_31"):setString(res.str.RICH_RANK_DESC1)
	self.panel:getChildByName("Button_4"):getChildByName("Text_19"):setString(res.str.RICH_RANK_DESC3)
	self.panel:getChildByName("Button_5"):getChildByName("Text_20"):setString(res.str.RICH_RANK_DESC4)
	self.panleImg:getChildByName("Text_16"):setString(res.str.RICH_RANK_DESC2)

	yestBtn:getChildByName("Text_1"):setString(res.str.OPEN_ACT_PRAISE_DESC6)
--[[
lastTime	说明：活动结束时间(秒)
2	
int32_t
变量名：sumMoneyZs	说明：总充值
3	
int32_t
变量名：todayZan	说明：今天可以点赞数
4	
vector<QmthItemInfo>
变量名：qmthList


index	说明：位置
2	string	变量名：roleName	说明：玩家名
3	int32_t	变量名：dianZan	说明：点赞数
4	int32_t	变量名：czZs
--]]
	--proxy.RichRank:reqRankInfo()
local data = {}
	data.lastTime = os.time()
	data.sumMoneyZs = 1000555
	data.todayZan = 10

	data.qmthList = {}

	for i=1,6 do
		local item = {}
		item.index = i 
		item.roleName = i * 100
		item.dianZan = i *3000
		item.czZs = i *90000
		item.roleSex = i % 2
		data.qmthList[i] = item
	end

	--self:setData(data)
	local params =  {id=404826, x=self.panel:getContentSize().width/2,
	y=self.panel:getContentSize().height/2,addTo=self.panel, playIndex=4}
	mgr.effect:playEffect(params)

	proxy.OpenAct:reqRankInfo()
end

function OpenPraiseView:setData( data )

	--奖励回馈系数
	self.varData = conf.OpenActVar:getValueByName("open_act_qmth_xishu")
	self.leftPraiseCount:setString(string.format(res.str.RICH_RANK_DESC6, data.todayZan))

	self.leftTime = data.lastTime
	self.todayLeftTime = data.todayTime
	self.dzCount = data.todayZan

	local zsStr = string.format(res.str.RICH_RANK_DESC36, data.sumMoneyZs)
	self.timeLab:setString(self:getTimeStr(self.leftTime))
	self.zsLab:setString(zsStr)

	self.calcuLab:setString(string.format(res.str.RICH_RANK_DESC28, self:getTimeStr(data.todayTime)))
	self:setItemsData(data.qmthList)

	--开始倒计时
	self:stopAllActions()
	self.timeSchedual  = self:schedule(self.timeTick, 1)




end

--创建或刷新数据
function OpenPraiseView:setItemsData(qmthList )
	---每个名次
	local k = 0
	for i,v in pairs(qmthList) do

		if i > 6 then
			break
		end

		local item
		if self.panel:getChildByName("item_" .. qmthList[i].index)  then
			item = self.panel:getChildByName("item_" .. qmthList[i].index)
		else
		    item = self.cloneItem:clone()
			item:setName("item_" .. qmthList[i].index)
			local panel = self.pos[qmthList[i].index]
			local posx,posy = panel:getPosition()
			item:setPosition(posx,posy)
		end
		local nameLab1 = item:getChildByName("Image_10")
		local nameLab2 = item:getChildByName("Image_3")
		local roleIcon = item:getChildByName("Image_2_4")
		local praiseBtn = item:getChildByName("Panel_14")
		local dianZanLab = praiseBtn:getChildByName("Text_29")

		local bg = item:getChildByName("Image_4")
		local descPan = bg:getChildByName("Panel_desc")
		local zsLab = descPan:getChildByName("Text_3_12")
		local leftLab = descPan:getChildByName("Text_2_8")
		local loveLab = descPan:getChildByName("Text_4_14")
		local  zsIcon = descPan:getChildByName("Image_5_10")
		local  loveIcon = descPan:getChildByName("Image_6_12")

		local dianZan = qmthList[i].dianZan
		local zs = qmthList[i].czZs

		--设置数值
		zsLab:setString(zs .. "+")
		loveLab:setString(dianZan .. ")x" .. (self.varData[qmthList[i].index] / 100))

		--计算着几个鬼东西的大小，便于居中
		local size = 0
		size = size + leftLab:getContentSize().width

		size = size + zsLab:getContentSize().width + loveLab:getContentSize().width
		size = size + zsIcon:getContentSize().width * 0.4 + loveIcon:getContentSize().width
		descPan:setContentSize(size,descPan:getContentSize().height)
		descPan:setPosition(bg:getContentSize().width / 2, descPan:getPositionY())

		local off = 0
		leftLab:setPosition(off, leftLab:getPositionY())
		off = leftLab:getContentSize().width
		zsIcon:setPosition(5, zsIcon:getPositionY())
		off = zsIcon:getPositionX() + zsIcon:getContentSize().width * 0.4
		zsLab:setPosition(off, zsLab:getPositionY())
		off = zsLab:getPositionX() + zsLab:getContentSize().width
		loveIcon:setPosition(off, loveIcon:getPositionY())
		off = loveIcon:getPositionX() + loveIcon:getContentSize().width
		loveLab:setPosition(off, loveLab:getPositionY())


		--角色信息
		local roleName = qmthList[i].roleName
		local roleSex = qmthList[i].roleSex
		if roleName == "" then
			roleName = res.str.RICH_RANK_DESC40
		end

		--点赞数
		dianZanLab:setString(dianZan)

		if self.panel:getChildByName("item_" .. qmthList[i].index) == nil  then
			
			local params =  {id=404858, x=30,y = 25,addTo = praiseBtn, playIndex=0,retain =false,loadComplete=function(arm )
			-- body
				self.eggEft = arm
				self.eggEft:setLocalZOrder(10)
				self.eggEft:setTouchEnabled(true)
			end}
			mgr.effect:playEffect(params)
		end
		praiseBtn:reorderChild(dianZanLab,1000)
		praiseBtn:addTouchEventListener(handler(self,self.praiseBtnCallback))
		praiseBtn.index = qmthList[i].index

		--男女
		if roleSex == 1 then
			roleIcon:loadTexture(res.image.ROLE_BOY)
			roleIcon:setScale(0.33)
		elseif roleSex == 2 then
			roleIcon:loadTexture(res.image.ROLE_GRILS)
			roleIcon:setScale(0.31)
		else
			roleIcon:loadTexture(res.image.CONTEST_ROLE[2])
			roleIcon:setScale(0.30)
		end

		if qmthList[i].index < 4 then
			nameLab2:setVisible(false)
			nameLab1:getChildByName("Text_9_4"):setString(roleName)
			nameLab1:getChildByName("Text_9_4"):setScale(1.2)
			nameLab1:getChildByName("Text_10_6"):setScale(1.2)
			nameLab1:getChildByName("Text_10_6"):setString(string.format(res.str.RICH_RANK_DESC7, zs))
			local rank = nameLab1:getChildByName("Image_11_7")
			local icon = "res/views/ui_res/icon/icon_rank%d.png"
			rank:loadTexture(string.format(icon, qmthList[i].index) )
			
		else
			nameLab1:setVisible(false)
			nameLab2:getChildByName("Text_6_18"):setString(roleName)
			nameLab2:getChildByName("Text_6_18"):setScale(1.2)
			nameLab2:getChildByName("Text_7_16"):setScale(1.2)
			nameLab2:getChildByName("Text_7_16"):setString(string.format(res.str.RICH_RANK_DESC7, zs))

			local rank = nameLab2:getChildByName("Image_7_15")
			local fontName = res.font.FLOAT_NUM[4]
			--如果存在，移除
			if rank:getChildByName("rankNum") then
				rank:removeChildByName("rankNum")
			end

            local numTxt = cc.LabelAtlas:_create(qmthList[i].index,fontName,16,21,string.byte("."))
            numTxt:setName("rankNum")
            numTxt:setAnchorPoint(0.5,0.5)
            numTxt:setPosition(rank:getContentSize().width / 2, rank:getContentSize().height / 2)
			rank:addChild(numTxt)
			
		end

		if self.panel:getChildByName("item_" .. qmthList[i].index) == nil then
			self.panel:addChild(item)
		end

		k = k + 1
	end

end


-----活动倒计时
function OpenPraiseView:timeTick( )
	self.leftTime = self.leftTime - 1
	local timeStr = self:getTimeStr(self.leftTime)
	if self.leftTime <= 0 then
		--self:stopAction(self.timeSchedual)
		self:stopAllActions()
		timeStr = res.str.RICH_RANK_DESC37
		return
	end

	if self.todayLeftTime <= 0 then
		self:stopAction(self.timeSchedual)
		proxy.OpenAct:reqRankInfo()
	end
	
	self.timeLab:setString(timeStr)


	self.todayLeftTime = self.todayLeftTime - 1
	self.calcuLab:setString(string.format(res.str.RICH_RANK_DESC28, self:getTimeStr(self.todayLeftTime)))

end


function OpenPraiseView:getTimeStr( leftTime )
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

--点赞成功
function OpenPraiseView:praiseSucc( data )
	--self:setItemsData(data.qmthList)
	self.dzCount = data.todayZan
	self.leftPraiseCount:setString(string.format(res.str.RICH_RANK_DESC6, data.todayZan))
	local data1 = {}
	data1[1] = {}
	data1[1].index = 1
	data1[1].mId = 221051002
	data1[1].amount = data.awardZs

	--设置红点
	cache.Player:_setRichRankNumber(cache.Player:getRichRankNumber() - 1)
	local view = mgr.ViewMgr:get(_viewname.MAIN)
	if view then
		view:setRedPoint()
	end

	local view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
	if view then
		view:setData(data1,true,true,false)
		view:setButtonVisible(false)
		view:setSureBtnTile(res.str.HSUI_DESC12)
	end
	self:setItemsData(data.qmthList)
	--proxy.RichRank:reqRankInfo()
end


--点赞
function OpenPraiseView:praiseBtnCallback( send,etype )
	if etype == ccui.TouchEventType.ended then
		if self.dzCount <= 0 then
			G_TipsOfstr(res.str.RICH_RANK_DESC32)
			return
		end
		proxy.OpenAct:reqPraise(send.index)
	end
end


--规则
function OpenPraiseView:gzCallbacl( send,etype )
	-- body
	if etype == ccui.TouchEventType.ended then
		local view = mgr.ViewMgr:showView(_viewname.GUIZE)
		view:showByName(12)
	end
end


--刷新
function OpenPraiseView:refreshCallback( send,etype )
	-- body
	if etype == ccui.TouchEventType.ended then
		if self.refresh and (os.time() - self.refresh < 5)  then
			G_TipsOfstr(string.format(res.str.RICH_RANK_DESC39,(5 - (os.time() - self.refresh) ) ))
			return
		end
		self.refresh = os.time()
		self:stopAllActions()
		proxy.OpenAct:reqRankInfo()
	end
end

--充值
function OpenPraiseView:chargeCallback( send,etype )
	-- body
	if etype == ccui.TouchEventType.ended then
		G_GoReCharge()
	end
end


--昨日排行
function OpenPraiseView:yesterdayRankCallback(send,etype )
	if etype == ccui.TouchEventType.ended then
		proxy.OpenAct:reqYesterdayRank()
	end
end




return OpenPraiseView