--[[
	Active_100_recharge 100元充值活动
]]

local Active_100_recharge = class("Active_100_recharge",base.BaseView)

function Active_100_recharge:ctor()
	-- body
end

function Active_100_recharge:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self:initDec()

	G_FitScreen(self,"Image_1")

	proxy.Active:send_116151({actId = 1018})
end

function Active_100_recharge:initDec()
	-- body
	local top = self.view:getChildByName("Panel_2")
	local lab_1 = top:getChildByName("Text_1")
	local lab_2 = top:getChildByName("Text_1_0")
	local lab_3 = top:getChildByName("Text_1_1")
	local lab_4 = top:getChildByName("Text_1_0_0")
	local lab_5 = top:getChildByName("Text_1_1_0")
	
	top:getChildByName("Text_1_5"):setString(res.str.RES_RES_83)
	lab_1:setString(res.str.RES_RES_78)
	lab_2:setString(res.str.RES_RES_79)
	lab_3:setString(res.str.RES_RES_80)
	lab_4:setString(res.str.RES_RES_81)
	lab_5:setString(res.str.RES_RES_82)
	local img = top:getChildByName("Image_4")

	img:setPositionX(lab_1:getPositionX()+lab_1:getContentSize().width)
	lab_2:setPositionX(img:getPositionX()+img:getContentSize().width*img:getScale())
	lab_3:setPositionX(lab_2:getPositionX()+lab_2:getContentSize().width)
	lab_4:setPositionX(lab_3:getPositionX()+lab_3:getContentSize().width)
	lab_5:setPositionX(lab_4:getPositionX()+lab_4:getContentSize().width)

	self.frame = top:getChildByName("Image_97_0")
	self.spr = self.frame:getChildByName("Image_97_0_0") 
	self.spr:ignoreContentAdaptWithSize(true)

	self.btn = top:getChildByName("Button_1")
	self.btn:setTitleText(res.str.RECHARGE)
	self.btn:addTouchEventListener(handler(self,self.onbtnClooseCallBack))

	local conf_data = conf.active:getItemByid_7x(1018)
	local mId = conf_data.gifts[1][1]
	if checkint(mId) > 0 then
		local colorlv = conf.Item:getItemQuality(mId)
		self.frame:loadTexture(res.btn.FRAME[colorlv])
		self.spr:loadTexture(conf.Item:getItemSrcbymid(mId))
		self.frame.mId = mId
		self.frame:addTouchEventListener(handler(self,self.onBtnSee))
		self.frame:setTouchEnabled(true)
	end
end

function Active_100_recharge:setData(data)
	-- body
	self.data = data

	if data.activeSign > 0 then --已经充值了
		self.btn.tag = 1
		self.btn:setTitleText(res.str.RES_RES_93)

		if data.awardSign > 0 then --领取了
			self.btn:setTouchEnabled(false)
			self.btn:setBright(false)
			
			self.btn:setTitleText(res.str.MAILVIEW_GET_OVER)
		else
			self.btn:setTouchEnabled(true)
			self.btn:setBright(true)
		end
	else
		self.btn.tag = 2
		self.btn:setTitleText(res.str.RECHARGE)
	end
end

function Active_100_recharge:update(data)
	-- body
	local view=mgr.ViewMgr:get(_viewname.PACKGETITEM)
	view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
	view:setData(data.items,true,true)
	view:setButtonVisible(false)

	self.data.awardSign =  data.awardSign
	if self.data.awardSign > 0 then --领取了
		self.btn:setTouchEnabled(false)
		self.btn:setBright(false)
	else
		self.btn:setTouchEnabled(true)
		self.btn:setBright(true)
	end
end

function Active_100_recharge:onBtnSee(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		G_openItem(sender_.mId)
	end
end

function Active_100_recharge:onbtnClooseCallBack(send_,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		if self.btn.tag == 2 then 
			G_GoReCharge(1000)
		else
			proxy.Active:send_116152({actId = 1018})
		end
	end
end

return Active_100_recharge
