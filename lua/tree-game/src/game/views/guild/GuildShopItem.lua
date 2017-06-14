--[[
	商店每一个item
]]

local GuildShopItem = class("GuildShopItem",function(  )
	return ccui.Widget:create()
end)

function GuildShopItem:init( widget )
	-- body
	self.Parent=widget
	self.view=widget:getColnePnaleItem()
	self.view:setVisible(true)
	self.view:setPosition(0,0)
	self:setContentSize(self.view:getContentSize())
	self:addChild(self.view)

	--图片框 和道具icon 
	self._frame = self.view:getChildByName("Image_22_24_137_0")
	self._frame:setTouchEnabled(true)
	self._icon =   self._frame:getChildByName("Image_22_24_137")
	--self._icon:ignoreContentAdaptWithSize(true)


	--
	self.lab_name = self.view:getChildByName("Image_zb_bg_30_139"):getChildByName("Text_name_19_115")
	--购买需求
	self.buyneed = {}
	local type_icon = self.view:getChildByName("Image_148")
	local cost = self.view:getChildByName("Text_130")

	local t = {}
	t.type_icon = type_icon
	t.cost = cost
	table.insert(self.buyneed,t)

	type_icon = self.view:getChildByName("Image_148_0")
	cost = self.view:getChildByName("Text_130_0")
	local t = {}
	t.type_icon = type_icon
	t.cost = cost
	table.insert(self.buyneed,t)
	--可购买次数 或者限制
	self.lab_dec = self.view:getChildByName("Text_130_0_0") 
	self.lab_cout = self.view:getChildByName("Text_130_0_0_0")
	self.lab_decci = self.view:getChildByName("Text_130_0_0_1")
	--购买按钮
	self.btn_buy =  self.view:getChildByName("Button_Using_26_48")
	self.btn_buy:addTouchEventListener(handler(self, self.onbtnBuy))

end

function GuildShopItem:onOpenItem( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		G_openItem(self.data.mId)
	end
end

function GuildShopItem:setData(data,idx)
	-- body
	self.data = data
	local itemdata = conf.guild:getShopItem(data.index)
	if not itemdata then
		printt(data)
	end

	local cololv = conf.Item:getItemQuality(data.mId)
	local framePath = res.btn.FRAME[cololv]
	self._frame:loadTexture(framePath)
	self._frame:setTouchEnabled(true)
	self._frame:addTouchEventListener(handler(self, self.onOpenItem))

	local icon = conf.Item:getItemSrcbymid(data.mId,data.propertys)
	self._icon:loadTexture(icon)

	local name = conf.Item:getName(data.mId)
	self.lab_name:setString(name)

	for k ,v in pairs(self.buyneed) do 
		v.type_icon:setVisible(false)
		v.cost:setVisible(false)
	end  
	local b1 = 0 
	if  itemdata.money_zs and itemdata.money_zs > 0 then 
		b1 = b1 +1 
		local t = self.buyneed[b1]
		t.type_icon:setVisible(true)
		t.cost:setVisible(true)
		t.type_icon:loadTexture(res.image.ZS)
		t.cost:setString(itemdata.money_zs)
	end  

	if itemdata.money_gx and itemdata.money_gx>0 then 
		b1 = b1 +1 
		local t = self.buyneed[b1]
		t.type_icon:setVisible(true)
		t.cost:setVisible(true)
		t.type_icon:loadTexture(res.icon.GONGXIANIOCN)
		t.cost:setString(itemdata.money_gx)
	end 

	self.lab_dec:setColor(self.lab_decci:getColor())
	self.lab_cout:setVisible(false)
	self.lab_decci:setVisible(false)

	self.btn_buy:setTouchEnabled(true)
	self.btn_buy:setBright(true)
	self.btn_buy:setTitleColor(cc.c3b(33,46,111))

	local property = vector2table(data.propertys,"type")
	local count = property[40103] and  property[40103].value or 0
	local isbuy = property[40105] and  property[40105].value or 0

	if isbuy == 0  then 
		--itemdata.guild_level>=cache.Guild:getGuildLevel()
		self.btn_buy:setTouchEnabled(false)
		self.btn_buy:setBright(false)
		self.btn_buy:setTitleColor(cc.c3b(0,0,0))

		self.lab_dec:setColor(COLOR[6])
		self.lab_dec:setString(string.format(res.str.GUILD_DEC32,itemdata.guild_level))
	else
		self.lab_dec:setString(res.str.GUILD_DEC33)
		self.lab_cout:setVisible(true)
		self.lab_decci:setVisible(true)

		
		--print("count = "..count)
		self.lab_cout:setString(count)

		if count ==  0 then 
			self.btn_buy:setTouchEnabled(false)
			self.btn_buy:setBright(false)
		end 

		self.lab_cout:setPositionX(self.lab_dec:getPositionX()+self.lab_dec:getContentSize().width)
		self.lab_decci:setPositionX(self.lab_cout:getPositionX()+self.lab_cout:getContentSize().width)
	end 


end

function GuildShopItem:onbtnBuy(sender_,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		debugprint("触发购买2次界面")
		mgr.ViewMgr:showView(_viewname.SHOP_BUY):setGuiildData(self.data)
	end 
end

return GuildShopItem
