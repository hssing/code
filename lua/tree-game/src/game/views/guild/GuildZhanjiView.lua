--[[
	GuildZhanjiView --成员战绩
]]

local GuildZhanjiView = class("GuildZhanjiView", base.BaseView)


function GuildZhanjiView:init()
	-- body
	self.bottomType = 2
	self.ShowAll=true
	self.showtype=view_show_type.OTHER
	self.view=self:addSelfView()

	self.panel = self.view:getChildByName("Panel_1") 

	self.lab_rank = self.panel:getChildByName("Text_6_0")
	self.lab_count =  self.panel:getChildByName("Text_6_0_0")
	self.lab_hurt = self.panel:getChildByName("Text_6_0_1")

	local btnclose= self.panel:getChildByName("Button_close_0")
	btnclose:addTouchEventListener(handler(self, self.onbtnclose))


	self.panle_fortable = self.view:getChildByName("Panel_2") 
	self.cloneitem = self.view:getChildByName("Panel_3_0")

	self:initData()

	proxy.guild:sendZhanji()--请求战绩
	proxy.guild:waitFor(517303)


	--界面文本
	self.panel:getChildByName("Text_6"):setString(res.str.GUILD_TEXT1)
	self.panel:getChildByName("Text_6_1"):setString(res.str.GUILD_TEXT2)
	self.panel:getChildByName("Text_6_1_0"):setString(res.str.GUILD_TEXT3)
	btnclose:getChildByName("Text_1_0_6_13"):setString(res.str.GUILD_TEXT4)

	self.cloneitem:getChildByName("Image_8_31_39"):getChildByName("Text_1_0_27_37"):setString(res.str.GUILD_TEXT2)
	self.cloneitem:getChildByName("Image_8_31_39"):getChildByName("Text_1_0_0_29_39"):setString(res.str.GUILD_TEXT3)
	self.cloneitem:getChildByName("Image_8_31_39"):getChildByName("Text_1_0_1_31_41"):setString(res.str.GUILD_TEXT5)
	self.cloneitem:getChildByName("Image_8_31_39"):getChildByName("Text_1_0_0_0_33_43"):setString(res.str.GUILD_TEXT6)


	G_FitScreen(self, "Image_1")
end

function GuildZhanjiView:initData()
	-- body
	self.lab_rank:setString("")
	self.lab_count:setString("")
	self.lab_hurt:setString("")
end

function GuildZhanjiView:setData()
	-- body
	self.data = cache.Guild:getZhanji()
	self.selfrole = cache.Player:getRoleInfo()
	for k ,v in pairs(self.data) do 
		if v.roleId.key == self.selfrole.roleId.key then 
			self.lab_rank:setString(v.rank or -1  )
			self.lab_count:setString(v.todayCount)
			self.lab_hurt:setString(v.hitStr)
			break
		end
	end 
	self:inittableView()
end

function GuildZhanjiView:getColnePnaleItem()
	-- body
	return self.cloneitem:clone()
end

function GuildZhanjiView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
    return size
end

function GuildZhanjiView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function GuildZhanjiView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function GuildZhanjiView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end 

function GuildZhanjiView:cellSizeForTable(table,idx) 
	local ccsize = self.cloneitem:getContentSize()    
    return ccsize.height,ccsize.width
end

function GuildZhanjiView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data[idx+1]
    --print("strValue="..strValue)
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.guild.GuildzhanjiItem")     
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

function GuildZhanjiView:inittableView()
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


function GuildZhanjiView:onbtnclose( sender_,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end 
end

function GuildZhanjiView:onCloseSelfView()
	-- body
	self:closeSelfView()
end


return GuildZhanjiView