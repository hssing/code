--[[
	GuildFBRank --副本排行
]]

local GuildFBRank = class("GuildFBRank", base.BaseView)

function GuildFBRank:init()
	-- body
	--消除红点 

	self.ShowAll=true
    self.bottomType = 1
	self.showtype=view_show_type.OTHER
	self.view=self:addSelfView()

	local panle = self.view:getChildByName("Panel_11")
	local down =  self.view:getChildByName("Image_34")
	--local btnclose = self.view:getChildByName("Button_close")

	self.view:reorderChild(panle,500)
	self.view:reorderChild(down,500)
	--self.view:reorderChild(btnclose,501)

	--用来做tableview
	self.panle_fortable = self.view:getChildByName("Panel_2") 
	--每一个ITEM 
	self.cloneitem= self.view:getChildByName("Panel_1")

	local panle_down = self.view:getChildByName("Panel_10")
	self.lab_rank = panle_down:getChildByName("Text_3")
	self.lab_reward = panle_down:getChildByName("Text_2")

	local btnclose = panle:getChildByName("Button_close")
	btnclose:addTouchEventListener(handler(self, self.onbtnclose))

	G_FitScreen(self, "Image_6")
end

function GuildFBRank:onbtnclose( send,eventype  )
	-- body
	if eventype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end 
end

function GuildFBRank:setData(data_)
	-- body
	self.data = data_.rankInfos--cache.Guild:getRankInfoData()
	local myself = data_.selfRank--cache.Guild:getRankmyself()
	self.lab_rank:setString(myself)
	if myself > 10 then 
		self.lab_rank:setString(res.str.GUILD_DEC49)
	end 

	--self.lab_rank:setString(myself)
	if myself then 
		local itemdata = conf.guild:getRankReward(myself)
		if itemdata then 
			self.lab_reward:setString(itemdata.money_zs)
		else
			self.lab_reward:setString("0")
		end 
	else
		self.lab_reward:setString("")
	end 

	self:inittableView()
end

function GuildFBRank:getColnePnaleItem()
	-- body
	return self.cloneitem:clone()
end

function GuildFBRank:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
	--debugprint("size = "..size)
    return size
end

function GuildFBRank:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function GuildFBRank:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function GuildFBRank:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end 

function GuildFBRank:cellSizeForTable(table,idx) 
	local ccsize = self.cloneitem:getContentSize()    
    return ccsize.height,ccsize.width
end

function GuildFBRank:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data[idx+1]
   -- print("strValue="..strValue)
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.guild.GuildRankItem")  
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

    --[[if idx + 2>#self.data then 
    	self.idx = idx
    	debugprint("尝试请求下一页")
    	local page = cache.Guild:getCurRankpage() 
    	proxy.guild:sendBenQuguildRank(page+1)
    	--proxy.Mail:sendMessage(self.packindex-1)
    end ]]--
    return cell
end

function GuildFBRank:inittableView()
	-- body
	if not self.tableView then 
		local posx ,posy = self.panle_fortable:getPosition()
		local ccsize =  self.panle_fortable:getContentSize() 

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

	if self.idx then 
		local num = math.ceil(self.panle_fortable:getContentSize().height/self.cloneitem:getContentSize().height)
		if  self.idx < num then 
			return 
		end 
		
		local offset = {
			x = 0 ,
			y = (self.idx+1) * self.cloneitem:getContentSize().height  - self.tableView:getContentSize().height	  
		}
		self.tableView:setContentOffset(offset)
	end 
end


function GuildFBRank:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return GuildFBRank