--[[
ContestGroupView --小组信息
--]]

local ContestGroupView = class("ContestGroupView", base.BaseView)

function ContestGroupView:ctor( ... )
	-- body
end

function ContestGroupView:init()
	-- body
	self.ShowAll = true
	--self.ShowBottom = true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	G_FitScreen(self, "Image_40")

	--用来做tableview
	self.panle_fortable = self.view:getChildByName("ListView_1") 
	--每一个ITEM 
	self.cloneitem= self.view:getChildByName("Panel_2")

	local _down = self.view:getChildByName("Image_212")
	self.view:reorderChild(_down, 500)

	self.lab_selfrank = self.view:getChildByName("Image_11"):getChildByName("Text_3")


	--界面固定文本
	self.view:getChildByName("Button_24"):setTitleText(res.str.CONTEST_TEXT8)
	self.cloneitem:getChildByName("Button_2_0_20"):setTitleText(res.str.CONTEST_TEXT9)

end

function ContestGroupView:setData()
	-- body
	self.data = cache.Contest:getGroupInfo()

	--printt(self.data)

	self.lab_selfrank:setString(string.format(res.str.CONTEST_DEC2,self.data.groupId,self.data.selfRank))

	self:inittableView()
end

function ContestGroupView:inittableView()
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

	if self.idx then 
		local num = math.ceil(self.panle_fortable:getContentSize().height/self.cloneitem:getContentSize().height)
		if  self.idx < num then 
			return 
		end 
		
		local offset = {
			x = 0 ,
			y = (self.idx+1) * self.cloneitem:getContentSize().height  - self.tableView:getContentSize().height	  
		}
		--printt(offset)
		self.tableView:setContentOffset(offset)
	end 
end

function ContestGroupView:getColnePnaleItem()
	-- GuildBenQuRank
	return self.cloneitem:clone()
end

function ContestGroupView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data.smdsArrays
	--debugprint("size = "..size)
    return size
end

function ContestGroupView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function ContestGroupView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function ContestGroupView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end 

function ContestGroupView:cellSizeForTable(table,idx) 
	local ccsize = self.cloneitem:getContentSize()    
    return ccsize.height,ccsize.width
end

function ContestGroupView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data.smdsArrays[idx+1]
    print("strValue="..strValue)

    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.contest.ContestGroupItem")  
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

    if idx + 2>#self.data.smdsArrays then 
    	self.idx = idx
    	debugprint("尝试请求下一页")

    	local param = {pageIndex = cache.Contest:getCurpage()+1}
		proxy.Contest:sendMyGroup(param)
    	--local page = cache.Guild:getCurRankpage() 
    	--proxy.guild:sendBenQuguildRank(page+1)
    	--proxy.Mail:sendMessage(self.packindex-1)
    end 
    return cell
end

function ContestGroupView:sendDuibi( otherroleId )
	-- body
	self.otherid= otherroleId

	if cache.Player:getRoleId().key == otherroleId.key then 
		G_TipsOfstr(res.str.CONTEST_DEC27)
		return
	end 

	local param = {tarAId =  cache.Player:getRoleId() , tarBId =  otherroleId }
	proxy.Contest:sendCompare(param)
	mgr.NetMgr:wait(501201)
end

function ContestGroupView:comPareCalllBack( data_ )
	-- body
	cache.Friend:setOnlyClose(true)
	local view = mgr.ViewMgr:createView(_viewname.ATHLETICS_COMPARE)
	local data = {}



	--右边
	local data1 = {}
	data1.tarName = data_.tarBName
	data1.tarLvl = data_.tarBLvl
	data1.tarPower = data_.tarBPower
	data1.tarCards = data_.tarBCards
	data1.huoban = data_.tarBXhbs

	if data1.tarName == cache.Player:getName() then 
		data1.roleId = cache.Player:getRoleId()
	else
		data1.roleId = self.otherid
	end 


	--左边
	local data = {}
	data.tarName = data_.tarAName
	data.tarLvl = data_.tarALvl
	data.tarPower = data_.tarAPower
	data.tarCards = data_.tarACards
	data.huoban = data_.tarAXhbs

	if data.tarName == cache.Player:getName() then 
		data.roleId = cache.Player:getRoleId()
	else
		data.roleId = self.otherid
	end 

	if data.tarName == cache.Player:getName() then
		view:setData(data1,data)
	else
		view:setData(data,data1)
	end 

	mgr.ViewMgr:showView(_viewname.ATHLETICS_COMPARE)
end

function ContestGroupView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return ContestGroupView