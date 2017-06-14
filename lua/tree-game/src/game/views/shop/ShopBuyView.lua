
local ShopBuyView  = class("ShopBuyView",base.BaseView)

function ShopBuyView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.BtnBuy=self.view:getChildByName("Button_2")
	
	--购买的数量
	self.lab_count = self.view:getChildByName("Text_4_0_0")
	--总价
	self.lab_price = self.view:getChildByName("Text_4_0")
	self.lab_price_1 = self.lab_price
	--货币的类型
	self.money_type = self.view:getChildByName("Image_2")
	self.money_type_1 = self.money_type
	self.money_type_1:ignoreContentAdaptWithSize(true)
	--self.money_type_1:setScale(0.7)

	self.BtnFrame=self.view:getChildByName("Button_frame_24_0")
	--品质框上的图像
	self.spr=self.BtnFrame:getChildByName("Image_22_24_9_4")

	--增加购买的数量
	self.ListButton1={}
	local btn  = self.view:getChildByName("Panel_add_one")
	btn:addTouchEventListener(handler(self,self.onListCallBack1))

	local btn1 = self.view:getChildByName("Panel_add_max")
	btn1:addTouchEventListener(handler(self,self.onListCallBack1))


	--减少购买的数量
	local btn2  = self.view:getChildByName("Panel_reduce_one")
	btn2:addTouchEventListener(handler(self,self.onListCallBack1)) 


	local btn3 = self.view:getChildByName("Panel_reduce_min") 
	btn3:addTouchEventListener(handler(self,self.onListCallBack1)) 


	--第二中货币
	self.lab_price_2 = self.view:getChildByName("Text_4_0_1")
	--货币的类型
	self.money_type_2 = self.view:getChildByName("Image_2_0")
	self.money_type_2:ignoreContentAdaptWithSize(true)
	--self.money_type_2:setScale(0.7)

	self.lab_price_2:setVisible(false)
	self.money_type_2:setVisible(false)

	self:initDec()
end

function ShopBuyView:initDec()
	-- body
	self.view:getChildByName("Text_4"):setString(res.str.SHOP_DEC_04)
	self.view:getChildByName("Text_4_1"):setString(res.str.SHOP_DEC_03)

	self.view:getChildByName("Button_close"):getChildByName("Text_1_0"):setString(res.str.SHOP_DEC_02)
	self.view:getChildByName("Button_2"):getChildByName("Text_1"):setString(res.str.SHOP_DEC_01)
end

function  ShopBuyView:setFrameQuality( lv )
	-- body
	local framePath=res.btn.FRAME[lv]
	self.BtnFrame:loadTextureNormal(framePath)
	--self.LabName:setColor(COLOR[lv])
end

--设置图像
function ShopBuyView:setBImage(imgpath)
	 self.spr:loadTexture(imgpath)
end

function ShopBuyView:setPrice(count)
	-- body
	self.lab_price:setString(self.price*count)
end

function ShopBuyView:setCount( count )
	-- body
	self.lab_count:setString(count)
	self:setPrice(count);
end

function ShopBuyView:setMoneyIcon( type )
	local path = res.image.GOLD
	if type == 3 then 
		path =  res.image.BADGE
	elseif type == 2 then 
		path =  res.image.ZS
	end	
	self.money_type:loadTexture(path)
end

function ShopBuyView:getMaxCount()
	-- body
	local count = 1;
	 --需要根据货币的类型 和单价 以及 剩余购买次数协定
	
	--print("self.data.amount 最大购买次数 "..self.data.amount)
	local count = checkint(math.floor(self.curmoney/self.price));
	--print(" count = "..count)
	if self.data.amount>0 then 
		count= math.min(count,self.data.amount)
	end	
	count = math.min(99,count)
	--print(" count = "..count)
	return count
end

function ShopBuyView:setData( data , stype)
	-- body
	debugprint("购买物品的信息！！！")
	self.data = data
	self.count = 1
	--print("stype "..stype)
	self.stype =stype

	local type=conf.Item:getType(data.mId)
	self.Item_type=type
	local lv=conf.Item:getItemQuality(data.mId)
	local name=conf.Item:getName(data.mId)

	local path = conf.Item:getItemSrcbymid(data.mId,data.propertys)
	
	self.data.item_lv=lv
	self.data.item_name=name
	self:setFrameQuality(lv)

	
	self:setBImage(path)

	local propertys = vector2table(self.data.propertys,"type")
	self.price =  propertys[40102].value
	self.moneytype = propertys[40101].value


	self.curmoney = 0;
	if self.moneytype ==3 then 
	 	self.curmoney= cache.Fortune:getFortuneInfo().moneyHz
	elseif self.moneytype ==2 then
	 	self.curmoney= cache.Fortune:getFortuneInfo().moneyZs
	else	
	 	self.curmoney = cache.Fortune:getFortuneInfo().moneyJb
	end
	self:setMoneyIcon(self.moneytype)
	
	local defaultcount = 1
	self:setCount(defaultcount)

	self.BtnBuy:addTouchEventListener(handler(self,self.onBtnSureBuyCallBack)) 
end

--普通商店
function ShopBuyView:onBtnSureBuyCallBack(send,eventtype)
	-- body
	--需要检查条件是否满足
	if eventtype == ccui.TouchEventType.ended then
		local amountNum = tonumber(self.lab_count:getString())

		if G_BuyAnything(self.moneytype,self.price,amountNum) then 
			local __reqdata = {
			stype = self.stype,
			index =self.data.index,
			mId = self.data.mId ,
			amount = amountNum,
			}
			proxy.shop:buySend(__reqdata)
		end	
	end
end
function ShopBuyView:onListCallBack1( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--local btnId=send:getTag()
		send:setScale(1)
		if send:getName()=="Panel_reduce_one" then --减少一个
			self.count = self.count > 1 and self.count-1 or 1
		elseif  send:getName()=="Panel_reduce_min" then 
			if self.count - 10 > 0 then 
				self.count = self.count -10 
			else
				self.count = 1
			end 
		else
			local max = self.guild and self:getGuildMaxCount() or self:getMaxCount()
			--print("max = "..max)
			if send:getName()=="Panel_add_one" then 
				self.count = math.min(self.count+1,max)
			else
				if self.count+10 <max then 
					if self.count < 10 then
						self.count = 10
					else
						self.count = self.count+10
					end
					
				else
					self.count = max
				end 
				
			end		
		end
		if self.guild then 
			self:setGuildCount(self.count) 
		else
			self:setCount(self.count) 
		end 
		
	elseif ccui.TouchEventType.began == eventtype then 
		send:setScale(0.8)
	--elseif ccui.TouchEventType.ended == eventtype then 
	end
end

function ShopBuyView:onCloseSelfView()
	-- body
	--self.super.onCloseSelfView(self)
	self:closeSelfView()
end



-----------------------------------------------------------------------------------------------------------------
--公会商店有2种购买货币，而且贡献又不一定是必须品，妈的。
-------------------------------------------------------------------------------------------------------------------

--公会商店
function ShopBuyView:onBtnGulidSureBuyCallBack(send,eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local amountNum = tonumber(self.lab_count:getString())
		if self.price and self.price > 0  then 
			local money = cache.Fortune:getFortuneInfo().moneyZs
			if not G_BuyAnything(2,self.price,amountNum) then 
				self:onCloseSelfView()
				return 
			end  
		end 


		local params = { index = self.data.index,amount = amountNum }
		proxy.guild:sendBuy(params)
	end 
end

function ShopBuyView:setGuildCount( value )
	-- body
	self.lab_count:setString(value)
	for i = 1 , 2 do 
		local v = self["lab_price_"..i]
		if v:isVisible() and v.price and v.price>0 then 
			v:setString(value*v.price)
		end 
	end 
end

function ShopBuyView:getGuildMaxCount()
	-- body
	--[[local count = 1;
	local count = checkint(math.floor(self.curmoney/self.price));
	if self.data.amount>0 then 
		count= math.min(count,self.data.amount)
	end	
	count = math.min(99,count)
	return count]]--

	local count = 1
	local zs_cout = 0 
	if self.price and self.price > 0 then 
		local money = cache.Fortune:getFortuneInfo().moneyZs
		zs_cout = checkint(math.floor(money/self.price))
	end 

	if zs_cout > 0 then 
		count = zs_cout
	end 

	local gx_count = 0 
	if self.price1 and self.price1 > 0 then 
		local money = cache.Guild:getGuildPoint()
		gx_count = checkint(math.floor(money/self.price1))
	end 

	if zs_cout ~= 0 then 
		if gx_count > 0 then 
			count = math.min(count,gx_count) 
		end 
	else
		if gx_count > 0 then 
			count = gx_count
		end 
	end 


	count = math.min(99,count)
	count = math.min(self.limlitcout,count)


	return count
end


function ShopBuyView:setGuiildData(data)
	-- body
	self.data = data
	self.count = 1

	self.guild = true

	local type=conf.Item:getType(data.mId)
	self.Item_type=type
	local lv=conf.Item:getItemQuality(data.mId)
	local name=conf.Item:getName(data.mId)
	local path = conf.Item:getItemSrcbymid(data.mId,data.propertys)
	self.data.item_lv=lv
	self.data.item_name=name
	self:setFrameQuality(lv)
	self:setBImage(path)


	local propertys = vector2table(self.data.propertys,"type")
	self.price =  propertys[40107] and   propertys[40107].value or nil  --砖石价格
	self.price1 =  propertys[40106] and propertys[40106].value or nil  --贡献价格

	self.limlitcout = propertys[40103] and propertys[40103].value or 0 --剩余可购买

	local b1 = 0 
	if self.price and self.price>0 then 
		b1 = b1 +1 
		self["money_type_"..b1]:loadTexture(res.image.ZS)
		self["lab_price_"..b1]:setString(self.price)
		self["lab_price_"..b1].price = self.price --单价

		self["money_type_"..b1]:setVisible(true)
		self["lab_price_"..b1]:setVisible(true)
	end 

	if self.price1 and self.price1 > 0 then 
		b1 = b1 +1 

		self["money_type_"..b1]:loadTexture(res.icon.GONGXIANIOCN)
		self["lab_price_"..b1]:setString(self.price1)
		self["lab_price_"..b1].price = self.price1

		self["money_type_"..b1]:setVisible(true)
		self["lab_price_"..b1]:setVisible(true)
	end 





	local defaultcount = 1
	self:setGuildCount(defaultcount)

	self.BtnBuy:addTouchEventListener(handler(self,self.onBtnGulidSureBuyCallBack)) 
end

return ShopBuyView