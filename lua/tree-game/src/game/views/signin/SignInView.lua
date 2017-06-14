--
-- Author: Your Name
-- Date: 2015-07-13 19:40:58
--

local  SignInView  = class("SignInView", base.BaseView)

local vipPath = "res/views/ui_res/icon/V"

function SignInView:init()
	-- body
    self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	G_FitScreen(self,"Image_3")
	self.timer = self:schedule(self.updateTime, 1)
	self.curOrgItem = self.view:getChildByName("Item_Panel_1")
	self.listView = self.view:getChildByName("ListView")
	local otherDayOrgItem = self.view:getChildByName("Item_Panel_2")

	self.curOrgItem:getChildByName("text_login_get"):setString(res.str.SIGNIN_TEXT1) 
	self.curOrgItem:getChildByName("text_curr"):setString(res.str.SIGNIN_TEXT2) 
	self.curOrgItem:getChildByName("btn_login_get"):setTitleText(res.str.HSUI_DESC1)

	otherDayOrgItem:getChildByName("text_date"):setString(res.str.HSUI_DESC30)
	otherDayOrgItem:getChildByName("text_login_get2"):setString(res.str.SIGNIN_TEXT1)



	proxy.signIn:setTarget(self)
	--proxy.signIn:reqSignInfo()
	
end

function SignInView:updateTime( ... )
	-- body
	local h = tonumber(os.date("%H"))
	local m = tonumber(os.date("%M"))
	local s = tonumber(os.date("%S"))

	if h == 0 and m == 0 and s == 0 then
		proxy.signIn:reqSignInfo()
		self:stopAction(self.timer)
	end

end


function SignInView:onCloseSelfView(  )
	--mgr.ViewMgr:hideView("signin.SignInView")
	self:closeSelfView()
	G_mainView()
end


function SignInView:onOpenItem( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		--mgr.ViewMgr:showView(_viewname.PRO_TIPS):setData(self.data)
		--G_openItem(self.data.mId)
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
	-- body


end

--点击领取奖励
function SignInView:getReWard(sender,eventType )
	-- body
	if eventType == ccui.TouchEventType.ended then
		if self.awardState == 1 then

			local data = {}
			data.day = conf.qiandao:getDate()
			proxy.signIn:reqAwardItems(data)
		end

	end
	
end

-- 成功领取奖励
function SignInView:getAwardSucc( data )
	-- body
	if data.status ~= 0 then
		return
	end

	if #data.items == 0 then
		proxy.signIn:reqSignInfo()
		return
	end

	if self.awardState == 1 then
		--todo
		self:changeUI()
		local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
		if not view then
			view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
			view:setData(data.items,true,true)
			view:setButtonVisible(false)
			view:setSureBtnTile(res.str.HSUI_DESC1)

		end
		--mgr.ViewMgr:showView("signin.AwardAlertView"):setData(data)

	end

	self.awardState = 2
	
end

function SignInView:changeUI(  )
	-- body
	self.btnAlreaddyGot:setVisible(true)
	self.textGet:removeFromParent()
	self.textCurr:removeFromParent()
	self.btnGet:removeFromParent()
end

--当从网络获取到数据时，更新显示数据
function SignInView:dataChanged( data )
	-- body

	 self.awardState = data["awardState"]
	 self.status = data["status"]
	 self.currDay = data["currDay"]
	print("currDay=",self.currDay)

	 --conf.qiandao:setDate(self.currDay)
	--self.currDay = 28

	--登陆领取 listView
	
	self.listView:removeAllItems()

	--当天的奖励数据信息
	local rewardCount = conf.qiandao:getReWardKindsByDayOffset(0)
	local reward = conf.qiandao:getRewardInfoAtIndex(0,1)
	--添加今日登陆领取
	local curItem =self.curOrgItem:clone();
	--listView:addChild(curItem)
	self.listView:pushBackCustomItem(curItem)
	curItem:setTag(100)
	local vip2 = curItem:getChildByName("imgV2")
	vip2:setLocalZOrder(1000)
	local path = vipPath .. (conf.qiandao:getVip2(0))
	path = path .. ".png"
	vip2:loadTexture(path)

	local goodsItem  = self.view:getChildByName("item")

	--循环设置每个奖励的信息
	local x = 0
	for i=1,rewardCount do

		local item = goodsItem:clone()
		curItem:addChild(item)
		item:setTag(100+i)
		item:setPosition(cc.p(10+x*item:getContentSize().width ,15))

		if i > 1 then
			item:setPosition(cc.p(item:getPositionX()+30*x,item:getPositionY()))
		end
		
		local reward = conf.qiandao:getRewardInfoAtIndex(0, i)
		local gIcon =  conf.qiandao:getIcon(reward[1])
		local fIcon =  conf.qiandao:getFrameIcon(reward[1])
		local gName =  conf.qiandao:getName(reward[1])
		local color =  conf.qiandao:getTextColor(reward[1])

		local gIconView = item:getChildByName("img_goods_1")
		local fIconView = item:getChildByName("btn_goods_1")
		local gTextView = item:getChildByName("text_goods_1")

		gIconView:loadTexture(gIcon)
		fIconView:loadTextureNormal(fIcon)
		gTextView:setString(gName.."x".. reward[2])
		gTextView:setColor(color)

		fIconView:addTouchEventListener(handler(self,self.onOpenItem))
		--fIconView:setTag(reward[1])
		fIconView.mid = reward[1]

		x = x + 1

	end

	--领取按钮
	self.btnGet = curItem:getChildByName("btn_login_get");
	self.textCurr = curItem:getChildByName("text_curr");
	self.textGet = curItem:getChildByName("text_login_get");

	self.btnGet:addTouchEventListener(handler(self,self.getReWard))

	--已领取按钮
	self.btnAlreaddyGot = curItem:getChildByName("btn_alreadyGot"):setVisible(false)



	local otherDayOrgItem = self.view:getChildByName("Item_Panel_2")
	
	--其他天的登陆领取
	for i=1,6 do
		local otherDayItem = otherDayOrgItem:clone()
		local otherDayRewardsConut = conf.qiandao:getReWardKindsByDayOffset(i)
		local y = 1
		for j=1,otherDayRewardsConut do
			local item = goodsItem:clone()
			otherDayItem:addChild(item)
			item:setTag(100+j)
			item:setPosition(cc.p(20+y*item:getContentSize().width + y*30,15))
			local reward = conf.qiandao:getRewardInfoAtIndex(i, j)
			local gIcon =  conf.qiandao:getIcon(reward[1])
			local fIcon =  conf.qiandao:getFrameIcon(reward[1])
			local gName =  conf.qiandao:getName(reward[1])
			local color =  conf.qiandao:getTextColor(reward[1])

			local gIconView = item:getChildByName("img_goods_1")
			local fIconView = item:getChildByName("btn_goods_1")
			local gTextView = item:getChildByName("text_goods_1")

			gIconView:loadTexture(gIcon)
			fIconView:loadTextureNormal(fIcon)
			gTextView:setString(gName.."x".. reward[2])
			gTextView:setColor(color)

			fIconView:addTouchEventListener(handler(self,self.onOpenItem))
			--fIconView:setTag(reward[1])
			fIconView.mid = reward[1]
			y = y + 1

		end

		--设置日期
		if i == 1 then
			otherDayItem:getChildByName("text_date"):setString(res.str.HSUI_DESC30)
		elseif i == 2 then
				--todo
			otherDayItem:getChildByName("text_date"):setString(res.str.HSUI_DESC31)
		else
			otherDayItem:getChildByName("text_date"):setString(i .. res.str.HSUI_DESC32)
		end
		self.listView:pushBackCustomItem(otherDayItem)
		--listView:addChild(otherDayItem)
		otherDayItem:setTag((i+1)*100)
		otherDayItem:getChildByName("imgV2_2"):setLocalZOrder(1000)
		local vip2 = otherDayItem:getChildByName("imgV2_2")
		vip2:setLocalZOrder(1000)
		local path = vipPath .. (conf.qiandao:getVip2(i))
		path = path .. ".png"
		vip2:loadTexture(path)
	end

	if self.awardState == 2 then
		--todo
		self:changeUI()
	end
	
	
end


return SignInView