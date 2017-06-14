local runePanle=class("runePanle",function(  )
	return ccui.Widget:create()
end)
function runePanle:init( Parent )
	-- body
	self.Parent=Parent
	self.view=Parent:getColnePnale()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self.view:setTouchEnabled(false)
	self:addChild(self.view)
	--品质框 按钮
	self.BtnFrame=self.view:getChildByName("Button_frame")
	self.BtnFrame:addTouchEventListener(handler(self,self.onOpenItem))
	--品质框上的图像
	self.spr=self.BtnFrame:getChildByName("Image_22")
	--使用按钮
	self.LabName=self.view:getChildByName("Image_zb_bg"):getChildByName("Text_name")
	--升级
	self.BtnUsing=self.view:getChildByName("Button_Using")
	self.BtnUsing:addTouchEventListener(handler(self,self.onUsingCallBack))
	
	self.BtnUsing10=self.view:getChildByName("Button_Using10")
	self.BtnUsing10:setVisible(false)
	--self.BtnUsing10:addTouchEventListener(handler(self,self.onUsingCallBack_10))
	--物品属性面板
	self.PanelAttribute=self.view:getChildByName("Panel_Attribute")
	--描述
	self.Lable_describe=self.PanelAttribute:getChildByName("Text_describe")
	--信息 物品剩余信息
	self.LabMessage=self.view:getChildByName("Text_message")
	--星星面板
	self.IconStar=self.view:getChildByName("Panel_star")
	--等级
	self.Image_lv=self.BtnFrame:getChildByName("Image_lv")
	self.Lable_lv=self.Image_lv:getChildByName("Text_lv")
	--数量
	self.img_amount = self.BtnFrame:getChildByName("Image_lv_0")
	self.Lable_amount=self.img_amount:getChildByName("Text_amount")
	----是否出站的
	self._icon_on = self.view:getChildByName("Image_Icon")

	--self:initDec()
end

--添加星星
function runePanle:addStar( num )
	self.IconStar:removeAllChildren()
	local starpath=res.image.STAR
	local size=num
	local iconheight=self.IconStar:getContentSize().height
	local iconwidth=self.IconStar:getContentSize().width
	for i=1,size do
		local sprite=display.newSprite(starpath)
		sprite:setPosition(sprite:getContentSize().width/2+sprite:getContentSize().width*(i-1),iconheight/2)
		self.IconStar:addChild(sprite)
	end
end

function runePanle:setData(data)
	-- body
	self.data=data

	local colorlv = conf.Item:getItemQuality(data.mId)
	self:addStar(colorlv)
	--外框
	local framePath=res.btn.FRAME[colorlv]
	self.BtnFrame:loadTextureNormal(framePath)
	--名字
	local name=conf.Item:getName(data.mId,data.propertys)
	self.LabName:setString(name)
	self.LabName:setColor(COLOR[colorlv])
	--icon
	local path = conf.Item:getItemSrcbymid(data.mId)
	self.spr:ignoreContentAdaptWithSize(true)
	self.spr:loadTexture(path)
	--等级
	local lv = data.propertys[315] and data.propertys[315].value or 0
	self.Lable_lv:setString(lv)
	--数量无
	self.img_amount:setVisible(false)
	self.Lable_describe:setString("")
	self.LabMessage:setString("")

	for i = 1 , 3 do 
		self.PanelAttribute:getChildByName("Image__"..i):setVisible(false)
		self.PanelAttribute:getChildByName("Image__"..i):ignoreContentAdaptWithSize(true)
	end 
	--printt(data)
	local count = 0
	for k ,v in pairs(res.str.DEC_NEW_04) do 
		if count >= 3 then
			break
		end
		if data.propertys[v] then
			count = count + 1

			local value = data.propertys[v].value
			local img_dec = self.PanelAttribute:getChildByName("Image__"..count)
			img_dec:setVisible(true)
			local lab_value = img_dec:getChildByName("Text_32_"..count)

			img_dec:loadTexture(res.font.FW[v])
			if v > 200 then
				value = value .. "%"
			end
			lab_value:setString(value)
		end
	end

	--[[local img_dec = self.PanelAttribute:getChildByName("Image__2")
	local part = conf.Item:getItemtypePart(data.mId)
	img_dec:loadTexture(res.font.FW[part])
	img_dec:setVisible(true)

	local lab_value = img_dec:getChildByName("Text_32_2")
	local key = res.str.DEC_NEW_04[part]
	local var = data.propertys[key] and data.propertys[key].value or 0
	lab_value:setString(var)]]--

	self._icon_on:loadTexture(res.icon.PACK.wear)
	self.BtnUsing:setTitleText(res.str.DEC_NEW_02)	
	self.BtnUsing:setTouchEnabled(true)
	self.BtnUsing:setBright(true)
	if lv == conf.Item:getCardMaxlv(data.mId) then
		self.BtnUsing:setTouchEnabled(false)
		self.BtnUsing:setBright(false)
	end

	if data.index < 600000 then
		self._icon_on:setVisible(false)
		self.BtnUsing:setVisible(false)
	else
		self._icon_on:setVisible(true)
		self.BtnUsing:setVisible(true)
	end
end

function runePanle:onOpenItem(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		--G_OpenRun(self.data)
	end
end
function runePanle:onUsingCallBack(send,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		debugprint("升级")
	end
end
return runePanle