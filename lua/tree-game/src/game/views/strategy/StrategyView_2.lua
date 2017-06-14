--
-- Author: Your Name
-- Date: 2015-07-23 15:32:09
--

local StrategyView_2 = class("StrategyView_2", base.BaseView)

function StrategyView_2:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	--设置选中第二级界面
	conf.strategy:setPageIndex(2)
	self.keys = conf.strategy:sort()
	self.data = conf.strategy:getCurrPageData()

	self.clonePane = self.view:getChildByName("Item_Panel")
	self.listView = self.view:getChildByName("ListView_2")

	--dump(self.data)

	local title = self.data[self.keys[1]]["title"]
	self.view:getChildByName("Header"):getChildByName("Text_title"):setString(title)

	self:inittableView()


	--self.listView:setSwallowTouches(true)


	--self:initListView()


end


function StrategyView_2:rollbackView(  )
	-- body
	 local scene =  mgr.SceneMgr:getMainScene()
    if scene then 
        scene:addHeadView()
        --mgr.ViewMgr:showView(_viewname.MAIN_TOP_LAYER)
        G_mainView()
	    local view =  mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)

	    if view then
	       view:setVisible(true)
	    end
    end
end

function StrategyView_2:btnGoClickUpCallbacl( sender,eventType )
	-- body
	if eventType == ccui.TouchEventType.ended then
		if sender then
			--todo
			local hasNext = self.data[sender:getTag() .. ""]["hasNext"]

			-- 没有下级界面，跳转到对应的系统
			if hasNext ~= 1 then
				local viewId = self.data[sender:getTag() .. ""]["viewid"]
				local limited_LV = self.data[sender:getTag() .. ""]["limited_LV"]
				local player_Lv = cache.Player:getLevel()
				--limited_LV = 1
				if player_Lv < limited_LV then
						G_TipsOfstr(res.str.SYS_DEC8)
					return
				end

				G_GoToView(viewId)

				return
			end
			local index = conf.strategy.selectedIdx
			conf.strategy:setSelectedIdx(sender:getTag())
			mgr.ViewMgr:showView(_viewname.STRATEGY_3).preIdx= index
			
			
			--self:closeSelfView()
		end

	elseif  eventType == ccui.TouchEventType.moved then

	elseif  eventType == ccui.TouchEventType.began then

	end

end



function StrategyView_2:onCloseSelfView(  )
	--self:rollbackView()
	mgr.ViewMgr:closeView(_viewname.STRATEGY_2)
	conf.strategy:setPageIndex(1)
	conf.strategy:setSelectedIdx(0)
	--G_mainView()
    -- local view =  mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)

    -- if view then
    --    view:setVisible(true)
    -- end
end



function StrategyView_2:numberOfCellsInTableView(table)
	-- body
	local size=#self.keys
    return size
end

function StrategyView_2:scrollViewDidScroll(view)
    print("scrollViewDidScroll")
end

function StrategyView_2:scrollViewDidZoom(view)
    print("scrollViewDidZoom")
end

function StrategyView_2:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
    self:performWithDelay(function( ... )
         --self:closeSelfView()
         self:btnGoClickUpCallbacl(cell:getChildByName("item"):getChildByName("Button_go"),ccui.TouchEventType.ended)
    end, 0.1)
end

function StrategyView_2:cellSizeForTable(table,idx) 
	local ccsize = self.clonePane:getContentSize()    
    return ccsize.height,ccsize.width
end

function StrategyView_2:tableCellAtIndex(table, idx)
    local strValue = string.format("%d================",idx)
    local cell = table:dequeueCell()
    local item

    if nil == cell then
        item = self.clonePane:clone()
        cell = cc.TableViewCell:new()
		cell:addChild(item)
		item:setName("item")
		--item:setTouchEnabled(false)
    else
        item = cell:getChildByName("item")
   
    end
    local v = self.keys[idx+1]
        --初始化界面显示
		local icon = item:getChildByName("icon")
		local textInfo = item:getChildByName("Text_info")
		local src = conf.strategy:getIconSrc(v)

		textInfo:setString(conf.strategy:getContent(v))
		icon:loadTexture(src)
		item:setPosition(5,0)
		item:setAnchorPoint(0,0)
		--self.listView:scro

		-- 按钮点击事件
		local btnGo = item:getChildByName("Button_go")
		btnGo:addTouchEventListener(handler(self,self.btnGoClickUpCallbacl))
		btnGo:setTag(v)
		--item:addTouchEventListener(handler(self,self.itemTouched))
		item:setTag(v)
		cell:setTag(v)
		item:setSwallowTouches(false)
    return cell
end

function StrategyView_2:itemTouched(sender,eType )
	-- body
	--self:btnGoClickUpCallbacl(sender,eType)
end

function StrategyView_2:inittableView()
	-- body
	if not self.tableView then 

		local posx ,posy = self.listView:getPosition()
		local ccsize =  self.listView:getContentSize() 

		self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	    self.tableView:setPosition(cc.p(posx, posy))
	    self.tableView:setDelegate()
	    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	    self.view:addChild(self.tableView,1000)
	    --registerScriptHandler functions must be before the reloadData funtion
	    self.tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView) ,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --tableView个数
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)           --滚动  
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)				--放大
	    self.tableView:registerScriptHandler(handler(self, self.tableCellTouched),cc.TABLECELL_TOUCHED)						--点击	
	    self.tableView:registerScriptHandler(handler(self, self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)				--xiao	
	    self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)               --添加
	    self.tableView:reloadData()
	    self:loadInRunAction()
	else
		self.tableView:reloadData()
		self:loadInRunAction()
	end 
end



function StrategyView_2:loadInRunAction( )
	local size=5

	local time = 0.5
	local starX=-400
	local offset = 200
	local moveItem_={}
	
	for i=1,size do
		local item=self.tableView:cellAtIndex(i-1)
		if item  then
			item:setPositionX(starX-i*offset)
			moveItem_[#moveItem_+1]=item
		end
	end
	local item_size=#moveItem_
	if item_size > 0 then
		for i=1,item_size do
			local act1=cc.MoveTo:create(time,cc.p(0,moveItem_[i]:getPositionY()))
			local act2=cc.CallFunc:create(function ( ... )
				if i == item_size then
					--self:setTouchEnabled(false) 
				end 
				end)
			local seq=cc.Sequence:create(act1,act2)
			moveItem_[i]:runAction(seq)
		end 
	end
end





return StrategyView_2