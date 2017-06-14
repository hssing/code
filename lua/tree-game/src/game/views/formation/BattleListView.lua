local BattleListView=class("BattleListView",base.BaseView)

function BattleListView:init()
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.Panel_Clone=self.view:getChildByName("Panel_Clone")
	self.ListView=self.view:getChildByName("ListView_1")
	self.ListView:setTouchEnabled(false)
	self.ListView:setVisible(false)
	--向下的箭头
	local down = self.view:getChildByName("other_arrow_1")
	self.view:reorderChild(down,200) --让箭头在ListView 上面
	
	---
	self.CheckBox=self.view:getChildByName("bg_2"):getChildByName("CheckBox_1")
	self.CheckBox:setTouchEnabled(true)
	self.CheckBox:addEventListener(handler(self,self.onCheckBoxCallBack))
	--保存已出站数据
	self.BattleListData={} 
	--
	self.pageindex = 2--默认隐藏上阵的人
	--[[mgr.ViewMgr:setallLayerCansee(false,_viewname.BATTLE_LIST)
	self:initListView()]]--
	
	G_FitScreen(self, "Image_2")

	self.title = self.view:getChildByName("bg_2"):getChildByName("Text_tiitle")
	local view = mgr.ViewMgr:get(_viewname.CHANGE_FORMATION)
	local view1 =  mgr.ViewMgr:get(_viewname.PETDETAIL)
	if view or view1 then 
		self.CheckBox:setVisible(false)
		self.title:setVisible(false)
	else
		self.CheckBox:setVisible(true)
		self.title:setVisible(true)
	end

	self:initDec()
end

function BattleListView:initDec()
	-- body
	self.title:setString(res.str.DUI_DEC_06)
end

function BattleListView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data[self.pageindex]
	return size
end

function BattleListView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function BattleListView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function BattleListView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function BattleListView:cellSizeForTable(table,idx) 
	local ccsize = self.Panel_Clone:getContentSize()    
    return ccsize.height,ccsize.width
end

function BattleListView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    
    local cell = table:dequeueCell()
    local data = self.data[self.pageindex][idx+1]

    if nil == cell then
        cell = cc.TableViewCell:new()
        local widget=CreateClass("views.formation.BattleWidget")
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
        widget:init(self)
        widget:setData(data,self.pos,self.type)
        widget.battpos = conf.Item:getBattleProperty(data)
    else
    	local widget = cell:getChildByName("widget")
        widget:setData(data,self.pos,self.type)
        widget.battpos = conf.Item:getBattleProperty(data)
    end
    return cell
end

function BattleListView:inittableView()
	-- body
	if not  self.tableView then 
		local posx ,posy = self.ListView:getPosition()
		local ccsize =  self.ListView:getContentSize() 

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
	self.tableView:reloadData()
end

function BattleListView:getWidgetClone()
	return self.Panel_Clone:clone()
end

function BattleListView:sortselfdata( data )
	-- body
	table.sort( data, function( a,b )
		-- body
		local apos  = conf.Item:getBattleProperty(a)
		apos = apos ==0 and apos or -1  
		local bpos = conf.Item:getBattleProperty(b)
		bpos = bpos ==0 and bpos or -1

		local apower = mgr.ConfMgr.getPower(a.propertys)
		local bpower =  mgr.ConfMgr.getPower(b.propertys)
 		if  apos == bpos then 
 			if apower == bpower then 
 				return a.mId<b.mId
 			else
 				return apower>bpower
 			end 
 		else
 			return apos < bpos
 		end	
	end )
end

function BattleListView:setData(pos,stype)
	-- body
	self.pos=pos
	self.type = stype
	local data = cache.Pack:getTypePackInfo(pack_type.SPRITE)
	self.data={
		{},
		{}
	}

	

	local onBattle = {}
	for k ,v in pairs(data) do 
		local onpos = conf.Item:getBattleProperty(v)
		local type_id = conf.Item:getItemConf(v.mId).type_id
		if onpos > 0 then 
			if not onBattle[type_id] then 
				onBattle[type_id] = true
			end
		else
			if v.propertys[317] and v.propertys[317].value > 0 then
				onBattle[type_id] = true
			end
		end 
	end 

	for k , v in pairs(data) do 
		local onpos = conf.Item:getBattleProperty(v)
		local type_id = conf.Item:getItemConf(v.mId).type_id
		if onpos < 1 then -- 
			if not onBattle[type_id] then --屏蔽同类卡牌
				table.insert(self.data[1],v) --没有上阵的人
				table.insert(self.data[2],v)
			end 
		else 
			table.insert(self.data[1],v) 
		end 
	end



	self:sortselfdata(self.data[1])
	self:sortselfdata(self.data[2])

	self:inittableView()
end

function BattleListView:onCloseSelfView()
	-- body
	--self.lv:onCleanup()
	self:closeSelfView()
	--mgr.ViewMgr:setallLayerCansee(true,_viewname.BATTLE_LIST)
end

function BattleListView:onCheckBoxCallBack(send,eventype)
	if eventype == 0 then  --勾选
		self:hidePet()
	else--不勾选
		self:showPet()
	end
end

--隐藏上阵
function BattleListView:hidePet()
	-- body
	--self.lv:removeAllItems()
	--self.lv:reload()
	--[[self.data = {}
	self.data = self.noOnBattle
	self:sortselfdata()]]--
	self.pageindex = 2
	self:inittableView()
end
--显示上阵
function BattleListView:showPet()
	-- body
	--[[table.merge(self.data, self.onBattle)
	self:sortselfdata( )]]--
	self.pageindex = 1
	self:inittableView()
end
	--self.lv:removeAllItems()
	--self.lv:reload()
--end













--------------------------------------------------------------------------------------------
--[[function BattleListView:onCheckBoxCallBack(send,eventype)
	if eventype == 0 then  --勾选
		self:hidePet()
	else--不勾选
		self:showPet()
	end
end

function BattleListView:hidePet(  )
	for i=1,#self.BattleListData do
		self.BattleListData[i]:removeFromParent()
	end

end
function BattleListView:showPet(  )
	for i=1,#self.BattleListData do
		self.ListView:insertCustomItem(self.BattleListData[i],0)
	end
end
function BattleListView:initList(data)

	--self:setInnerContainerSize(10*packpanle:getContentSize().height)
end
function BattleListView:setData(pos)
	self.pos=pos
	--self:initList(cache.Pack:getTypePackInfo(pack_type.SPRITE))
	self:updateUi()
end
function BattleListView:updateUi(  )
	self.data=cache.Pack:getTypePackInfo(pack_type.SPRITE)

	self.ListView:removeAllChildren()
	
	local table_sort={}
	for k,v in pairs(self.data) do
		table_sort[#table_sort+1]=v
	end
	table_sort[#table_sort+1]=v


	table.sort(table_sort,function ( a,b )
		return mgr.ConfMgr.getPower(a.propertys) > mgr.ConfMgr.getPower(b.propertys)
	end)
	for i=1,#table_sort do
		local packpanle=CreateClass("views.formation.BattleWidget")
		packpanle:init(self)
		-- packpanle:setPositionY(i*packpanle:getContentSize().height)
		packpanle:setData(table_sort[i],self.pos)
		if conf.Item:getBattleProperty(table_sort[i])> 0 then
			packpanle:retain()
			self.BattleListData[#self.BattleListData+1]= packpanle
		else
			self.ListView:pushBackCustomItem(packpanle)
		end	
	end
end

function BattleListView:onCloseHandler() 
	for i=1,#self.BattleListData do
		self.BattleListData[i]:release()
	end
	self.super.onCloseHandler(self)
end
function BattleListView:changeData( data )


end]]--














return BattleListView