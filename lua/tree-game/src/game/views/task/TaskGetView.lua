--[[
	活跃度 箱子领取
]]

local TaskGetView = class("TaskGetView",base.BaseView)

function TaskGetView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local bg = self.view:getChildByName("Image_1")
	local btn_close = bg:getChildByName("Image_2_0")
	btn_close:setTouchEnabled(true)
	btn_close:addTouchEventListener(handler(self,self.onBtnClose))

	self.btnget = bg:getChildByName("Button_2_0_20")
	self.btnget:setTitleText(res.str.MAILVIEW_GET)
	self.btnget:addTouchEventListener(handler(self,self.onBtnGet))

	self.frame = bg:getChildByName("Image_2_0_0")
	self.spr = self.frame:getChildByName("Image_2_1")
	self.spr:ignoreContentAdaptWithSize(true)
	self.lab_name = bg:getChildByName("Text_1")
	self.lab_name:setString("")

	self.dec = bg:getChildByName("Text_1_0")
	self.dec:setString("")
end

function TaskGetView:initDec()
	-- body

end

function TaskGetView:setData(index,isget,hy)
	-- body
	self.tag = index
	self.isget = isget
	self.hy = hy

	local reward = conf.Shop:getValue(14)
	local t = reward.value[self.tag] or reward.value[1]

	local colorlv = conf.Item:getItemQuality(t[1])
	self.frame:loadTexture(res.btn.FRAME[colorlv])
	self.spr:loadTexture(conf.Item:getItemSrcbymid(t[1]))
	self.lab_name:setString(conf.Item:getName(t[1]).."x"..t[2])
	self.lab_name:setColor(COLOR[colorlv])

	local conf_hy = conf.Shop:getValue(15)
	self.dec:setString(string.format(res.str.RES_GG_83,conf_hy.value[self.tag] or conf_hy.value[#conf_hy.value]))

	self.btnget:setTouchEnabled(false)
	self.btnget:setBright(false)
	if self.isget == 1 then
		self.btnget:setTouchEnabled(true)
		self.btnget:setBright(true)
	elseif self.isget == 2 then
		self.btnget:setTitleText(res.str.MAILVIEW_GET_OVER)
	end
end

function TaskGetView:onBtnGet(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		if not self.tag then
			return 
		end
		proxy.task:send_113004({mType = self.tag})
		self:onCloseSelfView()
	end
end

function TaskGetView:onBtnClose( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end
end

function TaskGetView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return TaskGetView


