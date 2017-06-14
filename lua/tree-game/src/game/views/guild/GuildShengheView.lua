--[[
	--公会审核
]]
local GuildShengheView = class("GuildShengheView",base.BaseView)

function GuildShengheView:init()
	-- body
	proxy.guild:sendShengheList()

	self.ShowAll=true
    self.bottomType = 1
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()


	--self.down = 
	--用来做tableview
	self.panle_fortable = self.view:getChildByName("Panel_2") 
	--关闭按钮
	local btn = self.view:getChildByName("Button_2_1")
	btn:addTouchEventListener(handler(self, self.closeView))
	--每一个ITEM 
	self.cloneitem = self.view:getChildByName("Panel_3")
	--成员数量
	self.cur_member = self.view:getChildByName("Text_18_0")
	self.max_member = self.view:getChildByName("Text_18_0_0")

	local down =self.view:getChildByName("Image_18") 
	down:setPositionY(down:getPositionY()+10)
	self.view:reorderChild(down,500)


	--界面文本
	btn:setTitleText(res.str.GUILD_TEXT4)
	self.view:getChildByName("Text_18"):setString(res.str.GUILD_TEXT27)

	self.cloneitem:getChildByName("Button_2_0"):setTitleText(res.str.GUILD_TEXT28)
	self.cloneitem:getChildByName("Button_2"):setTitleText(res.str.GUILD_TEXT29)

	local  img = self.cloneitem:getChildByName("Image_8") 
	img:getChildByName("Text_1_0"):setString(res.str.GUILD_TEXT5)
	img:getChildByName("Text_1_0_0"):setString(res.str.GUILD_TEXT6)
	img:getChildByName("Text_1_0_1"):setString(res.str.GUILD_TEXT5)
	img:getChildByName("Text_1_0_0_0"):setString(res.str.GUILD_TEXT6)



end

function GuildShengheView:setMember()
	-- body
	local count = cache.Guild:getGuildCount() 
	self.cur_member:setString(count)

	local level = cache.Guild:getGuildLevel()
	level = level ~= 0 and level or 1
	local maxCount = conf.guild:getLimitCount(level)
	self.max_member:setString("/"..maxCount)

	--调整一下位置
	self.max_member:setPositionX(self.cur_member:getPositionX()+self.cur_member:getContentSize().width
		+5)
end

function GuildShengheView:setData()
	-- body
	self.data =  clone(cache.Guild:getShenhe())
	self:inittableView()

	self:setMember()
	
end

function GuildShengheView:getColnePnaleItem()
	-- body
	return self.cloneitem:clone()
end

function GuildShengheView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
    return size
end

function GuildShengheView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function GuildShengheView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function GuildShengheView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end 

function GuildShengheView:cellSizeForTable(table,idx) 
	local ccsize = self.cloneitem:getContentSize()    
    return ccsize.height,ccsize.width
end

function GuildShengheView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data[idx+1]
    print("strValue="..strValue)
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.guild.GuildShengheItem")     
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

function GuildShengheView:inittableView()
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

function GuildShengheView:delItembyData( data_ )
	-- body
	local idx  = 0
	for k , v in pairs(self.data) do 
		if v.roleId.key == data_.roleId.key then 
			idx = k -1
			--debugprint("找到了对应的位置") 
			break;
		end 
	end  

	table.remove(self.data,idx+1)

	self:inittableView()
	self:setMember()

	local num = math.ceil(self.panle_fortable:getContentSize().height/self.cloneitem:getContentSize().height)
	if  idx < num then 
		return 
	end 
	
	local offset = {
		x = 0 ,
		y = (idx+1) * self.cloneitem:getContentSize().height  - self.tableView:getContentSize().height	  
	}
	self.tableView:setContentOffset(offset)
end

function GuildShengheView:closeView(sender_,eventype )
	-- body
	if eventype ==  ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end


function GuildShengheView:onCloseSelfView()
	-- body
	mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_VIEW)
	--self:closeSelfView()
end

return GuildShengheView