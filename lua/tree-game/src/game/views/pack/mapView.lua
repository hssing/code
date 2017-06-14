local  mapView = class("mapView",base.BaseView)

function mapView:ctor( ... )
	-- body
	self.Item = {}
	self.Equip = {}
	self.Card = {}
	self.RoleEquip = {}
	self.Material = {}

	self.data = nil
end

function mapView:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	self.pageindex = index
	--页标签
	local Panel_up = self.view:getChildByName("Panel_up") 

	self.listView = Panel_up:getChildByName("ListView_1") 
	local cloneItemBtn = self.view:getChildByName("Button_1")
	local size = 5
	for i=1,size do
		local item = cloneItemBtn:clone()
		self.listView:pushBackCustomItem(item)
		item:getChildByName("Text_1"):setString(res.str.PACKE_MAP_TITLE[i])
	end
	self.PageButton=gui.PageButton.new()

	for i=1,size do
		self.PageButton:addButton(self.listView:getItem(i - 1))
	end

	-- self.PageButton:addButton(Panel_up:getChildByName("Button_2_4"))
	-- self.PageButton:addButton(Panel_up:getChildByName("Button_2_4_0"))
	-- self.PageButton:addButton(Panel_up:getChildByName("Button_2_4_1"))
	-- self.PageButton:addButton(Panel_up:getChildByName("Button_2_4_2"))
	self.PageButton:setBtnCallBack(handler(self,self.ListButtonCallBack))
	
	--Panel_up:getChildByName("Button_2_4_2"):setVisible(false)

	-- local lab_2 = Panel_up:getChildByName("Text_1_2")
	-- lab_2:setString(res.str.MAP_DEC1)

	-- local lab_3 = Panel_up:getChildByName("Text_1_1")
	-- lab_3:setString(res.str.MAP_DEC2)

	-- local lab_4 = Panel_up:getChildByName("Text_1_0")
	-- lab_4:setString(res.str.DEC_NEW_01)
	--lab_4:setVisible(false)


	

	--listView
	self.Panel_15 = self.view:getChildByName("Panel_15") 
	self.clonePnale = self.view:getChildByName("Panel_16") 
	self.itemClone = self.view:getChildByName("Panel_17")
	self.downJiantou = self.view:getChildByName("Image_4")
	local closebtn = self.view:getChildByName("Button_close")

	self.view:reorderChild(self.downJiantou,500)
	self.view:reorderChild(Panel_up,500)
	self.view:reorderChild(closebtn,500)
	----
	self:setData()
	self.pageindex = self.pageindex and self.pageindex or 1

	local view =  mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	if view then 
		view:setVisible(true)
	end 

    local scene =  mgr.SceneMgr:getMainScene()
    if scene then 
        scene:addHeadView()
    end 

    if res.banshu then 
    	
    	Panel_up:getChildByName("Button_2_4_2"):setVisible(false)
    	Panel_up:getChildByName("Text_1_0"):setVisible(false)
    end 

    G_FitScreen(self,"Image_11")
end

function mapView:numberOfCellsInTableView(table)
	-- body
	return #self.data
end



function mapView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function mapView:scrollViewDidZoom(view)
   print("scrollViewDidZoom")
end

function mapView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function mapView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePnale:getContentSize()    
    return ccsize.height,ccsize.width
end

function mapView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local data = self.data[idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
        local widget=self.clonePnale:clone()
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
        self:initEverone(data,widget)
    else
    	local widget = cell:getChildByName("widget")
        self:initEverone(data,widget)
    end
    return cell
end


function mapView:inittableView()
	-- body
	if not  self.tableView then 
		local posx ,posy = self.Panel_15:getPosition()
		local ccsize =  self.Panel_15:getContentSize() 

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
----上面是tableView测试
function mapView:onOpenItem(sender,eventtype)
	if eventtype == ccui.TouchEventType.ended then

		local data = sender.data
		local item_type = conf.Item:getType(data.mId)
		if item_type ==  pack_type.PRO then
			mgr.ViewMgr:showView(_viewname.PRO_TIPS):setData(data,true)
		elseif  item_type  == pack_type.EQUIPMENT then 
			G_OpenEquip(data,true)
		elseif item_type == 4 then
			local lv = 0 
			G_openItem(sender.data.mId,lv)
		elseif item_type == 5 then
			--保存界面跳转信息
			local data2 = {}
			data2.mapView = true
			data2.selectedPage = 5
			cache.Player:saveMaterialJumpData(data2)

			G_OpenMaterial(data)
		else	
			G_OpenCard(data,true)
		end
	end
end

function mapView:initEverone( data,widget )
	local function initdata( k,v )
		-- body
		local lv=conf.Item:getItemQuality(v.mId)
		local name=conf.Item:getName(v.mId,v.propertys)
		local path = conf.Item:getItemSrcbymid(v.mId,v.propertys)
		print(lv,v.mId)
		local framePath=res.btn.FRAME[lv]

		--widget["frame"..k]:loadTextureNormal(framePath)
		widget["frame"..k]:loadTexture(framePath)
		widget["frame"..k]:addTouchEventListener(handler(self, self.onOpenItem))
		widget["frame"..k].data = v 
		widget["frame"..k]:setVisible(true)

		widget["LabName"..k]:setString(name) 
		widget["LabName"..k]:setVisible(true)
		--debugprint(widget["LabName"..k]:getFontName())

		widget["spr"..k]:ignoreContentAdaptWithSize(true)
		widget["spr"..k]:setScale(0.7)
		widget["spr"..k]:loadTexture(path)
		widget["spr"..k]:setVisible(true)
	end


	if #widget:getChildren() >0 then 
	else
		local w = widget:getContentSize().width/5
		for i = 1 , 5 do 
			local posx = (i-1)*w  
			local item =  self.itemClone:clone()
			widget.img = item
			widget["frame"..i] = item:getChildByName("Button_frame1")
			widget["LabName"..i] = item:getChildByName("Txt_name1_34")
			widget["LabName"..i]:setFontName("Helvetica-Bold")--Helvetica  --Helvetica-Bold
			widget["LabName"..i]:setFontSize(18)
			widget["spr"..i] = item:getChildByName("img_head1_41")

			item:setPositionX(posx)
			item:setPositionY(0)
			item:addTo(widget)
		end 
	end 

	for i = 1 , 5 do 
		widget["frame"..i]:setVisible(false)
		widget["LabName"..i]:setVisible(false)
		widget["spr"..i]:setVisible(false) 
	end 

	for k ,v in pairs(data) do 
		initdata(k,v)
	end 
end 

function mapView:setData()
	-- body
	local alltiems = {}
	local allequip = {}
	local allCard = {}
	local allroleequip ={}
	local allMaterial = {}

	--所有的东西分类
	local all = conf.Item:getall()
	for k ,v in pairs(all) do 
		if  v.no_tujian   and v.no_tujian == 1 then 
		else
			local t = {}
			t.mId = v.id 
			t.propertys ={}
			if v.type == 1  then
				table.insert(allequip,t)
			elseif v.type == 2 then 
				table.insert(alltiems,t)
			elseif v.type == 3 then 
				t.propertys[307] ={}
				t.propertys[307].value = 0
				table.insert(allCard,t)
			elseif v.type == 4 then 
				table.insert(allroleequip,t)
			elseif v.type == 5 then
				table.insert(allMaterial,t)
			end 
		end
	end  
	--排序
	self:sortItem(alltiems)
	self:sortEquip(allequip)
	self:sortCard(allCard)
	self:sortRoleEquip(allroleequip)
	self:sortItem(allMaterial)
	--每5个分一组 方便listView 不卡
	local function _funInitTabel( t1,t2 ) 
		-- body
		local t = {}
		for k ,v in pairs(t2) do 
			table.insert(t,v)
			if k%5 == 0  then 
				table.insert(t1,clone(t))
				t = {}
			elseif  k == #t2 then 
				table.insert(t1,clone(t))
			end 
		end 
	end

	_funInitTabel(self.Item,alltiems)
	_funInitTabel(self.Equip,allequip)
	_funInitTabel(self.Card,allCard)
	_funInitTabel(self.RoleEquip,allroleequip)
	_funInitTabel(self.Material,allMaterial)
end

function mapView:sortItem( alltiems )
	-- body
	table.sort( alltiems, function(a,b)
		-- body
		local acolor = conf.Item:getItemQuality(a.mId)
		local bcolor = conf.Item:getItemQuality(b.mId)

		local asort =  conf.Item:getSort(a.mId)
		local bsort =  conf.Item:getSort(b.mId)
		
		if acolor == bcolor then 
			return a.mId<b.mId
		else
			return acolor>bcolor
		end
	end )
end

function mapView:sortEquip(allequip)
	-- body
	table.sort( allequip, function ( a,b )
		-- body
		--品质
		local acolor = conf.Item:getItemQuality(a.mId)
		local bcolor = conf.Item:getItemQuality(b.mId)

		local asuit_id = conf.Item:getItemSuitId(a.mId)
		local bsuit_id = conf.Item:getItemSuitId(b.mId)
		asuit_id = asuit_id and asuit_id or 10000000
		bsuit_id = bsuit_id and bsuit_id or 10000000

		--部位
		local apart = conf.Item:getItemPart(a.mId)
		local bpart = conf.Item:getItemPart(b.mId)

		if acolor == bcolor then 
			if asuit_id ==  bsuit_id then 
				return apart < bpart
			else
				return asuit_id < bsuit_id
			end 
		else
			return  acolor  > 	bcolor
		end  

	end )
end

function mapView:sortCard( allCard )
	-- body
	table.sort( allCard, function ( a,b )
		-- body
		--品质
		local acolor = conf.Item:getItemQuality(a.mId)
		local bcolor = conf.Item:getItemQuality(b.mId)

		if acolor == bcolor then 
			return a.mId<b.mId
		else
			return acolor > bcolor
		end 
	end )
end

function mapView:sortRoleEquip(allroleequip)
	-- body
	table.sort( allroleequip, function ( a,b )
		-- body
		--品质
		local acolor = conf.Item:getItemQuality(a.mId)
		local bcolor = conf.Item:getItemQuality(b.mId)

		if acolor == bcolor then 
			return a.mId<b.mId
		else
			return acolor > bcolor
		end 
	end )
	
end

function mapView:ListButtonCallBack( index,eventtype )
	-- body
	self.pageindex = index
	self.data = {}
	if index == 1 then 
		self.data = self.Item
	elseif index == 2 then 
		self.data = self.Card
	elseif index == 3 then 
		self.data = self.Equip
	elseif index == 5 then
		self.data = self.Material
	else 	
		self.data = self.RoleEquip
	end 
	self:inittableView()
	return self
end

function mapView:pageviewChange(index)
	-- body
	self.PageButton:initClick(index)
end

function mapView:onCloseSelfView()
	-- body
	local scene =  mgr.SceneMgr:getMainScene()
    if scene then 
        scene:closeHeadView()
    end 
	self:closeSelfView()
end

return mapView