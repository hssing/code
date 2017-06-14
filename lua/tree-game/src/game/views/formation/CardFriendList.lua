--[[
	小伙伴上阵
]]
local CardFriendList=class("CardFriendList",base.BaseView)

function CardFriendList:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.Panel_Clone=self.view:getChildByName("Panel_Clone")
	self.ListView=self.view:getChildByName("ListView_1")
	self.ListView:setTouchEnabled(false)
	self.ListView:setVisible(false)

	local down = self.view:getChildByName("other_arrow_1")
	self.view:reorderChild(down,200) --让箭头在ListView 上面
	self:initDec()
	self:setData()

	G_FitScreen(self, "Image_2")
end

function CardFriendList:initDec()
	-- body
	self.view:getChildByName("bg_2"):getChildByName("Text_tiitle"):setString(res.str.RES_GG_12)
end

function CardFriendList:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
	return size
end

function CardFriendList:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function CardFriendList:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function CardFriendList:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function CardFriendList:cellSizeForTable(table,idx) 
	local ccsize = self.Panel_Clone:getContentSize()    
    return ccsize.height,ccsize.width
end

function CardFriendList:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    
    local cell = table:dequeueCell()
    local data = self.data[idx+1]

    if nil == cell then
        cell = cc.TableViewCell:new()
        local widget=CreateClass("views.formation.FriendCaradWidget")
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
        widget:init(self)
        widget:setData(data,self.pos)
    else
    	local widget = cell:getChildByName("widget")
        widget:setData(data,self.pos)
    end
    return cell
end

function CardFriendList:inittableView()
	-- body
	if not  self.tableView then 
		local posx ,posy = self.ListView:getPosition()
		local ccsize =  self.ListView:getContentSize() 

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
	end 
	self.tableView:reloadData()
end

function CardFriendList:getWidgetClone()
	return self.Panel_Clone:clone()
end

function CardFriendList:sortselfdata(  )
	-- body
	table.sort( self.data, function( a,b )
		-- body
		local acolor = conf.Item:getItemQuality(a.mId)
		local bcolor = conf.Item:getItemQuality(b.mId)

		local apower = mgr.ConfMgr.getPower(a.propertys)
		local bpower =  mgr.ConfMgr.getPower(b.propertys)
 		
 		if a.count == b.count then
 			if acolor == bcolor then
 				if apower == bpower then
 					return a.mId > b.mId
 				else
 					return apower > bpower
 				end
 			else
 				return bcolor < acolor
 			end
 		else
 			return a.count > b.count
 		end
	end )
end

function CardFriendList:setData()
	local data = cache.Pack:getTypePackInfo(pack_type.SPRITE)
	self.data = {}

	local onBattle = {}
	for k ,v in pairs(data) do 
		local onpos = conf.Item:getBattleProperty(v)
		local type_id = conf.Item:getItemConf(v.mId).type_id
		if onpos > 0  then 
			if not onBattle[type_id] then 
				onBattle[type_id] = 1
			end 
		elseif v.propertys[317] and  v.propertys[317].value > 0 then
			if not onBattle[type_id] then 
				onBattle[type_id] = 1
			end 
		end 
	end 

	self.friend = {}
	self.data_onbattle = {}
	for k ,v in pairs(data) do  
        local onpos = conf.Item:getBattleProperty(v)
        local type_id = conf.Item:getItemConf(v.mId).type_id
        if onpos <= 0   then 
            if v.propertys[317] and  v.propertys[317].value > 0 then 
            	self.friend[v.propertys[317].value] = {}
            	self.friend[v.propertys[317].value] = v 
            end
            if not onBattle[type_id] then --屏蔽同类卡牌
            	 table.insert(self.data,v)
            end
        else
        	table.insert(self.data_onbattle,v)
        end 
    end 
    --添加一个字段 看看激活几个亲密
    for k ,v in pairs(self.data) do 
    	local count = 0
    	local oldid = conf.Item:getItemConf(v.mId).type_id
    	for i , j in pairs(self.data_onbattle) do 
    		local type_id = conf.Item:getItemConf(j.mId).type_id
    		local Intimacy_id = conf.Item:getIntimacyID(type_id)
    		if Intimacy_id then
       			local card_id = conf.CardIntimacy:getIntimacy(Intimacy_id)
       			if card_id then
       				for h,g in pairs(card_id.effect_ids) do 
       					if oldid  == g then --如果激活了
       						count = count + 1 
       					end
       				end
       			end
       		end
    	end
    	v.count = count
    end

    self:sortselfdata()
	self:inittableView()
end

function CardFriendList:setPos(pos)
	-- body
	self.pos = pos
end

function CardFriendList:send_shang(data)
	-- body
	local param = {xhbIndex = self.pos,packIndex=data.index}
	if self.friend[self.pos] then
		param.opType = 2
	else
		param.opType = 1
	end
	proxy.card:send_104008(param)
end

function CardFriendList:onCloseSelfView()
	-- body
	self:closeSelfView()
end


return CardFriendList