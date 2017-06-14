
local ShopPanle=class("ShopPanle",function(  )
	return ccui.Widget:create()
end)

function ShopPanle:ctor()

end

function ShopPanle:initItem(  )
	-- body
	self.view=self.Parent:getColnePnaleItem()

	self.BtnBuy=self.view:getChildByName("Button_Using_26")
	self.BtnBuy:addTouchEventListener(handler(self,self.onBuyCallBack)) 
	--品质框
	self.BtnFrame=self.view:getChildByName("Button_frame_24")
	self.BtnFrame:addTouchEventListener(handler(self,self.onOpenItem))
	--品质框上的图像
	self.spr=self.BtnFrame:getChildByName("Image_22_24")
	--物品名字
	self.LabName=self.view:getChildByName("Image_zb_bg_30"):getChildByName("Text_name_19")
	--self.BtnFrame:addTouchEventListener(handler(self,self.onOpenItem))
	self.Lable_describe =self.view:getChildByName("Panel_Attribute_15"):getChildByName("Text_describe_27")
	--可购买个数
	self.dec_can = self.view:getChildByName("Text_message_21_0_0")
	self.Lable_canbuy=self.view:getChildByName("Text_message_21")
	--价格
	--原价
	self._olddec = self.view:getChildByName("Text_old_moneydec")
	self._moneytypeOld =  self.view:getChildByName("img_money_type_1")
	self._moneytypePrice =  self.view:getChildByName("Text_old_price")
	self._line = self.view:getChildByName("Image_7_0")
	--现价
	self._newdec = self.view:getChildByName("Text_new_moneydec")
	self.y = self._newdec:getPositionY()
	self._moneytypenew =  self.view:getChildByName("Image_3_0")
	self._moneytypenewPrice =  self.view:getChildByName("Text_new_price")
	--img_youhui
	self._img_youhui = self.view:getChildByName("img_youhui")

	self._olddec:setString(res.str.SHOP_DEC_05)
	self._newdec:setString(res.str.SHOP_DEC_06)
	self.dec_can:setString(res.str.SHOP_DEC_07)
	self.BtnBuy:setTitleText(res.str.SHOP_DEC_08)
end

function ShopPanle:initRecharge(  )
	-- body
	self.view=self.Parent:getColneRechargeItem()

	self.BtnFrame=self.view:getChildByName("Button_frame_24_3")
	--self.BtnFrame:addTouchEventListener(handler(self,self.onOpenItem))
	--品质框上的图像
	self.spr=self.BtnFrame:getChildByName("Image_22_24_8")
	--名字
	self.LabName=self.view:getChildByName("Image_zb_bg_30_13"):getChildByName("Text_name_19_6")
	--送多少
	self.Lable_describe =self.view:getChildByName("Panel_Attribute_15_6"):getChildByName("Text_describe_27_10")
	--价格
	self._img_di = self.view:getChildByName("Image_zb_bg_30_13")
	self._img_di.y = self._img_di:getPositionY()
	self._newdec = self._img_di:getChildByName("Text_name_19_6_0")
	self.y = self._newdec:getPositionY()
	--双倍图标
	self.icon = self.view:getChildByName("Image_2_0")
	--购买按钮
	self.BtnBuy=self.view:getChildByName("Button_Using_26_7")
	self.BtnBuy:addTouchEventListener(handler(self,self.onRechargeBuyCallBack)) 

	self.BtnBuy:setTitleText(res.str.SHOP_DEC_08)

	self.img_yue = self.view:getChildByName("Image_4")
	self.img_yue:setVisible(false)

	if g_language == LANGUAGE.CHINA_TW then 
		self._newdec:setVisible(false)
	else
		self._newdec:setVisible(true)
	end
end

function ShopPanle:getOnlyFirger()
	-- body
	local pos = self.BtnBuy:getWorldPosition()
	pos.x = pos.x + self.BtnBuy:getContentSize().width/2
	pos.y = pos.y --+ self.BtnBuy:getContentSize().height/2
	return pos
	--[[local params =  {id=404816, x=self.BtnBuy:getContentSize().width/2 ,
	y=self.BtnBuy:getContentSize().height/2 ,addTo=self.BtnBuy, playIndex=0
	,loadComplete = function ( var  )
		-- body
		self.firget_armature = var
	end}
	mgr.effect:playEffect(params)]]--
end

function ShopPanle:init(Parent,stype)
	-- body
	self.Parent=Parent
	self.stype=stype
	if self.stype == 4 then 
		self:initRecharge()
	else
		self:initItem()
	end	

	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self:addChild(self.view)

	
end
function ShopPanle:onOpenItem( send,eventtype )
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

function  ShopPanle:setFrameQuality( lv )
	-- body
	local framePath=res.btn.FRAME[lv]
	self.BtnFrame:loadTextureNormal(framePath)
	self.LabName:setColor(COLOR[lv])
end
--设置物品名字
function ShopPanle:setLabName(name)
	self.LabName:setString(name)
end
--设置图像
function ShopPanle:setBImage(imgpath)
	self.spr:loadTexture(imgpath)
end
function ShopPanle:setDscribe(dec)
	self.Lable_describe:setString(dec)
end

function ShopPanle:setCanBuyTimes( cout )
	-- body
	self.dec_can:setVisible(true)
	self.Lable_canbuy:setVisible(true)
	if cout>=0 then 
		self.Lable_canbuy:setString(tostring(cout))
	else
		self.Lable_canbuy:setString(res.str.SHOP_DEC1)
	end
end

function ShopPanle:getData( )
	-- body
	return self.data
end

function ShopPanle:setPrice( type_,money )
	-- body
	local path = res.image.GOLD;
	if type_ == 3 then 
		path =  res.image.BADGE;
		--str = res.str.MONEY_HZ
	elseif 	type_ == 2 then 
		path =  res.image.ZS;
		--str = res.str.MONEY_ZS
	end	
	self._moneytypeOld:loadTexture(path)
	self._moneytypenew:loadTexture(path)
	self._moneytypenewPrice:setString(tostring(money))
end

function ShopPanle:setBtnStatue( statue)
	-- body
	if statue == 0 or statue == 2 then --不能购买
		self.BtnBuy:setEnabled(false)
		self.BtnBuy:setBright(false)
		if statue == 2 then 
			self.BtnBuy:setTitleText(res.str.JUST_BUY)
		end		
	end	
end

function ShopPanle:setPriceinit()
	-- body
	self._olddec:setVisible(false)
	self._moneytypeOld:setVisible(false)
	self._moneytypePrice:setVisible(false)
	self._line:setVisible(false)

	self.dec_can:setVisible(false)	
	self.Lable_canbuy:setVisible(false)
	if self.stype == 2 then --道具商店
		self.dec_can:setVisible(true)	
		self.Lable_canbuy:setVisible(true)
		--[[self._olddec:setVisible(false)
		self._moneytypeOld:setVisible(false)
		self._moneytypePrice:setVisible(false)
		self._line:setVisible(false)]]--
	else
		self._olddec:setVisible(true)
		self._moneytypeOld:setVisible(true)
		self._moneytypePrice:setVisible(true)
		self._line:setVisible(true)

		--[[self.dec_can:setVisible(false)	
		self.Lable_canbuy:setVisible(false)]]--
	end	
end

function ShopPanle:setComByid( mId)
	-- body
	self.BtnBuy:setEnabled(true)
	self.BtnBuy:setBright(true)

	local type=conf.Item:getType(mId)
	self.Item_type=type

	local lv=conf.Item:getItemQuality(mId)
	local name=conf.Item:getName(mId)
	--local itemSrc=conf.Item:getSrc(mId)
	local path = conf.Item:getItemSrcbymid(mId)
	self.data.item_lv=lv
	self.data.item_name=name
	self:setFrameQuality(lv)
	self:setLabName(name)
	
	self:setBImage(path)

end

function ShopPanle:setDataOfItem( data,idx)
	-- body
	--self.data = data
	
	self:setComByid(data.mId)
	local str = conf.Item:getItemDescribe(data.mId)
	--print("str = "..str)
	self:setDscribe(str)

	self:setCanBuyTimes(data.amount)

	local propertys = vector2table(self.data.propertys,"type")
	local price =  propertys[40102].value
	self.price = price
	self.moneytype = propertys[40101].value
	self:setPrice(self.moneytype,price)
	if self.stype == 3 then 
		self._img_youhui:setVisible(true)
		self._moneytypePrice:setString(conf.Recharge:getOldPrice(self.data.index))
	else
		self._img_youhui:setVisible(false)
	end
	--print("propertys[40105].value = "..propertys[40105].value)
	self.BtnBuy:setTitleText(res.str.BUY)
	self:setBtnStatue(propertys[40105].value)
end

function ShopPanle:setDataOfRecharge( data )
	-- body
	--self.data = data
	local mId = 221051002
	self:setComByid(mId)
	--钻石
	local zs = data.moneyZs
	self:setLabName(zs)
	--RMB
	local price = data.moneyRmb --conf.Recharge:getRbm(data.index)
	self.BtnBuy:setTag(price*100)

	self._img_di:setPositionY(self._img_di.y)

	self._newdec:setString(price)
	self._newdec:setPositionY(self.y)

	self.img_yue:setVisible(false)

	
	local function _dec_create( ... )
		-- body
		self.Lable_describe:removeAllChildren()
		local zs_iocon = display.newSprite(res.image.ZS)
		zs_iocon:setAnchorPoint(0,0.5)
		zs_iocon:setPosition(self.Lable_describe:getContentSize().width,
		 self.Lable_describe:getContentSize().height/2)
		zs_iocon:setScale(0.8)
		zs_iocon:addTo(self.Lable_describe)

		if self.Lable_describe:getChildByName("name") then 
			self.Lable_describe:getChildByName("name"):removeFromParent()
		end 

		-- 创建一个居中对齐的文字显示对象
		local label = display.newTTFLabel({
		    text = zs,
		    size = self.Lable_describe:getFontSize(),
		    color = self.Lable_describe:getColor(),
		    font = self.Lable_describe:getFontName(),
		   -- align = cc.ui.TEXT_ALIGN_LEFT ,-- 文字内部居中对齐
		})
		label:setName("name")
		label:setAnchorPoint(0,0.5)
		label:setPosition(zs_iocon:getContentSize().width*0.8+zs_iocon:getPositionX(), self.Lable_describe:getContentSize().height/2)
		--label:setPosition(zs_iocon:getContentSize().width, zs_iocon:getContentSize().height/2)
		label:addTo(self.Lable_describe)
	end


	if data.isFirst == 0  then   
		self.Lable_describe:setVisible(true)
		self.icon:setVisible(true)
		local str =res.str.SHOP_RECHARGE_SONG --string.format(res.str.SHOP_RECHARGE_SONG,conf.Recharge:getZS(data.id))
		self.Lable_describe:setString(str)
		
		_dec_create()
	
		--[[local zs_iocon = display.newSprite(res.image.ZS)
		zs_iocon:setAnchorPoint(0,0.5)
		zs_iocon:setPosition(self.Lable_describe:getContentSize().width,
		 self.Lable_describe:getContentSize().height/2)
		zs_iocon:setScale(0.8)
		zs_iocon:addTo(self.Lable_describe)

		if self.Lable_describe:getChildByName("name") then 
			self.Lable_describe:getChildByName("name"):removeFromParent()
		end 

		-- 创建一个居中对齐的文字显示对象
		local label = display.newTTFLabel({
		    text = zs,
		    size = self.Lable_describe:getFontSize(),
		    color = self.Lable_describe:getColor(),
		    font = self.Lable_describe:getFontName(),
		   -- align = cc.ui.TEXT_ALIGN_LEFT ,-- 文字内部居中对齐
		})
		label:setName("name")
		label:setAnchorPoint(0,0.5)
		label:setPosition(zs_iocon:getContentSize().width*0.8+zs_iocon:getPositionX(), self.Lable_describe:getContentSize().height/2)
		--label:setPosition(zs_iocon:getContentSize().width, zs_iocon:getContentSize().height/2)
		label:addTo(self.Lable_describe)]]--
	else
		print("zs = "..zs)

		self.Lable_describe:setString("")
		self.Lable_describe:setVisible(false)
		self.icon:setVisible(false)

		self._img_di:setPositionY(self._img_di.y - 20 )
		self._newdec:setPositionY(self.y + 40)
	end 	

	if cache.Player:getMonthactiveNumber()>0 then --月卡活动开启了吗--月卡和终生卡的特殊处理
		if data.moneyRmb == 30 then
			if cache.Player:getMonthCard()<=0 then --未购买
				self.img_yue:setVisible(true)
				self.img_yue:getChildByName("Image_4_0"):loadTexture(res.font.MONYH_CARD)
			end
		elseif data.moneyRmb == 200  then 
			if cache.Player:getMonthAllCard()<=0 then--未购买
				self.img_yue:setVisible(true)
				self.img_yue:getChildByName("Image_4_0"):loadTexture(res.font.MONYH_ALL_CARD)
			end
		end
	end
end

function ShopPanle:setDoubleImg( )
	-- body
	self.icon:setVisible(false)
end

function ShopPanle:setData( data,stype,idx)
	-- body
	--print("设置各个item的属性")
	self.data = data
	self.stype = stype
	self.idx = idx

	if self.stype == 4 then 
		self:setDataOfRecharge(data)
	else
		
		self:setDataOfItem(data) --设置 道具商店 或 vipo礼拜
		self:setPriceinit()
	end	
	
end

function ShopPanle:onRechargeBuyCallBack( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--debugprint("充值的按钮被按下了 要充值"..send:getTag())
		if not g_recharge then 
			G_TipsOfstr(res.str.ROLE_GONGHUI)
			return 
		end 
		local params = {price=send:getTag()/100, name="钻石", desc="钻石"}
		--printt(params)

		sdk:pay(params)
		self.Parent:removefirget()
		--proxy.shop:sendRecharge(params.price)
		--cache.Shop:	
	end
end

function ShopPanle:setCallBack(fun)
	-- body
	self.callfunc = fun
end

function ShopPanle:onBuyCallBack( send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		debugprint("购买物品！！！"..self.stype.."," ..self.idx)
		if self.callfunc then 
			self.callfunc(self.idx)
		end 

		if self.stype == 2 then 
			if not G_BuyAnything(self.moneytype,self.price) then 
				G_TipsForNoEnough(self.moneytype)
				return 
			end	
			mgr.ViewMgr:showView(_viewname.SHOP_BUY):setData(self.data,self.stype)
            if self.data.mId == 221061001 then  --购买一阶精灵石
                local ids = {1018}
                mgr.Guide:continueGuide__(ids)
            elseif self.data.mId == 221023006 then  --购买白银装备宝箱
                local ids = {1032}
                mgr.Guide:continueGuide__(ids)
			end
		else

			if not G_BuyAnything(self.moneytype,self.price) then 
				G_TipsForNoEnough(self.moneytype)
				return 
			end	

			local function surecallbcak( ... )
				-- body
				--mgr.ViewMgr:closeView(_viewname.TIPS)

				local __reqdata = {
					stype = 3,
					index =self.data.index,
					mId = self.data.mId ,
					amount = 1,
				}
				printt(__reqdata)
				proxy.shop:buySend(__reqdata)	
			end

			local str = string.format(res.str.BUY_LIBAO_VIP,self.price)
			local data = {};
    		data.richtext = str;
    		data.sure = surecallbcak
    		data.cancel = function()
    			-- body
    		end
    		data.surestr = res.str.BUY 

    		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)

		end	
		--print("  getTag "..send:getTag())
	end
end

return ShopPanle