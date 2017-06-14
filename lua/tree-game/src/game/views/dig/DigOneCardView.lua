--[[
	DigOneCardView 数码兽选	
]]

local DigOneCardView = class("DigOneCardView",base.BaseView)

function DigOneCardView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	G_FitScreen(self, "Image_1")

	self.panle_fortable = self.view:getChildByName("Panel_1") 
	self.cloneitem = self.view:getChildByName("Panel_Clone") 

	self.view:reorderChild(self.panle_fortable,501)

	local btn_close = self.view:getChildByName("Panel_3"):getChildByName("Button_10")
	btn_close:addTouchEventListener(handler(self, self.onbtnbtnClose))

	--self:setData()

	--界面文本
	self.cloneitem:getChildByName("Button_Using_33"):setTitleText(res.str.DIG_DEC44)



end

function DigOneCardView:onbtnbtnClose(send,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end 
end

function DigOneCardView:setData()
	-- body
	local t = table.values(cache.Pack:getTypePackInfo(pack_type.SPRITE))
	self.data ={}
	for k , v in pairs(t) do 
		if not cache.Dig:isMid(v.mId) then 
			table.insert(self.data,v)
		end 
	end 
	table.sort(self.data,function(a,b)
		-- body
		return a.propertys[305].value>b.propertys[305].value
	end)
	self:inittableView()
end

function DigOneCardView:getColnePnaleItem()
	-- GuildBenQuRank
	return self.cloneitem:clone()
end

function DigOneCardView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
	--debugprint("size = "..size)
    return size
end

function DigOneCardView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function DigOneCardView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function DigOneCardView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end 

function DigOneCardView:cellSizeForTable(table,idx) 
	local ccsize = self.cloneitem:getContentSize()    
    return ccsize.height,ccsize.width
end

function DigOneCardView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data[idx+1]
   -- print("strValue="..strValue)
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.dig.DigOneCardItem")  
		widget:init(self)
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")

        widget:setData(data,idx,self.yidao)
        widget:addTo(cell)
    else
    	widget = cell:getChildByName("widget")
       	widget:setData(data,idx)
    end
    return cell
end

function DigOneCardView:setOnlyFirger(yidao)
	-- body
	self.yidao = yidao
	if self.yidao then 
		local widget = self.tableView:cellAtIndex(0)
		if widget then 
			local cell = widget:getChildByName("widget")
			cell:setOnlyFirger()
		end 	
	end
end


function DigOneCardView:inittableView()
	-- body
	if not self.tableView then 
		local posx ,posy = self.panle_fortable:getPosition()
		local ccsize =  self.panle_fortable:getContentSize() 

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
end
function DigOneCardView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return  DigOneCardView