--
-- Author: chenlu_y
-- Date: 2015-12-08 16:57:20
-- VIP商店
--
local ActiveVipShopView=class("ActiveVipShopView",base.BaseView)

function ActiveVipShopView:init()
	
	proxy.ActVipShop:sendMessage()

	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	
	self:initPanel1()
	self:initPanel2()
	self:initPanel3()
end

function ActiveVipShopView:initPanel1()
	local panel1 = self.view:getChildByName("Panel_1")
	local Panel38 = panel1:getChildByName("Panel_38") 

	local czBtn = panel1:getChildByName("Button_4") --充值按钮
	czBtn:addTouchEventListener(handler(self, self.onChongzhi))

	local vipLvTxt = panel1:getChildByName("Text_7_11") --当前VIP等级
	local nextCzTxt = Panel38:getChildByName("Text_3") --在充值
	local nextVipLvTxt = Panel38:getChildByName("Text_3_0") --下一级VIP等级
	local dic1 = Panel38:getChildByName("Text_5_6_0")
	local dic2 = Panel38:getChildByName("Text_5_6_1")

	local currVipLv = cache.Player:getVip()
	local nextVipLv = currVipLv+1
	local vipexp = cache.Player:getVipExp()
	local nextneedexp = conf.Recharge:getNextExp(nextVipLv)
	vipLvTxt:setString(currVipLv.."")
	if nextneedexp then
		Panel38:setVisible(true)
		nextCzTxt:setString((nextneedexp-vipexp).."")
		nextVipLvTxt:setString("VIP"..nextVipLv)
	else
		Panel38:setVisible(false)
	end
	
	dic1:setString(res.str.ACTIVE_TEXT48)
	dic2:setString(res.str.ACTIVE_TEXT49)
	panel1:getChildByName("Text_6_8"):setString(res.str.ACTIVE_TEXT46)
	Panel38:getChildByName("Text_5_6"):setString(res.str.ACTIVE_TEXT47)
	

	local px1 = nextCzTxt:getPositionX()
	local w1 = nextCzTxt:getContentSize().width+5
	dic1:setPositionX(w1+px1)

	px1 = dic1:getPositionX()
	w1 = dic1:getContentSize().width+5
	nextVipLvTxt:setPositionX(w1+px1)

	px1 = nextVipLvTxt:getPositionX()
	w1 = nextVipLvTxt:getContentSize().width+5
	dic2:setPositionX(w1+px1)

end

function ActiveVipShopView:initPanel2()
	self.cloneItemPanel = self.view:getChildByName("item_0") --物品

	local panel2 = self.view:getChildByName("Panel_2")
	self.itemY = panel2:getPositionY()+165

	self.buyBtn = panel2:getChildByName("Button_get") --购买按钮
	self.buyBtn:setTitleText(res.str.SHOP_DEC_01)
	self.buyBtn:addTouchEventListener(handler(self, self.onGoumai))
	
	self.buyLimitTxt = panel2:getChildByName("Text_14") --时间
	self.timeTxt = panel2:getChildByName("Text_14_1") --时间

	local image18 = panel2:getChildByName("Image_18")
	self.yuanjTxt = image18:getChildByName("Text_zs") --原价文本
	local image180 = panel2:getChildByName("Image_18_0")
	self.xianjTxt = image180:getChildByName("Text_zs_13") --现价文本

	self.buyNumTxt = panel2:getChildByName("Text_32")
	self.buyNumTxt:setString("1")
	panel2:getChildByName("Text_33"):setString("/1")
	--panel2:getChildByName("Text_14"):setString(res.str.ACTIVE_TEXT50)
	panel2:getChildByName("Text_14_0"):setString(res.str.ACTIVE_TEXT51)
	panel2:getChildByName("Text_31"):setString(res.str.ACTIVE_TEXT52)
	image18:getChildByName("Text_9"):setString(res.str.SHOP_DEC_05)
	image180:getChildByName("Text_9_11"):setString(res.str.SHOP_DEC_06)

end

function ActiveVipShopView:initPanel3()
	local panel3 = self.view:getChildByName("Panel_3")
	self.listView= panel3:getChildByName("ListView_1_2")
	self.clonepanel = self.view:getChildByName("item")
	self.listView:setItemsMargin(15)
end

function ActiveVipShopView:initListView()
	if self.vipItemList == nil then
		self.vipItemList = {}
		local currVipLv = cache.Player:getVip()
		local maxVipLv = conf.Recharge:getVipcount()
		for i=1,maxVipLv do
			local widget = self.clonepanel:clone()
			widget:setSwallowTouches(false)
			--widget:setPressedActionEnabled(false)
			local btnTxt = widget:getChildByName("AtlasLabel_1")
			btnTxt:setString(i)
			widget.vipLv = i
			if i == currVipLv then
				widget:getChildByName("Image_1"):setVisible(true)
			else
				widget:getChildByName("Image_1"):setVisible(false)
			end
			widget:setTouchEnabled(true)
			widget:addTouchEventListener(handler(self,self.onChangeItem))
			self.listView:pushBackCustomItem(widget)
			self.vipItemList[i] = widget
		end

		
		if currVipLv > 3 or currVipLv < maxVipLv-3 then
			self.listView:refreshView ()
			local newLv = currVipLv-1
			local rat = (newLv/maxVipLv)*100
			self.listView:scrollToPercentHorizontal(rat, 0.1, false)
		end

	end
end 

--充值
function ActiveVipShopView:onChongzhi( sender,eventype)
	if eventype == ccui.TouchEventType.ended then
		G_GoReCharge()
	end
end

--购买
function ActiveVipShopView:onGoumai( sender,eventype)
	if eventype == ccui.TouchEventType.ended then
		proxy.ActVipShop:sendBuyMessage()
	end
end

--根据VIP改变显示
function ActiveVipShopView:onChangeItem( sender,eventype )
	if eventype == ccui.TouchEventType.ended then
		for k,v in pairs(self.vipItemList) do
			v:getChildByName("Image_1"):setVisible(false)
		end
		sender:getChildByName("Image_1"):setVisible(true)
		local newLv = sender.vipLv
		self:setItemInfo(newLv)
		if newLv == cache.Player:getVip() then
			self:setBuyState(self.buySign)
		else
			self.buyBtn:setVisible(false)
		end
	end
end

function ActiveVipShopView:setData(data)
	self.buyDay = data.vipDay
	self.timeValue = data.todayLeftTime
	self:setBuyState(data.buySign)
	
	if self.timeValue > 0 then
		self.timeTxt:setString(G_getTimeStr(self.timeValue))
		self.timeSchedual = self:schedule(self.timeTick, 1)
	end
	
	self:setItemInfo()
	self:initListView()
	
end

--设置购买状态
function ActiveVipShopView:setBuyState(buySign)
	self.buySign = buySign
	self.buyBtn:setVisible(true)
	if buySign > 0 then
		self.buyNumTxt:setString("0")
		self.buyBtn:setEnabled(false)
		self.buyBtn:setBright(false)
		self.buyBtn:setTitleText(res.str.JUST_BUY)
	else
		self.buyNumTxt:setString("1")
		self.buyBtn:setEnabled(true)
		self.buyBtn:setBright(true)
		self.buyBtn:setTitleText(res.str.SHOP_DEC_01)
	end
end

---设置物品信息
function ActiveVipShopView:setItemInfo(vipLv)
	local currVipLv = vipLv or cache.Player:getVip()
	self.buyLimitTxt:setString(string.format(res.str.ACTIVE_TEXT50, currVipLv)) 
	local itemInfo = conf.VipShop:getInfo(currVipLv , self.buyDay)
	if itemInfo then
		self.yuanjTxt:setString(itemInfo.old_price)
		self.xianjTxt:setString(itemInfo.price)

		self.itemList = self.itemList or {}
		for k,vv in pairs(self.itemList) do
			vv:setVisible(false)
		end
		local itemInfoLen = #itemInfo.goodsConf
		for i,v in ipairs(itemInfo.goodsConf) do
			local itemCid = v[1]
			local itemNum = v[2]
			local color = conf.Item:getItemQuality(itemCid)
			local iconPath = res.btn["FRAME"][color]
			local iconImgSrc = conf.Item:getItemSrcbymid(itemCid)	
			local iconName = conf.Item:getName(itemCid)
			local textColor = COLOR[conf.Item:getItemQuality(itemCid)]

			local itemPanel = self.itemList[i]
			if itemPanel == nil then
				itemPanel = self.cloneItemPanel:clone()
				self.view:addChild(itemPanel)
				itemPanel:setPositionY(self.itemY)
				self.itemList[i] = itemPanel
			end
			itemPanel:setVisible(true)
			itemPanel:getChildByName("btn_goods_3"):loadTextureNormal(iconPath)
			itemPanel:getChildByName("img_goods_17"):loadTexture(iconImgSrc)
			itemPanel:getChildByName("text_goods_8"):setString(iconName .. "x" .. itemNum)
			itemPanel:getChildByName("text_goods_8"):setColor(textColor)

			itemPanel:setPositionX(display.width/(itemInfoLen+1)*i)

		end
	end
end

function ActiveVipShopView:timeTick( )
	self.timeValue = self.timeValue - 1
	self.timeTxt:setString(G_getTimeStr(self.timeValue))
	if self.timeValue <= 0 then
		self:stopAction(self.timeSchedual)
		proxy.ActVipShop:sendMessage()
	end
end


return ActiveVipShopView