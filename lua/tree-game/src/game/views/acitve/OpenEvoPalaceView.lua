--
-- Author: Your Name
-- Date: 2015-11-20 18:09:41
--
--
-- Author: Your Name
-- Date: 2015-08-26 21:23:35
--
local  OpenEvoPalaceView = class("OpenEvoPalaceView", base.BaseView)


function OpenEvoPalaceView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()


	self.headerPanel = self.view:getChildByName("Panel_1")
	self.panleImg = self.headerPanel:getChildByName("Image_14") 
	self.timeLab = self.panleImg:getChildByName("Text_17_8") 
	self.zsLab = self.panleImg:getChildByName("Text_18_10") 

	self.clonePanel = self.view:getChildByName("Item_Panel")
	self.listView = self.view:getChildByName("ListView_item")
	self.cloneItem = self.view:getChildByName("item")

	-- self.clonePanel:getChildByName("Button_get"):setEnabled(true)
	-- self.clonePanel:getChildByName("Button_get"):setBright(false)

	self.view:getChildByName("Panel_footer"):setLocalZOrder(1000)
	self.view:getChildByName("Panel_footer"):setSwallowTouches(false)

	self.data = {}
	self:inittableView()


	---固定文本抽出
	self.panleImg:getChildByName("Text_16_6"):setString(res.str.RICH_RANK_DESC2)
	self.panleImg:getChildByName("Text_15_4"):setString(res.str.OPEN_ACT_PALACE_DESC1)

	local  Text_5 = self.clonePanel:getChildByName("Text_31")
	Text_5:setString(res.str.RICH_RANK_DESC42)

	local Text_31 = self.clonePanel:getChildByName("Text_1")
	Text_31:setString(res.str.RICH_RANK_DESC20)
	
	proxy.OpenAct:reqJHSDInfo()
	--self:setGiftInfo()

end



---创建每个充值奖励
function OpenEvoPalaceView:createitem(idx)
	-- body
	local gifts = self.data[idx]["gifts"]
	local itemPanel = self.clonePanel:clone()
	local listView = itemPanel:getChildByName("ListView_sub_item")
	listView:setSwallowTouches(false)
	listView:setContentSize(1000,120)
	itemPanel:setSwallowTouches(false)
	for i=1,#gifts do
		local item = self.cloneItem:clone()
		item:setSwallowTouches(false)
		listView:pushBackCustomItem(item)

		local iconFrame = item:getChildByName("btn_goods")
		local iconImg = item:getChildByName("img_goods")
		local textLb = item:getChildByName("text_goods")

		local mid = gifts[i][1]
		local num = gifts[i][2]
		local iconFrameSrc = conf.ChargeCount:getFrameIcon(mid)
		local iconImgSrc = conf.ChargeCount:getIcon(mid)
		local textLbName = conf.ChargeCount:getName(mid)
		local textColor = conf.ChargeCount:getTextColor(mid)

		iconFrame:loadTextureNormal(iconFrameSrc)
		iconImg:loadTexture(iconImgSrc)
		textLb:setString(textLbName .. "x" .. num)
		textLb:setColor(textColor)


		---根据物品名字长度来设置item大小
		--item:setContentSize(textLb:getContentSize().width,item:getContentSize().height)

		iconFrame.mid = mid
		iconFrame:addTouchEventListener(handler(self,self.openItem))

	end

	--购买按钮
	local btnGet = itemPanel:getChildByName("Button_get")
	local label = btnGet:getChildByName("Text_title")
	btnGet:addTouchEventListener(handler(self,self.onBtnGetClicked))
	btnGet.count = self.data[idx]["count"]
	btnGet.price = self.data[idx]["price"]
	btnGet.buyId = self.data[idx]["id"]



	--；礼包名称
	local giftName = itemPanel:getChildByName("Text_limited")
	giftName:setString( self.data[idx]["name"])
	--ruleLab:setString("累计充值" .. (self.data[idx]["quota"] / 10) .. "元")

	--剩余领取次数
	local leftTimeLab = itemPanel:getChildByName("Text_32")
	local totalNum = self.data[idx]["count"]

	if totalNum >= 99999 then
		leftTimeLab:setString(res.str.RICH_RANK_DESC29)
	else
		leftTimeLab:setString(totalNum)
	end

	btnGet.countLab = leftTimeLab
	

	--价格
	local priceLab  = itemPanel:getChildByName("Text_2")
	priceLab:setString(self.data[idx]["price"])


	return itemPanel
end


--购买
function OpenEvoPalaceView:onBtnGetClicked( send,eventType )
	if eventType == ccui.TouchEventType.ended then
		--G_TipsForNoEnough(2)
		if send.count <= 0 then
			G_TipsOfstr(res.str.RICH_RANK_DESC33)
			return
		elseif cache.Fortune:getZs() < send.price  then
			G_TipsForNoEnough(2)
			return
		end
		self.countLab = send.countLab
		self.count = send.count
		self.send = send
		self.buyId = send.buyId
		proxy.OpenAct:reqJHSDBuy(send.buyId,1)
	end
end

--购买成功
function OpenEvoPalaceView:buySucc( data )
	--self.moodHitCount:setString(string.format(res.str.RICH_RANK_DESC18, data.zdCount))

	local view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
	if view then
		view:setData(data.items,true,true,false)
		view:setButtonVisible(false)
		view:setSureBtnTile(res.str.HSUI_DESC12)
	end
	self.send.count = self.send.count - 1
	self.countLab:setString(self.count - 1)
	for k,v in pairs(self.data) do
		if v.id == self.buyId then
			v.count = v.count - 1
			break
		end
	end

end




-----打开物品
function OpenEvoPalaceView:openItem( send,eventType  )
	-- body
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


-----活动倒计时
function OpenEvoPalaceView:timeTick( )
	self.leftTime = self.leftTime - 1
	self.todayTime = self.todayTime - 1
	local timeStr = self:getTimeStr(self.leftTime)
	if self.leftTime == 0 then
		self:stopAllActions(self.timeSchedual)
		timeStr = res.str.RICH_RANK_DESC37
	end
	if self.todayTime <= 0 then
		self:stopAllActions()
		proxy.OpenAct:reqJHSDInfo()
	end

	self.timeLab:setString(timeStr)
	

end


function OpenEvoPalaceView:getTimeStr( leftTime )
	--self.leftTime = self.leftTime - 1
	local left = 0
	local day = math.floor(leftTime / (60 * 60 * 24))--天
	left = leftTime - day * 60 * 60 * 24

	local hour = math.floor(left / (60 * 60))--时
	left = left - hour * 60 * 60

	local minute = math.floor(left / 60)--分
	left = left - minute * 60 --秒
	local timeStr

	if day == 0 and hour == 0 and minute == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC9,left)
	elseif day == 0 and hour == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC10, minute,left)
	elseif day == 0 then
		timeStr = string.format(res.str.RICH_RANK_DESC11, hour,minute,left)
	else
		timeStr = string.format(res.str.RICH_RANK_DESC12, day,hour,minute,left)
	end

	return timeStr
end



-------网络数据
--请求奖励信息成功返回
function OpenEvoPalaceView:setGiftInfo( data )
	self.data = conf.OpenActJHSD:getData()

	for i=1,#self.data do
		if data.canBuys[self.data[i].id .. ""] then
			self.data[i]["count"] = data.canBuys[self.data[i].id .. ""]
		end
	end



	--开始倒计时
	self.leftTime = data["lastTime"]
	self.todayTime = data["todayTime"]
	self.timeSchedual = self:schedule(self.timeTick, 1)
	
	self.timeLab:setString(self:getTimeStr(self.leftTime))
	self.zsLab:setString(res.str.RICH_RANK_DESC27)


	self.tableView:reloadData()

end




--------------------------TableVIew

function OpenEvoPalaceView:numberOfCellsInTableView(iTable)
	-- body
	--local size=#self.Data[self.packindex]
	--return 0
    return table.nums(self.data)
end

function OpenEvoPalaceView:scrollViewDidScroll(view)

   -- print("scrollViewDidScroll")
end

function OpenEvoPalaceView:scrollViewDidZoom(view)
	
   -- print("scrollViewDidZoom")
end

function OpenEvoPalaceView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end


function OpenEvoPalaceView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePanel:getContentSize()
    return ccsize.height,ccsize.width
end

function OpenEvoPalaceView:tableCellAtIndex(table, idx)
	
    local strValue = string.format("%d",idx)
    -- print("index "..strValue .." time" ..os.time())
    local cell = table:dequeueCell()
    --local data= self.Data[self.packindex][idx+1]
    if nil == cell then
        cell = cc.TableViewCell:new()
    else
  		--todo
       local item = cell:getChildByName("item")
       item:removeFromParent()
    end

     local item = self:createitem(idx + 1)
     item:setTouchEnabled(false)
     item:setAnchorPoint(0,0)
     item:setPosition(5,0)
     cell:addChild(item)
     item:setName("item")
    
    --设置每条数据的信息

    return cell
end


function OpenEvoPalaceView:inittableView(listView,ccsize)
	-- body
	--print("kaishi ="..os.time())
	if not self.tableView then 
		local posx ,posy = self.listView:getPosition()
		local ccsize =  self.listView:getContentSize() 

		self.tableView = cc.TableView:create(cc.size(ccsize.width,ccsize.height))
	    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	    self.tableView:setPosition(cc.p(posx, posy))
	    self.tableView:setDelegate()
	    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	    self.view:addChild(self.tableView,100)
	
	    self.tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView) ,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --tableView个数
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)           --滚动  
	    self.tableView:registerScriptHandler(handler(self, self.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)				--放大
	    self.tableView:registerScriptHandler(handler(self, self.tableCellTouched),cc.TABLECELL_TOUCHED)						--点击	
	    self.tableView:registerScriptHandler(handler(self, self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)				--xiao	
	    self.tableView:registerScriptHandler(handler(self, self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)               --添加
	end 
	--print("end ="..os.time())
	self.tableView:reloadData()
end








return OpenEvoPalaceView

