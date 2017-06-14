

local EquitmentJhWidget = require("game.views.equipmentpromote.EquitmentJhWidget")
local EquitmentJhListView = class("EquitmentJhListView",base.BaseView)

function EquitmentJhListView:ctor()
	
	self.super.ctor(self)
	self.HasEquipmentList = {} 
	self.HasEquipmentWidget ={}
end

function EquitmentJhListView:init()
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()
	self.ListView=self.view:getChildByName("ListView_1")
	self.ListView:setTouchEnabled(false)
	self.clone = self.view:getChildByName("Panel_Clone")




	--界面文本
	local bg_2 = self.view:getChildByName("bg_2")
	bg_2:getChildByName("Text_tiitle_2_2"):setString(res.str.EQUIPMENT_DEC11)
	bg_2:getChildByName("Text_tiitle_2_2_0"):setString(res.str.EQUIPMENT_DEC12)
 	self.clone:getChildByName("Button_zb"):setTitleText(res.str.EQUIPMENT_DEC13) 

	--mgr.ViewMgr:setallLayerCansee(false,_viewname.SELECT_EQUIPMENT)
	--self:initListView()
end

function EquitmentJhListView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
    return size
end

function EquitmentJhListView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function EquitmentJhListView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function EquitmentJhListView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function EquitmentJhListView:cellSizeForTable(table,idx) 
	local ccsize = self.clone:getContentSize()    
    return ccsize.height,ccsize.width
end

function EquitmentJhListView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data[idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=EquitmentJhWidget.new(self.clone)  
		--widget:init(self)
		widget:setData(data)
		widget:setHasEquipmentCallBack(handler(self,self.onHasEquitmentCallBack))
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
    else
    	widget = cell:getChildByName("widget")
       	widget:setData(data)
    end

    widget:setHasEuqipment(false)
	if self.nowdata then 
    	if data.index == self.nowdata.index and  data.mId  == self.nowdata.mId then 
    		widget:setHasEuqipment(true)
    	end 
    end 
    return cell
end

function EquitmentJhListView:inittableView()
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
		--self:loadInRunAction()
	end 
end

function EquitmentJhListView:initListView()
	-- body
	self:setTouchEnabled(false) 
	local posx ,posy = self.ListView:getPosition()
	local ccsize =  self.ListView:getContentSize()

	self.lv = cc.ui.UIListView.new {
       -- bgColor = cc.c4b(200, 200, 200, 120),
        --bg = res.image.RED_PONT,
    bgScale9 = true,
    async = true, --异步加载
    viewRect = cc.rect(posx, posy, ccsize.width, ccsize.height),
    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    :onTouch(handler(self, self.touchListener))
    :addTo(self.view,100)
    self.lv:setDelegate(handler(self, self.sourceDelegate))
end



function EquitmentJhListView:sourceDelegate(listView, tag, idx)
	-- body
	if cc.ui.UIListView.COUNT_TAG == tag then
		local size=#self.data
		return size
	elseif  cc.ui.UIListView.CELL_TAG == tag then 
		print("idx ="..idx)
		local item
        local content
        local data = self.data[idx]

        item = self.lv:dequeueItem()

        local function fun(pcontent)
        	-- body
        	pcontent:setHasEuqipment(false)
        	if self.nowdata then 
	        	if data.index == self.nowdata.index and  data.mId  == self.nowdata.mId then 
	        		pcontent:setHasEuqipment(true)
	        	end 
	        end 
        end
        if not item then 
        	item = self.lv:newItem()
        	local content=EquitmentJhWidget.new(self.clone)
        	--content:init(self)
        	content:setData(data)
			content:setHasEquipmentCallBack(handler(self,self.onHasEquitmentCallBack))
        	item:addContent(content)
        	fun(content)
        else
        	content = item:getContent()
        	content:setData(data)
        	fun(content)
        end
        local ccsize = self.clone:getContentSize()
        item:setItemSize(ccsize.width, ccsize.height)
        return item
    else
	end
end


function EquitmentJhListView:onCloseSelfView( )
	-- body
	--self.lv:onCleanup()
	self:closeSelfView()
	--mgr.ViewMgr:setallLayerCansee(true,_viewname.SELECT_EQUIPMENT)
end

function EquitmentJhListView:setData( data,nowqhdata)
	if self.colorlv == nil then 
		debugprint("要设置品质")
		return 
	end 
	self.data = {}
	for k , v in pairs(data) do 
		local colorlv = conf.Item:getItemQuality(v.mId,v.propertys)
		if colorlv == self.colorlv then 
			table.insert(self.data,v)
		end 
	end

	self.nowdata = nowqhdata --当前选中那个
	
	table.sort( self.data, function(a,b)
		-- body
		--local acolorlv = conf.Item:getItemQuality(a.mId,a.propertys)
		--local bcolorlv = conf.Item:getItemQuality(b.mId,b.propertys)

		local apower = mgr.ConfMgr.getPower(a.propertys)
		local bpower = mgr.ConfMgr.getPower(b.propertys)

		if apower == bpower then 
			return a.mId<b.mId
		else
			return apower < bpower 
		end 
	end )
	self:inittableView()
	--self.lv:removeAllItems()
   -- self.lv:onCleanup()	
   	--self.lv:reload()

end

function EquitmentJhListView:Colorlv( lv )
	-- body
	self.colorlv = lv
end


function EquitmentJhListView:onCloseHandler() 
	for i=1,#self.HasEquipmentWidget do
		self.HasEquipmentWidget[i]:release()
	end
	self.super.onCloseHandler(self)
end
--[[function EquitmentJhListView:updateUi(  )
	self.data=cache.Pack:getTypePackInfo(pack_type.EQUIPMENT)
	self.ListView:removeAllChildren()
end]]--

function EquitmentJhListView:onHasEquitmentCallBack(data_)
	local view = mgr.ViewMgr:get(_viewname.EQUIPMENT_QH)

	local qhlv = mgr.ConfMgr.getItemQhLV(data_.propertys)
	local jhlv = mgr.ConfMgr.getItemJh(data_.propertys)

	if qhlv > 0  or jhlv > 0 then
		local data = {};
		data.richtext = {
			{text=res.str.PROMOTEN_DEC1,fontSize=24,color=cc.c3b(255,255,255)},
			{text=string.gsub(res.str.PACK_STRENG," ","") ,fontSize=24,color=cc.c3b(255,0,0)},
			{text=res.str.PROMOTEN_DEC3,fontSize=24,color=cc.c3b(255,255,255)},
			{text=string.gsub(res.str.PACK_REFINING," ",""),fontSize=24,color=cc.c3b(255,0,0)},
			{text=res.str.COMPOSE_EQUIP_DEC2,fontSize=24,color=cc.c3b(255,255,255)},
		};
		data.sure = function( ... )
			-- body
			local view = mgr.ViewMgr:showView(_viewname.TUIVIEW)
			view:setData(data_)
			self:onCloseSelfView()
		end
		data.surestr =  res.str.COMPOSE_EQUIP_SURE
		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,true)
		
		return 
	end

	if  view then
		view:updateLiftFrame(data_)
	end
	self:onCloseSelfView()
end

--[[function EquitmentJhListView:getHasEquipmentData(  )
	local list={}
	local data = cache.Equipment:getEquitpmentDataInfo()
	for k,v in pairs(data) do
		local part = conf.Item:getItemPart(v.mId)
		if part == self.part  then
			list[#list+1]=v
		end
	end
	return list
end]]--














return EquitmentJhListView