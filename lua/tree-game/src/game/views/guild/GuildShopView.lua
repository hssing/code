--[[
	GuildShopView 公会商店
]]

local GuildShopView = class("GuildShopView", base.BaseView)

function GuildShopView:ctor()
	-- body
	self.data = {}
end

function GuildShopView:init()
	-- body
	self.ShowAll=true
    self.bottomType = 2
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	local panel_up = self.view:getChildByName("Panel_16")
	local btn = panel_up:getChildByName("Button_1") 
	local  btnFuwen = panel_up:getChildByName("Button_1_0") 


	self.ListGUIButton={}  --GUI按钮容器
	self.PageButton=gui.PageButton.new()--创建分页按钮管理器
	self.PageButton:addButton(btn)
	self.PageButton:addButton(btnFuwen)
	self.PageButton:setBtnCallBack(handler(self, self.onPageButtonCallBack))

	local closebtn = self.view:getChildByName("Button_close")
	self.view:reorderChild(panel_up,500)
	self.view:reorderChild(closebtn,501)
	--贡献
	self.lab_gongxian = panel_up:getChildByName("Text_1_0_34")
	--
	--用来做tableview
	self.panle_fortable = self.view:getChildByName("Panel_20") 
	--每一个ITEM 
	self.cloneitem = self.view:getChildByName("Panel_Clone")

	--界面文本
	panel_up:getChildByName("Text_1_0_34_0"):setString(res.str.GUILD_TEXT22) 
	panel_up:getChildByName("Button_1"):setTitleText(res.str.GUILD_TEXT23) 
	btnFuwen:setTitleText(res.str.DEC_NEW_41) 

	self.cloneitem:getChildByName("Text_130_0_0"):setString(res.str.GUILD_TEXT24)
	self.cloneitem:getChildByName("Text_130_0_0_1"):setString(res.str.GUILD_TEXT25)
	self.cloneitem:getChildByName("Button_Using_26_48"):setTitleText(res.str.GUILD_TEXT26)

	G_FitScreen(self, "Image_1")
end

function GuildShopView:onPageButtonCallBack( index,eventype )
	self.index = index
	self:inittableView() 
	--[[if index == 1 then
		if self.tableView then
			return
		end
		self.panle_fortable:removeAllChildren()
		self:setData() 
		self:inittableView() 
	elseif index == 2 then
	end]]--
	return self
end

function GuildShopView:setData()
	-- body
	self.data = {}
	local t = cache.Guild:getShopList()
	--printt(t)
	for k ,v in pairs(t) do 
		local itemdata = conf.guild:getShopItem(v.index)
		print(itemdata.page)
		if itemdata.page and  not self.data[itemdata.page]  then
			self.data[tonumber(itemdata.page)] = {}
		end
		if self.data[tonumber(itemdata.page)] then
			table.insert(self.data[tonumber(itemdata.page)],v)
		end
		
	end
	for k ,v in pairs(self.data) do 
		table.sort(v,function(a,b)
			-- body
			return a.index<b.index
		end)
	end 
	--self.data = cache.Guild:getShopList()
	self.guildGX = cache.Guild:getGuildPoint()
	self.lab_gongxian:setString(self.guildGX)
	--printt(self.data)
	self.PageButton:initClick(1)
end

function GuildShopView:getColnePnaleItem()
	-- body
	return self.cloneitem:clone()
end

function GuildShopView:numberOfCellsInTableView(table)
	-- body
	local count = 0
	if self.data[self.index] then
		count = #self.data[self.index]
	end
	local size=count
	--debugprint("size = "..size)
    return size
end

function GuildShopView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function GuildShopView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function GuildShopView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end 

function GuildShopView:cellSizeForTable(table,idx) 
	local ccsize = self.cloneitem:getContentSize()    
    return ccsize.height+6,ccsize.width
end

function GuildShopView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data[self.index][idx+1]
   -- print("strValue="..strValue)
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.guild.GuildShopItem") 
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

function GuildShopView:inittableView()
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

function GuildShopView:updateData( index ,data_)
	-- body
	local idx = -1
	for k ,v in pairs(self.data[self.index]) do 
		if v.index == index then 
			for i,j in pairs(v.propertys) do 
				if j.type == 40103 then
					j.value = data_.buyCount
				end
			end
			idx = k -1 
			break
		end 
	end 

	self.guildGX = cache.Guild:getGuildPoint()
	self.lab_gongxian:setString(self.guildGX)

	if idx > -1 then --找到了对应的
		local cell = self.tableView:cellAtIndex(idx)
		if cell then 
			local data= self.data[self.index][idx+1]
			cell:getChildByName("widget"):setData(data,idx)
		end 
	end 
end


function GuildShopView:onCloseSelfView()
	-- body
	G_MainGuild()
end

return GuildShopView