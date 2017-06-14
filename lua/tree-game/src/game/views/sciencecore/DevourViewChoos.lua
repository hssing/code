
local DevourViewChoos  = class("DevourViewChoos",base.BaseView)

function DevourViewChoos:ctor()
	--选择列表
	self.SelectPetListData = {}
	--精灵列表
	self.cardList = {}
end

function DevourViewChoos:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.ListView=self.view:getChildByName("ListView_1")
	self.ListView:setTouchEnabled(false)
	self._widgetClone=self.view:getChildByName("Panel_Clone")

	self.view:getChildByName("Button_2"):setTitleText(res.str.COMPOSE_DEC15)
	--界面文本
	self._widgetClone:getChildByName("Button_choose_6"):getChildByName("Text_1_0_9_15"):setString(res.str.COMPOSE_DEC17)

	local bg = self.view:getChildByName("Image_20")
	bg:setTouchEnabled(true)
    G_FitScreen(self,"Image_20")

    mgr.SceneMgr:getMainScene():addHeadView()
    self.maintoplayerview = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	if self.maintoplayerview and  not tolua.isnull(self.maintoplayerview) then
		self.maintoplayerview:setVisible(true)
	end
end

function DevourViewChoos:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
    return size
end

function DevourViewChoos:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function DevourViewChoos:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function DevourViewChoos:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function DevourViewChoos:cellSizeForTable(table,idx) 
	local ccsize = self._widgetClone:getContentSize()    
    return ccsize.height,ccsize.width
end

function DevourViewChoos:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local data =  self.data[idx+1]
    local widget
    if nil == cell then
        cell = cc.TableViewCell:new()
       	widget=CreateClass("views.sciencecore.DevourViewItem")
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

    --[[for k ,value in pairs(self.SelectPetListData) do 
    	if value.index == data.index then
 			widget:setbtGray()
 		end	
    end ]]--

    return cell
end

function DevourViewChoos:inittableView()
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

function DevourViewChoos:setData(data)
	-- body
	self.data = data
	self:inittableView()	
end

function DevourViewChoos:getClone(  )
	-- body
	return self._widgetClone:clone()
end

function DevourViewChoos:onCloseSelfView()
	-- body
	mgr.SceneMgr:getMainScene():closeHeadView()
    self.maintoplayerview = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	if self.maintoplayerview and  not tolua.isnull(self.maintoplayerview) then
		self.maintoplayerview:setVisible(false)
	end
	self:closeSelfView()
end

return DevourViewChoos