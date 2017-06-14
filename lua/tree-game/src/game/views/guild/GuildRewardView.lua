--[[
	GuildRewardView --通关奖励
]]
local GuildRewardView = class("GuildRewardView",base.BaseView)

function GuildRewardView:init() 
	-- body

	self.bottomType = 2
	self.ShowAll=true
	self.showtype=view_show_type.OTHER
	self.view=self:addSelfView()

	local panle = self.view:getChildByName("Panel_1")
	self.lab_guanka  = panle:getChildByName("Text_6_1_0_0_0") 
	self.lab_zhanjie = panle:getChildByName("Text_6_1_0_0")

	local btnclose= panle:getChildByName("Button_close_0")
	btnclose:addTouchEventListener(handler(self, self.onbtnclose))


	self.panle_fortable = self.view:getChildByName("Panel_2") 
	self.cloneitem = self.view:getChildByName("Panel_3_0")
	self.rewarditem = self.view:getChildByName("Panel_14")

	self:initData()
	G_FitScreen(self, "Image_1")
	
	proxy.guild:sendRewadrMsg()

	self:initDec()
end

function GuildRewardView:initDec( ... )
	-- body
	local panle = self.view:getChildByName("Panel_1")
	panle:getChildByName("Button_close_0"):getChildByName("Text_1_0_6_13"):setString(res.str.GUILD_DEC_42)
	panle:getChildByName("Text_6_1_0_0"):setString(res.str.GUILD_DEC_43)
	panle:getChildByName("Text_6_1_0"):setString(res.str.GUILD_DEC_44)

	self.cloneitem:getChildByName("Button_close_0_0"):getChildByName("Text_1_0_6_13_11"):setString(res.str.GUILD_DEC_45)
	

end

function GuildRewardView:initData()
	-- body
	local fbid = cache.Guild:getGuilidfbid()
	-- local maxIdx =  conf.guild:getMaxChapterIdx()
	 local id = math.floor(fbid/100)
	-- if id % 5000 >= maxIdx then--106
	-- 	id = 500000 + (maxIdx - 1) * 100 + 4
	-- 	fbid = id
	-- 	G_TipsOfstr(fbid)
	-- end
	self.zhanji = id
	local zhanjie =  conf.guild:getGuildChapter(id)

	self.lab_zhanjie:setString(zhanjie.title)
	print("fbid = "..fbid)
	local guanka = conf.guild:getGuildFb(fbid)
	self.lab_guanka:setString(guanka.name)

	--self.lab_guanka:setString("")
	--self.lab_zhanjie:setString("")
end

function GuildRewardView:setData()
	-- body



	self.data = {}
	local resdata = conf.guild:getGuildFbAll()

	local data = cache.Guild:getFBreward()
	local maxid = 0
	local minid = 0
	for k , v in pairs(data) do 
		--print(tolua.type(k))
		--print("k = ".. k)
		if checkint(k) ~=0 then 
			if maxid == 0 then 
				maxid = tonumber(k) 
			end  
			if  tonumber(k)  > maxid then 
				maxid =  tonumber(k)  
			end 
			if minid == 0 then 
				minid =  tonumber(k)  
			end 

			if  tonumber(k)  < minid then 
				minid =  tonumber(k)  
			end 
		end 
	end 

	--print(data[tostring(minid)])

	for k ,v in pairs(resdata) do 
		--print("k="..k)
		local t = {}
		t.cId = v.id
		t.status = 0 --未达成
		t.data = v

		if data[tostring(v.id)] then
		    if tonumber(data[tostring(v.id)]) == 1 then 
				t.status = 1
			else
				t.status = 2
			end 
		else
			if minid > 0 then 
				if  minid >  tonumber(t.cId) then 
					t.status = 2
				end 
			else
				if tonumber(t.cId) <  self.zhanji then 
					t.status = 2
			end 
		end 	

		end 

		

		table.insert(self.data,t)
	end 

	table.sort(self.data,function(a,b)
		-- body
		local astatus = a.status == 1 and -1 or a.status
		local bstatus = b.status == 1 and -1 or b.status

		if astatus == bstatus then 
			return a.cId<b.cId
		else
			return astatus<bstatus
		end 

	end)

	local maxIdx =  conf.guild:getMaxChapterIdx()
	for k,v in pairs(self.data) do
		if v.cId == 5000 + maxIdx then
			table.remove(self.data,k)
		end
	end



	self:inittableView()
end

function GuildRewardView:getRewaditem()
	-- body
	return self.rewarditem:clone()
end

function GuildRewardView:getColnePnaleItem()
	-- body
	return self.cloneitem:clone()
end

function GuildRewardView:numberOfCellsInTableView(table)
	-- body
	local size=#self.data
    return size
end

function GuildRewardView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function GuildRewardView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function GuildRewardView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end 

function GuildRewardView:cellSizeForTable(table,idx) 
	local ccsize = self.cloneitem:getContentSize()    
    return ccsize.height,ccsize.width
end

function GuildRewardView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.data[idx+1]
    print("strValue="..strValue)
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.guild.GuildRewarditem")     
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

function GuildRewardView:inittableView()
	-- body
	if not self.tableView then 
		local posx ,posy = self.panle_fortable:getPosition()
		local ccsize =  self.panle_fortable:getContentSize() 

		self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	    self.tableView:setPosition(cc.p(posx, posy))
	    self.tableView:setDelegate()
	    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	    self:addChild(self.tableView,100)
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



function GuildRewardView:setDataByidx(idx)
	-- body
	if idx then 
		local num = math.ceil(self.panle_fortable:getContentSize().height/self.cloneitem:getContentSize().height)
		if idx < num then 
			return 
		end 
		
		local offset = {
			x = 0 ,
			y = (idx+1) * self.cloneitem:getContentSize().height  - self.tableView:getContentSize().height	  
		}
		self.tableView:setContentOffset(offset)
	end 
end

function GuildRewardView:onbtnclose(sender_,eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		self:onCloseSelfView()
	end 
end

function GuildRewardView:onCloseSelfView()
	self:closeSelfView()
end 

return GuildRewardView