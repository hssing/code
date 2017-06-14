--
-- Author: Your Name
-- Date: 2015-07-23 14:39:24
--


local StrategyView = class("StrategyView", base.BaseView)

function StrategyView:init()
	-- body
	
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	conf.strategy:setPageIndex(1)
	conf.strategy:setSelectedIdx(0)
	self.keys = conf.strategy:sort()
	self.data = conf.strategy:getCurrPageData()

	self.clonePane = self.view:getChildByName("Item_Panel")
	self.listView = self.view:getChildByName("ListView_2")

	self:inittableView()

	self.listView:setSwallowTouches(true)

	--关闭果实界面
	local view = mgr.ViewMgr:get(_viewname.FRUIT_COMPOSE_PAGE)
	if view then
		view:closeSelfView()
	end


end

function StrategyView:btnGoClickUpCallbacl( sender,eventType )
	-- body
	if eventType == ccui.TouchEventType.ended then
		if sender then
			--todo
			local resType = conf.strategy:getResType(sender:getTag())
			if resType == 1 then
				conf.strategy:setSelectedIdx(sender:getTag())
				mgr.ViewMgr:showView(_viewname.STRATEGY_2)

				-- self:closeSelfView()
			elseif resType == 2 then
				mgr.ViewMgr:showView(_viewname.STRATEGY_INTRO):setData(sender:getTag())

			end

			
		end
		--print("======================")
	-- 	self.idMoved = false
	-- elseif eventType == ccui.TouchEventType.moved then
	-- 	self.idMoved = true
	-- elseif eventType == ccui.TouchEventType.began then
	-- 	self.idMoved = false
	end

end



function StrategyView:onCloseSelfView(  )
	 local scene =  mgr.SceneMgr:getMainScene()
    if scene then 
        scene:addHeadView()
        G_mainView()
        local view =  mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)

        if view then
        	view:setVisible(true)
        end
       
    end
	mgr.ViewMgr:closeView(_viewname.STRATEGY)
end

function StrategyView:itemTouched(sender,eType )
	-- body
	--self:btnGoClickUpCallbacl(sender,eType)
end



function StrategyView:numberOfCellsInTableView(table)
	-- body
	local size=#self.keys
    return size
end

function StrategyView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function StrategyView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function StrategyView:tableCellTouched(table,cell)

	-- local index =  tonumber(self.keys[cell:getIdx()+1])
	-- 		conf.strategy:setSelectedIdx(index)
	-- local resType = conf.strategy:getResType(index)
	-- G_TipsOfstr(resType)
	-- 	if resType == 1 then
	-- 		--mgr.ViewMgr:showView(_viewname.STRATEGY_2)
	-- 		self.tableView = nil
	-- 	elseif resType == 2 then

	-- 	end

	self:btnGoClickUpCallbacl(cell:getChildByName("item"),ccui.TouchEventType.ended)
			
			--self:closeSelfView()
end

function StrategyView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePane:getContentSize()    
    return ccsize.height,ccsize.width
end

function StrategyView:tableCellAtIndex(table, idx)
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
		local textInfo = item:getChildByName("text_info")
		--print(v)
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
		item:setSwallowTouches(false)



    return cell
end

function StrategyView:inittableView()
	-- body
	if not self.tableView then 

		local posx ,posy = self.listView:getPosition()
		local ccsize =  self.listView:getContentSize() 

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
	    self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)  
	                 --添加
	    self.tableView:reloadData()
	    self:loadInRunAction()
	else
		self.tableView:reloadData()
		self:loadInRunAction()
	end 
end



function StrategyView:loadInRunAction( )
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






return StrategyView