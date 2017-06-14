local ShopView  = class("ShopView",base.BaseView)

function ShopView:init(index)
	--self.ShowAll=true
	
	--proxy.shop:sendMessage(0)
	
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	self.ListGUIButton={}  --GUI按钮容器
	local size=4
	self.btn_panle = self.view:getChildByName("Panel_1")
	self.view:reorderChild(self.btn_panle,200)
	for i=1,size do
		local btn=self.btn_panle:getChildByTag(i)
		local gui_btn=gui.GUIButton.new(btn,nil,{ImagePath=res.image.RED_PONT,x=10,y=10})

		gui_btn:getInstance():setPressedActionEnabled(false)--guibutton默认点击会缩放，设置点击不需要缩放

		self.ListGUIButton[#self.ListGUIButton+1]=gui_btn
	end

	self.PageButton=gui.PageButton.new()--创建分页按钮管理器
	self.PageButton:setBtnCallBack(handler(self,self.onPageButtonCallBack))
	for i=1,#self.ListGUIButton do
		self.PageButton:addButton(self.ListGUIButton[i]:getInstance())
	end


	--神秘商店才显示的控件
	
	--self.PanleShengmi:setVisible(false)
	self.panleVisible = self.view:getChildByName("Panel_for_Shen")
	self.PanleShengmi = self.panleVisible:getChildByName("Panel_18")
	self.PanleShengmi:setTouchEnabled(false)
	--刷新次数
	self.textCishu = self.panleVisible:getChildByName("Text_count")
	self.textTime = self.panleVisible:getChildByName("txt_shuaxin_timess")
	--神秘商店 物品item
	self.clonePanelShenmi = self.view:getChildByName("Panel_4")
	--快速刷新按钮
	self.btnShuxin = self.panleVisible:getChildByName("Button_11")
	self.btnShuxin:addTouchEventListener(handler(self,self.onBtnReflahCallBack))
	--self.btnShuxin:setEnabled(false)
	--self.btnShuxin:setBright(false)
	--黑市货币
	self.Djheishi = self.panleVisible:getChildByName("Text_1_1")
	----道具和礼包试用的是List
	self.ListView=self.view:getChildByName("ListView")
	self.ListView:setVisible(false)
	self.ListView:setTouchEnabled(false)
	--道具和礼包 物品item
	self.clonelistItem = self.view:getChildByName("Panel_Clone")
	self.ccszie1 = self.clonelistItem:getContentSize()
	--
	self.otherline = self.view:getChildByName("other_line_3")

	--充值 界面专用
	self._r_ListView=self.view:getChildByName("ListView_1") 
	self._r_ListView:setTouchEnabled(false)
	self._r_ListView:setVisible(false)
	self._img_bg=self.view:getChildByName("img_recharge") 
	self._img_double = self.view:getChildByName("Image_2")
	

	self._p_first = self.view:getChildByName("Panel_Clone_0_0")
	self._p_recharge = self.view:getChildByName("Panel_Clone_0")

	--VIP特权切面跳转
	self.btnvip = self._img_bg:getChildByName("Button_4")
	self.btnvip:addTouchEventListener(handler(self,self.onBtnVipCallBack))

	self.packindex= index and index or 1;
	

	self:setData(cache.Shop:getShopInfo())
	self.PageButton:initClick(self.packindex)
	-- body
	--
	self.idx = 0

	local Panel_1 = self.view:getChildByName("Panel_1")
	self.view:reorderChild(Panel_1,500)
	self.view:reorderChild(self._img_double,500)

	
	self:setRedPoint()
	self:schedule(self.schedulerlastTime,1.0,"schedulerlastTime")

	if res.banshu then 
		self._img_double:setVisible(false)
		self.ListGUIButton[4]:getInstance():setVisible(false)
	end 

	self:initDec()	

	self:performWithDelay(function( ... )
			self:playerForever()
	end, 0.1)
end

function ShopView:initDec()
	-- body
	self.panleVisible:getChildByName("Text_1"):setString(res.str.SHOP_DEC_09)
	self.panleVisible:getChildByName("Text_1_0"):setString(res.str.SHOP_DEC_10)
	self.panleVisible:getChildByName("Button_11"):setTitleText(res.str.SHOP_DEC_11)
	self.panleVisible:getChildByName("txt_shuaxin_dec"):setString(res.str.SHOP_DEC_19)
	self.panleVisible:getChildByName("Text_30_0_0"):setString(res.str.SHOP_DEC_20)
	self.panleVisible:getChildByName("Text_30_0_1"):setString(res.str.SHOP_DEC_21)


	self.btn_panle:getChildByTag(1):setTitleText(res.str.SHOP_DEC_12)
	self.btn_panle:getChildByTag(2):setTitleText(res.str.SHOP_DEC_13)
	self.btn_panle:getChildByTag(3):setTitleText(res.str.SHOP_DEC_14)
	self.btn_panle:getChildByTag(4):setTitleText(res.str.SHOP_DEC_15)

	self._img_bg:getChildByName("Text_2"):setString(res.str.SHOP_DEC_16)
	self._img_bg:getChildByName("Button_4"):setTitleText(res.str.SHOP_DEC_17)
	self._img_bg:getChildByName("Text_4"):setString(res.str.SHOP_DEC_18)

	self._p_first:getChildByName("Button_Using_26_7_11"):setTitleText(res.str.SHOP_DEC_22)

end

function ShopView:setRedPoint()
	-- body
	--print("cache.Player:getDoubleRecharge() = "..cache.Player:getDoubleRecharge())
	if cache.Player:getDoubleRecharge()>0 then 
		self._img_double:setVisible(true)
	else
		self._img_double:setVisible(false)
	end
end

function ShopView:playerForever( ... )
	-- body
	local params =  {id=404810, x=self._img_double:getContentSize().width/2+4
	,y=self._img_double:getContentSize().height/2-3,addTo=self._img_double
	,from=nil,to=nil, playIndex=0,addName = "adv"}
	mgr.effect:playEffect(params)
end

function ShopView:initClickPage( packindex_ )
	-- body
	if packindex_ == self.packindex then 
		return
	end 
	self.PageButton:initClick(packindex_)
end

function ShopView:numberOfCellsInTableView(table)
	-- body
	local size=#self.Data[self.packindex]
    return size
end

function ShopView:scrollViewDidScroll(view)

   -- print("scrollViewDidScroll")
   self:removefirget()
end

function ShopView:scrollViewDidZoom(view)
	
   -- print("scrollViewDidZoom")
end

function ShopView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end


function ShopView:cellSizeForTable(table,idx) 
	--print(4)
	local ccsize =self.ccszie1-- self.ccszie1 --self.ccszie1   
    return ccsize.height-8,ccsize.width
end

function ShopView:tableCellAtIndex(table, idx)
	
    local strValue = string.format("%d",idx)
    -- print("index "..strValue .." time" ..os.time())
    local cell = table:dequeueCell()
    local widget
    local data= self.Data[self.packindex][idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget = CreateClass("views.shop.ShopPanle")     
		widget:init(self,self.packindex)
		widget:setData(data,self.packindex,idx)
		widget:setCallBack(handler(self, self.onidxCallback))
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(5, 0))
        widget:setName("widget")
        widget:addTo(cell)
		--[[if  cache.Player:getFirst40303()>0  and self.packindex == 4 then 
			widget:setDoubleImg()--不显示双倍图片
        end	]]--
    else
    	widget = cell:getChildByName("widget")
        widget:setData(data,self.packindex,idx)
        --[[if  cache.Player:getFirst40303()>0  and self.packindex == 4 then 
			widget:setDoubleImg()--不显示双倍图片
        end	]]--
    end
    --self.idx = idx  
    --print(self.idx)
    return cell
end

function ShopView:onidxCallback( id )
	-- body
	--debugprint(" self.idx ===== "..id)
	self.idx = id
end


function ShopView:inittableView(listView,ccsize,idx)
	-- body
	--print("kaishi ="..os.time())
	if not self.tableView then 
		local posx ,posy = listView:getPosition()
		--local ccsize =  listView:getContentSize() 

		self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	    self.tableView:setPosition(cc.p(posx, posy))
	    self.tableView:setDelegate()
	    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	    self.view:addChild(self.tableView,100)
	    --registerScriptHandler functions must be before the reloadData funtion
	    self.tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView) ,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --tableView个数
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)           --滚动  
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)				--放大
	    self.tableView:registerScriptHandler(handler(self, self.tableCellTouched),cc.TABLECELL_TOUCHED)						--点击	
	    self.tableView:registerScriptHandler(handler(self, self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)				--xiao	
	    self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)               --添加
	end 
	--print("end ="..os.time())
	self.tableView:reloadData()

	if idx then 
		local num = math.ceil(self.ListView:getContentSize().height/(self.ccszie1.height-8))
		if  idx < num then 
			return 
		end 

		local offset = {
			x = 0 ,
			y = (idx+1) * (self.ccszie1.height-8)  - self.tableView:getContentSize().height	+   self.ccszie1.height/2
		}
		--printt(offset)
		self.tableView:setContentOffset(offset)
	end 

end

function ShopView:onBtnReflahCallBack(send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		--刷新神秘商店
		local sendmType = 1
		local time = cache.Shop:getlastTime()-(os.time()- cache.Shop:getRecordTime())--时间刷新
		if time == 0 then 
			sendmType = 1
		elseif cache.Pack:getItemAmountByMid(pack_type.PRO,221015101)>0 then  -- 黑市道具ID then
			sendmType = 3 
		else
			sendmType = 2
		end	
		--砖石不足 tips
		if (sendmType == 2 and cache.Fortune:getFortuneInfo().moneyZs<10) then 
			G_TipsForNoEnough(sendmType)
			return 
		end

		proxy.shop:send105003(sendmType)

	end	
end

function ShopView:loadItemData(type,data,index,i)
	--data.index_=index
	if  i then
 		table.insert(self.Data[type],i,data)
 	else
 		table.insert(self.Data[type],data)
	end
end

function ShopView:initDta()
	self.Data={}
	self.Data[1] = {};--神秘商店物品
	self.Data[2]={}--道具商店物品
	self.Data[3]={}--VIP礼包
	self.Data[4] = {}
end

function ShopView:initRechargeData( data )
	-- body
	self:initDta()

	--local data = cache.Shop:getRechargeList()
	self.Data[4] = clone(cache.Shop:getRechargeList())
	table.sort( self.Data[4] , function ( a,b )
		-- body
		return a.moneyZs > b.moneyZs
	end )
end

function ShopView:setData( data )
	-- body 往self.Data 填充数据
	self:initDta()
	for k,v in pairs(data) do
		for k1,v1 in pairs(data[k]) do
			self:loadItemData(k,v1)
		end
	end
end



function ShopView:loadShengMi()
	local ccsize = self.PanleShengmi:getContentSize();
	for i = 1, #self.Data[1] do
		if i>8 then 
			break;
		end
		local data = self.Data[1][i]

		local shoppanle=CreateClass("views.shop.ShopPanleShengMi")
		shoppanle:init(self,i,ccsize,self.packindex)
		shoppanle:setData(data)

		local y  = i<=4 and 2 or 1
		local x  = i%4==0 and 4  or i%4;
		x = ccsize.width/8*(2*x-1)
		y = ccsize.height/4*(2*y-1)

		shoppanle:setPosition(x,y)
		self.PanleShengmi:addChild(shoppanle)
	end	
end

function ShopView:getColnePnale()
	-- body
	return self.clonePanelShenmi:clone()
end

function ShopView:getColnePnaleItem()
	-- bodyself.
	return self.clonelistItem:clone()
end

function ShopView:getColneRechargeItem()
	-- body
	return self._p_recharge:clone()
end


function ShopView:setTime( time )
	-- body
	self.textTime:setString(string.formatNumberToTimeString(time))
end

function ShopView:schedulerlastTime()
	-- body
	 
	if cache.Shop:getlastTime() and cache.Shop:getRecordTime() then
		--if cache.Shop:getRecordTime() > 0 and cache.Shop:getlastTime() > 0 then 
			--local time = cache.Shop:getlastTime()-(os.time()- cache.Shop:getRecordTime())
			local time =  cache.Shop:getlastTime()
			self:setTime(time)
			if time <= 0 then 
				if not self.send then --在这个界面只发送一次
					local __reqdata = {
					mType = 1,
					}
					mgr.NetMgr:send(105003,__reqdata)
					self.send = true
					--print("105003 ")
				end 
			end
			
		--end
	end
	
end

function ShopView:setCount( count )
	-- body
	self.textCishu:setString(count)
end

function ShopView:DiffentShow(flag)
	local tf = true;
	if flag then 
		tf = false
	end

	self.PanleShengmi:setVisible(flag)
	self.panleVisible:setVisible(flag)

	--self.ListView:setVisible(tf)
	self.otherline:setVisible(tf)

	self._r_ListView:setVisible(false)
	self._img_bg:setVisible(false)
	-- body
end

function ShopView:onBtnVipGetCallBack( send, eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		debugprint("领取首次充值奖励")
		proxy.shop:sendGetfirst()
	end
end

function ShopView:onOpenItem( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		G_openItem(self.data.mId)
	end
end

function ShopView:onOpenItemlocal( send,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--G_openItem(send:getTag())
		local mId = send:getTag()
		local type = send.type
		local data = { mId =  mId,propertys={}  }

		if type ==  pack_type.PRO then
			G_openItem(data.mId)
		elseif  type  == pack_type.EQUIPMENT then 
			G_OpenEquip(data,true)
		else	
			G_OpenCard(data,true)
		end
	end
end

function ShopView:initRecharge()
	-- body
	local imgCurVip = self._img_bg:getChildByName("img_vip_big")
	local imgnextvip = self._img_bg:getChildByName("img_vip_xiao")

	local loadBar = self._img_bg:getChildByName("LoadingBar_1")

	local dec = self._img_bg:getChildByName("Text_2")
	local icon = self._img_bg:getChildByName("img_zs")
	local txt_more = self._img_bg:getChildByName("txt_more")

	local _vipexp =  self._img_bg:getChildByName("exp")

	local curvip = cache.Player:getVip() 
	--print("curvip = "..curvip)
	curvip = curvip == 0 and 1 or curvip
 	local path = res.icon.VIP_LV[curvip]

	local max = #res.icon.VIP_LV
	if curvip  == 0 then 
		imgCurVip:setVisible(false)
	else
		imgCurVip:loadTexture(res.icon.VIP_LV[curvip])
	end
	if curvip >= max then 
		imgnextvip:setVisible(false)
	else
		imgnextvip:loadTexture(res.icon.VIP_LV[curvip+1])
	end

	local vipexp = cache.Player:getVipExp()
	local dd = curvip >= max and max or curvip+1
	local nextneedexp = conf.Recharge:getNextExp(dd)
	--print("curvip "..curvip)
	--print("nextneedexp "..nextneedexp)
	txt_more:setVisible(true)
	icon:setVisible(true)
	dec:setVisible(true)
	_vipexp:setString(vipexp.."/"..nextneedexp)
	if nextneedexp then 
		if nextneedexp - vipexp <= 0 then 
			loadBar:setPercent(100)
			txt_more:setVisible(false)
			icon:setVisible(false)
			dec:setVisible(false)
			_vipexp:setString(vipexp.."/"..nextneedexp)
		else
			icon:setVisible(true)
			txt_more:setString(string.format(res.str.SHOP_RECHARGE,nextneedexp-vipexp))
			loadBar:setPercent(vipexp*100/nextneedexp)
		end	
	else
		txt_more:setVisible(false)
		icon:setVisible(false)
		dec:setVisible(false)
		loadBar:setPercent(100)
	end	

	local w  = txt_more:getContentSize().width
	local posx = txt_more:getPosition()+w+imgnextvip:getContentSize().width*imgnextvip:getScaleX()/2
	imgnextvip:setPositionX(posx)

	local texx =  self._img_bg:getChildByName("Text_4")
	texx:setVisible(false)

	--[[if not cache.Shop:getIsRechargeFirst() then
		self._img_double:setVisible(true)
	else
		self._img_double:setVisible(false)
	end ]]--

	if cache.Player:getFirst40303() <2 then --是否领取
		texx:setVisible(true)
		--debugprint("显示2倍")
		--self._img_double:setVisible(true)
		local posx , posy = self._r_ListView:getPosition()
		if self.content then 
			self.content:removeFromParent() 
			self.content = nil;
		end	

		self.content = self._p_first:clone()
		self.content:setVisible(true)
		self.content:setPosition(posx+5,posy+self._r_ListView:getContentSize().height-self.content:getContentSize().height)
		local btn = self.content:getChildByName("Button_Using_26_7_11")
		btn:addTouchEventListener(handler(self,self.onBtnVipGetCallBack))
		self.view:addChild(self.content)

		for i = 1 , 4 do 
			local BtnFrame = self.content:getChildByName("Button_frame"..i)
			BtnFrame:setVisible(false)
		end

		local tab = conf.Sys:getValue("vip_first_reward")
		--local tab = conf.Recharge:getFirstreward()
		if tab then 
			for k ,v in pairs(tab) do
				--debugprint(" **** 首次充值奖励" .. v[1])
				v.mid = v[1]
				local type=conf.Item:getType(v.mid)
				local lv=conf.Item:getItemQuality(v.mid)
				local name=conf.Item:getName(v.mid)
				local path=conf.Item:getItemSrcbymid(v.mid)
				if not itemSrc then 
					--debugprint(" **** 没有配置 src ***" .. v.mid)
				end
				if type == pack_type.SPRITE then
					local propertys= v.propertys and v.propertys or {}
					local jj =  propertys[307] and propertys[307].value or 1
					jj = math.max(jj,1)
					local card_id=conf.Item:getCardId(v.mid,jj)
					name=conf.Card:getName(card_id)
				end

				local BtnFrame = self.content:getChildByName("Button_frame"..k)
				BtnFrame:setTag(v.mid)
				BtnFrame.type = type
				BtnFrame:setVisible(true)
				BtnFrame:addTouchEventListener(handler(self,self.onOpenItemlocal))
				local LabName = BtnFrame:getChildByName("Txt_name"..k)
				local img = BtnFrame:getChildByName("img_head"..k)

				local framePath=res.btn.FRAME[lv]
				BtnFrame:loadTextureNormal(framePath)
				LabName:setColor(COLOR[lv])
				LabName:setString(name.."x"..v[2])
				img:loadTexture(path)
			end	
		end	
	end	
end

function ShopView:onBtnVipCallBack( send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		--print("change to vip")
		mgr.ViewMgr:showView(_viewname.VIP)
	end
end

function ShopView:initAllPanle(index,idx)
	-- body

	if (index == 2 or index ==3)  and (self.packindex == 4 or self.packindex == 1) then 
		if self.tableView then 
			self.tableView:removeFromParent()
			self.tableView = nil 
		end 
	elseif index == 4 then 
		if self.tableView then 
			self.tableView:removeFromParent()
			self.tableView = nil 
		end 
	elseif index == 1 then 
		if self.tableView then 
			self.tableView:removeFromParent()
			self.tableView = nil 
		end 
	end 

	self.packindex = index

	

	if self.content then 
		self.content:removeFromParent() 
		self.content = nil;
	end	

	self.PanleShengmi:removeAllChildren()
	self:DiffentShow(false)
	if self.packindex == 2 or 3 == self.packindex  then --道具 vip 
		--self:initListView(self.ListView,self.ListView:getContentSize())
		--self.lv:reload()
		self:inittableView(self.ListView,self.ListView:getContentSize())
		--点击道具商店
        if self.packindex == 2 then
            local ids = {1017, 1031}
            mgr.Guide:continueGuide__(ids)
            mgr.Sound:playViewDaojushangdian()
        elseif self.packindex == 3 then
            
        end
	elseif self.packindex == 4 then
		self._img_bg:setVisible(true)
		self.otherline:setVisible(false)
		self:setRedPoint()
		self:initRecharge()
		local ccsize  = self._r_ListView:getContentSize()
		if self.content then 
			ccsize.height = ccsize.height - self.content:getContentSize().height 
		end	
		self:inittableView(self._r_ListView,ccsize,idx)
		--self:initListView(self._r_ListView,ccsize)
		
		--self.lv:reload()
	else
		self:DiffentShow(true)
		local count = cache.Pack:getItemAmountByMid(pack_type.PRO,221015101 )
		self.Djheishi:setString("0");
		--print("count = "..count)
		if count~=nil then 
			self.Djheishi:setString(count);
		end	
		count = cache.Shop:gettodayCount();
		if count ~= nil then  
			self:setCount(count)
		end

		local time =  cache.Shop:getlastTime()
		if time then 
			self:setTime(time)
		end 

		self:loadShengMi()
		
        --神秘商店
        local ids = {1054}
        mgr.Guide:continueGuide__(ids)
	end
end

function ShopView:onPageButtonCallBack( index,eventype )
	if eventype == ccui.TouchEventType.ended then
		if res.banshu  then --or g_recharge
   			if index == 4 then 
   				G_TipsOfstr(res.str.ROLE_GONGHUI)
   				return 
   			end 
   		end 

   		if index == 1 then 
   			mgr.Sound:playViewShenmishangdian()
   		end 

   		if index < 4 then 
   			proxy.shop:sendMessage(index)
   		else 
   			proxy.shop:sendRechargeList()
   		end 

		self:initAllPanle(index)
		return self
	end
end

function ShopView:onCloseSelfView(  )
    --关闭
    local ids = {1034}
    mgr.Guide:continueGuide__(ids)
    G_mainView()
	--mgr.SceneMgr:getMainScene():changeView( 1)
end
--如果有数据
function ShopView:updateShop(index,reqdata)
	-- body
	self:setData(cache.Shop:getShopInfo())
	if index and index==2 and self.packindex == index then 

		self:updtebuySucc(index,reqdata)
		return 
	end	
	self:initAllPanle(self.packindex)
end

function ShopView:updtebuySucc( index,reqdata )
	-- body
	if self.tableView then 
		self.tableView:reloadData()
	end 	

	if self.idx then 
		local num = math.ceil(self.ListView:getContentSize().height/(self.ccszie1.height-8))
		if  self.idx < num then 
			return 
		end 

		local offset = {
			x = 0 ,
			y = (self.idx+1) * (self.ccszie1.height-8)  - self.tableView:getContentSize().height	  
		}
		--printt(offset)
		self.tableView:setContentOffset(offset)
	end 
end

function ShopView:removefirget()
	-- body
	if self.firget_armature and not tolua.isnull(self.firget_armature) then
		self.firget_armature:removeSelf()
		self.firget_armature = nil 
	end
end

function ShopView:toConfGold(gold)
	-- body
	if self.packindex == 4 then
		local index = 0
		for k , v in pairs(self.Data[4]) do 
			if tonumber(v.moneyZs) == tonumber(gold) then
				index = k -1
				break
			end
		end
		local num = math.ceil(self.ListView:getContentSize().height/(self.ccszie1.height-8))
		local offset = {
			x = 0 ,
			y = (index + 1 ) * (self.ccszie1.height-8)  - self.tableView:getContentSize().height	  
		}
		--printt(offset)
		self.tableView:setContentOffset(offset)
		local cell = self.tableView:cellAtIndex(index)
		if cell then
			local widget = cell:getChildByName("widget")
			if widget then
				local pos = widget:getOnlyFirger()
				--widget:setOnlyFirger()
				local params =  {id=404816, x=pos.x ,y=pos.y ,addTo=self.view, playIndex=0
				,loadComplete = function ( var  )
					-- body
					self.firget_armature = var
				end}
				mgr.effect:playEffect(params)
			end
		end

	end
end

function ShopView:updateChongzhi( price )
	-- body
	if self.packindex ~= 4 then 
		return 
	end 
	--双倍图表不要
	local index = 1
	for k , v  in pairs(self.Data[4]) do 
		if v.moneyRmb == price then 
			index = k-1
			break
		end 
	end 

	proxy.shop:sendRechargeList(index)


	--[[self:setRedPoint()
	self:initRechargeData()
	--self._img_double:setVisible(false)

	self:initAllPanle(4)
	self:setRedPoint()
	local index = 1
	for k , v  in pairs(self.Data[4]) do 
		if v.moneyRmb == price then 
			index = k-1
			break
		end 
	end 

	local num = math.ceil(self.ListView:getContentSize().height/(self.ccszie1.height-8))
	if  index < num then 
		return 
	end 

	local offset = {
		x = 0 ,
		y = (index+1) * (self.ccszie1.height-8)  - self.tableView:getContentSize().height	+   self.ccszie1.height/2
	}
	--printt(offset)
	self.tableView:setContentOffset(offset)]]--
end

return ShopView