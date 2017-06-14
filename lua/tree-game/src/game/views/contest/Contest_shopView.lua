--[[
	Contest_shopView
]]

local Contest_shopView = class("Contest_shopView",base.BaseView)
local head = "res/views/ui_res/imagefont/"

function Contest_shopView:init()
	-- body
	self.ShowAll = true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.listview = self.view:getChildByName("Panel_1"):getChildByName("ListView_1")
	self.panel =self.view:getChildByName("Panel_1_0")
	self.lab_time = self.view:getChildByName("Text_40_0")
	--
	self.shopitem = self.view:getChildByName("Panel_4")
	self.btnitem =self.view:getChildByName("Button_24")

	self:clear()
	self:initListView()

	G_FitScreen(self,"Image_1")

	self.panel:setPositionY(display.cy - self.panel:getContentSize().height/2)

	self:schedule(self.changeTimes,1.0,"changeTimes")


	--界面固定文本
	self.view:getChildByName("Text_40"):setString(res.str.CONTEST_TEXT1)
	self.shopitem:getChildByName("txt_name_0_35"):setString(res.str.CONTEST_TEXT2)

	self.view:getChildByName("Text_40_1"):setString(res.str.DEC_NEW_35)
	self.lab_hz = self.view:getChildByName("Text_40_0_0")
	self.lab_hz:setString(cache.Fortune:getHz())
end

function Contest_shopView:clear()
	-- body
	self.lab_time:setString("0")
end

function Contest_shopView:changeTimes()
	-- body
	if self.data then 
		if self.data.refreshTime < 0 then 
			self.data.refreshTime = 0
		end 
		--print(string.formatNumberToTimeString(self.data.refreshTime))
		self.lab_time:setString(string.formatNumberToTimeString(self.data.refreshTime))
		self.data.refreshTime = self.data.refreshTime -1 
		if self.data.refreshTime < 0 then 
			self.data.refreshTime = 0
		end  
		if self.data.refreshTime == 0 then 
			if not self.request then 
				self.request = true
				self:performWithDelay(function( ... )
					-- body
					proxy.Contest:sendShopMsg({shopId = self.shopId})
					mgr.NetMgr:wait(519201)
				end, 1.5)
				
			end 
		end
	end 
end

function Contest_shopView:initListView()
	-- body
	local list = conf.Contest:getShoplist()
	table.sort(list,function( a,b)
		-- body
		return a.id<b.id
	end)

	self.btnlist = {}

	for k , v in  pairs(list) do 
		local item = self.btnitem:clone()
		table.insert(self.btnlist,item)

		local _txt = ccui.Text:create()
		_txt:setAnchorPoint(0,0.5)
		_txt:setFontSize(18)
		_txt:setFontName(res.ttf[1])
		_txt:setString(v.dec)
		_txt:setColor(cc.c3b(110,75,0))
		_txt:setPosition(10,item:getContentSize().height-15)
		_txt:addTo(item)

		local img = ccui.ImageView:create()
		img:setPosition(item:getContentSize().width/2,item:getContentSize().height/2)
		img:loadTexture(head..v.src)
		img:addTo(item)

		item:setTag(v.id)
		item:setTouchEnabled(true)
		item:addTouchEventListener(handler(self, self.ontbtnlistCallBack))

		self.listview:pushBackCustomItem(item)
	end 

	self:ontbtnlistCallBack(self.btnlist[1],ccui.TouchEventType.ended)
end


function Contest_shopView:ontbtnlistCallBack(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		--debugprint("选中的了其中一种"..sender_:getTag())
		self.request =false

		self.src = res.icon.CONTEST_SHOP_ZHE[sender_:getTag()]
		

		for k ,v in pairs(self.btnlist) do 
			v:setTouchEnabled(true)
			v:setBright(true)
		end 
		sender_:setTouchEnabled(false)
		sender_:setBright(false)

		--self:initPanel(sender_:getTag())
		self.shopId = sender_:getTag()
		proxy.Contest:sendShopMsg({shopId = self.shopId })
		mgr.NetMgr:wait(519201)
	end 
end
--看看是什么
function Contest_shopView:onOpenItem( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		G_openItem(send:getTag())
	end 
end

--是否能卖
function Contest_shopView:check()
	-- body
	local flag = true
	if self.data.smdsRank == 1 then 
		if self.shopId ~= self.data.smdsRank then 
			flag = false
		end 
	elseif self.data.smdsRank == 2 then 
		if self.shopId ~= self.data.smdsRank then 
			flag = false
		end 
	elseif self.data.smdsRank == 3 or self.data.smdsRank == 4 then 
		if self.shopId ~= 3 then 
			flag = false
		end 
	elseif self.data.smdsRank == 7 or self.data.smdsRank == 8 or self.data.smdsRank == 5 or self.data.smdsRank == 6 then
		if self.shopId ~= 4 then 
			flag = false
		end 
	elseif self.data.smdsRank == 0 then 
		if self.shopId ~= 5 then 
			flag = false
		end 
	else
		--flag = false
	end

	
	return flag
end
--购买
function Contest_shopView:onbtnBuy( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		if self:check() then 
			--if G_BuyAnything(send.buy_type, send.price) then 
				local data = {shop_index = tonumber(send.tag) } 
				proxy.Contest:sendBuy(data)
				mgr.NetMgr:wait(519202)
			--end 
		else
			G_TipsOfstr(res.str["CONTEST_DEC"..(43+self.shopId)])
		end 
	end 
end

function Contest_shopView:initShopItem(value,k,i)
	-- body
	local item = self.shopitem:clone()

	local ccsize = self.panel:getContentSize()
	local y  = i<=4 and 2 or 1
	local x  = i%4==0 and 4  or i%4;
	x = ccsize.width/8*(2*x-1)
	y = ccsize.height/4*(2*y-1)

	item:setAnchorPoint(cc.p(0.5,0.5))
	item:setPosition(x,y)
	item:addTo(self.panel)

	local v = conf.Contest:getShopItemById(k)

	local colorlv = conf.Item:getItemQuality(v.itemid)

	local lab_name = item:getChildByName("txt_name_33")
	lab_name:setString(conf.Item:getName(v.itemid))
	lab_name:setColor(COLOR[colorlv])

	local btnframe = item:getChildByName("Button_frame_24_0_21")
	btnframe:loadTextureNormal(res.btn.FRAME[colorlv])
	btnframe:setTag(v.itemid)
	btnframe:addTouchEventListener(handler(self,self.onOpenItem))

	local spr = btnframe:getChildByName("Image_22_24_9_47")
	spr:loadTexture(conf.Item:getItemSrcbymid(v.itemid))

	local _img = item:getChildByName("Image_10_50") 
	local _img1 = item:getChildByName("Image_10_0_52")

	local json = ""
	if v.type == 1 then 
		json = res.image.GOLD
	elseif v.type == 2 then 
		json = res.image.ZS
	else
		json = res.image.BADGE
	end 
	_img:loadTexture(json)
	_img1:loadTexture(json)

	local img_z = item:getChildByName("Image_6_56")
	img_z:loadTexture(self.src)

	local _oldtxt = item:getChildByName("txt_name_0_0_37")
	_oldtxt:setString(v.oldprice)

	local _newtxt = item:getChildByName("txt_name_0_0_0_39")
	_newtxt:setString(v.buyprice)

	local btn = item:getChildByName("Button_5_23")
	btn.tag = k
	btn.buy_type = v.type
	btn.price = v.buyprice
	btn:addTouchEventListener(handler(self, self.onbtnBuy))

	if self.data.smdsRank == 1 then 
		if value ~= 0 then 
			btn:setTouchEnabled(false)
			btn:setBright(false)
		else
			btn:setTouchEnabled(true)
			btn:setBright(true)
		end 
	elseif self.data.smdsRank == 2 then 
		if value ~= 0 then 
			btn:setTouchEnabled(false)
			btn:setBright(false)
		else
			btn:setTouchEnabled(true)
			btn:setBright(true)
		end 
	elseif self.data.smdsRank == 3 or self.data.smdsRank == 4 then 
		if value ~= 0 then 
			btn:setTouchEnabled(false)
			btn:setBright(false)
		else
			btn:setTouchEnabled(true)
			btn:setBright(true)
		end 
	elseif self.data.smdsRank == 7 or self.data.smdsRank == 8 or self.data.smdsRank == 5 or self.data.smdsRank == 6 then
		if value ~= 0 then 
			btn:setTouchEnabled(false)
			btn:setBright(false)
		else
			btn:setTouchEnabled(true)
			btn:setBright(true)
		end 
	elseif self.data.smdsRank == 0 then 
		if value ~= 0 then 
			btn:setTouchEnabled(false)
			btn:setBright(false)
		else
			btn:setTouchEnabled(true)
			btn:setBright(true)
		end 
	else
		btn:setTouchEnabled(true)
		btn:setBright(true)
	end
	table.insert(self.buybtnlist,btn)
end
--购买成功
function Contest_shopView:buySuccess(index)
	-- body
	--飘字
	G_TipsOfstr(res.str.BUY_SUCCESS) 
	self.lab_hz:setString(cache.Fortune:getHz())
	--按钮禁用
	for k ,v in pairs(self.buybtnlist) do 
		if tonumber(v.tag) == tonumber(index) then 
			v:setTouchEnabled(false)
			v:setBright(false)
		end 
	end 
end

function Contest_shopView:setData(data)
	-- body

	self.data = data
	self.buybtnlist = {}
	self.panel:removeAllChildren()
	
	local i = 1 
	for k ,v in pairs(data.shopList) do 
		if checknumber(k)~=0 then 
			self:initShopItem(v,k,i)
			i = i +1 
		end 
	end 

	--self:changeTimes()
end


function Contest_shopView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return Contest_shopView

