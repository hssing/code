
local ShopPanleShengMi=class("ShopPanleShengMi",function(  )
	return ccui.Widget:create()
end)


function ShopPanleShengMi:ctor()

end

function ShopPanleShengMi:init(Parent,type,ccsize,packindex)
	self.Parent=Parent
	self.index=type
	self.stype = packindex
	self.view=Parent:getColnePnale()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self:addChild(self.view)

	--品质框 按钮
	self.BtnFrame =  self.view:getChildByName("Button_frame_24_0")
	self.BtnFrame:addTouchEventListener(handler(self,self.onOpenItem))
	self.spr = self.view:getChildByName("Button_frame_24_0")
	--品质框上的图像
	self.spr=self.BtnFrame:getChildByName("Image_22_24_9")
	--物品名字
	self.LabName=self.view:getChildByName("txt_name")
	--购买按钮
	self.BtnBuy=self.view:getChildByName("Button_5")
	self.BtnBuy:addTouchEventListener(handler(self,self.onBuyCallBack))
	--购买的价格
	self.nowprice = self.view:getChildByName("txt_name_0_0_0")
	--原价
	self.Oldprice=self.view:getChildByName("txt_name_0_0")

	--是否打折的图标
	self.dazheimg =  self.view:getChildByName("Image_13")
	self.un_lab = self.view:getChildByName("txt_name_0")--
	self.dazheimg_2 = self.view:getChildByName("Image_6")
	self.line = self.view:getChildByName("Image_17")
	--货币类型
	self.moneytype_1 = self.view:getChildByName("Image_10")
	
	self.moneytype_1:setVisible(false)
	self.Oldprice:setVisible(false)
	self.un_lab:setVisible(false)
	self.dazheimg:setVisible(false)
	self.dazheimg_2:setVisible(false)
	self.line:setVisible(false)

	self.moneytype_2 = self.view:getChildByName("Image_10_0")

	self.un_lab:setString(res.str.SHOP_DEC_05)
end	

function ShopPanleShengMi:onBuyCallBack( send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		--debugprint("购买物品！！！")
		--print("  getTag "..send:getTag())
		--mgr.ViewMgr:showView(_viewname.SHOP_BUY):setData(self.data,self.stype)
		if self.price~=0 and  not G_BuyAnything(self.moneytype,self.price) then 
			G_TipsForNoEnough(self.moneytype)
			return 
		end	
		local __reqdata = {
			stype = 1,
			index =self.data.index,
			mId = self.data.mId ,
			amount = 1,
		}
		proxy.shop:buySend(__reqdata)

	end
end

function ShopPanleShengMi:onOpenItem( send,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		--mgr.ViewMgr:showView(_viewname.PRO_TIPS):setData(self.data)
		--G_openItem(self.data.mId)
		if self.Item_type ==  pack_type.PRO then
			G_openItem(self.data.mId)
		elseif  self.Item_type  == pack_type.EQUIPMENT then 
			G_OpenEquip(self.data,true)
		else	
			G_OpenCard(self.data,true)
		end
	end
	-- body
end
function ShopPanleShengMi:setFrameQuality(lv)
	local framePath=res.btn.FRAME[lv]
	self.BtnFrame:loadTextureNormal(framePath)
	self.LabName:setColor(COLOR[lv])
end
--设置物品名字
function ShopPanleShengMi:setName(name)
	self.LabName:setString(name)
end
--设置图像
function ShopPanleShengMi:setBImage(imgpath)
	 self.spr:loadTexture(imgpath)
end
--设置购买的价格
function ShopPanleShengMi:setPrice( price )
	-- body
	self.nowprice:setString(price)

	--[[local x = self.nowprice:getPosition()- self.nowprice:getContentSize().width/2
	x = x - self.moneytype_2:getContentSize().width/2
	local dx ,dy = self.moneytype_2:getPosition()
	self.moneytype_2:setPosition(x,dy)]]--

end
--设置原价
function ShopPanleShengMi:setOldprice(price )
	-- body
	self.Oldprice:setString(math.ceil(price))
	self.moneytype_1:setVisible(true)
	self.Oldprice:setVisible(true)
	self.un_lab:setVisible(true)
	self.dazheimg:setVisible(true)
	self.dazheimg_2:setVisible(true)
	self.line:setVisible(true)
end
--金币=1，钻石=2，徽章=3  self._curmoney = 购买该物品需要的货币
function ShopPanleShengMi:setMoneyIcon( type )
	local path = res.image.GOLD
	self._curmoney = cache.Fortune:getFortuneInfo().moneyJb
	if type == 3 then 
		path =  res.image.BADGE
		self._curmoney= cache.Fortune:getFortuneInfo().moneyHz
	elseif type == 2 then 
		path =  res.image.ZS
		self._curmoney= cache.Fortune:getFortuneInfo().moneyZs
	end	
	self.moneytype_1:loadTexture(path)
	self.moneytype_2:loadTexture(path)	
end

function ShopPanleShengMi:setBtnStatue(count)
	-- body

		
	if count<=0 then --不能购买
		self.BtnBuy:setEnabled(false)
		self.BtnBuy:setBright(false)

		--local Gray = display.newGraySprite(res.btn.SHOP)
		--Gray:setPosition(self.BtnBuy:getPosition())
		--self.BtnBuy:getParent():addChild(Gray,self.BtnBuy:getLocalZOrder())
	end	
end

function ShopPanleShengMi:setData(data)
	self.data=data
	local type=conf.Item:getType(data.mId)
	self.Item_type=type
	local lv= conf.Item:getItemQuality(data.mId)
	local name=conf.Item:getName(data.mId)
	local itemSrc=conf.Item:getSrc(data.mId)

	if self.Item_type == pack_type.SPRITE then
		local propertys=data.propertys
		local jj=mgr.ConfMgr.getItemJJ(propertys)    --几级进阶
		local card_id=mgr.ConfMgr.getItemID(data.mId,jj+1)
		name=mgr.ConfMgr.getCardName(card_id)
		itemSrc=mgr.ConfMgr.getCardSrc(card_id)
		path=mgr.PathMgr.getImageHeadPath(itemSrc)
	else
		path=mgr.PathMgr.getItemImagePath(itemSrc)
	end


	self.data.item_lv=lv
	self.data.item_name=name

	self:setFrameQuality(lv)
	self:setName(name)

	
	self:setBImage(path)

	local propertys = vector2table(self.data.propertys,"type")
	self.price =  propertys[40102].value
	self.moneytype = propertys[40101].value
	self:setPrice(self.price)

	if propertys[40104].value<100 and propertys[40104].value>0 then --如果有折扣
		--print(" propertys[40104].value =".. propertys[40104].value)
		local oldprice = self.price*100/propertys[40104].value
		self:setOldprice(oldprice)
	end	
	self:setMoneyIcon(propertys[40101].value)--金币=1，钻石=2，徽章=3 

	self:setBtnStatue(self.data.amount) -- 设置按钮的购买状态

end
return ShopPanleShengMi