--
-- Author: chenlu_y
-- Date: 2015-12-14 16:08:17
-- 吞噬奖励

local DevourRewardView=class("DevourRewardView",base.BaseView)

function DevourRewardView:init()
	self.itemList = {}
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.panel1 = self.view:getChildByName("Panel")
	self.titleImg = self.panel1:getChildByName("bg_title1"):getChildByName("font")

	self.quedBtn = self.panel1:getChildByName("Button_close")
	self.quedBtn:addTouchEventListener(handler(self,self.onGetClick))

	self.btnstr = self.quedBtn:getChildByName("Text_1_0_6")
	self.btnstr:setString(res.str.MAILVIEW_GET)

	self.cloneItemPanel = self.view:getChildByName("Panel_c")

	self.text_card = self.panel1:getChildByName("Text_1")
	self.text_card:setString("")

	self.text_card1 = self.panel1:getChildByName("Text_1_0")
	self.text_card1:setString("")

end

function DevourRewardView:onGetClick(sender,eventType)
	if eventType ==  ccui.TouchEventType.ended then
		--领取奖励
		if  self.starIndex then
			proxy.ScienceCore:send_127005({starIndex = self.starIndex})
			self:onCloseSelfView()
		else
			if self.tag > 4 then
				return
			elseif self.tag < 4 and self.newIndex > 1 then
				G_TipsOfstr(res.str.RES_GG_25)
				return 
			elseif self.newIndex == 1 and self.tag < 1 then
				G_TipsOfstr(res.str.RES_GG_25)
				return 
			end


			local data = {}
			data.richtext = res.str.RES_GG_28
			data.sure = function( ... )
				-- body
				proxy.ScienceCore:send_127003({mid = self.data.mId}) 
				self:onCloseSelfView()
			end

			data.cancel = function( ... )
				-- body
			end
			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
		end
	end
end

function DevourRewardView:setReward(data_)
	-- body
	for k,vv in pairs(self.itemList) do
		vv:setVisible(false)
	end
	local itemInfoLen = #data_
	for i,v in ipairs(data_) do
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
			self.panel1:addChild(itemPanel)
			itemPanel:setPositionY(300)
			self.itemList[i] = itemPanel
		end
		itemPanel:setVisible(true)
		itemPanel:getChildByName("Button_frame"):loadTextureNormal(iconPath)
		itemPanel:getChildByName("Image_head"):loadTexture(iconImgSrc)
		itemPanel:getChildByName("Text_name"):setString(iconName .. "x" .. itemNum)
		itemPanel:getChildByName("Text_name"):setColor(textColor)

		itemPanel:setPositionX(display.width/(itemInfoLen+1)*i)

	end
end

function DevourRewardView:setData(showIndex,state,data_)
	self.starIndex = showIndex
	self.titleImg:setTexture(res.kjhx.LISTITEM4[showIndex])
	self.quedBtn:setEnabled(false)
	self.quedBtn:setBright(false)
	if state == 0 then
		self.btnstr:setString(res.str.MAILVIEW_GET)
	elseif state == 1 then
		self.quedBtn:setEnabled(true)
		self.quedBtn:setBright(true)
		self.btnstr:setString(res.str.MAILVIEW_GET)
	else
		self.btnstr:setString(res.str.MAILVIEW_GET_OVER)
	end
	self.text_card1:setString(res.str.RES_GG_82)
	self:setReward(data_)
end	

function DevourRewardView:setData1(data,p_data,index,tag)
	-- body
	self.data = data

	self:setReward(p_data)
	self.mId = mId
	self.starIndex  = nil 

	self.tag = tag
	self.newIndex = index
	self.titleImg:setTexture(res.kjhx.LISTITEM4[index])

	local str = string.format(res.str.RES_GG_24,conf.Item:getName(self.data.mId,self.data.propertys))
	self.text_card:setString(str)
	self.text_card:setColor(COLOR[conf.Item:getItemQuality(self.data.mId)])

	self.text_card1:setString(res.str.RES_GG_29)
	self.btnstr:setString(res.str.RES_GG_30)

	if tag > 4 then
		self.quedBtn:setTouchEnabled(false)
		self.quedBtn:setBright(false)

		self.btnstr:setString(res.str.MAILVIEW_GET_OVER)
	end

end

function DevourRewardView:onCloseSelfView( ... )
	-- body
	self:closeSelfView()
end

return DevourRewardView
