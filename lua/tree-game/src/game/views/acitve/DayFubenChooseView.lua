local DayFubenChooseView = class("DayFubenChooseView",base.BaseView)

function DayFubenChooseView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local panel = self.view:getChildByName("Panel_1")
	self.listview = panel:getChildByName("ListView_1")
	self.item_clone = self.view:getChildByName("Panel_3_0")	

	--G_FitScreen(self,"Image_1")
end

function DayFubenChooseView:setData(data_,data1)
	-- body
	self.data = data_
	self.conf_data = data1
	for k ,v in pairs(self.conf_data.difficulty) do 
		local data = conf.DayFuben:getRewad(v)

		local item = self.item_clone:clone() 
		local imgdec = item:getChildByName("Image_4") 
		imgdec:loadTexture(res.font.DAYFUBEN[k])

		local reward = {} 
		local t = {}
		t.frame = item:getChildByName("Button_9") 
		t.frame:setVisible(false)
		t.spr = t.frame:getChildByName("Image_10_2")
		t.spr:ignoreContentAdaptWithSize(true)
		t.txt = t.frame:getChildByName("Text_1")
		table.insert(reward,t)

		local t = {}
		t.frame = item:getChildByName("Button_9_1") 
		t.frame:setVisible(false)
		t.spr = t.frame:getChildByName("Image_10_2_10")
		t.spr:ignoreContentAdaptWithSize(true)
		t.txt = t.frame:getChildByName("Text_1_5")
		table.insert(reward,t)

		local t = {}
		t.frame = item:getChildByName("Button_9_1_0") 
		t.frame:setVisible(false)
		t.spr = t.frame:getChildByName("Image_10_2_10_2")
		t.spr:ignoreContentAdaptWithSize(true)
		t.txt = t.frame:getChildByName("Text_1_5_3")
		table.insert(reward,t)


		

		for i , j in pairs(data.awards) do 
			if i > 3 then
				break 
			end

			local widget = reward[i]
			local mId = j[1]
			local amount = j[2]

			local colorlv = conf.Item:getItemQuality(mId)
			widget.frame:loadTextureNormal(res.btn.FRAME[colorlv])
			widget.spr:loadTexture(conf.Item:getItemSrcbymid(mId))

			widget.txt:setColor(COLOR[colorlv])
			widget.txt:setScale(1.05)
			widget.txt:setString(conf.Item:getName(mId).."x"..amount)

			widget.frame:setVisible(true)
			widget.frame.mId = mId
			widget.frame:addTouchEventListener(handler(self, self.onOpenItem))
		end

		local btn = item:getChildByName("Button_1")
		btn:setTitleText(res.str.DEC_NEW_26)
		btn.id = v 
		btn:addTouchEventListener(handler(self, self.onChangeCallBack))

		local lab_dec1 = item:getChildByName("Text_1_0_0_0_33_43")
		lab_dec1:setString(res.str.DEC_NEW_29..":")
		local lab_dec2 = item:getChildByName("Text_1_0_0_0_33_43_0")
		lab_dec2:setString(data1.condition[k] or 0)

		if k<=self.data.difficulty then
			btn:setVisible(true)
			lab_dec1:setVisible(false)
			lab_dec2:setVisible(false)
		else
			btn:setVisible(false)
			lab_dec1:setVisible(true)
			lab_dec2:setVisible(true)
		end

		self.listview:pushBackCustomItem(item)
	end
end

function DayFubenChooseView:onOpenItem( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		G_openItem(send.mId)
	end
end

function DayFubenChooseView:onChangeCallBack(send,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--[[if self.data.playCount == self.conf_data.comm_limit then
			G_TipsOfstr(res.str.DEC_NEW_30)
			return 
		end]]--
		proxy.copy:onSFight(102008,{sId = send.id })
	end
end

function DayFubenChooseView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return DayFubenChooseView