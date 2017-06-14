--
-- Author: Your Name
-- Date: 2015-12-17 15:12:09
--
local FruitPageView = class("FruitPageView", base.BaseView)

function FruitPageView:init( )
	self.showtype=view_show_type.TIPS
	self.view=self:addSelfView()

	self.ListGUIButton={}  --GUI按钮容器
	local size=2
	self.btn_panle = self.view:getChildByName("Panel_top")
	self.view:reorderChild(self.btn_panle,200)
	local btn=self.btn_panle:getChildByTag(103)
	btn:setVisible(false)
	for i=1,size do
		local btn=self.btn_panle:getChildByTag(i+100)
		local gui_btn=gui.GUIButton.new(btn,nil,{ImagePath=res.image.RED_PONT,x=10,y=10})

		gui_btn:getInstance():setPressedActionEnabled(false)--guibutton默认点击会缩放，设置点击不需要缩放

		self.ListGUIButton[#self.ListGUIButton+1]=gui_btn
	end

	self.PageButton=gui.PageButton.new()--创建分页按钮管理器
	self.PageButton:setBtnCallBack(handler(self,self.onPageButtonCallBack))
	for i=1,#self.ListGUIButton do
		self.PageButton:addButton(self.ListGUIButton[i]:getInstance())
	end

	--self.listView2 = self.view:getChildByName("ScrollView_3")
	self.scrollView2 = self.view:getChildByName("ScrollView_2")
	self.infoPanel = self.scrollView2:getChildByName("Panel_16")
	self.clonePanel = self.view:getChildByName("Panel_14")
	self.cloneItem = self.view:getChildByName("Panel_15")
	self.listView = self.view:getChildByName("ListView_3")

	self.view:getChildByName("ScrollView_1"):addEventListener(handler(self,self.scrollViewEvent))
	self.view:getChildByName("ScrollView_1"):setSwallowTouches(false)

	self.infoPanel:setSwallowTouches(false)

	self.type = 1
	self.itemList = {}
	

	self.view:reorderChild(self.scrollView2,2000)
	self.view:reorderChild(self.view:getChildByName("Image_52"),1000)
	
	

	mgr.SceneMgr:getMainScene():addHeadView()

	--初始默认设置
	self.cloneItem:getChildByName("Button_15"):setVisible(false)
	self.cloneItem:getChildByName("Image_53"):setVisible(false)
	self.cloneItem:getChildByName("Button_1"):addTouchEventListener(handler(self,self.goCompose))
	self.cloneItem:getChildByName("Button_1").state = 0--0未开启,1已开启未合成，2已合成
	self.cloneItem:getChildByName("Button_15"):setEnabled(false)

	self.view:reorderChild(self.view:getChildByName("Button_close"),300)


	---界面文本
	self.ListGUIButton[1]:getInstance():setTitleText(res.str.FRUIT_DESC1)
	self.ListGUIButton[2]:getInstance():setTitleText(res.str.FRUIT_DESC2)
	--self.ListGUIButton[3]:getInstance():setTitleText(res.str.FRUIT_DESC3)

	--信息面板
	self.infoPanel:getChildByName("Image_24"):getChildByName("Text_10"):setString(res.str.FRUIT_DESC4)
	self.infoPanel:getChildByName("Image_24_0"):getChildByName("Text_10_34"):setString(res.str.FRUIT_DESC5)
	self.infoPanel:getChildByName("Text_37"):setString(res.str.FRUIT_DESC6)

	--inittableView
	--proxy.Fruit:reqFruitinfo(1, 1)
end

function FruitPageView:setFidx( fidx )
	-- body
	self.fIdx = fidx
	self.PageButton:initClick(1)
	--G_TipsOfstr(self.fIdx)
end


function FruitPageView:setData( data )
	if data.pageType ~= self.type then
		return
	end

	--self:inittableView()
	--self.listView:removeAllItems()
	self.data = data
	self.conf = conf.Fruit:getData()
	self.fruitMap = self.data.fruitMap
	local atackPower = self.infoPanel:getChildByName("Image_24"):getChildByName("Text_32")
	local process = self.infoPanel:getChildByName("Image_24_0"):getChildByName("Text_32_36")

	--属性
	atackPower:setString(data.atk)
	process:setString(data.schedule .. "%")
	self.infoPanel:getChildByName("Image_24"):getChildByName("Text_10"):setString(res.str.FRUIT_PAGE_PRO[self.type])
	--self.infoPanel:getChildByName("Image_24_0"):getChildByName("Text_10_34"):setString(res.str.FRUIT_DESC5)
	self:setRedPoint(self.data.redMap)
	self:inittableView()
	if self.offSet then
		self.tableView:setContentOffset(self.offSet, false)
	end


end

function FruitPageView:setRedPoint( map )
	for i=1,#self.ListGUIButton do
		local num = 0
		if map[i ..""] > 0 then
			num = -1
		end
		self.ListGUIButton[i]:setNumber(num)
	end
end



function FruitPageView:openNext( key )
	local tmp = self.itemList[key].data.open_hole
	--开放同阶的下一个孔
	if tmp then
		local key2 = tmp[1]
		self.itemList[key2]:getChildByName("Button_15"):setVisible(true)
		self.itemList[key2]:getChildByName("Image_53"):setVisible(false)
		self.itemList[key2]:getChildByName("Button_1").state = 1

	end
	-- --开放下一阶一个孔
	if tmp and key % 10 == 1  then --第一个完成，开放下一个
		local key2 = tmp[1]
		if #tmp >= 2 then
		      key2 = tmp[2]
		end
		self.itemList[key2]:getChildByName("Button_15"):setVisible(true)
		self.itemList[key2]:getChildByName("Image_53"):setVisible(false)
		self.itemList[key2]:getChildByName("Button_1").state = 1
	end
end




--合成成功
function FruitPageView:composeCallback( data )

	G_TipsOfstr(res.str.FRUIT_DESC18)

	local atackPower = self.infoPanel:getChildByName("Image_24"):getChildByName("Text_32")
	local process = self.infoPanel:getChildByName("Image_24_0"):getChildByName("Text_32_36")

	atackPower:setString(data.atk)
	process:setString(data.schedule .. "%")


	 --红点
	  local num = 0
	  if data.pageRed > 0 then
	  	num = -1
	  end
	  self.ListGUIButton[self.type]:setNumber(num)

	  local view = mgr.ViewMgr:get(_viewname.FORMATION)
		if view then
			view:setFruitRedpoint()
		end

	-- --遍历后端数据，看看那些是已合成
	 self.fruitMap = data.fruitMap
	 --self.fruitMap._size = nil

	 self:inittableView()
	 if self.offSet then
	 	self.tableView:setContentOffset(self.offSet, false)
	 end
	 
	 
end


function FruitPageView:forever( item )
	-- body
	-- local params =  {id=404826, x=item:getContentSize().width/2,
	-- y=item:getContentSize().height/2,addTo=item, playIndex=4}
	-- mgr.effect:playEffect(params)
	-- local params =  {id=404803, x=item:getContentSize().width/2,
	-- 	y=item:getContentSize().height/2,
	-- 	addTo=item,endCallFunc=nil,from=nil,to=nil, playIndex=0,addName = "effofname"}
	-- 	mgr.effect:playEffect(params)
end




--分页按钮回调
function FruitPageView:onPageButtonCallBack( index,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		self.type = index
		self.listView:removeAllItems()
		proxy.Fruit:reqFruitinfo(self.fIdx,self.type)
		--mgr.NetMgr:wait(525001)
		self.offSet = nil

		return self
	end
end

--进入合成界面
function FruitPageView:goCompose( send,etype )
	if etype == ccui.TouchEventType.ended then
		local view = mgr.ViewMgr:showView(_viewname.FRUIT_COMPOSE)
		local data = send:getParent().data
		data.state =  send.state
		data.fIdx = self.fIdx
		view:setData(data)

		self.offSet = self.tableView:getContentOffset()
		--保存跳转界面信息
		local data2  = {}
		data2.formationView = true
		data2.fIdx =self.fIdx--阵型位
		data2.extData = data--合成界面所需的数据
		data2.selectedPage = self.type--分页类型
		data2.offset = self.offSet--记住跳转是选择的阶数
		cache.Player:saveMaterialJumpData(data2)

		

	end
end

function FruitPageView:onCloseSelfView(  )
	-- body
	mgr.SceneMgr:getMainScene():closeHeadView()

	self:closeSelfView()
end


function FruitPageView:scrollViewEvent(sender, evenType)
    if evenType == ccui.ScrollviewEventType.scrollToBottom then

    elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then

    elseif evenType == ccui.ScrollviewEventType.scrolling then
--     	local layout = sender:getInnerContainer()
-- 		local x,y = layout:getPosition()
-- --		print(self.height,y,-self.height + 150)
-- 		if self.height < 0 then
-- 			return
-- 		end
		
-- 		if y >= -self.height and y <= -self.height + 200 then
-- 			local percent = (self.height + y) /200 * 100

-- 			if percent <= 10 then
-- 				percent = 0
-- 			elseif percent >= 90 then
-- 				percent = 100
-- 			end
-- 			self.scrollView2:scrollToPercentVertical(percent,0.1,true)
-- 		end
		
    end
end



function FruitPageView:createItem( i )
	local data = conf.Fruit:getDataByIdxPageStep(0,self.type,i)
		local clonePanel = self.clonePanel:clone()
		clonePanel:setSwallowTouches(false)
		for j=1,#data do
			local item = self.cloneItem:clone()
			local listView = clonePanel:getChildByName("ListView_4")
			listView:pushBackCustomItem(item)
			listView:setSwallowTouches(false)
			item.data = data[j]
			self.itemList[tostring(data[j].id)] = item
			item:getChildByName("Button_1"):addTouchEventListener(handler(self,self.goCompose))
			item:getChildByName("Button_1").state = 0--0未开启,1已开启未合成，2已合成

			item:getChildByName("Button_1"):setSwallowTouches(false)
			item:setSwallowTouches(false)
			item:getChildByName("Button_15"):setSwallowTouches(false)
		end

		local stepPanel = clonePanel:getChildByName("Panel_25")
		local fontName = "res/views/ui_res/imagefont/font_fruit_num.png"
		local jie = ccui.ImageView:create("res/views/ui_res/imagefont/font_fruit_step.png")

		if i < 10 then
			local geImg = cc.LabelAtlas:_create(i ,fontName,26,45,string.byte("."))
			geImg:setAnchorPoint(0.5,0.5)
			geImg:setPosition(stepPanel:getContentSize().width / 2-15,stepPanel:getContentSize().height / 2 - 10)
			stepPanel:addChild(geImg)
			stepPanel:addChild(jie)
			jie:setPosition(stepPanel:getContentSize().width / 2+15, stepPanel:getContentSize().height / 2)
		else
			local tenWei = math.floor(i / 10) 
			local geWei = i % 10
			local tenImg = cc.LabelAtlas:_create(tenWei ,fontName,26,45,string.byte("."))
			local geImg = cc.LabelAtlas:_create(geWei ,fontName,26,45,string.byte("."))
			stepPanel:addChild(tenImg)
			stepPanel:addChild(geImg)
			tenImg:setAnchorPoint(0.5,0.5)
			geImg:setAnchorPoint(0.5,0.5)
			tenImg:setPosition(stepPanel:getContentSize().width / 2-30, stepPanel:getContentSize().height / 2 - 10)
			geImg:setPosition(stepPanel:getContentSize().width / 2-10, stepPanel:getContentSize().height / 2 - 10)
			jie:setPosition(stepPanel:getContentSize().width / 2+15, stepPanel:getContentSize().height / 2)
			stepPanel:addChild(jie)
		end


--101010201
	-- --遍历后端数据，看看那些是已合成
	--local fruitMap = self.data.fruitMap--各个孔的状态信息
	self.fruitMap._size = nil
	 for k,v in pairs(self.fruitMap) do
	 		
	 	local key = tonumber(k) % 1000000 + 100000000
	 		key = tostring(key)
	 	if self.itemList[key] ~= nil  then
	 		if v == 0 then
			self.itemList[key]:getChildByName("Button_15"):setVisible(true)
			self.itemList[key]:getChildByName("Image_53"):setVisible(false)
			self.itemList[key]:getChildByName("Button_1").state = 1
			local path = res.btn.FRAME[conf.Fruit:getFrameColor(key)]
			self.itemList[key]:getChildByName("Button_1"):loadTextureNormal(path)
			self:forever(self.itemList[key])

			local a1 = cc.FadeOut:create(0.5)
			local a2 = cc.FadeIn:create(0.5)
			local s = cc.Sequence:create(a1,a2)
			self.itemList[key]:getChildByName("Button_15"):runAction(cc.RepeatForever:create(s))

			elseif v > 0 then
				self.itemList[key]:getChildByName("Button_15"):setVisible(false)
				local path = res.btn.FRAME[conf.Fruit:getFrameColor(key)]
				self.itemList[key]:getChildByName("Button_1"):loadTextureNormal(path)
				self.itemList[key]:getChildByName("Image_53"):setVisible(true)
				local path1 = "res/itemicon/%s.png"
				--self.itemList[key]:getChildByName("Image_53"):ignoreContentAdaptWithSize(true)
				print(string.format(path1, self.itemList[key].data.id))
				self.itemList[key]:getChildByName("Image_53"):loadTexture(string.format(path1, self.itemList[key].data.fruit_icon))
				--self.itemList[key]:getChildByName("Image_53"):ignoreContentAdaptWithSize(true)
				self.itemList[key]:getChildByName("Button_1").state = 2

			--self:openNext(key)

			end
		 end


		
	  end
		self.itemList = {}

		--clonePanel:getChildByName("Image_21"):loadTexture(string.format("res/views/ui_res/imagefont/font_fruit_%dstep.png",i)) 
		--self.listView:pushBackCustomItem(clonePanel)
		--self.height = self.height + clonePanel:getContentSize().height

	return clonePanel
end





function FruitPageView:inittableView(listView,ccsize)
	-- body
	--print("kaishi ="..os.time())
	if not self.tableView then 
		local posx ,posy = self.listView:getPosition()
		local ccsize =  self.listView:getContentSize() 
		self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	    self.tableView:setPosition(cc.p(posx, posy))
	    self.tableView:setDelegate()
	    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	    self.view:addChild(self.tableView,100)
	
	    self.tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView) ,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --tableView个数
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)           --滚动  
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)				--放大
	    self.tableView:registerScriptHandler(handler(self, self.tableCellTouched),cc.TABLECELL_TOUCHED)						--点击	
	    self.tableView:registerScriptHandler(handler(self, self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)				--xiao	
	    self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)  
	    self.tableView:reloadData()

	 else  
	    self.tableView:reloadData()
	end 
	--print("end ="..os.time())
	
end


--------------------------TableVIew

function FruitPageView:numberOfCellsInTableView(iTable)
	-- body
	--local size=#self.Data[self.packindex]
    return conf.Fruit:getStepNum(0,self.type)
end

function FruitPageView:scrollViewDidScroll(view)
  local percent = -view:getContentOffset().y / (view:getContentSize().height -self.listView:getContentSize().height)  * 100
   percent = 100 - percent
  self.scrollView2:scrollToPercentVertical(percent,0.1,true)


end

function FruitPageView:scrollViewDidZoom(view)
	
   -- print("scrollViewDidZoom")
end

function FruitPageView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end


function FruitPageView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePanel:getContentSize()
    return ccsize.height,ccsize.width
end

function FruitPageView:tableCellAtIndex(table, idx)
	
    local strValue = string.format("%d",idx)
    -- print("index "..strValue .." time" ..os.time())
    local cell = table:dequeueCell()
    local item
    if nil == cell then
        cell = cc.TableViewCell:new()
    else
       local item = cell:getChildByName("item")
       item:removeFromParent()
    end

     local item = self:createItem( idx + 1 )
     item:setTouchEnabled(true)
     --item:setEnabled(false)
     item:setSwallowTouches(false)
     item:setAnchorPoint(0,0)
     item:setPosition(5,0)
     cell:addChild(item)
     item:setName("item")

    

    return cell
end


function FruitPageView:jumpBack( idx,fIdx,offset )
	self.fIdx = fIdx--阵型位置
	self.PageButton:initClick(idx)
	self.offSet = offset
	
end








return FruitPageView