--
-- Author: Your Name
-- Date: 2015-12-18 15:46:36
--
local FruitSellView = class("FruitSellView", base.BaseView)


function FruitSellView:init(  )
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.numLab = self.view:getChildByName("Text_4_0_0")
	self.numLab:setString(1)
	self.num = 1

	self.coinLab = self.view:getChildByName("Text_4_0")
	self.sellBtn = self.view:getChildByName("Button_2")
	self.closeBtn = self.view:getChildByName("Button_close")

	self.addOneBtn = self.view:getChildByName("Panel_add_one"):getChildByName("Button_5_2")
	self.descOneBtn =  self.view:getChildByName("Panel_reduce_one"):getChildByName("Button_5_0")
	self.addTenBtn = self.view:getChildByName("Panel_add_max"):getChildByName("Button_5_1")
	self.descTenBtn = self.view:getChildByName("Panel_reduce_min"):getChildByName("Button_5")
	self.addMaxBtn = self.view:getChildByName("Panel_2"):getChildByName("Button_1")

	self.btnFrame = self.view:getChildByName("Button_frame_24_0")

	self.addOneBtn:addTouchEventListener(handler(self,self.addProNum))
	self.descOneBtn:addTouchEventListener(handler(self,self.addProNum))
	self.addTenBtn:addTouchEventListener(handler(self,self.addProNum))
	self.descTenBtn:addTouchEventListener(handler(self,self.addProNum))
	self.addMaxBtn:addTouchEventListener(handler(self,self.addProNum))

	self.addOneBtn.num = 1
	self.descOneBtn.num = -1
	self.addTenBtn.num = 10
	self.descTenBtn.num = -10
	self.addMaxBtn.num = 99



	self.sellBtn:addTouchEventListener(handler(self,self.gotoSell))



	--界面文本
	self.view:getChildByName("Text_4_1"):setString(res.str.FRUIT_DESC10)
	self.view:getChildByName("Text_4"):setString(res.str.FRUIT_DESC11)

	self.sellBtn:getChildByName("Text_2"):setString(res.str.FRUIT_DESC12)
	self.closeBtn:getChildByName("Text_1"):setString(res.str.FRUIT_DESC13)


end

function FruitSellView:setData( data )
	self.data = data
	local path = conf.Item:getItemSrcbymid(data.mId,data.propertys)
	self.btnFrame:getChildByName("Image_22_24_9_4"):loadTexture(path)--材料ICON
	local fIcon =  res.btn.FRAME[conf.Item:getItemQuality(data.mId)]
	self.btnFrame:loadTextureNormal(fIcon)--品质框

	local price = conf.Item:getPrice(self.data.mId)
	self.numLab:setString(self.num)
	self.coinLab:setString(self.num * price)
	self.cost = self.num * price
end


function FruitSellView:addProNum( send,etype )
	if etype == ccui.TouchEventType.ended then
		self.num = self.num + send.num
		if self.num <= 0 then
			self.num = 1
		elseif self.num > self.data.amount and self.data.amount <= 99 then
			self.num = self.data.amount
		elseif self.num > 99 then
			self.num = 99
		end

		local price = conf.Item:getPrice(self.data.mId)
		self.numLab:setString(self.num)
		self.coinLab:setString(self.num * price)
		self.cost = self.num * price

	end
end


--出售
function FruitSellView:gotoSell( send,etype )
	if etype == ccui.TouchEventType.ended then
		proxy.Fruit:reqSellPro(self.data.index,self.num)
	end
end

function FruitSellView:sellSucc(  )
	-- body
	G_TipsOfstr(string.format(res.str.FRUIT_DESC17, self.cost))
	self:closeSelfView()
end






return FruitSellView