local CompseChooseView  = class("CompseChooseView",base.BaseView)

function CompseChooseView:ctor()
	self.super.ctor(self)
	--选择列表
	self.SelectPetListData = {}
	--精灵列表
	self.cardList = {}
	--装备列表
	self.equipList = {}
end

function CompseChooseView:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.ListGUIButton={}  --GUI按钮容器
	local size=2
	for i=1,size do
		local btn=self.view:getChildByTag(i)
		local gui_btn=gui.GUIButton.new(btn,nil,{ImagePath=res.image.RED_PONT,x=10,y=10})

		gui_btn:getInstance():setPressedActionEnabled(false)--guibutton默认点击会缩放，设置点击不需要缩放

		self.ListGUIButton[#self.ListGUIButton+1]=gui_btn
	end

	self.PageButton=gui.PageButton.new()--创建分页按钮管理器
	self.PageButton:setBtnCallBack(handler(self,self.onPageButtonCallBack))
	for i=1,#self.ListGUIButton do
		self.PageButton:addButton(self.ListGUIButton[i]:getInstance())
	end

	self.ListView=self.view:getChildByName("ListView_1")
	self.ListView:setTouchEnabled(false)
	self._widgetClone=self.view:getChildByName("Panel_Clone")

	--self:setTouchEnabled(false)
	
	--mgr.SceneMgr:getMainScene():addHeadView()
	--self:initListView()


	--界面文本
	self.ListGUIButton[1]:getInstance():setTitleText(res.str.COMPOSE_DEC15)
	self.ListGUIButton[2]:getInstance():setTitleText(res.str.COMPOSE_DEC16)
	self._widgetClone:getChildByName("Button_choose_6"):getChildByName("Text_1_0_9_15"):setString(res.str.COMPOSE_DEC17)

	local bg = self.view:getChildByName("Image_20")
	bg:setTouchEnabled(true)
    G_FitScreen(self,"Image_20")
end

function CompseChooseView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
    return size
end

function CompseChooseView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function CompseChooseView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function CompseChooseView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function CompseChooseView:cellSizeForTable(table,idx) 
	local ccsize = self._widgetClone:getContentSize()    
    return ccsize.height,ccsize.width
end

function CompseChooseView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local data =  self.data[idx+1]
    local widget
    if nil == cell then
        cell = cc.TableViewCell:new()
       	widget=CreateClass("views.compose.ComposeItem")
       	widget:init(self)
        widget:setData(data)
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
    else
    	widget = cell:getChildByName("widget")
        widget:setData(data)
    end

    for k ,value in pairs(self.SelectPetListData) do 
    	if value.index == data.index then
 			widget:setbtGray()
 		end	
    end 

    return cell
end

function CompseChooseView:inittableView()
	-- body
	if not  self.tableView then 
		local posx ,posy = self.ListView:getPosition()
		local ccsize =  self.ListView:getContentSize() 

		self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	    self.tableView:setPosition(cc.p(posx, posy))
	    self.tableView:setDelegate()
	    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	    self:addChild(self.tableView,100)
	    --registerScriptHandler functions must be before the reloadData funtion
	    self.tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView) ,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --tableView个数
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)           --滚动  
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)				--放大
	    self.tableView:registerScriptHandler(handler(self, self.tableCellTouched),cc.TABLECELL_TOUCHED)						--点击	
	    self.tableView:registerScriptHandler(handler(self, self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)				--xiao	
	    self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)               --添加
	    self.tableView:reloadData()
	else
		self.tableView:reloadData()
	end 
end

function CompseChooseView:sourceDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
    	local size=#self.data
        return size
    elseif cc.ui.UIListView.CELL_TAG == tag then
   		--print("idx "..idx)
        local item
        local content
      	item = self.lv:dequeueItem()
        local v = self.data[idx]
        if not item then
            item = self.lv:newItem()
            local widget=CreateClass("views.compose.ComposeItem")
            widget:init(self)
            widget:setData(v)
			content = widget
			item:addContent(content)
        else
            content = item:getContent()
            content:setData(v)
        end
        for k ,value in pairs(self.SelectPetListData) do 
        	if value.index == v.index then
	 			content:setbtGray()
	 		end	
        end 

        local ccsize = self:getClone():getContentSize()       
        item:setItemSize(ccsize.width, ccsize.height)
        return item
    else
    end
end


--type = nil 两种类型都显示 type = 1 显示装备类型 type == 3 显示卡牌类型
function CompseChooseView:btncall( type )
	-- body
	if type then
		if type == 1 then 
			--self.view:reorderChild(self.btn_panle,200)
			self.ListGUIButton[1]:getInstance():setVisible(false)
			self.ListGUIButton[2]:getInstance():setPosition(self.ListGUIButton[1]:getInstance():getPosition())
			self.PageButton:initClick(2)
		else
			self.ListGUIButton[2]:getInstance():setVisible(false)
			self.PageButton:initClick(1)
		end	
	else
		self.PageButton:initClick(1)
	end
end

--传入已经选
function CompseChooseView:setSelectPetListData( data)
	self.SelectPetListData =  data
end

function CompseChooseView:setCardList( data ,color)
	-- body
	if not color then 
		--self.cardList = data
		if data then
			for k ,v in pairs(data) do
				for i = 1 , #v do 
					if v[i].propertys[317] and v[i].propertys[317].value >0 then
					else
						table.insert(self.cardList,v[i])
					end
					
				end	
			end 
		end
	else
		self.cardList = {}
		--if data[color] then self.cardList = data[color] end)
		if data[color] then
			for k ,v in pairs(data[color]) do 
				if v.propertys[317] and v.propertys[317].value >0 then
				else
					table.insert(self.cardList,v)
				end
			end
		end

	end	

	--print("setCardList ".. #self.cardList)	
end

function CompseChooseView:setEquiplist( data ,color)
	-- body
	if not color then 
		--self.equipList = data
		for k ,v in pairs(data) do
			for i = 1 , #v do  
				table.insert(self.equipList,v[i])
			end	
		end 
	else
		if data[color] then self.equipList = data[color] end
	end	
	--print("setEquiplist ".. #self.equipList)	
end


function CompseChooseView:initAllPanle( index )
	-- body
	self.data = index == 1 and self.cardList or self.equipList

	self:inittableView()	
end

function CompseChooseView:getClone(  )
	-- body
	return self._widgetClone:clone()
end


function CompseChooseView:onPageButtonCallBack(index,eventtype)
	-- body
	if index == 1 then
		debugprint("精灵按钮按下")
	else
		debugprint("装备按钮按下")
	end
	--self:initListView()
	self:initAllPanle(index)
	return self
end

function CompseChooseView:selePage(index)
	-- body
	self.PageButton:initClick(index)
end

function CompseChooseView:setLowStart( flag )
	-- body
	self.low = flag
end

function CompseChooseView:getLowStart( ... )
	-- body
	return self.low
end

function CompseChooseView:onCloseSelfView()
	-- body
	local view=mgr.ViewMgr:get(_viewname.COMPOSE)
	if view then 
		view:removeFromWidge()
	end
	self:closeSelfView()
end

return CompseChooseView