--GuildSearchView
--[[
	公会查找
]]--


local GuildSearchView=class("GuildSearchView",base.BaseView)


function GuildSearchView:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	local panle_up =self.view:getChildByName("Panel_16")

	self.view:reorderChild(panle_up, 500)

	local btnCreate = panle_up:getChildByName("Button_23") 
	btnCreate:addTouchEventListener(handler(self, self.onBtnCreate))

	local _name_di = panle_up:getChildByName("Image_117") 
	self.lab_name  = cc.ui.UIInput.new({
	    image = res.image.TRANSPARENT,
	    x = _name_di:getPositionX(),
	    y = _name_di:getPositionY(),
	    size = cc.size(_name_di:getContentSize().width,_name_di:getContentSize().height)
	})
	self.lab_name:addTo(panle_up)
	self.lab_name:registerScriptEditBoxHandler(handler(self, self.onName))

	--拿来做居中显示，妈的
	self.label = display.newTTFLabel({
    text = res.str.GUILD_DEC3,
    font = res.ttf[1],
    size = 24,
    color = cc.c3b(192,192,192) ,
    align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
    x=_name_di:getContentSize().width/2,
    y=_name_di:getContentSize().height/2,
    })
    self.label:setAnchorPoint(cc.p(0.5,0.5))
    self.label:addTo(_name_di)
    --把edibox 藏起来
	panle_up:reorderChild(_name_di,500)
	panle_up:reorderChild(self.lab_name,400)

	--搜索按钮
	local btnSearch = panle_up:getChildByName("Button_25") 
	btnSearch:addTouchEventListener(handler(self, self.onSearchcall))
	--item
	self.panelFoartableview = self.view:getChildByName("Panel_31")
	self.cloneItem = self.view:getChildByName("Panel_Clone_0")

	local _img_down = self.view:getChildByName("Image_104")
	self.view:reorderChild(_img_down, 500) 

	G_FitScreen(self,"Image_36")

	self:initDec()

	mgr.SceneMgr:getMainScene():addHeadView()
	--self:onSearchcall(btnSearch,ccui.TouchEventType.ended)
end

function GuildSearchView:initDec( ... )
	-- body
	local Panel_16 = self.view:getChildByName("Panel_16")
	Panel_16:getChildByName("Button_23"):setTitleText(res.str.GUILD_DEC_49)

	self.cloneItem:getChildByName("Button_Using_26_7_84"):setTitleText(res.str.GUILD_DEC_50)
	
end

--输入信息后
function GuildSearchView:onName( eventype )
	-- body
	if eventype == "began" then
	elseif  eventype == "ended" then
		local str = string.trim(self.lab_name:getText())
		if str == "" then 
			self.label:setString(res.str.GUILD_DEC3)
		else
			self.label:setString(str)
		end 
	elseif eventype == "changed" then
	elseif eventype == "return" then
		local str = string.trim(self.lab_name:getText())
		--print("str = "..str)
		if str == "" then 
			self.label:setString(res.str.GUILD_DEC3)
		else
			self.label:setString(str)
		end 
	end
end

--创建公会
function GuildSearchView:onBtnCreate( sender_,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		mgr.ViewMgr:showView(_viewname.GUILD_CREATE)
	end 
end

function GuildSearchView:onSearchcall( sender_,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		local str = string.trim(self.label:getString())
		local params = {guildName = "" , first = true ,page = 1 }
		if str~=res.str.GUILD_DEC3  then 
			params.guildName = str
		end 
		--print("page = "..page)
		proxy.guild:sendSearch(params)
	end 
end

function GuildSearchView:setData()
	-- body
	self.data = cache.Guild:getSearchData()
	self:inittableView()
end

function GuildSearchView:updateData(  )
	-- body
	self.data = cache.Guild:getSearchData()
end

function GuildSearchView:updateDataByidx( idx )
	-- body
	local cell = self.tableView:cellAtIndex(idx)
	if cell then 
		local data= self.data[idx+1]
		cell:getChildByName("widget"):setData(data,idx)
	end 
end

function GuildSearchView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
    return size
end

function GuildSearchView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function GuildSearchView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function GuildSearchView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end 

function GuildSearchView:cellSizeForTable(table,idx) 
	local ccsize = self.cloneItem:getContentSize()    
    return ccsize.height,ccsize.width
end

function GuildSearchView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
     local data= self.data[idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.guild.GuildSearchitem")     
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

    if idx + 2>#self.data then 
    	self.idx = idx
    	debugprint("尝试请求下一页")

    	local str = self.label:getString()
    	if str == res.str.GUILD_DEC3 then 
    		str = ""
    	end 
    	local params = {guildName = str , first = false }
    	proxy.guild:sendSearch(params)
    	--proxy.Mail:sendMessage(self.packindex-1)
    end 

    return cell
end

function GuildSearchView:inittableView()
	-- body
	if not self.tableView then 
		local posx ,posy = self.panelFoartableview:getPosition()
		local ccsize =  self.panelFoartableview:getContentSize() 

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
	--debugprint(self.tableView:getContentSize().height)
	--debugprint(self.tableView:getContainer():getPositionY() )
	--debugprint("... self.tableView:getContentOffset() "..self.tableView:getContentOffset().y)
	if self.idx then 
		local num = math.ceil(self.panelFoartableview:getContentSize().height/self.cloneItem:getContentSize().height)
		if  self.idx < num then 
			return 
		end 
		
		local offset = {
			x = 0 ,
			y = (self.idx+1) * self.cloneItem:getContentSize().height  - self.tableView:getContentSize().height	  
		}
		self.tableView:setContentOffset(offset)
	end 
end

function GuildSearchView:getColnePnaleItem()
	-- body
	return self.cloneItem:clone()
end


function GuildSearchView:onCloseSelfView()
	-- body
	self:closeSelfView()

	---显示蛋疼的 聊天按钮
	local maintoplayerview = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
    if  maintoplayerview and tolua.isnull(maintoplayerview.btnChat) == false then
     	maintoplayerview.btnChat:setVisible(true)
     end
	G_mainView()
	--mgr.SceneMgr:getMainScene():changeView(1, _viewname.MAIN)
end

return GuildSearchView