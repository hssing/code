
local runeItem = class("runeItem", function( ... )
	-- body
	return ccui.Widget:create()
end)

function runeItem:init(Parent)
	-- body
	self.Parent=Parent
	self.view=self.Parent:getClone()
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self:addChild(self.view)

	self.btnFrame =self.view:getChildByName("Button_frame")
	self.spr = self.btnFrame:getChildByName("Image_22_23_5")
	self.lab_curlv = self.btnFrame:getChildByName("Image_lv_25_7"):getChildByName("Text_lv")

	self.lab_name = self.view:getChildByName("Image_zb_bg_29_9"):getChildByName("Text_name1_8")
	self.lab_name:setString("")

	for i = 1 , 3 do 
		self.view:getChildByName("Panel_Attribute"):getChildByName("Image__"..i):setVisible(false)
		self.view:getChildByName("Panel_Attribute"):getChildByName("Image__"..i):ignoreContentAdaptWithSize(true)
	end 

	--[[self.imgdec1 = self.view:getChildByName("Panel_Attribute"):getChildByName("Image__1")
	self.imgdec1:setVisible(false)

	self.imgdec2 = self.view:getChildByName("Panel_Attribute"):getChildByName("Image__2")
	--self.imgdec:setVisible(false)
	self.lab_value = self.imgdec:getChildByName("Text_33_31_14")
	self.lab_value:setString("")--]]

	self.Icon = self.view:getChildByName("Image_Icon")

	self.btn = self.view:getChildByName("Button_zb")
	self.btn:setTouchEnabled(true)
	self.btn:addTouchEventListener(handler(self, self.onHasEquipmentCallBack))
end

function runeItem:setData(data_)
	-- body
	self.data = data_
	local colorlv = conf.Item:getItemQuality(data_.mId)
	self.btnFrame:loadTextureNormal(res.btn.FRAME[colorlv])

	local icon = conf.Item:getItemSrcbymid(data_.mId)
	self.spr:ignoreContentAdaptWithSize(true)
	self.spr:loadTexture(icon)

	local lv = data_.propertys[315] and data_.propertys[315].value or 0
	self.lab_curlv:setString(lv)

	self.lab_name:setString(conf.Item:getName(data_.mId))
	self.lab_name:setColor(COLOR[colorlv])

	self.btn:setTouchEnabled(true)
	self.btn:setBright(true)

	if self.data.index > 600000 then
		self.Icon:setVisible(true)
		self.btn:setTouchEnabled(false)
		self.btn:setBright(false)
		--self.btn:setTitleText(res.str.DEC_NEW_12)
	else
		self.Icon:setVisible(false)
		self.btn:setTitleText(res.str.DEC_NEW_11)
	end

	local t = {}
	t.mId = data_.mId
	t.propertys = data_.propertys

	local prot =  data_--G_CalculateRunePro(t)
	local count = 0
	for k ,v in pairs(res.str.DEC_NEW_04) do 
		if count >= 3 then
			break
		end
		if prot.propertys[v] then
			count = count + 1

			local value = prot.propertys[v].value
			local img_dec = self.view:getChildByName("Panel_Attribute"):getChildByName("Image__"..count)
			img_dec:setVisible(true)
			local lab_value = img_dec:getChildByName("Text_32_"..count)

			img_dec:loadTexture(res.font.FW[v])
			if v > 200 then
				value = value .. "%"
			end
			lab_value:setString(value)

			lab_value:setPositionX(img_dec:getContentSize().width+img_dec:getPositionX())
		end
	end


	--[[local part = conf.Item:getItemPart(data_.mId)

	self.imgdec:loadTexture(res.font.FW[part])
	self.imgdec:setVisible(true)--]]

	--local value = data_.propertys[res.str.DEC_NEW_04[part]] and  
	--data_.propertys[res.str.DEC_NEW_04[part]].value or 0
	--self.lab_value:setString(value)

end


function runeItem:onHasEquipmentCallBack( send,even )
	if even == ccui.TouchEventType.ended then
		self.Parent:onHasEquitmentCallBack(self.data)
	end
end

return runeItem