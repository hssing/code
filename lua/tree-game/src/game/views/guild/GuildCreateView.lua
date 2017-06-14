
--guildSearchView
--[[
	公会创建
]]--

local GuildCreateView=class("GuildCreateView",base.BaseView)

function GuildCreateView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.image_bg = self.view:getChildByName("Image_bg")
	--公会输入框 edibox 拿来弹出输入 label 用来居中显示 
	local _name_di = self.image_bg:getChildByName("Image_9") 
	self.lab_name  = cc.ui.UIInput.new({
	    image = res.image.TRANSPARENT,
	    x = _name_di:getPositionX()+10,
	    y = _name_di:getPositionY(),
	    size = cc.size(_name_di:getContentSize().width,_name_di:getContentSize().height)
	})
	self.lab_name:addTo(self.image_bg)
	self.lab_name:setMaxLength(7)
	self.lab_name:registerScriptEditBoxHandler(handler(self, self.onName))

	--拿来做居中显示，妈的
	self.label = display.newTTFLabel({
    text = res.str.GUILD_DEC1,
    font = res.ttf[1],
    size = 24,
    color = COLOR[3], 
    align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
    x=_name_di:getContentSize().width/2,
    y=_name_di:getContentSize().height/2,
    })
    self.label:setAnchorPoint(cc.p(0.5,0.5))
    self.label:addTo(_name_di)
    --把edibox 藏起来
    local hei_di = self.image_bg:getChildByName("Panel_12")
    hei_di:setTouchEnabled(false)
	self.image_bg:reorderChild(_name_di,500)
	self.image_bg:reorderChild(self.lab_name,400)
	self.image_bg:reorderChild(hei_di,401)
	--3个公会的头像选择
	self.img1 = self.image_bg:getChildByName("Image_17")
	self.img2 = self.image_bg:getChildByName("Image_17_0")
	self.img3 = self.image_bg:getChildByName("Image_17_1")

	for i = 1 , 3 do 
		local ccsize =self["img"..i]:getContentSize()

		--[[local frame = display.newSprite(res.btn.FRAME[1])
		frame:setScale(0.8)
		frame:setPosition(ccsize.width/2, ccsize.height/2)
		frame:addTo(self["img"..i])]]--


		


		--self["img"..i]:setContentSize(frame:getContentSize())
		self["img"..i]:loadTexture(res.btn.FRAME[1])
		self["img"..i]:ignoreContentAdaptWithSize(true)
		self["img"..i]:setScale(0.8)
		self["img"..i]:setTag(i)
		self["img"..i]:setTouchEnabled(true)
		self["img"..i]:addTouchEventListener(handler(self, self.imgChooseBack))

		local spr = display.newSprite(res.gonghui.img[i])
		spr:setPosition(self["img"..i]:getPosition())
		spr:addTo(self.image_bg)
	end 
	self:imgChooseBack(self.img1,ccui.TouchEventType.ended)--默认选择第一个

	local lab_cost  = self.image_bg:getChildByName("Text_18")
	self.cost_jb =  res.gonghui.cost_jb  --设置消耗的金币 
	lab_cost:setString("x"..self.cost_jb)

	local costicon = self.image_bg:getChildByName("Image_17_2")
	costicon:loadTexture(res.image.ZS)

	local btnCreate = self.image_bg:getChildByName("Button_buy_more_5") 
	btnCreate:addTouchEventListener(handler(self, self.onBtnCreate))

	local panel_1 = self.view:getChildByName("Panel_1")
	--panel_1:addTouchEventListener(handler(self, self.closeView))



	self:initDesc()
end

function GuildCreateView:initDesc(  )
	-- body
	self.image_bg:getChildByName("Text_18_0"):setString(res.str.GUILD_DEC_07)
	self.image_bg:getChildByName("Button_buy_more_5"):getChildByName("Text_1_2_5"):setString(res.str.GUILD_DEC_08)
end

function GuildCreateView:closeView( sender_,eventype  )
	-- body
	if eventype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end 
end

function GuildCreateView:imgChooseBack( sender_,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		self.imgtag = sender_:getTag()
		if not self.choose then
			self.choose = display.newSprite(res.btn.SELECT_BTN)
			self.choose:addTo(self.image_bg)
		end 
		self.choose:setPosition(sender_:getPosition())
		
	end 
end

function GuildCreateView:onName( eventype )
	-- body
	if eventype == "began" then
	elseif  eventype == "ended" then
	elseif eventype == "changed" then
	elseif eventype == "return" then
		local str = string.trim(self.lab_name:getText())
		if str == "" then 
			self.label:setString(res.str.GUILD_DEC1)
		else
			self.label:setString(str)
		end 
	end
end

function GuildCreateView:onBtnCreate(sender_,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		local str = G_filterChar(self.label:getString())
		local len = string.utf8len(str)
		--G_TipsOfstr(string.len(str).." wo cao "..string.len(self.lab_name:getText()))
		if string.len(str) ~= string.len(self.lab_name:getText()) then 
			G_TipsOfstr(res.str.GUILD_DEC12)
			return 
		elseif len<3 or len>7 then 
			G_TipsOfstr(res.str.GUILD_DEC2)
			return 
		elseif cache.Fortune:getZs()<self.cost_jb then
			--G_TipsOfstr(res.str.NO_ENOUGH_ZS)
			G_TipsForNoEnough(2)
			--G_GoReCharge()
			--self:onCloseSelfView()
			
			return 
		elseif string.find(self.label:getString()," ") ~=nil then --不允许空格
			G_TipsOfstr(res.str.LOGIN_ACCCOUNT_EXIT_NO)
			return 
		end 

		local params = {icon =self.imgtag,guildName = str}
		proxy.guild:sendCreate(params)
		
		debugprint("创建帮派 ====")
		printt(params)
	end 
end

function GuildCreateView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return GuildCreateView