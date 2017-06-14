--[[
	GuildMemberView --公会成员
]]
local GuildMemberView = class("GuildMemberView",base.BaseView)

function GuildMemberView:ctor( ... )
	-- body
	self.data = {
		{},
		{}
	}
end

function GuildMemberView:init(index)
	-- body
	--proxy.guild:sendShengheList()
	

	self.ShowAll=true
    self.bottomType = 1
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
	-- 成员 -- 审核
	local panel_up = self.view:getChildByName("Panel_1")
	self.PageButton= gui.PageButton.new()
	self.PageButton:addButton(panel_up:getChildByName("Button_1"))
	self.PageButton:addButton(panel_up:getChildByName("Button_1_0"))
	self.PageButton:setBtnCallBack(handler(self,self.ListButtonCallBack))

	--排序 
	self.pagebtn = gui.PageButton.new()
	self.pagebtn:addButton(panel_up:getChildByName("Button_1_1"))
	self.pagebtn:addButton(panel_up:getChildByName("Button_1_1_0"))
	self.pagebtn:addButton(panel_up:getChildByName("Button_1_1_1"))
	self.pagebtn:setBtnCallBack(handler(self,self.ListButtonCallBack1))
	--用来做tableview
	self.panle_fortable_1 = self.view:getChildByName("Panel_3") 
	--每一个ITEM 
	self.cloneitem_1 = self.view:getChildByName("Panel_4")

	------审核用的
	self.panel_sh = self.view:getChildByName("Panel_10") 
	self.panle_fortable_2 = self.panel_sh:getChildByName("Panel_2") 

	--关闭按钮
	local btn = self.panel_sh:getChildByName("Button_2_1")
	btn:addTouchEventListener(handler(self, self.closeView))

	self.cloneitem_2 = self.panel_sh:getChildByName("Panel_3_0")
	self.cur_member = self.panel_sh:getChildByName("Text_18_0")
	self.max_member = self.panel_sh:getChildByName("Text_18_0_0")

	local down =self.panel_sh:getChildByName("Image_18") 
	down:setPositionY(down:getPositionY()+10)
	self.panel_sh:reorderChild(down,500)

	G_FitScreen(self,"Image_1")
	self:initDesc()

	self.pageindex = 1
	if index==2 then 
		self.pageindex = 2 
	else
		--proxy.guild:sendCallMember()
	end 
	--self.PageButton:initClick(index)
	self.PageButton:initClick(self.pageindex)
	
end

function GuildMemberView:initDesc( ... )
	-- body
	local Panel_1 = self.view:getChildByName("Panel_1")
	Panel_1:getChildByName("Button_1"):setTitleText (res.str.GUILD_DEC_23)
	Panel_1:getChildByName("Button_1_0"):setTitleText(res.str.GUILD_DEC_24)

	Panel_1:getChildByName("Button_1_1"):getChildByName("Text_1"):setString(res.str.GUILD_DEC_25)
	Panel_1:getChildByName("Button_1_1_0"):getChildByName("Text_1_3"):setString(res.str.GUILD_DEC_26)
	Panel_1:getChildByName("Button_1_1_1"):getChildByName("Text_1_5"):setString(res.str.GUILD_DEC_27)

	self.cloneitem_1:getChildByName("Text_7_1_0"):setString(res.str.GUILD_DEC_28)
	self.cloneitem_1:getChildByName("Text_7_1_0_0"):setString(res.str.GUILD_DEC_29)

	self.panel_sh:getChildByName("Button_2_1"):setTitleText(res.str.GUILD_DEC_30)

	self.cloneitem_2:getChildByName("Image_8_31"):getChildByName("Text_1_0_27"):setString(res.str.GUILD_DEC_31)
	self.cloneitem_2:getChildByName("Image_8_31"):getChildByName("Text_1_0_0_29"):setString(res.str.GUILD_DEC_32)
	self.cloneitem_2:getChildByName("Button_2_0_20"):setTitleText(res.str.GUILD_DEC_33)
	self.cloneitem_2:getChildByName("Button_2_18"):setTitleText(res.str.GUILD_DEC_34)

	self.panel_sh:getChildByName("Text_18"):setString(res.str.GUILD_DEC_35)
end

function GuildMemberView:ishitTest( postion )
	-- body
	return self.panle_fortable_2:hitTest(postion)
end

function GuildMemberView:closeView( sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		local data = {}
		data.sure = function( ... )
			-- body
			--debugprint("清除所有的东西")
			--for k ,v in pairs(self.data[2]) do 
				local params = {roleId = -1,isOk = 2 }
				proxy.guild:sendShenghe(params)
			--end 
		end

		data.surestr = res.str.SURE
		data.cancel =function( ... )
			-- body
		end
		data.richtext = res.str.GUILD_DEC50
		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)
		--self:onCloseSelfView()
	end 
end

function GuildMemberView:pagebtninit( index )
	-- body
	if self.pageindex == index then 
		self.pagebtn:initClick(1)
	end 
	
end

function GuildMemberView:ListButtonCallBack( index , eventtype )
	-- body
	--print("index = "..index)
	local txt = self.view:getChildByName("Panel_1"):getChildByName("Button_1_1_0"):getChildByName("Text_1_3")

	self.panel_sh:setVisible(false)
	self.pageindex = index
	if self.pageindex == 2 then 
		proxy.guild:sendShengheList()
		self.panel_sh:setVisible(true)
		txt:setString(res.str.GUILD_DEC52)
	else
		txt:setString(res.str.GUILD_DEC51)
		proxy.guild:sendCallMember()
	end 

	if self.tableView then 
		self.tableView:removeFromParent()
		self.tableView = nil 
	end 
	--if index == 1 then 
		self.pagebtn:initClick(1)
	--end 
	return self
end



function GuildMemberView:ListButtonCallBack1( index,eventtype )
	-- body
	debugprint("anxia "..index)
	debugprint("self.pageindex "..self.pageindex)
	if index == 1 then --时间
		
		table.sort(self.data[self.pageindex],function( a,b )
			-- body
			local ajob = a.job  and  a.job or 0
			local bjob = b.job  and  b.job or 0
			if a.lastTime == b.lastTime then 
				if ajob == bjob then 
					if a.power == b.power then 
						if a.roleLevel == b.roleLevel then 
							return a.roleId.high<b.roleId.high
						else
							return a.roleLevel>b.roleLevel
						end 
					else
						return a.power>b.power
					end 
				else
					return ajob<bjob
				end 	
			else
				return a.lastTime<b.lastTime
			end 
		end)

	elseif index == 2 then --等级
		if self.pageindex == 1 then 
			table.sort(self.data[self.pageindex],function( a,b )
				-- body
				local ajob = a.job  and  a.job or 0
				local bjob = b.job  and  b.job or 0

				if a.totalPoint == b.totalPoint then 
					if a.lastTime == b.lastTime then 
						if ajob == bjob then 
							if a.power == b.power then 
								return a.roleId.high<b.roleId.high
							else
								return a.power>b.power
							end 
						else
							return ajob < bjob
						end 	
					else
						return a.lastTime<b.lastTime
					end 
				else
					return 	a.totalPoint > b.totalPoint
				end 
			end)
		else
			table.sort(self.data[self.pageindex],function( a,b )
			-- body
				if a.roleLevel==b.roleLevel then 
					if ajob == bjob then 
						if a.lastTime == b.lastTime then 
							if a.power == b.power then 
								return a.roleId.high<b.roleId.high
							else
								return a.power>b.power
							end 
						else
							return a.lastTime<b.lastTime
						end 
					else
						return ajob<bjob
					end 
				else
					return a.roleLevel>b.roleLevel
				end 
			end)
		end 
	elseif index == 3 then  -- 战力
		table.sort(self.data[self.pageindex],function( a,b )
			-- body
			local ajob = a.job  and  a.job or 0
			local bjob = b.job  and  b.job or 0
			if a.power == b.power then 
				if ajob == bjob then 
					if a.lastTime == b.lastTime then 
						if a.roleLevel == b.roleLevel then
							return a.roleId.high<b.roleId.high
						else
							return a.roleLevel>b.roleLevel
						end 
					else
						return a.lastTime<b.lastTime
					end 
				else
					return ajob<bjob
				end 
			else
				return a.power>b.power
			end 
		end)
	end 
	self:inittableView()
	return self
end

function GuildMemberView:setData1()
	-- body
	self.data[1] = clone(cache.Guild:getMemberInfo())
end

function GuildMemberView:setData2()
	-- body
	self.data[2] =  clone(cache.Guild:getShenhe()) 
	self:setMember()
end




function GuildMemberView:getColnePnaleItem()
	-- body
	return self["cloneitem_"..self.pageindex]:clone()
end

function GuildMemberView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data[self.pageindex]
	--debugprint("size = "..size)
    return size
end

function GuildMemberView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function GuildMemberView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function GuildMemberView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end 

function GuildMemberView:cellSizeForTable(table,idx) 
	local ccsize = self["cloneitem_"..self.pageindex]:getContentSize()    
    return ccsize.height,ccsize.width
end

function GuildMemberView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data[self.pageindex][idx+1]
   -- print("strValue="..strValue)
    if nil == cell then
        cell = cc.TableViewCell:new()
        if self.pageindex == 2 then 
        	widget=CreateClass("views.guild.GuildShengheItem")  
        else
           	--todo
            widget=CreateClass("views.guild.GuildMemberItem") 
        end    
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
    return cell
end

function GuildMemberView:inittableView()
	-- body
	if not self.tableView then 
		local posx ,posy = self["panle_fortable_"..self.pageindex] :getPosition()
		local ccsize =  self["panle_fortable_"..self.pageindex]:getContentSize() 

		self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	    self.tableView:setPosition(cc.p(posx, posy))
	    self.tableView:setDelegate()
	    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	    if self.pageindex then 
	    	self.view:addChild(self.tableView,100)
	    else
	    	self.panel_sh:addChild(self.tableView,100)
	    end 
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

function GuildMemberView:setMember()
	-- body
	local count = cache.Guild:getGuildCount() 
	self.cur_member:setString(count)

	local level = cache.Guild:getGuildLevel()
	level = level ~= 0 and level or 1
	local maxCount = conf.guild:getLimitCount(level)
	self.max_member:setString("/"..maxCount)

	--调整一下位置
	self.max_member:setPositionX(self.cur_member:getPositionX()+self.cur_member:getContentSize().width
		+5)
end

function GuildMemberView:delItembyData( data_,flag )
	-- body
	if flag and flag == 2 then  --全部清除
		self.data[2] = {}
		self:inittableView()
		return 
	end

	local idx  = 0
	for k , v in pairs(self.data[2]) do 
		if v.roleId.key == data_.roleId.key then 
			idx = k -1
			--debugprint("找到了对应的位置") 
			break;
		end 
	end  

	table.remove(self.data[2],idx+1)

	self:inittableView()
	self:setMember()

	local num = math.ceil(self.panle_fortable_2:getContentSize().height/self.cloneitem_2:getContentSize().height)
	if  idx < num then 
		return 
	end 
	
	local offset = {
		x = 0 ,
		y = (idx+1) * self.cloneitem_2:getContentSize().height  - self.tableView:getContentSize().height	  
	}
	self.tableView:setContentOffset(offset)
end

function GuildMemberView:delItembyRoleId( roleId )
	-- body
	local idx  = 0
	for k , v in pairs(self.data[1]) do 
		if v.roleId.key == roleId.key then 
			idx = k -1
			---debugprint("找到了对应的位置") 
			break;
		end 
	end  

	table.remove(self.data[1],idx+1)
	self:inittableView()
	local num = math.ceil(self.panle_fortable_1:getContentSize().height/self.cloneitem_1:getContentSize().height)
	if  idx < num then 
		return 
	end 
	
	local offset = {
		x = 0 ,
		y = (idx+1) * self.cloneitem_1:getContentSize().height  - self.tableView:getContentSize().height	  
	}
	self.tableView:setContentOffset(offset)
end

function GuildMemberView:onCloseSelfView()
	-- body
	G_MainGuild()
	--mgr.SceneMgr:getMainScene():changeView(0, _viewname.GUILD_VIEW)
end



return GuildMemberView
