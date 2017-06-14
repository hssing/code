--
-- Author: chenlu_y
-- Date: 2015-12-08 16:57:20
-- 天天豪礼
--
local EveryDayGiftView=class("EveryDayGiftView",base.BaseView)

function EveryDayGiftView:init()
	
	proxy.EveryDayGift:sendMessage()

	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.data = {}
	self.config = conf.active.tthlConf
	self.configLen = table.nums(self.config)

	self:initPanel1()
	self:initOther()
end

function EveryDayGiftView:initPanel1()
	local panel1 = self.view:getChildByName("Panel_1")
	self.timeTxt = panel1:getChildByName("Text_7_11") --计时时间

	local decTxt = display.newTTFLabel({
		    text = res.str.ACTIVE_TEXT54,
		    font = res.ttf[1],
		    size = 20,
		    color = COLOR[2],
		    align = cc.TEXT_ALIGNMENT_LEFT,
		    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
		    dimensions = cc.size(510, 0), 
		})
	decTxt:setAnchorPoint(cc.p(0,1))
	decTxt:setPosition(67, 100)
	panel1:addChild(decTxt)

	panel1:getChildByName("Text_6_8"):setString(res.str.ACTIVE_TEXT53)
end

function EveryDayGiftView:initOther()
	self.clonePanel = self.view:getChildByName("Item_Panel")
	self.cloneItem = self.view:getChildByName("item")

	local listView = self.view:getChildByName("ListView_item")
	local posx ,posy = listView:getPosition()
	local ccsize =  listView:getContentSize() 

	local listBg = self.view:getChildByName("Image_22")
	listBg:setContentSize(display.width, ccsize.height+30) 

	self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.tableView:setPosition(cc.p(posx, posy))
	self.tableView:setDelegate()
	self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self.view:addChild(self.tableView,100)
	self.tableView:setVisible(false)
	
	self.tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView) ,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --tableView个数
	--self.tableView:registerScriptHandler(handler(self, self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)           --滚动  
	--self.tableView:registerScriptHandler(handler(self, self.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)				--放大
	--self.tableView:registerScriptHandler(handler(self, self.tableCellTouched),cc.TABLECELL_TOUCHED)						--点击	
	self.tableView:registerScriptHandler(handler(self, self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)				--xiao	
	self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)               --添加

	self.tableView:reloadData()
end

function EveryDayGiftView:numberOfCellsInTableView(iTable)
    return self.configLen
end

function EveryDayGiftView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePanel:getContentSize()
    return ccsize.height,ccsize.width
end

function EveryDayGiftView:tableCellAtIndex(table, idx)

    local cell = table:dequeueCell()
    if cell then
    	local item = cell:getChildByName("item")
       	item:removeFromParent()
    else
  		cell = cc.TableViewCell:new()
    end

    local item = self:createitem(idx + 1)
    item:setTouchEnabled(false)
    item:setAnchorPoint(0,0)
    item:setPosition(5,0)
    item:setName("item")
    cell:addChild(item)
    
    return cell
end

function EveryDayGiftView:createitem( idx )
	local cellConf = self.config[idx..""]
	local currDay = cellConf.id
	local gifts = cellConf["gifts"]
	local panel = self.clonePanel:clone()
	local itemW
	for i,v in ipairs(gifts) do
		local item = self.cloneItem:clone()
		itemW = itemW or item:getContentSize().width
		item:setSwallowTouches(false)
		panel:addChild(item)

		item:setPosition(5+itemW*(i-1) - (i-1)*20, 5)

		local iconFrame = item:getChildByName("btn_goods")
		local iconImg = item:getChildByName("img_goods")
		local textLb = item:getChildByName("text_goods")

		local mid = v[1]
		local num = v[2]
		local iconFrameSrc = conf.bigGift:getFrameIcon(mid)
		local iconImgSrc = conf.bigGift:getIcon(mid)
		local textLbName = conf.bigGift:getName(mid)
		local textColor = conf.bigGift:getTextColor(mid)

		iconFrame:loadTextureNormal(iconFrameSrc)
		iconImg:loadTexture(iconImgSrc)
		textLb:setString(textLbName .. "x" .. num)
		textLb:setColor(textColor)

		iconFrame.mid = mid
		iconFrame:addTouchEventListener(handler(self,self.openItem))
	end

	if currDay == 3 or currDay == 7 then
		panel:getChildByName("Image_59"):setVisible(true)
	else
		panel:getChildByName("Image_59"):setVisible(false)
	end
	panel:getChildByName("Text_limited"):setString(res.str.ACTIVE_TEXT55[currDay])

	local yilingquImg = panel:getChildByName("Image_60")
	local btnGet =  panel:getChildByName("Button_get")
	btnGet:setTitleText(res.str.HSUI_DESC1)
	btnGet:addTouchEventListener(handler(self,self.btnGetClickUpCallback))

	if self.ddays then
		print(currDay," ** ",self.ddays," ---",self.sign)
		if currDay < self.ddays then
			btnGet:setVisible(false)
			yilingquImg:setVisible(true)
		elseif currDay == self.ddays then
			btnGet:setVisible(true)
			yilingquImg:setVisible(false)	
			if self.sign == 0 then
				btnGet:setEnabled(false)
				btnGet:setBright(false)
			elseif self.sign == 1	then
				btnGet:setEnabled(true)
				btnGet:setBright(true)
			elseif self.sign == 2 then
				btnGet:setVisible(false)
				yilingquImg:setVisible(true)	
			end
		else
			btnGet:setVisible(true)
			btnGet:setEnabled(false)
			btnGet:setBright(false)
			yilingquImg:setVisible(false)	
		end		
	end

	return panel
end

function EveryDayGiftView:setData(data)
	self.sign = data.sign
	self.ddays = data.days+1
	self.timeValue = data.leftTime+5
	if self.timeValue > 0 then
		self.timeTxt:setString(G_getTimeStr(self.timeValue))
		self.timeSchedual = self:schedule(self.timeTick, 1)
	end

	-- if data.days > 0 and data.sign == 2 then
	-- 	self.ddays = self.ddays-1
	-- end
	-- local currTime = os.date("*t", data.curTime)
	-- local lastCzTime = os.date("*t", data.lastCzTime)
	-- -- print("当前服务器时间：")
	-- -- printt(currTime)
	-- -- print("####################################")
	-- -- print("上一次充值时间：")
	-- -- printt(lastCzTime)
	-- -- print("###############################")
	-- if currTime.year == lastCzTime.year and currTime.month == lastCzTime.month and currTime.day == lastCzTime.day then
	-- 	--今天有充值
	-- 	if data.lastAwardTime > 0 then
	-- 		local lastAwardTime = os.date("*t", data.lastAwardTime)
	-- 		-- print("上一次领取时间：")
	-- 		-- printt(lastAwardTime)
	-- 		-- print("###############################")
	-- 		if currTime.year == lastAwardTime.year and currTime.month == lastAwardTime.month and currTime.day == lastAwardTime.day then
	-- 			--已领取
	-- 			self.data.getTag = 2
	-- 			self.data.days = self.data.days-1
	-- 		else
	-- 			--可领取	
	-- 			self.data.getTag = 1	
	-- 		end	
	-- 	else
	-- 		--可领取	
	-- 		self.data.getTag = 1
	-- 	end
	-- else
	-- 	--今天没充值
	-- 	self.data.getTag = 0
	-- end

	self.tableView:reloadData()
	self.tableView:setVisible(true)
	
	if self.ddays >= 4 then
		self:setTableViewContentOffset()
	end
	
end

--设置tableView的Y轴偏移,显示指定行
function EveryDayGiftView:setTableViewContentOffset()
	local locationindex = 4 --需要将cellIndex放到可视区域的第几个，从1开始 
	local cellCountShown = 4   --可视区域可显示的cell的数量
	local cellIndex = self.ddays-1 --需要指定的cell的索引，从0开始计数
	local cellHeight = self.clonePanel:getContentSize().height --单个cell的高度 
	local viewHeight = self.view:getChildByName("ListView_item"):getContentSize().height --可视区域的高度 

	local offsety
	local tableTotalHeight = cellHeight * self.configLen
	if tableTotalHeight > viewHeight then
		offsety = -(self.configLen - (cellIndex + cellCountShown - locationindex + 1)) * cellHeight
	else
		offsety = viewHeight - tableTotalHeight	
	end

	self.tableView:setContentOffset( cc.p(0, offsety), false) 

end

--设置获取状态
function EveryDayGiftView:setGetState(data)
	self.sign = 2
	self.tableView:reloadData()
end

function EveryDayGiftView:btnGetClickUpCallback( sender,eventType  )
	if eventType == ccui.TouchEventType.ended then
		proxy.EveryDayGift:sendBuyMessage()
	end
end

function EveryDayGiftView:openItem( send,eventType  )
	if eventType == ccui.TouchEventType.ended then
		local data = {}
		data.mId = send.mid
		local itype=conf.Item:getType(data.mId)
		if itype ==  pack_type.PRO then
			G_openItem(data.mId)
		elseif itype  == pack_type.EQUIPMENT then 
			G_OpenEquip(data,true)
		else	
			G_OpenCard(data,true)
		end
	end
end

function EveryDayGiftView:timeTick( )
	self.timeValue = self.timeValue - 1
	self.timeTxt:setString(G_getTimeStr(self.timeValue))
	if self.timeValue <= 0 then
		self:stopAction(self.timeSchedual)
		proxy.EveryDayGift:sendMessage()
	end
end


return EveryDayGiftView