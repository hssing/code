--
-- Author: Your Name
-- Date: 2015-07-23 16:04:39
--
--
-- Author: Your Name
-- Date: 2015-07-23 15:32:09
--

local StrategyView_3 = class("StrategyView_3", base.BaseView)

function StrategyView_3:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	--设置当前选中第三级界面
	conf.strategy:setPageIndex(3)
	self.keys = conf.strategy:sort()
	self.data = conf.strategy:getCurrPageData()

	self.clonePane = self.view:getChildByName("Item_Panel")
	self.listView = self.view:getChildByName("ListView_2")

	local title = self.data[self.keys[1]]["title"]
	self.view:getChildByName("Header"):getChildByName("Text_title"):setString(title)

	self.clonePane:getChildByName("Button_go"):setTitleText(res.str.STRATEGY_TEXT1)

	--初始化界面显示
	-- for k,v in pairs(self.keys) do
	-- 	local item = self.clonePane:clone()
	-- 	local icon = item:getChildByName("icon")
	-- 	local textInfo = item:getChildByName("Text_info")
	-- 	local src = conf.strategy:getIconSrc(v)

	-- 	print(src)

	-- 	textInfo:setString(conf.strategy:getContent(v))
	-- 	textInfo:ignoreContentAdaptWithSize(false)
	-- 	icon:loadTexture(src)
	-- 	self.listView:addChild(item)

	-- 	-- 按钮点击事件
	-- 	local btnGo = item:getChildByName("Button_go")
	-- 	btnGo:addTouchEventListener(handler(self,self.btnGoClickUpCallbacl))
	-- 	btnGo:setTag(v)

	-- 	--break

	-- end
	self.listView:setSwallowTouches(true)

	self:inittableView()


end

-- 点击按钮 跳转对应的系统界面
function StrategyView_3:btnGoClickUpCallbacl( sender,eventType )
	-- body
	
	if eventType == ccui.TouchEventType.ended then
		if sender then
			--to
			-- 跳转到对应的系统

				local viewId = self.data[sender:getTag() .. ""]["viewid"]
				local limited_LV = self.data[sender:getTag() .. ""]["limited_LV"]
				local player_Lv = cache.Player:getLevel()


				if not viewId then
					G_TipsOfstr(res.str.SYS_DEC8)
					return
				end

				if player_Lv < limited_LV then
					G_TipsOfstr(string.format(res.str.STRATEGY_TIPS1, limited_LV))
					return
				end

				if viewId[1] == "SINGNIN" then
					--todo
					self:rollbackView()
					proxy.signIn:reqSignInfo()
					mgr.ViewMgr:closeView(_viewname.STRATEGY_3)
					return
				end


				self:rollbackView()
				G_GoToView(viewId)
				--mgr.ViewMgr:closeView(_viewname.STRATEGY_3)
		end
	-- 	self.idMoved = false
	-- elseif eventType == ccui.TouchEventType.moved then
	-- 	self.idMoved = true
	-- elseif eventType == ccui.TouchEventType.began then
	-- 	self.idMoved = false
	end

end

function StrategyView_3:rollbackView(  )
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



function StrategyView_3:onCloseSelfView(  )
	--self:rollbackView()
	conf.strategy:setPageIndex(2)
    conf.strategy:setSelectedIdx(self.preIdx)
   -- G_TipsOfstr(self.preIdx)
	mgr.ViewMgr:closeView(_viewname.STRATEGY_3)
	--G_mainView()
    -- local view =  mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)

    -- if view then
    --    view:setVisible(true)
    -- end
end


function StrategyView_3:numberOfCellsInTableView(table)
	-- body
	local size=#self.keys
    return size
end

function StrategyView_3:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function StrategyView_3:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function StrategyView_3:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
   -- self:btnGoClickUpCallbacl(cell:getChildByName("item"),ccui.TouchEventType.ended)
end

function StrategyView_3:cellSizeForTable(table,idx) 
	local ccsize = self.clonePane:getContentSize()    
    return ccsize.height,ccsize.width
end

function StrategyView_3:tableCellAtIndex(table, idx)
    local strValue = string.format("%d================",idx)
    local cell = table:dequeueCell()
    local item

    if nil == cell then
        item = self.clonePane:clone()
        cell = cc.TableViewCell:new()
		cell:addChild(item)
		item:setName("item")
		item:setTouchEnabled(false)
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

    return cell
end

function StrategyView_3:inittableView()
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
	    self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)               --添加
	    self.tableView:reloadData()
	    self:loadInRunAction()
	else
		self.tableView:reloadData()
		self:loadInRunAction()
	end 
end



function StrategyView_3:loadInRunAction( )
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


return StrategyView_3