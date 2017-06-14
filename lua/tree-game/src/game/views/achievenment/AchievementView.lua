

local AchievementView=class("AchievementView",base.BaseView)

function AchievementView:init()
	--
	proxy.task:sendMessagetype(2)--请求成就

	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.ListGUIButton={}  --GUI按钮容器
	for i = 1 , 2 do 
		local btn=self.view:getChildByTableTag(1,i)
		local gui_btn=gui.GUIButton.new(btn,nil,{ImagePath=res.image.RED_PONT,x=10,y=10})
		gui_btn:getInstance():setPressedActionEnabled(false) -- 默认点击会缩放
		self.ListGUIButton[#self.ListGUIButton+1]=gui_btn
	end	



	self.PageButton=gui.PageButton.new()--创建分页按钮管理器
	self.PageButton:setBtnCallBack(handler(self,self.onPageButtonCallBack))
	for i=1,#self.ListGUIButton do
		self.PageButton:addButton(self.ListGUIButton[i]:getInstance())
	end

	self.clonePanle = self.view:getChildByName("Panel_Clone")

	self.ListView = self.view:getChildByName("ListView")

	self.down = self.view:getChildByName("Image_13")
	self.panel_1 = self.view:getChildByName("Panel_1")
	self.view:reorderChild(self.down,500)
	self.view:reorderChild(self.panel_1,500)
	--self.ListView:setTouchEnabled(false)

	self.packindex = 1 
	self:setData()
	
	

	--self:initlistView()
	self:pagebtninit(self.packindex)

	self:initDec()
end

function AchievementView:initDec( ... )
	-- body
	self.view:getChildByTableTag(1,1):setTitleText(res.str.ACHI_DEC5)
	self.view:getChildByTableTag(1,2):setTitleText(res.str.ACHI_DEC6)

end

function AchievementView:pageClick( index )
	-- body
	self.packindex = 2
	self:pagebtninit(self.packindex)
end


function AchievementView:numberOfCellsInTableView(table)
	-- body
	local size = #self.ListViewItemData[self.packindex]
    return size
end

function AchievementView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
end

function AchievementView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function AchievementView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function AchievementView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePanle:getContentSize()    
    return ccsize.height-8,ccsize.width
end

function AchievementView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.ListViewItemData[self.packindex][idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
        cell.index = idx
        widget=CreateClass("views.achievenment.achieveItem")      
		widget:init(self)
		widget:setData(data)
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
    else
    	widget = cell:getChildByName("widget")
       	widget:setData(data)
    end

    return cell
end

function AchievementView:inittableView()
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
	end 
	self.tableView:reloadData()
end


--设置
function AchievementView:setRedPoint()
	-- body
	debugprint("成就完成个数设置"..self.count)
	local num= self.count and self.count or 0
	self.ListGUIButton[2]:setNumber(num)
	--[[if num > 0 then 
		self.ListGUIButton[2]:setNumber(num)
	end]]--
end

function AchievementView:initDta( )
	-- body
	self.ListViewItemData={}
	self.ListViewItemData[1] = {};--未完成 或者 未领取
	self.ListViewItemData[2]={}--已经完成的成就
	self.count = 0
end

function AchievementView:setData()
	-- body
	self:initDta()
	local typerecord = {} --同类型的任务就获取完成度最高的，相同ID小的
	local data = cache.Taskinfo:getAchievement() 
	if data then
		for k,v in pairs(data) do
			--print(v.is_get)
			if v.is_get >= 1 then
				if v.is_get == 1 then 
					self.count = self.count +1
				end
				table.insert(self.ListViewItemData[2] ,v)
			else
				table.insert(self.ListViewItemData[1],v)
			end 

			--[[if v.is_get == 2 then  --已经领取
				table.insert(self.ListViewItemData[2] ,v)
			else
				if v.is_get ==1 then 
					self.count = self.count +1
				end
				local type = conf.achieve:getType(v.taskId)
				if not typerecord[type] then 
					typerecord[type] = {}
				end 
				table.insert(typerecord[type],v)
			end]]--
		end
	end
	for k ,v in pairs(typerecord) do 
		table.sort(v,function( a,b )
			-- body
			if a.is_get ~= b.is_get then --
				return a.is_get>b.is_get
			else
				--todo
				local maxa = conf.achieve:gettotal_count(a.taskId)  --目标完成个数
				local maxb = conf.achieve:gettotal_count(b.taskId)  --目标完成个数
				local preA = a.pass/maxa 
				local  preB = b.pass/maxb
				if preA == preB then --完成个数
					return a.taskId<b.taskId
				else
					return preA>preB
				end
			end
		end)

		table.insert(self.ListViewItemData[1],v[1]) --只取一条记录
	end 
	--当前完成度高到低的排序规则。
	table.sort( self.ListViewItemData[1], function( a,b )
		-- body
		if a.is_get ~= b.is_get then --
			return a.is_get>b.is_get
		else
			--todo
			local maxa = conf.achieve:gettotal_count(a.taskId)  --目标完成个数
			local maxb = conf.achieve:gettotal_count(b.taskId)  --目标完成个数
			local preA = a.pass/maxa 
			local  preB = b.pass/maxb
			if preA == preB then --完成个数
				return a.taskId<b.taskId
			else
				return preA>preB
			end
		end
	end )
    --已完。
	table.sort( self.ListViewItemData[2], function(a,b )
		-- body
		if a.is_get ~= b.is_get then --
			return a.is_get<b.is_get
		else
			--todo
			return a.taskId<b.taskId
			--[[local maxa = conf.achieve:gettotal_count(a.taskId)  --目标完成个数
			local maxb = conf.achieve:gettotal_count(b.taskId)  --目标完成个数
			local preA = a.pass/maxa 
			local  preB = b.pass/maxb
			if preA == preB then --完成个数
				return a.taskId<b.taskId
			else
				return preA>preB
			end]]--
		end
	end )
	print("self.count = "..self.count)
	self:setRedPoint()
end

function AchievementView:getColnePnaleItem()
	-- body
	return self.clonePanle:clone()
end

function AchievementView:initAllPanle( index )
	-- body
	if index then 
		self.packindex =  index
	end 
	self:inittableView()
end

function AchievementView:pagebtninit( index )
	-- body
	self.PageButton:initClick(index)
end

----------------------按钮回调-------------
--页面切换
function AchievementView:onPageButtonCallBack( index,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		--debugprint("index "..index)
		self:initAllPanle(index)
		return self
	end
end

--
function AchievementView:onCloseSelfView()
	G_mainView()
end
--达成某一成就 飘个字看看
function AchievementView:tips(id)
	-- body
	if not conf.achieve:getdec(id) then 
		debugprint("没有这个成就ID = "..id)
		return
	end 

	local _img = self.view:getChildByName("tips")
    if _img ~= nil then 
        _img:removeFromParent();
    end 

    local spr = display.newSprite(res.other.TISHI)

    local _img = display.newScale9Sprite(res.other.TISHI,display.cx,display.cy/2
        ,cc.size(500, 60),spr:getContentSize())
    _img:setName("tips")
    self:addChild(_img)

    
    local label = display.newTTFLabel({
	    text = res.str.ACHI_DEC1,
	    size = 24,
	    color = COLOR[1], 
	    align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
	    x = 0,
	    y = _img:getContentSize().height/2,
    })
    label:setAnchorPoint(cc.p(0,0.5))
    label:addTo(_img)



    local label2 = display.newTTFLabel({
	    text = "\""..conf.achieve:getdec(id).."\"",
	    size = 24,
	    color = COLOR[6], 
	    align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
	    x = label:getContentSize().width+label:getPositionX(),
	    y = _img:getContentSize().height/2,
    })
    label2:setAnchorPoint(cc.p(0,0.5))
    label2:addTo(_img)

    local label3 = display.newTTFLabel({
	    text = res.str.ACHI_DEC2,
	    size = 24,
	    color = COLOR[1], 
	    align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
	    x = label2:getContentSize().width+label2:getPositionX(),
	    y = _img:getContentSize().height/2,
    })
    label3:setAnchorPoint(cc.p(0,0.5))
    label3:addTo(_img)

    local zs = display.newSprite(res.image.ZS)
    zs:setScale(0.8)
    zs:setAnchorPoint(cc.p(0,0.5))
    zs:setPositionX(label3:getContentSize().width+label3:getPositionX())
    zs:setPositionY(_img:getContentSize().height/2)
    zs:addTo(_img)

    local reward = conf.achieve:getReward(id)
    local label4 = display.newTTFLabel({
	    text = reward[2],
	    size = 24,
	    color = COLOR[5], 
	    align = cc.TEXT_ALIGNMENT_CENTER ,-- 文字内部居中对齐
	    x = zs:getContentSize().width*0.8+zs:getPositionX(),
	    y = _img:getContentSize().height/2,
    })
    label4:setAnchorPoint(cc.p(0,0.5))
    label4:addTo(_img)

   


    --调整位置去中间
    local w = 0 
    w =  label:getContentSize().width+label2:getContentSize().width
    +label3:getContentSize().width+label4:getContentSize().width
    +zs:getContentSize().width*0.8

    local offx = (_img:getContentSize().width-w)/2
    label:setPositionX(label:getPositionX()+offx)
    label2:setPositionX(label2:getPositionX()+offx)
    label3:setPositionX(label3:getPositionX()+offx)
    label4:setPositionX(label4:getPositionX()+offx)
    zs:setPositionX(zs:getPositionX()+offx)



    local sequence = transition.sequence({
    cc.Spawn:create(cc.FadeIn:create(0.5) ,cc.MoveTo:create(1.5,cc.p(display.cx,display.cy))),
    cc.DelayTime:create(1.5),
    cc.CallFunc:create(function()
    	-- body
    	_img:removeFromParent()
    end)
    })

     _img:runAction(sequence)

    --label:enableOutline(cc.c4b(255,0,0,100),2)

end

return AchievementView		