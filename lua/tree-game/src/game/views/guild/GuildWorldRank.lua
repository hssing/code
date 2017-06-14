--[[
	GuildWorldRank --世界排行
]]

local GuildWorldRank = class("GuildWorldRank",base.BaseView)

local data = {}
for i = 1 , 10 do 
	local t = {}
	t.rank = i 
	table.insert(data,t) 
end 

function GuildWorldRank:init()
	-- body
	self.bottomType = 1
	self.ShowAll=true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	local panel = self.view:getChildByName("Panel_1")
	local btnClose = self.view:getChildByName("Button_close")
	local down = self.view:getChildByName("Image_18")
	--改变一下层级 
	self.view:reorderChild(panel, 500)
	self.view:reorderChild(down, 500)
	self.view:reorderChild(btnClose, 501)

	self.rank = self.view:getChildByName("Text_18_0_0")
	--关闭按钮
	local btn = self.view:getChildByName("Button_2_1")
	btn:addTouchEventListener(handler(self, self.closeView))

	self.panle_fortable = self.view:getChildByName("Panel_2") 

	--每一个ITEM 
	self.cloneitem = self.view:getChildByName("Panel_1_0")

	self:setData()

	--界面文本
	panel:getChildByName("Text_18_0"):setString(res.str.GUILD_TEXT7) 
	btn:setTitleText(res.str.GUILD_TEXT4)

	self.cloneitem:getChildByName("Text_5_4"):setString(res.str.GUILD_TEXT8) 
	self.cloneitem:getChildByName("Text_7_8"):setString(res.str.GUILD_TEXT9) 
	self.cloneitem:getChildByName("Text_6_6"):setString(res.str.GUILD_TEXT10) 


end

function GuildWorldRank:setMember()
	-- body
	self.rank:setString("骗你的")
end

function GuildWorldRank:setData()
	-- body
	

	self.data =  data 
	self:inittableView()

	self:setMember()
	
end

function GuildWorldRank:getColnePnaleItem()
	-- body
	return self.cloneitem:clone()
end

function GuildWorldRank:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
    return size
end

function GuildWorldRank:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function GuildWorldRank:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function GuildWorldRank:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end 

function GuildWorldRank:cellSizeForTable(table,idx) 
	local ccsize = self.cloneitem:getContentSize()    
    return ccsize.height,ccsize.width
end

function GuildWorldRank:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data[idx+1]
    --print("strValue="..strValue)
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.guild.GuildWorldItem")     
		widget:init(self)
		widget:setData(data,idx)
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
    else
    	widget = cell:getChildByName("widget")
       	widget:setData(data,idx)
    end
    return cell
end

function GuildWorldRank:inittableView()
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

function GuildWorldRank:closeView( sender_,eventype  )
	-- body
	if eventype ==  ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end

function GuildWorldRank:onCloseSelfView()
	-- body
	G_MainGuild()
end
return GuildWorldRank
