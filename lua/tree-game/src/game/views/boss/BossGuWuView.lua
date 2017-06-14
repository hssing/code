--[[
	BossGuWuView
]]

local BossGuWuView = class("BossGuWuView",base.BaseView)
function BossGuWuView:ctor()
	-- body
end

function BossGuWuView:init()
	-- body
	self.showtype=view_show_type.TOP 
    self.view=self:addSelfView()

    self.panel =self.view:getChildByName("Panel_2_0")
    local btn_close = self.panel:getChildByName("Button_3")
    btn_close:addTouchEventListener(handler(self,self.onBtnClose))

    local btn_1 = self.panel:getChildByName("Button_Using_1")
    btn_1.tag = 1
    btn_1:setTitleText(res.str.RES_GG_47)
    btn_1:addTouchEventListener(handler(self,self.btnGuwu))

    local btn_2 = self.panel:getChildByName("Button_Using_22")
    btn_2.tag = 2
    btn_2:setTitleText(res.str.RES_GG_48)
    btn_2:addTouchEventListener(handler(self,self.btnGuwu))

    self:initDec()
    self:setData()
end

function BossGuWuView:initDec()
	-- body
	self.panel:getChildByName("Text_1_0"):setString(res.str.RES_GG_49)

	self.left = {}
	self.right = {}

	self.widget_left = self.panel:getChildByName("Image_2_1")
	self.widget_right = self.panel:getChildByName("Image_2_1_0")

	for i = 1 , 3 do 
		local t = {}
		t.dec = self.widget_left:getChildByName("Text_dec_"..i)
		t.img = self.widget_left:getChildByName("Image_20_"..i)
		t.value = self.widget_left:getChildByName("Text_value_"..i)
		t.dec:setVisible(false)
		t.img:setVisible(false)
		t.value:setVisible(false)
		t.img:ignoreContentAdaptWithSize(true)
		table.insert(self.left,t)

		t = {}
		t.dec = self.widget_right:getChildByName("T_dec_"..i)
		t.img = self.widget_right:getChildByName("Image_21_"..i)
		t.value = self.widget_right:getChildByName("T_value_"..i)
		t.dec:setVisible(false)
		t.img:setVisible(false)
		t.value:setVisible(false)
		t.img:ignoreContentAdaptWithSize(true)
		table.insert(self.right,t)
	end
end

function BossGuWuView:setData()
	-- body

	local conf_data = conf.Boss:getOtherItem(14)
	self.left[1].dec:setString(res.str.RES_GG_50)
	self.left[1].value:setString(conf_data.value)
	self.left[1].dec:setVisible(true)
	self.left[1].value:setVisible(true)
	self.left[1].img:setVisible(true)

	local conf_l = conf.Boss:getOtherItem(4)
	for k ,v in pairs(conf_l.value) do 
		print("k = "..k)
		local t = self.left[1+ k]
		t.dec:setVisible(true)
		t.img:setVisible(true)
		t.value:setVisible(true)

		t.dec:setString(res.str.RES_GG_89)
		t.value:setString(v[2])
		local json = res.image.GOLD
		if v[1] == 221051001 then 
		elseif v[1] == 221051002 then
			json = res.image.ZS
		elseif v[1] == 221051003 then 
			json = res.image.BADGE 
		end
		t.img:loadTexture(json)
	end

	local conf_data_1 = conf.Boss:getOtherItem(15)
	self.right[1].dec:setString(res.str.RES_GG_50)
	self.right[1].value:setString(conf_data_1.value)
	self.right[1].dec:setVisible(true)
	self.right[1].value:setVisible(true)
	self.right[1].img:setVisible(true)

	local conf_r = conf.Boss:getOtherItem(5)
	for k ,v in pairs(conf_r.value) do 
		local t = self.right[1+ k]
		t.dec:setVisible(true)
		t.img:setVisible(true)
		t.value:setVisible(true)

		t.dec:setString(res.str.RES_GG_89)
		t.value:setString(v[2])
		local json = res.image.GOLD
		if v[1] == 221051001 then 
		elseif v[1] == 221051002 then
			json = res.image.ZS
		elseif v[1] == 221051003 then 
			json = res.image.BADGE 
		end
		t.img:loadTexture(json)
	end


	--[[self.panel:getChildByName("Image_2_1"):getChildByName("Text_1_0_0"):setString(conf_data.value)
	local conf_data = conf.Boss:getOtherItem(15)
	self.panel:getChildByName("Image_2_1_0"):getChildByName("Text_1_0_0_14"):setString(conf_data.value)]]--

end

function BossGuWuView:btnGuwu( sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		proxy.Boss:send_126004({type = sender_.tag})
		self:onCloseSelfView()
	end
end

function BossGuWuView:onBtnClose(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end
end

function BossGuWuView:onCloseSelfView()
	-- body
	self:closeSelfView()
end
return BossGuWuView