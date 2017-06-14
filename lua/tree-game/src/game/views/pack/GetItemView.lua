local GetItemView=class("GetItemView",base.BaseView)


function GetItemView:init()
	self.showtype = view_show_type.TOP
	self.view=self:addSelfView()

	self._Image_bg = self.view:getChildByName("Image_bg")
	self._img_title = self._Image_bg:getChildByName("bg_title1")

	self._itemPanel = self.view:getChildByName("Panel")

	self._clonePanel = self.view:getChildByName("Panel_c")

	self._closebtn = self._Image_bg:getChildByName("Button_close")
	
	--self._closebtn = ccui.Helper:seekWidgetByName(self.view,,"Button_close")
	self._closebtn:addTouchEventListener(handler(self,self.onBtnSureCallBack))

	self.Button_buy_more = self._Image_bg:getChildByName("Button_buy_more")
	self.Button_buy_more:addTouchEventListener(handler(self,self.onBtnMoreCallBack))

	local posx,posy = self._img_title:getPosition()
	self.dis = posy -self._Image_bg:getContentSize().height 

	self.per_close_pos =  self._closebtn:getPositionPercent()
	self.per_more_pos =  self.Button_buy_more:getPositionPercent()

	--print("self.per_close_pos "..self.per_close_pos.y)

	--self.dis2 = self._Image_bg:getPositionY() - self._closebtn:getPositionY()
	--print("self.dis2 = "..self.dis2)
	
	--暴击图标
	local bigBang = self._clonePanel:getChildByName("Image_1")
	bigBang:setRotationSkewY(47)
	bigBang:setRotationSkewX(47)
	bigBang:setVisible(false)

	self:initDec()
	
end

function GetItemView:initDec()
	-- body
	self._Image_bg:getChildByName("Button_close"):getChildByName("Text_1_0_6"):setString(res.str.PACK_DEC_07)

	self._Image_bg:getChildByName("Button_buy_more"):getChildByName("Text_1_2"):setString(res.str.PACK_DEC_08)
end

function GetItemView:adjustSize( flag )
	-- body
	self._Image_bg:setContentSize(cc.size(540,459))

	self._closebtn:setPositionPercent(self.per_close_pos)
	self.Button_buy_more:setPositionPercent(self.per_more_pos)

	local posx,posy = self._closebtn:getPosition()
	self._closebtn:setPosition(posx,posy+15)
	posx,posy = self.Button_buy_more:getPosition()
	self.Button_buy_more:setPosition(posx,posy+15)
	
	self._img_title:setPosition(self._img_title:getPosition(),self._Image_bg:getContentSize().height+self.dis)
end
--flag2 是否显示品质框 --flag3 特别显示一件退化
function GetItemView:setData(data,flag,flag2,flag3,baojiVisible)
	--[[data = {}
	for i = 1 , 12 do 
		

		local t = {} 
		t.mId = 221015051
		t.amount = 200
		t.propertys ={}

		table.insert(data,t)
	end]]--

	--local size=10
	--local row=size/2 -- 行
	--local column=   --列
    mgr.Sound:playGetGood()
	self.data = data 
	self._itemPanel:removeAllChildren()
    
	if #self.data <= 4 then 
		self:adjustSize()
		local ccszie = self._itemPanel:getContentSize()
		local y = ccszie.height/2
		local x = 0 
		for k , v in pairs(data) do 
			local panle=CreateClass("views.pack.GetItemPanle")
			panle:init(self)
			self.showPanle = panle
			panle:setData(v,flag,flag2,flag3)

			local w = panle:getContentSize().width*0.95

			if #data == 1 then 
				panle:setPosition(ccszie.width/2,y)
			elseif #data == 2 then 
				panle:setLinevis()
				x = panle:getContentSize().width*(k) +panle:getContentSize().width/2
				panle:setPosition(x, y)
			elseif #data == 3 then 
				panle:setLinevis()
				x = panle:getContentSize().width*(k) --+panle:getContentSize().width/2 
				panle:setPosition(x, y)
			else
				self._Image_bg:setContentSize(cc.size(640,459))
				panle:setLinevis()
				local x = panle:getContentSize().width*(k-1)+panle:getContentSize().width/2
				--local y = ccszie.height/2

				panle:setPosition(x, y)
			end 

			self._itemPanel:addChild(panle)
		end 

		return
	end	

	for i=1,#self.data do
		if i > 12 then
			break
		end
		local panle=CreateClass("views.pack.GetItemPanle")
		panle:init(self)
		panle:setLinevis()
		panle:setData(data[i],flag,flag2,flag3)
		self.showPanle = panle
		local x  = 0 
		local y = 0
		local dx = i%4 == 0 and 4 or   i%4
		if i <=  8 then 
			x = panle:getContentSize().width*(dx-1)+panle:getContentSize().width/2 --*panle:getContentSize().width
		elseif i <= 10	then
			x = panle:getContentSize().width*(dx) +panle:getContentSize().width/2 --*panle:getContentSize().width
		else
			if i == 11 then 
				dx = 1
				x = panle:getContentSize().width*(dx-1)+panle:getContentSize().width/2 --*panle:getContentSize().width
			elseif i == 12 then 
				dx = 4
				x = panle:getContentSize().width*(dx-1)+panle:getContentSize().width/2 --*panle:getContentSize().width
			end
			
		end	
		y =  self._itemPanel:getContentSize().height - math.ceil(i/4)*panle:getContentSize().height+panle:getContentSize().height/2

		panle:setPosition(x,y)
		self._itemPanel:addChild(panle)
	end

end
function GetItemView:setButtonVisible( flag )
	--self._closebtn:setPosition(320,90)

	self._closebtn:setPositionPercent(cc.p(0.5,self.per_close_pos.y))

	local posx,posy = self._closebtn:getPosition()
	self._closebtn:setPosition(posx,posy+15)

	self.Button_buy_more:setVisible(flag)
end


function GetItemView:onBtnMoreCallBack( send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		local ctype = proxy.lucky:getCurBuy_ctype()
		if proxy.lucky:getCurBuy_ctype()>0 then 
			self:onCloseSelfView()
			proxy.lucky:sendMessage(ctype)
			
		end	
		--[[if not G_BuyAnything(2,2520) then 
			return
		end
		proxy.lucky:sendMessage(3)]]--
	end	
end

function GetItemView:onBtnSureCallBack( send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
        local ids = {1007,1037}
        mgr.Guide:continueGuide__(ids)
		self:onCloseSelfView()
	end
end

function GetItemView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

function GetItemView:getClone()
	-- body
	return self._clonePanel:clone() 
end


function GetItemView:setSureBtnTile( title )
	-- body
	self._closebtn:getChildByName("Text_1_0_6"):setString(title)
	self._closebtn:setPosition(self._closebtn:getPositionX(),self._closebtn:getPositionY())
end

return GetItemView