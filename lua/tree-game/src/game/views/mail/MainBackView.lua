--[[
	-查看  后台邮件
]]

local MainBackView = class("MainBackView", base.BaseView)

local str = ""
--[[str = str .."接电话交电话费交电话费的交话费交话费接电话交电话费计划地方回到家发货接电"
str = str .."话反加好地方就好的肌肤回到家发货的交话费电话费"
str = str .."接电话交电话费交电话费的交话费交话费接电话交电话费计划地方回到家发货接电"
str = str .."话反加好地方就好的肌肤回到家发货的交话费电话费"
str = str .."接电话交电话费交电话费的交话费交话费接电话交电话费计划地方回到家发货接电"
str = str .."话反加好地方就好的肌肤回到家发货的交话费电话费"
str = str .."接电话交电话费交电话费的交话费交话费接电话交电话费计划地方回到家发货接电"
str = str .."话反加好地方就好的肌肤回到家发货的交话费电话费"
str = str .."接电话交电话费交电话费的交话费交话费接电话交电话费计划地方回到家发货接电"
str = str .."话反加好地方就好的肌肤回到家发货的交话费电话费"]]--


function MainBackView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local bg = self.view:getChildByName("Panel_1"):getChildByName("Image_1")

	self.lab_begin =  bg:getChildByName("Text_1_0")
	self.lab_begin:setVisible(false)

	self.lab_title = bg:getChildByName("Text_1")
	self.scroll = bg:getChildByName("ScrollView_1")

	self.rewardtab = {}
	local t = {}
	t.frame = bg:getChildByName("Button_frame")
	t.spr = t.frame:getChildByName("Image_head_23")
	t.name = bg:getChildByName("Text_name")
	table.insert(self.rewardtab,t)

	local t = {}
	t.frame = bg:getChildByName("Button_frame_0")
	t.spr = t.frame:getChildByName("Image_head_23_25")
	t.name = bg:getChildByName("Text_name_0")
	table.insert(self.rewardtab,t)

	local t = {}
	t.frame = bg:getChildByName("Button_frame_1")
	t.spr = t.frame:getChildByName("Image_head_23_27")
	t.name = bg:getChildByName("Text_name_1")
	table.insert(self.rewardtab,t)

	local btn = bg:getChildByName("Button_close_0")
	btn:addTouchEventListener(handler(self, self.closeview))

	self.lab_dec2 = bg:getChildByName("Text_1_0_0")
	self.lab_dec2:setString(res.str.MAIL_DEC_04)


	btn:getChildByName("Text_1_0_19_5"):setString(res.str.MAIL_DEC_05)
end

function MainBackView:onOpenItem( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		G_openItem(send:getTag())
	end
	-- body
end

function MainBackView:setData(data)
	-- body
	self.data = data 
	for k ,v in pairs(self.rewardtab) do 
		v.frame:setVisible(false)
		v.spr:setVisible(false)
		v.name:setVisible(false)
	end 

	self.lab_title:setString(data.titleStr)

	-- 左对齐，并且多行文字顶部对齐
	local label = display.newTTFLabel({
	    text = data.contentStr..str,
	    font = res.ttf[1],
	    size = 20,
	    color = COLOR[1], 
	    align = cc.TEXT_ALIGNMENT_LEFT,
	    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
	    dimensions = cc.size(self.scroll:getContentSize().width*0.9, 0),
	})
	label:setAnchorPoint(cc.p(0,1))
	label:addTo(self.scroll)

	local ccsize = label:getContentSize()
	if ccsize.height > self.scroll:getInnerContainerSize().height then 
		self.scroll:setInnerContainerSize(ccsize)
		label:setPosition(20, self.scroll:getInnerContainerSize().height) 
	else
		label:setPosition(20, self.scroll:getInnerContainerSize().height)
	end
	self.scroll:jumpToTop()
	
	
	self.lab_dec2:setVisible(false)
	for k ,v in pairs(data.items) do 
		self.lab_dec2:setVisible(true)
		local colorlv = conf.Item:getItemQuality(v.mId)
		local icon = conf.Item:getItemSrcbymid(v.mId)
		local name = conf.Item:getName(v.mId)

		local widget = self.rewardtab[k]
		widget.frame:loadTextureNormal(res.btn.FRAME[colorlv])
		widget.spr:loadTexture(icon)
		widget.name:setString(name.."x"..v.amount)
		widget.name:setColor(COLOR[colorlv])

		widget.frame:setVisible(true)
		widget.spr:setVisible(true)
		widget.name:setVisible(true)

		widget.frame:setTouchEnabled(true)
		widget.frame:setTag(v.mId)
		widget.frame:addTouchEventListener(handler(self, self.onOpenItem))
	end 
end

function MainBackView:closeview( sender_,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end 
end

function MainBackView:onCloseSelfView()
	-- body

	--[[if #self.data.items > 0 then 
		local view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		view:setData(self.data.items,false,true)
		view:setButtonVisible(false)
	end ]]--

	self:closeSelfView()
end

return MainBackView