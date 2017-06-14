--
-- Author: chenlu_y
-- Date: 2015-12-08 16:57:20
-- 累计消费
--
local ConsumeGiftView=class("ConsumeGiftView",base.BaseView)

function ConsumeGiftView:init()
	
	proxy.ConsumeGift:sendMessage()

	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.config = conf.active:getXfhl()
	self.configLen = table.nums(self.config)

	self:initPanel1()
	self:initOther()
end

function ConsumeGiftView:initPanel1()
	local panel1 = self.view:getChildByName("Panel_1")
	self.timeTxt = panel1:getChildByName("Text_7_11") --计时时间
	self.consumeTxt = panel1:getChildByName("Text_2") --已消费

	local decTxt = display.newTTFLabel({
		    text = res.str.ACTIVE_TEXT60,
		    font = res.ttf[1],
		    size = 20,
		    color = COLOR[2],
		    align = cc.TEXT_ALIGNMENT_LEFT,
		    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
		    dimensions = cc.size(550, 0), 
		})
	decTxt:setAnchorPoint(cc.p(0,1))
	decTxt:setPosition(27, 100)
	panel1:addChild(decTxt)

	panel1:getChildByName("Text_6_8"):setString(res.str.ACTIVE_TEXT56)
	panel1:getChildByName("Text_1"):setString(res.str.ACTIVE_TEXT57)
end

function ConsumeGiftView:initOther()
	self.cloneItem = self.view:getChildByName("item")
	self.clonePanel = self.view:getChildByName("Item_Panel")

	local listView = self.view:getChildByName("ListView_item")
	local posx ,posy = listView:getPosition()
	local ccsize =  listView:getContentSize() 

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

function ConsumeGiftView:numberOfCellsInTableView(iTable)
    return self.configLen
end

function ConsumeGiftView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePanel:getContentSize()
    return ccsize.height,ccsize.width
end

function ConsumeGiftView:tableCellAtIndex(table, idx)

    local cell = table:dequeueCell()
    if cell then
    	local item = cell:getChildByName("item")
       	item:removeFromParent()
    else
  		cell = cc.TableViewCell:new()
    end

    local item = self:createitem(idx)
    item:setTouchEnabled(false)
    item:setAnchorPoint(0,0)
    item:setPosition(5,0)
    item:setName("item")
    cell:addChild(item)
    
    return cell
end

function ConsumeGiftView:createitem( idx )

	local cellConf = self.config[idx+1]
	local czzs = cellConf.quota --需要充值的钻石
	local gifts = cellConf.gifts  --道具列表
	local panel = self.clonePanel:clone()
	local itemW
	for i,v in ipairs(gifts) do
		local item = self.cloneItem:clone()
		itemW = itemW or item:getContentSize().width
		item:setSwallowTouches(false)
		panel:addChild(item)

		item:setPosition(20+itemW*(i-1) - (i-1)*10, 5)

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

	panel:getChildByName("Text_32"):setString("1")
	panel:getChildByName("Text_33"):setString("/1")
	panel:getChildByName("Text_31"):setString(res.str.ACTIVE_TEXT58)
	panel:getChildByName("Text_limited"):setString(string.format(res.str.ACTIVE_TEXT59, czzs)) 

	local btnGet =  panel:getChildByName("cha")
	btnGet.typeTag = cellConf.id-1
	btnGet:addTouchEventListener(handler(self,self.btnGetClickUpCallback))

	if self.awardSign then
		local signs = self.awardSign[czzs..""]
		if signs then
			if signs == 0 then
				btnGet:setEnabled(false)
				btnGet:setBright(false)
				btnGet:setTitleText(res.str.HSUI_DESC1)
			elseif signs == 1 then
				btnGet:setEnabled(true)
				btnGet:setBright(true)
				btnGet:setTitleText(res.str.HSUI_DESC1)
			elseif signs == 2 then	
				btnGet:setEnabled(false)
				btnGet:setBright(false)
				btnGet:setTitleText(res.str.HSUI_DESC2)
				panel:getChildByName("Text_32"):setString("0")
			end
		end
	end

	return panel
end

function ConsumeGiftView:setData(data)
	self.dayCostZs = data.dayCostZs
	self.awardSign = data.awardSigns
	self.timeValue = data.leftTime

	if self.timeValue > 0 then
		self.timeTxt:setString(G_getTimeStr(self.timeValue))
		self.timeSchedual = self:schedule(self.timeTick, 1)
	end

	self.consumeTxt:setString(data.dayCostZs.."")

	--排序
	local newList1 = {}
	local newList2 = {}
	for i,v in ipairs(self.config) do
		local xfzs = self.awardSign[v.quota .. ""]
		if xfzs ~= 2 then
			table.insert(newList1, v)
		else
			table.insert(newList2, v)
		end
	end	
	for ii,vv in ipairs(newList2) do
		table.insert(newList1, vv)
	end
	self.config = newList1


	self.tableView:reloadData()
	self.tableView:setVisible(true)
	
end

--设置获取状态
function ConsumeGiftView:setGetState(data)
	self.awardSign = data.awardSigns

	local index = data.gotType+1
	for i,v in ipairs(self.config) do
		if v.id == index then
			index = i
			break
		end
	end	
	
	local tmp = self.config[index]
	table.remove(self.config,index)
	table.insert(self.config,tmp)
	self.tableView:reloadData()
end

function ConsumeGiftView:btnGetClickUpCallback( sender,eventType  )
	if eventType == ccui.TouchEventType.ended then
		proxy.ConsumeGift:sendBuyMessage(sender.typeTag)
	end
end

function ConsumeGiftView:openItem( send,eventType  )
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

function ConsumeGiftView:timeTick( )
	self.timeValue = self.timeValue - 1
	self.timeTxt:setString(G_getTimeStr(self.timeValue))
	if self.timeValue <= 0 then
		self:stopAction(self.timeSchedual)
		proxy.ConsumeGift:sendMessage()
	end

	--如果是从活动进入
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		view:updateData(G_getTimeStr(self.timeValue))
	end


end

function ConsumeGiftView:hideTitle()
	local panel1 = self.view:getChildByName("Panel_1")
	panel1:getChildByName("Image_27_22"):setVisible(false)
	panel1:getChildByName("Text_7_11"):setVisible(false)
	panel1:getChildByName("Text_6_8"):setVisible(false)

	panel1:getChildByName("Text_1"):setPositionX(260)
	panel1:getChildByName("Text_2"):setPositionX(348)
	panel1:getChildByName("Image_3"):setPositionX(330)
end

return ConsumeGiftView