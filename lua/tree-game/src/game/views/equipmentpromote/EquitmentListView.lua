

local EquitmentWidget = require("game.views.equipmentpromote.EquitmentWidget")
local EquitmentListView = class("EquitmentListView",base.BaseView)

function EquitmentListView:ctor()
	
	self.super.ctor(self)
	self.HasEquipmentList = {} 
	self.HasEquipmentWidget ={}
end

function EquitmentListView:init()
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()
	self.ListView=self.view:getChildByName("ListView_1")
	self.ListView:setTouchEnabled(false)
	self.CheckBox=self.view:getChildByName("bg_2"):getChildByName("CheckBox_1_2")
	self.CheckBox:addEventListener(handler(self,self.onCheckBoxCallBack))
	self.clone = self.view:getChildByName("Panel_Clone")

	local down = self.view:getChildByName("Image_34")
	self.view:reorderChild(down,500)
	--mgr.ViewMgr:setallLayerCansee(false,_viewname.EQUIPMENT)
	--self:initListView()

	self.pageindex = 2

	--界面文本
	self.view:getChildByName("bg_2"):getChildByName("Text_tiitle_2"):setString(res.str.EQUIPMENT_DEC14) 
	self.clone:getChildByName("Button_zb"):setTitleText(res.str.EQUIPMENT_DEC15)

	
    G_FitScreen(self, "bg_factory")
end

function EquitmentListView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data[self.pageindex]
    return size
end

function EquitmentListView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function EquitmentListView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function EquitmentListView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function EquitmentListView:cellSizeForTable(table,idx) 
	local ccsize = self.clone:getContentSize()    
    return ccsize.height+5,ccsize.width
end

function EquitmentListView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data[self.pageindex][idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=EquitmentWidget.new(self.clone)    
		--widget:init(self)
		widget:setData(data)
		widget:setHasEquipmentCallBack(handler(self,self.onHasEquitmentCallBack))
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
        widget.index = data.index
    else
    	widget = cell:getChildByName("widget")
      	widget:setData(data)
      	widget.index = data.index
		widget:setHasEquipmentCallBack(handler(self,self.onHasEquitmentCallBack))
    end
    return cell
end

function EquitmentListView:inittableView()
	-- body
	if not self.tableView then 
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
	    self.tableView:reloadData()
	    --self:loadInRunAction()
	else
		self.tableView:reloadData()
		---self:loadInRunAction()
	end 
end


function EquitmentListView:onCloseSelfView()
	-- body
	for i=1,#self.HasEquipmentWidget do
		self.HasEquipmentWidget[i]:release()
	end
	--self.lv:onCleanup()
	self:closeSelfView()
	--mgr.ViewMgr:setallLayerCansee(true,_viewname.EQUIPMENT)
end



function EquitmentListView:sourceDelegate(listView, tag, idx)
	-- body
	if cc.ui.UIListView.COUNT_TAG == tag then
		local size=#self.data
		return size
	elseif  cc.ui.UIListView.CELL_TAG == tag then 
		local item
        local content
        local data = self.data[idx]
        if self.CheckBox:isSelected() and data.index > 400000 then
        	return item
        end
        item = self.lv:dequeueItem()
        if not item then 
        	item = self.lv:newItem()
        	local content=EquitmentWidget.new(self.clone)
        	content:setData(data)
			--content:setHasEuqipment(true)
			content:setHasEquipmentCallBack(handler(self,self.onHasEquitmentCallBack))
        	item:addContent(content)
        else
        	content = item:getContent()
        	content:setData(data)
        	content:setHasEquipmentCallBack(handler(self,self.onHasEquitmentCallBack))
			--content:setHasEuqipment(true)
        end
      
        local ccsize = self.clone:getContentSize()
        item:setItemSize(ccsize.width, ccsize.height)
        return item
    else
	end
end

function EquitmentListView:sortdata( data  )
	-- body
	table.sort(data,function( a,b )
		-- body
		local abatt = a.index>400000 and 1 or 0 
		local bbatt = b.index>400000 and 1 or 0 

		local acolorlv = conf.Item:getItemQuality(a.mId)
		local bcolorlv = conf.Item:getItemQuality(b.mId)

		local apower = mgr.ConfMgr.getPower(a.propertys)
        local bpower = mgr.ConfMgr.getPower(b.propertys)


		if abatt == bbatt then 
			if acolorlv == bcolorlv then 
				if apower == bpower then 
					return a.mId<b.mId
				else
					return apower > bpower
				end 
			else
				return acolorlv>bcolorlv
			end 
		else
			return abatt > bbatt 
		end 
	end)
end

function EquitmentListView:setData( pos)
	print("pos = "..pos)
	self.pos=pos
	self.part=self.pos%10

	self.data = {
		{},
		{}
	}
	local data = self:getHasEquipmentData()
	local data1 = cache.Pack:getTypePackInfo(pack_type.EQUIPMENT)
	for k ,v in pairs(data) do 
		if conf.Item:getItemPart(v.mId) == self.part then 
			table.insert(self.data[1],v)
			--break
		end 
	end 

	for k , v in pairs (data1) do 
		if conf.Item:getItemPart(v.mId) == self.part then 
			table.insert(self.data[1],v)
			table.insert(self.data[2],v)
		end 
	end 

	self:sortdata(self.data[1])
	self:sortdata(self.data[2])
	
	self:inittableView()

end
function EquitmentListView:onCheckBoxCallBack(send,eventype)
	if eventype == 0 then  --勾选
		self:hideEquipment()
	else--不勾选
		self:showEquipment()
	end
end
function EquitmentListView:hideEquipment()
	self.pageindex = 2
	self:inittableView()

end
function EquitmentListView:showEquipment(  )
	self.pageindex = 1
	self:inittableView()
end



function EquitmentListView:onHasEquitmentCallBack(data)
	--print("self.pos = "..self.pos)
	--print("data.index = "..data.index)
	proxy.Equipment:reqWearEquipment(self.pos,data.index)

	local view=mgr.ViewMgr:get(_viewname.EQUIPMENT_MESSAGE)
	if view then
		view:onCloseSelfView()
	end
	self:onCloseSelfView()
end

function EquitmentListView:getHasEquipmentData(  )
	local list={}
	local data = cache.Equipment:getEquitpmentDataInfo()
	for k,v in pairs(data) do
		local part = conf.Item:getItemPart(v.mId)
		if part == self.part then
			--print("wo jiu cao le ")
			list[#list+1]=v
		end
	end
	return list
end














return EquitmentListView