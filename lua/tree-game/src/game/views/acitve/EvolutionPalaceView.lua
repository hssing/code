--
-- Author: Your Name
-- Date: 2015-08-26 21:23:35
--
local  EvolutionPalaceView = class("EvolutionPalaceView", base.BaseView)


function EvolutionPalaceView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()


	self.headerPanel = self.view:getChildByName("Panel_1")

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
	local  Text_5 = self.clonePanel:getChildByName("Text_31")--可购买次数
	Text_5:setString(res.str.RICH_RANK_DESC19)

	local Text_31 = self.clonePanel:getChildByName("Text_1")--现价
	Text_31:setString(res.str.RICH_RANK_DESC20)

	local originLabFont = self.clonePanel:getChildByName("Text_1_0")--原价
	originLabFont:setString(res.str.ACT2_PALACE_DESC1)


	
	proxy.RichRank:reqJHSDInfo()
	--self:setGiftInfo()
	
end



---创建每个充值奖励
function EvolutionPalaceView:createitem(idx)
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

	----蛋疼的对齐
	local x = giftName:getPositionX() + giftName:getContentSize().width + 60
	local leftDescLab = itemPanel:getChildByName("Text_31")
	leftDescLab:setPosition(x, leftDescLab:getPositionY())
	x = leftDescLab:getPositionX() + leftDescLab:getContentSize().width - 60
	leftTimeLab:setPosition(x, leftTimeLab:getPositionY())
	x = leftTimeLab:getPositionX() + leftTimeLab:getContentSize().width
	local kuohao = itemPanel:getChildByName("Text_3")
	kuohao:setPosition(x, kuohao:getPositionY())

	--现价价格
	local priceLab  = itemPanel:getChildByName("Text_2")
	priceLab:setString(self.data[idx]["price"])
	--原价
	local originLab = itemPanel:getChildByName("Text_2_0")
	originLab:setString(self.data[idx]["original_price"])


--是否显示 原价
	if self.data[idx]["flag"] == 1 then
		originLab:setVisible(true)
		itemPanel:getChildByName("Text_1_0"):setVisible(true)
		itemPanel:getChildByName("Image_4"):setVisible(true)
		itemPanel:getChildByName("Image_1_0"):setVisible(true)
	else
		originLab:setVisible(false)
		itemPanel:getChildByName("Text_1_0"):setVisible(false)
		itemPanel:getChildByName("Image_4"):setVisible(false)
		itemPanel:getChildByName("Image_1_0"):setVisible(false)
	end

	--
	-- local originLabFont = itemPanel:getChildByName("Text_1_0")
	-- local nowLab = itemPanel:getChildByName("Text_1")
	-- originLabFont:setString(res.str.ACT2_PALACE_DESC1)
	-- nowLab:setString(res.str.ACT2_PALACE_DESC2)



	return itemPanel
end


--购买
function EvolutionPalaceView:onBtnGetClicked( send,eventType )
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
		proxy.RichRank:reqJHSDBuy(send.buyId,1)
	end
end

--购买成功
function EvolutionPalaceView:buySucc( data )
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
function EvolutionPalaceView:openItem( send,eventType  )
	-- body
	if eventType == ccui.TouchEventType.ended then

		local data = {}
			data.mId = send.mid
		local itype=conf.Item:getType(data.mId)
		if itype ==  pack_type.PRO then
			G_openItem(data.mId)
		elseif itype  == pack_type.EQUIPMENT then 
			G_OpenEquip(data,true)
		elseif itype  == pack_type.MATERIAL then 
			--保存界面跳转信息
			local data2 = {}
			data2.Evolution = true
			data2.selectedPage = 1
			cache.Player:saveMaterialJumpData(data2)

			G_openItem(data.mId)
		elseif itype == pack_type.RUNE then 
			G_openItem(data.mId)
		else	
			G_OpenCard(data,true)
		end

	end
end


-----活动倒计时
function EvolutionPalaceView:timeTick( )
	self.leftTime = self.leftTime - 1
	self.todayTime = self.todayTime - 1
	local timeStr = self:getTimeStr(self.leftTime)
	if self.leftTime <= 0 then
		self:stopAllActions()
		timeStr = res.str.RICH_RANK_DESC37
		G_mainView()
	end
	if self.todayTime <= 0 then
		self:stopAllActions()
		proxy.RichRank:reqJHSDInfo()
	end

	--如果是从活动进入
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		view:updateData(timeStr)
	end

end


function EvolutionPalaceView:getTimeStr( leftTime )
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
function EvolutionPalaceView:setGiftInfo( data )
	self.data = conf.Palace:getData()

	for i=1,#self.data do
		if data.canBuys[self.data[i].id .. ""] then
			self.data[i]["count"] = data.canBuys[self.data[i].id .. ""]
		end
	end



	--开始倒计时
	self.leftTime = data["lastTime"]
	self.todayTime = data["todayTime"]
	self.timeSchedual = self:schedule(self.timeTick, 1)
	local view = mgr.ViewMgr:get(_viewname.RANKENTY)
	if view then
		view:updateData(self:getTimeStr(self.leftTime),res.str.ACT2_PALACE_DESC3)
	end


	self.tableView:reloadData()

end




--------------------------TableVIew

function EvolutionPalaceView:numberOfCellsInTableView(iTable)
	-- body
	--local size=#self.Data[self.packindex]
	--return 0
    return table.nums(self.data)
end

function EvolutionPalaceView:scrollViewDidScroll(view)

   -- print("scrollViewDidScroll")
end

function EvolutionPalaceView:scrollViewDidZoom(view)
	
   -- print("scrollViewDidZoom")
end

function EvolutionPalaceView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end


function EvolutionPalaceView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePanel:getContentSize()
    return ccsize.height,ccsize.width
end

function EvolutionPalaceView:tableCellAtIndex(table, idx)
	
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


function EvolutionPalaceView:inittableView(listView,ccsize)
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








return EvolutionPalaceView