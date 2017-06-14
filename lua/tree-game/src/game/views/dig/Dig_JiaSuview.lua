
--[[
	Dig_JiaSuview --加速确认
]]

local Dig_JiaSuview = class("Dig_JiaSuview",base.BaseView)


function Dig_JiaSuview:init()
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local bg = self.view:getChildByName("Panel_1"):getChildByName("Image_1")
	self.bg = bg

	self.btn_sure = bg:getChildByName("Button_2_0_20")
	self.btn_sure:addTouchEventListener(handler(self, self.onBtnSureCallBack))

	local btncancel = bg:getChildByName("Button_Using")
	btncancel:addTouchEventListener(handler(self, self.closeView))

	self.rewardframe = bg:getChildByName("Button_frame")
	self.spr = self.rewardframe:getChildByName("Image_22_4")
	self.lab_name = bg:getChildByName("Text_1_0_1")

	self.lab_dec = bg:getChildByName("Text_1_0")


	--界面文本
	btncancel:setTitleText(res.str.DIG_DEC34)
	self.btn_sure:setTitleText(res.str.DIG_DEC35)

	self.bg:getChildByName("Text_1"):setString(res.str.DIG_DEC36)
	self.bg:getChildByName("Text_1_0"):setString(res.str.DIG_DEC36)
	self.bg:getChildByName("Text_1_0_1"):setString(res.str.DIG_DEC36)
	self.bg:getChildByName("Text_1_0_0"):setString(res.str.DIG_DEC37)



end 

function Dig_JiaSuview:setData(data)
	-- body
	self.data = data

	local v = cache.Dig:getOneMsg(data.daoId)
	local arg = conf.Item:getArg1(v.mId) 

	local colorlv = conf.Item:getItemQuality(arg.arg5)
	local json = conf.Item:getItemSrcbymid(arg.arg5) 

	self.rewardframe:loadTextureNormal(res.btn.FRAME[colorlv])
	self.spr:loadTexture(json)

	--[[local type = conf.Item:getType(arg.arg5)
	local str = ""
	if type == 1 then
	 	str = res.str.MONEY_JB
	elseif type ==2 then 
		str = res.str.MONEY_ZS
	else
		str = res.str.MONEY_HZ
	end ]]--
	local v = cache.Dig:getOneMsg(data.daoId)
	local var = 0
	if v and v.loseCount then 
		var = v.loseCount
	end
	print("awardMoney = "..data.awardMoney)

	self.lab_name:setString(conf.Item:getName(arg.arg5).."x"..data.awardMoney)

	self.lab_dec:setString(res.str.DIG_DEC22)
	local spr = display.newSprite(res.image.ZS)
	spr:setScale(0.5)
	spr:setAnchorPoint(cc.p(0,0.5))
	spr:setPositionX(self.lab_dec:getPositionX() + self.lab_dec:getContentSize().width)
	spr:setPositionY(self.lab_dec:getPositionY())
	spr:addTo(self.bg)

	local lab = self.lab_dec:clone()
	lab:setPositionX(spr:getPositionX()+spr:getContentSize().width*0.5)
	lab:setPositionY(self.lab_dec:getPositionY())
	lab:setString(string.format(res.str.DIG_DEC23,data.speedMoney,data.speedCount))
	lab:addTo(self.bg)
end

function Dig_JiaSuview:closeView( sender_, eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end

function Dig_JiaSuview:onBtnSureCallBack( sender_, eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then 
		if cache.Fortune:getZs() < self.data.speedMoney then 
			G_TipsForNoEnough(2)
			return 
		end 
		local data = {daoId = self.data.daoId}


		proxy.Dig:sendJiasu(data)
		mgr.NetMgr:wait(520006)

		self:onCloseSelfView()
	end 
end

function Dig_JiaSuview:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return Dig_JiaSuview