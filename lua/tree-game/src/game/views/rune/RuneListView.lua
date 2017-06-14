local RuneListView = class("RuneListView",base.BaseView)

function RuneListView:init()
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.ListView=self.view:getChildByName("ListView_1")
	self.ListView:setTouchEnabled(false)

	self.CheckBox=self.view:getChildByName("bg_2"):getChildByName("CheckBox_1_2")
	self.CheckBox:addEventListener(handler(self,self.onCheckBoxCallBack))

	self.clone = self.view:getChildByName("Panel_Clone")

	local down = self.view:getChildByName("Image_34")
	self.view:reorderChild(down,500)

	self:initDec()
	G_FitScreen(self, "bg_factory")

	self.pageindex = 2 --默认看隐藏的--
	self:setData()
end

function RuneListView:setSomething()
	-- body
	--self.CheckBox:setVisible(false)
	--self.dec:setVisible(false)
end

function RuneListView:getClone( ... )
	-- body
	return self.clone:clone()
end

function RuneListView:initDec()
	-- body
	self.dec = self.view:getChildByName("bg_2"):getChildByName("Text_tiitle_2")
	self.dec:setString(res.str.EQUIPMENT_DEC14) 
	self.clone:getChildByName("Button_zb"):setTitleText(res.str.DEC_NEW_11)
end

function RuneListView:sortdata( data )
	-- body
	table.sort(data,function( a,b )
		-- body
		local abatt = a.index>600000 and 1 or 0 
		local bbatt = b.index>600000 and 1 or 0 

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

function RuneListView:setData()
	-- body
	self.data = { {},{} }
	local data_1 = cache.Rune:getUseinfo()
	local data_2 = cache.Rune:getPackinfo()
	if data_1 then 
		for k , v in pairs(data_1) do 
			table.insert(self.data[1],v)
		end
	end
	if data_2 then
		for k ,v in pairs(data_2) do 
			table.insert(self.data[1],v)
			table.insert(self.data[2],v)
		end
	end

	self:sortdata(self.data[1])
	self:sortdata(self.data[2])
	self:inittableView()
end

function RuneListView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data[self.pageindex]
    return size
end

function RuneListView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function RuneListView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function RuneListView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function RuneListView:cellSizeForTable(table,idx) 
	local ccsize = self.clone:getContentSize()    
    return ccsize.height+5,ccsize.width
end

function RuneListView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data[self.pageindex][idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
       	widget=CreateClass("views.rune.runeItem")
       	widget:init(self)
        widget:setData(data)
        --widget:setHasEquipmentCallBack(handler(self,self.onHasEquitmentCallBack))
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
       
    else
    	widget = cell:getChildByName("widget")
        widget:setData(data)
        --widget:setHasEquipmentCallBack(handler(self,self.onHasEquitmentCallBack))
    end
    return cell
end

function RuneListView:setWearpos( pos )
	-- body
	self.pos = pos
end


function RuneListView:onHasEquitmentCallBack(data)
	local param
	if data.index < 600000 then
		param = {index = self.pos , toIndex =data.index , opType = 1 }
		for k ,  v in pairs(self.data[1]) do  --如果穿戴的位置有装备 要用替换
			if v.index == self.pos then
				param.opType = 3
			end
		end
	else
		param = {index = self.pos , toIndex =data.index , opType = 3 }
	end
	proxy.Rune:send120201(param)
	mgr.NetMgr:wait(520201)

	local view=mgr.ViewMgr:get(_viewname.RUNE_MSG)
	if view then
		view:onCloseSelfView()
	end
	self:onCloseSelfView()
end

function RuneListView:inittableView()
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


function RuneListView:hideEquipment()
	self.pageindex = 2
	self:inittableView()

end
function RuneListView:showEquipment(  )
	self.pageindex = 1
	self:inittableView()
end

function RuneListView:onCheckBoxCallBack( sender,eventtype )
	-- body
	if eventtype == ccui.CheckBoxEventType.selected then
		self:hideEquipment()
	else--不勾选
		self:showEquipment()
	end
end



return RuneListView

