--[[
	GuildTwoRank 两个排行（合并 本区和副本）  
]]

local GuildTwoRank = class("GuildTwoRank", base.BaseView)

function GuildTwoRank:init()
	self.ShowAll=true
    self.bottomType = 1
	self.showtype=view_show_type.OTHER
	self.view=self:addSelfView()

	local panle = self.view:getChildByName("Panel_11")
	local down =  self.view:getChildByName("Image_34")
	self.view:reorderChild(panle,500)
	self.view:reorderChild(down,500)

	self.PageButton=gui.PageButton.new()--创建分页按钮管理器
	local btn = panle:getChildByName("Button_1")
	self.PageButton:addButton(btn)
	local btn = panle:getChildByName("Button_1_0")
	self.PageButton:addButton(btn)
	self.PageButton:setBtnCallBack(handler(self, self.onPageButtonCallBack))

	local btnclose = panle:getChildByName("Button_close")
	btnclose:addTouchEventListener(handler(self, self.onbtnclose))

	self.panle_fortable = self.view:getChildByName("Panel_2") 
	

	--副本排行下面显示
	self.cloneitem_fb= self.view:getChildByName("Panel_1")
	local panle_down = self.view:getChildByName("Panel_10")
	self.lab_rank_fb = panle_down:getChildByName("Text_3")
	self.lab_reward_fb = panle_down:getChildByName("Text_2")
	self.panle_fb = panle_down

	--本区排行下面显示
	self.cloneitem_bq = self.view:getChildByName("Panel_1_0") 
	local panle_down = self.view:getChildByName("Panel_10_0")
	self.lab_rank_bq = panle_down:getChildByName("Text_3_44")
	self.panle_bq = panle_down

	self:clear()


	--界面文本
	--btn:setTitleText(res.str.GUILD_TEXT14)
	panle:getChildByName("Button_1_0"):setTitleText(res.str.GUILD_TEXT15)
	panle:getChildByName("Button_1"):setTitleText(res.str.GUILD_TEXT14)

	self.view:getChildByName("Panel_10"):getChildByName("Text_166"):setString(res.str.GUILD_TEXT7) 
	self.view:getChildByName("Panel_10"):getChildByName("Text_1"):setString(res.str.GUILD_TEXT16) 
	self.view:getChildByName("Panel_10"):getChildByName("Text_9"):setString(res.str.GUILD_TEXT17) 
	panle_down:getChildByName("Text_166_42"):setString(res.str.GUILD_TEXT7) 


	self.cloneitem_fb:getChildByName("Text_5"):setString(res.str.GUILD_TEXT18)
	self.cloneitem_fb:getChildByName("Text_6"):setString(res.str.GUILD_TEXT19)
	self.cloneitem_fb:getChildByName("Text_7"):setString(res.str.GUILD_TEXT20)

	self.cloneitem_bq:getChildByName("Text_5_48"):setString(res.str.GUILD_TEXT18)
	self.cloneitem_bq:getChildByName("Text_7_52"):setString(res.str.GUILD_TEXT21)
	self.cloneitem_bq:getChildByName("Text_6_50"):setString(res.str.GUILD_TEXT19)

	G_FitScreen(self, "Image_6")
end 

function GuildTwoRank:clear( ... )
	-- body
	self.panle_fb:setVisible(false)
	self.panle_bq:setVisible(false)
end

function GuildTwoRank:pageviewChange( index )
	-- body
	self.pageindex = index
	self.PageButton:initClick(self.pageindex)
end

function GuildTwoRank:onPageButtonCallBack(index,eventype)
	-- body
	debugprint("which one call .. "..index)
	if self.tableView then 
		self.tableView:removeSelf()
		self.tableView = nil 
	end 
	self.pageindex = index
	if index == 1 then  
		proxy.guild:sendBenQuguildRank(1)
        proxy.guild:waitFor(517304)
	else
		proxy.guild:sendguildRank(1)
        proxy.guild:waitFor(517306)
	end 

	return self
end

function GuildTwoRank:initData()
	-- body
	self.data = {{},{}}
end

function GuildTwoRank:setData1()
	-- body
	self:initData()
	self:clear()
	self.data[1] = cache.Guild:getRankInfoData()
	local myself = cache.Guild:getRankmyself()
	self.lab_rank_bq:setString(myself)
	self.panle_bq:setVisible(true)
	self:inittableView()
end

function GuildTwoRank:setData2(data_)
	-- body
	self:initData()
	self:clear()
	self.data[2] = data_.rankInfos
	local myself = data_.selfRank

	self.lab_rank_fb:setString(myself)
	if myself > 10 then 
		self.lab_rank_fb:setString(res.str.GUILD_DEC49)
	end 

	if myself and myself<11 then 
		local itemdata = conf.guild:getRankReward(myself)
		if itemdata then 
			self.lab_reward_fb:setString(itemdata.money_zs)
		else
			self.lab_reward_fb:setString("0")
		end 
	else
		self.lab_reward_fb:setString("")
	end 
	self.panle_fb:setVisible(true)
	self:inittableView()
end

function GuildTwoRank:getColnePnaleItem()
	-- GuildBenQuRank
	if self.pageindex == 1 then 
		return self.cloneitem_bq:clone()
	else
		return self.cloneitem_fb:clone()
	end
end

function GuildTwoRank:numberOfCellsInTableView(table)
	-- body
	local size=#self.data[self.pageindex]
    return size
end

function GuildTwoRank:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function GuildTwoRank:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function GuildTwoRank:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function GuildTwoRank:cellSizeForTable(table,idx) 
	local ccsize 
	if self.pageindex == 1 then 
		ccsize =  self.cloneitem_bq:getContentSize()
	else
		ccsize =  self.cloneitem_fb:getContentSize()
	end 
    return ccsize.height,ccsize.width
end


function GuildTwoRank:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data[self.pageindex][idx+1]
   	print("strValue="..strValue)
    if nil == cell then
        cell = cc.TableViewCell:new()
        if self.pageindex == 1 then 
       		widget=CreateClass("views.guild.GuildBenquRankItem")  
       	else
       		widget=CreateClass("views.guild.GuildRankItem")  
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
   if self.pageindex == 1 then 
	    if idx + 2>#self.data[self.pageindex] then 
	    	self.idx = idx
	    	debugprint("尝试请求下一页")
	    	local page = cache.Guild:getCurRankpage() 
	    	proxy.guild:sendBenQuguildRank(page+1)
	    	--proxy.Mail:sendMessage(self.packindex-1)
	    end 
	end 
    return cell
end


function GuildTwoRank:onbtnclose( send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end 
end

function GuildTwoRank:inittableView()
	-- body
	if not self.tableView then 
		debugprint("1")
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
		debugprint("2")
		self.tableView:reloadData()
	end 

	if self.pageindex == 1 then 
		if self.idx then 
			local num = math.ceil(self.panle_fortable:getContentSize().height/self.cloneitem_bq:getContentSize().height)
			if  self.idx < num then 
				return 
			end 
			
			local offset = {
				x = 0 ,
				y = (self.idx+1) * self.cloneitem_bq:getContentSize().height  - self.tableView:getContentSize().height	  
			}
			self.tableView:setContentOffset(offset)
		end 
	end 
end



function GuildTwoRank:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return GuildTwoRank

