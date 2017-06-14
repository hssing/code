
local runeDevorItemWiget=require("game.views.rune.runeDevorItem")
local RuneDevourListView = class("RuneDevourListView",base.BaseView)

function RuneDevourListView:ctor()
	-- body
	self.SelectPetListData = {}
	self.selectMax=5
	self.curexp = 0
end

function RuneDevourListView:init()
	-- body
	self.ShowAll = true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	self.ListView=self.view:getChildByName("ListView_1")
	self.ListView:setTouchEnabled(false)
	self._widgetClone=self.view:getChildByName("Panel_Clone")
	--
	self._bg_2 = self.view:getChildByName("bg_2")

	--获得的经验文本
	self.LableGetExp=self.view:getChildByName("bg_2"):getChildByName("Text_31")
	--升级所需要的经验
	self.LableNeedExp=self.view:getChildByName("bg_2"):getChildByName("Text_31_0")
	--确定按钮
	self.BtnSure =self.view:getChildByName("Button_er")
	self.BtnSure:addTouchEventListener(handler(self,self.onSureCallBack))

	self:initDec()

	if mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER) then 
		mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER):setVisible(true)
	end

	 G_FitScreen(self,"bg_factory")
end


function RuneDevourListView:setNeedExp(exp)
	-- body
	self.needexp = exp
	if self.needexp == 0 then
		self.LableNeedExp:setString(1)
	else
		self.LableNeedExp:setString(self.needexp)
	end
end

function RuneDevourListView:initDec( ... )
	-- body
	self._bg_2:getChildByName("Text_29"):setString(res.str.PET_DEC_01)
	self._bg_2:getChildByName("Text_29_0"):setString(res.str.PET_DEC_02)
	self.LableGetExp:setString(0)
	self.LableNeedExp:setString(0)
	self.BtnSure:setTitleText(res.str.PET_DEC_03)
end

function RuneDevourListView:getWidgetClone()
	return self._widgetClone:clone()
end

function RuneDevourListView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
    return size
end

function RuneDevourListView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function RuneDevourListView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function RuneDevourListView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function RuneDevourListView:cellSizeForTable(table,idx) 
	local ccsize = self._widgetClone:getContentSize()    
    return ccsize.height,ccsize.width
end

function RuneDevourListView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data = self.data[idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=runeDevorItemWiget.new()   
		widget:init(self)
		widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
		widget:setData(data)
		widget:addTo(cell)
    else
    	widget = cell:getChildByName("widget")
       	widget:setData(data)
    end
    for k ,v in pairs(self.SelectPetListData) do
    	if v.index == data.index then
    		widget:setBtnfalse()
    	end
    end
    return cell
end

function RuneDevourListView:check(data,flag)
	-- body
	if flag then
		if not self.conf_next then
			G_TipsOfstr(res.str.DEC_NEW_22)
			return 
		end

		if #self.SelectPetListData >=5 then
			G_TipsOfstr(res.str.DEC_NEW_23)
			return false
		end

		local exp = 0
		for k ,v in pairs(self.SelectPetListData) do 
			exp = exp + G_ExpofRune(v) 
		end
		print("exp = "..exp)

		if exp + G_ExpofRune(self.maindata) >= self.maxexp then --添加的 道具 已经够最大等级
			G_TipsOfstr(res.str.DEC_NEW_38)
			return false
		end
		--[[local lv , statue = G_CanUptolv(self.maindata,self.curexp + G_ExpofRune(data))
		if lv == 0 then
			if statue == 2 then
				G_TipsOfstr(res.str.DEC_NEW_24)
				
			end
			return false 
		elseif lv == cache.Player:getLevel() then
			if statue == 2 then
				G_TipsOfstr(res.str.DEC_NEW_24)
				return false
			end
		end

		if #self.SelectPetListData >=5 then
			G_TipsOfstr(res.str.DEC_NEW_23)
			return false
		end]]--

		table.insert(self.SelectPetListData,data)
		self:setgetExp()
		return true
	else
		self:removePetListDataByData(data)
		self:setgetExp()
		return true
	end
end

function RuneDevourListView:setgetExp(  )
	-- body
	local exp = 0
	for k ,v in pairs(self.SelectPetListData ) do 
		exp = exp +  G_ExpofRune(v)
	end
	self.exp = exp
	self.LableGetExp:setString(self.exp)
end

--移除一个
function RuneDevourListView:removePetListDataByData(data)
	-- body
	for i,v in ipairs(self.SelectPetListData) do
		if v.index == data.index then
			table.remove(self.SelectPetListData,i)
			break
		end
	end
	self:setgetExp()
end
--设置已经选择的经验
function RuneDevourListView:setSelect(data)
	-- body
	self.SelectPetListData = clone(data)
	self:setgetExp()
end

function RuneDevourListView:setUseFor(data )
	-- body
	self.maindata = data

	--计算升到最大等级需要 --上限是人物等级 或者是 装备上限等级
	self.maxexp = 0

	local lv = data.propertys[315] and data.propertys[315].value or 0

	local maxlv = conf.Item:getMaxQhLv(data.mId) --可升到的最高等级
	local maxplayerLv = cache.Player:getLevel() --玩家等级
	--local max = math.min(maxlv,maxplayerLv)
	local max = maxlv
	local att_pre = conf.Item:getAttPre(data.mId)
	local id_max = att_pre .. string.format("%03d",max)
	local maxconf = conf.Rune:getItem( id_max )
	self.maxlv = maxlv --能升到的最大等级
	self.maxexp = maxconf.all_exp --升到最大等级所需的经验

	--计算下一级需要
	local id  = att_pre .. string.format("%03d",lv)
	local nextid = att_pre .. string.format("%03d",lv+1)
	self.conf_next = conf.Rune:getItem( nextid )
end

function RuneDevourListView:inittableView()
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
	else
		self.tableView:reloadData()
	end 
end

function RuneDevourListView:setData(data_)
	-- body
	self.data = cache.Rune:getPackinfo()
	table.sort(self.data,function( a,b )
		-- body
		local acolorlv = conf.Item:getItemQuality(a.mId)
		local bcolorlv = conf.Item:getItemQuality(b.mId)

		local apower = mgr.ConfMgr.getPower(a.propertys)
        local bpower = mgr.ConfMgr.getPower(b.propertys)

		if acolorlv == bcolorlv then 
			if apower == bpower then 
				return a.index < b.index
			else
				return apower < bpower
			end 
		else
			return acolorlv<bcolorlv
		end 
	end)
	self:inittableView()
end


function RuneDevourListView:onSureCallBack(send_,evevttype)
	-- body
	if evevttype == ccui.TouchEventType.ended then
		debugprint("确定回调")
		local view=mgr.ViewMgr:get(_viewname.RUNE_LV)
		if view then
			view:setSelectList(self.SelectPetListData)
		end
		self:onCloseSelfView()
	end
end

function RuneDevourListView:onCloseSelfView( )
	self.super.onCloseSelfView(self)
	mgr.SceneMgr:getMainScene():addHeadView()
end
return RuneDevourListView