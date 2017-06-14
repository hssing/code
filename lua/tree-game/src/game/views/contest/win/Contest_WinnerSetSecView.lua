--[[

]]

local Contest_WinnerSetSecView = class("Contest_WinnerSetSecView", base.BaseView)

function Contest_WinnerSetSecView:init()
	-- body
	self.ShowAll = true
	self.ShowBottom = true
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local panle = self.view:getChildByName("Panel_2")
	self.panle = panle

	local btn = panle:getChildByName("Button_close")
	btn:addTouchEventListener(handler(self, self.closeview))

	self.bg_img = panle:getChildByName("Image_2")
	self.btn_cancel =  panle:getChildByName("Button_close_0")
	self.btn_cancel:addTouchEventListener(handler(self, self.closeview))
	self.btn_sure = panle:getChildByName("Button_2")
	self.btn_sure:addTouchEventListener(handler(self, self.onbtnSure))

	self.lab_1 = panle:getChildByName("Text_7_1")
	self.lab_dec = panle:getChildByName("Text_7_2")


	self.dec1 = panle:getChildByName("Text_7_0_1")
	self._img_dec = panle:getChildByName("Image_16_0_2_0_1")
	self.dec2 = panle:getChildByName("Text_7_1_0")


	--界面文本
	panle:getChildByName("Text_7"):setString(res.str.CONTEST_TEXT23)
	panle:getChildByName("Text_7_2"):setString(res.str.CONTEST_TEXT24)
	panle:getChildByName("Text_7_0_1"):setString(res.str.CONTEST_TEXT25)
	panle:getChildByName("Text_7_0"):setString(res.str.CONTEST_TEXT26)
	panle:getChildByName("Text_7_0_0"):setString(res.str.CONTEST_TEXT26)
	self.btn_cancel:getChildByName("Text_1_0_19_29"):setString(res.str.CONTEST_TEXT28)
	self.btn_sure:getChildByName("Text_1_17_27"):setString(res.str.CONTEST_TEXT27)

end	

function Contest_WinnerSetSecView:onOpenItem( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		--[[local data = { mId =  send:getTag(),propertys = {}}
		local itemtype = conf.Item:getType(data.mId)
		if itemtype ==  pack_type.PRO then
			G_openItem(send:getTag())
		elseif  itemtype  == pack_type.EQUIPMENT then 
			G_OpenEquip(data,true)
		else	
			G_OpenCard(data,true)
		end]]--
	end
	-- body
end

function Contest_WinnerSetSecView:initReardByIndex(index)
	-- body
	self.dec2:setString(self.conf_data[index].zan_jb)

	local lab1 = self.panle:getChildByName("Text_7_0")
	local lab2 = self.panle:getChildByName("Text_7_0_0")
	local img2 = self.panle:getChildByName("Image_16_0_2_0_0")

	--local img_list = {}
	local panle1 = self.panle:getChildByName("Panel_3_1")
	panle1:setVisible(false)
	panle1.frame = panle1:getChildByName("Button_1")  
	panle1.spr = panle1.frame:getChildByName("Image_16_0_0_0")
	panle1.txt = panle1:getChildByName("Text_4")  

	local panle2 = self.panle:getChildByName("Panel_3_1_0")
	panle2:setVisible(false)
	panle2.frame = panle2:getChildByName("Button_1_3")
	panle2.spr = panle2.frame:getChildByName("Image_16_0_0_0_6")
	panle2.txt = panle2:getChildByName("Text_4_6")  

	local panle3 = self.panle:getChildByName("Panel_3_1_1")
	panle3:setVisible(false)
	panle3.frame = panle3:getChildByName("Button_1_5")
	panle3.spr = panle3.frame:getChildByName("Image_16_0_0_0_9")
	panle3.txt = panle3:getChildByName("Text_4_10")  

	local panle4 = self.panle:getChildByName("Panel_3_1_0_0")
	panle4:setVisible(false)
	panle4.frame = panle4:getChildByName("Button_1_3_7")
	panle4.spr = panle4.frame:getChildByName("Image_16_0_0_0_6_11")
	panle4.txt = panle4:getChildByName("Text_4_6_12")

	local panle5 = self.panle:getChildByName("Panel_3_1_4")
	panle5:setVisible(false)
	panle5.frame = panle5:getChildByName("Button_1_3_4")
	panle5.spr = panle5.frame:getChildByName("Image_16_0_0_0_6_2")
	panle5.txt = panle5:getChildByName("Text_4_6_2")

	local panle6 = self.panle:getChildByName("Panel_3_1_3")
	panle6:setVisible(false)
	panle6.frame = panle6:getChildByName("Button_1_3_7_6")
	panle6.spr = panle6.frame:getChildByName("Image_16_0_0_0_6_11_5")
	panle6.txt = panle6:getChildByName("Text_4_6_12_4")



	local function initPanle(widget,data)
		-- body
		if not data then 
			return 
		end 
		widget:setVisible(true)
		local colorlv = conf.Item:getItemQuality(data[1]) 
		widget.frame:loadTextureNormal(res.btn.FRAME[colorlv])
		widget.spr:loadTexture(conf.Item:getItemSrcbymid(data[1]))
		widget.txt:setString(conf.Item:getName(data[1]).."x"..data[2])
		widget.txt:setColor(COLOR[colorlv])

		widget.frame:setTouchEnabled(true)
		widget.frame:setTag(data[1])
		widget.frame:addTouchEventListener(handler(self, self.onOpenItem))
	end


	if index == 3 then 
		--调整大小
		local offy = 150
		self.bg_img:setContentSize(cc.size(self.bg_img:getContentSize().width,
			self.bg_img:getContentSize().height - offy))
		self.btn_cancel:setPositionY(self.btn_cancel:getPositionY()+offy)
		self.btn_sure:setPositionY(self.btn_sure:getPositionY()+offy)

		lab2:setVisible(false)
		img2:setVisible(false)

		panle3:setVisible(false)
		panle4:setVisible(false)

		local data = self.conf_data[3]
		initPanle(panle1,data.reward[1])
		initPanle(panle2,data.reward[2])
		initPanle(panle5,data.reward[3])

		lab1:setString(string.format(res.str.CONTEST_DEC36,data.cost))
	else
		local data = self.conf_data[2]
		initPanle(panle1,data.reward[1])
		initPanle(panle2,data.reward[2])
		initPanle(panle5,data.reward[3])

		lab1:setString(string.format(res.str.CONTEST_DEC36,data.cost))

		local data1 = self.conf_data[3]
		initPanle(panle3,data1.reward[1])
		initPanle(panle4,data1.reward[2])
		initPanle(panle6,data1.reward[3])

		lab2:setString(string.format(res.str.CONTEST_DEC36,data1.cost))
	end 

end

function Contest_WinnerSetSecView:setData(index,setday)
	-- body
	self.index = index
	self.setday = setday
	self.conf_data = {}
	for i = 1 , 3 do  
		table.insert(self.conf_data,conf.Contest:getItemByIndex(i))
	end 

	self:initReardByIndex(index)
	self.lab_1:setString(self.conf_data[index].cost)
	self.lab_dec:setPositionX(self.lab_1:getPositionX()+self.lab_1:getContentSize().width + 5)


end


function Contest_WinnerSetSecView:onbtnSure( send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		debugprint("确定点击")
		local data = self.conf_data[self.index]
		if cache.Contest:getIsWinner() ~= 1  then 
			G_TipsOfstr(res.str.CONTEST_DEC38)
			return 
		elseif  cache.Fortune:getFortuneInfo().moneyZs <  data.cost then 
			G_TipsForNoEnough(2)
			return 
		end 
		local data = {zanType = self.index ,day = self.setday }
		proxy.Contest:sendToset(data)
		mgr.NetMgr:wait(519103)
		--self:onCloseSelfView()
	end 
end

function Contest_WinnerSetSecView:closeview(send, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end

function Contest_WinnerSetSecView:onCloseSelfView()
	self:closeSelfView()
end

return Contest_WinnerSetSecView