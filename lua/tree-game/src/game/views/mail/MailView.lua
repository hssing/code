--[[
	邮件 
]]--


local MailView=class("MailView",base.BaseView)

function MailView:init()
	-- body
	--proxy.Mail:sendMessage(0,true)--第一次默认请求全部

	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.ListGUIButton={}  --GUI按钮容器
	for i = 2 , 4 do 
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

	self.ListView=self.view:getChildByName("ListView_1")
	self.ListView:setTouchEnabled(false)
	self.clonepanle = self.view:getChildByName("panle")
	self.down = self.view:getChildByName("img_down")
	local panle = self.view:getChildByName("Panel_1")
	local button_close = self.view:getChildByName("Button_close")
	self.view:reorderChild(self.down,500)
	self.view:reorderChild(panle,500)
	self.view:reorderChild(button_close,500)

	local btn = self.view:getChildByName("Button_1")
	--btn:setTitleText(res.str.DUI_DEC_09)
	btn:setVisible(false)
	btn:addTouchEventListener(handler(self, self.onBtnCallBack))
	self.btn =btn 
	self.view:reorderChild(btn,500)

	self:initDec()
	if res.banshu then 
		for i = 3 , 4 do  
			local tbt = self.view:getChildByTableTag(1,i)
			tbt:setVisible(false)
		end 
	end 

	self:setData(cache.Mail:getAllDataInfo())
	self.packindex = 1
	self.PageButton:initClick(self.packindex)

	---------选择哪个面板
	self.selectedIdx = 1

	
end

function MailView:initDec( ... )
	-- body
	self.view:getChildByName("Panel_1"):getChildByName("Button_1_2"):setTitleText(res.str.MAIL_DEC_01)
	self.view:getChildByName("Panel_1"):getChildByName("Button_1_3"):setTitleText(res.str.MAIL_DEC_02)
	self.view:getChildByName("Panel_1"):getChildByName("Button_1_4"):setTitleText(res.str.MAIL_DEC_03)

	self.view:getChildByName("panle"):getChildByName("Panel_2"):getChildByName("txt_reward"):setString(res.str.MAIL_DEC_04)


end

function MailView:numberOfCellsInTableView(table)
	-- body
	local size=#self.ListViewItemData[self.packindex]
	--print("size = "..size)
    return size
end

function MailView:scrollViewDidScroll(view)
   -- print("scrollViewDidScroll")
   --print("---  "..view:getContainer():getPositionY())
   --print(" getContentOffset "  .. view:getContentOffset().x..","..view:getContentOffset().y)

end

function MailView:scrollViewDidZoom(view)
   -- print("scrollViewDidZoom")
end

function MailView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
    --print("cell pos "..cell:getPositionY())
    -- print(" getContentOffset "  .. self.tableView:getContentOffset().x..","..self.tableView:getContentOffset().y)
end

function MailView:cellSizeForTable(table,idx) 
	local ccsize = self.clonepanle:getContentSize()    
    return ccsize.height,ccsize.width
end

function MailView:tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local widget
    local data= self.ListViewItemData[self.packindex][idx+1]
    print("strValue = "..strValue)
    --printt(data)
    if nil == cell then
        cell = cc.TableViewCell:new()
        widget=CreateClass("views.mail.MailItemview")     
		widget:init(self,self.selectedIdx)
		widget:setData(data)
        widget:setAnchorPoint(cc.p(0,0))
        widget:setPosition(cc.p(0, 0))
        widget:setName("widget")
        widget:addTo(cell)
    else
    	widget = cell:getChildByName("widget")
       	widget:setData(data)
    end
    --print(" getContentOffset "  .. self.tableView:getContentOffset().x..","..self.tableView:getContentOffset().y)
    if idx + 2>#self.ListViewItemData[self.packindex] then 
    	self.idx = idx
    	proxy.Mail:sendMessage(self.packindex)
    	--print("尝试请求 下一页的 = "..self.idx)
    end 

    return cell
end

function MailView:inittableView()
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
	   -- self:loadInRunAction()
	else
		self.tableView:reloadData()
		--self:loadInRunAction()
	end 
	--debugprint(self.tableView:getContentSize().height)
	--debugprint(self.tableView:getContainer():getPositionY() )
	--debugprint("... self.tableView:getContentOffset() "..self.tableView:getContentOffset().y)
	if self.idx then 
		local num = math.ceil(self.ListView:getContentSize().height/self.clonepanle:getContentSize().height)
		if  self.idx < num then 
			return 
		end 
		
		local offset = {
			x = 0 ,
			y = (self.idx+1) * self.clonepanle:getContentSize().height  - self.tableView:getContentSize().height	  
		}
		--printt(offset)
		self.tableView:setContentOffset(offset)
	end 
end

--

--设置 各个邮件的个数
function MailView:setRedPoint( tablenum )
	local sys =  cache.Mail:getCoutbytype(1)
	local zhandou = cache.Mail:getCoutbytype(2)
	local friend = cache.Mail:getCoutbytype(3)

	for i = 2 , 4 do 
		if i == 1 then 
			self.ListGUIButton[i]:setNumber(sys+zhandou+friend)
		elseif i == 2 then 
			self.ListGUIButton[i-1]:setNumber(sys)
		elseif i == 3 then 
			self.ListGUIButton[i-1]:setNumber(zhandou)
		elseif i == 4 then 
			self.ListGUIButton[i-1]:setNumber(friend)
		end
	end	
end
--页面切换
function MailView:onPageButtonCallBack( index,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		proxy.Mail:sendMessage(index,true)
		self.selectedIdx = index
		self:initAllPanle(index)
		if index == 1 then
			self.btn:setTitleText(res.str.DEC_NEW_15)
		elseif index == 2 then
			self.btn:setTitleText(res.str.DEC_NEW_17)
		else
			self.btn:setTitleText(res.str.DEC_NEW_16)
		end
		return self
	end
end
--
function MailView:initDta()
	-- body
	self.ListViewItemData={}
	self.ListViewItemData[1]={}--系统
	self.ListViewItemData[2]={}--战斗
	self.ListViewItemData[3]={}--社交
	--[[self.ListViewItemData[1] = {};--all
	self.ListViewItemData[2]={}--系统
	self.ListViewItemData[3]={}--战斗
	self.ListViewItemData[4]={}--社交]]--
end

function MailView:setData( data_ )
	-- body
	self:initDta()

	if data_ then
		for k ,v in pairs(data_) do 
			self.ListViewItemData[tonumber(k)]=v
		end	
	end

	--printt(self.ListViewItemData[3])
end

function MailView:getColnePnaleItem()
	return self.clonepanle:clone()
end	





function MailView:Toclick()
	-- body
	self:initAllPanle(self.packindex)
end

function MailView:_Sort(index )
	-- body
	--[[table.sort( self.ListViewItemData[index], function( a,b )
		-- body
		local areward = #a.items == 0 and 0 or 1
		local breward = #b.items == 0 and 0 or 1

		local amtype = a.mtype > 300 and  1 or a.mtype
		local bmtype = b.mtype > 300 and  1 or b.mtype

		local amState = a.mState == 1 and 100 or a.mState
		local bmState = b.mState == 1 and 100 or b.mState

		if amState == bmState then 
			if a.lastTime  == b.lastTime then 
				return a.mailId.key<b.mailId.key
			else
				return a.lastTime<b.lastTime
			end 
		else
		 	return amState < bmState
		end  
	end )]]--
end

function MailView:initAllPanle( index )
	-- body
	debugprint("index ="..index)
	self.idx = nil 
	self:setRedPoint()
	self.btn:setVisible(true)
	--[[if #self.ListViewItemData[index] > 0 then
		self.btn:setVisible(true)
	else
		self.btn:setVisible(false)
	end]]--

	self.packindex = index


	--table.sort( tablename, sortfunction ) 界面切换排序
	self:_Sort(self.packindex)
	self:inittableView()
	--self.lv:reload()
end
--请求的信息直接放后面
function MailView:updateData(data_)
	-- body
	self:_Sort(self.packindex)
	
	self:inittableView()
end

function MailView:updateinfo(mailId)
	-- body
	self:setRedPoint()
	if mailId then
		for k , v in pairs(self.ListViewItemData[self.packindex]) do 
			--[idx+1]
			if v.mailId.key == mailId.key then 
				--local widget = self.tableView:
				local cell = self.tableView:cellAtIndex(k -1 )
				if cell then 
					local data= v
					cell:getChildByName("widget"):setData(v)
				end 

				return 
			end
		end 
	end
end

--*-----------------
function MailView:onBtnCallBack(send_,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		--local param = {mailId = -1 }
		local mState
		if self.selectedIdx == 1 then
			mState = 997
		elseif self.selectedIdx== 2 then
			mState = 998
		else
			mState = 999
		end
		proxy.Mail:sendGet(-1,mState)
	end
end

function MailView:onCloseSelfView()
	G_mainView()
end	

return MailView