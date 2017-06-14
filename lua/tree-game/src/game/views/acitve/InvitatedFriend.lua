--
-- Author: Your Name
-- Date: 2015-08-03 16:31:04
--

local InvitatedFriend = class("InvitatedFriend", base.BaseView)

function InvitatedFriend:init(  )
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()
	local panel1 = self.view:getChildByName("Panel_1")
	self.listView = panel1:getChildByName("ListView")
	self.clonePanel = self.view:getChildByName("Panel_item")

	-- for i=1,10 do
	-- 	self.listView:pushBackCustomItem(self.clonePanel:clone())
	-- end
	panel1:getChildByName("Text_12"):setString(res.str.ACTIVE_TEXT20)
	panel1:getChildByName("Text_12_0"):setString(res.str.ACTIVE_TEXT21)
	panel1:getChildByName("Text_12_0_0"):setString(res.str.ACTIVE_TEXT22)


	self.data = {}
	self:inittableView()
	
end

function InvitatedFriend:setData( data )
	self.data = data["roleKeyFriends"]
	self.tableView:reloadData()
end

function InvitatedFriend:createItem( idx ,item)
	if idx <= 0 then
		print("索引有误",idx)
		return
	end
	local nameLab = item:getChildByName("Text_16")
	local chargeLab = item:getChildByName("Text_17")
	local returnLab = item:getChildByName("Text_17_0")

	nameLab:setString(self.data[idx]["roleName"])
	chargeLab:setString(self.data[idx]["firstGlod"])
	returnLab:setString(self.data[idx]["awardZs"])
end





function InvitatedFriend:inittableView(  )
	-- body
	local size = self.listView:getContentSize()
	local x,y = self.listView:getPosition()
	self.tableView = cc.TableView:create(cc.size(size.width,size.height))
	self.tableView:setPosition(x,y)
	self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.tableView:setDelegate()
	self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self.view:getChildByName("Panel_1"):addChild(self.tableView)

	-----设置cell处理事件
	self.tableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	self.tableView:registerScriptHandler(handler(self,self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)
	self.tableView:registerScriptHandler(handler(self,self.tableCellTouched),cc.TABLECELL_TOUCHED)
	self.tableView:registerScriptHandler(handler(self,self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)
	self.tableView:registerScriptHandler(handler(self, self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)  

	self.tableView:reloadData()

end

function InvitatedFriend:scrollViewDidScroll(  )
	-- body
end

function InvitatedFriend:numberOfCellsInTableView(atable)
	-- body
	print("numberOfCellsInTableView")

	return table.nums(self.data)
end

function InvitatedFriend:cellSizeForTable(table, idx)
	-- body
	print("cellSizeForTable")
	local size = self.clonePanel:getContentSize()
	return size.height,size.width
end

function InvitatedFriend:tableCellTouched(table, cell)
	-- body
	print("tableCellTouched")
end

function InvitatedFriend:tableCellAtIndex(table, idx)
	-- body
	local cell = table:dequeueCell()
	if cell == nil then
		--todo
		cell = cc.TableViewCell:new()
		local widget = self.clonePanel:clone()
		self:createItem(idx + 1,widget)
		widget:setPosition(0,0)
		widget:setSwallowTouches(false)
		widget:setName("item")
		cell:addChild(widget)
	else
		local widget = cell:getChildByName("item")
		self:createItem(idx + 1,widget)
	end


	return cell
	
end


function InvitatedFriend:onCloseSelfView(  )
	-- body
	self:closeSelfView()
	--mgr.ViewMgr:showView(_viewname.INVITATEFRIEND)
end



return InvitatedFriend