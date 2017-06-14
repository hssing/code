--[[
	DigFriend --好友界面
]]

local DigFriend = class("DigFriend", base.BaseView)

function DigFriend:ctor()
	-- body
	self.data ={}
end

function DigFriend:init()
	-- body
	--self.ShowAll = true
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local panle = self.view:getChildByName("Panel_5")
	self.panle = panle
	local bg = panle:getChildByName("Image_24")
	--关闭按钮
	local btn_close = bg:getChildByName("Button_4") 
	btn_close:addTouchEventListener(handler(self,self.onBtnClose))
	--用来做tableview
	self.panle_fortable = panle:getChildByName("Panel_8") 

	--每一个Item
	self.cloneitem= self.view:getChildByName("Panel_1")


	--界面文本
	--self.cloneitem:getChildByName("Button_2_1"):setString(res.str.DIG_DEC41) 

	self.img_titile = bg:getChildByName("Image_26")
	self.img_titile:ignoreContentAdaptWithSize(true)

	--G_FitScreen(self,"Image_1")
end

function DigFriend:setData(data_)
	-- body --好友
	self.data = data_

	table.sort(self.data,function(a,b)
		-- body
		return a.helpCount > b.helpCount
	end)

	self.enemy = 1
	self:inittableView()
end


function DigFriend:setData2( data_ )
	-- body --复仇
	self.data = data_
	

	self.enemy = 2
	self:inittableView()

	self.img_titile:loadTexture(res.font.FUCHOU)
end

function DigFriend:setData3( data_,daoId )
	-- body --助阵
	self.data = data_
	table.sort( self.data , function(a,b )
		-- body
		if a.lastTime == b.lastTime then 
			if a.score == b.score then 
				if a.level ~= b.level then 
					return a.level > b.level
				end
			else
				return a.score > b.score 
			end
		else
			return a.lastTime < b.lastTime
		end
	end)

	self.daoId = daoId
	self.enemy = 3
	self:inittableView()

	self.img_titile:loadTexture(res.font.FRIEND)
end

function DigFriend:getColnePnaleItem( ... )
	-- body
	return self.cloneitem:clone()
end

function DigFriend:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
	--debugprint("size = "..size)
    return size
end

function DigFriend:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function DigFriend:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function DigFriend:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end 

function DigFriend:cellSizeForTable(table,idx) 
	local ccsize = self.cloneitem:getContentSize()    
    return ccsize.height,ccsize.width
end

function DigFriend:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data[idx+1]
    --print("self.enemy = " ..self.enemy )
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.dig.DigFriendItem")  
		widget:init(self)
		if tonumber(self.enemy) == 1 then 
			widget:setData(data,idx)
		elseif tonumber(self.enemy) == 2 then 
			widget:setData2(data,idx)
		elseif tonumber(self.enemy) == 3 then 
			widget:setData3(data,idx,self.daoId)
		end
		--widget:setvis()
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
    else
    	widget = cell:getChildByName("widget")
        if tonumber(self.enemy) == 1 then 
			widget:setData(data,idx)
		elseif tonumber(self.enemy) == 2 then 
			widget:setData2(data,idx)
		elseif tonumber(self.enemy) == 3 then 
			widget:setData3(data,idx,self.daoId)
		end
    end 
    return cell
end

function DigFriend:inittableView()
	-- body
	if not self.tableView then 

		local posx ,posy = self.panle_fortable:getPosition()
		local ccsize =  self.panle_fortable:getContentSize() 

		self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	    self.tableView:setPosition(cc.p(posx, posy))
	    self.tableView:setDelegate()
	    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	    self.panle:addChild(self.tableView,100)
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

function DigFriend:onBtnSeeFriendData(sender_, eventtype)
	-- body
	if eventtype ==  ccui.TouchEventType.ended then 
		debugprint("查看好友文件岛")
	end 
end

function DigFriend:onBtnClose( sender_, eventtype )
	-- body
	if eventtype ==  ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end

function DigFriend:onCloseSelfView()
	-- body
	local scene =  mgr.SceneMgr:getMainScene()
    if scene then 
        scene:addHeadView()
    end
	self:closeSelfView()
end

function DigFriend:updateDataByidx( idx )
	-- body
	local cell = self.tableView:cellAtIndex(idx)
	if cell then 
		local data= self.data[idx+1]
		self.data[idx+1].hasInvite = 1
		cell:getChildByName("widget"):update3(data,idx)
	end 
end


return DigFriend