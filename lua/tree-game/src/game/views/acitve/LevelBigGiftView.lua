--
-- Author: Your Name
-- Date: 2015-08-01 00:15:52
--
local LevelBigGiftView = class("LevelBigGiftView", base.BaseView)


function LevelBigGiftView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.middlePanel = self.view:getChildByName("Panel_middle")
	--self.timeTickLb = self.middlePanel:getChildByName("Text_timeTick")
	self.LvLabel = self.middlePanel:getChildByName("Text_lv")
	self.listView = self.view:getChildByName("ListView")

	self.clonePanel = self.view:getChildByName("Item_Panel")
	self.cloneItem = self.view:getChildByName("item")

	self.data = {}
	self:inittableView()

	--self:createitem()------初始化显示

	----角色当前等级
	local level = cache.Player:getLevel()
	self.middlePanel:getChildByName("Text_lv"):setString(level.."")
	self.nowTime = 1

	self.middlePanel:getChildByName("Text_1"):setString(res.str.ACTIVE_TEXT32)
	self.middlePanel:getChildByName("Text_2"):setString(res.str.ACTIVE_TEXT33)


	----请求礼包信息
    proxy.LevelGift:reqGiftInfo()

end



function LevelBigGiftView:decreaseRedPointNum()
	-- body
	local view = mgr.ViewMgr:get(_viewname.ACTIVITY)
	if view then
		view:setRedPoint()
	end
end

function LevelBigGiftView:setData(data)
	-- body
	--self.listView:removeAllItems(
	self.data = conf.bigGift:getData()
	local awards = data["awards"]
	 self.currLV = cache.Player:getLevel()
	for i=1,table.nums(self.data) do
		local lv = self.data[i]["level"]
		if awards[lv..""] and awards[lv..""] == 1 then--可领取
			self.data[i]["canGet"] = 1

		elseif awards[lv..""] == nil and self.data[i]["level"] <= self.currLV  then
			self.data[i]["canGet"] = 3--已领取

		else
			self.data[i]["canGet"] = 2--不能领取
		end
	end

	----排序
	for i=1,table.nums(self.data) - 1 do
		for j=i+1,table.nums(self.data) do
			if self.data[i]["canGet"] > self.data[j]["canGet"] then
				local tmp = self.data[i]
				self.data[i] = self.data[j]
				self.data[j] = tmp

			elseif self.data[i]["canGet"] == self.data[j]["canGet"] and self.data[i]["canGet"] == 3 then
				if self.data[i]["level"] > self.data[j]["level"] then
					local tmp = self.data[i]
					self.data[i] = self.data[j]
					self.data[j] = tmp
				end
			end

		end
	end
	




	self.tableView:reloadData()

end


------------创建显示条目
function LevelBigGiftView:createitem( idx )
	-- body
		local panel = self.clonePanel:clone()
		local x = 0
		local gifts = self.data[idx]["gifts"]

		for j=1,#gifts do
			local item = self.cloneItem:clone()
			item:setSwallowTouches(false)
			panel:addChild(item)

			if #gifts >= 3 then
				--todo
				item:setPosition(20+item:getContentSize().width*x + x*20,10)
			elseif #gifts <= 2 then
					--todo
				item:setPosition(20+item:getContentSize().width*x + x*20,10)
			end

			local iconFrame = item:getChildByName("btn_goods")
			local iconImg = item:getChildByName("img_goods")
			local textLb = item:getChildByName("text_goods")

			--iconFrame:setEnabled(false)

			--每个礼品的数据
			local mid = gifts[j][1]
			local num = gifts[j][2]
			local iconFrameSrc = conf.bigGift:getFrameIcon(mid)

			local iconImgSrc = conf.bigGift:getIcon(mid)
			local textLbName = conf.bigGift:getName(mid)
			local textColor = conf.bigGift:getTextColor(mid)

			iconFrame:loadTextureNormal(iconFrameSrc)
			iconImg:loadTexture(iconImgSrc)
			textLb:setString(textLbName .. "x" .. num)
			textLb:setColor(textColor)

			iconFrame:setTag(mid)
			iconFrame:addTouchEventListener(handler(self,self.openItem))

			x = x+1
		end

		--每个礼包的数据
		--local countLeftLb = panel:getChildByName("Text_countLeft")
		local limitedLV =  panel:getChildByName("Text_limitedLv")
		local btnGet =  panel:getChildByName("Button_get")

		local totalNum = self.data[idx]["count"]
		local levelLimit = self.data[idx]["level"]
		--countLeftLb:setString(totalNum .. "/" .. totalNum)
		--limitedLV:setString("等级到达" .. levelLimit)
		limitedLV:setString(string.format(res.str.HSUI_DESC11, levelLimit))
		

		if self.data[idx]["canGet"] == 3 then
			--todo
			btnGet:setBright(false)
			btnGet:setEnabled(false)
			--btnGet:setTitleText("已领取")
			btnGet:getChildByName("Text_title"):setString(res.str.HSUI_DESC2)
		elseif self.data[idx]["canGet"] == 2 then
			btnGet:setBright(false)
			btnGet:setEnabled(false)
			btnGet:getChildByName("Text_title"):setString(res.str.HSUI_DESC1)
		elseif self.data[idx]["canGet"] == 1 then
			btnGet:setBright(true)
			btnGet:setEnabled(true)
			btnGet:getChildByName("Text_title"):setString(res.str.HSUI_DESC1)
		end

		local vipIcon = btnGet:getChildByName("Image_vipIcon")
		------是否显示vip图标
		if self.data[idx]["vip_icon"] then
			local vipLv = self.data[idx]["vip_icon"] - 100
			vipIcon:loadTexture(res.icon.GIFT_VIP["V"..vipLv])
		else
			vipIcon:setVisible(false)
		end

		btnGet:setTag(idx+100)
		btnGet:addTouchEventListener(handler(self,self.btnGetClickUpCallback))
		
		--self.listView:pushBackCustomItem(panel)
		return panel
end



function LevelBigGiftView:timeTick( dt )
	-- body
	self.nowTime = self.nowTime + 1

	self.timeTickLb:setString("0天0小时0分".. self.nowTime.."秒")

end


function LevelBigGiftView:openItem( send,eventType  )
	-- body
	if eventType == ccui.TouchEventType.ended then

		local data = {}
			data.mId = send:getTag()
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

--[[
 ._length: 3
 .amount: 1
 .mId: 112064001
 .index: 200009
--]]
function LevelBigGiftView:getAwardSucc( data )
	-- body

	--data.level = 40
	local items = {}
	local  index = 0
	for i=1,table.nums(self.data) do
		if self.data[i]["level"] == data.level then
			index = i
			break
		end
	end

	if index <= 0 then
		--todo
		print("=========index error===========")
		return
	end

	local gifts = self.data[index]["gifts"]
	for i=1,#gifts do
		local item = {}
		item.mId =  gifts[i][1]
		item.amount = gifts[i][2]
		item.index = i
		items[#items + 1] = item
	end

	local view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		if view then
			view:setData(items,true,true)
			view:setButtonVisible(false)
			view:setSureBtnTile(res.str.HSUI_DESC12)
		end


		---更新table显示
	local cell = self.tableView:cellAtIndex(index - 1)
	local widget = cell:getChildByName("item")
	local btn = widget:getChildByName("Button_get")
	btn:setEnabled(false)
	btn:setBright(false)
	btn:getChildByName("Text_title"):setString(res.str.HSUI_DESC2)

	----标记为已领取
	self.data[index]["canGet"] = 3
	----移动到最后
	local tmp = self.data[index]
	table.remove(self.data,index)
	table.insert(self.data,tmp)
	
	self.tableView:reloadData()

		-------红点数目减少
		--self:decreaseRedPointNum()

		--proxy.LevelGift:reqGiftInfo()
	
end



function LevelBigGiftView:btnGetClickUpCallback( sender,eventType  )
	-- body
	if eventType == ccui.TouchEventType.ended then
		--todo

		local index = sender:getTag() - 100
		 local lv = self.data[index]["level"]
		if  self.currLV < lv then
			G_TipsOfstr(res.str.LEVELGIFT_TIP1)
			return
		end
		print("lv,lv",lv)
		proxy.LevelGift:reqGetAward(lv)

	end
end


--------------------------TableVIew

function LevelBigGiftView:numberOfCellsInTableView(iTable)
	-- body
	--local size=#self.Data[self.packindex]
    return table.nums(self.data)
end

function LevelBigGiftView:scrollViewDidScroll(view)

   -- print("scrollViewDidScroll")
end

function LevelBigGiftView:scrollViewDidZoom(view)
	
   -- print("scrollViewDidZoom")
end

function LevelBigGiftView:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end


function LevelBigGiftView:cellSizeForTable(table,idx) 
	local ccsize = self.clonePanel:getContentSize()
    return ccsize.height,ccsize.width
end

function LevelBigGiftView:tableCellAtIndex(table, idx)
	
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


function LevelBigGiftView:inittableView(listView,ccsize)
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


return LevelBigGiftView