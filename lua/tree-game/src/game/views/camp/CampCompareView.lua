--[[
	查看阵营
]]
local CampCompareView = class("CampCompareView",base.BaseView)

function CampCompareView:init()
	-- body
	self.showtype=view_show_type.TOP
    self.view=self:addSelfView()

    self.camp  = {}
    local t  = {}
    t.fenshu = self.view:getChildByName("Text_13")
    t.renshu = self.view:getChildByName("Text_13_1")
    table.insert(self.camp,t)
    self.color1 = t.fenshu:getColor()
    local t  = {}
    t.fenshu = self.view:getChildByName("Text_13_0")
    t.renshu = self.view:getChildByName("Text_13_0_0")
    table.insert(self.camp,t)
    self.color2 = t.fenshu:getColor()
    G_FitScreen(self,"Image_bg")

    self.p1 = self.view:getChildByName("Panel_1"):getChildByName("Panel_1_1")
    self.p2 = self.view:getChildByName("Panel_1"):getChildByName("Panel_1_2")
    self.item = self.view:getChildByName("Panel_3")

    local btn = self.view:getChildByName("Button_6")
    btn:addTouchEventListener(handler(self,self.onbtnClose))
end

function CampCompareView:onbtnClose( sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end
end

function CampCompareView:getLeftPanel( )
	-- body
	return self.p1
end

function CampCompareView:getRightPanle()
	-- body
	return self.p2
end

function CampCompareView:getCloneItem()
	-- body
	return self.item:clone()
end

function CampCompareView:initData(id)
	-- body
	local widget = self.camp[id]
	local data = cache.Camp:getDataBycamp(id)

	widget.fenshu:setString(res.str.DEC_ERR_55..data.campScore) 
	widget.renshu:setString(res.str.DEC_ERR_58..":"..data.campPlayerCount) 	
end

function CampCompareView:setData()
	-- bodyp
	self.data = cache.Camp:getInfoData()

	self:initData(1)
	self:initData(2)

	if self.data.jusList then
		self:inittableView()
	end

	if self.data.eviList then 
		self:inittableView1()
	end 
end
-------------------------------------------------------------------------------------------------
function CampCompareView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data.jusList
	--print("size = "..size)
    return size
end
function CampCompareView:scrollViewDidScroll(view)
end
function CampCompareView:scrollViewDidZoom(view)
end
function CampCompareView:tableCellTouched(table,cell)
   print("cell touched at index: " .. cell:getIdx())
end 
function CampCompareView:cellSizeForTable(table,idx) 
	local ccsize = self.item:getContentSize()    
    return ccsize.height + 10 ,ccsize.width
end

function CampCompareView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data.jusList[idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.camp.CampJustListItem")  
		widget:init(self)
		widget:setData(data,self.color1)
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
       -- widget:setTextColor(self.color1) 
        widget:addTo(cell)
    else
    	widget = cell:getChildByName("widget")
       	widget:setData(data,self.color1)
       --	widget:setTextColor(self.color1)
    end

    if idx + 2>#self.data.jusList then 
    	--print("#self.data.jusList = "..#self.data.jusList)
    	self.justidx = idx
    	if not self.juslistpage then 
    		self.juslistpage = 2
    	else
    		self.juslistpage = self.juslistpage + 1
    	end
    	local data = { type = 1 , page = self.juslistpage}
    	proxy.Camp:send120103(data)
       -- mgr.NetMgr:wait(520103)
    end 
    return cell
end

function CampCompareView:inittableView()
	-- body
	if not self.tableView then 
		local posx ,posy = self.p1:getPosition()
		local ccsize =  self.p1:getContentSize() 

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
	    self.tableView:reloadData()
	else
		self.tableView:reloadData()
	end 

	if self.justidx then 
		local num = math.ceil(self.p1:getContentSize().height/self.item:getContentSize().height)
		if  self.justidx < num then 
			return 
		end 
		
		local offset = {
			x = 0 ,
			y = (self.justidx+1) * self.item:getContentSize().height  - self.tableView:getContentSize().height	  
		}
		self.tableView:setContentOffset(offset)
	end 
end
--********************************************************************************************************************
function CampCompareView:numberOfCellsInTableView1(table)
	-- body
	local size=#self.data.eviList
	--print("size = "..size)
    return size
end
function CampCompareView:scrollViewDidScroll1(view)
end
function CampCompareView:scrollViewDidZoom1(view)
end
function CampCompareView:tableCellTouched1(table,cell)
   print("cell touched at index: " .. cell:getIdx())
end 
function CampCompareView:cellSizeForTable1(table,idx) 
	local ccsize = self.item:getContentSize()    
    return ccsize.height + 10 ,ccsize.width
end

function CampCompareView:tableCellAtIndex1(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data.eviList[idx+1]
    --print("strValue="..strValue)
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.camp.CampJustListItem")  
		widget:init(self)
		widget:setData(data,self.color2)
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:setTextColor(self.color2)
        widget:addTo(cell)
    else
    	widget = cell:getChildByName("widget")
    	--widget:setTextColor()
       	widget:setData(data,self.color2)
    end

    if idx + 2>#self.data.eviList then 
    	--print("#self.data.eviList = "..#self.data.eviList)
    	self.eviidx = idx
    	if not self.evitpage then 
    		self.evitpage = 2
    	else
    		self.evitpage = self.evitpage + 1
    	end
    	local data = { type = 2 , page = self.evitpage}
    	proxy.Camp:send120103(data)
    	--mgr.NetMgr:wait(520103)
    end 
    return cell
end

function CampCompareView:inittableView1()
	-- body
	if not self.tableView1 then 
		local posx ,posy = self.p2:getPosition()
		local ccsize =  self.p2:getContentSize() 

		self.tableView1 = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	    self.tableView1:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	    self.tableView1:setPosition(cc.p(posx, posy))
	    self.tableView1:setDelegate()
	    self.tableView1:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	    self.view:addChild(self.tableView1,100)
	    --registerScriptHandler functions must be before the reloadData funtion
	    self.tableView1:registerScriptHandler(handler(self, self.numberOfCellsInTableView1) ,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --tableView个数
	    self.tableView1:registerScriptHandler(handler(self, self.scrollViewDidScroll1),cc.SCROLLVIEW_SCRIPT_SCROLL)           --滚动  
	    self.tableView1:registerScriptHandler(handler(self, self.scrollViewDidZoom1),cc.SCROLLVIEW_SCRIPT_ZOOM)				--放大
	    self.tableView1:registerScriptHandler(handler(self, self.tableCellTouched1),cc.TABLECELL_TOUCHED)						--点击	
	    self.tableView1:registerScriptHandler(handler(self, self.cellSizeForTable1),cc.TABLECELL_SIZE_FOR_INDEX)				--xiao	
	    self.tableView1:registerScriptHandler(handler(self, self.tableCellAtIndex1),cc.TABLECELL_SIZE_AT_INDEX)               --添加
	    self.tableView1:reloadData()
	else
		self.tableView1:reloadData()
	end 

	if self.eviidx then 
		local num = math.ceil(self.p2:getContentSize().height/self.item:getContentSize().height)
		if  self.eviidx < num then 
			return 
		end 
		
		local offset = {
			x = 0 ,
			y = (self.eviidx+1) * self.item:getContentSize().height  - self.tableView1:getContentSize().height	  
		}
		self.tableView1:setContentOffset(offset)
	end 
end


function CampCompareView:onCloseSelfView()
	-- body
	self:closeSelfView()
end
return CampCompareView