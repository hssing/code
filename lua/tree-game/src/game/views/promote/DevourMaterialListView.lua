
local DevourMaterialWidget=require("game.views.promote.DevourMaterialWidget")


local DevourMaterialListView = class("DevourMaterialListView",base.BaseView)


function DevourMaterialListView:ctor()
	self.super.ctor(self)
	--选择列表
	self.SelectPetListData = {}
end

function DevourMaterialListView:init()
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	self.ListView=self.view:getChildByName("ListView_1")
	self.ListView:setTouchEnabled(false)
	self._widgetClone=self.view:getChildByName("Panel_Clone")
	--
	self._bg_2 = self.view:getChildByName("bg_2")

	self._sprTitile = self.view:getChildByName("Image_1")
	--获得的经验文本
	self.LableGetExp=self.view:getChildByName("bg_2"):getChildByName("Text_31")
	--升级所需要的经验
	self.LableNeedExp=self.view:getChildByName("bg_2"):getChildByName("Text_31_0")
	--确定按钮
	self.BtnSure =self.view:getChildByName("Button_er")
	self.BtnSure:addTouchEventListener(handler(self,self.onSureCallBack))
	--
	self.jiantou = self.view:getChildByName("Image_5")

	self._bg_2:getChildByName("txt_jinghua"):setVisible(false)

	--所需要升级数据
	--self.TageData = nil
	--self._getExp = 0
	--self._needExp = 0
	self._selectMax=5
	self.nowselectnum=0
	-- 1 吞噬界面 2 进化选择
	self.pageIndex = 1

	--mgr.ViewMgr:setallLayerCansee(false,_viewname.DEVOUR_MATERIAL)
	--self:initListView()

	if mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER) then 
		mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER):setVisible(true)
	end
	
    G_FitScreen(self,"bg_factory")

    self:initDec()
end

function DevourMaterialListView:initDec()
	-- body
	self._bg_2:getChildByName("Text_29"):setString(res.str.PET_DEC_01)
	self._bg_2:getChildByName("Text_29_0"):setString(res.str.PET_DEC_02)
	self._bg_2:getChildByName("txt_jinghuadec"):setString(res.str.PET_DEC_05)
	self._bg_2:getChildByName("txt_jinghua"):setString(res.str.PET_DEC_04)

	self.view:getChildByName("Button_er"):setTitleText(res.str.PET_DEC_03)
	
end

function DevourMaterialListView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
    return size
end

function DevourMaterialListView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function DevourMaterialListView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function DevourMaterialListView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function DevourMaterialListView:cellSizeForTable(table,idx) 
	local ccsize = self._widgetClone:getContentSize()    
    return ccsize.height,ccsize.width
end

function DevourMaterialListView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data = self.data[idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=DevourMaterialWidget.new()   
		widget:init(self,idx+1)
		widget:setData(data)
		widget:setbtnVis(self.pageIndex)
    	widget:addCallBack(handler(self,self.onSelectCallBack))

        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
    else
    	widget = cell:getChildByName("widget")
       	widget:setData(data,idx)
    end
   	for k ,v in pairs(self.SelectPetListData) do 
		if not v.cout  then 
	   		if v == data  then 
	   			widget:setSelected(true)
		 		if self.pageIndex == 2  then 
		 			widget:setBtnfalse()
		 		end
		 		break
	   		end
	   	else
	   		if v.cout == data.cout then 
	   			widget:setSelected(true)
		 		if self.pageIndex == 2  then 
		 			widget:setBtnfalse()
		 		end
		 		break
	   		end 
	   	end 
	end 

    return cell
end

function DevourMaterialListView:inittableView()
	-- body
	if not self.tableView then 
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
	    self.tableView:reloadData()
	    --self:loadInRunAction()
	else
		self.tableView:reloadData()
		--self:loadInRunAction()
	end 
end



--已经选择的列表
function DevourMaterialListView:setSelectPetListData( data)
	for k ,v in pairs(data) do 
		table.insert(self.SelectPetListData,v)
	end 
	self.nowselectnum = #self.SelectPetListData
	--self.SelectPetListData =  data
	
end
--下一级需求的经验
function DevourMaterialListView:setNeedExp( exp)
	self.LableNeedExp:setString(exp)
end



--
function DevourMaterialListView:setData(data,data2)
	--self.data = {}
	self.data={}

	for k ,v in pairs(data ) do 
		if conf.Item:getType(v.mId) ~= pack_type.PRO then
			if v.propertys[317] and v.propertys[317].value > 0 then
			else
				table.insert(self.data,v)
			end
		end
	end 

	if data2 then 
		for k ,v in pairs(data2 ) do 
			if conf.Item:getType(v.mId) == pack_type.PRO then
				table.insert(self.data,v)
			end
		end 
	end 


	table.sort(self.data,function(a,b)
		-- body
		local atype = conf.Item:getType(a.mId)
		atype = atype == pack_type.PRO and 0 or 1
		local btype = conf.Item:getType(b.mId)
		btype = btype == pack_type.PRO and 0 or 1


		local acolor = conf.Item:getItemQuality(a.mId)
		local bcolor = conf.Item:getItemQuality(b.mId)

		local alv = mgr.ConfMgr.getLv(a.propertys)
		local blv = mgr.ConfMgr.getLv(b.propertys)

		local aJLlv =  mgr.ConfMgr.getItemJh(a.propertys)
		local bJLlv =  mgr.ConfMgr.getItemJh(b.propertys)

		local apower = mgr.ConfMgr.getPower(a.propertys)
		local bpower = mgr.ConfMgr.getPower(b.propertys)
		if atype == btype then 
			if acolor == bcolor then 
				if alv == blv then 
					if aJLlv == bJLlv then 
						if apower == bpower then 
							return a.mId<b.mId
						else
							return apower < bpower
						end 
					else 
						return aJLlv < bJLlv
					end 
				else
					return alv < blv
				end 
			else
				return acolor<bcolor
			end 
		else
			return atype < btype
		end 
	end)

	--self.lv:removeAllItems()
    --self.lv:onCleanup()

   --	self.lv:reload()
   self:inittableView()

   	self.LableGetExp:setString(self:getExp())
end

--计算选择的列表总经验
function DevourMaterialListView:getExp(  )
	local exp = 0
	for k ,v in pairs(self.SelectPetListData) do 
		local atype = conf.Item:getType(v.mId)	
		if atype ~= pack_type.PRO then 
			local quality = conf.Item:getItemQuality(v.mId)
			local lv = mgr.ConfMgr.getLv(v.propertys)
			exp = exp+conf.CardExp:getExp(conf.Item:getItemSjPre(v.mId),lv)
		else
			local addexp = conf.Item:getExp(v.mId)
			exp = exp + addexp
		end
	end 
	return exp
end

function DevourMaterialListView:addCallBack2(fun)
	-- body
	self.callbackfun = fun
end

---勾选打上勾
function DevourMaterialListView:onSelectCallBack(eventype,data)
	-- body
	if eventype == 0 then--勾选
		--print("self:getExp() ="..self:getExp())
		local bl = self.callbackfun(self:getExp())
		if not bl and #self.SelectPetListData>0 then 
			return false
		end 
		--[[if self:getExp()>= tonumber(self.LableNeedExp:getString()) then --如果经验够了
			--debugprint("其实经验够了 但是就不飘个字给你看")
			return false
		end ]]--

		if self.nowselectnum >= self._selectMax then
			return false
		else
			self.nowselectnum=self.nowselectnum+1
		end
		table.insert(self.SelectPetListData,data)
	elseif eventype == 1 then
		self.nowselectnum=self.nowselectnum-1
		self:removePetListDataByData(data)
	end
	self.LableGetExp:setString(self:getExp())
	return true
end


--
--选择的是否数已满
function DevourMaterialListView:isSelectFull(  )
	if self.nowselectnum < self._selectMax then
		self.nowselectnum=self.nowselectnum+1
		return false
	else
		return true
	end
end
--勾选够 加入选择列表
function DevourMaterialListView:puskPetListData( data)
	table.insert(self.SelectPetListData,data)
	--[#self.SelectPetListData+1]=data
end
function DevourMaterialListView:removeLastPetListData()
	self.SelectPetListData[#self.SelectPetListData]=nil 
end
function DevourMaterialListView:removePetListDataByData(data)
	for i,v in ipairs(self.SelectPetListData) do
		if not v.cout  then 
			if v == data then
				table.remove(self.SelectPetListData,i)
				break
			end
		else
			if v.cout == data.cout then
				table.remove(self.SelectPetListData,i)
				break
			end 
		end 
	end
	debugprint("删除后"..#self.SelectPetListData)
end

--
function DevourMaterialListView:getSelectPetListData( )
	return self.SelectPetListData 
end

function DevourMaterialListView:onSureCallBack(send,evevttype)
	if evevttype == ccui.TouchEventType.ended then
		local view=mgr.ViewMgr:get(_viewname.PROMOTE_LV)
		if view then
			view:selectSearch(self:getSelectPetListData())
		end
		self:closeSelfView()
	end
end
function DevourMaterialListView:closeSelfView(  )
	self.super.closeSelfView(self)
	--mgr.ViewMgr:setallLayerCansee(true,_viewname.BATTLE_LIST)
	mgr.SceneMgr:getMainScene():addHeadView()
end
function DevourMaterialListView:onCloseSelfView(  )
	-- body
	--self.lv:removeAllItems()
	--self.lv:onCleanup()
	self.super.onCloseSelfView(self)
	local view=mgr.ViewMgr:get(_viewname.PROMOTE_LV)
	if view then
		local data = {}
		--print("")
		view:selectSearch(data)
	end
	--mgr.ViewMgr:setallLayerCansee(true,_viewname.BATTLE_LIST)
end

function DevourMaterialListView:getWidgetClone()
	return self._widgetClone:clone()
end


function DevourMaterialListView:CardJingjie()
	-- body
	self.pageIndex = 2
	local array = self._bg_2:getChildren()
	for k ,v in pairs (array) do 
		if v:getName() == "txt_jinghuadec" or v:getName() == "txt_jinghua" then 
			v:setVisible(true)
		else
			v:setVisible(false)
		end 
	end	
	self.BtnSure:setVisible(false)

	self._sprTitile:loadTexture(res.font.DEVOUR[1])

end

return DevourMaterialListView