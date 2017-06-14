--[[
购买体力
]]

local BuyTiliView=class("BuyTiliView",base.BaseView)

function BuyTiliView:init()
	-- body
	--proxy.Radio:send101006(40411)

	self.showtype=view_show_type.GUIDE
	self.view=self:addSelfView()

	--使用道具框
	self.pane1 = self.view:getChildByName("Panel_9")
	self.pane1:setVisible(false)
	--购买体力框
	self.pane2 = self.view:getChildByName("Panel_9_0")
	self.pane2:setVisible(false)
	--购买不足 或者vip 不够
	self.pane3 = self.view:getChildByName("Panel_9_0_0")
	self.pane3:setVisible(false)


	
	--
	self.btncancel = self.view:getChildByName("Button_close_0")
	self.btncancel:addTouchEventListener(handler(self, self.onbtnCancel))

	self.btnuse = self.view:getChildByName("Button_2")
	self._txtuse = self.btnuse:getChildByName("Text_1_17")

	self.posx = self.btnuse:getPositionX()
	self.posy = self.btnuse:getPositionY()

	self.cancel_posx = self.btncancel:getPositionX()
	self.cancel_posy = self.btncancel:getPositionY()

	--self:chooseshow()

	self:initDec()
end


function BuyTiliView:initDec()
	-- body
	self.pane3:getChildByName("Text_20_25_34"):setString(res.str.BUG_DEC_08)

	self.pane2:getChildByName("Text_20_25"):setString(res.str.BUG_DEC_05)
	self.pane2:getChildByName("Text_20_0_27_0"):setString(res.str.BUG_DEC_06)
	self.pane2:getChildByName("Text_20_0_27"):setString(res.str.BUG_DEC_07)
	
	self.pane1:getChildByName("Text_20"):setString(res.str.BUG_DEC_01)
	self.pane1:getChildByName("Text_20_0"):setString(res.str.BUG_DEC_02)

	self.btnuse:getChildByName("Text_1_17"):setString(res.str.BUG_DEC_03)
	self.btncancel:getChildByName("Text_1_0_19"):setString(res.str.BUG_DEC_04)
end

function BuyTiliView:onbtnuseItem( sender,eventtype )
	-- body
	if eventtype ==  ccui.TouchEventType.ended then
		debugprint("使用道具试试")
		local data = sender.data
		
	
		local item={}
		item.index=data.index
		item.amount= 1 
		item.mId=data.mId

		printt(item)
		proxy.pack:reqGetPack(item)

		self:onCloseSelfView()
	end
end

function BuyTiliView:setUseMessage( data_ )
	-- body
	self.pane1:setVisible(true)

	self.view:getChildByName("Image_3"):loadTexture(res.font.CISHU)
	

	local _txt1 = self.pane1:getChildByName("Text_20")
	_txt1:setString(res.str.BUY_DEC1)

	local _txt2 = self.pane1:getChildByName("Text_20_0_0")
	_txt2:setString(conf.Item:getName(data_.mId))

	_txt2:setPositionX(_txt1:getContentSize().width+_txt1:getPositionX())

	local function isExist(param,id) 
		-- body
		for k ,v in pairs(param) do 
			if v == id then 
				return true
			end 
		end 
		return false
	end 

	local str = ""
	local _txt3 = self.pane1:getChildByName("Text_20_0")
	if isExist(PRO_USE_TM,data_.mId) then --屠魔药剂
		_txt3:setString(res.str.BUY_DEC2)
		str = res.str.BUY_DEC4
	elseif isExist(PRO_USE_ATHELETICS,data_.mId) then --挑战药剂
		_txt3:setString(res.str.BUY_DEC3)
		str = res.str.BUY_DEC5
	end 
	
	local img = self.pane1:getChildByName("Image_48")
	img:loadTexture(conf.Item:getItemSrcbymid(data_.mId))

	local _txt4 = self.pane1:getChildByName("Text_20_0_0_0")
	_txt4:setString(str.."+"..conf.Item:getExp(data_.mId))

	self.btncancel:addTouchEventListener(handler(self, self.onbtnCancel))

	self.btnuse.data = data_
	self.btnuse:addTouchEventListener(handler(self, self.onbtnuseItem))
end

function BuyTiliView:chooseshow()
	-- body
	self.pane1:setVisible(false)
	self.pane2:setVisible(false)
	self.pane3:setVisible(false)
	self.btncancel:setVisible(true)
	self.btnuse:setPositionX(self.posx)
	self.btnuse:setPositionY(self.posy)

	--查找回复体力的道具
	local id = 0
	for k ,v in pairs(PRO_USE_TL) do
		local count = cache.Pack:getItemAmountByMid(pack_type.PRO,v)
		if count > 0 then 
			id = v
			break
		end 
	end 

	if id ~=0 then  --使用道具
		self:show1(id)
		return
	end 

	--购买次数
	local cout = cache.Player:getTliBuy()
	if cout <= 0 then --次数不足
		self:show2() --提升vip
	else
		self:show3() --购买
	end 
end

function BuyTiliView:onbtnCancel(sender,eventtype)
	-- body
	if eventtype ==  ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end
end
--使用道具
function BuyTiliView:ontbtnUse( sender,eventtype )
	-- body
	if eventtype ==  ccui.TouchEventType.ended then
		local mId = sender:getTag()
		local packOne =	cache.Pack:getItemAllitemByMid(pack_type.PRO,mId)
		local data={}
		data.index=packOne[1].index
		data.amount=1
		data.mId=packOne[1].mId
		proxy.pack:reqGetPack(data)

		self:onCloseSelfView()
	end
end

function BuyTiliView:show1(id)
	-- body
	self.pane1:setVisible(true)

	local img = self.pane1:getChildByName("Image_48")  
	local png = conf.Item:getItemSrcbymid(id)
	--print("png "..png)
	img:loadTexture(png)

	local txt =  self.pane1:getChildByName("Text_20_0_0_0")
	local useadd  = conf.Item:getExp(id)
	txt:setString(res.str.ROLE_BUY_TILI.."+"..useadd)

	
	self._txtuse:setString(res.str.PACK_USE)
	self.btnuse:addTouchEventListener(handler(self, self.ontbtnUse))
	self.btnuse:setTag(id)
end
--去充值
function BuyTiliView:ontbtnRecharge( sender,eventtype )
	-- body
	if eventtype ==  ccui.TouchEventType.ended then
		G_GoReCharge()
		self:onCloseSelfView()
	end
end

function BuyTiliView:show2()
	-- body
	self.pane3:setVisible(true)
	local vip = cache.Player:getVip()
	local max = #res.icon.VIP_LV
	if vip == max then 
		local dx = self.pane3:getChildByName("Text_20_25_34")
		dx:setString("\n\n"..res.str.ROLE_BUY_TILI_MAX_VIP)

		self._txtuse:setString(res.str.SURE)
		self.btnuse:addTouchEventListener(handler(self, self.onbtnCancel))
		self.btncancel:setVisible(false)
		self.btnuse:setPositionX((self.btnuse:getPositionX()+self.btncancel:getPositionX())/2)
	else
		self._txtuse:setString(res.str.RECHARGE)
		self.btnuse:addTouchEventListener(handler(self, self.ontbtnRecharge))
	end 

	local text = self.pane3:getChildByName("Text_20_25_34") 
	if res.banshu  then --or g_recharge
		text:setString("主人，今日购买次数已达上限")
		self.btncancel:setPositionX(display.cx)
		self.btncancel:getChildByName("Text_1_0_19"):setString("确 定")
		
		self.btnuse:setVisible(false)
	end 
		
	
end
--发送购买
function BuyTiliView:ontbtnBuy( sender,eventtype )
	-- body
	if eventtype ==  ccui.TouchEventType.ended then
		debugprint("发送购买"..sender:getTag())
		local price = tonumber(sender:getName())
		if not G_BuyAnything(2,price) then 
			self:onCloseSelfView()
			return 
		end 

		local tag = sender:getTag()
		local data ={stype = 40411,count = tag }
		--debugprint("购买体力 ="..tag)
		proxy.Radio:send101005(data)
		self:onCloseSelfView()
	end
end

--购买体力
function BuyTiliView:show3()
	-- body
	self.pane2:setVisible(true)
	local price = self.pane2:getChildByName("Text_20_0_0_29")

	local times  = cache.Player:getBuycount()
	print("times = "..times)
	local ttpr = conf.buyprice:getPrice(times+1)
	if not ttpr then 
		ttpr = conf.buyprice:getPriceMax()
	end 

	price:setString(ttpr)


	local img = self.pane2:getChildByName("Image_17_19"):getChildByName("Image_49") 
	local id = PRO_USE_TL[1] --221011002
	local png = conf.Item:getItemSrcbymid(id)
	img:loadTexture(png)

	local txt =  self.pane2:getChildByName("Text_20_0_0_0_31")
	local useadd  = conf.Item:getExp(id)
	txt:setString(res.str.ROLE_BUY_TILI.."+"..useadd)

	self._txtuse:setString(res.str.BUY)
	self.btnuse:setTag(checkint(useadd))
	self.btnuse:setName(ttpr)
	self.btnuse:addTouchEventListener(handler(self, self.ontbtnBuy))


	self.btncancel:setVisible(true)
	self.btnuse:setVisible(true)
	self.btncancel:setPositionX(self.cancel_posx)
	self.btncancel:setPositionY(self.cancel_posy)
	self.btncancel:getChildByName("Text_1_0_19"):setString(res.str.CLOSE)
end


function BuyTiliView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return BuyTiliView