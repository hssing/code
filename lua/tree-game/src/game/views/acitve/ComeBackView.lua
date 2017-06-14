--
-- Author: Your Name
-- Date: 2015-09-02 17:11:58
--
 --local bit = require("bit")
local ComeBackView = class("ComeBackView", base.BaseView)

function ComeBackView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	local listview = self.view:getChildByName("Panel_1"):getChildByName("ListView_1")
	self.listView = listview:getChildByName("Panel_9"):getChildByName("ListView")
	self.clonePanel = self.view:getChildByName("Panel_clone")
	self.blankPanel = self.view:getChildByName("Panel_2")

	local panel2 = listview:getChildByName("Panel_5")

	self.loadingBar = panel2:getChildByName("zLoadingBar_exp")
	self.Label_exp = panel2:getChildByName("Text_exp") 
	self.Label_exp:enableOutline(cc.c4b(0,0,0,255),1)
	self.chargeZsCount = panel2:getChildByName("Text_24")
	self.returnZsCount = panel2:getChildByName("Text_22")
	self.vipIcon = panel2:getChildByName("Image_35")

	self.btnGetZs = panel2:getChildByName("Button_get")--领取砖石按钮
	self.btnGetZs:addTouchEventListener(handler(self,self.onBtnGetZS))

	local panel3 = listview:getChildByName("Panel_9")
	self.btnGetAward = panel3:getChildByName("Button_get_0")--领取奖励按钮
	self.btnGetAward:addTouchEventListener(handler(self,self.onBtnGetAward))
	--self.btnGetAward:addTouchEventListener(handler(self,self.))

	self.btnLeft = panel3:getChildByName("Button_9") --左滑动按钮
	self.btnRight = panel3:getChildByName("Button_9_0") --左滑动按钮
	self.btnLeft:setEnabled(false)
	self.btnRight:setEnabled(false)
	--左右滑动事件
	self.btnLeft:addTouchEventListener(handler(self,self.adjustScrollViewPos))
	self.btnRight:addTouchEventListener(handler(self,self.adjustScrollViewPos))
	self.btnLeft:setName("left")
	self.btnRight:setName("right")

	self.offsetIdx = 0
	self.data = {}


	self.blankPanel:getChildByName("Text_1"):setString(res.str.ACTIVE_TEXT6)

	local  panel_4 = listview:getChildByName("Panel_4")
	panel_4:getChildByName("Text_7"):setString(res.str.ACTIVE_TEXT7)
	panel_4:getChildByName("Text_8"):setString(res.str.ACTIVE_TEXT8)
	panel_4:getChildByName("Text_9"):setString(res.str.ACTIVE_TEXT9)

	panel_4:getChildByName("Text_7_0"):setString(res.str.ACTIVE_TEXT10)
	panel_4:getChildByName("Text_7_0_0"):setString(res.str.ACTIVE_TEXT11)
	panel_4:getChildByName("Text_7_0_0_0"):setString(res.str.ACTIVE_TEXT12)

	panel2:getChildByName("Text_23"):setString(res.str.ACTIVE_TEXT13)
	panel3:getChildByName("Text_23_0"):setString(res.str.ACTIVE_TEXT14)
	--panel2:getChildByName("Text_23"):setString(res.str.ACTIVE_TEXT13)


	proxy.ComeBack:reqGiftInfo()
	local data = {}
	data.awards = {}

	--self:setData(data)
end

function ComeBackView:setData( data )
	self.data = data
	self:createItems()
	--dump(self.data.vipExp)
end


function ComeBackView:createItems(  )
	--dump(self.data)
	self.chargeZsCount:setString(self.data.czZs)
	self.returnZsCount:setString("X".. self.data.czZs * 1.5)

	--  local curvip = cache.Player:getVip() 
	-- 
	local p = ccui.PageView:create()
	
	 
	-- -- local vipexp = cache.Player:getVipExp()
	local max= #res.icon.VIP_LV
	local curvip = self.data["vipLevel"]
	curvip = curvip == 0 and 1 or curvip
	local dd = curvip >= max and max or curvip+1
	local nextneedexp = conf.Recharge:getNextExp(dd)
	
	if self.data["vipExp"] >= nextneedexp then
		 self.Label_exp:setString(self.data["vipExp"].."/"..self.data["vipExp"])
 		 self.loadingBar:setPercent(100)
	else
		 self.Label_exp:setString(self.data["vipExp"].."/"..nextneedexp)
 		 self.loadingBar:setPercent(self.data["vipExp"]*100/nextneedexp)
	end


	local flag1 = false
	local flag2 = false
	if self.data["gotSign"] == 0 then
		flag1 = true
		flag2 = true
	elseif self.data["gotSign"] == 1 then
		flag1 = true
		flag2 = false
	elseif  self.data["gotSign"] == 2 then
		flag1 = false
		flag2 = true
	elseif self.data["gotSign"] == 3 then
		flag1 = false
		flag2 = false
	end
	
	
	--10
	--1110
	--bit._and(self.data["gotSign"] , bit.lshift(1,1)) == 0
	--设置按钮转态
	if flag1 then
		self.btnGetAward:setEnabled(true)
		self.btnGetAward:setBright(true)
		self.btnGetAward:getChildByName("Text_title_21_2"):setString(res.str.HSUI_DESC1)
	elseif self.data.czZs <= 0  then
		self.btnGetZs:setEnabled(false)
		self.btnGetZs:setBright(false)
		self.btnGetZs:getChildByName("Text_title_21"):setString(res.str.HSUI_DESC1)
	else
		self.btnGetAward:setEnabled(false)
		self.btnGetAward:setBright(false)
		self.btnGetAward:getChildByName("Text_title_21_2"):setString(res.str.HSUI_DESC2)
	end

	--设置按钮转态
	if  flag2 then
		self.btnGetZs:setEnabled(true)
		self.btnGetZs:setBright(true)
		self.btnGetZs:getChildByName("Text_title_21"):setString(res.str.HSUI_DESC1)
	else
		self.btnGetZs:setEnabled(false)
		self.btnGetZs:setBright(false)
		self.btnGetZs:getChildByName("Text_title_21"):setString(res.str.HSUI_DESC2)
	end
	
	--self.loadingBar:setPercent(Percent*100)
	--self.Label_exp:setString(exp.."/"..max_exp)

	 self.vipIcon:loadTexture(res.font.VIP[self.data.vipLevel]) --vipLevel

	local awards = self.data.awards
	local len = table.nums(awards) - 1

	if len <= 0 then
		self.btnGetAward:setEnabled(false)
		self.btnGetAward:setBright(false)
		self.btnGetAward:getChildByName("Text_title_21_2"):setString(res.str.HSUI_DESC1)
		self.listView:pushBackCustomItem(self.blankPanel:clone())
		self.listView:setEnabled(false)
		return
	end
	
	local keys = table.keys(awards)
	for i=1,#keys do
		if keys[i] == "_size" then
			table.remove(keys,i)
		end
	end
	local i = 1

	while len >= 1  do
			local item = self.clonePanel:clone()
			item:setSwallowTouches(false)
			local subItem1 = item:getChildByName("Button_2")
			local subItem2 = item:getChildByName("Button_2_0")

			local icon1 = subItem1:getChildByName("Image_4")
			local text1 = subItem1:getChildByName("Text_3")

			local icon2 = subItem2:getChildByName("Image_4_6")
			local text2 = subItem2:getChildByName("Text_3_6")

			local k1 = tonumber(keys[i])
			subItem1:loadTextureNormal(conf.bigGift:getFrameIcon(k1))
			icon1:loadTexture(conf.bigGift:getIcon(k1))
			text1:setString(conf.bigGift:getName(k1) .. "x" .. awards[keys[i]])
			text1:setColor(conf.bigGift:getTextColor(k1))

			subItem1:addTouchEventListener(handler(self,self.openItem))
			subItem1.mid = k1

			if i < len then

				local k2 = tonumber(keys[i+1])
				subItem2:loadTextureNormal(conf.bigGift:getFrameIcon(k2))
				icon2:loadTexture(conf.bigGift:getIcon(k2))
				text2:setString(conf.bigGift:getName(k2) .. "x" .. awards[keys[i+1]])
				text2:setColor(conf.bigGift:getTextColor(k2))

				subItem2:addTouchEventListener(handler(self,self.openItem))
				subItem2.mid = k2
				i = i + 1 
			else
				if len % 2 ~= 0 then
					subItem2:setVisible(false)
				end
			end
			i = i + 1
			self.listView:pushBackCustomItem(item)
			if i > len then
				break
			end

	end
		
	
	--dump(keys)

end

function ComeBackView:getsign(sign, atype )

	return  math.floor(sign / math.pow(10, atype)) == 0
end




function ComeBackView:onBtnGetZS( send,etype )
	if etype == ccui.TouchEventType.ended then
		--G_TipsOfstr(res.str.COMEBACK_TIPS1)
		proxy.ComeBack:reqGetAward(0)
	end
end

function ComeBackView:onBtnGetAward( send,etype)
	if etype == ccui.TouchEventType.ended then
		--G_TipsOfstr(res.str.COMEBACK_TIPS1)
		proxy.ComeBack:reqGetAward(1)
	end
end

function ComeBackView:getAwardSucc( data )
	--道具

	if  data["gotType"] == 1 then
		self.btnGetAward:setEnabled(false)
		self.btnGetAward:setBright(false)
		self.btnGetAward:getChildByName("Text_title_21_2"):setString(res.str.HSUI_DESC2)
	else
		self.btnGetZs:setEnabled(false)
		self.btnGetZs:setBright(false)
		self.btnGetZs:getChildByName("Text_title_21"):setString(res.str.HSUI_DESC2)
	end
end



-----打开物品

function ComeBackView:openItem( send,eventType  )
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










return ComeBackView